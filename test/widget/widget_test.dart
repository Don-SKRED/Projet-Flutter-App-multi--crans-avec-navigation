import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multi_screen_app_with_navigation/main.dart';
import 'package:multi_screen_app_with_navigation/features/film/data/model/film_model.dart';
import 'package:multi_screen_app_with_navigation/features/film/presentation/widget/card_film_widget.dart';
import 'package:multi_screen_app_with_navigation/core/widgets/search_result_section.dart';

// ---------------------------------------------------------------------------
// Mock HttpClient pour CachedNetworkImage dans les tests widgets
// ---------------------------------------------------------------------------
final kTransparentImage = Uint8List.fromList([
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52,
  0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4,
  0x89, 0x00, 0x00, 0x00, 0x0A, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
  0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE,
  0x42, 0x60, 0x82,
]);

class MockHttpClient extends Fake implements HttpClient {
  @override
  Future<HttpClientRequest> getUrl(Uri url) async => MockHttpClientRequest();
}

class MockHttpClientRequest extends Fake implements HttpClientRequest {
  @override
  final HttpHeaders headers = MockHttpHeaders();
  @override
  Future<HttpClientResponse> close() async => MockHttpClientResponse();
}

class MockHttpHeaders extends Fake implements HttpHeaders {
  @override
  void set(String name, Object value, {bool preserveHeaderCase = false}) {}
}

class MockHttpClientResponse extends Fake implements HttpClientResponse {
  @override
  int get statusCode => 200;
  @override
  int get contentLength => kTransparentImage.length;
  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;
  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int>)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return Stream<List<int>>.fromIterable([kTransparentImage]).listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }
}

class TestHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) => MockHttpClient();
}

// ---------------------------------------------------------------------------
// Tests Widgets
// ---------------------------------------------------------------------------
void main() {
  late Directory tempDir;

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    HttpOverrides.global = TestHttpOverrides();

    tempDir = Directory.systemTemp.createTempSync('widget_test_');

    const MethodChannel channel = MethodChannel(
      'plugins.flutter.io/path_provider',
    );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          return tempDir.path;
        });
  });

  tearDownAll(() {
    HttpOverrides.global = null;
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MyApp(),
      ),
    );
    await tester.pump();

    // L'application se monte proprement avec son MaterialApp.router
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets(
    'CardFilmWidget displays film title and handles responsive sizing',
    (WidgetTester tester) async {
      const film = Film(
        1,
        title: 'Inception',
        release: 2010,
        synopsis: 'Dream heist',
        genre: 'Sci-Fi',
        poster: 'https://example.com/inception.jpg',
      );

      // Test sur la taille d'écran par défaut (Tablette)
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: CardFilmWidget(film: film)),
        ),
      );
      await tester.pump();

      expect(find.text('Inception'), findsOneWidget);

      final cardFinder = find.byType(CardFilmWidget);
      expect(cardFinder, findsOneWidget);

      // Vérifie les dimensions appliquées sur tablette (largeur 200, hauteur 350)
      final SizedBox sizedBox = tester.widget(
        find.descendant(of: cardFinder, matching: find.byType(SizedBox).first),
      );
      expect(sizedBox.width, equals(200));
      expect(sizedBox.height, equals(350));
    },
  );

  testWidgets(
    'SearchResultSection renders title, items list, and Tout afficher button when overflowing',
    (WidgetTester tester) async {
      final List<String> items = [
        'Item 1',
        'Item 2',
        'Item 3',
        'Item 4',
        'Item 5',
      ];
      bool onVoirToutCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchResultSection<String>(
              titre: 'Résultats',
              items: items,
              limiteAffichee: 3,
              itemBuilder: (context, item) => ListTile(title: Text(item)),
              onVoirTout: () {
                onVoirToutCalled = true;
              },
            ),
          ),
        ),
      );

      // Doit afficher le titre avec le décompte total (5)
      expect(find.text('Résultats(5)'), findsOneWidget);

      // Sous la limite de 3, seuls 3 éléments doivent être affichés
      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);
      expect(find.text('Item 3'), findsOneWidget);
      expect(find.text('Item 4'), findsNothing);
      expect(find.text('Item 5'), findsNothing);

      // Le bouton "Tout afficher" doit être visible puisque items.length > limiteAffichee
      final buttonFinder = find.text('Tout afficher');
      expect(buttonFinder, findsOneWidget);

      // Cliquer sur le bouton "Tout afficher"
      await tester.tap(buttonFinder);
      await tester.pump();

      expect(onVoirToutCalled, isTrue);
    },
  );
}
