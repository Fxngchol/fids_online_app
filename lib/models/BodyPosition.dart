// ignore_for_file: file_names

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class BodyPosition {
  int? id;
  String? bodyPosition;

  BodyPosition({this.id, this.bodyPosition});

  factory BodyPosition.fromJson(Map<String, dynamic> json) {
    return BodyPosition(id: json['ID'], bodyPosition: json['BodyPosition']);
  }

  factory BodyPosition.fromJsonFile(Map<String, dynamic> json) {
    return BodyPosition(id: json['id'], bodyPosition: json['BodyPosition']);
  }
}

class BodyPositionDao {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  insertBodyPosition(String? json) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('bodyPosition', json!);
  }

  Future<List<BodyPosition>> getBodyPosition() async {
    final SharedPreferences prefs = await _prefs;
    List<BodyPosition> listResult = [];

    var json = prefs.getString('bodyPosition');
    final jsonResult = jsonDecode(json!);

    var listRes = jsonResult['bodyPosition'] as List;

    for (int i = 0; i < listRes.length; i++) {
      Map<String, dynamic> res = listRes[i];
      BodyPosition formResponse = BodyPosition.fromJsonFile(res);
      listResult.add(formResponse);
    }
    return listResult;
  }

  Future<List<String>> getBodyPositionLabel() async {
    final SharedPreferences prefs = await _prefs;
    List<String> listResult = [];

    var json = prefs.getString('bodyPosition');
    final jsonResult = jsonDecode(json!);

    var listRes = jsonResult['bodyPosition'] as List;

    for (int i = 0; i < listRes.length; i++) {
      Map<String, dynamic> res = listRes[i];
      BodyPosition formResponse = BodyPosition.fromJsonFile(res);
      listResult.add(formResponse.bodyPosition ?? '');
    }
    return listResult;
  }
}
