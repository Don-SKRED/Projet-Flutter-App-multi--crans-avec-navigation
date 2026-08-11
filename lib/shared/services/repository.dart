import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

abstract class Repository<T> {
  String get filename;
  String get assetPath;

  T fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson(T item);

  Future<File> getLocalfile() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$filename');
    return file;
  }

  Future<File> initFile() async {
    final file = await getLocalfile();

    if (!await file.exists()) {
      //rootBundle permet de lire des fichiers statiques(assets) directement intégrés et empaquetés à l'interieur de l'application
      final initialData = await rootBundle.loadString(assetPath);
      await file.writeAsString(initialData);
    }
    return file;
  }

  Future<List<T>> readFile() async {
    final file = await initFile();
    String jsonString = await file.readAsString();
    List jsonList = jsonDecode(jsonString);

    return jsonList.map((json) => fromJson(json)).toList();
  }

  Future<T?> findById(int id) async {
    final list = await readFile();

    for (var item in list) {
      if ((item as dynamic).id == id) {
        return item;
      }
    }
    return null;
  }

  Future<void> add(T item) async {
    List<T> items = await readFile();
    final file = await getLocalfile();
    items.add(item);
    file.writeAsString(jsonEncode(items.map((item) => toJson(item)).toList()));
  }

  Future<void> update(int id, T updatedItem) async {
    List<T> items = await readFile();
    final file = await getLocalfile();
    final index = items.indexWhere((item) => (item as dynamic).id == id);
    if (index != -1) {
      items[index] = updatedItem;
      file.writeAsString(
        jsonEncode(items.map((item) => toJson(item)).toList()),
      );
    }
  }

  Future<int> generateNewId() async {
    final list = await readFile();
    if (list.isEmpty) return 1;

    // Récupère l'ID maximum présent dans la liste
    int maxId = 0;
    for (var item in list) {
      final itemId = (item as dynamic).id;
      if (itemId > maxId) {
        maxId = itemId;
      }
    }
    return maxId + 1;
  }
}
