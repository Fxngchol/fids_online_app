// ignore_for_file: file_names

import '../../../../models/CaseEvidentDeliver.dart';
import '../../../../models/CaseEvidentLocation.dart';

class CaseEvidentForm {
  String? id;
  String? fidsId;
  String? evidentNo;
  String? evidenceTypeID;
  String? evidenceCheckID;
  String? evidentDetail;
  String? evidentAmount;
  String? evidentUnit;
  String? packageID;
  String? packageOther;
  String? isEvidentOperate;
  String? workGroupID;
  String? departmentID;
  String? personalID;
  String? vehiclePosition;
  String? caseVehicleId;

  List<CaseEvidentLocation>? caseEvidentLocation = [];
  List<CaseEvidentDeliver>? caseEvidentDeliver = [];

  CaseEvidentForm(
      {this.id,
      this.fidsId,
      this.evidentNo,
      this.evidenceTypeID,
      this.evidenceCheckID,
      this.evidentDetail,
      this.evidentAmount,
      this.evidentUnit,
      this.packageID,
      this.packageOther,
      this.isEvidentOperate,
      this.workGroupID,
      this.departmentID,
      this.caseEvidentLocation,
      this.caseEvidentDeliver,
      this.personalID,
      this.vehiclePosition,
      this.caseVehicleId});
  factory CaseEvidentForm.fromJson(Map<String, dynamic> json) {
    return CaseEvidentForm(
      id: '${json['ID']}',
      fidsId: '${json['FidsID']}',
      evidentNo: json['EvidentNo'],
      evidenceTypeID: '${json['EvidentTypeID']}',
      evidenceCheckID: '${json['EvidenceCheckID']}',
      evidentDetail: json['EvidentDetails'],
      evidentAmount: json['EvidentAmount'],
      evidentUnit: '${json['EvidentUnit']}',
      packageID: '${json['PackageID']}',
      packageOther: '${json['PackageOther']}',
      isEvidentOperate: '${json['IsEvidentOperate']}',
      departmentID: '${json['DepartmentID']}',
      workGroupID: '${json['WorkGroupID']}',
      personalID: '${json['PersonalID']}',
      vehiclePosition: '${json['VehiclePosition']}',
      caseVehicleId: '${json['CaseVehicelID']}',
    );
  }

  factory CaseEvidentForm.fromApi(Map<String, dynamic> json) {
    return CaseEvidentForm(
      id: json['id'],
      fidsId: json['fisno'],
      evidentNo: json['evident_no'],
      evidenceTypeID: json['evident_type_id'],
      evidentDetail: json['evident_detail'],
      evidentAmount: json['evident_amount'],
      evidentUnit: json['EvidentUnit'],
      packageID: json['package_id'],
      packageOther: json['package_other'],
      isEvidentOperate: json['is_evident_operate'],
      departmentID: json['department_id'],
      workGroupID: json['workgroup_id'],
      personalID: '${json['PersonalID']}',
      vehiclePosition: '${json['vehicle_position']}',
      caseVehicleId: '${json['case_vehicle_id']}',
    );
  }

  Map toJson() => {
        'id': id == '-2' || id == null ? '' : '$id',
        'evident_no': evidentNo ?? '',
        'evident_type_id': evidenceTypeID == '-2' || evidenceTypeID == null
            ? ''
            : '$evidenceTypeID',
        'evident_detail': evidentDetail ?? '',
        'evident_amount': evidentAmount ?? '',
        'EvidentUnit':
            evidentUnit == '-2' || evidentUnit == null ? '' : '$evidentUnit',
        'package_id':
            packageID == '-2' || packageID == null ? '' : '$packageID',
        'package_other': packageOther == null ? '' : '$packageOther',
        'is_evident_operate':
            isEvidentOperate == null || isEvidentOperate == '-1'
                ? ''
                : '$isEvidentOperate',
        'department_id': departmentID == '-2' ||
                departmentID == null ||
                departmentID == 'null'
            ? '0'
            : '$departmentID',
        'workgroup_id':
            workGroupID == '-2' || workGroupID == null || workGroupID == 'null'
                ? '0'
                : '$workGroupID',
        'active_flag': '1',
        'case_evident_location': caseEvidentLocation,
        'case_evident_deliver': caseEvidentDeliver,
        'personal_id':
            personalID == '-2' || personalID == null || personalID == 'null'
                ? ''
                : '$personalID',
        'case_vehicle_id': caseVehicleId,
      };

  @override
  String toString() {
    return 'CaseEvidentForm(id: $id, fidsId: $fidsId, evidentNo: $evidentNo, evidenceTypeID: $evidenceTypeID, evidenceCheckID: $evidenceCheckID, evidentDetail: $evidentDetail, evidentAmount: $evidentAmount, evidentUnit: $evidentUnit, packageID: $packageID, packageOther: $packageOther, isEvidentOperate: $isEvidentOperate, workGroupID: $workGroupID, departmentID: $departmentID, personalID: $personalID, vehiclePosition: $vehiclePosition, caseVehicleId: $caseVehicleId, caseEvidentLocation: $caseEvidentLocation, caseEvidentDeliver: $caseEvidentDeliver)';
  }
}
