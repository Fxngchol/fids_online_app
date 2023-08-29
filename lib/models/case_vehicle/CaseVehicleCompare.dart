// ignore_for_file: file_names

import 'package:flutter/foundation.dart';

import '../../utils/database/database.dart';

class CaseVehicleCompare {
  String? id;
  String? caseVehicleId1;
  String? caseVehicleId2;

  CaseVehicleCompare({
    this.id,
    this.caseVehicleId1,
    this.caseVehicleId2,
  });

  CaseVehicleCompare.fromJson(Map<String, dynamic> json) {
    id = '${json['ID']}';
    caseVehicleId1 = json['CaseVehicleID1'];
    caseVehicleId2 = json['CaseVehicleID2'];
  }

  Map toJson() => {
        'id': id == '-2' || id == null ? '' : '$id',
        'case_vehicle_id1': caseVehicleId1 ?? '',
        'case_vehicle_id2': caseVehicleId2 ?? '',
      };

  @override
  String toString() =>
      'CaseVehicleCompare(id: $id, caseVehicleId1: $caseVehicleId1, caseVehicleId2: $caseVehicleId2)';
}

class CaseVehicleCompareDao {
  createCaseVehicleCompared(
    String? fidsId,
    String? caseVehicleId1,
    String? caseVehicleId2,
  ) async {
    final db = await DBProvider.db.database;
    var res = await db.rawInsert('''
      INSERT INTO CaseVehicleCompare (
        FidsID,CaseVehicleID1,CaseVehicleID2
      ) VALUES (?,?,?)
    ''', [
      fidsId,
      caseVehicleId1,
      caseVehicleId2,
    ]);

    return res;
  }

  Future<int> updateCaseVehicleCompared(
    String? caseVehicleId1,
    String? caseVehicleId2,
    int id,
  ) async {
    final db = await DBProvider.db.database;
    var res = await db.rawUpdate('''
      UPDATE CaseVehicleCompare SET 
     CaseVehicleID1 = ?, CaseVehicleID2 = ? WHERE ID = ?
    ''', [caseVehicleId1, caseVehicleId2, id]);
    return res;
  }

  Future<List<CaseVehicleCompare>> getCaseVehicleCompare(int fidsID) async {
    final db = await DBProvider.db.database;
    var res = await db.query("CaseVehicleCompare",
        where: '"FidsID" = ?', whereArgs: ['$fidsID']);
    if (res.isEmpty) {
      return [];
    } else {
      var result = await db.query("CaseVehicleCompare",
          where: '"FidsID" = ?', whereArgs: ['$fidsID']);
      List<CaseVehicleCompare> listResult = [];

      for (int i = 0; i < result.length; i++) {
        Map<String, dynamic> res = result[i];
        CaseVehicleCompare formResponse = CaseVehicleCompare.fromJson(res);
        listResult.add(formResponse);
      }

      return listResult;
    }
  }

  Future<CaseVehicleCompare?> getCaseVehicleCompareById(int id) async {
    final db = await DBProvider.db.database;
    var res = await db.query("CaseVehicleCompare");
    if (res.isEmpty) {
      return null;
    } else {
      var result = await db
          .query("CaseVehicleCompared", where: '"ID" = ?', whereArgs: ['$id']);
      CaseVehicleCompare response = CaseVehicleCompare.fromJson(result[0]);
      return response;
    }
  }

  Future<void> deleteCaseVehicleCompared(String? id) async {
    final db = await DBProvider.db.database;
    await db.rawDelete('''
      DELETE FROM CaseVehicleCompare WHERE ID = ?
    ''', [id]);
    if (kDebugMode) {
      print('DELETE Success');
    }
  }

  delete(int fidsId) async {
    final db = await DBProvider.db.database;

    var res = await db.rawDelete('''
      DELETE FROM CaseVehicleCompare WHERE FidsID = ?
    ''', [fidsId]);
    if (kDebugMode) {
      print('DELETE Success');
    }
    return res;
  }
}
