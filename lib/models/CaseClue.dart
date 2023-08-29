// ignore_for_file: file_names

import 'package:flutter/foundation.dart';

import '../../utils/database/database.dart';

class CaseClue {
  String? id;
  String? fidsId;
  String? caseClueId;
  String? isoIsClue;
  String? clueTypeDetail;
  String? isDoor;
  String? doorDetail;
  String? isWindows;
  String? windowsDetail;
  String? isCelling;
  String? cellingDetail;
  String? isRoof;
  String? roofDetail;
  String? isClueOther;
  String? clueOtherDetail;
  String? isTools1;
  String? tools1Detail;
  String? isTools2;
  String? tools2Detail;
  String? isTools3;
  String? tools3Detail;
  String? isTools4;
  String? tools4Detail;
  String? width;
  String? widthUnitID;
  String? labelNo;
  String? villainEntrance;
  CaseClue(
      this.id,
      this.fidsId,
      this.caseClueId,
      this.isoIsClue,
      this.clueTypeDetail,
      this.isDoor,
      this.doorDetail,
      this.isWindows,
      this.windowsDetail,
      this.isCelling,
      this.cellingDetail,
      this.isRoof,
      this.roofDetail,
      this.isClueOther,
      this.clueOtherDetail,
      this.isTools1,
      this.tools1Detail,
      this.isTools2,
      this.tools2Detail,
      this.isTools3,
      this.tools3Detail,
      this.isTools4,
      this.tools4Detail,
      this.width,
      this.widthUnitID,
      this.labelNo,
      this.villainEntrance);

  @override
  String toString() {
    return 'CaseClue{id: $id,fidsId: $fidsId,caseClueId: $caseClueId, clueTypeDetail: $clueTypeDetail, isDoor: $isDoor, doorDetail: $doorDetail, isWindows: $isWindows, windowsDetail: $windowsDetail, isCelling: $isCelling, cellingDetail: $cellingDetail, isRoof: $isRoof, roofDetail: $roofDetail, isClueOther: $isClueOther, clueOtherDetail: $clueOtherDetail, isTools1: $isTools1, tools1Detail: $tools1Detail, isTools2: $isTools2, tools2Detail: $tools2Detail, isTools3: $isTools3, tools3Detail: $tools3Detail, isTools4: $isTools4, tools4Detail: $tools4Detail, width: $width, widthUnitID: $widthUnitID, VillainEntrance: $villainEntrance}';
  }

  Map toJson() => {
        'id': id,
        'fidsId': fidsId,
        'case_clue_id': caseClueId,
        'clue_type_detail': clueTypeDetail,
        'is_door': isDoor == null || isDoor == '-1' ? '' : isDoor,
        'door_detail': doorDetail,
        'is_windows': isWindows == null || isWindows == '-1' ? '' : isWindows,
        'windows_detail': windowsDetail,
        'is_celling': isCelling == null || isCelling == '-1' ? '' : isCelling,
        'celling_detail': cellingDetail,
        'is_roof': isRoof == null || isRoof == '-1' ? '' : isRoof,
        'roof_detail': roofDetail,
        'is_clue_other':
            isClueOther == null || isClueOther == '-1' ? '' : isClueOther,
        'clue_other_detail': clueOtherDetail,
        'is_tools1': isTools1 == null || isTools1 == '-1' ? '' : isTools1,
        'tools1_detail': tools1Detail,
        'is_tools2': isTools2 == null || isTools2 == '-1' ? '' : isTools2,
        'tools2_detail': tools2Detail,
        'is_tools3': isTools3 == null || isTools3 == '-1' ? '' : isTools3,
        'tools3_detail': tools3Detail,
        'is_tools4': isTools4 == null || isTools4 == '-1' ? '' : isTools4,
        'tools4_detail': tools4Detail,
        'width': width,
        'width_unit_id': widthUnitID,
        'iso_IsClue': isoIsClue == null || isoIsClue == '-1' ? '' : isoIsClue,
        'label_no': labelNo,
        'villain_entrance': villainEntrance
      };

  factory CaseClue.fromJson(Map<String, dynamic> json) {
    return CaseClue(
        '${json['ID']}',
        '${json['FidsID']}',
        json['ClueTypeID'],
        json['Iso_IsClue'],
        json['ClueTypeDetail'],
        json['IsDoor'],
        json['DoorDetail'],
        json['IsWindows'],
        json['WindowsDetail'],
        json['IsCelling'],
        json['CellingDetail'],
        json['IsRoof'],
        json['RoofDetail'],
        json['IsClueOther'],
        json['ClueOtherDetail'],
        json['IsTools1'],
        json['Tools1Detail'],
        json['IsTools2'],
        json['Tools2Detail'],
        json['IsTools3'],
        json['Tools3Detail'],
        json['IsTools4'],
        json['Tools4Detail'],
        json['Width'],
        json['WidthUnitID'],
        json['LabelNo'],
        json['VillainEntrance']);
  }
}

class CaseClueDao {
  Future<dynamic> createCaseClueDao(
    int fidsId,
    String? caseClueId,
    String? isoIsClue,
    String? clueTypeDetail,
    String? isDoor,
    String? doorDetail,
    String? isWindows,
    String? windowsDetail,
    String? isCelling,
    String? cellingDetail,
    String? isRoof,
    String? roofDetail,
    String? isClueOther,
    String? clueOtherDetail,
    String? isTools1,
    String? tools1Detail,
    String? isTools2,
    String? tools2Detail,
    String? isTools3,
    String? tools3Detail,
    String? isTools4,
    String? tools4Detail,
    String? width,
    String? widthUnitID,
    String? labelNo,
    String? villainEntrance,
  ) async {
    final db = await DBProvider.db.database;

    var res = await db.rawInsert('''
      INSERT INTO CaseClue (
        FidsID,ClueTypeID,Iso_IsClue,ClueTypeDetail,IsDoor,DoorDetail,IsWindows,
        WindowsDetail,IsCelling,CellingDetail,IsRoof,RoofDetail,
        IsClueOther,ClueOtherDetail,IsTools1,Tools1Detail,
        IsTools2,Tools2Detail,IsTools3,Tools3Detail,IsTools4,Tools4Detail,Width,WidthUnitID,LabelNo,VillainEntrance
      ) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)
    ''', [
      fidsId,
      caseClueId,
      isoIsClue,
      clueTypeDetail,
      isDoor,
      doorDetail,
      isWindows,
      windowsDetail,
      isCelling,
      cellingDetail,
      isRoof,
      roofDetail,
      isClueOther,
      clueOtherDetail,
      isTools1,
      tools1Detail,
      isTools2,
      tools2Detail,
      isTools3,
      tools3Detail,
      isTools4,
      tools4Detail,
      width,
      widthUnitID,
      labelNo,
      villainEntrance
    ]);
    return res;
  }

  Future<dynamic> updateCaseClueDao(
      String? caseClueId,
      String? isoIsClue,
      String? clueTypeDetail,
      String? isDoor,
      String? doorDetail,
      String? isWindows,
      String? windowsDetail,
      String? isCelling,
      String? cellingDetail,
      String? isRoof,
      String? roofDetail,
      String? isClueOther,
      String? clueOtherDetail,
      String? isTools1,
      String? tools1Detail,
      String? isTools2,
      String? tools2Detail,
      String? isTools3,
      String? tools3Detail,
      String? isTools4,
      String? tools4Detail,
      String? width,
      String? widthUnitID,
      String? labelNo,
      String? villainEntrance,
      String? id) async {
    final db = await DBProvider.db.database;
    var res = await db.rawUpdate('''
      UPDATE CaseClue SET
        ClueTypeID = ?,Iso_IsClue = ?, ClueTypeDetail = ?, IsDoor = ?, DoorDetail = ?, IsWindows = ?, WindowsDetail = ?, IsCelling = ? , CellingDetail = ? , IsRoof = ? , RoofDetail = ?,IsClueOther = ?, ClueOtherDetail = ?, IsTools1 = ?, Tools1Detail = ?, IsTools2 = ?, Tools2Detail = ?, IsTools3 = ?, Tools3Detail = ?, IsTools4 = ?, Tools4Detail = ?, Width = ?, WidthUnitID = ?, LabelNo = ?,VillainEntrance = ?  WHERE ID = ?
    ''', [
      caseClueId,
      isoIsClue,
      clueTypeDetail,
      isDoor,
      doorDetail,
      isWindows,
      windowsDetail,
      isCelling,
      cellingDetail,
      isRoof,
      roofDetail,
      isClueOther,
      clueOtherDetail,
      isTools1,
      tools1Detail,
      isTools2,
      tools2Detail,
      isTools3,
      tools3Detail,
      isTools4,
      tools4Detail,
      width,
      widthUnitID,
      labelNo,
      villainEntrance,
      id
    ]);
    return res;
  }

  Future<List<CaseClue>> getCaseClue(int fidsID) async {
    final db = await DBProvider.db.database;
    var res = await db.query("CaseClue");
    if (res.isEmpty) {
      return [];
    } else {
      var result = await db
          .query("CaseClue", where: '"FidsID" = ?', whereArgs: ['$fidsID']);

      List<CaseClue> listResult = [];

      for (int i = 0; i < result.length; i++) {
        Map<String, dynamic> res = result[i];
        CaseClue formResponse = CaseClue.fromJson(res);
        listResult.add(formResponse);
      }
      return listResult;
    }
  }

  Future<CaseClue?> getCaseClueById(String id) async {
    final db = await DBProvider.db.database;
    var res = await db.query("CaseClue", where: '"ID" = ?', whereArgs: [id]);
    if (res.isEmpty) {
      return null;
    } else {
      var result =
          await db.query("CaseClue", where: '"ID" = ?', whereArgs: [id]);
      CaseClue response = CaseClue.fromJson(result[0]);
      return response;
    }
  }

  Future<dynamic> deleteCaseClueById(String id) async {
    final db = await DBProvider.db.database;

    var res = await db.rawDelete('''
      DELETE FROM CaseClue WHERE ID = ?
    ''', [id]);
    if (kDebugMode) {
      print('DELETE Success');
    }
    return res;
  }

  Future<dynamic> delete(String id) async {
    final db = await DBProvider.db.database;

    var res = await db.rawDelete('''
      DELETE FROM CaseClue WHERE FidsID = ?
    ''', [id]);
    if (kDebugMode) {
      print('DELETE Success');
    }
    return res;
  }
}
