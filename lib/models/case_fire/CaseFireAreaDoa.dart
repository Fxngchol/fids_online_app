// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import '../../utils/database/database.dart';
import 'CaseFireArea.dart';

class CaseFireAreaDao {
  Future<dynamic> createCaseFireArea(
      String? fidsId,
      String? areaDetail,
      String? front1,
      String? left1,
      String? right1,
      String? back1,
      String? floor1,
      String? roof1,
      String? other1,
      String? front2,
      String? left2,
      String? right2,
      String? back2,
      String? center2,
      String? roof2,
      String? other2) async {
    final db = await DBProvider.db.database;
    var res = await db.rawInsert('''
      INSERT INTO CaseFireArea (
        FidsID,AreaDetail,Front1, Left1,Right1,Back1, Floor1, Roof1,Other1, Front2, Left2,Right2, Back2, Center2,Roof2,Other2
      ) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)
    ''', [
      fidsId,
      areaDetail,
      front1,
      left1,
      right1,
      back1,
      floor1,
      roof1,
      other1,
      front2,
      left2,
      right2,
      back2,
      center2,
      roof2,
      other2
    ]);

    return res;
  }

  Future<dynamic> updateCaseFireArea(
      int id,
      String? areaDetail,
      String? front1,
      String? left1,
      String? right1,
      String? back1,
      String? floor1,
      String? roof1,
      String? other1,
      String? front2,
      String? left2,
      String? right2,
      String? back2,
      String? center2,
      String? roof2,
      String? other2) async {
    final db = await DBProvider.db.database;
    var res = await db.rawUpdate('''
      UPDATE CaseFireArea SET 
      AreaDetail = ?,Front1 = ?, Left1 = ?,Right1 = ?,
          Back1 = ?, Floor1 = ?, Roof1= ?,
          Other1= ?, Front2= ?, Left2= ?,
          Right2 = ?, Back2 = ?, Center2 = ?,
          Roof2= ?,Other2 = ? WHERE ID = ?
    ''', [
      areaDetail,
      front1,
      left1,
      right1,
      back1,
      floor1,
      roof1,
      other1,
      front2,
      left2,
      right2,
      back2,
      center2,
      roof2,
      other2,
      id
    ]);

    return res;
  }

  Future<dynamic> updateCaseFireAreaMap(
    int id,
    String? vehicleMap,
  ) async {
    final db = await DBProvider.db.database;
    var res = await db.rawUpdate('''
      UPDATE CaseFireArea SET 
    VehicleMap = ? WHERE ID = ?
    ''', [vehicleMap, id]);

    return res;
  }

  Future<List<CaseFireArea>> getCaseFireArea(int fidsID) async {
    final db = await DBProvider.db.database;
    var res = await db
        .query("CaseFireArea", where: '"FidsID" = ?', whereArgs: ['$fidsID']);
    if (res.isEmpty) {
      return [];
    } else {
      var result = await db
          .query("CaseFireArea", where: '"FidsID" = ?', whereArgs: ['$fidsID']);
      List<CaseFireArea> listResult = [];
      for (int i = 0; i < result.length; i++) {
        Map<String?, dynamic> res = result[i];
        CaseFireArea formResponse = CaseFireArea.fromJson(res);
        listResult.add(formResponse);
      }

      listResult.sort((a, b) => a.id!.compareTo(b.id!));
      return listResult;
    }
  }

  Future<CaseFireArea?> getCaseFireAreaById(String? id) async {
    final db = await DBProvider.db.database;
    var res = await db.query("CaseFireArea");
    if (res.isEmpty) {
      return null;
    } else {
      var result =
          await db.query("CaseFireArea", where: '"ID" = ?', whereArgs: ['$id']);
      CaseFireArea response = CaseFireArea.fromJson(result[0]);
      return response;
    }
  }

  Future<dynamic> deleteCaseFireArea(String? id) async {
    final db = await DBProvider.db.database;

    var res = await db.rawDelete('''
      DELETE FROM CaseFireArea WHERE ID = ?
    ''', [id]);
    if (kDebugMode) {
      print('DELETE Success');
    }
    return res;
  }

  Future<dynamic> delete(int fidsId) async {
    final db = await DBProvider.db.database;

    var res = await db.rawDelete('''
      DELETE FROM CaseFireArea WHERE FidsID = ?
    ''', [fidsId]);
    if (kDebugMode) {
      print('DELETE Success');
    }
    return res;
  }
}
