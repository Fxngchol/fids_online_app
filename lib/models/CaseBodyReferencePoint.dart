// ignore_for_file: file_names

import 'package:flutter/foundation.dart';

import '../../utils/database/database.dart';

class CaseBodyReferencePoint {
  String? bodyPositionId;
  String? id;
  String? fidsId;
  String? bodyId;
  String? referenceDetail;
  String? referenceID1;
  String? referenceDistance1;
  String? referenceUnitId1;
  String? referenceID2;
  String? referenceDistance2;
  String? referenceUnitId2;
  String? createDate;
  String? createBy;
  String? updateDate;
  String? updateBy;
  String? activeFlag;

  CaseBodyReferencePoint({
    this.bodyPositionId,
    this.id,
    this.fidsId,
    this.bodyId,
    this.referenceDetail,
    this.referenceID1,
    this.referenceDistance1,
    this.referenceUnitId1,
    this.referenceID2,
    this.referenceDistance2,
    this.referenceUnitId2,
    this.createDate,
    this.createBy,
    this.updateDate,
    this.updateBy,
    this.activeFlag,
  });

  factory CaseBodyReferencePoint.fromJson(Map<String, dynamic> json) {
    return CaseBodyReferencePoint(
        bodyPositionId: '${json['BodyPositionID']}',
        id: '${json['ID']}',
        fidsId: '${json['FidsID']}',
        bodyId: '${json['BodyID']}',
        referenceDetail: json['ReferenceDetail'] ?? '',
        referenceID1: '${json['ReferenceID1']}',
        referenceDistance1: '${json['ReferenceDistance1']}',
        referenceUnitId1: '${json['ReferenceUnitID1']}',
        referenceID2: '${json['ReferenceID2']}',
        referenceDistance2: '${json['ReferenceDistance2']}',
        referenceUnitId2: '${json['ReferenceUnitID2']}',
        createDate: json['CreateDate'] ?? '',
        createBy: json['CreateBy'] ?? '',
        updateDate: json['UpdateDate'] ?? '',
        updateBy: json['UpdateBy'] ?? '',
        activeFlag: '${json['ActiveFlag']}');
  }

  factory CaseBodyReferencePoint.fromApi(Map<String, dynamic> json) {
    return CaseBodyReferencePoint(
        bodyPositionId: json['BodyPositionID'] ?? '',
        id: json['id'] ?? '',
        referenceDetail: json['reference_detail'] ?? '',
        referenceID1: json['reference_id1'] ?? '',
        referenceDistance1: json['reference_distance1'] ?? '',
        referenceUnitId1: json['reference_unit_id1'] ?? '',
        referenceID2: json['reference_id2'] ?? '',
        referenceDistance2: json['reference_distance2'] ?? '',
        referenceUnitId2: json['reference_unit_id2'] ?? '');
  }

  Map toJson() => {
        'body_position_id':
            bodyPositionId == '-2' || id == null ? '' : '$bodyPositionId',
        'id': id == '-2' || id == null ? '' : '$id',
        'reference_detail': referenceDetail ?? '',
        'reference_id1':
            referenceID1 == '-2' || referenceID1 == null ? '' : '$referenceID1',
        'reference_distance1': referenceDistance1 ?? '',
        'reference_unit_id1':
            referenceUnitId1 == '-2' || referenceUnitId1 == null
                ? ''
                : '$referenceUnitId1',
        'reference_id2':
            referenceID2 == '-2' || referenceID2 == null ? '' : '$referenceID2',
        'reference_distance2': referenceDistance2 ?? '',
        'reference_unit_id2':
            referenceUnitId2 == '-2' || referenceUnitId2 == null
                ? ''
                : '$referenceUnitId2',
      };

  @override
  String toString() {
    return 'CaseBodyReferencePoint(bodyPositionId: $bodyPositionId, id: $id, fidsId: $fidsId, bodyId: $bodyId, referenceDetail: $referenceDetail, referenceID1: $referenceID1, referenceDistance1: $referenceDistance1, referenceUnitId1: $referenceUnitId1, referenceID2: $referenceID2, referenceDistance2: $referenceDistance2, referenceUnitId2: $referenceUnitId2, createDate: $createDate, createBy: $createBy, updateDate: $updateDate, updateBy: $updateBy, activeFlag: $activeFlag)';
  }
}

class CaseBodyReferencePointDao {
  Future<void> createCaseBodyReferencePoint(
      int fidsId,
      int bodyId,
      String? referenceDetail,
      int referenceID1,
      double referenceDistance1,
      int referenceUnitId1,
      int referenceID2,
      double referenceDistance2,
      int referenceUnitId2,
      String? bodyPositionId,
      String? createDate,
      String? createBy,
      String? updateDate,
      String? updateBy,
      int activeFlag) async {
    final db = await DBProvider.db.database;
    await db.rawInsert('''
      INSERT INTO CaseBodyReferencePoint (
        FidsID,BodyID,ReferenceDetail,ReferenceID1,ReferenceDistance1,ReferenceUnitID1,ReferenceID2,ReferenceDistance2,ReferenceUnitID2,BodyPositionID,CreateDate,CreateBy,UpdateDate,UpdateBy,ActiveFlag
      ) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)
    ''', [
      fidsId,
      bodyId,
      referenceDetail,
      referenceID1,
      referenceDistance1,
      referenceUnitId1,
      referenceID2,
      referenceDistance2,
      referenceUnitId2,
      bodyPositionId,
      createDate,
      createBy,
      updateDate,
      updateBy,
      activeFlag
    ]);
  }

  Future<void> updateCaseBodyReferencePoint(
      int fidsId,
      int bodyId,
      String? referenceDetail,
      int referenceID1,
      double referenceDistance1,
      int referenceUnitId1,
      int referenceID2,
      double referenceDistance2,
      int referenceUnitId2,
      String? bodyPositionId,
      String? createDate,
      String? createBy,
      String? updateDate,
      String? updateBy,
      int activeFlag,
      int id) async {
    final db = await DBProvider.db.database;

    // if bodyId == null{

    // }

    await db.rawUpdate('''
      UPDATE CaseBodyReferencePoint SET
        FidsID = ?, BodyID = ?, ReferenceDetail = ?, ReferenceID1 = ?, ReferenceDistance1 = ?, ReferenceUnitID1 = ?, ReferenceID2 = ?, ReferenceDistance2 = ?, ReferenceUnitID2 = ?,BodyPositionID = ?, CreateDate = ?, CreateBy = ?, UpdateDate = ?, UpdateBy = ?, ActiveFlag = ? WHERE ID = ?
    ''', [
      fidsId,
      bodyId,
      referenceDetail,
      referenceID1,
      referenceDistance1,
      referenceUnitId1,
      referenceID2,
      referenceDistance2,
      referenceUnitId2,
      bodyPositionId,
      createDate,
      createBy,
      updateDate,
      updateBy,
      activeFlag,
      id
    ]);
  }

  Future<void> deleteCaseBodyReferencePointFidsID(int id) async {
    final db = await DBProvider.db.database;
    await db.rawDelete('''
      DELETE FROM CaseBodyReferencePoint WHERE FidsID = ?
    ''', [id]);
  }

  Future<List<CaseBodyReferencePoint>> getCaseBodyReferencePoint(
      int fidsID) async {
    final db = await DBProvider.db.database;
    var res = await db.query("CaseBodyReferencePoint",
        where: '"FidsID" = ?', whereArgs: ['$fidsID']);
    if (res.isEmpty) {
      return [];
    } else {
      var result = await db.query("CaseBodyReferencePoint",
          where: '"FidsID" = ?', whereArgs: ['$fidsID']);

      List<CaseBodyReferencePoint> listResult = [];
      // print('result : ${result.toString()}');
      //FidsCrimeScene response = FidsCrimeScene.fromJson(result[0]);

      for (int i = 0; i < result.length; i++) {
        Map<String, dynamic> res = result[i];
        CaseBodyReferencePoint formResponse =
            CaseBodyReferencePoint.fromJson(res);
        listResult.add(formResponse);
      }
      return listResult;
    }
  }

  Future<List<CaseBodyReferencePoint>> getCaseBodyReferencePointById(
      String? bodyID) async {
    final db = await DBProvider.db.database;
    var res = await db.query("CaseBodyReferencePoint");
    if (res.isEmpty) {
      return [];
    } else {
      var result = await db.query("CaseBodyReferencePoint",
          where: '"BodyID" = ?', whereArgs: ['$bodyID']);
      List<CaseBodyReferencePoint> listResult = [];

      for (int i = 0; i < result.length; i++) {
        Map<String, dynamic> res = result[i];
        CaseBodyReferencePoint formResponse =
            CaseBodyReferencePoint.fromJson(res);
        listResult.add(formResponse);
      }

      return listResult;
    }
  }

  Future<void> deleteCaseBodyReferencePointBy(String id) async {
    final db = await DBProvider.db.database;

    await db.rawDelete('''
      DELETE FROM CaseBodyReferencePoint WHERE ID = ?
    ''', [id]);
    if (kDebugMode) {
      print('DELETE Success');
    }
  }

  Future<void> deleteAllCaseBodyReferencePoint(String bodyId) async {
    final db = await DBProvider.db.database;

    await db.rawDelete('''
      DELETE FROM CaseBodyReferencePoint WHERE BodyID = ?
    ''', [bodyId]);
    if (kDebugMode) {
      print('DELETE Success');
    }
  }
}
