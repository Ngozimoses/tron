import 'package:equatable/equatable.dart';
import '../../../../domain/entities/resident.dart';

abstract class HomeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

// ✅ Updated HomeLoaded with events field + null safety
class HomeLoaded extends HomeState {
  final Resident resident;
  final List<dynamic> notices;
  final List<dynamic> maintenanceRequests;
  final List<dynamic> pendingVisitors;
  final List<dynamic> events; // ✅ New field for events

  HomeLoaded({
    required this.resident,
    List<dynamic>? notices,
    List<dynamic>? maintenanceRequests,
    List<dynamic>? pendingVisitors,
    List<dynamic>? events, // ✅ Optional parameter
  })  : notices = notices ?? [],
        maintenanceRequests = maintenanceRequests ?? [],
        pendingVisitors = pendingVisitors ?? [],
        events = events ?? []; // ✅ Default to empty list

  @override
  List<Object?> get props => [
    resident,
    notices,
    maintenanceRequests,
    pendingVisitors,
    events, // ✅ Include in equality check
  ];
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
  @override
  List<Object?> get props => [message];
}