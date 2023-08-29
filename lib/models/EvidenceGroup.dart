// ignore_for_file: file_names

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class EvidenceGroup {
  int? id;
  String? name;

  EvidenceGroup({this.id, this.name});

  factory EvidenceGroup.fromJson(Map<String, dynamic> json) {
    return EvidenceGroup(id: json['id'], name: json['name']);
  }

  factory EvidenceGroup.fromJsonFile(Map<String, dynamic> json) {
    return EvidenceGroup(id: json['id'], name: json['name']);
  }
}

class EvidenceGroupDao {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  insertEvidenceGroup(String? json) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('evidenceGroup', json!);
  }

  Future<List<EvidenceGroup>> getEvidenceGroup() async {
    final SharedPreferences prefs = await _prefs;
    List<EvidenceGroup> listResult = [];

    var json = prefs.getString('evidenceGroup');
    final jsonResult = jsonDecode(json!);

    var listRes = jsonResult['evidenceGroup'] as List;

    for (int i = 0; i < listRes.length; i++) {
      Map<String, dynamic> res = listRes[i];
      EvidenceGroup formResponse = EvidenceGroup.fromJsonFile(res);
      listResult.add(formResponse);
    }
    return listResult;
  }

  Future<List<String>> getEvidenceGroupLabel() async {
    final SharedPreferences prefs = await _prefs;
    List<String> listResult = [];

    var json = prefs.getString('evidenceGroup');
    final jsonResult = jsonDecode(json!);

    var listRes = jsonResult['evidenceGroup'] as List;

    for (int i = 0; i < listRes.length; i++) {
      Map<String, dynamic> res = listRes[i];
      EvidenceGroup formResponse = EvidenceGroup.fromJsonFile(res);
      listResult.add(formResponse.name ?? '');
    }
    return listResult;
  }
}
