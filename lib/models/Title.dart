// ignore_for_file: file_names

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyTitle {
  int? id;
  String? shortName;
  String? name;

  MyTitle({this.id, this.shortName, this.name});

  factory MyTitle.fromJson(Map<String, dynamic> json) {
    return MyTitle(
        id: json['ID'], shortName: json['ShortName'], name: json['Name']);
  }

  factory MyTitle.fromJsonFile(Map<String, dynamic> json) {
    return MyTitle(
        id: '${json['id']}' == '' ? -2 : int.parse('${json['id']}'),
        name: json['name']);
  }

  @override
  String toString() => 'MyTitle(id: $id, shortName: $shortName, name: $name)';
}

class TitleDao {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  insertTitle(String json) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('title', json);
  }

  Future<List<MyTitle>> getTitle() async {
    final SharedPreferences prefs = await _prefs;
    List<MyTitle> listResult = [];

    var json = prefs.getString('title');
    final jsonResult = jsonDecode(json!);

    var listRes = jsonResult['title'] as List;

    for (int i = 0; i < listRes.length; i++) {
      Map<String, dynamic> res = listRes[i];
      MyTitle formResponse = MyTitle.fromJsonFile(res);
      listResult.add(formResponse);
    }
    return listResult;
  }

  Future<List<String>> getTitleLabel() async {
    final SharedPreferences prefs = await _prefs;
    List<String> listResult = [];

    var json = prefs.getString('title');
    final jsonResult = jsonDecode(json!);

    var listRes = jsonResult['title'] as List;

    for (int i = 0; i < listRes.length; i++) {
      Map<String, dynamic> res = listRes[i];
      MyTitle formResponse = MyTitle.fromJsonFile(res);
      listResult.add(formResponse.name ?? '');
    }
    return listResult;
  }

  Future<String> getTitleLabelById(int id) async {
    try {
      final SharedPreferences prefs = await _prefs;

      var json = prefs.getString('title');
      final jsonResult = jsonDecode(json!);
      if (kDebugMode) {
        print('titletitletitletitle $id');
      }

      var listRes = jsonResult['title'] as List;

      for (int i = 0; i < listRes.length; i++) {
        Map<String, dynamic> res = listRes[i];
        MyTitle formResponse = MyTitle.fromJsonFile(res);
        if ('${formResponse.id}' == '$id') {
          if (kDebugMode) {
            print(formResponse.name ?? '');
          }
          return formResponse.name ?? '';
        }
      }
      return '';
    } catch (ex) {
      return '';
    }
  }
}
