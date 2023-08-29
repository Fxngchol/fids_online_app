// ignore_for_file: file_names

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Personal {
  String? id;
  String? titleId;
  String? name;
  String? firstName;
  String? lastName;
  String? idCard;
  String? positionId;
  String? headId;
  String? departmentId;

  Personal({
    this.id,
    this.titleId,
    this.name,
    this.firstName,
    this.lastName,
    this.idCard,
    this.positionId,
    this.headId,
    this.departmentId,
  });

  factory Personal.fromJson(Map<String, dynamic> json) {
    return Personal(
        id: '${json['ID']}',
        titleId: '${json['TitleID']}',
        name: json['Name'],
        firstName: json['FirstName'],
        lastName: json['lastname'],
        idCard: '${json['IDCard']}',
        positionId: '${json['positionid']}',
        headId: '${json['HeadID']}',
        departmentId: '${json['DepartmentID']}');
  }

  factory Personal.fromJsonFile(Map<String, dynamic> json) {
    return Personal(
        id: '${json['id']}',
        titleId: '${json['titleid']}',
        name: json['Name'],
        firstName: json['FirstName'],
        lastName: json['lastname'],
        idCard: '${json['IDCard']}',
        positionId: '${json['positionid']}',
        headId: '${json['HeadID']}',
        departmentId: '${json['DepartmentID']}');
  }

  @override
  String toString() {
    return 'Personal(id: $id, titleId: $titleId, name: $name, firstName: $firstName, lastName: $lastName, idCard: $idCard, positionId: $positionId, headId: $headId, departmentId: $departmentId)';
  }
}

class PersonalDao {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  insertPersonalSharedPref(String json) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('personal', json);
  }

  Future<List<Personal>> getPersonal() async {
    final SharedPreferences prefs = await _prefs;
    List<Personal> listResult = [];
    var json = prefs.getString('personal');

    final jsonResult = jsonDecode(json!);
    var listPersonal = jsonResult['personal'] as List;

    for (int i = 0; i < listPersonal.length; i++) {
      Map<String, dynamic> res = listPersonal[i];
      Personal formResponse = Personal.fromJsonFile(res);

      listResult.add(formResponse);
    }
    return listResult;

    // final db = await DBProvider.db.database;
    // var res = await  db.query("Personal");
    // if (res.isEmpty) {
    //   return [];
    // } else {
    //   var result = await db.query("Personal");

    //   List<Personal> listResult = [];
    //   // print('result : ${result.toString()}');
    //   Personal response = Personal.fromJson(result[0]);

    //   for (int i = 0; i < result.length; i++) {
    //     Map<String, dynamic> res = result[i];
    //     Personal formResponse = Personal.fromJson(res);
    //     listResult.add(formResponse);
    //   }
    //   return listResult;
    // }
  }

  Future<List<String>> getPersonalLabel() async {
    final SharedPreferences prefs = await _prefs;
    List<String> listResult = [];
    var json = prefs.getString('personal');

    final jsonResult = jsonDecode(json!);
    var listPersonal = jsonResult['personal'] as List;

    for (int i = 0; i < listPersonal.length; i++) {
      Map<String, dynamic> res = listPersonal[i];
      Personal formResponse = Personal.fromJsonFile(res);

      listResult.add('${formResponse.firstName}  ${formResponse.lastName}');
    }
    return listResult;
    // final db = await DBProvider.db.database;
    // var res = await  db.query("Personal");
    // print('getPersonalLabel ${res.length}');
    // if (res.isEmpty) {
    //   return [];
    // } else {
    //   var result = await db.query("Personal");

    //   List<String> listResult = [];
    //   // // print('result : ${result.toString()}');
    //   // Personal response = Personal.fromJson(result[0]);

    //   for (int i = 0; i < result.length; i++) {
    //     Map<String, dynamic> res = result[i];
    //     Personal formResponse = Personal.fromJson(res);
    //     listResult.add('${formResponse.name}');
    //   }
    //   print('getPersonalLabel ${result.length}');
    //   return listResult;
    // }
  }

  Future<String> getPersonalLabelById(int id) async {
    final SharedPreferences prefs = await _prefs;
    var json = prefs.getString('personal');

    final jsonResult = jsonDecode(json!);
    var listPersonal = jsonResult['personal'] as List;

    for (int i = 0; i < listPersonal.length; i++) {
      Map<String, dynamic> res = listPersonal[i];
      Personal formResponse = Personal.fromJsonFile(res);
      if ('${formResponse.id}' == '$id') {
        return '${formResponse.firstName}  ${formResponse.lastName}';
      }
    }
    return '';
  }
}
