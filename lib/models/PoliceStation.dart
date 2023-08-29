// ignore_for_file: file_names

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PoliceStation {
  int? id;
  String? name;
  int? provinceId;
  int? amphurId;
  int? tambolId;

  PoliceStation(
      {this.id, this.name, this.provinceId, this.amphurId, this.tambolId});

  factory PoliceStation.fromJson(Map<String, dynamic> json) {
    return PoliceStation(
        id: json['ID'],
        name: json['Name'],
        provinceId: json['ProvinceID'],
        amphurId: json['AmphurID'],
        tambolId: json['TambolID']);
  }

  factory PoliceStation.fromJsonFile(Map<String, dynamic> json) {
    return PoliceStation(
        id: json['id'],
        name: json['name'],
        provinceId: json['ProvinceID'],
        amphurId: json['AmphurID'],
        tambolId: json['TambonID']);
  }
}

class PoliceStationDao {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  insertPoliceStation(String json) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('policeStation', json);
  }

  Future<List<PoliceStation>> getPoliceStation() async {
    final SharedPreferences prefs = await _prefs;
    List<PoliceStation> listResult = [];

    var json = prefs.getString('policeStation');
    final jsonResult = jsonDecode(json!);

    var listAmphur = jsonResult['policeStation'] as List;

    for (int i = 0; i < listAmphur.length; i++) {
      Map<String, dynamic> res = listAmphur[i];
      PoliceStation formResponse = PoliceStation.fromJsonFile(res);
      listResult.add(formResponse);
    }
    return listResult;
  }

  Future<List<String>> getPoliceStationLabel() async {
    final SharedPreferences prefs = await _prefs;
    List<String> listResult = [];

    var json = prefs.getString('policeStation');
    final jsonResult = jsonDecode(json!);

    var listAmphur = jsonResult['policeStation'] as List;

    for (int i = 0; i < listAmphur.length; i++) {
      Map<String, dynamic> res = listAmphur[i];
      PoliceStation formResponse = PoliceStation.fromJsonFile(res);
      listResult.add(formResponse.name ?? '');
    }
    return listResult;
  }

  Future<String> getPoliceStationLabelById(int id) async {
    final SharedPreferences prefs = await _prefs;

    var json = prefs.getString('policeStation');
    final jsonResult = jsonDecode(json!);

    var listAmphur = jsonResult['policeStation'] as List;

    for (int i = 0; i < listAmphur.length; i++) {
      Map<String, dynamic> res = listAmphur[i];
      PoliceStation formResponse = PoliceStation.fromJsonFile(res);
      if ('${formResponse.id}' == '$id') {
        return formResponse.name ?? '';
      }
    }
    return '';
  }

  Future<int> getProvinceById(int id) async {
    final SharedPreferences prefs = await _prefs;

    var json = prefs.getString('province');
    final jsonResult = jsonDecode(json!);

    var listAmphur = jsonResult['province'] as List;

    for (int i = 0; i < listAmphur.length; i++) {
      Map<String, dynamic> res = listAmphur[i];
      PoliceStation formResponse = PoliceStation.fromJsonFile(res);
      if ('${formResponse.id}' == '$id') {
        return formResponse.provinceId!;
      }
    }
    return -1;
  }

  Future<List<PoliceStation>> getPoliceStationByProvince(
      String provinceID) async {
    final SharedPreferences prefs = await _prefs;
    List<PoliceStation> listResult = [];

    var json = prefs.getString('policeStation');
    final jsonResult = jsonDecode(json!);

    var listAmphur = jsonResult['policeStation'] as List;

    for (int i = 0; i < listAmphur.length; i++) {
      Map<String, dynamic> res = listAmphur[i];
      PoliceStation formResponse = PoliceStation.fromJsonFile(res);
      if ('${formResponse.provinceId}' == provinceID ||
          formResponse.provinceId == 0) {
        listResult.add(formResponse);
      }
    }
    if (kDebugMode) {
      print('getPoliceStationByProvince : ${listResult.length}');
    }
    return listResult;
  }

  Future<List<String>> getPoliceStationLabelByProvince(
      String provinceID) async {
    final SharedPreferences prefs = await _prefs;
    List<String> listResult = [];

    var json = prefs.getString('policeStation');
    final jsonResult = jsonDecode(json!);

    var listAmphur = jsonResult['policeStation'] as List;

    for (int i = 0; i < listAmphur.length; i++) {
      Map<String, dynamic> res = listAmphur[i];
      PoliceStation formResponse = PoliceStation.fromJsonFile(res);
      if ('${formResponse.provinceId}' == provinceID ||
          formResponse.provinceId == 0) {
        listResult.add(formResponse.name ?? '');
      }
    }
    return listResult;
  }
}
