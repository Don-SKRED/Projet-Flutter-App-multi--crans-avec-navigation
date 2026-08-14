import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class ThemeProvider {
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  Future<File> getLocalfile() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/theme_mode.json');
    return file;
  }

  Future<File> initFile() async {
    final file = await getLocalfile();

    if (!await file.exists()) {
      //rootBundle permet de lire des fichiers statiques(assets) directement intégrés et empaquetés à l'interieur de l'application
      final initialData = await rootBundle.loadString(
        "assets/data/theme_mode.json",
      );
      await file.writeAsString(initialData);
    }
    return file;
  }

  Future<bool> readFile() async {
    final file = await initFile();
    String jsonString = await file.readAsString();
    Map<dynamic, dynamic> value = jsonDecode(jsonString);
    _themeMode = value["dark_mode"] as bool ? ThemeMode.dark : ThemeMode.light;
    return value["dark_mode"];
  }

  Future changeMode() async {
    // _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    var actualMode = await readFile();
    final file = await getLocalfile();

    file.writeAsString(actualMode.toString());
    _themeMode = !actualMode ? ThemeMode.dark : ThemeMode.light;
  }
}
