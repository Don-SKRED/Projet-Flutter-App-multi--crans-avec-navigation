// import 'package:flutter_test/flutter_test.dart';
// import 'package:multi_screen_app_with_navigation/features/auth/data/dataSources/auth_data_source.dart';
// import 'package:multi_screen_app_with_navigation/features/auth/data/repositories/auth_repository_impl.dart';

// /// Faux DataSource pour valider que le Repository délègue correctement les appels.
// class FakeRemoteAuthDataSource implements RemoteAuthDataSource {
//   String? lastLoginEmail;
//   String? lastLoginPassword;
//   String? lastRegisterEmail;
//   String? lastRegisterPassword;
//   bool logoutCalled = false;

//   @override
//   Future<void> login(String email, String password) async {
//     lastLoginEmail = email;
//     lastLoginPassword = password;
//   }

//   @override
//   Future<void> register(String email, String password) async {
//     lastRegisterEmail = email;
//     lastRegisterPassword = password;
//   }

//   @override
//   Future<void> logout() async {
//     logoutCalled = true;
//   }
// }

// void main() {
//   late FakeRemoteAuthDataSource fakeDataSource;
//   late AuthRepositoryImpl repository;

//   setUp(() {
//     fakeDataSource = FakeRemoteAuthDataSource();
//     repository = AuthRepositoryImpl(fakeDataSource);
//   });

//   group('AuthRepositoryImpl', () {
//     test('login délègue l\'appel au RemoteAuthDataSource', () async {
//       await repository.login('user@test.com', 'pass123');

//       expect(fakeDataSource.lastLoginEmail, equals('user@test.com'));
//       expect(fakeDataSource.lastLoginPassword, equals('pass123'));
//     });

//     test('register délègue l\'appel au RemoteAuthDataSource', () async {
//       await repository.register('newuser@test.com', 'securepass');

//       expect(fakeDataSource.lastRegisterEmail, equals('newuser@test.com'));
//       expect(fakeDataSource.lastRegisterPassword, equals('securepass'));
//     });

//     test('logout délègue l\'appel au RemoteAuthDataSource', () async {
//       await repository.logout();

//       expect(fakeDataSource.logoutCalled, isTrue);
//     });
//   });
// }
