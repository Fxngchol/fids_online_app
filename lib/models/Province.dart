// ignore_for_file: file_names

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Province {
  int? id;
  String? province;

  Province({this.id, this.province});

  factory Province.fromJson(Map<String, dynamic> json) {
    return Province(id: json['ID'], province: json['Province']);
  }

  factory Province.fromJsonFile(Map<String, dynamic> json) {
    return Province(id: json['id'], province: json['Province']);
  }
}

class ProvinceDao {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  insertProvince(String json) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('province', json);
  }

  Future<List<Province>> getProvince() async {
    final SharedPreferences prefs = await _prefs;
    List<Province> listResult = [];

    var json = prefs.getString('province');
    final jsonResult = jsonDecode(json!);

    var listAmphur = jsonResult['province'] as List;

    for (int i = 0; i < listAmphur.length; i++) {
      Map<String, dynamic> res = listAmphur[i];
      Province formResponse = Province.fromJsonFile(res);
      listResult.add(formResponse);
    }
    if (kDebugMode) {
      print('terk province size : ${listResult.length}');
    }
    return listResult;
  }

  Future<List<String>> getProvinceLabel() async {
    final SharedPreferences prefs = await _prefs;
    List<String> listResult = [];

    var json = prefs.getString('province');
    final jsonResult = jsonDecode(json!);

    var listAmphur = jsonResult['province'] as List;

    for (int i = 0; i < listAmphur.length; i++) {
      Map<String, dynamic> res = listAmphur[i];
      Province formResponse = Province.fromJsonFile(res);
      listResult.add(formResponse.province ?? '');
    }
    return listResult;
  }

  Future<String> getProvinceLabelById(int id) async {
    try {
      final SharedPreferences prefs = await _prefs;

      var json = prefs.getString('province');
      final jsonResult = jsonDecode(json!);
      var listAmphur = jsonResult['province'] as List;

      for (int i = 0; i < listAmphur.length; i++) {
        Map<String, dynamic> res = listAmphur[i];
        Province formResponse = Province.fromJsonFile(res);

        if ('${formResponse.id}' == '$id') {
          return formResponse.province ?? '';
        }
      }
      return '';
    } catch (ex) {
      return '';
    }
  }
}
