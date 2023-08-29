// ignore_for_file: file_names
import 'package:flutter/foundation.dart';

import '../../utils/database/database.dart';

class CaseExhibit {
  int? id;
  int? fidsId;
  String? exhibitName;
  String? exhibitDetail;
  String? exhibitAmount;
  String? exhibitUnit;

  CaseExhibit({
    this.id,
    this.fidsId,
    this.exhibitName,
    this.exhibitDetail,
    this.exhibitAmount,
    this.exhibitUnit,
  });

  factory CaseExhibit.fromJson(Map<dynamic, dynamic> json) {
    return CaseExhibit(
        id: json['ID'],
        fidsId: json['FidsID'],
        exhibitName: '${json['ExhibitName']}',
        exhibitDetail: '${json['ExhibitDetail']}',
        exhibitAmount: json['ExhibitAmount'],
        exhibitUnit: json['ExhibitUnit']);
  }

  factory CaseExhibit.fromApi(Map<String, dynamic> json) {
    return CaseExhibit(
        id: json['id'],
        exhibitName: json['title_id'],
        exhibitDetail: json['exhibit_detail'],
        exhibitAmount: json['exhibit_amount'],
        exhibitUnit: json['exhibit_unit']);
  }

  Map toJson() => {
        'id': '$id',
        'exhibit_name':
            exhibitName == '' || exhibitName == null ? '' : '$exhibitName',
        'exhibit_detail':
            exhibitDetail == '' || exhibitDetail == null ? '' : exhibitDetail,
        'exhibit_amount':
            exhibitAmount == '' || exhibitAmount == null ? '' : exhibitAmount,
        'exhibit_unit': exhibitUnit == null ? '' : '$exhibitUnit',
      };

  @override
  String toString() {
    return 'CaseExhibit(id: $id, fidsId: $fidsId, exhibitName: $exhibitName, exhibitDetail: $exhibitDetail, exhibitAmount: $exhibitAmount, exhibitUnit: $exhibitUnit)';
  }
}

class CaseExhibitDao {
  Future<void> createCaseExhibit(
    int fidsId,
    String exhibitName,
    String exhibitDetail,
    String exhibitAmount,
    String exhibitUnit,
  ) async {
    final db = await DBProvider.db.database;

    await db.rawInsert('''
      INSERT INTO CaseExhibit (
        FidsID,ExhibitName,ExhibitDetail,ExhibitAmount,ExhibitUnit
      ) VALUES (?,?,?,?,?)
    ''', [
      fidsId,
      exhibitName,
      exhibitDetail,
      exhibitAmount,
      exhibitUnit,
    ]);
  }

  Future<void> deleteCaseExhibit(String id) async {
    final db = await DBProvider.db.database;

    await db.rawDelete('''
      DELETE FROM CaseExhibit WHERE ID = ?
    ''', [id]);
  }

  Future<List<CaseExhibit>> getCaseExhibit(int fidsID) async {
    final db = await DBProvider.db.database;
    var res = await db
        .query("CaseExhibit", where: '"FidsID" = ?', whereArgs: ['$fidsID']);
    if (res.isEmpty) {
      return [];
    } else {
      var result = await db
          .query("CaseExhibit", where: '"FidsID" = ?', whereArgs: ['$fidsID']);

      List<CaseExhibit> listResult = [];
      for (int i = 0; i < result.length; i++) {
        Map<String, dynamic> res = result[i];
        CaseExhibit formResponse = CaseExhibit.fromJson(res);
        listResult.add(formResponse);
      }
      return listResult;
    }
  }

  Future<CaseExhibit> getCaseExhibitById(int caseId, int relatepersonId) async {
    final db = await DBProvider.db.database;
    var res = await db.query("CaseExhibit");
    if (res.isEmpty) {
      return CaseExhibit();
    } else {
      var result = await db
          .query("CaseExhibit", where: '"FidsID" = ?', whereArgs: ['$caseId']);

      CaseExhibit caseExhibit = CaseExhibit();

      for (int i = 0; i < result.length; i++) {
        Map<String, dynamic> res = result[i];
        CaseExhibit formResponse = CaseExhibit.fromJson(res);
        if ('${formResponse.id}' == '$relatepersonId') {
          caseExhibit = formResponse;
          if (kDebugMode) {
            print('formResponseformResponse: $formResponse');
          }
          return caseExhibit;
        }
      }
      return caseExhibit;
    }
  }

  Future<void> delete(int fidsId) async {
    final db = await DBProvider.db.database;

    await db.rawDelete('''
      DELETE FROM CaseExhibit WHERE FidsID = ?
    ''', [fidsId]);
    if (kDebugMode) {
      print('DELETE Success');
    }
  }

  Future<void> deleteById(String id) async {
    final db = await DBProvider.db.database;
    await db.rawDelete('''
      DELETE FROM CaseExhibit WHERE ID = ?
    ''', [id]);
    if (kDebugMode) {
      print('DELETE Success');
    }
  }

  updateCaseExhibit(String exhibitName, String exhibitDetail,
      String exhibitAmount, String exhibitUnit, int id) async {
    final db = await DBProvider.db.database;

    var res = await db.rawUpdate('''
      UPDATE CaseExhibit SET  ExhibitName = ?, ExhibitDetail = ?, ExhibitAmount = ?,ExhibitUnit = ? WHERE ID = ?
    ''', [exhibitName, exhibitDetail, exhibitAmount, exhibitUnit, id]);
    return res;
  }
}
