import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/failures.dart';
import 'package:education_app/src/on_boarding/domain/usecases/cache_first_timer.dart';
import 'package:education_app/src/on_boarding/domain/usecases/check_if_user_is_first_timer.dart';
import 'package:education_app/src/on_boarding/presentation/cubit/on_boarding_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCacheFirstTimer extends Mock implements CacheFirstTimer {}

class MockCheckIfUserIsFirstTimer extends Mock
    implements CheckIfUserIsFirstTimer {}

void main() {
  late CacheFirstTimer cacheFirstTimer;
  late CheckIfUserIsFirstTimer checkIfUserIsFirstTimer;
  late OnBoardingCubit cubit;

  setUp(() {
    cacheFirstTimer = MockCacheFirstTimer();
    checkIfUserIsFirstTimer = MockCheckIfUserIsFirstTimer();
    cubit = OnBoardingCubit(
      cacheFirstTimer: cacheFirstTimer,
      checkIfUserIsFirstTimer: checkIfUserIsFirstTimer,
    );
  });

  final tFailure = CacheFailure(
    message: 'Insufficient Permissions',
    statusCode: 4032,
  );

  test('initial state should be [OnBoardingInitial]', () {
    expect(cubit.state, isA<OnBoardingInitial>());
  });

  group('cache first timer', () {
    blocTest<OnBoardingCubit, OnBoardingState>(
      'should emit [CachingFirstTimer] when successful',
      build: () {
        when(
          () => cacheFirstTimer(),
        ).thenAnswer((_) async => const Right(null));

        return cubit;
      },
      act: (cubit) => cubit.cacheFirstTimer(),
      expect: () => const [CachingFirstTimer(), UserCached()],
      verify: (_) {
        verify(() => cacheFirstTimer()).called(1);
        verifyNoMoreInteractions(cacheFirstTimer);
      },
    );

    blocTest<OnBoardingCubit, OnBoardingState>(
      'should emit [CachingFirstTimer, OnBoardingError,] when unsuccessful',
      build: () {
        when(() => cacheFirstTimer()).thenAnswer((_) async => Left(tFailure));

        return cubit;
      },
      act: (cubit) => cubit.cacheFirstTimer(),
      expect:
          () => [
            const CachingFirstTimer(),
            OnBoardingError(message: tFailure.message),
          ],
      verify: (_) {
        verify(() => cacheFirstTimer()).called(1);
        verifyNoMoreInteractions(cacheFirstTimer);
      },
    );
  });

  group('checkIfUserIsFirstTimer', () {
    blocTest<OnBoardingCubit, OnBoardingState>(
      'should emit [CheckingIfUserIsFirstTimer, OnBoardingStatus] '
      'when successful',
      build: () {
        when(
          () => checkIfUserIsFirstTimer(),
        ).thenAnswer((_) async => const Right(false));

        return cubit;
      },
      act: (cubit) => cubit.checkIfUserIsFirstTimer(),
      expect:
          () => const [
            CheckingIfUserFirstTimer(),
            OnBoardingStatus(isFirstTimer: false),
          ],
      verify: (_) {
        verify(() => checkIfUserIsFirstTimer()).called(1);
        verifyNoMoreInteractions(checkIfUserIsFirstTimer);
      },
    );

    blocTest<OnBoardingCubit, OnBoardingState>(
      'should emit [CheckingIfUserIsFirstTimer, OnBoardingStatus(true)] '
      'when unsuccessful',
      build: () {
        when(
          () => checkIfUserIsFirstTimer(),
        ).thenAnswer((_) async => Left(tFailure));

        return cubit;
      },
      act: (cubit) => cubit.checkIfUserIsFirstTimer(),
      expect:
          () => const [
            CheckingIfUserFirstTimer(),
            OnBoardingStatus(isFirstTimer: true),
          ],
      verify: (_) {
        verify(() => checkIfUserIsFirstTimer()).called(1);
        verifyNoMoreInteractions(checkIfUserIsFirstTimer);
      },
    );
  });
}
