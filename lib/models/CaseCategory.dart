// ignore_for_file: file_names
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CaseCategories {
  final List<CaseCategory>? caseCategories;

  CaseCategories({this.caseCategories});

  factory CaseCategories.fromJson(Map<String, dynamic> json) {
    return CaseCategories(
      caseCategories:
          (json as List).map((data) => CaseCategory.fromJson(data)).toList(),
    );
  }
}

class CaseCategory {
  int? id;
  String? name;

  CaseCategory({this.id, this.name});

  factory CaseCategory.fromJson(Map<String, dynamic> json) {
    return CaseCategory(
      id: json['ID'],
      name: json['Name'],
    );
  }

  factory CaseCategory.fromJsonFile(Map<String, dynamic> json) {
    return CaseCategory(
      id: json['id'],
      name: json['name'],
    );
  }
}

class CaseCategoryDAO {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  insertCaseCategorySharedPref(String json) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('caseCategory', json);
  }

  Future<List<CaseCategory>> getCaseCategory() async {
    final SharedPreferences prefs = await _prefs;
    List<CaseCategory> listResult = [];
    var json = prefs.getString('caseCategory');
    // print(' json : json : $json');

    final jsonResult = jsonDecode(json!);
    var listCaseCategory = jsonResult['caseCategory'] as List;

    for (int i = 0; i < listCaseCategory.length; i++) {
      Map<String, dynamic> res = listCaseCategory[i];
      CaseCategory formResponse = CaseCategory.fromJsonFile(res);

      listResult.add(formResponse);
    }
    return listResult;
  }

  Future<List<String>> getCaseCategoryLabel() async {
    final SharedPreferences prefs = await _prefs;
    List<String> listResult = [];
    var json = prefs.getString('caseCategory');

    final jsonResult = jsonDecode(json!);
    var listPersonal = jsonResult['caseCategory'] as List;

    for (int i = 0; i < listPersonal.length; i++) {
      Map<String, dynamic> res = listPersonal[i];
      CaseCategory formResponse = CaseCategory.fromJsonFile(res);

      listResult.add(formResponse.name ?? '');
    }
    return listResult;
  }

  Future<String> getCaseCategoryLabelByid(int id) async {
    final SharedPreferences prefs = await _prefs;
    var json = prefs.getString('caseCategory');

    final jsonResult = jsonDecode(json!);
    var listCaseCategory = jsonResult['caseCategory'] as List;

    for (int i = 0; i < listCaseCategory.length; i++) {
      Map<String, dynamic> res = listCaseCategory[i];
      CaseCategory formResponse = CaseCategory.fromJsonFile(res);
      if ('${formResponse.id}' == '$id') {
        return formResponse.name ?? '';
      }
    }
    return '';
  }
}
