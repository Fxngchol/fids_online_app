// ignore_for_file: file_names

import 'package:shared_preferences/shared_preferences.dart';

import '../../view/life_case/evident/model/CaseEvidentForm.dart';
import '../CaseEvident.dart';
import '../CaseImage.dart';
import '../CaseInspection.dart';
import '../CaseInspector.dart';
import '../CaseRelatedPerson.dart';
import '../FidsCrimeScene.dart';
import 'CaseDamaged.dart';
import 'CaseVehicle.dart';
import 'CaseVehicleCompare.dart';
import 'CaseVehicleCompareDetail.dart';
import 'CaseVehicleDao.dart';
import 'CaseVehicleOpinion.dart';

class TrafficAPI {
  String? fidsNo;
  String? action;
  String? userId;
  List<FidsCrimeSceneTraffic>? fidsCrimeScene;
  TrafficAPI({
    this.fidsNo,
    this.action,
    this.userId,
    this.fidsCrimeScene,
  });

  Map<String, dynamic> toJson() {
    return {
      'fidsno': '$fidsNo',
      'action': action,
      'user_id': userId,
      'fids_crime_scene': fidsCrimeScene,
    };
  }
}

class FidsCrimeSceneTraffic {
  String? fidsNo;
  String? departmentId;
  String? casecategoryId;
  String? subCaseCategoryOther;
  String? isoSubcasecategoryId; //เพิ่ม
  String? caseIssueDate;
  String? caseIssueTime;
  String? isCaseNotification;
  String? caseVictimDate;
  String? caseVictimTime;
  String? caseOfficerDate;
  String? caseOfficerTime;
  String? issueMedia;
  String? deliverBookNo; //เพิ่ม
  String? deliverBookDate; // เพิ่ม
  String? issueMediaDetail;
  String? policeStationId;
  String? isoOtherDepartment;
  String? investigatorTitleId;
  String? investigatorName;
  String? isoCaseNo;
  String? isoInvestigatorTel;
  String? sceneDescription;
  String? sceneProvinceId;
  String? sceneAmphurId;
  String? sceneTambolId;
  String? isoLatitude;
  String? isoLongtitude;
  String? policeDaily;
  String? policeDailyDate;
  String? trafficObjective;
  String? trafficObjectiveOther;
  String? caseBehavior;
  List<CaseInspection>? caseInspection;
  List<CaseInspector>? caseInspector;
  List<CaseRelatedPerson>? caseRelatedPerson;
  List<CaseVehicle>? caseVehicle;
  List<CaseDamaged>? caseVehicleDamaged;
  List<CaseEvidentForm>? caseEvident;
  List<CaseVehicleCompare>? caseVehicleCompare;
  List<CaseVehicleCompareDetail>? caseVehicleCompareDetail;
  List<CaseVehicleOpinion>? caseVehicleOpinion;
  List<CaseImages>? image;

  FidsCrimeSceneTraffic({
    this.fidsNo,
    this.departmentId,
    this.casecategoryId,
    this.subCaseCategoryOther,
    this.isoSubcasecategoryId,
    this.caseIssueDate,
    this.caseIssueTime,
    this.isCaseNotification,
    this.caseVictimDate,
    this.caseVictimTime,
    this.caseOfficerDate,
    this.caseOfficerTime,
    this.issueMedia,
    this.deliverBookNo,
    this.deliverBookDate,
    this.issueMediaDetail,
    this.policeStationId,
    this.isoOtherDepartment,
    this.investigatorTitleId,
    this.investigatorName,
    this.isoCaseNo,
    this.isoInvestigatorTel,
    this.sceneDescription,
    this.sceneProvinceId,
    this.sceneAmphurId,
    this.sceneTambolId,
    this.isoLatitude,
    this.isoLongtitude,
    this.policeDaily,
    this.policeDailyDate,
    this.trafficObjective,
    this.trafficObjectiveOther,
    this.caseBehavior,
    this.caseInspection,
    this.caseInspector,
    this.caseVehicle,
    this.caseRelatedPerson,
    this.caseVehicleDamaged,
    this.caseEvident,
    this.caseVehicleCompare,
    this.caseVehicleCompareDetail,
    this.caseVehicleOpinion,
    this.image,
  });

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
      'scence_province_id': sceneProvinceId == '-2' || sceneProvinceId == 'null'
          ? ''
          : sceneProvinceId,
      'scence_amphur_id':
          sceneAmphurId == '-2' || sceneAmphurId == 'null' ? '' : sceneAmphurId,
      'scence_tambol_id':
          sceneTambolId == '-2' || sceneTambolId == 'null' ? '' : sceneTambolId,
      'iso_latitude': isoLatitude == 'null' ? '' : isoLatitude,
      'iso_longtitude': isoLongtitude == 'null' ? '' : isoLongtitude,
      'police_daily': policeDaily == 'null' ? '' : policeDaily,
      'police_daily_date': policeDailyDate == 'null' ? '' : policeDailyDate,
      'traffic_objective': trafficObjective,
      'traffic_objective_other': trafficObjectiveOther,
      'case_behavior': caseBehavior,
      'case_inspection': caseInspection,
      'case_inspector': caseInspector,
      'case_vehicle': caseVehicle,
      'case_related_person': caseRelatedPerson,
      'case_vehicle_damaged': caseVehicleDamaged,
      'case_evident': caseEvident,
      'case_vehicle_compare': caseVehicleCompare,
      'case_vehicle_compare_detail': caseVehicleCompareDetail,
      'case_vehicle_opinion': caseVehicleOpinion,
      'image': image,
    };
  }

  Future<List<FidsCrimeSceneTraffic>> generateModel(FidsCrimeScene data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var uGroup = prefs.getString('uGroup');

    FidsCrimeSceneTraffic response = FidsCrimeSceneTraffic();
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
    response.sceneProvinceId = '${data.sceneProvinceID}';
    response.sceneAmphurId = '${data.sceneAmphurID}';
    response.sceneTambolId = '${data.sceneTambolID}';
    response.isoLatitude = data.isoLatitude;
    response.isoLongtitude = data.isoLongtitude;
    response.policeDaily = data.policeDaily;
    response.policeDailyDate = data.policeDailyDate;

    response.caseBehavior = data.caseBehavior;

    response.trafficObjective = '${data.trafficObjective}';
    response.trafficObjectiveOther = data.trafficObjectiveOther;

    var resultCaseInspection =
        await CaseInspectionDao().getCaseInspection(data.fidsid!);
    var resultCaseInspector =
        await CaseInspectorDao().getCaseInspector(data.fidsid ?? -1);
    var resultCaseEvident =
        await CaseEvidentDao().getCaseEvident(data.fidsid ?? -1);
    var resultCaseVehicle =
        await CaseVehicleDao().getCaseVehicle(data.fidsid ?? -1);
    var resultCaseVehicleDamaged =
        await CaseDamagedDao().getAllCaseDamages(data.fidsid ?? -1);
    var resultCaseVehicleCompare =
        await CaseVehicleCompareDao().getCaseVehicleCompare(data.fidsid ?? -1);
    var resultCaseVehicleCompareDetail = await CaseVehicleCompareDetailDao()
        .getAllCaseVehicleCompareDetail(data.fidsid ?? -1);
    var resultCaseVehicleOpinion =
        await CaseVehicleOpinionDao().getCaseVehicleOpinions(data.fidsid ?? -1);
    var resultCaseRelatedPerson =
        await CaseRelatedPersonDao().getCaseRelatedPerson(data.fidsid ?? -1);
    var resultCaseImage =
        await CaseImagesDao().getCaseImages(data.fidsid ?? -1);

    response.caseInspection = resultCaseInspection;
    response.caseInspector = resultCaseInspector;
    response.caseRelatedPerson = resultCaseRelatedPerson;
    response.caseVehicleCompare = resultCaseVehicleCompare;
    response.caseVehicleDamaged = resultCaseVehicleDamaged;
    response.caseVehicleCompareDetail = resultCaseVehicleCompareDetail;
    response.caseVehicle = resultCaseVehicle;
    response.caseEvident = resultCaseEvident;
    response.caseVehicleOpinion = resultCaseVehicleOpinion;
    response.image = resultCaseImage;
    List<FidsCrimeSceneTraffic>? go = [];
    go.add(response);
    return go;
  }

  void printWrapped(String? text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    // ignore: avoid_print
    pattern.allMatches(text!).forEach((match) => print(match.group(0)));
  }
}
