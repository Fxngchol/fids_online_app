// ignore_for_file: file_names
import 'package:flutter/foundation.dart';

import '../../utils/database/database.dart';
import 'CaseAreaClue.dart';
import 'CaseRansacked.dart';

class CaseAssetArea {
  String? id;
  String? fidsId;
  String? area;

  CaseAreaClue? caseAreaClues;
  List<CaseRansacked>? caseRansackeds = [];
  List<CaseAreaClue>? caseAreaCluesArray = [];

  CaseAssetArea(
      {this.id,
      this.fidsId,
      this.area,
      this.caseAreaClues,
      this.caseRansackeds});

  factory CaseAssetArea.fromJson(Map<String, dynamic> json) {
    return CaseAssetArea(
      id: '${json['ID']}',
      fidsId: '${json['FidsID']}',
      area: json['Area'],
      // isClue: '${json['IsClue']}' == '-1' ? '' : '${json['IsClue']}',
      // isLock: '${json['IsLock']}' == '-1' ? '' : '${json['IsLock']}',
    );
  }

  Map toJson() => {
        'id': id == '-2' ? '' : '$id',
        'area': area ?? '',
        // 'is_clue': isClue == null ? '' : '$isClue',
        // 'is_lock': isLock == null ? '' : '$isLock',
        'case_area_clue': caseAreaCluesArray,
        'case_ransackeds': caseRansackeds
      };

  @override
  String toString() {
    return 'CaseAssetArea(id: $id, fidsId: $fidsId, area: $area, caseAreaClues: $caseAreaClues, caseRansackeds: $caseRansackeds)';
  }
}

class CaseAssetAreaDao {
  Future<dynamic> createCaseAssetArea(String? fidsId, String? area) async {
    final db = await DBProvider.db.database;
    var res = await db.rawInsert('''
      INSERT INTO CaseAssetArea (
        FidsID,Area
      ) VALUES (?,?)
    ''', [
      fidsId,
      area,
    ]);

    return res;
  }

  Future<dynamic> updateCaseAssetArea(
      String? fidsId, String? area, String? id) async {
    final db = await DBProvider.db.database;
    var res = await db.rawUpdate('''
      UPDATE CaseAssetArea SET
        FidsID = ?, Area = ? WHERE ID = ?
    ''', [fidsId, area, id]);

    return res;
  }

  Future<dynamic> deleteCaseAssetArea(String? id) async {
    final db = await DBProvider.db.database;

    var res = await db.rawDelete('''
      DELETE FROM CaseAssetArea WHERE ID = ?
    ''', [id]);
    return res;
  }

  Future<List<CaseAssetArea>> getCaseAssetArea(int fidsID) async {
    final db = await DBProvider.db.database;
    var res = await db
        .query("CaseAssetArea", where: '"FidsID" = ?', whereArgs: ['$fidsID']);
    if (res.isEmpty) {
      return [];
    } else {
      var result = await db.query("CaseAssetArea",
          where: '"FidsID" = ?', whereArgs: ['$fidsID']);
      List<CaseAssetArea> listResult = [];
      for (int i = 0; i < result.length; i++) {
        // Map<String?, dynamic> res = result[i];
        CaseAssetArea formResponse = CaseAssetArea.fromJson(result[i]);

        var caseAreaC =
            await CaseAreaClueDao().getCaseAreaClue(formResponse.id);
        formResponse.caseAreaClues = caseAreaC;
        List<CaseAreaClue> arrList = [];
        arrList.add(caseAreaC);
        formResponse.caseAreaCluesArray = arrList;

        // print(
        //     'formResponse.caseAreaClues : ${formResponse.caseAreaClues.length}');

        var caseRa =
            await CaseRansackedDao().getCaseRansacked(formResponse.id ?? '');
        formResponse.caseRansackeds = caseRa;
        if (kDebugMode) {
          print(
              'formResponse.caseRansackeds : ${formResponse.caseRansackeds?.length}');
        }
        listResult.add(formResponse);
      }

      return listResult;
    }
  }

  Future<CaseAssetArea> getCaseAssetAreaById(String? id) async {
    final db = await DBProvider.db.database;
    var res =
        await db.query("CaseAssetArea", where: '"ID" = ?', whereArgs: ['$id']);
    if (res.isEmpty) {
      return CaseAssetArea();
    } else {
      var result = await db
          .query("CaseAssetArea", where: '"ID" = ?', whereArgs: ['$id']);
      CaseAssetArea caseAssetArea = CaseAssetArea();
      for (int i = 0; i < result.length; i++) {
        // Map<String?, dynamic> res = result[i];
        CaseAssetArea formResponse = CaseAssetArea.fromJson(result[i]);

        var caseAreaC =
            await CaseAreaClueDao().getCaseAreaClue(formResponse.id);
        formResponse.caseAreaClues = caseAreaC;
        // print(
        //     'formResponse.caseAreaClues : ${formResponse.caseAreaClues.length}');

        var caseRa =
            await CaseRansackedDao().getCaseRansacked(formResponse.id ?? '');
        formResponse.caseRansackeds = caseRa;
        caseAssetArea = formResponse;
        // print(
        //     'formResponse.caseRansackeds : ${formResponse.caseRansackeds.length}');
        // listResult.add(formResponse);
      }

      return caseAssetArea;
    }
  }

  Future<dynamic> delete(int fidsId) async {
    final db = await DBProvider.db.database;

    var res = await db.rawDelete('''
      DELETE FROM CaseAssetArea WHERE FidsID = ?
    ''', [fidsId]);
    if (kDebugMode) {
      print('DELETE Success');
    }
    return res;
  }
}
