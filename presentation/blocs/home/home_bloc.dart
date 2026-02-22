import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/datasources/local/secure_storage_impl.dart';
import '../../../domain/entities/resident.dart';
import 'home_event.dart';
import 'home_state.dart';
import '../../../../data/datasources/remote/estate_remote_datasource.dart';
import '../../../../data/datasources/local/auth_local_datasource.dart';
import '../../../../core/di/injection_container.dart' as di;

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final EstateRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  HomeBloc({required this.remoteDataSource, required this.localDataSource})
      : super(HomeInitial()) {
    on<LoadHome>(_onLoadHome);
    on<RefreshHome>(_onRefreshHome);
    on<LogoutRequested>(_onLogout);
  }

  Future<void> _onLoadHome(LoadHome event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      // In production, get residentId from secure storage
      final residentId = await di.sl<SecureStorageImpl>().getResidentId();

      if (residentId == null) {
        emit(HomeError('Resident ID not found'));
        return;
      }

      // Fetch data with error handling for each call
      late Resident resident;
      late List<dynamic> notices;
      late List<dynamic> maintenance;
      late List<dynamic> visitors;
      late List<dynamic> events; // ✅ New variable for events

      try {
        resident = await remoteDataSource.getResidentProfile(residentId);
      } catch (e) {
        resident = Resident(
          id: residentId,
          name: 'Resident',
          email: '',
          phone: '',
          blockNumber: '',
          unitNumber: '',
        );
      }

      try {
        notices = await remoteDataSource.getEstateNotices();
      } catch (e) {
        notices = [];
      }

      try {
        maintenance = await remoteDataSource.getMaintenanceRequests();
      } catch (e) {
        maintenance = [];
      }

      try {
        visitors = await remoteDataSource.getVisitors();
      } catch (e) {
        visitors = [];
      }

      // ✅ Fetch events with error handling
      try {
        events = await remoteDataSource.getResidentEvents(residentId);
      } catch (e) {
        events = []; // Default to empty list on error
      }

      // Filter pending visitors safely
      final pendingVisitors = visitors.where((v) {
        return v != null && v['status'] == 'pending';
      }).toList();

      // ✅ Emit state with events included
      emit(HomeLoaded(
        resident: resident,
        notices: notices,
        maintenanceRequests: maintenance,
        pendingVisitors: pendingVisitors,
        events: events, // ✅ Pass events to state
      ));

    } catch (e) {
      emit(HomeError('Failed to load home data: ${e.toString()}'));
    }
  }

  Future<void> _onRefreshHome(RefreshHome event, Emitter<HomeState> emit) async {
    add(LoadHome());
  }

  Future<void> _onLogout(LogoutRequested event, Emitter<HomeState> emit) async {
    await di.sl<SecureStorageImpl>().deleteAll();
    // Navigate to identify page would be handled in UI
    emit(HomeInitial());
  }
}