import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class PreferenceService {
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
    return value["dark_mode"];
  }

  Future save(bool value) async {
    final file = await getLocalfile();
    final json = jsonEncode({"dark_mode": value});
    await file.writeAsString(json);
  }
}
