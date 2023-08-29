// ignore_for_file: file_names

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SubCaseCategory {
  int? id;
  String? name;
  int? caseCategoryId;

  SubCaseCategory({this.id, this.name, this.caseCategoryId});

  factory SubCaseCategory.fromJson(Map<String, dynamic> json) {
    return SubCaseCategory(
        id: json['ID'],
        name: json['Name'],
        caseCategoryId: json['CaseCategory']);
  }

  factory SubCaseCategory.fromJsonFile(Map<String, dynamic> json) {
    return SubCaseCategory(
      id: json['id'],
      name: json['name'],
      caseCategoryId: json['CaseCategoryID'],
    );
  }

  @override
  String toString() =>
      'SubCaseCategory(id: $id, name: $name, caseCategoryId: $caseCategoryId)';
}

class SubCaseCategoryDao {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  insertSubCaseCategorySharedPref(String json) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('subCaseCategory', json);
  }

  Future<List<SubCaseCategory>> getSubCaseCategoryByFK(
      int caseCategoryId) async {
    final SharedPreferences prefs = await _prefs;
    List<SubCaseCategory> listResult = [];

    var json = prefs.getString('subCaseCategory');
    final jsonResult = jsonDecode(json!);

    var listAmphur = jsonResult['subCaseCategory'] as List;

    for (int i = 0; i < listAmphur.length; i++) {
      Map<String, dynamic> res = listAmphur[i];
      SubCaseCategory formResponse = SubCaseCategory.fromJsonFile(res);
      if ('${formResponse.caseCategoryId}' == '$caseCategoryId' ||
          formResponse.caseCategoryId == 0) {
        listResult.add(formResponse);
      }
    }
    return listResult;
  }

  Future<List<String>> getSubCaseCategoryLabelByFK(int caseCategoryId) async {
    final SharedPreferences prefs = await _prefs;
    List<String> listResult = [];

    var json = prefs.getString('subCaseCategory');
    final jsonResult = jsonDecode(json!);

    var listAmphur = jsonResult['subCaseCategory'] as List;

    for (int i = 0; i < listAmphur.length; i++) {
      Map<String, dynamic> res = listAmphur[i];
      SubCaseCategory formResponse = SubCaseCategory.fromJsonFile(res);
      if ('${formResponse.caseCategoryId}' == '$caseCategoryId') {
        listResult.add(formResponse.name ?? '');
      }
    }
    return listResult;
  }

  Future<String> getSubCaseCategoryByid(int id) async {
    final SharedPreferences prefs = await _prefs;

    var json = prefs.getString('subCaseCategory');
    final jsonResult = jsonDecode(json!);

    var listAmphur = jsonResult['subCaseCategory'] as List;

    for (int i = 0; i < listAmphur.length; i++) {
      Map<String, dynamic> res = listAmphur[i];
      SubCaseCategory formResponse = SubCaseCategory.fromJsonFile(res);
      if ('${formResponse.id}' == '$id') {
        return formResponse.name ?? '';
      }
    }
    return '';
  }

  Future<List<SubCaseCategory>> getSubCaseCategory(int caseCategoryId) async {
    final SharedPreferences prefs = await _prefs;
    List<SubCaseCategory> listResult = [];

    var json = prefs.getString('subCaseCategory');
    final jsonResult = jsonDecode(json!);

    var listSubcaseCatagory = jsonResult['subCaseCategory'] as List;

    for (int i = 0; i < listSubcaseCatagory.length; i++) {
      Map<String, dynamic> res = listSubcaseCatagory[i];
      SubCaseCategory formResponse = SubCaseCategory.fromJsonFile(res);
      if ('${formResponse.caseCategoryId}' == '$caseCategoryId' ||
          formResponse.caseCategoryId == 0) {
        listResult.add(formResponse);
      }
      // listResult.add(formResponse);
    }

    return listResult;
  }
}
