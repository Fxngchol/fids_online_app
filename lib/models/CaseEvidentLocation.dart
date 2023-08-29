// ignore_for_file: file_names
import 'package:flutter/foundation.dart';

import '../../utils/database/database.dart';

class CaseEvidentLocation {
  int? id;
  int? fidsId;
  int? evidentId;
  String? evidentFoundId;
  String? evidentLocationDetail;
  String? createDate;
  String? createBy;
  String? updateDate;
  String? updateBy;
  String? activeFlag;
  String? area;
  String? labelNo;

  CaseEvidentLocation(
      {this.id,
      this.fidsId,
      this.evidentId,
      this.evidentFoundId,
      this.evidentLocationDetail,
      this.createDate,
      this.createBy,
      this.updateDate,
      this.updateBy,
      this.activeFlag,
      this.area,
      this.labelNo});

  factory CaseEvidentLocation.fromJson(Map<String?, dynamic> json) {
    return CaseEvidentLocation(
      id: json['ID'],
      fidsId: json['FidsID'],
      evidentId: json['EvidentID'],
      evidentFoundId: json['EvidentFoundID'],
      evidentLocationDetail: json['EvidentLocationDetail'],
      createDate: json['CreateDate'],
      createBy: json['CreateBy'],
      updateDate: json['UpdateDate'],
      updateBy: json['UpdateBy'],
      activeFlag: '${json['ActiveFlag']}',
      area: json['Area'],
      labelNo: json['LabelNo'],
    );
  }

  Map toJson() => {
        'id': id == -2 || id == null ? '' : '$id',
        'evident_id': evidentId == -2 || evidentId == null ? '' : '$evidentId',
        'evident_found_id': evidentFoundId ?? '',
        'evident_location_detail': evidentLocationDetail ?? '',
        'active_flag': '1',
        'area': area ?? '',
        'labelNo': labelNo ?? '',
      };
}

class CaseEvidentLocationDao {
  Future<void> createCaseEvidentLocation(
      int? fidsId,
      int? evidentId,
      String? evidentFoundId,
      String? evidentLocationDetail,
      String? createDate,
      String? createBy,
      String? updateDate,
      String? updateBy,
      bool? activeFlag,
      String? area,
      String? labelNo) async {
    final db = await DBProvider.db.database;

    await db.rawInsert('''
      INSERT INT?  CaseEvidentLocation (
        FidsID,EvidentID,EvidentFoundID,EvidentLocationDetail,CreateDate,CreateBy,UpdateDate,UpdateBy,ActiveFlag,Area,LabelNo
      ) VALUES (?,?,?,?,?,?,?,?,?,?,?)
    ''', [
      fidsId,
      evidentId,
      evidentFoundId,
      evidentLocationDetail,
      createDate,
      createBy,
      updateDate,
      updateBy,
      activeFlag,
      area,
      labelNo
    ]);
  }

  Future<void> updateCaseEvidentLocation(
      int fidsId,
      int evidentId,
      String evidentFoundId,
      String? evidentLocationDetail,
      String? labelNo,
      String? area,
      int? id) async {
    final db = await DBProvider.db.database;

    var result = await db.query("CaseEvidentLocation");
    bool isUpdate = false;
    for (int i = 0; i < result.length; i++) {
      CaseEvidentLocation formResponse =
          CaseEvidentLocation.fromJson(result[i]);
      if ('${formResponse.id}' == '$id') {
        isUpdate = true;
      }
    }

    isUpdate
        ? await db.rawUpdate('''
      UPDATE CaseEvidentLocation SET
        FidsID = ?, EvidentID = ?, EvidentFoundID = ?, EvidentLocationDetail = ?, Area = ?, LabelNo = ? WHERE ID = ?
    ''', [
            fidsId,
            evidentId,
            evidentFoundId,
            evidentLocationDetail,
            area,
            labelNo,
            id
          ])
        : await db.rawInsert('''
      INSERT INT?  CaseEvidentLocation (
        FidsID,EvidentID,EvidentFoundID,EvidentLocationDetail,CreateDate,CreateBy,UpdateDate,UpdateBy,ActiveFlag,Area,LabelNo
      ) VALUES (?,?,?,?,?,?,?,?,?,?,?)
    ''', [
            fidsId,
            evidentId,
            evidentFoundId,
            evidentLocationDetail,
            '',
            '',
            '',
            '',
            '',
            area,
            labelNo
          ]);
  }

  Future<List<CaseEvidentLocation>> getCaseEvidentLocation(int fidsID) async {
    final db = await DBProvider.db.database;
    var res = await db.query("CaseEvidentLocation",
        where: '"FidsID" = ?', whereArgs: ['$fidsID']);
    if (res.isEmpty) {
      return [];
    } else {
      var result = await db.query("CaseEvidentLocation",
          where: '"FidsID" = ?', whereArgs: ['$fidsID']);

      List<CaseEvidentLocation> listResult = [];
      //// print? 'result : ${result.toString?()}');
      //FidsCrimeScene response = FidsCrimeScene.fromJson(result[0]);

      for (int? i = 0; i! < result.length; i++) {
        CaseEvidentLocation formResponse =
            CaseEvidentLocation.fromJson(result[i]);
        listResult.add(formResponse);
      }
      return listResult;
    }
  }

  Future<List<String?>> getCaseEvidentLocationLabel(int? fidsID) async {
    final db = await DBProvider.db.database;
    var res = await db.query("CaseEvidentLocation",
        where: '"FidsID" = ?', whereArgs: ['$fidsID']);
    if (res.isEmpty) {
      return [];
    } else {
      var result = await db.query("CaseEvidentLocation",
          where: '"FidsID" = ?', whereArgs: ['$fidsID']);

      List<String?> listResult = [];
      // print? 'result : ${result.toString?()}');
      //FidsCrimeScene response = FidsCrimeScene.fromJson(result[0]);

      for (int i = 0; i < result.length; i++) {
        CaseEvidentLocation formResponse =
            CaseEvidentLocation.fromJson(result[i]);
        listResult.add(formResponse.evidentLocationDetail);
      }
      return listResult;
    }
  }

  Future<CaseEvidentLocation?> getCaseEvidentLocationById(int? id) async {
    final db = await DBProvider.db.database;
    var res = await db
        .query("CaseEvidentLocation", where: '"ID" = ?', whereArgs: ['$id']);
    if (res.isEmpty) {
      return null;
    } else {
      var result = await db
          .query("CaseEvidentLocation", where: '"ID" = ?', whereArgs: ['$id']);

      CaseEvidentLocation response = CaseEvidentLocation.fromJson(result[0]);

      return response;
    }
  }

  Future<List<CaseEvidentLocation>> getCaseEvidentLocationByEvidentId(
      String? evidentID) async {
    final db = await DBProvider.db.database;
    var res = await db.query("CaseEvidentLocation",
        where: '"EvidentID" = ?', whereArgs: ['$evidentID']);
    if (res.isEmpty) {
      return [];
    } else {
      var result = await db.query("CaseEvidentLocation",
          where: '"EvidentID" = ?', whereArgs: ['$evidentID']);

      List<CaseEvidentLocation> listResult = [];
      //// print? 'result : ${result.toString?()}');
      //FidsCrimeScene response = FidsCrimeScene.fromJson(result[0]);

      for (int i = 0; i < result.length; i++) {
        CaseEvidentLocation formResponse =
            CaseEvidentLocation.fromJson(result[i]);
        listResult.add(formResponse);
      }
      return listResult;
    }
  }

  Future<void> delete(int id) async {
    final db = await DBProvider.db.database;

    await db.rawDelete('''
      DELETE FROM CaseEvidentLocation WHERE ID = ?
    ''', [id]);
    if (kDebugMode) {
      print('DELETE Success');
    }
  }

  Future<void> deleteAll(int? fidsID) async {
    final db = await DBProvider.db.database;

    await db.rawDelete('''
      DELETE FROM CaseEvidentLocation WHERE FidsID = ?
    ''', [fidsID]);
    if (kDebugMode) {
      print('DELETE Success');
    }
  }
}
