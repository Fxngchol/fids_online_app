// ignore_for_file: file_names
import 'package:flutter/foundation.dart';

import '../../utils/database/database.dart';

class CaseInternal {
  String? id;
  String? floorNo;
  String? floorDetail;
  String? fidsId;
  String? createDate;
  String? createBy;
  String? updateDate;
  String? updateBy;
  String? activeFlag;

  CaseInternal(
      {this.id,
      this.floorNo,
      this.floorDetail,
      this.fidsId,
      this.createDate,
      this.createBy,
      this.updateDate,
      this.updateBy,
      this.activeFlag});

  factory CaseInternal.fromJson(Map<String, dynamic> json) {
    return CaseInternal(
      id: '${json['ID']}',
      floorNo: '${json['FloorNo']}',
      floorDetail: json['FloorDetail'] ?? '',
      fidsId: '${json['FidsID']}',
      activeFlag: '${json['ActiveFlag']}',
    );
  }

  factory CaseInternal.fromApi(Map<String, dynamic> json) {
    return CaseInternal(
      id: json['id'] ?? '',
      floorNo: json['floor_no'] ?? '',
      floorDetail: json['floor_detail'] ?? '',
    );
  }

  Map toJson() => {
        'id': id == '-2' || id == null ? '' : '$id',
        'floor_no': floorNo ?? '',
        'floor_detail': floorDetail ?? '',
      };

  //       @override
  // String toString() {
  //   return '{id: $id, fidsId: $fidsId, action: $action, fidsCrimeScene: $fidsCrimeScene}';
  // }

  @override
  String toString() {
    return 'CaseInternal(id: $id, floorNo: $floorNo, floorDetail: $floorDetail, fidsId: $fidsId, createDate: $createDate, createBy: $createBy, updateDate: $updateDate, updateBy: $updateBy, activeFlag: $activeFlag)';
  }
}

class CaseInternalDao {
  Future<dynamic> createCaseInternal(
      String? floorNo,
      String? floorDetail,
      int fidsId,
      String? createDate,
      String? createBy,
      String? updateDate,
      String? updateBy,
      int activeFlag) async {
    final db = await DBProvider.db.database;

    var res = await db.rawInsert('''
      INSERT INTO CaseInternal (
        FloorNo,FloorDetail,FidsID,CreateDate,CreateBy,UpdateDate,UpdateBy,ActiveFlag
      ) VALUES (?,?,?,?,?,?,?,?)
    ''', [
      floorNo,
      floorDetail,
      fidsId,
      createDate,
      createBy,
      updateDate,
      updateBy,
      activeFlag
    ]);
    return res;
  }

  Future<dynamic> updateCaseInternal(
      int fidsId, String floorNo, String floorDetail, int id) async {
    final db = await DBProvider.db.database;
    var res = await db.rawUpdate('''
      UPDATE CaseInternal SET
        FidsID = ? ,FloorNo = ? ,FloorDetail = ?  WHERE ID = ?
    ''', [fidsId, floorNo, floorDetail, id]);
    return res;
  }

  Future<dynamic> updateMyCaseInternal(
      String floorNo, String floorDetail, String id) async {
    final db = await DBProvider.db.database;
    var res = await db.rawUpdate('''
      UPDATE CaseInternal SET
        FloorNo = ?, FloorDetail = ? WHERE ID = ?
    ''', [floorNo, floorDetail, id]);

    return res;
  }

  Future<dynamic> updateCaseInspector(
      int fidsId,
      String? titleID,
      String? firstName,
      String? lastName,
      String? positionID,
      String? positionOther,
      String? departmentID,
      String? subDepartmentID,
      String? id) async {
    final db = await DBProvider.db.database;
    var res = await db.rawUpdate('''
      UPDATE CaseInspector SET
        FidsID = ? ,TitleID = ? ,FirstName = ? ,LastName = ?,PositionID = ?,PositionOther = ? ,DepartmentID = ? ,SubDepartmentID = ? WHERE ID = ?
    ''', [
      fidsId,
      titleID,
      firstName,
      lastName,
      positionID,
      positionOther,
      departmentID,
      subDepartmentID,
      id
    ]);

    return res;
  }

  Future<List<CaseInternal>> getCaseInternal(int fidsID) async {
    final db = await DBProvider.db.database;
    var res = await db
        .query("CaseInternal", where: '"FidsID" = ?', whereArgs: ['$fidsID']);
    if (res.isEmpty) {
      if (kDebugMode) {
        print('res.length ==0');
      }
      return [];
    } else {
      // var result = await db.query("CaseInspector",
      //     where: '"FidsID" = ?', whereArgs: ['$fidsID']);

      var result = await db
          .query("CaseInternal", where: '"FidsID" = ?', whereArgs: ['$fidsID']);

      List<CaseInternal> listResult = [];
      if (kDebugMode) {
        print('result : ${result.toString()}');
      }
      // CaseInspector response = CaseInspector.fromJson(result[0]);

      for (int i = 0; i < result.length; i++) {
        Map<String, dynamic> res = result[i];
        CaseInternal formResponse = CaseInternal.fromJson(res);
        listResult.add(formResponse);
      }
      return listResult;
    }
  }

  Future<CaseInternal> getCaseInternalById(String id) async {
    final db = await DBProvider.db.database;
    var res = await db.query("CaseInternal");
    if (res.isEmpty) {
      return CaseInternal();
    } else {
      var result = await db.query("CaseInternal");
      for (int i = 0; i < result.length; i++) {
        Map<String, dynamic> res = result[i];
        CaseInternal formResponse = CaseInternal.fromJson(res);
        if (id == '${formResponse.id}') {
          return formResponse;
        }
      }
      return CaseInternal();
    }
  }

  Future<dynamic> delete(int fidsId) async {
    final db = await DBProvider.db.database;

    var res = await db.rawDelete('''
      DELETE FROM CaseInternal WHERE FidsID = ?
    ''', [fidsId]);
    if (kDebugMode) {
      print('DELETE Success');
    }
    return res;
  }

  Future<dynamic> deleteById(String id) async {
    final db = await DBProvider.db.database;

    var res = await db.rawDelete('''
      DELETE FROM CaseInternal WHERE ID = ?
    ''', [id]);
    if (kDebugMode) {
      print('DELETE Success');
    }
    return res;
  }
}
