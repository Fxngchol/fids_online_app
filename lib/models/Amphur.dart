// ignore_for_file: file_names

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Amphur {
  int? id;
  String? amphur;
  int? provinceId;

  Amphur({this.id, this.amphur, this.provinceId});

  factory Amphur.fromJson(Map<String, dynamic> json) {
    return Amphur(
        id: json['ID'], amphur: json['Amphur'], provinceId: json['ProvinceID']);
  }

  factory Amphur.fromJsonFile(Map<String, dynamic> json) {
    return Amphur(
      id: json['id'],
      amphur: json['Amphur'],
      provinceId: json['ProvinceID'],
    );
  }

  @override
  String toString() =>
      'Amphur(id: $id, amphur: $amphur, provinceId: $provinceId)';
}

class AmphurDao {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  insertAmphurSharedPref(String json) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('amphur', json);
  }

  Future<List<Amphur>> getAmphurByProvinceID(int provinceId) async {
    final SharedPreferences prefs = await _prefs;
    List<Amphur> listResult = [];
    var json = prefs.getString('amphur');

    final jsonResult = jsonDecode(json!);
    var listAmphur = jsonResult['amphur'] as List;
    for (int i = 0; i < listAmphur.length; i++) {
      Map<String, dynamic> res = listAmphur[i];
      Amphur formResponse = Amphur.fromJsonFile(res);
      if ('${formResponse.provinceId}' == '$provinceId') {
        listResult.add(formResponse);
        if (kDebugMode) {
          print(formResponse.amphur);
        }
      }
    }
    // print('listResult${listResult.toString()}');

    return listResult;
  }

  Future<List<String>> getProvinceLabelByProvinceID(int provinceId) async {
    final SharedPreferences prefs = await _prefs;
    List<String> listResult = [];
    var json = prefs.getString('amphur');

    final jsonResult = jsonDecode(json!);
    var listAmphur = jsonResult['amphur'] as List;

    for (int i = 0; i < listAmphur.length; i++) {
      Map<String, dynamic> res = listAmphur[i];
      Amphur formResponse = Amphur.fromJsonFile(res);
      if ('${formResponse.provinceId}' == '$provinceId') {
        listResult.add(formResponse.amphur ?? '');
      }
    }
    return listResult;
  }

  Future<String> getAmphurLabelByid(int id) async {
    final SharedPreferences prefs = await _prefs;

    var json = prefs.getString('amphur');

    final jsonResult = jsonDecode(json!);
    var listPersonal = jsonResult['amphur'] as List;

    for (int i = 0; i < listPersonal.length; i++) {
      Map<String, dynamic> res = listPersonal[i];
      Amphur formResponse = Amphur.fromJsonFile(res);
      if ('${formResponse.id}' == '$id') {
        return formResponse.amphur ?? '';
      }
    }
    return '';
  }
}

// class AmphurDao {

//   final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();


//   insertAmphur(int id, String amphur, int provinceId) async {
//     final db = await DBProvider.db.database;

//     List<Map> result = await db.query("Amphur");
//     // result.forEach((row) => print('farmid : ${row['farmid']}'));

//     bool isAdded = false;
//     for (int i = 0; i < result.length; i++) {
//       if (id == result[i]['ID']) {
//         isAdded = true;
//       }
//     }
//      
//     if (isAdded) {
//   var res = await db.rawUpdate('''
//       UPDATE Amphur SET Amphur = ?,ProvinceID = ? WHERE ID = ?
//     ''', [amphur, provinceId, id]);
//     } else {
//   var res = await db.rawInsert('''
//       INSERT INTO Amphur (
//         ID,Amphur,ProvinceID
//       ) VALUES (?,?,?)
//     ''', [id, amphur, provinceId]);
//     }

//     return res;
//   }

//   Future<List<Amphur>> getAmphurByProvinceID(int provinceId) async {
//     final db = await DBProvider.db.database;
//     var res = await  db.query("Amphur");
//     if (res.isEmpty) {
//       return [];
//     } else {
//       var result = await db.query("Amphur",
//           where: '"ProvinceID" = ?', whereArgs: ['$provinceId']);

//       List<Amphur> listResult = [];
//       // print('result : ${result.toString()}');
//       Amphur response = Amphur.fromJson(result[0]);

//       for (int i = 0; i < result.length; i++) {
//         Map<String, dynamic> res = result[i];
//         Amphur formResponse = Amphur.fromJson(res);
//         listResult.add(formResponse);
//       }
//       return listResult;
//     }
//   }

//   Future<List<String>> getProvinceLabelByProvinceID(int provinceId) async {
//     final db = await DBProvider.db.database;
//     var res = await  db.query("Amphur");
//     if (res.isEmpty) {
//       return [];
//     } else {
//       var result = await db.query("Amphur",
//           where: '"ProvinceID" = ?', whereArgs: ['$provinceId']);

//       List<String> listResult = [];
//       // print('result : ${result.toString()}');
//       Amphur response = Amphur.fromJson(result[0]);

//       for (int i = 0; i < result.length; i++) {
//         Map<String, dynamic> res = result[i];
//         Amphur formResponse = Amphur.fromJson(res);
//         listResult.add(formResponse.amphur);
//       }
//       return listResult;
//     }
//   }

//   Future<String> getAmphurLabelByid(int id) async {
//     try {
//       final db = await DBProvider.db.database;
//       var res = await  db.query("Amphur");
//       if (res.isEmpty) {
//         return '';
//       } else {
//         var result =
//             await db.query("Amphur", where: '"ID" = ?', whereArgs: ['$id']);
//         Amphur response = Amphur.fromJson(result[0]);
//         return response.amphur;
//       }
//     } catch (ex) {
//       return '';
//     }
//   }
// }
