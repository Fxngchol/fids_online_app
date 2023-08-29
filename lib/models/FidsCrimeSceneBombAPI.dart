// ignore_for_file: file_names

import 'package:shared_preferences/shared_preferences.dart';

import '../view/life_case/evident/model/CaseEvidentForm.dart';
import 'CaseBody.dart';
import 'CaseBomb.dart';
import 'CaseEvident.dart';
import 'CaseEvidentFound.dart';
import 'CaseImage.dart';
import 'CaseInspection.dart';
import 'CaseInspector.dart';
import 'CaseInternal.dart';
import 'CaseReferencePoint.dart';
import 'CaseRelatedPerson.dart';
import 'CaseSceneLocation.dart';
import 'DiagramLocation.dart';
import 'FidsCrimeScene.dart';

class FidsCrimeSceneBombAPI {
  String? fidsNo;
  String? departmentId;
  String? casecategoryId;
  String? isoSubcasecategoryId;
  String? caseIssueDate;
  String? caseIssueTime;
  String? isCaseNotification;
  String? caseVictimDate;
  String? caseVictimTime;
  String? caseOfficerDate;
  String? caseOfficerTime;
  String? deliverBookNo;
  String? deliverBookDate;
  String? issueMedia;
  String? issueMediaDetail;
  String? policeStationId;
  String? isoOtherDepartment;
  String? investigatorTitleId;
  String? investigatorName;
  String? isoCaseNo;
  String? isoInvestigatorTel;
  String? sceneDescription;
  String? sceneProvinceID;
  String? sceneAmphurID;
  String? sceneTambolID;
  String? isoLatitude;
  String? isoLongtitude;
  String? policeDaily;
  String? policeDailyDate;
  String? isSceneProtection;
  String? sceneProtectionDetails;
  String? lightCondition;
  String? lightConditionDetails;
  String? temperatureCondition;
  String? tempetatureConditionDetails;
  String? isSmell;
  String? smellDetails;
  String? isInternalBuilding;
  String? sceneType;
  String? sceneDetails;
  String? sceneFront;
  String? sceneLeft;
  String? sceneRight;
  String? sceneBack;
  String? sceneLocation;
  String? buildingTypeId;
  String? isoBuildingDetail;
  String? floor;
  String? isFence;
  List<CaseInternal>? caseInternal;
  List<CaseRelatedPerson>? caseRelatedPerson;
  List<CaseSceneLocation>? caseSceneLocation;
  String? caseBehavior;
  String? caseEntranceDetails;
  String? isFightingClue;
  String? fightingClueDetails;
  String? isRanksackClue;
  String? ranksackClueDetail;
  String? isoIsFinal;
  String? isoComplete;
  String? isoIsDeliver;
  String? closeDate;
  String? closeTime;
  List<CaseInspection>? caseInspection;
  List<CaseInspector>? caseInspector;
  List<CaseBody>? caseBody;
  List<CaseReferencePoint>? referencePoint;
  List<CaseEvidentFound>? caseEvidentFound;
  List<CaseEvidentForm>? caseEvident;
  List<CaseImages>? caseimage;
  String? diagramId;
  String? diagram;
  String? diagramRemark;
  String? isReportNo;
  String? reportNo;

  String? receiveSignature;
  String? receiveTitleID;
  String? receiveName;
  String? receivePosition;
  String? sendSignature;
  String? sendPersonID;
  String? sendPosition;

  String? isoDamage;
  String? isoBombLocation;
  List<CaseBomb>? caseBomb;

  String? isoBombSize;

  String? subCaseCategoryOther;

  String? buildingTypeOther;

  FidsCrimeSceneBombAPI(
      {this.fidsNo,
      this.departmentId,
      this.casecategoryId,
      this.isoSubcasecategoryId,
      this.caseIssueDate,
      this.caseIssueTime,
      this.isCaseNotification,
      this.caseVictimDate,
      this.caseVictimTime,
      this.caseOfficerDate,
      this.caseOfficerTime,
      this.deliverBookNo,
      this.deliverBookDate,
      this.issueMedia,
      this.issueMediaDetail,
      this.policeStationId,
      this.isoOtherDepartment,
      this.investigatorTitleId,
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
      this.isSceneProtection,
      this.sceneProtectionDetails,
      this.lightCondition,
      this.lightConditionDetails,
      this.temperatureCondition,
      this.tempetatureConditionDetails,
      this.isSmell,
      this.smellDetails,
      this.isInternalBuilding,
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
      this.caseInternal,
      this.caseRelatedPerson,
      this.caseSceneLocation,
      this.caseBehavior,
      this.caseEntranceDetails,
      this.isFightingClue,
      this.fightingClueDetails,
      this.isRanksackClue,
      this.ranksackClueDetail,
      this.isoIsFinal,
      this.isoComplete,
      this.isoIsDeliver,
      this.closeDate,
      this.closeTime,
      this.caseInspection,
      this.caseInspector,
      this.caseBody,
      this.referencePoint,
      this.caseEvidentFound,
      this.caseEvident,
      this.caseimage,
      this.diagramId,
      this.diagram,
      this.diagramRemark,
      this.isReportNo,
      this.reportNo,
      this.receiveSignature,
      this.receiveTitleID,
      this.receiveName,
      this.receivePosition,
      this.sendSignature,
      this.sendPersonID,
      this.sendPosition,
      this.isoDamage,
      this.isoBombLocation,
      this.caseBomb,
      this.isoBombSize,
      this.buildingTypeOther,
      this.subCaseCategoryOther});

  Map<String, dynamic> toJson() {
    return {
      'fidsno': fidsNo,
      'department_id': departmentId == '-2' ? '' : departmentId,
      'casecategory_id': casecategoryId == '-2' ? '' : casecategoryId,
      'iso_subcasecategory_id':
          isoSubcasecategoryId == '-2' ? '' : isoSubcasecategoryId,
      'subcasecategoryother': subCaseCategoryOther,
      'case_issue_date': caseIssueDate,
      'case_issue_time': caseIssueTime,
      'is_case_notification':
          isCaseNotification == null || isCaseNotification == '-1'
              ? ''
              : '$isCaseNotification',
      'case_victim_date': caseVictimDate,
      'case_victim_time': caseVictimTime,
      'case_officer_date': caseOfficerDate,
      'case_officer_time': caseOfficerTime,
      'delivery_book_date': deliverBookDate,
      'delivery_book_no': deliverBookNo,
      'issue_media': issueMedia,
      'issue_media_detail': issueMediaDetail,
      'police_station_id': policeStationId == '-2' ? '' : policeStationId,
      'iso_other_department': isoOtherDepartment,
      'investigator_title_id':
          investigatorTitleId == '-2' ? '' : investigatorTitleId,
      'investigator_name': investigatorName,
      'iso_case_no': isoCaseNo,
      'iso_investigator_tel': isoInvestigatorTel,
      'scence_description': sceneDescription,
      'scence_province_id': sceneProvinceID == '-2' ? '' : sceneProvinceID,
      'scence_amphur_id': sceneAmphurID == '-2' ? '' : sceneAmphurID,
      'scence_tambol_id': sceneTambolID == '-2' ? '' : sceneTambolID,
      'iso_latitude': isoLatitude,
      'iso_longtitude': isoLongtitude,
      'police_daily': policeDaily,
      'police_daily_date': policeDailyDate,
      'is_scene_protection':
          isSceneProtection == null || isSceneProtection == '-1'
              ? ''
              : '$isSceneProtection',
      'scene_protection_details': sceneProtectionDetails,
      'light_condition': '$lightCondition',
      'light_condition_details': lightConditionDetails,
      'temperature_condition': '$temperatureCondition',
      'temperature_condition_details': tempetatureConditionDetails,
      'is_smell': isSmell == null || isSmell == '-1' ? '' : '$isSmell',
      'smell_details': smellDetails,
      'is_internal_building':
          isInternalBuilding == null || isInternalBuilding == '-1'
              ? ''
              : '$isInternalBuilding',
      'scene_type': sceneType,
      'scene_details': sceneDetails,
      'scene_front': sceneFront,
      'scene_left': sceneLeft,
      'scene_right': sceneRight,
      'scene_back': sceneBack,
      'scene_location': sceneLocation,
      'building_type_id': buildingTypeId == '-2' ? '' : buildingTypeId,
      'iso_building_detail': isoBuildingDetail,
      'floor': floor,
      'is_frence': isFence == null || isFence == '-1' ? '' : '$isFence',
      'case_internal': caseInternal,
      'case_related_person': caseRelatedPerson,
      'case_scene_location': caseSceneLocation,
      'case_behavior': caseBehavior,
      'case_entrance_details': caseEntranceDetails,
      'is_fighting_clue': isFightingClue == null || isFightingClue == '-1'
          ? ''
          : '$isFightingClue',
      'fighting_clue_details': fightingClueDetails,
      'is_ranksack_clue': isRanksackClue == null || isRanksackClue == '-1'
          ? ''
          : '$isRanksackClue',
      'ranksack_clue_details': ranksackClueDetail,
      'iso_is_final':
          isoIsFinal == null || isoIsFinal == '-1' ? '' : '$isoIsFinal',
      'iso_complete': '$isoComplete',
      'iso_is_deliver':
          isoIsDeliver == null || isoIsDeliver == '-1' ? '' : '$isoIsDeliver',
      'close_date': closeDate,
      'close_time': closeTime,
      'case_inspection': caseInspection,
      'case_inspector': caseInspector,
      'reference_point': referencePoint,
      'case_body': caseBody,
      'case_evident_found': caseEvidentFound,
      'case_evident': caseEvident,
      'image': caseimage,
      'diagram_id': diagramId == '-2' || diagramId == 'null' ? '' : diagramId,
      'diagram': diagram,
      'diagram_remark': diagramRemark,
      'IsReportNo': isReportNo ?? '',
      'ReportNo': '$reportNo',
      'receive_signature': receiveSignature,
      'receive_title_id': receiveTitleID,
      'receive_name': receiveName,
      'receive_position': receivePosition,
      'send_signature': sendSignature,
      'send_person_id': sendPersonID,
      'send_position': sendPosition,
      'iso_damage': '$isoDamage',
      'iso_bomb_location': '$isoBombLocation',
      'case_bomb': caseBomb,
      'iso_bombSize': '$isoBombSize',
    };
  }

  Future<List<FidsCrimeSceneBombAPI>> generateModel(FidsCrimeScene data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var uGroup = prefs.getString('uGroup');

    FidsCrimeSceneBombAPI response = FidsCrimeSceneBombAPI();
    response.fidsNo = data.fidsNo == '' ? '' : data.fidsNo;

    response.departmentId = '$uGroup';
    response.casecategoryId = '${data.caseCategoryID}';
    response.isoSubcasecategoryId = '${data.isoSubCaseCategoryID}';
    response.subCaseCategoryOther = data.subCaseCategoryOther;
    response.caseIssueDate = data.caseIssueDate;
    response.caseIssueTime = data.caseIssueTime;

    response.deliverBookDate = data.deliverBookDate;
    response.deliverBookNo = data.deliverBookNo;

    response.isCaseNotification = data.isCaseNotification == 1 ? '1' : '2';
    response.caseVictimDate = data.caseVictimDate;
    response.caseVictimTime = data.caseVictimTime;
    response.caseOfficerDate = data.caseOfficerDate;
    response.caseOfficerTime = data.caseOfficerTime;
    response.issueMedia = data.issueMedia == 1 ? '1' : '2';
    response.issueMediaDetail = data.issueMediaDetail;
    response.policeStationId = '${data.policeStationID}';
    response.isoOtherDepartment = data.isoOtherDepartment;
    response.investigatorTitleId = '${data.investigatorTitleID}';
    response.investigatorName = data.investigatorName;
    response.isoCaseNo = data.isoCaseNo;
    response.isoInvestigatorTel = data.isoInvestigatorTel;
    response.sceneDescription = data.sceneDescription;
    response.sceneProvinceID = '${data.sceneProvinceID}';
    response.sceneAmphurID = '${data.sceneAmphurID}';
    response.sceneTambolID = '${data.sceneTambolID}';
    response.isoLatitude = data.isoLatitude;
    response.isoLongtitude = data.isoLongtitude;
    response.policeDaily = data.policeDaily;
    response.policeDailyDate = data.policeDailyDate;
    response.isSceneProtection = data.isSceneProtection == 1 ? '1' : '2';
    response.sceneProtectionDetails = data.sceneProtectionDetails;
    response.lightCondition = data.lightCondition;
    response.lightConditionDetails = data.lightConditionDetails;
    response.temperatureCondition = data.temperatureCondition;
    response.tempetatureConditionDetails = data.tempetatureConditionDetails;
    response.isSmell = data.isSmell == 1 ? '1' : '2';
    response.smellDetails = data.smellDetails;
    response.isInternalBuilding = '${data.isOutside}';
    response.sceneType = data.sceneType;
    response.sceneDetails = data.sceneDetails;
    response.sceneFront = data.sceneFront;
    response.sceneLeft = data.sceneLeft;
    response.sceneRight = data.sceneRight;
    response.sceneBack = data.sceneBack;
    response.sceneLocation = data.sceneLocation;
    response.buildingTypeId = '${data.buildingTypeId}';
    response.buildingTypeOther = data.buildingTypeOther;
    response.isoBuildingDetail = data.isoBuildingDetail;
    response.floor = data.floor;
    response.isFence = data.isFence == 1 ? '1' : '2';

    var resultCaseInternal =
        await CaseInternalDao().getCaseInternal(data.fidsid ?? -1);
    response.caseInternal = resultCaseInternal;

    var resultCaseRelatedPerson =
        await CaseRelatedPersonDao().getCaseRelatedPerson(data.fidsid ?? -1);
    response.caseRelatedPerson = resultCaseRelatedPerson;

    var resultCaseSceneLocation =
        await CaseSceneLocationDao().getCaseSceneLocation(data.fidsid ?? -1);
    response.caseSceneLocation = resultCaseSceneLocation;

    var resultCaseImage =
        await CaseImagesDao().getCaseImages(data.fidsid ?? -1);
    response.caseimage = resultCaseImage;

    response.caseBehavior = data.caseBehavior;

    response.isoDamage = data.isoDamage;
    response.isoBombLocation = data.isoBombLocation;
    response.isoBombSize = data.isoBombSize;

    response.caseEntranceDetails = data.caseEntranceDetails;
    response.isFightingClue = data.isFightingClue == 1 ? '1' : '2';
    response.fightingClueDetails = data.fightingClueDetails;
    response.isRanksackClue = data.isRansackClue == 1 ? '1' : '2';
    response.ranksackClueDetail = data.ransackClueDetails;
    response.isoIsFinal = data.isoIsFinal == 1 ? '1' : '2';
    response.isoComplete = data.isoIsComplete == 1 ? '1' : '2';
    response.isoIsDeliver = data.isoIsDeliver == 1 ? '1' : '2';
    response.closeDate = data.closeDate;
    response.closeTime = data.closeTime;

    var resultCaseInspection =
        await CaseInspectionDao().getCaseInspection(data.fidsid ?? -1);
    response.caseInspection = resultCaseInspection;

    var resultCaseInspector =
        await CaseInspectorDao().getCaseInspector(data.fidsid ?? -1);
    response.caseInspector = resultCaseInspector;

    var resultReferencePoint =
        await CaseReferencePointDao().getCaseReferencePoint('${data.fidsid}');
    response.referencePoint = resultReferencePoint;

    var resultCaseBody = await CaseBodyDao().getCaseBody(data.fidsid ?? -1);
    response.caseBody = resultCaseBody;

    var resultCaseEvidentFound =
        await CaseEvidentFoundDao().getCaseEvidentFound(data.fidsid ?? -1);
    response.caseEvidentFound = resultCaseEvidentFound;

    var resultCaseEvident =
        await CaseEvidentDao().getCaseEvident(data.fidsid ?? -1);
    response.caseEvident = resultCaseEvident;

    var resultDiagram =
        await DiagramLocationDao().getDiagramLocation('${data.fidsid}');

    response.diagramId = resultDiagram.diagramId;
    response.diagram = resultDiagram.diagram;
    response.diagramRemark = resultDiagram.diagramRemark;

    // response.isReportNo = data.isReportNo == null
    //     ? ''
    //     : data.isReportNo == '1'
    //         ? '1'
    //         : data.isReportNo == '2'
    //             ? '2'
    //             : '';
    response.reportNo = data.reportNo;
    response.receiveSignature = data.receiveSignature;

    response.receiveTitleID = data.receiveTitleID;
    response.receiveName = data.receiveName;
    response.receivePosition = data.receivePosition;
    response.sendSignature = data.sendSignature;
    response.sendPersonID = data.sendPersonID;
    response.sendPosition = data.sendPosition;

    var resultCaseBomb = await CaseBombDao().getCaseBomb(data.fidsid ?? -1);
    response.caseBomb = resultCaseBomb;

    List<FidsCrimeSceneBombAPI> go = [];
    go.add(response);
    return go;
  }
}

class CaseInternalList {
  List<CaseInternal>? listCaseInternal;

  CaseInternalList({
    this.listCaseInternal,
  });

  factory CaseInternalList.fromJson(Map<String, dynamic> json) {
    return CaseInternalList(
      listCaseInternal: json['case_internal'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'case_internal': listCaseInternal,
    };
  }
}

void printWrapped(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  // ignore: avoid_print
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}
