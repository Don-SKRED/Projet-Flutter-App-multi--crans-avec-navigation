import 'package:flutter/material.dart';
import 'package:multi_screen_app_with_navigation/routing/routes.dart';
import 'package:multi_screen_app_with_navigation/shared/utils/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await themeProvider.currentMode(); // chargement AVANT le premier affichage

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   title: 'Flutter Demo',
    //   theme: ThemeData(
    //     colorScheme: .fromSeed(seedColor: Colors.deepPurple),
    //   ),
    //   home: const MyHomePage(title: 'Flutter Demo Home Page'),
    // );
    return ListenableBuilder(
      listenable: themeProvider,
      builder: (context, child) {
        return MaterialApp.router(
          theme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: Colors.deepPurple,
            brightness: Brightness.light,
          ),

          darkTheme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: Colors.deepPurple,
            brightness: Brightness.dark,
          ),
          themeMode: themeProvider.isDarkMode
              ? ThemeMode.dark
              : ThemeMode.light, // lequel des deux utiliser

          routerConfig: appRouter,
          title: 'Flutter Demo',
        );
      },
    );
  }
}
