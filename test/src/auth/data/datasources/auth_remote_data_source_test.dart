import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/src/auth/data/datasources/auth_remote_data_source.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseStorage extends Mock implements FirebaseStorage {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockUser extends Mock implements User {
  final String _uid = 'test-uid';

  @override
  String get uid => _uid;
}

class MockUserCredential extends Mock implements UserCredential {
  MockUserCredential([User? user]) : _user = user;

  User? _user;

  @override
  User? get user => _user;

  set user(User? value) {
    if (_user != value) _user = value;
  }
}

void main() {
  late FirebaseAuth authClient;
  late FirebaseFirestore cloudStoreClient;
  late FirebaseStorage dbClient;
  late AuthRemoteDataSourceImpl dataSource;
  late MockUserCredential userCredential;

  setUp(() {
    authClient = MockFirebaseAuth();
    cloudStoreClient = MockFirebaseFirestore();
    dbClient = MockFirebaseStorage();
    final mockUser = MockUser();
    dataSource = AuthRemoteDataSourceImpl(
      authClient: authClient,
      cloudStoreClient: cloudStoreClient,
      dbClient: dbClient,
    );
    userCredential = MockUserCredential(mockUser);
  });

  group('signIn', () {
    test(
      'should complete successfully when call to the server is successful',
      () async {
        when(
          () => authClient.signInWithEmailAndPassword(
            email: any(named: 'email@email.com'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => userCredential);

        when(
          () => authClient.createUserWithEmailAndPassword(
            email: any(named: 'email@email.com'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => userCredential);

        await dataSource.signUp(
          email: 'email@email.com',
          password: 'password',
          fullName: 'fullName',
        );
        // act
        final result = await dataSource.signIn(
          email: 'email@email.com',
          password: 'password',
        );

        // assert
        expect(result, equals('email@email.com'));
      },
    );
  });
}
