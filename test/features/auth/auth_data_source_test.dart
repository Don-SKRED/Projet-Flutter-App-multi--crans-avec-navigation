// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:dio/dio.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:multi_screen_app_with_navigation/features/auth/data/dataSources/auth_data_source.dart';

// /// Adapter personnalisé pour intercepter et tester les requêtes HTTP émise par Dio.
// class MockHttpClientAdapter implements HttpClientAdapter {
//   RequestOptions? lastOptions;
//   int statusCode = 200;
//   Map<String, dynamic> responseData = {};

//   @override
//   Future<ResponseBody> fetch(
//     RequestOptions options,
//     Stream<Uint8List>? requestStream,
//     Future<void>? cancelFuture,
//   ) async {
//     lastOptions = options;
//     return ResponseBody.fromString(
//       jsonEncode(responseData),
//       statusCode,
//       headers: {
//         Headers.contentTypeHeader: [Headers.jsonContentType],
//       },
//     );
//   }

//   @override
//   void close({bool force = false}) {}
// }

// void main() {
//   late Dio dio;
//   late MockHttpClientAdapter mockAdapter;
//   late RemoteAuthDataSourceImpl dataSource;

//   setUp(() {
//     dio = Dio(BaseOptions(baseUrl: 'https://example.com'));
//     mockAdapter = MockHttpClientAdapter();
//     dio.httpClientAdapter = mockAdapter;
//     dataSource = RemoteAuthDataSourceImpl(dio);
//   });

//   group('RemoteAuthDataSourceImpl', () {
//     test('login fait un appel POST vers /auth/v1/token avec les identifiants', () async {
//       mockAdapter.responseData = {
//         'access_token': 'fake_token',
//         'token_type': 'bearer',
//       };

//       await dataSource.login('test@example.com', 'password123');

//       expect(mockAdapter.lastOptions, isNotNull);
//       expect(mockAdapter.lastOptions!.method, equals('POST'));
//       expect(mockAdapter.lastOptions!.path, equals('/auth/v1/token?grant_type=password'));
//       expect(mockAdapter.lastOptions!.data, equals({
//         'email': 'test@example.com',
//         'password': 'password123',
//       }));
//     });

//     test('register fait un appel POST vers /auth/v1/signup', () async {
//       mockAdapter.responseData = {'id': 'user_123', 'email': 'new@example.com'};

//       await dataSource.register('new@example.com', 'secret123');

//       expect(mockAdapter.lastOptions, isNotNull);
//       expect(mockAdapter.lastOptions!.method, equals('POST'));
//       expect(mockAdapter.lastOptions!.path, equals('/auth/v1/signup'));
//       expect(mockAdapter.lastOptions!.data, equals({
//         'email': 'new@example.com',
//         'password': 'secret123',
//       }));
//     });

//     test('logout fait un appel POST vers /auth/v1/logout', () async {
//       mockAdapter.responseData = {'message': 'Logged out'};

//       await dataSource.logout();

//       expect(mockAdapter.lastOptions, isNotNull);
//       expect(mockAdapter.lastOptions!.method, equals('POST'));
//       expect(mockAdapter.lastOptions!.path, equals('/auth/v1/logout'));
//     });
//   });
// }
