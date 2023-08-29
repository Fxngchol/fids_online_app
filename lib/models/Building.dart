// ignore_for_file: file_names

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Building {
  int? id;
  String? name;

  Building({this.id, this.name});

  factory Building.fromJson(Map<String, dynamic> json) {
    return Building(id: json['ID'], name: json['Name']);
  }

  factory Building.fromJsonFile(Map<String, dynamic> json) {
    return Building(id: json['id'], name: json['name']);
  }

  @override
  String toString() => 'Building(id: $id, name: $name)';
}

class BuildingDao {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  insertBuildingSharedPref(String? json) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('sceneType', json!);
  }

  Future<List<Building>> getBuilding() async {
    final SharedPreferences prefs = await _prefs;
    List<Building> listResult = [];
    var json = prefs.getString('sceneType');

    final jsonResult = jsonDecode(json!);
    var listCaseCategory = jsonResult['sceneType'] as List;

    for (int i = 0; i < listCaseCategory.length; i++) {
      Map<String, dynamic> res = listCaseCategory[i];
      Building formResponse = Building.fromJsonFile(res);

      listResult.add(formResponse);
    }
    return listResult;
  }

  Future<List<String>> getBuildingLabel() async {
    final SharedPreferences prefs = await _prefs;
    List<String> listResult = [];
    var json = prefs.getString('sceneType');

    final jsonResult = jsonDecode(json!);
    var listCaseCategory = jsonResult['sceneType'] as List;

    for (int i = 0; i < listCaseCategory.length; i++) {
      Map<String, dynamic> res = listCaseCategory[i];
      Building formResponse = Building.fromJsonFile(res);

      listResult.add(formResponse.name ?? '');
    }
    return listResult;
  }
}
