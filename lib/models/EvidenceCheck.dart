// ignore_for_file: file_names

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class EvidenceCheck {
  int? id;
  String? name;

  EvidenceCheck({this.id, this.name});

  factory EvidenceCheck.fromJson(Map<String, dynamic> json) {
    return EvidenceCheck(id: json['id'], name: json['name']);
  }

  factory EvidenceCheck.fromJsonFile(Map<String, dynamic> json) {
    return EvidenceCheck(id: json['id'], name: json['name']);
  }
}

class EvidenceCheckDao {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  insertEvidenceCheck(String json) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('evidenceCheck', json);
  }

  Future<List<EvidenceCheck>> getEvidenceCheck() async {
    final SharedPreferences prefs = await _prefs;
    List<EvidenceCheck> listResult = [];

    var json = prefs.getString('evidenceCheck');
    final jsonResult = jsonDecode(json!);

    var listRes = jsonResult['evidenceCheck'] as List;

    for (int i = 0; i < listRes.length; i++) {
      Map<String, dynamic> res = listRes[i];
      EvidenceCheck formResponse = EvidenceCheck.fromJsonFile(res);
      listResult.add(formResponse);
    }
    return listResult;
  }

  Future<List<String>> getEvidenceCheckLabel() async {
    final SharedPreferences prefs = await _prefs;
    List<String> listResult = [];

    var json = prefs.getString('evidenceCheck');
    final jsonResult = jsonDecode(json!);

    var listRes = jsonResult['evidenceCheck'] as List;

    for (int i = 0; i < listRes.length; i++) {
      Map<String, dynamic> res = listRes[i];
      EvidenceCheck formResponse = EvidenceCheck.fromJsonFile(res);
      listResult.add(formResponse.name ?? '');
    }
    return listResult;
  }
}
