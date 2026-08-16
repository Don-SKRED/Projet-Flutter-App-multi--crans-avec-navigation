import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multi_screen_app_with_navigation/main.dart';
import 'package:multi_screen_app_with_navigation/features/film/domain/film_model.dart';
import 'package:multi_screen_app_with_navigation/features/film/presentation/widget/card_film_widget.dart';
import 'package:multi_screen_app_with_navigation/features/person/domain/person_model.dart';
import 'package:multi_screen_app_with_navigation/features/person/presentation/widgets/card_person_widget.dart';
import 'package:multi_screen_app_with_navigation/shared/widgets/search_result_section.dart';

void main() {
  // Configurer le mock pour path_provider
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    const MethodChannel channel = MethodChannel(
      'plugins.flutter.io/path_provider',
    );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          if (methodCall.method == 'getApplicationDocumentsDirectory') {
            return '.'; // Retourne le répertoire courant pour les tests
          }
          return null;
        });
  });

  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the home screen is displayed by checking for the AppBar title.
    expect(find.text('Film page'), findsOneWidget);
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
        poster: 'inception.jpg',
      );

      // Test sur la taille d'écran par défaut (Tablette)
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: CardFilmWidget(film: film)),
        ),
      );

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
