// ignore_for_file: file_names

import 'package:shared_preferences/shared_preferences.dart';
import '../view/life_case/evident/model/CaseEvidentForm.dart';
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

class FidsCrimeSceneWitnessCaseCrimeSceneAPI {
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

  String? buildingTypeOther;

  String? subCaseCategoryOther;

  FidsCrimeSceneWitnessCaseCrimeSceneAPI(
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
      //this.caseBody,
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
      this.buildingTypeOther,
      this.subCaseCategoryOther});

  // factory FidsCrimeSceneAPI.fromJson(Map<String, dynamic> json) {
  //   return FidsCrimeSceneAPI(
  //     fidsNo: json['fidsno'],
  //     departmentId: json['department_id'],
  //     casecategoryId: json['casecategory_id'],
  //     isoSubcasecategoryId: json['iso_subcasecategory_id'],
  //     caseIssueDate: json['case_issue_date'],
  //     caseIssueTime: json['case_issue_time'],
  //     isCaseNotification: json['is_case_notification'],
  //     caseVictimDate: json['case_victim_date'],
  //     caseVictimTime: json['case_victim_time'],
  //     caseOfficerDate: json['case_officer_date'],
  //     caseOfficerTime: json['case_officer_time'],
  //     issueMedia: json['issue_media'],
  //     issueMediaDetail: json['issue_media_detail'],
  //     policeStationId: json['police_station_id'],
  //     isoOtherDepartment: json['iso_other_department'],
  //     investigatorTitleId: json['investigator_title_id'],
  //     investigatorName: json['investigator_name'],
  //     isoCaseNo: json['iso_case_no'],
  //     isoInvestigatorTel: json['iso_investigator_tel'],
  //     sceneDescription: json['scence_description'],
  //     sceneProvinceID: json['scence_province_id'],
  //     sceneAmphurID: json['scence_amphur_id'],
  //     sceneTambolID: json['scence_tambol_id'],
  //     isoLatitude: json['iso_latitude'],
  //     isoLongtitude: json['iso_longtitude'],
  //     policeDaily: json['police_daily'],
  //     policeDailyDate: json['police_daily_date'],
  //     isSceneProtection: json['is_scene_protection'],
  //     sceneProtectionDetails: json['scene_protection_details'],
  //     lightCondition: json['light_condition'],
  //     lightConditionDetails: json['light_condition_details'],
  //     temperatureCondition: json['temperature_condition'],
  //     tempetatureConditionDetails: json['temperature_condition_details'],
  //     isSmell: json['is_smell'],
  //     smellDetails: json['smell_details'],
  //     isInternalBuilding: json['is_internal_building'],
  //     sceneType: json['scene_type'],
  //     sceneDetails: json['scene_details'],
  //     sceneFront: json['scene_front'],
  //     sceneLeft: json['scene_left'],
  //     sceneRight: json['scene_right'],
  //     sceneBack: json['scene_back'],
  //     sceneLocation: json['scene_location'],
  //     buildingTypeId: json['building_type_id'],
  //     isoBuildingDetail: json['iso_building_detail'],
  //     floor: json['floor'],
  //     isFence: json['is_frence'],
  //     caseInternal: (json['case_internal'] as List)
  //         .map((data) => CaseInternal.fromJson(data))
  //         .toList(),
  //     caseRelatedPerson: (json['case_related_person'] as List)
  //         .map((data) => CaseRelatedPerson.fromJson(data))
  //         .toList(),
  //     caseSceneLocation: (json['case_scene_location'] as List)
  //         .map((data) => CaseSceneLocation.fromJson(data))
  //         .toList(),
  //     caseBehavior: json['case_behavior'],
  //     caseEntranceDetails: json['case_entrance_details'],
  //     isFightingClue: json['is_fighting_clue'],
  //     fightingClueDetails: json['fighting_clue_details'],
  //     isRanksackClue: json['is_ranksack_clue'],
  //     ranksackClueDetail: json['ranksack_clue_details'],
  //     isoIsFinal: json['iso_is_final'],
  //     isoComplete: json['iso_complete'],
  //     isoIsDeliver: json['iso_is_deliver'],
  //     closeDate: json['close_date'],
  //     closeTime: json['close_time'],
  //     caseInspection: (json['case_inspection'] as List)
  //         .map((data) => CaseInspection.fromJson(data))
  //         .toList(),
  //     caseInspector: (json['case_inspector'] as List)
  //         .map((data) => CaseInspector.fromJson(data))
  //         .toList(),
  //     caseBody: (json['case_body'] as List)
  //         .map((data) => CaseBody.fromJson(data))
  //         .toList(),
  //     caseEvidentFound: (json['case_evident_found'] as List)
  //         .map((data) => CaseEvidentFound.fromMap(data))
  //         .toList(),
  //     caseEvident: (json['case_evident'] as List)
  //         .map((data) => CaseEvident.fromJson(data))
  //         .toList(),
  //     image: (json['image'] as List)
  //         .map((data) => ImageApi.fromJson(data))
  //         .toList(),
  //       diagramId: json['diagram_id'],
  //     diagram: json['diagram'],
  //     diagramRemark: json['diagram_remark'],
  //   );
  // }

  Map<String, dynamic> toJson() {
    return {
      'fidsno': fidsNo == 'null' ? '' : fidsNo,
      'department_id':
          departmentId == '-2' || departmentId == 'null' ? '' : departmentId,
      'casecategory_id': casecategoryId == '-2' || casecategoryId == 'null'
          ? ''
          : casecategoryId,
      'iso_subcasecategory_id':
          isoSubcasecategoryId == '-2' || isoSubcasecategoryId == 'null'
              ? ''
              : isoSubcasecategoryId,
      'subcasecategoryother':
          subCaseCategoryOther == null || subCaseCategoryOther == 'null'
              ? ''
              : subCaseCategoryOther,
      'case_issue_date': caseIssueDate == 'null' ? '' : caseIssueDate,
      'case_issue_time': caseIssueTime == 'null' ? '' : caseIssueTime,
      'is_case_notification': isCaseNotification == null ||
              isCaseNotification == '-1' ||
              isCaseNotification == 'null'
          ? ''
          : '$isCaseNotification',
      'case_victim_date': caseVictimDate == 'null' ? '' : caseVictimDate,
      'case_victim_time': caseVictimTime == 'null' ? '' : caseVictimTime,
      'case_officer_date': caseOfficerDate == 'null' ? '' : caseOfficerDate,
      'case_officer_time': caseOfficerTime == 'null' ? '' : caseOfficerTime,
      'delivery_book_date': deliverBookDate == 'null' ? '' : deliverBookDate,
      'delivery_book_no': deliverBookNo == 'null' ? '' : deliverBookNo,
      'issue_media': issueMedia == 'null' ? '' : issueMedia,
      'issue_media_detail': issueMediaDetail == 'null' ? '' : issueMediaDetail,
      'police_station_id': policeStationId == '-2' || policeStationId == 'null'
          ? ''
          : policeStationId,
      'iso_other_department':
          isoOtherDepartment == 'null' ? '' : isoOtherDepartment,
      'investigator_title_id':
          investigatorTitleId == '-2' || investigatorTitleId == 'null'
              ? ''
              : investigatorTitleId,
      'investigator_name': investigatorName == 'null' ? '' : investigatorName,
      'iso_case_no': isoCaseNo == 'null' ? '' : isoCaseNo,
      'iso_investigator_tel':
          isoInvestigatorTel == 'null' ? '' : isoInvestigatorTel,
      'scence_description': sceneDescription == 'null' ? '' : sceneDescription,
      'scence_province_id': sceneProvinceID == '-2' || sceneProvinceID == 'null'
          ? ''
          : sceneProvinceID,
      'scence_amphur_id':
          sceneAmphurID == '-2' || sceneAmphurID == 'null' ? '' : sceneAmphurID,
      'scence_tambol_id':
          sceneTambolID == '-2' || sceneTambolID == 'null' ? '' : sceneTambolID,
      'iso_latitude': isoLatitude == 'null' ? '' : isoLatitude,
      'iso_longtitude': isoLongtitude == 'null' ? '' : isoLongtitude,
      'police_daily': policeDaily == 'null' ? '' : policeDaily,
      'police_daily_date': policeDailyDate == 'null' ? '' : policeDailyDate,
      'is_scene_protection': isSceneProtection == null ||
              isSceneProtection == '-1' ||
              isSceneProtection == 'null'
          ? ''
          : '$isSceneProtection',
      'scene_protection_details':
          sceneProtectionDetails == 'null' ? '' : sceneProtectionDetails,
      'light_condition': lightCondition == null || lightCondition == 'null'
          ? ''
          : '$lightCondition',
      'light_condition_details':
          lightConditionDetails == 'null' ? '' : lightConditionDetails,
      'temperature_condition':
          temperatureCondition == null || temperatureCondition == 'null'
              ? ''
              : '$temperatureCondition',
      'temperature_condition_details': tempetatureConditionDetails == 'null'
          ? ''
          : tempetatureConditionDetails,
      'is_smell': isSmell == null || isSmell == '-1' || isSmell == 'null'
          ? ''
          : '$isSmell',
      'smell_details': smellDetails == 'null' ? '' : smellDetails,
      'is_internal_building': isInternalBuilding == null ||
              isInternalBuilding == '-1' ||
              isInternalBuilding == 'null'
          ? ''
          : '$isInternalBuilding',
      'scene_type': sceneType == 'null' ? '' : sceneType,
      'scene_details': sceneDetails == 'null' ? '' : sceneDetails,
      'scene_front': sceneFront == 'null' ? '' : sceneFront,
      'scene_left': sceneLeft == 'null' ? '' : sceneLeft,
      'scene_right': sceneRight == 'null' ? '' : sceneRight,
      'scene_back': sceneBack == 'null' ? '' : sceneBack,
      'scene_location': sceneLocation == 'null' ? '' : sceneLocation,
      'building_type_id': buildingTypeId == '-2' || buildingTypeId == 'null'
          ? ''
          : buildingTypeId,
      'building_type_other':
          buildingTypeOther == null || buildingTypeOther == 'null'
              ? ''
              : '$buildingTypeOther',
      'iso_building_detail':
          isoBuildingDetail == 'null' ? '' : isoBuildingDetail,
      'floor': floor == 'null' ? '' : floor,
      'is_frence': isFence == null || isFence == '-1' || isFence == 'null'
          ? ''
          : '$isFence',
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
      'case_evident_found': caseEvidentFound,
      'case_evident': caseEvident,
      'image': caseimage,
      'diagram_id': diagramId == '-2' || diagramId == 'null' ? '' : diagramId,
      'diagram': diagram,
      'diagram_remark': diagramRemark,
      'IsReportNo': isReportNo,
      'ReportNo': '$reportNo',
      'receive_signature': receiveSignature,
      'receive_title_id': receiveTitleID,
      'receive_name': receiveName,
      'receive_position': receivePosition,
      'send_signature': sendSignature,
      'send_person_id': sendPersonID,
      'send_position': sendPosition
    };
  }

  Future<List<FidsCrimeSceneWitnessCaseCrimeSceneAPI>> generateModel(
      FidsCrimeScene data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var uGroup = prefs.getString('uGroup');

    FidsCrimeSceneWitnessCaseCrimeSceneAPI response =
        FidsCrimeSceneWitnessCaseCrimeSceneAPI();
    response.fidsNo = data.fidsNo == null
        ? ''
        : data.fidsNo == ''
            ? ''
            : data.fidsNo;

    response.departmentId = '$uGroup';
    response.casecategoryId = '${data.caseCategoryID}';
    response.isoSubcasecategoryId =
        data.isoSubCaseCategoryID == null ? '' : '${data.isoSubCaseCategoryID}';

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

    response.reportNo = data.reportNo;
    response.receiveSignature = data.receiveSignature;

    response.receiveTitleID = data.receiveTitleID;
    response.receiveName = data.receiveName;
    response.receivePosition = data.receivePosition;
    response.sendSignature = data.sendSignature;
    response.sendPersonID = data.sendPersonID;
    response.sendPosition = data.sendPosition;
    List<FidsCrimeSceneWitnessCaseCrimeSceneAPI> go = [];
    go.add(response);
    return go;
  }
}

class CaseInternalList {
  List<CaseInternal> listCaseInternal;

  CaseInternalList({
    required this.listCaseInternal,
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

// class CaseInternalItem {
//   int? id;
//   String? floorNo;
//   String? floorDetail;
//   bool activeFlag;

//   CaseInternalItem({
//     this.id,
//     this.floorNo,
//     this.floorDetail,
//     this.activeFlag,
//   });

//   factory CaseInternalItem.fromJson(Map<String, dynamic> json) {
//     return CaseInternalItem(
//       id: json['id'],
//       floorNo: json['floor_no'],
//       floorDetail: json['floor_detail'],
//       activeFlag: json['active_flag'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'floor_no': floorNo,
//       'floor_detail': floorDetail,
//       'active_flag': activeFlag,
//     };
//   }
// }
