// ignore_for_file: file_names

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorkGroup {
  int? id;
  String? name;

  WorkGroup({this.id, this.name});

  factory WorkGroup.fromJson(Map<String, dynamic> json) {
    return WorkGroup(id: json['ID'], name: json['Name']);
  }

  factory WorkGroup.fromJsonFile(Map<String, dynamic> json) {
    return WorkGroup(id: json['ID'], name: json['Name']);
  }
}

class WorkGroupDao {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  insertWorkGroup(String json) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('workgroup', json);
  }

  Future<List<WorkGroup>> getWorkGroup() async {
    final SharedPreferences prefs = await _prefs;
    List<WorkGroup> listResult = [];
    var json = prefs.getString('workgroup');

    final jsonResult = jsonDecode(json!);
    var listCaseCategory = jsonResult['workgroup'] as List;

    for (int i = 0; i < listCaseCategory.length; i++) {
      Map<String, dynamic> res = listCaseCategory[i];
      WorkGroup formResponse = WorkGroup.fromJsonFile(res);

      listResult.add(formResponse);
    }

    if (kDebugMode) {
      print('workgroup : ${listResult.length}');
    }
    return listResult;
  }

  Future<List<String>> getWorkGroupLabel() async {
    final SharedPreferences prefs = await _prefs;
    List<String> listResult = [];
    var json = prefs.getString('workgroup');

    final jsonResult = jsonDecode(json!);
    var listCaseCategory = jsonResult['workgroup'] as List;

    for (int i = 0; i < listCaseCategory.length; i++) {
      Map<String, dynamic> res = listCaseCategory[i];
      WorkGroup formResponse = WorkGroup.fromJsonFile(res);

      listResult.add(formResponse.name ?? '');
    }
    return listResult;
  }
}
