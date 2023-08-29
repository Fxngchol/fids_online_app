// ignore_for_file: file_names

import 'package:flutter/foundation.dart';

import '../../utils/database/database.dart';

class CaseEvidentDeliver {
  int? id;
  int? fidsId;
  int? evidentId;
  int? workGroupId;
  String? evidenceCheckId;

  CaseEvidentDeliver(
      {this.id,
      this.fidsId,
      this.evidentId,
      this.workGroupId,
      this.evidenceCheckId});

  factory CaseEvidentDeliver.fromJson(Map<String, dynamic> json) {
    return CaseEvidentDeliver(
      id: json['ID'],
      fidsId: json['FidsID'],
      evidentId: json['EvidentID'],
      workGroupId: json['WorkGroupID'],
      evidenceCheckId: json['EvidenceCheckID'],
    );
  }

  Map toJson() => {
        'ID': id == -2 || id == null ? '' : '$id',
        'FidsID': fidsId == -2 || fidsId == null ? '' : '$fidsId',
        'EvidentID': evidentId == -2 || evidentId == null ? '' : '$evidentId',
        'WorkGroupID':
            workGroupId == -2 || workGroupId == null ? '' : '$workGroupId',
        'evident_check_id': evidenceCheckId == null ? '' : '$evidenceCheckId',
      };

  @override
  String toString() {
    return 'CaseEvidentDeliver(id: $id, fidsId: $fidsId, evidentId: $evidentId, workGroupId: $workGroupId, evidenceCheckId: $evidenceCheckId)';
  }
}

class CaseEvidentDeliverDao {
  Future<void> createCaseEvidentDeliver(int fidsId, int evidentId,
      int workGroupId, String evidenceCheckId) async {
    final db = await DBProvider.db.database;

    await db.rawInsert('''
      INSERT INTO CaseEvidentDeliver (
        FidsID,EvidentID,WorkGroupID,EvidenceCheckID
      ) VALUES (?,?,?,?)
    ''', [fidsId, evidentId, workGroupId, evidenceCheckId]);
  }

  Future<void> updateCaseEvidentDeliver(int id, int fidsId, int evidentId,
      int workGroupId, String evidenceCheckId) async {
    final db = await DBProvider.db.database;

    bool isUpdate = false;
    var result = await db.query("CaseEvidentDeliver");
    for (int i = 0; i < result.length; i++) {
      CaseEvidentDeliver formResponse = CaseEvidentDeliver.fromJson(result[i]);
      if ('${formResponse.id}' == '$id') {
        isUpdate = true;
      }
    }

    isUpdate ? await db.rawUpdate('''
      UPDATE CaseEvidentDeliver SET
        FidsID = ?, EvidentID = ?, WorkGroupID = ? WHERE ID = ?
    ''', [fidsId, evidentId, workGroupId, id]) : await db.rawInsert('''
      INSERT INTO CaseEvidentDeliver (
        FidsID,EvidentID,WorkGroupIDฃ
      ) VALUES (?,?,?)
    ''', [fidsId, evidentId, workGroupId]);
  }

  Future<List<CaseEvidentDeliver>> getCaseEvidentDeliver(
      String evidentID) async {
    final db = await DBProvider.db.database;
    var res = await db.query("CaseEvidentDeliver",
        where: '"EvidentID" = ?', whereArgs: [evidentID]);
    if (res.isEmpty) {
      return [];
    } else {
      var result = await db.query("CaseEvidentDeliver",
          where: '"EvidentID" = ?', whereArgs: [evidentID]);

      List<CaseEvidentDeliver> listResult = [];
      //// print('result : ${result.toString()}');
      //FidsCrimeScene response = FidsCrimeScene.fromJson(result[0]);

      for (int i = 0; i < result.length; i++) {
        // Map<String, dynamic> res = result[i];
        CaseEvidentDeliver formResponse =
            CaseEvidentDeliver.fromJson(result[i]);
        listResult.add(formResponse);
      }
      return listResult;
    }
  }

  Future<void> delete(int id) async {
    final db = await DBProvider.db.database;

    await db.rawDelete('''
      DELETE FROM CaseEvidentDeliver WHERE ID = ?
    ''', [id]);
    if (kDebugMode) {
      print('DELETE Success');
    }
  }

  Future<void> deleteAll(int fidsID) async {
    final db = await DBProvider.db.database;

    await db.rawDelete('''
      DELETE FROM CaseEvidentDeliver WHERE FidsID = ?
    ''', [fidsID]);
    if (kDebugMode) {
      print('DELETE Success');
    }
  }

  // Future<List<String>> getCaseCaseEvidentDelivernLabel(int fidsID) async {
  //   final db = await DBProvider.db.database;
  //   var res = await  db.query("CaseEvidentDeliver",
  //       where: '"FidsID" = ?', whereArgs: ['$fidsID']);
  //   if (res.isEmpty) {
  //     return [];
  //   } else {
  //     var result = await db.query("CaseEvidentDeliver",
  //         where: '"FidsID" = ?', whereArgs: ['$fidsID']);

  //     List<String> listResult = [];
  //     // print('result : ${result.toString()}');
  //     //FidsCrimeScene response = FidsCrimeScene.fromJson(result[0]);

  //     for (int i = 0; i < result.length; i++) {
  //       Map<String, dynamic> res = result[i];
  //       CaseEvidentDeliver formResponse =
  //           CaseEvidentDeliver.fromJson(result[i]);
  //       listResult.add(formResponse.);
  //     }
  //     return listResult;
  //   }
  // }

  // Future<CaseEvidentLocation> getCaseEvidentLocationById(int id) async {
  //   final db = await DBProvider.db.database;
  //   var res = await  db
  //       .query("CaseEvidentLocation", where: '"ID" = ?', whereArgs: ['$id']);
  //   if (res.isEmpty) {
  //     return null;
  //   } else {
  //     var result = await db
  //         .query("CaseEvidentLocation", where: '"ID" = ?', whereArgs: ['$id']);

  //     CaseEvidentLocation response = CaseEvidentLocation.fromJson(result[0]);

  //     return response;
  //   }
  // }

  // Future<List<CaseEvidentLocation>> getCaseEvidentLocationByEvidentId(
  //     String evidentID) async {
  //   final db = await DBProvider.db.database;
  //   var res = await  db.query("CaseEvidentLocation",
  //       where: '"EvidentID" = ?', whereArgs: ['$evidentID']);
  //   if (res.isEmpty) {
  //     return [];
  //   } else {
  //     var result = await db.query("CaseEvidentLocation",
  //         where: '"EvidentID" = ?', whereArgs: ['$evidentID']);

  //     List<CaseEvidentLocation> listResult = [];
  //     //// print('result : ${result.toString()}');
  //     //FidsCrimeScene response = FidsCrimeScene.fromJson(result[0]);

  //     for (int i = 0; i < result.length; i++) {
  //       Map<String, dynamic> res = result[i];
  //       CaseEvidentLocation formResponse =
  //           CaseEvidentLocation.fromJson(result[i]);
  //       listResult.add(formResponse);

  //     }
  //     return listResult;
  //   }
  // }
}
