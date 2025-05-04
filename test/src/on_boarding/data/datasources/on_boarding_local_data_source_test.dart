import 'package:education_app/core/errors/exceptions.dart';
import 'package:education_app/src/on_boarding/data/datasources/on_boarding_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late MockSharedPreferences prefs;
  late OnBoardingLocalDataSource onBoardingLocalDataSource;

  setUp(() {
    prefs = MockSharedPreferences();
    onBoardingLocalDataSource = OnBoardingLocalDataSourceImpl(prefs);
  });

  group('cacheFirstTimer', () {
    test('should call [SharedPreferences] to cache the data', () async {
      when(() => prefs.setBool(any(), any())).thenAnswer((_) async => true);

      await onBoardingLocalDataSource.cacheFirstTimer();

      verify(() => prefs.setBool(kFirstTimerKey, false)).called(1);
      verifyNoMoreInteractions(prefs);
    });

    test(
      'should throw a [CacheException] when there is an error caching the data',
      () async {
        when(() => prefs.setBool(any(), any())).thenThrow(Exception());

        final methodCall = onBoardingLocalDataSource.cacheFirstTimer;

        expect(methodCall, throwsA(isA<CacheException>()));

        verify(() => prefs.setBool(kFirstTimerKey, false)).called(1);
        verifyNoMoreInteractions(prefs);
      },
    );
  });

  group('checkIfUserIsFirstTimer', () {
    test(
      'should call [SharedPreferences] to check if the user is first timer and '
      'return the right value from storage when data exists',
      () async {
        when(() => prefs.getBool(any())).thenReturn(false);

        final result =
            await onBoardingLocalDataSource.checkIfUserIsFirstTimer();

        expect(result, false);

        verify(() => prefs.getBool(kFirstTimerKey)).called(1);
        verifyNoMoreInteractions(prefs);
      },
    );

    test('should return the true if there is no data in storage', () async {
      when(() => prefs.getBool(any())).thenReturn(null);

      final result = await onBoardingLocalDataSource.checkIfUserIsFirstTimer();

      expect(result, true);

      verify(() => prefs.getBool(kFirstTimerKey)).called(1);
      verifyNoMoreInteractions(prefs);
    });

    test('should throw a [CacheException] when there is an error '
        'retrieving the data', () async {
      when(() => prefs.getBool(any())).thenThrow(Exception());

      final methodCall = onBoardingLocalDataSource.checkIfUserIsFirstTimer;

      expect(methodCall, throwsA(isA<CacheException>()));

      verify(() => prefs.getBool(kFirstTimerKey)).called(1);
      verifyNoMoreInteractions(prefs);
    });
  });
}
