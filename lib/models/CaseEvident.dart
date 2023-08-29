// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import '../../utils/database/database.dart';
import '../view/life_case/evident/model/CaseEvidentForm.dart';
import 'CaseEvidentDeliver.dart';
import 'CaseEvidentLocation.dart';

class CaseEvident {
  String? id;
  String? fidsId;
  String? evidentNo;
  String? evidentTypeId;
  String? evidentDetail;
  String? evidentAmount;
  String? evidentUnit;
  String? packageId;
  String? packageOther;
  String? isEvidentOperate;
  String? departmentId;
  String? workGroupId;
  String? personalId;
  String? caseEvidentFoundId;
  String? deliverWorkGroupID;
  String? evidenceDetail;
  String? vehiclePosition;
  String? evidenceAmount;
  String? evidenceUnit;
  String? isEvidenceOperate;
  String? createDate;
  String? createBy;
  String? updateDate;
  String? updateBy;
  String? activeFlag;
  List<CaseEvidentLocation>? caseEvidentLocation;

  CaseEvident(
      {this.id,
      this.fidsId,
      this.evidentNo,
      this.evidentTypeId,
      this.evidentDetail,
      this.evidentAmount,
      this.evidentUnit,
      this.packageId,
      this.packageOther,
      this.isEvidentOperate,
      this.departmentId,
      this.workGroupId,
      this.personalId,
      this.caseEvidentFoundId,
      this.deliverWorkGroupID,
      this.evidenceDetail,
      this.vehiclePosition,
      this.evidenceAmount,
      this.evidenceUnit,
      this.isEvidenceOperate,
      this.createDate,
      this.createBy,
      this.updateDate,
      this.updateBy,
      this.activeFlag,
      this.caseEvidentLocation});

  factory CaseEvident.fromJson(Map<String, dynamic> json) {
    return CaseEvident(
        id: '${json['ID']}',
        fidsId: '${json['FidsID']}',
        evidentNo: json['EvidentNo'],
        evidentTypeId: '${json['EvidentTypeID']}',
        evidentDetail: json['EvidentDetails'],
        evidentAmount: json['EvidentAmount'],
        evidentUnit: '${json['EvidentUnit']}',
        packageId: '${json['PackageID']}',
        packageOther: '${json['PackageOther']}',
        isEvidentOperate: '${json['IsEvidentOperate']}',
        departmentId: '${json['DepartmentID']}',
        workGroupId: '${json['WorkGroupID']}',
        caseEvidentFoundId: '${json['CaseEvindentFoundID']}',
        deliverWorkGroupID: '${json['deliverWorkGroupID']}',
        createDate: json['CreateDate'],
        createBy: json['CreateBy'],
        updateDate: json['UpdateDate'],
        updateBy: json['UpdateBy'],
        activeFlag: '${json['ActiveFlag']}',
        personalId: '${json['PersonalID']}',
        evidenceDetail: '${json['EvidenceDetail']}',
        vehiclePosition: '${json['VehiclePosition']}',
        evidenceAmount: '${json['EvidenceAmount']}',
        evidenceUnit: '${json['EvidenceUnit']}',
        isEvidenceOperate: '${json['IsEvidenceOperate']}');
  }

  factory CaseEvident.fromApi(Map<String, dynamic> json) {
    return CaseEvident(
        id: json['id'],
//      fidsId: json['fids_no'] ,
        evidentNo: json['evident_no'],
        evidentTypeId: json['evident_type_id'],
        evidentDetail: json['evident_detail'],
        evidentAmount: json['evident_amount'],
        evidentUnit: json['EvidentUnit'],
        packageId: json['package_id'],
        packageOther: json['package_other'],
        isEvidentOperate: json['is_evident_operate'],
        departmentId: json['department_id'],
        workGroupId: json['workgroup_id'],
        caseEvidentFoundId: json['case_evindent_found_id'],
        deliverWorkGroupID: json['deliver_work_group_id'],
        personalId: '${json['PersonalID']}',
        evidenceDetail: json['evidence_detail'],
        vehiclePosition: json['vehicle_position'],
        evidenceAmount: json['evidence_amount'],
        evidenceUnit: json['evidence_unit'],
        isEvidenceOperate: '${json['is_evidence_operate']}');
  }

  Map toTrafficJson() => {
        'id': id == '-2' || id == null ? '' : '$id',
        'evident_no': evidentNo,
        'evident_type_id': evidentTypeId == '-2' || evidentTypeId == null
            ? ''
            : '$evidentTypeId',
        'evident_detail': evidentDetail,
        'evident_amount': evidentAmount,
        'evidentUnit':
            evidentUnit == '-2' || evidentUnit == null ? '' : '$evidentUnit',
        'package_id':
            packageId == '-2' || packageId == null ? '' : '$packageId',
        'package_other': packageOther,
        'is_evident_operate':
            isEvidentOperate == null ? '' : '$isEvidentOperate',
        'department_id': departmentId == '-2' ||
                departmentId == null ||
                departmentId == 'null'
            ? '0'
            : '$departmentId',
        'workgroup_id':
            workGroupId == '-2' || workGroupId == null || workGroupId == 'null'
                ? '0'
                : '$workGroupId',
        'active_flag': '1',
        'case_evident_location': caseEvidentLocation,
        'personal_id':
            personalId == '-2' || personalId == null || personalId == 'null'
                ? ''
                : '$personalId',
      };

  Map toJson() => {
        'id': id == '-2' || id == null ? '' : '$id',
        'evident_no': evidentNo,
        'evident_type_id': evidentTypeId == '-2' || evidentTypeId == null
            ? ''
            : '$evidentTypeId',
        'evident_detail': evidentDetail,
        'evident_amount': evidentAmount,
        'evidentUnit':
            evidentUnit == '-2' || evidentUnit == null ? '' : '$evidentUnit',
        'package_id':
            packageId == '-2' || packageId == null ? '' : '$packageId',
        'package_other': packageOther,
        'is_evident_operate':
            isEvidentOperate == null ? '' : '$isEvidentOperate',
        'department_id': departmentId == '-2' ||
                departmentId == null ||
                departmentId == 'null'
            ? '0'
            : '$departmentId',
        'workgroup_id':
            workGroupId == '-2' || workGroupId == null || workGroupId == 'null'
                ? '0'
                : '$workGroupId',
        'active_flag': '1',
        'case_evident_location': caseEvidentLocation,
        'personal_id':
            personalId == '-2' || personalId == null || personalId == 'null'
                ? ''
                : '$personalId',
      };
}

class CaseEvidentDao {
  Future<dynamic> createCaseEvident(
      int fidsId,
      String evidentNo,
      int evidentTypeId,
      String? evidentDetail,
      int evidentAmount,
      String? evidentUnit,
      int packageId,
      String? packageOther,
      int isEvidentOperate,
      int departmentId,
      int workGroupId,
      int caseEvidentFoundId,
      int deliverWorkGroupID,
      String evidenceCheckID,
      String createDate,
      String createBy,
      String updateDate,
      String updateBy,
      int activeFlag,
      String personalId) async {
    final db = await DBProvider.db.database;
    var res = await db.rawInsert('''
      INSERT INTO CaseEvident (
        FidsID,EvidentNo,EvidentTypeID,EvidentDetails,EvidentAmount,EvidentUnit,PackageID,PackageOther,IsEvidentOperate,DepartmentID,WorkGroupID,deliverWorkGroupID,EvidenceCheckID,CreateDate,CreateBy,UpdateDate,UpdateBy,ActiveFlag,PersonalID
      ) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)
    ''', [
      fidsId,
      evidentNo,
      evidentTypeId,
      evidentDetail,
      evidentAmount,
      evidentUnit,
      packageId,
      packageOther,
      isEvidentOperate,
      departmentId,
      workGroupId,
      deliverWorkGroupID,
      evidenceCheckID,
      createDate,
      createBy,
      updateDate,
      updateBy,
      activeFlag,
      personalId
    ]);

    return res;
  }

  Future<dynamic> createCaseEvidentTraffic(
      int fidsId,
      String? evidentNo,
      String? evidentDetail,
      String? vehiclePosition,
      int evidentAmount,
      String? evidentUnit,
      int isEvidentOperate,
      int departmentId,
      int workGroupId,
      String? caseVehicleId) async {
    final db = await DBProvider.db.database;
    var res = await db.rawInsert('''
      INSERT INTO CaseEvident (
        FidsID,EvidentNo,EvidentDetails,VehiclePosition,EvidentAmount,EvidentUnit,IsEvidentOperate,DepartmentID,WorkGroupID,CaseVehicelID
      ) VALUES (?,?,?,?,?,?,?,?,?,?)
    ''', [
      fidsId,
      evidentNo,
      evidentDetail,
      vehiclePosition,
      evidentAmount,
      evidentUnit,
      isEvidentOperate,
      departmentId,
      workGroupId,
      caseVehicleId,
    ]);

    return res;
  }

  Future<dynamic> updateCaseEvidentTraffic(
    String? evidentNo,
    String? evidentDetail,
    String? vehiclePosition,
    int evidentAmount,
    String? evidentUnit,
    int isEvidentOperate,
    int departmentId,
    int workGroupId,
    String? id,
  ) async {
    final db = await DBProvider.db.database;
    var res = await db.rawUpdate('''
      UPDATE CaseEvident SET
        EvidentNo = ?, EvidentDetails = ?, VehiclePosition = ?, EvidentAmount = ?, EvidentUnit = ?, IsEvidentOperate = ? , DepartmentID = ? , WorkGroupID = ? WHERE ID = ?
    ''', [
      evidentNo,
      evidentDetail,
      vehiclePosition,
      evidentAmount,
      evidentUnit,
      isEvidentOperate,
      departmentId,
      workGroupId,
      id
    ]);
    if (kDebugMode) {
      print('res : $res');
    }
    return res;
  }

  Future<dynamic> updateCaseEvident(
      int fidsId,
      String? evidentNo,
      int evidentTypeId,
      String? evidentDetail,
      int evidentAmount,
      String? evidentUnit,
      int packageId,
      String? packageOther,
      int isEvidentOperate,
      int departmentId,
      int workGroupId,
      int caseEvidentFoundId,
      int deliverWorkGroupID,
      String? evidenceCheckID,
      String? createDate,
      String? createBy,
      String? updateDate,
      String? updateBy,
      int activeFlag,
      String? id,
      String? personalId) async {
    final db = await DBProvider.db.database;
    var res = await db.rawUpdate('''
      UPDATE CaseEvident SET
        FidsID = ?, EvidentNo = ?, EvidentTypeID = ?, EvidentDetails = ?, EvidentAmount = ?, EvidentUnit = ?, PackageID = ? , IsEvidentOperate = ? , DepartmentID = ? , WorkGroupID = ?,deliverWorkGroupID = ?, EvidenceCheckID = ?,PackageOther = ?,PersonalID = ?  WHERE ID = ?
    ''', [
      fidsId,
      evidentNo,
      evidentTypeId,
      evidentDetail,
      evidentAmount,
      evidentUnit,
      packageId,
      isEvidentOperate,
      departmentId,
      workGroupId,
      deliverWorkGroupID,
      evidenceCheckID,
      packageOther,
      personalId,
      id
    ]);
    if (kDebugMode) {
      print('res : $res');
    }
    return res;
  }

  Future<List<CaseEvidentForm>?> getCaseEvident(int fidsID) async {
    final db = await DBProvider.db.database;
    var res = await db
        .query("CaseEvident", where: '"FidsID" = ?', whereArgs: ['$fidsID']);
    if (res.isEmpty) {
      return [];
    } else {
      var result = await db
          .query("CaseEvident", where: '"FidsID" = ?', whereArgs: ['$fidsID']);

      List<CaseEvidentForm> listResult = [];

      for (int i = 0; i < result.length; i++) {
        if (kDebugMode) {
          print(' ff : ${result[i]}');
        }
        CaseEvidentForm formResponse = CaseEvidentForm.fromJson(result[i]);
        var caseEvident = await CaseEvidentLocationDao()
            .getCaseEvidentLocationByEvidentId(formResponse.id);

        var caseEvidentDeliver = await CaseEvidentDeliverDao()
            .getCaseEvidentDeliver(formResponse.id ?? '');

        formResponse.caseEvidentLocation = caseEvident;
        formResponse.caseEvidentDeliver = caseEvidentDeliver;
        listResult.add(formResponse);
      }
      return listResult;
    }
  }

  Future<List<CaseEvidentForm>> getCaseEvidentTraffic(
      int fidsID, int caseVehicleId) async {
    final db = await DBProvider.db.database;
    var res = await db
        .query("CaseEvident", where: '"FidsID" = ?', whereArgs: ['$fidsID']);
    if (res.isEmpty) {
      return [];
    } else {
      var result = await db
          .query("CaseEvident", where: '"FidsID" = ?', whereArgs: ['$fidsID']);

      List<CaseEvidentForm> listResult = [];

      for (int i = 0; i < result.length; i++) {
        if (kDebugMode) {
          print(' ff : ${result[i]}');
        }
        CaseEvidentForm formResponse = CaseEvidentForm.fromJson(result[i]);
        var caseEvident = await CaseEvidentLocationDao()
            .getCaseEvidentLocationByEvidentId(formResponse.id);

        var caseEvidentDeliver = await CaseEvidentDeliverDao()
            .getCaseEvidentDeliver(formResponse.id ?? '');

        formResponse.caseEvidentLocation = caseEvident;
        formResponse.caseEvidentDeliver = caseEvidentDeliver;
        if (formResponse.caseVehicleId == caseVehicleId.toString()) {
          listResult.add(formResponse);
        }
      }
      return listResult;
    }
  }

  Future<CaseEvident?> getCaseEvidentById(String? id) async {
    final db = await DBProvider.db.database;
    var res =
        await db.query("CaseEvident", where: '"ID" = ?', whereArgs: ['$id']);
    if (res.isEmpty) {
      return null;
    } else {
      var result =
          await db.query("CaseEvident", where: '"ID" = ?', whereArgs: ['$id']);

      CaseEvident response = CaseEvident.fromJson(result[0]);

      return response;
    }
  }

  Future<dynamic> deleteCaseEvidentBy(String? id) async {
    final db = await DBProvider.db.database;

    var res = await db.rawDelete('''
      DELETE FROM CaseEvident WHERE ID = ?
    ''', [id]);
    if (kDebugMode) {
      print('DELETE Success');
    }
    return res;
  }

  Future<dynamic> delete(int fidsId) async {
    final db = await DBProvider.db.database;

    var res = await db.rawDelete('''
      DELETE FROM CaseEvident WHERE FidsID = ?
    ''', [fidsId]);
    if (kDebugMode) {
      print('DELETE Success');
    }
    return res;
  }
}
