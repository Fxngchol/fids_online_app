// ignore_for_file: file_names
import 'package:flutter/foundation.dart';

import '../../utils/database/database.dart';

class CaseAreaClue {
  String? id;
  String? fidsId;
  String? isClue;
  String? clueTypeID;
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
  String? labelNo;
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
  int? caseAssetAreaID;
  String? villainEntrance;
  CaseAreaClue(
      {this.id,
      this.fidsId,
      this.isClue,
      this.clueTypeID,
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
      this.caseAssetAreaID,
      this.labelNo,
      this.villainEntrance});

  factory CaseAreaClue.fromJson(Map<String?, dynamic> json) {
    return CaseAreaClue(
        id: '${json['ID']}',
        fidsId: '${json['FidsID']}',
        isClue: '${json['IsClue']}',
        clueTypeID: '${json['ClueTypeID']}',
        clueTypeDetail: json['ClueTypeDetail'],
        isDoor: '${json['IsDoor']}' == '-1' ? '' : '${json['IsDoor']}',
        doorDetail: json['DoorDetail'],
        isWindows: '${json['IsWindows']}' == '-1' ? '' : '${json['IsWindows']}',
        windowsDetail: json['WindowsDetail'],
        isCelling: '${json['IsCelling']}' == '-1' ? '' : '${json['IsCelling']}',
        cellingDetail: json['CellingDetail'],
        isRoof: '${json['IsRoof']}' == '-1' ? '' : '${json['IsRoof']}',
        roofDetail: json['RoofDetail'],
        isClueOther:
            '${json['IsClueOther']}' == '-1' ? '' : '${json['IsClueOther']}',
        clueOtherDetail: json['ClueOtherDetail'],
        isTools1: '${json['IsTools1']}' == '-1' ? '' : '${json['IsTools1']}',
        tools1Detail: json['Tools1Detail'],
        isTools2: '${json['IsTools2']}' == '-1' ? '' : '${json['IsTools2']}',
        tools2Detail: json['Tools2Detail'],
        isTools3: '${json['IsTools3']}' == '-1' ? '' : '${json['IsTools3']}',
        tools3Detail: json['Tools3Detail'],
        isTools4: '${json['IsTools4']}' == '-1' ? '' : '${json['IsTools4']}',
        tools4Detail: json['Tools4Detail'],
        width: json['Width'],
        widthUnitID: '${json['WidthUnitID']}',
        labelNo: '${json['LabelNo']}',
        villainEntrance: '${json['VillainEntrance']}',
        caseAssetAreaID: json['CaseAssetAreaID']);
  }

  Map toJson() => {
        'id': id == '-2' || id == null || id == 'null' ? '' : '$id',
        'clueTypeID': clueTypeID == null ? '' : '$clueTypeID',
        'is_clue': isClue == null ? '' : '$isClue',
        'clueType_detail': clueTypeDetail == null ? '' : '$clueTypeDetail',
        'is_door': isDoor == null ? '' : '$isDoor',
        'door_detail': doorDetail == null ? '' : '$doorDetail',
        'is_windows': isWindows == null ? '' : '$isWindows',
        'windows_detail': windowsDetail == null ? '' : '$windowsDetail',
        'is_celling': isCelling == null ? '' : '$isCelling',
        'celling_detail': cellingDetail == null ? '' : '$cellingDetail',
        'is_roof': isRoof == null ? '' : '$isRoof',
        'roof_detail': roofDetail == null ? '' : '$roofDetail',
        'is_clueOther': isClueOther == null ? '' : '$isClueOther',
        'clueOther_detail': clueOtherDetail == null ? '' : '$clueOtherDetail',
        'is_tools1': isTools1 == null ? '' : '$isTools1',
        'tools1_detail': tools1Detail == null ? '' : '$tools1Detail',
        'is_tools2': isTools2 == null ? '' : '$isTools2',
        'tools2_detail': tools2Detail == null ? '' : '$tools2Detail',
        'is_tools3': isTools3 == null ? '' : '$isTools3',
        'tools3_detail': tools3Detail == null ? '' : '$tools3Detail',
        'is_tools4': isTools4 == null ? '' : '$isTools4',
        'tools4_detail': tools4Detail == null ? '' : '$tools4Detail',
        'width': width == null ? '' : '$width',
        'label_no': labelNo == null ? '' : '$labelNo',
        'width_unit_id': widthUnitID == null ? '' : '$widthUnitID',
        'villain_entrance': villainEntrance == null ? '' : '$villainEntrance',
      };

  @override
  String toString() {
    return 'CaseAreaClue{id: $id, fidsId: $fidsId, isClue: $isClue, clueTypeID: $clueTypeID, clueTypeDetail: $clueTypeDetail, isDoor: $isDoor, doorDetail: $doorDetail, isWindows: $isWindows, windowsDetail: $windowsDetail, isCelling: $isCelling, cellingDetail: $cellingDetail, isRoof: $isRoof, roofDetail: $roofDetail, isClueOther: $isClueOther, clueOtherDetail: $clueOtherDetail, isTools1: $isTools1, tools1Detail: $tools1Detail, isTools2: $isTools2, tools2Detail: $tools2Detail, isTools3: $isTools3, tools3Detail: $tools3Detail, isTools4: $isTools4, tools4Detail: $tools4Detail, width: $width, widthUnitID: $widthUnitID, caseAssetAreaID: $caseAssetAreaID,labelNo: $labelNo, villainEntrance: $villainEntrance}';
  }
}

class CaseAreaClueDao {
  createCaseAreaClue(
    String? fidsId,
    String? isClue,
    String? clueTypeID,
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
    String? labelNo,
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
    int caseAssetAreaID,
    String? villainEntrance,
  ) async {
    final db = await DBProvider.db.database;
    var res = await db.rawInsert('''
      INSERT INTO CaseAreaClue (
        FidsID,IsClue,ClueTypeID,ClueTypeDetail,IsDoor,DoorDetail,IsWindows,WindowsDetail,IsCelling,
        CellingDetail,IsRoof,VillainEntrance,RoofDetail,IsClueOther,ClueOtherDetail,labelNo,IsTools1,Tools1Detail,
        IsTools2,Tools2Detail,IsTools3,Tools3Detail,IsTools4,Tools4Detail,Width,WidthUnitID,CaseAssetAreaID
      ) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)
    ''', [
      fidsId,
      isClue,
      clueTypeID,
      clueTypeDetail,
      isDoor,
      doorDetail,
      isWindows,
      windowsDetail,
      isCelling,
      cellingDetail,
      isRoof,
      villainEntrance,
      roofDetail,
      isClueOther,
      clueOtherDetail,
      labelNo,
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
      caseAssetAreaID
    ]);

    return res;
  }

  updateCaseAreaClue(
      String? isClue,
      String? clueTypeID,
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
      String? labelNo,
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
      int caseAssetAreaID,
      String? villainEntrance,
      String? id) async {
    final db = await DBProvider.db.database;
    var res = await db.rawUpdate('''
      UPDATE CaseAreaClue SET
        IsClue = ?, ClueTypeID = ?, ClueTypeDetail = ?, IsDoor = ?, DoorDetail = ?, IsWindows = ?, WindowsDetail = ?, IsCelling = ?, CellingDetail = ?, IsRoof = ?, RoofDetail = ?, IsClueOther = ?, ClueOtherDetail = ?, LabelNo = ?, IsTools1 = ?, Tools1Detail = ?, IsTools2 = ?, Tools2Detail = ?, IsTools3 = ?, Tools3Detail = ?, IsTools4 = ?, Tools4Detail = ?, Width = ?, WidthUnitID = ?,CaseAssetAreaID = ?,VillainEntrance = ? WHERE ID = ?
    ''', [
      isClue,
      clueTypeID,
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
      labelNo,
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
      caseAssetAreaID,
      villainEntrance,
      id
    ]);

    return res;
  }

  Future<CaseAreaClue?> getCaseAreaClueById(String? id) async {
    final db = await DBProvider.db.database;
    var res =
        await db.query("CaseAreaClue", where: '"ID" = ?', whereArgs: ['$id']);
    if (res.isEmpty) {
      return null;
    } else {
      var result =
          await db.query("CaseClue", where: '"ID" = ?', whereArgs: ['$id']);
      CaseAreaClue response = CaseAreaClue.fromJson(result[0]);
      return response;
    }
  }

  deleteCaseAreaClue(String? id) async {
    final db = await DBProvider.db.database;

    var res = await db.rawDelete('''
      DELETE FROM CaseAreaClue WHERE ID = ?
    ''', [id]);
    return res;
  }

  deleteCaseAreaClueAll(String? id) async {
    final db = await DBProvider.db.database;

    var res = await db.rawDelete('''
      DELETE FROM CaseAreaClue WHERE CaseAssetAreaID = ?
    ''', [id]);
    return res;
  }

  Future<CaseAreaClue> getCaseAreaClue(String? caseAssetAreaId) async {
    final db = await DBProvider.db.database;
    var res = await db.query("CaseAreaClue",
        where: '"CaseAssetAreaID" = ?', whereArgs: ['$caseAssetAreaId']);
    if (res.isEmpty) {
      return CaseAreaClue();
    } else {
      var result = await db.query("CaseAreaClue",
          where: '"CaseAssetAreaID" = ?', whereArgs: ['$caseAssetAreaId']);
      CaseAreaClue caseAreaClue = CaseAreaClue();
      for (int i = 0; i < result.length; i++) {
        // Map<String?, dynamic> res = result[i];
        CaseAreaClue formResponse = CaseAreaClue.fromJson(result[i]);
        caseAreaClue = formResponse;
        // listResult.add(formResponse);
        if (kDebugMode) {
          print('object TERRERERERRER');
        }
      }

      return caseAreaClue;
    }
  }

  delete(int fidsId) async {
    final db = await DBProvider.db.database;

    var res = await db.rawDelete('''
      DELETE FROM CaseAreaClue WHERE FidsID = ?
    ''', [fidsId]);
    if (kDebugMode) {
      print('DELETE Success');
    }
    return res;
  }

  Future<void> insertCheck(
      CaseAreaClue caseAreaClue, String? caseAssetAreaId) async {
    final db = await DBProvider.db.database;

    if (kDebugMode) {
      print('caseAssetAreaId $caseAssetAreaId');
    }
    if (kDebugMode) {
      print('caseAreaClue ${caseAreaClue.toString()}}');
    }

    var result = await db.query("CaseAreaClue",
        where: '"CaseAssetAreaID" = ?', whereArgs: ['$caseAssetAreaId']);

    bool isAdd = false;
    if (result.isEmpty) {
    } else {
      for (int i = 0; i < result.length; i++) {
        // Map<String?, dynamic> res = result[i];
        CaseAreaClue formResponse = CaseAreaClue.fromJson(result[i]);
        if (kDebugMode) {
          print('object ${formResponse.id} :  ${caseAreaClue.id}');
        }
        if ('${formResponse.id}' == '${caseAreaClue.id}') {
          isAdd = true;
        }
      }
    }

    if (isAdd) {
      if (kDebugMode) {
        print('updateCaseAreaClue');
      }
      await updateCaseAreaClue(
        caseAreaClue.isClue,
        caseAreaClue.clueTypeID,
        caseAreaClue.clueTypeDetail,
        caseAreaClue.isDoor,
        caseAreaClue.doorDetail,
        caseAreaClue.isWindows,
        caseAreaClue.windowsDetail,
        caseAreaClue.isCelling,
        caseAreaClue.cellingDetail,
        caseAreaClue.isRoof,
        caseAreaClue.roofDetail,
        caseAreaClue.isClueOther,
        caseAreaClue.clueOtherDetail,
        caseAreaClue.labelNo,
        caseAreaClue.isTools1,
        caseAreaClue.tools1Detail,
        caseAreaClue.isTools2,
        caseAreaClue.tools2Detail,
        caseAreaClue.isTools3,
        caseAreaClue.tools3Detail,
        caseAreaClue.isTools4,
        caseAreaClue.tools4Detail,
        caseAreaClue.width,
        caseAreaClue.widthUnitID,
        caseAreaClue.caseAssetAreaID ?? -1,
        caseAreaClue.villainEntrance,
        caseAreaClue.id,
      );
    } else {
      if (kDebugMode) {
        print('createCaseAreaClue');
      }
      await createCaseAreaClue(
        caseAreaClue.fidsId,
        caseAreaClue.isClue,
        caseAreaClue.clueTypeID,
        caseAreaClue.clueTypeDetail,
        caseAreaClue.isDoor,
        caseAreaClue.doorDetail,
        caseAreaClue.isWindows,
        caseAreaClue.windowsDetail,
        caseAreaClue.isCelling,
        caseAreaClue.cellingDetail,
        caseAreaClue.isRoof,
        caseAreaClue.roofDetail,
        caseAreaClue.isClueOther,
        caseAreaClue.clueOtherDetail,
        caseAreaClue.labelNo,
        caseAreaClue.isTools1,
        caseAreaClue.tools1Detail,
        caseAreaClue.isTools2,
        caseAreaClue.tools2Detail,
        caseAreaClue.isTools3,
        caseAreaClue.tools3Detail,
        caseAreaClue.isTools4,
        caseAreaClue.tools4Detail,
        caseAreaClue.width,
        caseAreaClue.widthUnitID,
        caseAreaClue.caseAssetAreaID ?? -1,
        caseAreaClue.villainEntrance,
      );
    }
    return;
    // }
  }
}
