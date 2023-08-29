// ignore_for_file: file_names
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Career {
  int? id;
  String? name;

  Career({this.id, this.name});

  factory Career.fromJson(Map<String, dynamic> json) {
    return Career(id: json['ID'], name: json['Name']);
  }

  factory Career.fromJsonFile(Map<String, dynamic> json) {
    return Career(id: json['id'], name: json['name']);
  }
}

class CareerDao {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  insertCareer(String json) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('career', json);
  }

  Future<List<Career>> getCareer() async {
    final SharedPreferences prefs = await _prefs;
    List<Career> listResult = [];

    var json = prefs.getString('career');
    final jsonResult = jsonDecode(json!);

    var listRes = jsonResult['career'] as List;

    for (int i = 0; i < listRes.length; i++) {
      Map<String, dynamic> res = listRes[i];
      Career formResponse = Career.fromJsonFile(res);
      listResult.add(formResponse);
    }
    return listResult;
  }

  Future<List<String>> getCareerLabel() async {
    final SharedPreferences prefs = await _prefs;
    List<String> listResult = [];

    var json = prefs.getString('career');
    final jsonResult = jsonDecode(json!);

    var listRes = jsonResult['career'] as List;

    for (int i = 0; i < listRes.length; i++) {
      Map<String, dynamic> res = listRes[i];
      Career formResponse = Career.fromJsonFile(res);
      listResult.add(formResponse.name ?? '');
    }
    return listResult;
  }
}
