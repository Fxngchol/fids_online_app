// ignore_for_file: file_names

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Package {
  int? id;
  String? name;

  Package({this.id, this.name});

  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(id: json['ID'], name: json['Name']);
  }

  factory Package.fromJsonFile(Map<String, dynamic> json) {
    return Package(id: json['ID'], name: json['Name']);
  }
}

class PackageDao {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  insertPackage(String json) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('package', json);
  }

  Future<List<Package>> getPackage() async {
    final SharedPreferences prefs = await _prefs;
    List<Package> listResult = [];
    var json = prefs.getString('package');

    final jsonResult = jsonDecode(json!);
    var listCaseCategory = jsonResult['package'] as List;

    for (int i = 0; i < listCaseCategory.length; i++) {
      Map<String, dynamic> res = listCaseCategory[i];
      Package formResponse = Package.fromJsonFile(res);

      listResult.add(formResponse);
    }
    return listResult;
  }

  Future<List<String>> getPackageLabel() async {
    final SharedPreferences prefs = await _prefs;
    List<String> listResult = [];
    var json = prefs.getString('package');

    final jsonResult = jsonDecode(json!);
    var listCaseCategory = jsonResult['package'] as List;

    for (int i = 0; i < listCaseCategory.length; i++) {
      Map<String, dynamic> res = listCaseCategory[i];
      Package formResponse = Package.fromJsonFile(res);

      listResult.add(formResponse.name ?? '');
    }
    return listResult;
  }
}
