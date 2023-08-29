// ignore_for_file: file_names

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Department {
  int? id;
  String? name;
  int? rootId;

  Department({this.id, this.name, this.rootId});

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      id: json['id'],
      name: json['name'],
      rootId: json['rootid'],
    );
  }

  factory Department.fromJsonFile(Map<String, dynamic> json) {
    return Department(
      id: json['id'],
      name: json['name'],
      rootId: json['rootid'],
    );
  }
}

class DepartmentDao {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  insertDepartment(String json) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('department', json);
  }

  Future<List<Department>> getDepartment() async {
    final SharedPreferences prefs = await _prefs;
    List<Department> listResult = [];

    var json = prefs.getString('department');
    final jsonResult = jsonDecode(json!);

    var listRes = jsonResult['department'] as List;

    for (int i = 0; i < listRes.length; i++) {
      Map<String, dynamic> res = listRes[i];
      Department formResponse = Department.fromJsonFile(res);
      listResult.add(formResponse);
    }
    return listResult;
  }

  Future<List<Department>> getDepartmentRootZero() async {
    final SharedPreferences prefs = await _prefs;
    List<Department> listResult = [];

    var json = prefs.getString('department');
    final jsonResult = jsonDecode(json!);

    var listRes = jsonResult['department'] as List;

    for (int i = 0; i < listRes.length; i++) {
      Map<String, dynamic> res = listRes[i];
      Department formResponse = Department.fromJsonFile(res);
      if (formResponse.rootId == 0) {
        listResult.add(formResponse);
      }
    }
    return listResult;
  }

  Future<List<Department>> getDepartmentByRootId(int rootId) async {
    final SharedPreferences prefs = await _prefs;
    List<Department> listResult = [];

    var json = prefs.getString('department');
    final jsonResult = jsonDecode(json!);

    var listRes = jsonResult['department'] as List;

    for (int i = 0; i < listRes.length; i++) {
      Map<String, dynamic> res = listRes[i];
      Department formResponse = Department.fromJsonFile(res);
      if (formResponse.rootId == rootId) {
        listResult.add(formResponse);
      }
    }
    return listResult;
  }

  Future<List<String>> getDepartmentLabel() async {
    final SharedPreferences prefs = await _prefs;
    List<String> listResult = [];

    var json = prefs.getString('department');
    final jsonResult = jsonDecode(json!);

    var listRes = jsonResult['department'] as List;

    for (int i = 0; i < listRes.length; i++) {
      Map<String, dynamic> res = listRes[i];
      Department formResponse = Department.fromJsonFile(res);
      listResult.add(formResponse.name ?? '');
    }
    return listResult;
  }
}
