import 'package:flutter/material.dart';
import 'package:multi_screen_app_with_navigation/routing/routes.dart';
import 'package:multi_screen_app_with_navigation/shared/services/theme_provider.dart';

void main() {
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
      themeMode: ThemeProvider().themeMode, // lequel des deux utiliser

      routerConfig: appRouter,
      title: 'Flutter Demo',
    );
  }
}
