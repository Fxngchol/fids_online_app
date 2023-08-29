// ignore_for_file: file_names
import 'package:flutter/foundation.dart';

import '../../utils/database/database.dart';

class CaseRansacked {
  String? id;
  int? preId;
  String? fidsId;
  String? isClue;
  String? areaDetail;
  String? detail;
  String? labelNo;
  String? ransackedTypeID;
  String? caseAssetAreaID;

  CaseRansacked(
      {this.id,
      this.preId,
      this.fidsId,
      this.isClue,
      this.areaDetail,
      this.detail,
      this.labelNo,
      this.ransackedTypeID,
      this.caseAssetAreaID});

  factory CaseRansacked.fromJson(Map<String, dynamic> json) {
    return CaseRansacked(
        id: '${json['ID']}',
        // fidsId: '${json['FidsID']}',
        isClue: json['IsClue'],
        areaDetail: json['AreaDetail'],
        detail: json['Detail'],
        labelNo: json['LabelNo'],
        ransackedTypeID: json['RansackedTypeID'],
        caseAssetAreaID: json['CaseAssetAreaID']);
  }

  Map toJson() => {
        'id': id == '-2' ? '' : '$id',
        'is_clue': isClue == null || isClue == '-1' ? '' : '$isClue',
        'area_detail': areaDetail == null ? '' : '$areaDetail',
        'detail': detail == null ? '' : '$detail',
        'label_no': labelNo == null ? '' : '$labelNo',
        'ransacked_type_id': ransackedTypeID == null ? '' : '$ransackedTypeID',
      };

  @override
  String toString() {
    return 'CaseRansacked(id: $id, preId: $preId, fidsId: $fidsId, isClue: $isClue, areaDetail: $areaDetail, detail: $detail, labelNo: $labelNo, ransackedTypeID: $ransackedTypeID, caseAssetAreaID: $caseAssetAreaID)';
  }
}

class CaseRansackedDao {
  Future<dynamic> createCaseRansacked(
      String? fidsId,
      String? isClue,
      String? areaDetail,
      String? detail,
      String? labelNo,
      String? ransackedTypeID,
      String? caseAssetAreaID) async {
    final db = await DBProvider.db.database;
    var res = await db.rawInsert('''
      INSERT INTO CaseRansacked (
        FidsID,IsClue,AreaDetail,Detail,LabelNo,RansackedTypeID,CaseAssetAreaID
      ) VALUES (?,?,?,?,?,?,?)
    ''', [
      fidsId,
      isClue,
      areaDetail,
      detail,
      labelNo,
      ransackedTypeID,
      caseAssetAreaID
    ]);

    return res;
  }

  Future<dynamic> updateCaseRansacked(
    String? fidsId,
    String? isClue,
    String? areaDetail,
    String? detail,
    String? labelNo,
    String? ransackedTypeID,
    String? caseAssetAreaID,
  ) async {
    final db = await DBProvider.db.database;
    var res = await db.rawUpdate('''
      UPDATE CaseRansacked SET
        FidsID = ?, IsClue = ?, AreaDetail = ? , Detail = ?, LabelNo = ? , RansackedTypeID = ? WHERE ID = ?
    ''', [
      fidsId,
      isClue,
      areaDetail,
      detail,
      labelNo,
      ransackedTypeID,
      caseAssetAreaID
    ]);

    return res;
  }

  Future<dynamic> deleteCaseRansacked(String id) async {
    final db = await DBProvider.db.database;

    var res = await db.rawDelete('''
      DELETE FROM CaseRansacked WHERE ID = ?
    ''', [id]);
    return res;
  }

  Future<dynamic> deleteCaseRansackedAll(String id) async {
    final db = await DBProvider.db.database;

    var res = await db.rawDelete('''
      DELETE FROM CaseRansacked WHERE CaseAssetAreaID = ?
    ''', [id]);
    return res;
  }

  Future<List<CaseRansacked>> getCaseRansacked(String caseAssetAreaID) async {
    final db = await DBProvider.db.database;
    var res = await db.query("CaseRansacked",
        where: '"CaseAssetAreaID" = ?', whereArgs: [caseAssetAreaID]);
    if (res.isEmpty) {
      return [];
    } else {
      var result = await db.query("CaseRansacked",
          where: '"CaseAssetAreaID" = ?', whereArgs: [caseAssetAreaID]);
      List<CaseRansacked> listResult = [];
      for (int i = 0; i < result.length; i++) {
        CaseRansacked formResponse = CaseRansacked.fromJson(result[i]);
        listResult.add(formResponse);
      }

      return listResult;
    }
  }

  Future<dynamic> delete(int fidsId) async {
    final db = await DBProvider.db.database;

    var res = await db.rawDelete('''
      DELETE FROM CaseRansacked WHERE FidsID = ?
    ''', [fidsId]);
    if (kDebugMode) {
      print('DELETE Success');
    }
    return res;
  }

  Future<void> insertCheck(
      CaseRansacked caseRansacked, String caseAssetAreaId) async {
    final db = await DBProvider.db.database;

    var result = await db.query("CaseRansacked",
        where: '"CaseAssetAreaID" = ?', whereArgs: [caseAssetAreaId]);

    bool isAdd = false;
    if (result.isEmpty) {
    } else {
      for (int i = 0; i < result.length; i++) {
        CaseRansacked formResponse = CaseRansacked.fromJson(result[i]);
        if ('${formResponse.id}' == '${caseRansacked.id}') {
          isAdd = true;
        }
      }
    }

    if (isAdd) {
      if (kDebugMode) {
        print('updateCaseRansacked');
      }
      await updateCaseRansacked(
          caseRansacked.fidsId,
          caseRansacked.isClue,
          caseRansacked.areaDetail,
          caseRansacked.detail,
          caseRansacked.labelNo,
          caseRansacked.ransackedTypeID,
          caseRansacked.id);
    } else {
      if (kDebugMode) {
        print('createCaseRansacked');
      }

      await createCaseRansacked(
          caseRansacked.fidsId,
          caseRansacked.isClue,
          caseRansacked.areaDetail,
          caseRansacked.detail,
          caseRansacked.labelNo,
          caseRansacked.ransackedTypeID,
          caseAssetAreaId);
    }

    return;
  }
}
