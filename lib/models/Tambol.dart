// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Tambol {
  int? id;
  String? tambol;
  int? provinceId;
  String? amphurId;

  Tambol({this.id, this.tambol, this.provinceId, this.amphurId});

  factory Tambol.fromJson(Map<String, dynamic> json) {
    return Tambol(
        id: json['ID'],
        tambol: json['Tambol'],
        provinceId: json['ProvinceID'],
        amphurId: json['AmphurID']);
  }

  factory Tambol.fromJsonFile(Map<String, dynamic> json) {
    return Tambol(
        id: json['id'],
        tambol: json['tambol'],
        provinceId: json['ProvinceID'],
        amphurId: '${json['AmphurID']}');
  }
}

class TambolDao {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  insertTambolSharedPref(String json) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('tambol', json);
  }

  Future<List> getTambolSharedPref() async {
    final SharedPreferences prefs = await _prefs;
    var json = prefs.getString('tambol');
    final personalJsonResult = jsonDecode(json!);
    var listPersonal = personalJsonResult['tambol'] as List;
    for (int i = 0; i < listPersonal.length; i++) {
      Map<String, dynamic> res = listPersonal[i];
      if (kDebugMode) {
        print('getTambolSharedPref : ${res.toString()}');
      }
      Tambol formResponse = Tambol.fromJsonFile(res);
      listPersonal.add(formResponse);
    }
    return listPersonal;
  }

  // insertTambol(int id, String tambol, int provinceId, int amphurId) async {
  //   final db = await DBProvider.db.database;
  //   Batch batch = db.batch();

  //   List<Map> result = await db.query("tambol");
  //   // result.forEach((row) => print('farmid : ${row['farmid']}'));

  //   bool isAdded = false;
  //   for (int i = 0; i < result.length; i++) {
  //     if (id == result[i]['ID']) {
  //       isAdded = true;
  //     }
  //   }
  //
  //   if (isAdded) {
  // var res = await db.rawUpdate('''
  //     UPDATE Tambol SET Tambol = ?,ProvinceID = ?,AmphurID = ? WHERE ID = ?
  //   ''', [tambol, provinceId, amphurId, id]);
  //   } else {
  //     batch.insert('Tambol', {
  //       'ID': id,
  //       'Tambol': tambol,
  //       'ProvinceID': provinceId,
  //       'AmphurID': amphurId
  //     });
  //     await batch.commit(noResult: true);

  //     //   res = await db.rawInsert('''
  //     //   INSERT INTO Tambol (
  //     //     ID,Tambol,ProvinceID,AmphurID
  //     //   ) VALUES (?,?,?,?)
  //     // ''', [id, tambol, provinceId, amphurId]);
  //   }

  //   return res;
  // }

  Future<List<Tambol>> getTambolByID(int provinceId, int amphurId) async {
    final SharedPreferences prefs = await _prefs;
    List<Tambol> listResult = [];
    var json = prefs.getString('tambol');

    final jsonResult = jsonDecode(json!);
    var listPersonal = jsonResult['tambol'] as List;

    for (int i = 0; i < listPersonal.length; i++) {
      Map<String, dynamic> res = listPersonal[i];
      Tambol formResponse = Tambol.fromJsonFile(res);
      if ('${formResponse.amphurId}' == '$amphurId') {
        listResult.add(formResponse);
      }
    }
    return listResult;

    // final db = await DBProvider.db.database;
    // var res = await  db.query("Tambol");
    // if (res.isEmpty) {
    //   return [];
    // } else {
    //   var result = await db
    //       .query("Tambol", where: '"AmphurID" = ?', whereArgs: ['$amphurId']);

    //   List<Tambol> listResult = [];
    //   print('result : ${result.toString()}');
    //   Tambol response = Tambol.fromJson(result[0]);

    //   for (int i = 0; i < result.length; i++) {
    //     Map<String, dynamic> res = result[i];
    //     Tambol formResponse = Tambol.fromJson(res);
    //     listResult.add(formResponse);
    //   }
    //   return listResult;
    // }
  }

  Future<List<String>> getTambolLabelByID(int provinceId, int amphurId) async {
    if (kDebugMode) {
      print('amphurId : $amphurId');
    }
    final SharedPreferences prefs = await _prefs;
    List<String> listResult = [];
    var json = prefs.getString('tambol');
    final jsonResult = jsonDecode(json!);
    var listPersonal = jsonResult['tambol'] as List;
    for (int i = 0; i < listPersonal.length; i++) {
      Map<String, dynamic> res = listPersonal[i];
      Tambol formResponse = Tambol.fromJsonFile(res);
      if ('${formResponse.amphurId}' == '$amphurId') {
        listResult.add(formResponse.tambol ?? '');
      }
    }
    return listResult;
    // final db = await DBProvider.db.database;
    // var res = await  db.query("Tambol");
    // if (res.isEmpty) {
    //   return [];
    // } else {
    //   var result = await db
    //       .query("Tambol", where: '"AmphurID" = ?', whereArgs: ['$amphurId']);

    //   List<String> listResult = [];
    //   print('result : ${result.toString()}');
    //   Tambol response = Tambol.fromJson(result[0]);

    //   for (int i = 0; i < result.length; i++) {
    //     Map<String, dynamic> res = result[i];
    //     Tambol formResponse = Tambol.fromJson(res);
    //     listResult.add(formResponse.tambol);
    //   }
    //   return listResult;
    // }
  }

  Future<String> getTambolLabelByid(int id) async {
    final SharedPreferences prefs = await _prefs;
    var json = prefs.getString('tambol');
    final jsonResult = jsonDecode(json!);
    var listPersonal = jsonResult['tambol'] as List;
    for (int i = 0; i < listPersonal.length; i++) {
      Map<String, dynamic> res = listPersonal[i];
      Tambol formResponse = Tambol.fromJsonFile(res);
      if ('${formResponse.id}' == '$id') {
        if (kDebugMode) {
          print('in for : ${formResponse.tambol}');
        }
        return formResponse.tambol ?? '';
      }
    }
    if (kDebugMode) {
      print('out for');
    }
    return '';
    // try {
    //   final db = await DBProvider.db.database;
    //   var res = await  db.query("Tambol");
    //   if (res.isEmpty) {
    //     return '';
    //   } else {
    //     var result =
    //         await db.query("Tambol", where: '"ID" = ?', whereArgs: ['$id']);
    //     Tambol response = Tambol.fromJson(result[0]);
    //     return response.tambol;
    //   }
    // } catch (ex) {
    //   return '';
    // }
  }
}
