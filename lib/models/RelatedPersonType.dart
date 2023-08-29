// ignore_for_file: file_names

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class RelatedPersonType {
  int? id;
  String? name;

  RelatedPersonType({this.id, this.name});

  factory RelatedPersonType.fromJson(Map<String, dynamic> json) {
    return RelatedPersonType(id: json['ID'], name: json['Name']);
  }

  factory RelatedPersonType.fromJsonFile(Map<String, dynamic> json) {
    return RelatedPersonType(id: json['id'], name: json['name']);
  }

  @override
  String toString() => 'RelatedPersonType(id: $id, name: $name)';
}

class RelatedPersonTypeDao {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  insertRelatedPersonType(String json) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('relatedPersonType', json);
  }

  Future<List<RelatedPersonType>> getRelatedPersonType() async {
    final SharedPreferences prefs = await _prefs;
    List<RelatedPersonType> listResult = [];
    var json = prefs.getString('relatedPersonType');

    final jsonResult = jsonDecode(json!);
    var listCaseCategory = jsonResult['relatedPersonType'] as List;

    for (int i = 0; i < listCaseCategory.length; i++) {
      Map<String, dynamic> res = listCaseCategory[i];
      RelatedPersonType formResponse = RelatedPersonType.fromJsonFile(res);

      listResult.add(formResponse);
    }
    return listResult;
  }

  Future<List<String>> getRelatedPersonTypeLabel() async {
    final SharedPreferences prefs = await _prefs;
    List<String> listResult = [];
    var json = prefs.getString('relatedPersonType');

    final jsonResult = jsonDecode(json!);
    var listCaseCategory = jsonResult['relatedPersonType'] as List;

    for (int i = 0; i < listCaseCategory.length; i++) {
      Map<String, dynamic> res = listCaseCategory[i];
      RelatedPersonType formResponse = RelatedPersonType.fromJsonFile(res);

      listResult.add(formResponse.name ?? '');
    }
    return listResult;
  }
}
