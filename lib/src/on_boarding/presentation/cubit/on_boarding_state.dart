part of 'on_boarding_cubit.dart';

sealed class OnBoardingState extends Equatable {
  const OnBoardingState();

  @override
  List<Object> get props => [];
}

final class OnBoardingInitial extends OnBoardingState {
  @override
  List<Object> get props => [];
}

class CachingFirstTimer extends OnBoardingState {
  const CachingFirstTimer();
}

class CheckingIfUserFirstTimer extends OnBoardingState {
  const CheckingIfUserFirstTimer();
}

class UserCached extends OnBoardingState {
  const UserCached();
}

class OnBoardingStatus extends OnBoardingState {
  const OnBoardingStatus({required this.isFirstTimer});

  final bool isFirstTimer;

  @override
  List<bool> get props => [isFirstTimer];
}

class OnBoardingError extends OnBoardingState {
  const OnBoardingError({required this.message});

  final String message;

  @override
  List<String> get props => [message];
}
