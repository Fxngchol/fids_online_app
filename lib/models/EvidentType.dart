// ignore_for_file: file_names

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class EvidentType {
  int? id;
  String? name;
  //int evidenceGroupID;

  EvidentType({this.id, this.name});

  factory EvidentType.fromJson(Map<String, dynamic> json) {
    return EvidentType(
      id: json['id'],
      name: json['name'],
      // evidenceGroupID: json['EvidenceGroupID']
    );
  }

  factory EvidentType.fromJsonFile(Map<String, dynamic> json) {
    return EvidentType(
      id: json['id'],
      name: json['name'],
      // evidenceGroupID: json['EvidenceGroupID']
    );
  }
}

class EvidentypeDao {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  insertEvidentType(String json) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('evidentType', json);
  }

  Future<List<EvidentType>> getEvidentType() async {
    final SharedPreferences prefs = await _prefs;
    List<EvidentType> listResult = [];

    var json = prefs.getString('evidentType');
    final jsonResult = jsonDecode(json!);

    var listRes = jsonResult['evidentType'] as List;

    for (int i = 0; i < listRes.length; i++) {
      Map<String, dynamic> res = listRes[i];
      EvidentType formResponse = EvidentType.fromJsonFile(res);
      listResult.add(formResponse);
    }
    return listResult;
  }

  Future<List<String>> getEvidentTypeLabel() async {
    final SharedPreferences prefs = await _prefs;
    List<String> listResult = [];

    var json = prefs.getString('evidentType');
    final jsonResult = jsonDecode(json!);

    var listRes = jsonResult['evidentType'] as List;

    for (int i = 0; i < listRes.length; i++) {
      Map<String, dynamic> res = listRes[i];
      EvidentType formResponse = EvidentType.fromJsonFile(res);
      listResult.add(formResponse.name ?? '');
    }
    return listResult;
  }

  Future<String> getEvidentTypeLabelById(String id) async {
    final SharedPreferences prefs = await _prefs;

    var json = prefs.getString('evidentType');
    final jsonResult = jsonDecode(json!);

    var listRes = jsonResult['evidentType'] as List;

    for (int i = 0; i < listRes.length; i++) {
      Map<String, dynamic> res = listRes[i];
      EvidentType formResponse = EvidentType.fromJsonFile(res);
      if (id == '${formResponse.id}') {
        return formResponse.name ?? '';
      }
      // listResult.add(formResponse.name ?? '');
    }
    return '';
  }

  Future<List<EvidentType>> getEvidentTypeWithEvidenceGroup(
      String evidenceGroupid) async {
    final SharedPreferences prefs = await _prefs;
    List<EvidentType> listResult = [];

    var json = prefs.getString('evidentType');
    final jsonResult = jsonDecode(json!);

    var listRes = jsonResult['evidentType'] as List;

    for (int i = 0; i < listRes.length; i++) {
      Map<String, dynamic> res = listRes[i];
      EvidentType formResponse = EvidentType.fromJsonFile(res);
      //  if ('${formResponse.evidenceGroupID}' == evidenceGroupid) {
      listResult.add(formResponse);
      // }
    }
    return listResult;
  }

  Future<List<String>> getEvidentTypeLabelWithEvidenceGroup(
      String evidenceGroupid) async {
    final SharedPreferences prefs = await _prefs;
    List<String> listResult = [];

    var json = prefs.getString('evidentType');
    final jsonResult = jsonDecode(json!);

    var listRes = jsonResult['evidentType'] as List;

    for (int i = 0; i < listRes.length; i++) {
      Map<String, dynamic> res = listRes[i];
      EvidentType formResponse = EvidentType.fromJsonFile(res);
      //if ('${formResponse.evidenceGroupID}' == evidenceGroupid) {
      listResult.add(formResponse.name ?? '');
      //}
    }
    return listResult;
  }
}
