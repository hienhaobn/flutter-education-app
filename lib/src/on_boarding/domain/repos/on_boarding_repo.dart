import 'package:education_app/core/utils/typedefs.dart';

abstract class OnBoardingRepo {
  const OnBoardingRepo();

  // check if user is first timer else redirect to login screen
  ResultFuture<void> cacheFirstTimer();

  ResultFuture<bool> checkIfUserIsFirstTimer();
}
