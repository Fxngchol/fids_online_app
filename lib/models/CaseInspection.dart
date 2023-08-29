// ignore_for_file: file_names
import 'package:flutter/foundation.dart';

import '../../utils/database/database.dart';

class CaseInspection {
  String? id;
  String? inspectDate;
  String? inspectTime;
  String? activeFlag;
  String? fidsId;

  CaseInspection(
      {this.id,
      this.inspectDate,
      this.inspectTime,
      this.activeFlag,
      this.fidsId});

  factory CaseInspection.fromApi(Map<String, dynamic> json) {
    return CaseInspection(
        id: json['id'] ?? '',
        inspectDate: json['inspect_date'] ?? '',
        inspectTime: json['inspect_time'] ?? '');
  }

  factory CaseInspection.fromJson(Map<String, dynamic> json) {
    return CaseInspection(
        id: '${json['ID']}',
        inspectDate: json['InspectDate'] ?? '',
        inspectTime: json['InspectTime'] ?? '',
        activeFlag: '${json['ActiveFlag']}',
        fidsId: '${json['FidsID']}');
  }

  Map toJson() => {
        'id': id == '-2' || id == null ? '' : '$id',
        'inspect_date': inspectDate ?? '',
        'inspect_time': inspectTime ?? '',
      };

  @override
  String toString() {
    return 'CaseInspection(id: $id, inspectDate: $inspectDate, inspectTime: $inspectTime, activeFlag: $activeFlag, fidsId: $fidsId)';
  }
}

class CaseInspectionDao {
  Future<void> createCaseInspection(String inspectDate, String inspectTime,
      int activeFlag, int fidsId) async {
    final db = await DBProvider.db.database;
    await db.rawInsert('''
      INSERT INTO CaseInspection (
        InspectDate,InspectTime,ActiveFlag,FidsID
      ) VALUES (?,?,?,?)
    ''', [inspectDate, inspectTime, activeFlag, fidsId]);
  }

  Future<void> deleteCaseInspection(String id) async {
    final db = await DBProvider.db.database;

    await db.rawDelete('''
      DELETE FROM CaseInspection WHERE ID = ?
    ''', [id]);
  }

  Future<List<CaseInspection>> getCaseInspection(int fidsID) async {
    final db = await DBProvider.db.database;
    var res = await db
        .query("CaseInspection", where: '"FidsID" = ?', whereArgs: ['$fidsID']);
    if (res.isEmpty) {
      return [];
    } else {
      var result = await db.query("CaseInspection",
          where: '"FidsID" = ?', whereArgs: ['$fidsID']);

      List<CaseInspection> listResult = [];
      for (int i = 0; i < result.length; i++) {
        Map<String, dynamic> res = result[i];
        CaseInspection formResponse = CaseInspection.fromJson(res);
        listResult.add(formResponse);
      }
      return listResult;
    }
  }

  Future<void> delete(int fidsId) async {
    final db = await DBProvider.db.database;

    await db.rawDelete('''
      DELETE FROM CaseInspection WHERE FidsID = ?
    ''', [fidsId]);
    if (kDebugMode) {
      print('DELETE Success');
    }
  }
}
