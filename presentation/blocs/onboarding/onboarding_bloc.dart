import 'package:flutter_bloc/flutter_bloc.dart';
import 'onboarding_event.dart';
import 'onboarding_state.dart';
import '../../../../data/datasources/local/auth_local_datasource.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final AuthLocalDataSource localDataSource;
  static const int totalPages = 3;

  OnboardingBloc({required this.localDataSource}) : super(OnboardingInitial()) {
    on<OnboardingStarted>(_onStarted);
    on<OnboardingPageChanged>(_onPageChanged);
    on<OnboardingCompleted>(_onCompleted);
  }

  void _onStarted(OnboardingStarted event, Emitter<OnboardingState> emit) {
    emit(OnboardingInProgress(currentPage: 0, totalPages: totalPages));
  }

  void _onPageChanged(OnboardingPageChanged event, Emitter<OnboardingState> emit) {
    emit(OnboardingInProgress(currentPage: event.pageIndex, totalPages: totalPages));
  }

  Future<void> _onCompleted(OnboardingCompleted event, Emitter<OnboardingState> emit) async {
    await localDataSource.setOnboardingSeen();
    emit(OnboardingComplete());
  }
}