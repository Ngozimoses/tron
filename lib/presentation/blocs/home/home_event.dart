import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// ✅ RENAMED: HomeLoaded → LoadHome (action verb)
class LoadHome extends HomeEvent {}

class RefreshHome extends HomeEvent {}

class NavigateToSettings extends HomeEvent {}

class LogoutRequested extends HomeEvent {}