// ignore_for_file: file_names

import 'package:flutter/foundation.dart';

import '../../utils/database/database.dart';

class CaseVehicleCompareDetail {
  String? id;
  String? caseVehicleId;
  // String?vehicleSideId;
  int? caseVehicleCompareId;
  String? caseVehicleDamagedId;
  String? labelNo;

  CaseVehicleCompareDetail({
    this.id,
    this.caseVehicleId,
    // this.vehicleSideId,
    this.caseVehicleCompareId,
    this.caseVehicleDamagedId,
    this.labelNo,
  });

  CaseVehicleCompareDetail.fromJson(Map<String, dynamic> json) {
    id = '${json['ID']}';
    caseVehicleId = json['CaseVehicleID'];
    // vehicleSideId = json['VehicleSideID'];
    caseVehicleCompareId = json['CaseVehicleCompareID'];
    caseVehicleDamagedId = json['CaseVehicleDamagedID'];
    labelNo = json['LabelNo'];
  }

  Map toJson() => {
        'id': id == '-2' || id == null ? '' : '$id',
        'case_vehicle_id': caseVehicleId ?? '',
        // 'vehicle_side_id': this.vehicleSideId ?? '',
        'case_vehicle_compare_id': '$caseVehicleCompareId',
        'case_vehicle_damaged_id': '$caseVehicleDamagedId',
        'label_no': labelNo ?? '',
      };

  @override
  String toString() {
    return 'CaseVehicleCompareDetail(id: $id, caseVehicleId: $caseVehicleId, caseVehicleCompareId: $caseVehicleCompareId, caseVehicleDamagedId: $caseVehicleDamagedId, labelNo: $labelNo)';
  }
}

class CaseVehicleCompareDetailDao {
  Future<dynamic> createCaseVehicleCompareDetail(
      String? fidsId,
      String? caseVehicleID,
      String? caseVehicleDamagedID,
      int caseVehicleCompareID) async {
    final db = await DBProvider.db.database;
    var res = await db.rawInsert('''
      INSERT INTO CaseVehicleCompareDetail (
        FidsID,CaseVehicleID,CaseVehicleDamagedID,CaseVehicleCompareID
      ) VALUES (?,?,?,?)
    ''', [fidsId, caseVehicleID, caseVehicleDamagedID, caseVehicleCompareID]);

    return res;
  }

  Future<dynamic> updateCaseVehicleCompareDetail(
    String? caseVehicleID,
    String? vehicleSideID,
    String? caseVehicleDamagedID,
    String? labelNo,
    int id,
  ) async {
    final db = await DBProvider.db.database;
    var res = await db.rawUpdate('''
      UPDATE CaseVehicleCompareDetail SET 
     CaseVehicleID = ?, CaseVehicleDamagedID = ?, LabelNo = ? WHERE ID = ?
    ''', [caseVehicleID, caseVehicleDamagedID, labelNo, id]);
    return res;
  }

  Future<List<CaseVehicleCompareDetail>> getAllCaseVehicleCompareDetail(
      int fidsID) async {
    final db = await DBProvider.db.database;
    var res = await db.query("CaseVehicleCompareDetail",
        where: '"FidsID" = ?', whereArgs: ['$fidsID']);
    if (res.isEmpty) {
      return [];
    } else {
      var result = await db.query("CaseVehicleCompareDetail",
          where: '"FidsID" = ?', whereArgs: ['$fidsID']);
      List<CaseVehicleCompareDetail> listResult = [];

      for (int i = 0; i < result.length; i++) {
        Map<String, dynamic> res = result[i];
        CaseVehicleCompareDetail formResponse =
            CaseVehicleCompareDetail.fromJson(res);
        listResult.add(formResponse);
      }
      return listResult;
    }
  }

  Future<List<CaseVehicleCompareDetail>> getCaseVehicleCompareDetail(
      int fidsID, String? id) async {
    final db = await DBProvider.db.database;
    var res = await db.query("CaseVehicleCompareDetail",
        where: '"FidsID" = ?', whereArgs: ['$fidsID']);
    if (res.isEmpty) {
      return [];
    } else {
      var result = await db.query("CaseVehicleCompareDetail",
          where: '"FidsID" = ?', whereArgs: ['$fidsID']);
      List<CaseVehicleCompareDetail> listResult = [];

      for (int i = 0; i < result.length; i++) {
        Map<String, dynamic> res = result[i];
        CaseVehicleCompareDetail formResponse =
            CaseVehicleCompareDetail.fromJson(res);
        if (formResponse.caseVehicleCompareId.toString() == id) {
          listResult.add(formResponse);
        }
      }
      return listResult;
    }
  }

  Future<CaseVehicleCompareDetail?> getCaseVehicleCompareDetailById(
      int id) async {
    final db = await DBProvider.db.database;
    var res = await db.query("CaseVehicleCompareDetail");
    if (res.isEmpty) {
      return null;
    } else {
      var result = await db.query("CaseVehicleCompareDetail",
          where: '"ID" = ?', whereArgs: ['$id']);
      CaseVehicleCompareDetail response =
          CaseVehicleCompareDetail.fromJson(result[0]);
      return response;
    }
  }

  Future<void> deleteCaseVehicleCompareDetail(String? id) async {
    final db = await DBProvider.db.database;

    await db.rawDelete('''
      DELETE FROM CaseVehicleCompareDetail WHERE CaseVehicleCompareID = ?
    ''', [id]);
    if (kDebugMode) {
      print('DELETE Success');
    }
  }

  Future<dynamic> delete(int fidsId) async {
    final db = await DBProvider.db.database;

    var res = await db.rawDelete('''
      DELETE FROM CaseVehicleCompareDetail WHERE FidsID = ?
    ''', [fidsId]);
    if (kDebugMode) {
      print('DELETE Success');
    }
    return res;
  }
}
