// ignore_for_file: file_names

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class TypeCard {
  int? id;
  String? name;

  TypeCard({this.id, this.name});

  factory TypeCard.fromJson(Map<String, dynamic> json) {
    return TypeCard(id: json['ID'], name: json['Name']);
  }

  factory TypeCard.fromJsonFile(Map<String, dynamic> json) {
    return TypeCard(id: json['id'], name: json['Name']);
  }

  @override
  String toString() => 'TypeCard(id: $id, name: $name)';
}

class TypeCardDao {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  insertTypeCard(String? json) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('typeCard', json!);
  }

  Future<List<TypeCard>> getTypeCard() async {
    final SharedPreferences prefs = await _prefs;
    List<TypeCard> listResult = [];

    var json = prefs.getString('typeCard');
    final jsonResult = jsonDecode(json!);

    var listRes = jsonResult['typeCard'] as List;

    for (int i = 0; i < listRes.length; i++) {
      Map<String, dynamic> res = listRes[i];
      TypeCard formResponse = TypeCard.fromJsonFile(res);
      listResult.add(formResponse);
    }
    return listResult;
  }

  Future<List<String>> getTypeCardLabel() async {
    final SharedPreferences prefs = await _prefs;
    List<String> listResult = [];

    var json = prefs.getString('typeCard');
    final jsonResult = jsonDecode(json!);

    var listRes = jsonResult['typeCard'] as List;

    for (int i = 0; i < listRes.length; i++) {
      Map<String, dynamic> res = listRes[i];
      TypeCard formResponse = TypeCard.fromJsonFile(res);
      listResult.add(formResponse.name ?? '');
    }
    return listResult;
  }
}
