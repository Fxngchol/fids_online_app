// ignore_for_file: file_names
import 'package:flutter/foundation.dart';

import '../../utils/database/database.dart';

class CaseInspector {
  int? id;
  int? fidsId;
  String? titleId;
  String? firstname;
  String? lastname;
  String? positionID;
  String? positionOther;
  String? departmentID;
  String? subDepartmentID;
  String? orderID;

  CaseInspector(
      {this.id,
      this.fidsId,
      this.titleId,
      this.firstname,
      this.lastname,
      this.positionID,
      this.positionOther,
      this.departmentID,
      this.subDepartmentID,
      this.orderID});

  factory CaseInspector.fromJson(Map<dynamic, dynamic> json) {
    return CaseInspector(
        id: json['ID'],
        fidsId: json['FidsID'],
        titleId: json['TitleID'] ?? '',
        firstname: '${json['FirstName']}',
        lastname: json['LastName'] ?? '',
        positionID: json['PositionID'] ?? '',
        positionOther: json['PositionOther'] ?? '',
        departmentID: json['DepartmentID'] ?? '',
        orderID: json['OrderID'] ?? '',
        subDepartmentID: json['SubDepartmentID'] ?? '');
  }

  factory CaseInspector.fromApi(Map<String, dynamic> json) {
    return CaseInspector(
        id: int.parse(json['id']),
        titleId: json['titleId'] ?? '',
        firstname: json['firstname'] ?? '',
        lastname: json['lastname'] ?? '',
        positionID: json['position_id'] ?? '',
        positionOther: json['position_other'] ?? '',
        departmentID: json['department_id'] ?? '',
        orderID: json['order_id'] ?? '',
        subDepartmentID: json['sub_department_id'] ?? '');
  }

  Map toJson() => {
        'id': '$id',
        'titleId': titleId == '-2' || titleId == null ? '' : '$titleId',
        'firstname': firstname ?? '',
        'lastname': lastname ?? '',
        'position_id': positionID == null ? '' : '$positionID',
        'position_other': positionOther ?? '',
        'department_id': departmentID ?? '',
        'sub_department_id': subDepartmentID ?? '',
        'order_id': orderID ?? '',
      };

  @override
  String toString() {
    return 'CaseInspector(id: $id, orderID: $orderID, titleId: $titleId, firstname: $firstname, lastname: $lastname, positionID: $positionID, positionOther: $positionOther, departmentID: $departmentID ,subDepartmentID: $subDepartmentID)';
  }
}

class CaseInspectorDao {
  Future<dynamic> createCaseInspector(
      int fidsId,
      String? titleID,
      String? firstName,
      String? lastName,
      String? positionID,
      String? positionOther,
      String? departmentID,
      String? subDepartmentID) async {
    if (kDebugMode) {
      print('createCaseInspector');
    }
    final db = await DBProvider.db.database;

    var res = await db.rawInsert('''
      INSERT INTO CaseInspector (
        FidsID,TitleID,FirstName,LastName,PositionID,PositionOther,DepartmentID,SubDepartmentID
      ) VALUES (?,?,?,?,?,?,?,?)
    ''', [
      fidsId,
      titleID,
      firstName,
      lastName,
      positionID,
      positionOther,
      departmentID,
      subDepartmentID
    ]);
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

  Future<dynamic> updateOrderID(String orderID, String id) async {
    if (kDebugMode) {
      print('updateOrderID');
    }
    final db = await DBProvider.db.database;
    var res = await db.rawUpdate('''
      UPDATE CaseInspector SET
        OrderID = ? WHERE ID = ?
    ''', [orderID, id]);
    return res;
  }

  Future<dynamic> deleteCaseInspector(String id, int fidsId) async {
    final db = await DBProvider.db.database;

    var res = await db.rawDelete('''
      DELETE FROM CaseInspector WHERE ID = ?
    ''', [id]);

    var caseInspectorList = await CaseInspectorDao().getCaseInspector(fidsId);

    await delete(fidsId);

    for (int i = 0; i < caseInspectorList.length; i++) {
      await createCaseInspector(
          fidsId,
          caseInspectorList[i].titleId.toString(),
          caseInspectorList[i].firstname,
          caseInspectorList[i].lastname,
          caseInspectorList[i].positionID,
          caseInspectorList[i].positionOther,
          caseInspectorList[i].departmentID,
          caseInspectorList[i].subDepartmentID);
    }

    for (int i = 0; i < caseInspectorList.length; i++) {
      await updateOrderID(caseInspectorList[i].id.toString(),
          caseInspectorList[i].id.toString());
    }
    return res;
  }

  Future<List<CaseInspector>> getCaseInspector(int fidsID) async {
    final db = await DBProvider.db.database;
    var res = await db
        .query("CaseInspector", where: '"FidsID" = ?', whereArgs: ['$fidsID']);
    if (res.isEmpty) {
      return [];
    } else {
      // var result = await db.query("CaseInspector",
      //     where: '"FidsID" = ?', whereArgs: ['$fidsID']);

      var result = await db.query("CaseInspector",
          where: '"FidsID" = ?', whereArgs: ['$fidsID']);

      List<CaseInspector> listResult = [];
      for (int i = 0; i < result.length; i++) {
        Map<String, dynamic> res = result[i];
        CaseInspector formResponse = CaseInspector.fromJson(res);
        listResult.add(formResponse);
      }
      return listResult;
    }
  }

  Future<dynamic> delete(int fidsId) async {
    final db = await DBProvider.db.database;

    var res = await db.rawDelete('''
      DELETE FROM CaseInspector WHERE FidsID = ?
    ''', [fidsId]);
    if (kDebugMode) {
      print('DELETE Success');
    }
    return res;
  }

  Future<dynamic> deleteById(String id) async {
    final db = await DBProvider.db.database;

    var res = await db.rawDelete('''
      DELETE FROM CaseInspector WHERE ID = ?
    ''', [id]);
    if (kDebugMode) {
      print('DELETE Success');
    }

    return res;
  }
}
