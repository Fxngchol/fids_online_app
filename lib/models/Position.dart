// ignore_for_file: file_names

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Position {
  int? id;
  String? name;

  Position({this.id, this.name});

  factory Position.fromJson(Map<String, dynamic> json) {
    return Position(id: json['ID'], name: json['Name']);
  }

  factory Position.fromJsonFile(Map<String, dynamic> json) {
    return Position(id: json['id'], name: json['name']);
  }
}

class PositionDao {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  insertPosition(String json) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('position', json);
  }

  Future<List<Position>> getPosition() async {
    final SharedPreferences prefs = await _prefs;
    List<Position> listResult = [];
    var json = prefs.getString('position');

    final jsonResult = jsonDecode(json!);
    var listCaseCategory = jsonResult['position'] as List;

    for (int i = 0; i < listCaseCategory.length; i++) {
      Map<String, dynamic> res = listCaseCategory[i];
      Position formResponse = Position.fromJsonFile(res);

      listResult.add(formResponse);
    }
    return listResult;
  }

  Future<List<String>> getPositionLabel() async {
    final SharedPreferences prefs = await _prefs;
    List<String> listResult = [];
    var json = prefs.getString('position');

    final jsonResult = jsonDecode(json!);
    var listCaseCategory = jsonResult['position'] as List;

    for (int i = 0; i < listCaseCategory.length; i++) {
      Map<String, dynamic> res = listCaseCategory[i];
      Position formResponse = Position.fromJsonFile(res);

      listResult.add(formResponse.name ?? '');
    }
    return listResult;
  }
}
