// ignore_for_file: file_names

import 'package:flutter/foundation.dart';

import '../../utils/database/database.dart';
import 'CaseFireSideArea.dart';

class CaseFireSideAreaDao {
  Future<dynamic> createCaseFireSideArea(
    String? fidsId,
    String? sideAreaDetail,
    String? caseFireAreaID,
  ) async {
    final db = await DBProvider.db.database;
    var res = await db.rawInsert('''
      INSERT INTO CaseFireSideArea (
        FidsID,SideAreaDetail
      ) VALUES (?,?)
    ''', [fidsId, sideAreaDetail]);

    return res;
  }

  Future<dynamic> updateCaseFireSideArea(
    int id,
    String? sideAreaDetail,
  ) async {
    final db = await DBProvider.db.database;
    var res = await db.rawUpdate('''
      UPDATE CaseFireSideArea SET 
      sideAreaDetail = ? WHERE ID = ?
    ''', [sideAreaDetail, id]);

    return res;
  }

  Future<dynamic> updateCaseFireSideAreaMap(
    int id,
    String? sideAreaDetail,
  ) async {
    final db = await DBProvider.db.database;
    var res = await db.rawUpdate('''
      UPDATE CaseFireSideArea SET 
    SideAreaDetail = ? WHERE ID = ?
    ''', [sideAreaDetail, id]);

    return res;
  }

  Future<List<CaseFireSideArea>> getAllCaseFireSideArea(int fidsID) async {
    final db = await DBProvider.db.database;
    var res = await db.query("CaseFireSideArea",
        where: '"FidsID" = ?', whereArgs: ['$fidsID']);
    if (res.isEmpty) {
      return [];
    } else {
      var result = await db.query("CaseFireSideArea",
          where: '"FidsID" = ?', whereArgs: ['$fidsID']);
      List<CaseFireSideArea> listResult = [];
      for (int i = 0; i < result.length; i++) {
        Map<String, dynamic> res = result[i];
        CaseFireSideArea formResponse = CaseFireSideArea.fromJson(res);
        listResult.add(formResponse);
      }

      listResult.sort((a, b) => a.id!.compareTo(b.id!));
      return listResult;
    }
  }

  // Future<List<CaseFireSideArea>> getCaseFireSideArea(
  //     int fidsID, String?caseFireAreaID) async {
  //   final db = await DBProvider.db.database;
  //   var res = await  db.query("CaseFireSideArea",
  //       where: '"FidsID" = ?', whereArgs: ['$fidsID']);
  //   if (res.isEmpty) {
  //     return [];
  //   } else {
  //     var result = await db.query("CaseFireSideArea",
  //         where: '"FidsID" = ?', whereArgs: ['$fidsID']);
  //     List<CaseFireSideArea> listResult = [];

  //     for (int i = 0; i < result.length; i++) {
  //       Map<String, dynamic> res = result[i];
  //       CaseFireSideArea formResponse = CaseFireSideArea.fromJson(res);
  //       if (formResponse.caseFireAreaID == caseFireAreaID.toString()) {
  //         listResult.add(formResponse);
  //       }
  //     }

  //     return listResult;
  //   }
  // }

  Future<CaseFireSideArea?> getCaseFireSideAreaById(String? id) async {
    final db = await DBProvider.db.database;
    var res = await db.query("CaseFireSideArea");
    if (res.isEmpty) {
      return null;
    } else {
      var result = await db
          .query("CaseFireSideArea", where: '"ID" = ?', whereArgs: ['$id']);
      CaseFireSideArea response = CaseFireSideArea.fromJson(result[0]);
      return response;
    }
  }

  Future<dynamic> deleteCaseFireSideArea(String? id) async {
    final db = await DBProvider.db.database;

    var res = await db.rawDelete('''
      DELETE FROM CaseFireSideArea WHERE ID = ?
    ''', [id]);
    if (kDebugMode) {
      print('DELETE Success');
    }
    return res;
  }

  Future<dynamic> delete(int fidsId) async {
    final db = await DBProvider.db.database;

    var res = await db.rawDelete('''
      DELETE FROM CaseFireSideArea WHERE FidsID = ?
    ''', [fidsId]);
    if (kDebugMode) {
      print('DELETE Success');
    }
    return res;
  }
}
