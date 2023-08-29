// ignore_for_file: file_names

import 'package:flutter/foundation.dart';

import '../../utils/database/database.dart';

class CaseEvidentFound {
  String? id;
  String? fidsId;
  String? evidentTypeId;
  String? isoLabelNo;
  String? evidentDetails;
  String? isoEvidentPosition;
  String? evidentAmount;
  String? evidenceUnit;
  String? isoReferenceId1;
  String? isoReferenceDistance1;
  String? isoReferenceUnitId1;
  String? isoReferenceId2;
  String? isoReferenceDistance2;
  String? isoReferenceUnitId2;
  String? isBlood;
  String? isoIsTestStains;
  String? isoIsHermastix;
  String? isoIsHermastixChange;
  String? isoIsPhenolphthaiein;
  String? isoIsPhenolphthaieinChange;
  String? createDate;
  String? createBy;
  String? updateDate;
  String? updateBy;

  String? activeFlag;

  String? size;
  String? sizeUnit;

  CaseEvidentFound(
      {this.id,
      this.fidsId,
      this.evidentTypeId,
      this.isoLabelNo,
      this.evidentDetails,
      this.isoEvidentPosition,
      this.evidentAmount,
      this.evidenceUnit,
      this.isoReferenceId1,
      this.isoReferenceDistance1,
      this.isoReferenceUnitId1,
      this.isoReferenceId2,
      this.isoReferenceDistance2,
      this.isoReferenceUnitId2,
      this.isBlood,
      this.isoIsTestStains,
      this.isoIsHermastix,
      this.isoIsHermastixChange,
      this.isoIsPhenolphthaiein,
      this.isoIsPhenolphthaieinChange,
      this.createDate,
      this.createBy,
      this.updateDate,
      this.updateBy,
      this.activeFlag,
      this.size,
      this.sizeUnit});

  Map<String, dynamic> toMap() {
    return {
      'ID': id == '-2' || id == null ? '' : id,
      'FidsID': fidsId == '-2' || fidsId == null ? '' : fidsId,
      'EvidentTypeID':
          evidentTypeId == '-2' || evidentTypeId == null ? '' : evidentTypeId,
      'Iso_LabelNo': isoLabelNo ?? '',
      'EvidentDetails': evidentDetails ?? '',
      'Iso_EvidentPosition': isoEvidentPosition ?? '',
      'EvidentAmount': evidentAmount ?? '',
      'evidenceUnit':
          evidenceUnit == '-2' || evidenceUnit == null ? '' : evidenceUnit,
      'Iso_ReferenceID1': isoReferenceId1 == '-2' || isoReferenceId1 == null
          ? ''
          : isoReferenceId1,
      'Iso_ReferenceDistance1': isoReferenceDistance1 ?? '',
      'Iso_ReferenceUnitID1':
          isoReferenceUnitId1 == '-2' || isoReferenceUnitId1 == null
              ? ''
              : isoReferenceUnitId1,
      'Iso_ReferenceID2': isoReferenceId2 == '-2' || isoReferenceId2 == null
          ? ''
          : isoReferenceId2,
      'Iso_ReferenceDistance2': isoReferenceDistance2 ?? '',
      'Iso_ReferenceUnitID2':
          isoReferenceUnitId2 == '-2' || isoReferenceUnitId2 == null
              ? ''
              : isoReferenceUnitId2,
      'IsBlood': isBlood == null || isBlood == '-1' ? '' : isBlood,
      'Iso_IsTestStains': isoIsTestStains == null || isoIsTestStains == '-1'
          ? ''
          : isoIsTestStains,
      'Iso_IsHermastix': isoIsHermastix == null || isoIsHermastix == '-1'
          ? ''
          : isoIsHermastix,
      'Iso_IsHermastixChange':
          isoIsHermastixChange == null || isoIsHermastixChange == '-1'
              ? ''
              : isoIsHermastixChange,
      'Iso_IsPhenolphthaiein':
          isoIsPhenolphthaiein == null || isoIsPhenolphthaiein == '-1'
              ? ''
              : isoIsPhenolphthaiein,
      'Iso_IsPhenolphthaieinChange': isoIsPhenolphthaieinChange == null ||
              isoIsPhenolphthaieinChange == '-1'
          ? ''
          : isoIsPhenolphthaieinChange,
      'ActiveFlag': activeFlag ?? '',
      'SizeUnit': sizeUnit ?? '',
      'Size': size ?? '',
    };
  }

  factory CaseEvidentFound.fromMap(Map<String, dynamic> map) {
    //if (map == null) return null;

    return CaseEvidentFound(
        id: '${map['ID']}',
        fidsId: map['fidsno'],
        evidentTypeId: '${map['EvidentTypeID']}',
        isoLabelNo: map['Iso_LabelNo'],
        evidentDetails: map['EvidentDetails'],
        isoEvidentPosition: map['Iso_EvidentPosition'],
        evidentAmount: map['EvidentAmount'],
        evidenceUnit: '${map['EvidenceUnit']}',
        isoReferenceId1: '${map['Iso_ReferenceID1']}',
        isoReferenceDistance1: '${map['Iso_ReferenceDistance1']}',
        isoReferenceUnitId1: '${map['Iso_ReferenceUnitID1']}',
        isoReferenceId2: '${map['Iso_ReferenceID2']}',
        isoReferenceDistance2: '${map['Iso_ReferenceDistance2']}',
        isoReferenceUnitId2: '${map['Iso_ReferenceUnitID2']}',
        isBlood: '${map['IsBlood']}',
        isoIsTestStains: '${map['Iso_IsTestStains']}',
        isoIsHermastix: '${map['Iso_IsHermastix']}',
        isoIsHermastixChange: '${map['Iso_IsHermastixChange']}',
        isoIsPhenolphthaiein: '${map['Iso_IsPhenolphthaiein']}',
        isoIsPhenolphthaieinChange: '${map['Iso_IsPhenolphthaieinChange']}',
        createDate: map['CreateDate'],
        createBy: map['CreateBy'],
        updateDate: map['UpdateDate'],
        updateBy: map['UpdateBy'],
        activeFlag: '${map['ActiveFlag']}',
        size: '${map['Size']}',
        sizeUnit: '${map['SizeUnit']}');
  }

  factory CaseEvidentFound.fromApi(Map<String, dynamic> map) {
    return CaseEvidentFound(
        id: '${map['id']}',
        fidsId: map['fidsno'],
        evidentTypeId: map['evident_type_id'],
        isoLabelNo: map['iso_label_no'],
        evidentDetails: map['evident_details'],
        isoEvidentPosition: map['iso_evident_position'],
        evidentAmount: map['evident_amount'],
        evidenceUnit: '${map['EvidenceUnit']}',
        isoReferenceId1: '${map['iso_reference_id1']}',
        isoReferenceDistance1: map['iso_reference_distance1'],
        isoReferenceUnitId1: '${map['iso_reference_unit_id1']}',
        isoReferenceId2: '${map['iso_reference_id2']}',
        isoReferenceDistance2: map['iso_reference_distance2'],
        isoReferenceUnitId2: '${map['iso_reference_unit_id2']}',
        isBlood: '${map['isBlood']}',
        isoIsTestStains: '${map['iso_is_test_stains']}',
        isoIsHermastix: '${map['iso_is_hermastix']}',
        isoIsHermastixChange: '${map['iso_is_hermastix_change']}',
        isoIsPhenolphthaiein: '${map['iso_is_phenolphthaiein']}',
        isoIsPhenolphthaieinChange: '${map['iso_is_phenolphthaiein_change']}',
        size: '${map['Size']}',
        sizeUnit: '${map['SizeUnit']}');
  }

  Map toJson() => {
        'id': id == '-2' || id == null ? '' : '$id',
        'evident_type_id': evidentTypeId == null || evidentTypeId == 'null'
            ? ''
            : evidentTypeId,
        'iso_label_no': isoLabelNo,
        'evident_datails': evidentDetails,
        'iso_evident_position': isoEvidentPosition,
        'evident_amount': evidentAmount,
        'evidence_unit':
            evidenceUnit == '-2' || evidenceUnit == null ? '' : '$evidenceUnit',
        'iso_reference_id1': isoReferenceId1 == '-2' || isoReferenceId1 == null
            ? ''
            : '$isoReferenceId1',
        'iso_reference_distance1': isoReferenceDistance1,
        'iso_reference_unit_id1':
            isoReferenceUnitId1 == '-2' || isoReferenceUnitId1 == null
                ? ''
                : '$isoReferenceUnitId1',
        'iso_reference_id2': isoReferenceId2 == '-2' || isoReferenceId2 == null
            ? ''
            : '$isoReferenceId2',
        'iso_reference_distance2': isoReferenceDistance2,
        'iso_reference_unit_id2':
            isoReferenceUnitId2 == '-2' || isoReferenceUnitId2 == null
                ? ''
                : '$isoReferenceUnitId2',
        'is_blood': isBlood == null || isBlood == '-1' ? '' : '$isBlood',
        'iso_is_test_stains': isoIsTestStains == null ||
                isoIsTestStains == '-1' ||
                isoIsTestStains == 'null'
            ? ''
            : '$isoIsTestStains',
        'iso_is_hermastix': isoIsHermastix == null ||
                isoIsHermastix == '-1' ||
                isoIsHermastix == 'null'
            ? ''
            : '$isoIsHermastix',
        'iso_is_hermastix_change': isoIsHermastixChange == null ||
                isoIsHermastixChange == '-1' ||
                isoIsHermastixChange == 'null'
            ? ''
            : '$isoIsHermastixChange',
        'iso_is_phenolphthaiein': isoIsPhenolphthaiein == null ||
                isoIsPhenolphthaiein == '-1' ||
                isoIsPhenolphthaiein == 'null'
            ? ''
            : '$isoIsPhenolphthaiein',
        'iso_is_phenolphthaiein_change': isoIsPhenolphthaieinChange == null ||
                isoIsPhenolphthaieinChange == '-1' ||
                isoIsPhenolphthaieinChange == 'null'
            ? ''
            : '$isoIsPhenolphthaieinChange',
        'active_flag': '1',
        'size': size,
        'size_unit': sizeUnit
      };

  @override
  String toString() {
    return 'CaseEvidentFound(id: $id, fidsId: $fidsId, evidentTypeId: $evidentTypeId, isoLabelNo: $isoLabelNo, evidentDetails: $evidentDetails, isoEvidentPosition: $isoEvidentPosition, evidentAmount: $evidentAmount, evidenceUnit: $evidenceUnit, isoReferenceId1: $isoReferenceId1, isoReferenceDistance1: $isoReferenceDistance1, isoReferenceUnitId1: $isoReferenceUnitId1, isoReferenceId2: $isoReferenceId2, isoReferenceDistance2: $isoReferenceDistance2, isoReferenceUnitId2: $isoReferenceUnitId2, isBlood: $isBlood, isoIsTestStains: $isoIsTestStains, isoIsHermastix: $isoIsHermastix, isoIsHermastixChange: $isoIsHermastixChange, isoIsPhenolphthaiein: $isoIsPhenolphthaiein, isoIsPhenolphthaieinChange: $isoIsPhenolphthaieinChange, createDate: $createDate, createBy: $createBy, updateDate: $updateDate, updateBy: $updateBy, activeFlag: $activeFlag)';
  }
}

class CaseEvidentFoundDao {
  Future<void> createCaseEvidentFound(
    int fidsId,
    String? isoLabelNo,
    String? evidentDetails,
    String? isoEvidentPosition,
    String? size,
    String? sizeUnit,
    String? evidentAmount,
    String? evidenceUnit,
    int isoReferenceId1,
    double isoReferenceDistance1,
    int isoReferenceUnitId1,
    int isoReferenceId2,
    double isoReferenceDistance2,
    int isoReferenceUnitId2,
    int isoIsTestStains,
    int isoIsHermastix,
    int isoIsHermastixChange,
    int isoIsPhenolphthaiein,
    int isoIsPhenolphthaieinChange,
    int isBlood,
    String? createDate,
    String? createBy,
    String? updateDate,
    String? updateBy,
    int activeFlag,
  ) async {
    final db = await DBProvider.db.database;
    await db.rawInsert('''
      INSERT INTO CaseEvidentFound (
        FidsID,Iso_LabelNo,EvidentDetails,Iso_EvidentPosition,Size,SizeUnit,EvidentAmount,EvidenceUnit,Iso_ReferenceID1,Iso_ReferenceDistance1,Iso_ReferenceUnitID1,Iso_ReferenceID2,Iso_ReferenceDistance2,Iso_ReferenceUnitID2,Iso_IsTestStains,Iso_IsHermastix,Iso_IsHermastixChange,Iso_IsPhenolphthaiein,Iso_IsPhenolphthaieinChange,IsBlood,CreateDate,CreateBy,UpdateDate,UpdateBy,ActiveFlag
      ) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)
    ''', [
      fidsId,
      isoLabelNo,
      evidentDetails,
      isoEvidentPosition,
      size,
      sizeUnit,
      evidentAmount,
      evidenceUnit,
      isoReferenceId1,
      isoReferenceDistance1,
      isoReferenceUnitId1,
      isoReferenceId2,
      isoReferenceDistance2,
      isoReferenceUnitId2,
      isoIsTestStains,
      isoIsHermastix,
      isoIsHermastixChange,
      isoIsPhenolphthaiein,
      isoIsPhenolphthaieinChange,
      isBlood,
      createDate,
      createBy,
      updateDate,
      updateBy,
      activeFlag,
    ]);
  }

  Future<void> updateCaseEvidentFound(
    int fidsId,
    String? isoLabelNo,
    String? evidentDetails,
    String? isoEvidentPosition,
    String? size,
    String? sizeUnit,
    String? evidentAmount,
    String? evidenceUnit,
    int isoReferenceId1,
    double isoReferenceDistance1,
    int isoReferenceUnitId1,
    int isoReferenceId2,
    double isoReferenceDistance2,
    int isoReferenceUnitId2,
    int isoIsTestStains,
    int isoIsHermastix,
    int isoIsHermastixChange,
    int isoIsPhenolphthaiein,
    int isoIsPhenolphthaieinChange,
    String? caseEvidentFoundID,
    int isBlood,
  ) async {
    final db = await DBProvider.db.database;
    await db.rawUpdate('''
      UPDATE CaseEvidentFound SET
        FidsID = ?, Iso_LabelNo = ?, EvidentDetails = ?, Iso_EvidentPosition = ?,Size = ?,SizeUnit = ?, EvidentAmount = ?, EvidenceUnit = ? , Iso_ReferenceID1 = ? , Iso_ReferenceDistance1 = ? , Iso_ReferenceUnitID1 = ?,Iso_ReferenceID2 = ?,Iso_ReferenceDistance2 = ?,Iso_ReferenceUnitID2 = ?,Iso_IsTestStains = ?,Iso_IsHermastix = ?,Iso_IsHermastixChange = ?,Iso_IsPhenolphthaiein = ?,Iso_IsPhenolphthaieinChange = ?,IsBlood = ?  WHERE ID = ?
    ''', [
      fidsId,
      // evidentTypeId,
      isoLabelNo,
      evidentDetails,
      isoEvidentPosition,
      size, sizeUnit,
      evidentAmount,
      evidenceUnit,
      isoReferenceId1,
      isoReferenceDistance1,
      isoReferenceUnitId1,
      isoReferenceId2,
      isoReferenceDistance2,
      isoReferenceUnitId2,
      isoIsTestStains,
      isoIsHermastix,
      isoIsHermastixChange,
      isoIsPhenolphthaiein,
      isoIsPhenolphthaieinChange,
      isBlood,
      caseEvidentFoundID,
    ]);
  }

  Future<List<CaseEvidentFound>> getCaseEvidentFound(int fidsID) async {
    final db = await DBProvider.db.database;
    var res = await db.query("CaseEvidentFound",
        where: '"FidsID" = ?', whereArgs: ['$fidsID']);
    if (res.isEmpty) {
      return [];
    } else {
      var result = await db.query("CaseEvidentFound",
          where: '"FidsID" = ?', whereArgs: ['$fidsID']);

      List<CaseEvidentFound> listResult = [];
      //// print('result : ${result.toString()}');
      //FidsCrimeScene response = FidsCrimeScene.fromJson(result[0]);

      for (int i = 0; i < result.length; i++) {
        CaseEvidentFound formResponse = CaseEvidentFound.fromMap(result[i]);
        if (kDebugMode) {
          print(
              'CaseEvidentFound : ${formResponse.id} -> ${formResponse.evidentDetails} ');
        }
        listResult.add(formResponse);
      }

      return listResult;
    }
  }

  Future<CaseEvidentFound?> getCaseEvidentFoundById(String id) async {
    final db = await DBProvider.db.database;
    var res = await db.query("CaseEvidentFound");
    if (res.isEmpty) {
      return null;
    } else {
      var result = await db
          .query("CaseEvidentFound", where: '"ID" = ?', whereArgs: [id]);

      CaseEvidentFound response = CaseEvidentFound.fromMap(result[0]);
      return response;
    }
  }

  Future<void> deleteCaseEvidentFounde(String id) async {
    final db = await DBProvider.db.database;
    await db.rawDelete('''
      DELETE FROM CaseEvidentFound WHERE ID = ?
    ''', [id]);
    if (kDebugMode) {
      print('DELETE Success');
    }
  }

  Future<List<String>> getCaseEvidentFoundLabel(int fidsID) async {
    final db = await DBProvider.db.database;
    var res = await db.query("CaseEvidentFound",
        where: '"FidsID" = ?', whereArgs: ['$fidsID']);
    if (res.isEmpty) {
      return [];
    } else {
      var result = await db.query("CaseEvidentFound",
          where: '"FidsID" = ?', whereArgs: ['$fidsID']);

      List<String> listResult = [];
      //// print('result : ${result.toString()}');
      //FidsCrimeScene response = FidsCrimeScene.fromJson(result[0]);

      for (int i = 0; i < result.length; i++) {
        if (kDebugMode) {
          Map<String, dynamic> res = result[i];
          print('getCaseEvidentFoundLabel $res');
        }
        CaseEvidentFound formResponse = CaseEvidentFound.fromMap(result[i]);
        listResult.add(formResponse.isoLabelNo ?? '');
      }
      return listResult;
    }
  }

  delete(int fidsId) async {
    final db = await DBProvider.db.database;

    var res = await db.rawDelete('''
      DELETE FROM CaseEvidentFound WHERE FidsID = ?
    ''', [fidsId]);
    if (kDebugMode) {
      print('DELETE Success');
    }
    return res;
  }
}
