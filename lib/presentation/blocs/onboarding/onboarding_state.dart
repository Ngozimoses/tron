import 'package:equatable/equatable.dart';

abstract class OnboardingState extends Equatable {
  @override
  List<Object?> get props => [];
}

class OnboardingInitial extends OnboardingState {}

class OnboardingInProgress extends OnboardingState {
  final int currentPage;
  final int totalPages;

  OnboardingInProgress({required this.currentPage, required this.totalPages});

  @override
  List<Object?> get props => [currentPage, totalPages];
}

class OnboardingComplete extends OnboardingState {}