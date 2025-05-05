import 'dart:convert';

import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/auth/data/models/user_model.dart';
import 'package:education_app/src/auth/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tLocalUserModel = LocalUserModel.empty();

  test(
    'should be a subclass of [LocalUser] entity',
    () => expect(tLocalUserModel, isA<LocalUser>()),
  );

  final tMap = jsonDecode(fixture('user.json')) as DataMap;

  group('fromMap', () {
    test('should return a valid [LocalUserModel] from the map', () {
      // act
      final result = LocalUserModel.fromMap(tMap);

      // assert

      expect(result, isA<LocalUserModel>());

      expect(result, equals(tLocalUserModel));
    });

    test('should throw an [Error] when the map is invalid', () {
      final map = DataMap.from(tMap)..remove('uid');

      const call = LocalUserModel.fromMap;

      expect(() => call(map), throwsA(isA<Error>()));
    });
  });

  group('toMap', () {
    test('should return a valid [DataMap] from the [LocalUserModel]', () {
      final result = tLocalUserModel.toMap();

      expect(result, equals(tMap));
    });
  });

  group('copyWith', () {
    test('should return a new [LocalUserModel] with the updated values', () {
      final result = tLocalUserModel.copyWith(uid: '123');

      expect(result, equals(tLocalUserModel.copyWith(uid: '123')));
    });
  });
}
