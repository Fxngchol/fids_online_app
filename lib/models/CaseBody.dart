// ignore_for_file: file_names
import 'package:flutter/foundation.dart';

import '../../utils/database/database.dart';
import 'CaseBodyReferencePoint.dart';
import 'CaseBodyWound.dart';
import 'CaseReferencePoint.dart';

class CaseBody {
  String? id;
  String? fidsId;
  String? labelNo;
  String? bodyTitleName;
  String? bodyFirstName;
  String? bodyLastName;
  String? bodyFoundLocation;
  String? bodyFoundCondition;
  String? isClothing;
  String? clothingDetail;
  String? isPants;
  String? pantsDetail;
  String? isShoes;
  String? shoesDetail;
  String? isBelt;
  String? beltDetail;
  String? isTattoo;
  String? tattooDetail;
  String? dressOther;
  String? investigatorDoctor;
  String? bodyDiagram;
  String? isWound;
  String? personalID;
  String? createDate;
  String? createBy;
  String? updateDate;
  String? updateBy;
  String? activeFlag;

  List<CaseReferencePoint>? referencePoint;
  List<CaseBodyReferencePoint>? bodyReferencePoint;
  List<CaseBodyWound>? caseBodyWound;

  CaseBody(
      {this.id,
      this.fidsId,
      this.labelNo,
      this.isWound,
      this.bodyTitleName,
      this.bodyFirstName,
      this.bodyLastName,
      this.bodyFoundLocation,
      this.bodyFoundCondition,
      this.isClothing,
      this.clothingDetail,
      this.isPants,
      this.pantsDetail,
      this.isShoes,
      this.shoesDetail,
      this.isBelt,
      this.beltDetail,
      this.isTattoo,
      this.tattooDetail,
      this.dressOther,
      this.investigatorDoctor,
      this.bodyDiagram,
      this.createDate,
      this.createBy,
      this.updateDate,
      this.updateBy,
      this.activeFlag,
      this.referencePoint,
      this.bodyReferencePoint,
      this.caseBodyWound,
      this.personalID});

  factory CaseBody.fromJson(Map<String, dynamic> json) {
    return CaseBody(
      id: '${json['ID']}',
      fidsId: '${json['FidsID']}',
      labelNo: json['LabelNo'],
      bodyTitleName: '${json['BodyTitleName']}',
      bodyFirstName: json['BodyFirstName'],
      bodyLastName: json['BodyLastName'],
      bodyFoundLocation: json['BodyFoundLocation'],
      bodyFoundCondition: json['BodyFoundCondition'],
      isClothing:
          '${json['IsClothing']}' == '-1' ? '' : '${json['IsClothing']}',
      clothingDetail: json['ClothingDetail'],
      isPants: '${json['IsPants']}' == '-1' ? '' : '${json['IsPants']}',
      pantsDetail: json['PantsDetail'],
      isShoes: '${json['IsShoes']}' == '-1' ? '' : '${json['IsShoes']}',
      shoesDetail: json['ShoesDetail'],
      isBelt: '${json['IsBelt']}' == '-1' ? '' : '${json['IsBelt']}',
      isWound: '${json['IsWound']}' == '-1' ? '' : '${json['IsWound']}',
      beltDetail: json['BeltDetail'],
      isTattoo: '${json['IsTattoo']}' == '-1' ? '' : '${json['IsTattoo']}',
      tattooDetail: json['TattooDetail'],
      dressOther: json['DressOther'],
      investigatorDoctor: json['InvestigatorDoctor'],
      bodyDiagram: json['BodyDiagram'],
      personalID: json['PersonalID'],
      createDate: json['CreateDate'],
      createBy: json['CreateBy'],
      updateDate: json['UpdateDate'],
      updateBy: json['UpdateBy'],
      activeFlag: '${json['ActiveFlag']}',
    );
  }

  factory CaseBody.fromApi(Map<String, dynamic> json) {
    if (kDebugMode) {
      print(
          'jsonjsonjsonjsonjsonjsonjsonjsonjsonjsonjsonjson ${json['reference_point']}');
    }
    return CaseBody(
      id: json['id'],
      fidsId: json['fidsno'],
      labelNo: json['label_no'],
      isWound: json['is_wound'],
      bodyTitleName: json['body_title_name'],
      bodyFirstName: json['body_firstname'],
      bodyLastName: json['body_lastname'],
      bodyFoundLocation: json['body_found_location'],
      bodyFoundCondition: json['body_found_condition'],
      isClothing: json['is_clothing'],
      clothingDetail: json['clothing_detail'],
      isPants: json['is_pants'],
      pantsDetail: json['pants_detail'],
      isShoes: json['is_shoes'],
      shoesDetail: json['shoes_detail'],
      isBelt: json['is_belt'],
      beltDetail: json['belt_detail'],
      isTattoo: json['is_tattoo'],
      tattooDetail: json['tattoo_detail'],
      dressOther: json['dress_other'],
      investigatorDoctor: json['investigator_doctor'],
      bodyDiagram: json['body_diagram'],
      personalID: json['pernosal_id'],
      activeFlag: json['active_flag'],
      referencePoint: json['reference_point'] == null
          ? []
          : (json['reference_point'] as List)
              .map((data) => CaseReferencePoint.fromApi(data))
              .toList(),
      bodyReferencePoint: json['body_reference_point'] == null
          ? []
          : (json['body_reference_point'] as List)
              .map((data) => CaseBodyReferencePoint.fromApi(data))
              .toList(),
      caseBodyWound: json['case_body_wound'] == null
          ? []
          : (json['case_body_wound'] as List)
              .map((data) => CaseBodyWound.fromApi(data))
              .toList(),
    );
  }

  Map toJson() => {
        'id': id == '-2' ? '' : '$id',
        'label_no': labelNo ?? '',
        'is_wound': isWound == null || isWound == '-1' ? '' : '$isWound',
        'body_title_name': bodyTitleName == null ? '' : '$bodyTitleName',
        'body_firstname': bodyFirstName ?? '',
        'body_lastname': bodyLastName ?? '',
        'body_found_location': bodyFoundLocation ?? '',
        'body_found_condition': bodyFoundCondition ?? '',
        'is_clothing':
            isClothing == '-2' || isClothing == '-1' || isClothing == null
                ? ''
                : '$isClothing',
        'clothing_detail': clothingDetail ?? '',
        'is_pants': isPants == '-2' || isPants == '-1' || isPants == null
            ? ''
            : '$isPants',
        'pants_detail': pantsDetail ?? '',
        'is_shoes': isShoes == '-2' || isShoes == '-1' || isShoes == null
            ? ''
            : '$isShoes',
        'shoes_detail': shoesDetail ?? '',
        'is_belt':
            isBelt == '-2' || isBelt == '-1' || isBelt == null ? '' : '$isBelt',
        'belt_detail': beltDetail ?? '',
        'is_tattoo': isTattoo == '-2' || isTattoo == '-1' || isTattoo == null
            ? ''
            : '$isTattoo',
        'tattoo_detail': tattooDetail ?? '',
        'dress_other': dressOther ?? '',
        'body_diagram': bodyDiagram ?? '',
        'investigator_doctor': investigatorDoctor ?? '',
        'active_flag': '1',
        'body_reference_point': bodyReferencePoint,
        'case_body_wound': caseBodyWound,
        'personal_id': personalID == null ? '' : '$personalID',
      };

  @override
  String toString() {
    return 'CaseBody(id: $id, fidsId: $fidsId, labelNo: $labelNo, bodyTitleName: $bodyTitleName, bodyFirstName: $bodyFirstName, bodyLastName: $bodyLastName, bodyFoundLocation: $bodyFoundLocation, bodyFoundCondition: $bodyFoundCondition, isClothing: $isClothing, clothingDetail: $clothingDetail, isPants: $isPants, pantsDetail: $pantsDetail, isShoes: $isShoes, shoesDetail: $shoesDetail, isBelt: $isBelt, beltDetail: $beltDetail, isTattoo: $isTattoo, tattooDetail: $tattooDetail, dressOther: $dressOther, investigatorDoctor: $investigatorDoctor, isWound: $isWound, bodyDiagram: $bodyDiagram, createDate: $createDate, createBy: $createBy, updateDate: $updateDate, updateBy: $updateBy, activeFlag: $activeFlag, referencePoint: $referencePoint, bodyReferencePoint: $bodyReferencePoint, caseBodyWound: $caseBodyWound,personalID: $personalID)';
  }
}

class CaseBodyDao {
  createCaseBody(
      String? labelNo,
      String? bodyTitleName,
      String? bodyFirstName,
      String? bodyLastName,
      String? bodyFoundLocation,
      String? bodyFoundCondition,
      int fidsId,
      int isClothing,
      String? clothingDetail,
      int isPants,
      String? pantsDetail,
      int isShoes,
      String? shoesDetail,
      int isBelt,
      String? beltDetail,
      int isTattoo,
      String? tattooDetail,
      String? dressOther,
      String? investigatorDoctor,
      String? bodyDiagram,
      int isWound,
      String? personalID,
      String? createDate,
      String? createBy,
      String? updateDate,
      String? updateBy,
      int activeFlag) async {
    final db = await DBProvider.db.database;
    var res = await db.rawInsert('''
      INSERT INTO CaseBody (
        LabelNo,BodyTitleName,BodyFirstName,BodyLastName,BodyFoundLocation,BodyFoundCondition,FidsID,IsClothing,ClothingDetail,IsPants,PantsDetail,IsShoes,ShoesDetail,IsBelt,BeltDetail,IsTattoo,TattooDetail,DressOther,InvestigatorDoctor,BodyDiagram,IsWound,PersonalID,CreateDate,CreateBy,UpdateDate,UpdateBy,ActiveFlag
      ) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)
    ''', [
      labelNo,
      bodyTitleName,
      bodyFirstName,
      bodyLastName,
      bodyFoundLocation,
      bodyFoundCondition,
      fidsId,
      isClothing,
      clothingDetail,
      isPants,
      pantsDetail,
      isShoes,
      shoesDetail,
      isBelt,
      beltDetail,
      isTattoo,
      tattooDetail,
      dressOther,
      investigatorDoctor,
      bodyDiagram,
      isWound,
      personalID,
      createDate,
      createBy,
      updateDate,
      updateBy,
      activeFlag
    ]);

    return res;
  }

  updateCaseBody(
      String? labelNo,
      String? bodyTitleName,
      String? bodyFirstName,
      String? bodyLastName,
      String? bodyFoundLocation,
      String? bodyFoundCondition,
      int fidsId,
      int isClothing,
      String? clothingDetail,
      int isPants,
      String? pantsDetail,
      int isShoes,
      String? shoesDetail,
      int isBelt,
      String? beltDetail,
      int isTattoo,
      String? tattooDetail,
      String? dressOther,
      String? investigatorDoctor,
      String? bodyDiagram,
      int isWound,
      String? personalID,
      String? createDate,
      String? createBy,
      String? updateDate,
      String? updateBy,
      int activeFlag,
      int id) async {
    final db = await DBProvider.db.database;
    var res = await db.rawUpdate('''
      UPDATE CaseBody SET
        LabelNo = ?, BodyTitleName = ?, BodyFirstName = ?, BodyLastName = ?, BodyFoundLocation = ?, BodyFoundCondition = ?, FidsID = ?, IsClothing = ?, ClothingDetail = ?, IsPants = ?, PantsDetail = ?, IsShoes = ?, ShoesDetail = ?, IsBelt = ?, BeltDetail = ?, IsTattoo = ?, TattooDetail = ?, DressOther = ?, InvestigatorDoctor = ?, BodyDiagram = ?, isWound = ? , personalID = ?, CreateDate = ?, CreateBy = ?, UpdateDate = ?, UpdateBy = ?, ActiveFlag = ? WHERE ID = ?
    ''', [
      labelNo,
      bodyTitleName,
      bodyFirstName,
      bodyLastName,
      bodyFoundLocation,
      bodyFoundCondition,
      fidsId,
      isClothing,
      clothingDetail,
      isPants,
      pantsDetail,
      isShoes,
      shoesDetail,
      isBelt,
      beltDetail,
      isTattoo,
      tattooDetail,
      dressOther,
      investigatorDoctor,
      bodyDiagram,
      isWound,
      personalID,
      createDate,
      createBy,
      updateDate,
      updateBy,
      activeFlag,
      id
    ]);

    return res;
  }

  deleteCaseBody(int id) async {
    final db = await DBProvider.db.database;

    var res = await db.rawDelete('''
      DELETE FROM CaseBody WHERE ID = ?
    ''', [id]);
    return res;
  }

  Future<List<CaseBody>> getCaseBody(int fidsId) async {
    final db = await DBProvider.db.database;
    var res = await db.query("CaseBody");
    if (res.isEmpty) {
      return [];
    } else {
      var result = await db
          .query("CaseBody", where: '"FidsID" = ?', whereArgs: ['$fidsId']);

      List<CaseBody> listResult = [];
      for (int i = 0; i < result.length; i++) {
        Map<String, dynamic> res = result[i];
        CaseBody formResponse = CaseBody.fromJson(res);
        var referencePoint = await CaseReferencePointDao()
            .getCaseReferencePoint(formResponse.fidsId);
        var bodyReferencePoint = await CaseBodyReferencePointDao()
            .getCaseBodyReferencePointById(formResponse.id ?? '');
        var caseBodyWound =
            await CaseBodyWoundDao().getCaseBodyWound(formResponse.id ?? '');
        formResponse.bodyReferencePoint = bodyReferencePoint;
        formResponse.caseBodyWound = caseBodyWound;
        formResponse.referencePoint = referencePoint;
        listResult.add(formResponse);
      }
      return listResult;
    }
  }

  Future<CaseBody?> getCaseBodyById(int id) async {
    final db = await DBProvider.db.database;
    var res = await db.query("CaseBody");
    if (res.isEmpty) {
      return null;
    } else {
      var result =
          await db.query("CaseBody", where: '"ID" = ?', whereArgs: ['$id']);

      CaseBody response = CaseBody.fromJson(result[0]);
      if (kDebugMode) {
        print('CaseBodyCaseBodyCaseBody $response');
      }
      return response;
    }
  }

  delete(int fidsId) async {
    final db = await DBProvider.db.database;

    var res = await db.rawDelete('''
      DELETE FROM CaseBody WHERE FidsID = ?
    ''', [fidsId]);
    if (kDebugMode) {
      print('DELETE Success');
    }
    return res;
  }
}
