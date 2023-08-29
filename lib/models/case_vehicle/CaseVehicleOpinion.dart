// ignore_for_file: file_names

import 'package:flutter/foundation.dart';

import '../../utils/database/database.dart';

class CaseVehicleOpinion {
  String? id;
  String? opinion;

  CaseVehicleOpinion({
    this.id,
    this.opinion,
  });

  CaseVehicleOpinion.fromJson(Map<String, dynamic> json) {
    id = '${json['ID']}';
    opinion = json['Opinion'];
  }

  Map toJson() => {
        'id': id == '-2' || id == null ? '' : '$id',
        'opinion': opinion ?? '',
      };
}

class CaseVehicleOpinionDao {
  Future<dynamic> createCaseVehicleOpinion(
    String? fidsId,
    String? opinion,
  ) async {
    final db = await DBProvider.db.database;
    var res = await db.rawInsert('''
      INSERT INTO CaseVehicleOpinion (
        FidsID,Opinion
      ) VALUES (?,?)
    ''', [
      fidsId,
      opinion,
    ]);

    return res;
  }

  Future<dynamic> updateCaseVehicleOpinions(
    int id,
    String? opinion,
  ) async {
    final db = await DBProvider.db.database;
    var res = await db.rawUpdate('''
      UPDATE CaseVehicleOpinion SET 
      Opinion = ? WHERE ID = ?
    ''', [opinion, id]);

    return res;
  }

  Future<List<CaseVehicleOpinion>> getCaseVehicleOpinions(int fidsID) async {
    final db = await DBProvider.db.database;
    var res = await db.query("CaseVehicleOpinion",
        where: '"FidsID" = ?', whereArgs: ['$fidsID']);
    if (res.isEmpty) {
      return [];
    } else {
      var result = await db.query("CaseVehicleOpinion",
          where: '"FidsID" = ?', whereArgs: ['$fidsID']);
      List<CaseVehicleOpinion> listResult = [];
      for (int i = 0; i < result.length; i++) {
        Map<String, dynamic> res = result[i];
        CaseVehicleOpinion formResponse = CaseVehicleOpinion.fromJson(res);
        listResult.add(formResponse);
      }
      return listResult;
    }
  }

  Future<CaseVehicleOpinion?> getCaseVehicleOpinionById(int id) async {
    final db = await DBProvider.db.database;
    var res = await db.query("CaseVehicleOpinion");
    if (res.isEmpty) {
      return null;
    } else {
      var result = await db
          .query("CaseVehicleOpinion", where: '"ID" = ?', whereArgs: ['$id']);
      CaseVehicleOpinion response = CaseVehicleOpinion.fromJson(result[0]);
      return response;
    }
  }

  Future<dynamic> deleteCaseVehicleOpinion(String? id) async {
    final db = await DBProvider.db.database;

    var res = await db.rawDelete('''
      DELETE FROM CaseVehicleOpinion WHERE ID = ?
    ''', [id]);
    if (kDebugMode) {
      print('DELETE Success');
    }
    return res;
  }

  Future<dynamic> delete(int fidsId) async {
    final db = await DBProvider.db.database;

    var res = await db.rawDelete('''
      DELETE FROM CaseVehicleOpinion WHERE FidsID = ?
    ''', [fidsId]);
    if (kDebugMode) {
      print('DELETE Success');
    }
    return res;
  }
}
