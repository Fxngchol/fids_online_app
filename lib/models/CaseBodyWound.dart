// ignore_for_file: file_names
import 'package:flutter/foundation.dart';

import '../../utils/database/database.dart';

class CaseBodyWound {
  String? id;
  String? bodyId;
  String? woundDetail;
  String? woundPosition;
  String? woundSize;
  String? woundUnitId;
  String? woundAmount;
  String? createDate;
  String? createBy;
  String? updateDate;
  String? updateBy;
  String? activeFlag;

  CaseBodyWound({
    this.id,
    this.bodyId,
    this.woundDetail,
    this.woundPosition,
    this.woundSize,
    this.woundUnitId,
    this.woundAmount,
    this.createDate,
    this.createBy,
    this.updateDate,
    this.updateBy,
    this.activeFlag,
  });

  factory CaseBodyWound.fromJson(Map<String, dynamic> json) {
    return CaseBodyWound(
        id: '${json['ID']}',
        bodyId: '${json['BodyID']}',
        woundDetail: json['WoundDetail'],
        woundPosition: json['WoundPosition'],
        woundSize: '${json['WoundSize']}',
        woundUnitId: '${json['WoundUnitID']}',
        woundAmount: '${json['WoundAmount']}',
        createDate: json['CreateDate'],
        createBy: json['CreateBy'],
        updateDate: json['UpdateDate'],
        updateBy: json['UpdateBy'],
        activeFlag: '${json['ActiveFlag']}');
  }

  factory CaseBodyWound.fromApi(Map<String, dynamic> json) {
    return CaseBodyWound(
        id: json['id'],
        bodyId: json['body_id'],
        woundDetail: json['wound_detail'],
        woundPosition: json['wound_position'],
        woundSize: json['wound_size'],
        woundUnitId: json['wound_unit_id'],
        woundAmount: json['wound_amount'],
        activeFlag: json['active_flag']);
  }

  Map toJson() => {
        'id': id == '-2' || id == null ? '' : '$id',
        'wound_detail': woundDetail ?? '',
        'wound_position': woundPosition ?? '',
        'wound_size': woundSize ?? '',
        'wound_unit_id': woundUnitId == '-2' ? '' : '$woundUnitId',
        'wound_amount': woundAmount ?? '',
        'active_flag': activeFlag ?? '',
      };

  @override
  String toString() {
    return 'CaseBodyWound(id: $id, bodyId: $bodyId, woundDetail: $woundDetail, woundPosition: $woundPosition, woundSize: $woundSize, woundUnitId: $woundUnitId, woundAmount: $woundAmount, createDate: $createDate, createBy: $createBy, updateDate: $updateDate, updateBy: $updateBy, activeFlag: $activeFlag)';
  }
}

class CaseBodyWoundDao {
  Future<void> createCaseBodyWound(
      int bodyId,
      String? woundDetail,
      String? woundPosition,
      String? woundSize,
      String? woundUnitId,
      String? woundAmount,
      String? createDate,
      String? createBy,
      String? updateDate,
      String? updateBy,
      int activeFlag) async {
    final db = await DBProvider.db.database;
    db.rawInsert('''
      INSERT INTO CaseBodyWound (
        BodyID,WoundDetail,WoundPosition,WoundSize,WoundUnitID,WoundAmount,CreateDate,CreateBy,UpdateDate,UpdateBy,ActiveFlag
      ) VALUES (?,?,?,?,?,?,?,?,?,?,?)
    ''', [
      bodyId,
      woundDetail,
      woundPosition,
      woundSize,
      woundUnitId,
      woundAmount,
      createDate,
      createBy,
      updateDate,
      updateBy,
      activeFlag
    ]);
  }

  Future<void> updateCaseBodyWound(
      int bodyId,
      String? woundDetail,
      String? woundPosition,
      String? woundSize,
      String? woundUnitId,
      String? woundAmount,
      String? createDate,
      String? createBy,
      String? updateDate,
      String? updateBy,
      int activeFlag,
      int id) async {
    final db = await DBProvider.db.database;
    await db.rawUpdate('''
      UPDATE CaseBodyWound SET
         WoundDetail = ?, WoundPosition = ?, WoundSize = ?, WoundUnitID = ?, WoundAmount = ?, CreateDate = ?, CreateBy = ?, UpdateDate = ?, UpdateBy = ?, ActiveFlag = ? WHERE ID = ?
    ''', [
      woundDetail,
      woundPosition,
      woundSize,
      woundUnitId,
      woundAmount,
      createDate,
      createBy,
      updateDate,
      updateBy,
      activeFlag,
      id
    ]);
  }

  Future<void> deleteCaseBodyWound(String id) async {
    final db = await DBProvider.db.database;
    await db.rawDelete('''
      DELETE FROM CaseBodyWound WHERE ID = ?
    ''', [id]);
    if (kDebugMode) {
      print('DELETE Success');
    }
  }

  Future<void> deleteAllCaseBodyWound(String bodyId) async {
    final db = await DBProvider.db.database;
    await db.rawDelete('''
      DELETE FROM CaseBody WHERE ID = ?
    ''', [bodyId]);
    if (kDebugMode) {
      print('DELETE Success');
    }
  }

  Future<List<CaseBodyWound>> getCaseBodyWound(String bodyID) async {
    final db = await DBProvider.db.database;
    var res = await db.query("CaseBodyWound");
    if (res.isEmpty) {
      return [];
    } else {
      var result = await db
          .query("CaseBodyWound", where: '"BodyID" = ?', whereArgs: [bodyID]);

      List<CaseBodyWound> listResult = [];
      // print('result : ${result.toString()}');
      //FidsCrimeScene response = FidsCrimeScene.fromJson(result[0]);

      for (int i = 0; i < result.length; i++) {
        Map<String, dynamic> res = result[i];
        CaseBodyWound formResponse = CaseBodyWound.fromJson(res);
        listResult.add(formResponse);
      }
      return listResult;
    }
  }

  // CaseBodyWoundDao().deleteCaseBodyWound(caseBodyWounds[index].id);

  Future<CaseBodyWound?> getCaseBodyWoundById(int id) async {
    final db = await DBProvider.db.database;
    var res = await db.query("CaseBodyWound");
    if (res.isEmpty) {
      return null;
    } else {
      var result = await db
          .query("CaseBodyWound", where: '"ID" = ?', whereArgs: ['$id']);

      CaseBodyWound response = CaseBodyWound.fromJson(result[0]);

      return response;
    }
  }

  // Future<CaseBodyWound> getAllCaseBodyWoundById(int id) async {
  //   final db = await DBProvider.db.database;
  //   var res = await  db.query("CaseBodyWound");
  //   if (res.isEmpty) {
  //     return null;
  //   } else {
  //     var result = await db
  //         .query("CaseBodyWound", where: '"ID" = ?', whereArgs: ['$id']);

  //     CaseBodyWound response = CaseBodyWound.fromJson(result[0]);

  //     return response;
  //   }
  // }
}
