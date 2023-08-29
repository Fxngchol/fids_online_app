// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import '../utils/database/database.dart';

class FidsCrimeScene {
  int? fidsid;
  int? isMobileCreate;
  String? fidsNo;
  int? departmentID;
  int? caseCategoryID;
  int? isoSubCaseCategoryID;
  String? caseIssueDate;
  String? caseIssueTime;
  int? isCaseNotification;
  String? caseVictimDate;
  String? caseVictimTime;
  String? caseOfficerDate;
  String? caseOfficerTime;

  int? issueMedia;
  String? issueMediaDetail;
  int? policeStationID;
  int? investigatorTitleID;
  String? investigatorName;
  String? isoCaseNo;
  String? isoInvestigatorTel;
  String? sceneDescription;
  int? sceneProvinceID;
  int? sceneAmphurID;
  int? sceneTambolID;
  String? isoLatitude;
  String? isoLongtitude;
  String? policeDaily;

  // DateTime policeDailyDate;
  String? policeDailyDate;

  String? deliverBookNo;

  // DateTime deliverBookDate;
  String? deliverBookDate;

  int? isSceneProtection;
  String? sceneProtectionDetails;
  String? lightCondition;
  String? lightConditionDetails;
  String? temperatureCondition;
  String? tempetatureConditionDetails;
  int? isSmell;
  String? smellDetails;

  String? caseBehavior;
  String? isoDamage;
  String? isoBombLocation;
  String? caseEntranceDetails;
  int? isFightingClue;
  String? fightingClueDetails;
  int? isRansackClue;
  String? ransackClueDetails;
  String? isBodyFound;
  int? isoIsFinal;
  int? isoIsComplete;
  int? isoIsDeliver;
  String? closeDate;
  String? closeTime;

  String? sceneType;
  String? sceneDetails;
  String? sceneFront;
  String? sceneLeft;
  String? sceneRight;
  String? sceneBack;
  String? sceneLocation;

  int? buildingTypeId;
  String? isoBuildingDetail;
  String? floor;
  int? isFence;
  int? isOutside;

  String? subCaseCategoryOther;
  String? reportNo;
  String? isoOtherDepartment;
  String? receiveSignature;
  String? receiveTitleID;
  String? receiveName;
  String? receivePosition;
  String? sendSignature;
  String? sendPersonID;
  String? sendPosition;

  String? isoIsClue;
  String? isoIsLock;

  String? criminalAmount;
  String? isoIsWeapon;
  String? isoIsWeaponType1;
  String? isoIsWeaponType2;
  String? isoIsWeaponType3;
  String? isoIsWeaponType4;
  String? isoWeaponType4Detail;
  String? isoIsImprisonInRoom;
  String? isoIsImprison;
  String? isoImprison;
  String? isoImprisonDetail;
  String? isoIscasualty;
  String? isoIsDeceased;
  String? isoCasualtyDetail;
  String? buildingTypeOther;
  String? isoBombSize;

  String? objective;
  String? exhibitLocation;
  String? exhibitDate;
  String? exhibitTime;
  int? trafficObjective;
  String? trafficObjectiveOther;
  String? fireTypeID;
  String? fireAreaDetail;
  String? fireMainSwitch;
  String? fireSourceArea;
  String? fireFuel;
  String? fireHeatSource;
  String? fireOpinion;
  String? fireDamagedDetail;

  FidsCrimeScene(
      {this.fidsid,
      this.isMobileCreate,
      this.fidsNo,
      this.departmentID,
      this.caseCategoryID,
      this.isoSubCaseCategoryID,
      this.caseIssueDate,
      this.caseIssueTime,
      this.isCaseNotification,
      this.caseVictimDate,
      this.caseVictimTime,
      this.caseOfficerDate,
      this.caseOfficerTime,
      this.issueMedia,
      this.issueMediaDetail,
      this.policeStationID,
      this.isBodyFound,
      this.investigatorTitleID,
      this.investigatorName,
      this.isoCaseNo,
      this.isoInvestigatorTel,
      this.sceneDescription,
      this.sceneProvinceID,
      this.sceneAmphurID,
      this.sceneTambolID,
      this.isoLatitude,
      this.isoLongtitude,
      this.policeDaily,
      this.policeDailyDate,
      this.deliverBookNo,
      this.deliverBookDate,
      this.isSceneProtection,
      this.sceneProtectionDetails,
      this.lightCondition,
      this.lightConditionDetails,
      this.temperatureCondition,
      this.tempetatureConditionDetails,
      this.isSmell,
      this.smellDetails,
      this.caseBehavior,
      this.isoDamage,
      this.isoBombLocation,
      this.caseEntranceDetails,
      this.isFightingClue,
      this.fightingClueDetails,
      this.isRansackClue,
      this.ransackClueDetails,
      this.isoIsFinal,
      this.isoIsComplete,
      this.isoIsDeliver,
      this.closeDate,
      this.closeTime,
      this.sceneType,
      this.sceneDetails,
      this.sceneFront,
      this.sceneLeft,
      this.sceneRight,
      this.sceneBack,
      this.sceneLocation,
      this.buildingTypeId,
      this.isoBuildingDetail,
      this.floor,
      this.isFence,
      this.isOutside,
      this.subCaseCategoryOther,
      this.reportNo,
      this.isoOtherDepartment,
      this.receiveSignature,
      this.receiveTitleID,
      this.receiveName,
      this.receivePosition,
      this.sendSignature,
      this.sendPersonID,
      this.sendPosition,
      this.isoIsClue,
      this.isoIsLock,
      this.criminalAmount,
      this.isoIsWeapon,
      this.isoIsWeaponType1,
      this.isoIsWeaponType2,
      this.isoIsWeaponType3,
      this.isoIsWeaponType4,
      this.isoWeaponType4Detail,
      this.isoIsImprisonInRoom,
      this.isoIsImprison,
      this.isoImprison,
      this.isoImprisonDetail,
      this.isoIscasualty,
      this.isoIsDeceased,
      this.isoCasualtyDetail,
      this.buildingTypeOther,
      this.isoBombSize,
      this.objective,
      this.exhibitLocation,
      this.exhibitDate,
      this.exhibitTime,
      this.trafficObjective,
      this.trafficObjectiveOther,
      this.fireTypeID,
      this.fireAreaDetail,
      this.fireMainSwitch,
      this.fireSourceArea,
      this.fireFuel,
      this.fireHeatSource,
      this.fireOpinion,
      this.fireDamagedDetail});

  factory FidsCrimeScene.fromJson(Map<String, dynamic> json) {
    return FidsCrimeScene(
        fidsid: json['ID'],
        isMobileCreate: json['IsMobileCreate'],
        fidsNo: json['FidsNo'],
        departmentID: json['DepartmentID'],
        caseCategoryID: json['CaseCategoryID'],
        isoSubCaseCategoryID: json['ISO_SubCaseCategoryID'],
        caseIssueDate: json['CaseIssueDate'],
        caseIssueTime: json['CaseIssueTime'],
        isCaseNotification: json['IsCaseNotification'],
        caseVictimDate: json['CaseVictimDate'],
        caseVictimTime: json['CaseVictimTime'],
        caseOfficerDate: json['CaseOfficerDate'],
        caseOfficerTime: json['CaseOfficerTime'],
        issueMedia: json['IssueMedia'],
        issueMediaDetail: json['IssueMediaDetail'],
        policeStationID: json['PoliceStationID'],
        investigatorTitleID: json['InvestigatorTitleID'],
        investigatorName: json['InvestigatorName'],
        isoCaseNo: json['Iso_CaseNo'],
        isoInvestigatorTel: json['Iso_InvestigatorTel'],
        sceneDescription: json['SceneDescription'],
        sceneProvinceID: json['SceneProvinceID'],
        sceneAmphurID: json['SceneAmphurID'],
        sceneTambolID: json['SceneTambolID'],
        isoLatitude: json['Iso_Latitude'],
        isoLongtitude: json['Iso_Longtitude'] ?? '',
        policeDaily: json['PoliceDaily'],
        policeDailyDate: json['PoliceDailyDate'],
        deliverBookNo: json['DeliverBookNo'],
        deliverBookDate: json['DeliverBookDate'],
        isSceneProtection: json['IsSceneProtection'] ?? -1,
        sceneProtectionDetails: json['SceneProtectionDetails'],
        lightCondition: json['LightCondition'],
        lightConditionDetails: json['LightConditionDetails'],
        temperatureCondition: json['TemperatureCondition'],
        tempetatureConditionDetails: json['TemperatureConditionDetails'],
        isSmell: json['IsSmell'],
        smellDetails: json['SmellDetails'],
        caseBehavior: json['CaseBehavior'],
        isoDamage: json['Iso_Damage'],
        isoBombLocation: json['Iso_BombLocation'],
        caseEntranceDetails: json['CaseEntranceDetails'],
        isFightingClue: json['IsFightingClue'],
        fightingClueDetails: json['FightingClueDetails'],
        isRansackClue: json['IsRansackClue'],
        ransackClueDetails: json['RansackClueDetails'],
        isoIsFinal: json['Iso_IsFinal'],
        isoIsComplete: json['Iso_IsComplete'],
        isoIsDeliver: json['Iso_IsDeliver'],
        closeDate: json['CloseDate'],
        closeTime: json['CloseTime'],
        sceneType: json['SceneType'],
        sceneDetails: json['SceneDetails'],
        sceneFront: json['SceneFront'],
        sceneLeft: json['SceneLeft'],
        sceneRight: json['SceneRight'],
        sceneBack: json['SceneBack'],
        sceneLocation: json['SceneLocation'],
        buildingTypeId: json['BuildingTypeid'],
        isoBuildingDetail: json['Iso_BuildingDetail'],
        floor: json['Floor'],
        isFence: json['IsFence'],
        isOutside: json['isOutside'],
        subCaseCategoryOther: json['SubCaseCategoryOther'],
        reportNo: json['ReportNo'],
        isoOtherDepartment: json['Iso_OtherDepartment'],
        receiveSignature: json['ReceiveSignature'],
        receiveTitleID: json['ReceiveTitleID'],
        receiveName: json['ReceiveName'],
        receivePosition: json['ReceivePosition'],
        sendSignature: json['SendSignature'],
        sendPersonID: json['SendPersonID'],
        sendPosition: json['SendPosition'],
        isoIsClue: json['Iso_IsClue'],
        isoIsLock: json['Iso_IsLock'],
        criminalAmount: json['CriminalAmount'],
        isoIsWeapon: json['Iso_IsWeapon'],
        isoIsWeaponType1: json['Iso_IsWeaponType1'],
        isoIsWeaponType2: json['Iso_IsWeaponType2'],
        isoIsWeaponType3: json['Iso_IsWeaponType3'],
        isoIsWeaponType4: json['Iso_IsWeaponType4'],
        isoWeaponType4Detail: json['Iso_WeaponType4Detail'],
        isoIsImprisonInRoom: json['Iso_IsImprisonInRoom'],
        isoIsImprison: json['Iso_IsImprison'],
        isoImprison: json['Iso_Imprison'],
        isoImprisonDetail: json['IsoImprisonDetail'],
        isoIscasualty: json['Iso_IsCasualty'],
        isoIsDeceased: json['Iso_IsDeceased'],
        isoCasualtyDetail: json['IsoCasualtyDetail'],
        buildingTypeOther: json['BuildingTypeOther'],
        isoBombSize: json['Iso_BombSize'],
        isBodyFound: json['IsBodyFound'] ?? '',
        objective: json['Objective'],
        exhibitLocation: json['ExhibitLocation'],
        exhibitDate: json['ExhibitDate'],
        exhibitTime: json['ExhibitTime'] ?? '',
        trafficObjective: json['TrafficObjective'] ?? -1,
        trafficObjectiveOther: json['TrafficObjectiveOther'] ?? '',
        fireTypeID: json['FireTypeID'] ?? '',
        fireAreaDetail: json['FireAreaDetail'] ?? '',
        fireMainSwitch: json['FireMainSwitch'] ?? '',
        fireSourceArea: json['FireSourceArea'] ?? '',
        fireFuel: json['FireFuel'] ?? '',
        fireHeatSource: json['FireHeatSource'] ?? '',
        fireOpinion: json['FireOpinion'] ?? '',
        fireDamagedDetail: json['FireDamagedDetail'] ?? '');
  }

  @override
  String toString() {
    return 'FidsCrimeScene(fidsid: $fidsid, isMobileCreate: $isMobileCreate, fidsNo: $fidsNo, departmentID: $departmentID, caseCategoryID: $caseCategoryID, isoSubCaseCategoryID: $isoSubCaseCategoryID, caseIssueDate: $caseIssueDate, caseIssueTime: $caseIssueTime, isCaseNotification: $isCaseNotification, caseVictimDate: $caseVictimDate, caseVictimTime: $caseVictimTime, caseOfficerDate: $caseOfficerDate, caseOfficerTime: $caseOfficerTime, issueMedia: $issueMedia, issueMediaDetail: $issueMediaDetail, policeStationID: $policeStationID, investigatorTitleID: $investigatorTitleID, investigatorName: $investigatorName, isoCaseNo: $isoCaseNo, isoInvestigatorTel: $isoInvestigatorTel, sceneDescription: $sceneDescription, sceneProvinceID: $sceneProvinceID, sceneAmphurID: $sceneAmphurID, sceneTambolID: $sceneTambolID, isoLatitude: $isoLatitude, isoLongtitude: $isoLongtitude, policeDaily: $policeDaily, policeDailyDate: $policeDailyDate, deliverBookNo: $deliverBookNo, deliverBookDate: $deliverBookDate, isSceneProtection: $isSceneProtection, sceneProtectionDetails: $sceneProtectionDetails, lightCondition: $lightCondition, lightConditionDetails: $lightConditionDetails, temperatureCondition: $temperatureCondition, tempetatureConditionDetails: $tempetatureConditionDetails, isSmell: $isSmell, smellDetails: $smellDetails, caseBehavior: $caseBehavior, isoDamage: $isoDamage, isoBombLocation: $isoBombLocation, caseEntranceDetails: $caseEntranceDetails, isFightingClue: $isFightingClue, fightingClueDetails: $fightingClueDetails, isRansackClue: $isRansackClue, ransackClueDetails: $ransackClueDetails, isBodyFound: $isBodyFound, isoIsFinal: $isoIsFinal, isoIsComplete: $isoIsComplete, isoIsDeliver: $isoIsDeliver, closeDate: $closeDate, closeTime: $closeTime, sceneType: $sceneType, sceneDetails: $sceneDetails, sceneFront: $sceneFront, sceneLeft: $sceneLeft, sceneRight: $sceneRight, sceneBack: $sceneBack, sceneLocation: $sceneLocation, buildingTypeId: $buildingTypeId, isoBuildingDetail: $isoBuildingDetail, floor: $floor, isFence: $isFence, isOutside: $isOutside, subCaseCategoryOther: $subCaseCategoryOther, reportNo: $reportNo, isoOtherDepartment: $isoOtherDepartment, receiveSignature: $receiveSignature, receiveTitleID: $receiveTitleID, receiveName: $receiveName, receivePosition: $receivePosition, sendSignature: $sendSignature, sendPersonID: $sendPersonID, sendPosition: $sendPosition, isoIsClue: $isoIsClue, isoIsLock: $isoIsLock, criminalAmount: $criminalAmount, isoIsWeapon: $isoIsWeapon, isoIsWeaponType1: $isoIsWeaponType1, isoIsWeaponType2: $isoIsWeaponType2, isoIsWeaponType3: $isoIsWeaponType3, isoIsWeaponType4: $isoIsWeaponType4, isoWeaponType4Detail: $isoWeaponType4Detail, isoIsImprisonInRoom: $isoIsImprisonInRoom, isoIsImprison: $isoIsImprison, isoImprison: $isoImprison, isoImprisonDetail: $isoImprisonDetail, isoIscasualty: $isoIscasualty, isoIsDeceased: $isoIsDeceased, isoCasualtyDetail: $isoCasualtyDetail, buildingTypeOther: $buildingTypeOther, isoBombSize: $isoBombSize, objective: $objective, exhibitLocation: $exhibitLocation, exhibitDate: $exhibitDate, exhibitTime: $exhibitTime, trafficObjective: $trafficObjective, trafficObjectiveOther: $trafficObjectiveOther, fireTypeID: $fireTypeID, fireAreaDetail: $fireAreaDetail, fireMainSwitch: $fireMainSwitch, fireSourceArea: $fireSourceArea, fireFuel: $fireFuel, fireHeatSource: $fireHeatSource, fireOpinion: $fireOpinion, fireDamagedDetail: $fireDamagedDetail)';
  }
}

class FidsCrimeSceneDao {
  Future<dynamic> createFidsCrimeScene(
      String? fidsNo,
      int? caseCategoryID,
      int? subCaseCategory,
      String? isoCaseNo,
      String? caseIssueDate,
      String? caseIssueTime,
      int? issueMedia,
      String? issueMediaDetail,
      String? deliverBookNo,
      String? deliverBookDate,
      int? policeStationId,
      String? isoOtherDepartment,
      String? policeDaily,
      String? policaDailyDate,
      int? investigatorTitleID,
      String? investigatorName,
      String? isoInvestigatorTel,
      int? provinceId,
      String? subCaseCategoryOther,
      String? reportNo,
      String? fireTypeID) async {
    final db = await DBProvider.db.database;

    var res = await db.rawInsert('''
      INSERT INTO FidsCrimeScene (
        IsMobileCreate,FidsNo,CaseCategoryID,ISO_SubCaseCategoryID,Iso_CaseNo,
        CaseIssueDate,CaseIssueTime,IssueMedia,IssueMediaDetail,DeliverBookNo,
        DeliverBookDate,PoliceStationID,Iso_OtherDepartment,PoliceDaily,PoliceDailyDate,
        InvestigatorTitleID,InvestigatorName,Iso_InvestigatorTel, SceneProvinceID,SubCaseCategoryOther,ReportNo,FireTypeID
      ) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)
    ''', [
      1,
      fidsNo,
      caseCategoryID,
      subCaseCategory,
      isoCaseNo,
      caseIssueDate,
      caseIssueTime,
      issueMedia,
      issueMediaDetail,
      deliverBookNo,
      deliverBookDate,
      policeStationId,
      isoOtherDepartment,
      policeDaily,
      policaDailyDate,
      investigatorTitleID,
      investigatorName,
      isoInvestigatorTel,
      provinceId,
      subCaseCategoryOther,
      reportNo,
      fireTypeID
    ]);
    // }

    return res;
  }

  Future<dynamic> createFidsCrimeSceneDownload(
      String? fidsNo,
      int? caseCategoryID,
      int? subCaseCategory,
      String? isoCaseNo,
      String? caseIssueDate,
      String? caseIssueTime,
      int? issueMedia,
      String? issueMediaDetail,
      String? deliverBookNo,
      String? deliverBookDate,
      int? policeStationId,
      String? isoOtherDepartment,
      String? policeDaily,
      String? policaDailyDate,
      int? investigatorTitleID,
      String? investigatorName,
      String? isoInvestigatorTel,
      int? provinceId,
      String? subCaseCategoryOther,
      String? reportNo,
      String? fireTypeID) async {
    final db = await DBProvider.db.database;

    var res = await db.rawInsert('''
      INSERT INTO FidsCrimeScene (
        IsMobileCreate,FidsNo,CaseCategoryID,ISO_SubCaseCategoryID,Iso_CaseNo,
        CaseIssueDate,CaseIssueTime,IssueMedia,IssueMediaDetail,DeliverBookNo,
        DeliverBookDate,PoliceStationID,Iso_OtherDepartment,PoliceDaily,PoliceDailyDate,
        InvestigatorTitleID,InvestigatorName,Iso_InvestigatorTel, SceneProvinceID,SubCaseCategoryOther,ReportNo,FireTypeID
      ) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)
    ''', [
      1,
      fidsNo,
      caseCategoryID,
      subCaseCategory,
      isoCaseNo,
      caseIssueDate,
      caseIssueTime,
      issueMedia,
      issueMediaDetail,
      deliverBookNo,
      deliverBookDate,
      policeStationId,
      isoOtherDepartment,
      policeDaily,
      policaDailyDate,
      investigatorTitleID,
      investigatorName,
      isoInvestigatorTel,
      provinceId,
      subCaseCategoryOther,
      reportNo,
      fireTypeID
    ]);
    // }

    return res;
  }

  Future<dynamic> updateTrafficObj(
    String? id,
    int? trafficObjective,
    String? trafficObjectiveOther,
  ) async {
    final db = await DBProvider.db.database;
    var res = await db.rawUpdate('''
      UPDATE FidsCrimeScene SET TrafficObjective = ?,TrafficObjectiveOther = ?
       WHERE ID = ?
    ''', [
      trafficObjective,
      trafficObjectiveOther,
      id,
    ]);

    return res;
  }

  Future<dynamic> updateFidsCrimeScene(
      int? caseCategoryID,
      int? subCaseCategory,
      String? isoCaseNo,
      String? caseIssueDate,
      String? caseIssueTime,
      int? issueMedia,
      String? issueMediaDetail,
      String? deliverBookNo,
      String? deliverBookDate,
      int? policeStationId,
      String? isoOtherDepartment,
      String? policeDaily,
      String? policaDailyDate,
      int? investigatorTitleID,
      String? investigatorName,
      String? isoInvestigatorTel,
      int? provinceId,
      int? id,
      String? subCaseCategoryOther,
      String? reportNo,
      fireTypeID) async {
    final db = await DBProvider.db.database;

    //  List<Map> result = await db.query("FidsCrimeScene");

    var res = await db.rawUpdate('''
      UPDATE FidsCrimeScene SET IsMobileCreate = ?,CaseCategoryID = ?,
      ISO_SubCaseCategoryID = ?,Iso_CaseNo = ?,CaseIssueDate = ?, CaseIssueTime = ?,
      IssueMedia = ?,IssueMediaDetail = ?,DeliverBookNo = ?,DeliverBookDate = ?,
      PoliceStationID = ?,Iso_OtherDepartment = ?, PoliceDaily = ?, PoliceDailyDate = ?,
      InvestigatorTitleID = ?,InvestigatorName = ?,Iso_InvestigatorTel = ? ,SceneProvinceID = ? ,SubCaseCategoryOther = ? ,ReportNo = ? ,FireTypeID = ?
       WHERE ID = ?
    ''', [
      1,
      caseCategoryID,
      subCaseCategory,
      isoCaseNo,
      caseIssueDate,
      caseIssueTime,
      issueMedia,
      issueMediaDetail,
      deliverBookNo,
      deliverBookDate,
      policeStationId,
      isoOtherDepartment,
      policeDaily,
      policaDailyDate,
      investigatorTitleID,
      investigatorName,
      isoInvestigatorTel,
      provinceId,
      subCaseCategoryOther,
      reportNo,
      fireTypeID,
      id
    ]);

    return res;
  }

  Future<dynamic> updateIsOutside(int isOutside, int caseId) async {
    final db = await DBProvider.db.database;
    var res = await db.rawUpdate('''
      UPDATE FidsCrimeScene SET isOutside = ?
       WHERE ID = ?
    ''', [isOutside, caseId]);
    if (kDebugMode) {
      print('UPDATE Success');
    }
    return res;
  }

  Future<dynamic> updateTrafficObjective(
      int? trafficObjective, trafficObjectiveOther, int caseId) async {
    final db = await DBProvider.db.database;
    var res = await db.rawUpdate('''
      UPDATE FidsCrimeScene SET TrafficObjective = ?,TrafficObjectiveOther = ?
       WHERE ID = ?
    ''', [trafficObjective, trafficObjectiveOther, caseId]);
    if (kDebugMode) {
      print('UPDATE Success');
    }
    return res;
  }

  Future<dynamic> updateIsBodyFound(String isBodyFound, int caseId) async {
    final db = await DBProvider.db.database;

    var res = await db.rawUpdate('''
      UPDATE FidsCrimeScene SET IsBodyFound = ?
       WHERE ID = ?
    ''', [isBodyFound, caseId]);
    if (kDebugMode) {
      print('UPDATE Success');
    }
    return res;
  }

  Future<dynamic> deleteFidsCrimeScene(int id) async {
    final db = await DBProvider.db.database;
    var res = await db.rawDelete('''
      DELETE FROM FidsCrimeScene WHERE ID = ?
    ''', [id]);
    if (kDebugMode) {
      print('DELETE Success');
    }
    return res;
  }

  Future<dynamic> updateLocationCase(
      String? sceneDescription,
      int? sceneTambolId,
      int? sceneAmphurId,
      int? sceneProvinceId,
      String? isoLatitude,
      String? isoLongtitude,
      String? id) async {
    final db = await DBProvider.db.database;

    var res = await db.rawUpdate('''
      UPDATE FidsCrimeScene SET SceneDescription = ?,SceneTambolID = ?,SceneAmphurID = ?,SceneProvinceID = ?,Iso_Latitude = ?,Iso_Longtitude = ? WHERE ID = ?
    ''', [
      sceneDescription,
      sceneTambolId,
      sceneAmphurId,
      sceneProvinceId,
      isoLatitude,
      isoLongtitude,
      id
    ]);

    return res;
  }

  Future<dynamic> updateCaseDateTime(
      int? isCaseNotification,
      String? caseVictimDate,
      String? caseVictimTime,
      String? caseOfficerDate,
      String? caseOfficerTime,
      String? id) async {
    final db = await DBProvider.db.database;

    var res = await db.rawUpdate('''
      UPDATE FidsCrimeScene SET IsCaseNotification = ?,CaseVictimDate = ?,CaseVictimTime = ?,CaseOfficerDate = ?,CaseOfficerTime = ? WHERE ID = ?
    ''', [
      isCaseNotification,
      caseVictimDate,
      caseVictimTime,
      caseOfficerDate,
      caseOfficerTime,
      id
    ]);
    return res;
  }

  Future<dynamic> updateSceneLocation(
      int? isSceneProtection,
      String? sceneProtectionDetails,
      String? lightCondition,
      String? lightConditionDetails,
      String? temperatureCondition,
      String? temperatureConditionDetails,
      int? isSmell,
      String? smellDetails,
      String? id) async {
    final db = await DBProvider.db.database;

    var res = await db.rawUpdate('''
      UPDATE FidsCrimeScene SET IsSceneProtection = ?,SceneProtectionDetails = ?,LightCondition = ?,LightConditionDetails = ?,TemperatureCondition = ?,TemperatureConditionDetails = ?,IsSmell = ?,SmellDetails = ? WHERE ID = ?
    ''', [
      isSceneProtection,
      sceneProtectionDetails,
      lightCondition,
      lightConditionDetails,
      temperatureCondition,
      temperatureConditionDetails,
      isSmell,
      smellDetails,
      id
    ]);
    return res;
  }

  Future<dynamic> updateResultCase(
      String? caseBehavior,
      String? caseEntranceDetails,
      int? isFightingClue,
      String? fightingClueDetails,
      int? isRansackClue,
      String? ransackClueDetails,
      String? id) async {
    final db = await DBProvider.db.database;

    var res = await db.rawUpdate('''
      UPDATE FidsCrimeScene SET CaseBehavior = ?,CaseEntranceDetails = ?,IsFightingClue = ?,FightingClueDetails = ?,IsRansackClue = ?,RansackClueDetails = ? WHERE ID = ?
    ''', [
      caseBehavior,
      caseEntranceDetails,
      isFightingClue,
      fightingClueDetails,
      isRansackClue,
      ransackClueDetails,
      id
    ]);
    return res;
  }

  Future<dynamic> updateReleaseCase(
      int? isoIsFinal,
      int? isoIsComplete,
      int? isoIsDeliver,
      String? closeDate,
      String? closeTime,
      String? receiveSignature,
      String? receiveTitleID,
      String? receiveName,
      String? receivePosition,
      String? sendSignature,
      String? sendPersonID,
      String? sendPosition,
      String? id) async {
    final db = await DBProvider.db.database;

    var res = await db.rawUpdate('''
      UPDATE FidsCrimeScene SET Iso_IsFinal = ?,Iso_IsComplete = ?,Iso_IsDeliver = ?,CloseDate = ?,CloseTime = ?,ReceiveSignature = ? ,ReceiveTitleID = ?,ReceiveName = ?,ReceivePosition = ?,SendSignature = ?,SendPersonID = ?,SendPosition = ? WHERE ID = ?
    ''', [
      isoIsFinal,
      isoIsComplete,
      isoIsDeliver,
      closeDate,
      closeTime,
      receiveSignature,
      receiveTitleID,
      receiveName,
      receivePosition,
      sendSignature,
      sendPersonID,
      sendPosition,
      id
    ]);
    return res;
  }

  Future<dynamic> updateSceneExternal(
      String? sceneType,
      String? sceneDetails,
      String? sceneFront,
      String? sceneLeft,
      String? sceneRight,
      String? sceneBack,
      String? sceneLocation,
      String? id) async {
    final db = await DBProvider.db.database;

    var res = await db.rawUpdate('''
      UPDATE FidsCrimeScene SET SceneType = ?,SceneDetails = ?,SceneFront = ?,SceneLeft = ?,SceneRight = ?,SceneBack = ?,SceneLocation = ? WHERE ID = ?
    ''', [
      sceneType,
      sceneDetails,
      sceneFront,
      sceneLeft,
      sceneRight,
      sceneBack,
      sceneLocation,
      id
    ]);
    return res;
  }

  Future<dynamic> updateSceneInternal(
      int? buildingTypeid,
      String? buildingTypeOther,
      String? isoBuildingDetail,
      String? floor,
      int? isFence,
      String? sceneFront,
      String? sceneLeft,
      String? sceneRight,
      String? sceneBack,
      String? id) async {
    final db = await DBProvider.db.database;

    var res = await db.rawUpdate('''
      UPDATE FidsCrimeScene SET BuildingTypeid = ?,BuildingTypeOther = ?,Iso_BuildingDetail = ?,Floor = ?,IsFence = ?,SceneFront = ?,SceneLeft = ?,SceneRight = ?,SceneBack = ? WHERE ID = ?
    ''', [
      buildingTypeid,
      buildingTypeOther,
      isoBuildingDetail,
      floor,
      isFence,
      sceneFront,
      sceneLeft,
      sceneRight,
      sceneBack,
      id
    ]);
    return res;
  }

  Future<dynamic> updateCasualtyDeceased(String isoIsCasualty,
      String isoIsDeceased, String? isoCasualtyDetail, String id) async {
    final db = await DBProvider.db.database;

    var res = await db.rawUpdate('''
      UPDATE FidsCrimeScene SET Iso_IsCasualty = ?,Iso_IsDeceased = ?,IsoCasualtyDetail = ? WHERE ID = ?
    ''', [isoIsCasualty, isoIsDeceased, isoCasualtyDetail, id]);
    return res;
  }

  Future<List<FidsCrimeScene>> getFidsCrimeScene() async {
    final db = await DBProvider.db.database;
    var res = await db.query("FidsCrimeScene");
    if (res.isEmpty) {
      return [];
    } else {
      var result = await db.query("FidsCrimeScene");

      List<FidsCrimeScene> listResult = [];

      for (int i = 0; i < result.length; i++) {
        Map<String, dynamic> res = result[i];
        FidsCrimeScene formResponse = FidsCrimeScene.fromJson(res);
        listResult.add(formResponse);
      }
      return listResult;
    }
  }

  Future<FidsCrimeScene?> getFidsCrimeSceneById(int id) async {
    final db = await DBProvider.db.database;
    var res = await db.query("FidsCrimeScene");
    if (res.isEmpty) {
      return null;
    } else {
      var result = await db
          .query("FidsCrimeScene", where: '"ID" = ?', whereArgs: ['$id']);

      FidsCrimeScene response = FidsCrimeScene.fromJson(result[0]);

      return response;
    }
  }

  Future<FidsCrimeScene?> getFidsCrimeSceneByFidsNo(fidsNo) async {
    final db = await DBProvider.db.database;
    var res = await db.query("FidsCrimeScene");
    if (res.isEmpty) {
      return null;
    } else {
      var result = await db.query("FidsCrimeScene",
          where: '"FidsNo" = ?', whereArgs: ['$fidsNo']);
      FidsCrimeScene response = FidsCrimeScene.fromJson(result[0]);
      return response;
    }
  }

  ///////////// BOMB ////////////////////
  Future<dynamic> updateBombResultCase(String caseBehavior, String isoDamage,
      String? isoBombLocation, String isoBombSize, String id) async {
    final db = await DBProvider.db.database;

    var res = await db.rawUpdate('''
      UPDATE FidsCrimeScene SET CaseBehavior = ?,Iso_Damage = ?,Iso_BombLocation = ?,Iso_BombSize = ? WHERE ID = ?
    ''', [caseBehavior, isoDamage, isoBombLocation, isoBombSize, id]);
    return res;
  }

  Future<dynamic> updateCrimeSceneBomb(
      int? isSceneProtection,
      String? sceneProtectionDetail,
      int? buildingTypeid,
      String? buildingTypeOther,
      String? isoBuildingDetail,
      String? floor,
      int? isFence,
      String? sceneFront,
      String? sceneLeft,
      String? sceneRight,
      String? sceneBack,
      String? id) async {
    final db = await DBProvider.db.database;

    var res = await db.rawUpdate('''
      UPDATE FidsCrimeScene SET IsSceneProtection = ?,SceneProtectionDetails = ?,BuildingTypeid = ?, BuildingTypeOther = ?, Iso_BuildingDetail = ?,Floor = ?,IsFence = ?,SceneFront = ?,SceneLeft = ?,SceneRight = ?,SceneBack = ? WHERE ID = ?
    ''', [
      isSceneProtection,
      sceneProtectionDetail,
      buildingTypeid,
      buildingTypeOther,
      isoBuildingDetail,
      floor,
      isFence,
      sceneFront,
      sceneLeft,
      sceneRight,
      sceneBack,
      id
    ]);
    return res;
  }

  /////// Asset //////
  Future<dynamic> updateCaseBehivior(String caseBehavior, String id) async {
    final db = await DBProvider.db.database;

    var res = await db.rawUpdate('''
      UPDATE FidsCrimeScene SET CaseBehavior = ? WHERE ID = ?
    ''', [caseBehavior, id]);
    return res;
  }

  Future<dynamic> updateFireAreaDetail(String fireAreaDetail, String id) async {
    final db = await DBProvider.db.database;
    var res = await db.rawUpdate('''
      UPDATE FidsCrimeScene SET FireAreaDetail = ? WHERE ID = ?
    ''', [fireAreaDetail, id]);
    return res;
  }

  Future<dynamic> updateFireMainSwitch(String fireMainSwitch, String id) async {
    final db = await DBProvider.db.database;

    var res = await db.rawUpdate('''
      UPDATE FidsCrimeScene SET FireMainSwitch = ? WHERE ID = ?
    ''', [fireMainSwitch, id]);
    return res;
  }

  Future<dynamic> updateFireResult(String fireSourceArea, String fireFuel,
      String? fireHeatSource, String id) async {
    final db = await DBProvider.db.database;

    var res = await db.rawUpdate('''
      UPDATE FidsCrimeScene SET FireSourceArea = ?,FireFuel = ?,FireHeatSource = ? WHERE ID = ?
    ''', [fireSourceArea, fireFuel, fireHeatSource, id]);
    return res;
  }

  Future<dynamic> updateFireOpinion(String fireOpinion, String id) async {
    final db = await DBProvider.db.database;
    var res = await db.rawUpdate('''
      UPDATE FidsCrimeScene SET FireOpinion = ? WHERE ID = ?
    ''', [fireOpinion, id]);
    return res;
  }

  Future<dynamic> updateFireDamagedDetail(
      String fireDamagedDetail, String id) async {
    final db = await DBProvider.db.database;
    var res = await db.rawUpdate('''
      UPDATE FidsCrimeScene SET FireDamagedDetail = ? WHERE ID = ?
    ''', [fireDamagedDetail, id]);
    return res;
  }

  Future<dynamic> updateAssetClueCase(
      String isoIsClue, String isoIsLock, String id) async {
    final db = await DBProvider.db.database;

    var res = await db.rawUpdate('''
      UPDATE FidsCrimeScene SET Iso_IsClue = ?,Iso_IsLock = ? WHERE ID = ?
    ''', [isoIsClue, isoIsLock, id]);
    return res;
  }

  Future<dynamic> updateAssetCriminal(
      String? criminalAmount,
      String? isoIsWeapon,
      String? isoIsWeaponType1,
      String? isoIsWeaponType2,
      String? isoIsWeaponType3,
      String? isoIsWeaponType4,
      String? isoWeaponType4Detail,
      String? isoIsImprisonInRoom,
      String? isoIsImprison,
      String? isoImprison,
      String? isoImprisonDetail,
      String? id) async {
    final db = await DBProvider.db.database;

    var res = await db.rawUpdate('''
      UPDATE FidsCrimeScene SET CriminalAmount = ?,Iso_IsWeapon = ?,Iso_IsWeaponType1 = ?,Iso_IsWeaponType2 = ?,Iso_IsWeaponType3 = ?, Iso_IsWeaponType4 = ?,Iso_WeaponType4Detail = ?,Iso_IsImprisonInRoom = ?,Iso_IsImprison = ?,Iso_Imprison = ?, IsoImprisonDetail = ? WHERE ID = ?
    ''', [
      criminalAmount,
      isoIsWeapon,
      isoIsWeaponType1,
      isoIsWeaponType2,
      isoIsWeaponType3,
      isoIsWeaponType4,
      isoWeaponType4Detail,
      isoIsImprisonInRoom,
      isoIsImprison,
      isoImprison,
      isoImprisonDetail,
      id
    ]);
    return res;
  }

  Future<dynamic> updateInspectionResult(
      String objective,
      String exhibitLocation,
      String? exhibitDate,
      String exhibitTime,
      String id) async {
    final db = await DBProvider.db.database;
    var res = await db.rawUpdate('''
      UPDATE FidsCrimeScene SET Objective = ?,ExhibitLocation = ?,ExhibitDate = ?, ExhibitTime = ? WHERE ID = ?
    ''', [objective, exhibitLocation, exhibitDate, exhibitTime, id]);
    return res;
  }
}
