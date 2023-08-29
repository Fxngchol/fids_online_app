// ignore_for_file: file_names

import 'CaseBody.dart';
import 'CaseEvident.dart';
import 'CaseEvidentFound.dart';
import 'CaseInspection.dart';
import 'CaseInspector.dart';
import 'CaseInternal.dart';
import 'CaseRelatedPerson.dart';
import 'CaseSceneLocation.dart';
import 'ImageAPI.dart';
import 'case_vehicle/CaseVehicle.dart';

class Download {
  String? fidsNo;
  String? preResultID;
  String? grpWorkNo;
  String? departmentId;
  String? caseCategoryId;
  String? isoSubcaseCategoryId;
  String? caseCategoryName;
  String? caseIssueDate;
  String? caseIssueTime;
  String? isCaseNotification;
  String? caseVictimDate;
  String? caseVictimTime;
  String? caseOfficerDate;
  String? caseOfficerTime;
  String? issueMedia;
  String? issueMediaDetail;
  String? policeStationID;
  String? isoOtherDepartment;
  String? investigatorTitleID;
  String? investigatorTitleLabel;
  String? investigatorName;
  String? isoAllegation;
  String? isoCaseNo;
  String? isoInvestigatorTel;
  String? sceneDescription;
  String? sceneInsideOutsideDescription;
  String? sceneProvinceID;
  String? sceneAmphurID;
  String? sceneTambolID;
  String? isoLatitude;
  String? isoLongtitude;
  String? isSceneProtection;
  String? sceneProtectionDetails;
  String? lightCondition;
  String? lightConditionDetails;
  String? temperatureCondition;
  String? temperatureConditionDetails;
  String? isSmell;
  String? smellDetails;
  String? isOutside;
  String? sceneType;
  String? sceneDetails;
  String? sceneFaceTo;
  String? sceneFront;
  String? sceneBack;
  String? sceneLeft;
  String? sceneRight;
  String? sceneLocation;
  String? buildingTypeID;
  String? floor;
  String? isoBuildingDetail;
  String? isMezzanine;
  String? isFence;
  String? isDeck;
  String? internalDetail;
  String? buildingAmount;
  String? buildingAmountUnit;
  String? buildingWidth;
  String? buildingLength;
  String? buildingStructure;
  String? buildingDecoration;
  String? caseBehavior;
  String? isoDamage;
  String? isoBombLocation;
  String? isoIsNoClue;
  String? isoIsLock;
  String? isoIsClue;
  String? isoClueType1;
  String? isoClueType2;
  String? isoClueType3;
  String? isoClueType4;
  String? isoClueType4Detail;
  String? isoIsDoor;
  String? isoDoorDetail;
  String? isoIsWindows;
  String? isoWindowsDetail;
  String? isoIsCelling;
  String? isoCellingDetail;
  String? isoIsRoof;
  String? isoRoofDetail;
  String? isoIsClueOther;
  String? isoClueOtherDetail;
  String? isoIsTools1;
  String? isoTools1Detail;
  String? isoIsTools2;
  String? isoTools2Detail;
  String? isoIsTools3;
  String? isoTools3Detail;
  String? isoIsTools4;
  String? isoTools4Detail;
  String? isoWidthWound;
  String? isoWidthWoundUnitID;
  String? criminalAmount;
  String? isoIsWeapon;
  String? isoIsWeaponType1;
  String? isoIsWeaponType2;
  String? isoIsWeaponType3;
  String? isoIsWeaponType4;
  String? isoWeaponType4Detail;
  String? isoIsImprisonInRoom;
  String? isoIsImprison;
  String? isoimprison;
  String? isoimprisonDetail;
  String? isoIsCasualty;
  String? isoIsDeceased;
  String? isoCasualtyDetail;
  String? caseEntranceDetails;
  String? isFightingClue;
  String? fightingClueDetails;
  String? isRansackClue;
  String? ransackClueDetails;
  String? isBodyFound;
  String? bobyFoundDetails;
  String? bodyFoundLocation;
  String? foundEvidentDetails;
  String? evidentManagement;
  String? isoIsFinal;
  String? isoIsComplete;
  String? isoIsDeliver;
  String? closeDate;
  String? closeTime;
  String? createBy;
  String? createDate;
  String? updateBy;
  String? updateDate;
  String? remark;
  String? isCaseClose;
  String? caseLadtitude;
  String? caseLongtitude;
  String? fidsStatus;
  String? policeDaily;
  String? policeDailyDate;
  String? buildingWallFront;
  String? buildingWallFrontWindow;
  String? buildingWallFrontDoor;
  String? buildingWallLeft;
  String? buildingWallLeftWindow;
  String? buildingWallLeftDoor;
  String? buildingWallRight;
  String? buildingWallRightWindow;
  String? buildingWallRightDoor;
  String? buildingWallBack;
  String? buildingWallBackWindow;
  String? buildingWallBackDoor;
  String? roomFloor;
  String? roomCeiling;
  String? roof;
  String? arrangeFrontL2R;
  String? arrangeLeftF2B;
  String? arrangeRightF2B;
  String? arrangeBackL2R;
  String? otherLocation;
  String? isoIsBombPackage1;
  String? isoIsBombPackage2;
  String? isoIsBombPackage3;
  String? isoIsBombPackage4;
  String? isoIsBombPackage5;
  String? isoIsBombPackage6;
  String? isoIsBombPackage7;
  String? isoIsBombPackage8;
  String? isoBombPackage8Detail;
  String? isoIsIgnitionType1;
  String? isoIgnitionType1Detail;
  String? isoIsIgnitionType2;
  String? isoIgnitionType1Color;
  String? isoIgnitionType1Length;
  String? isoIsIgnitionType3;
  String? isoIgnitionType3Brand;
  String? isoIgnitionType3Model;
  String? isoIgnitionType3Colour;
  String? isoIgnitionType3SN;
  String? isoIsIgnitionType4;
  String? isoIgnitionType4Brand;
  String? isoIgnitionType4Model;
  String? isoIgnitionType4Colour;
  String? isoIgnitionType4SN;
  String? isoIsIgnitionType5;
  String? isoIgnitionType5Detail;
  String? isoIsIgnitionType6;
  String? isoIgnitionType6Detail;
  String? isoIsIgnitionType7;
  String? isoIgnitionType7Detail;
  String? isoIsFlakType1;
  String? isoFlakType1Size;
  String? isoFlakType1Length;
  String? isoIsFlakType2;
  String? isoFlakType2Size;
  String? isoIsFlakType3;
  String? isoFlakType3Detail;
  String? isoIsMaterial1;
  String? isoMaterial1;
  String? isoIsMaterial2;
  String? isoMaterial2;
  String? isoIsMaterial3;
  String? isoMaterial3;
  String? isoIsMaterial4;
  String? isoMaterial4;
  String? isoIsMaterial5;
  String? isoMaterial5;
  String? isoIsMaterial6;
  String? isoMaterial6;
  String? isoIsMaterial7;
  String? isoMaterial7;
  String? isoIsMaterial8;
  String? isoMaterial8;
  String? isoIsMaterial9;
  String? isoMaterial9;
  String? isoIsMaterial10;
  String? isoMaterial10;
  String? isoIsMaterial11;
  String? isoMaterial11;
  String? isoIsMaterial12;
  String? isoMaterial12;
  String? isoIsMaterial13;
  String? isoMaterial13;
  String? isoIsMaterial14;
  String? isoMaterial14;
  String? isored;
  String? isoyellow;
  String? isogreen;
  String? reportred;
  String? reportyellow;
  String? reportgreen;
  String? flowstatus1;
  String? flowstatus2;
  String? flowstatus3;
  String? flowstatus4;
  String? flowstatus5;
  String? flowstatus6;
  String? deliverBookNo;
  String? deliverBookDate;
  String? diagramId;
  String? diagram;
  String? diagramRemark;
  String? isReportNo;
  String? reportNo;
  String? subCaseCategoryOther;
  String? fireTypeId;

  List<CaseRelatedPerson>? caseRelatedPerson;
  List<CaseInternal>? caseInternal;
  List<CaseInspection>? caseInspection;
  List<CaseInspector>? caseInspector;
  List<CaseEvidentFound>? caseEvidentFound;
  List<CaseEvident>? caseEvident;
  List<CaseBody>? caseBody;
  List<CaseSceneLocation>? caseSceneLocation;
  List<ImageApi>? image;
  List<CaseVehicle>? caseVehicle;

  Download(
      {this.fidsNo,
      this.preResultID,
      this.grpWorkNo,
      this.departmentId,
      this.caseCategoryId,
      this.isoSubcaseCategoryId,
      this.caseCategoryName,
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
      this.isoOtherDepartment,
      this.investigatorTitleID,
      this.investigatorTitleLabel,
      this.investigatorName,
      this.isoAllegation,
      this.isoCaseNo,
      this.isoInvestigatorTel,
      this.sceneDescription,
      this.sceneInsideOutsideDescription,
      this.sceneProvinceID,
      this.sceneAmphurID,
      this.sceneTambolID,
      this.isoLatitude,
      this.isoLongtitude,
      this.isSceneProtection,
      this.sceneProtectionDetails,
      this.lightCondition,
      this.lightConditionDetails,
      this.temperatureCondition,
      this.temperatureConditionDetails,
      this.isSmell,
      this.smellDetails,
      this.isOutside,
      this.sceneType,
      this.sceneDetails,
      this.sceneFaceTo,
      this.sceneFront,
      this.sceneBack,
      this.sceneLeft,
      this.sceneRight,
      this.sceneLocation,
      this.buildingTypeID,
      this.floor,
      this.isoBuildingDetail,
      this.isMezzanine,
      this.isFence,
      this.isDeck,
      this.internalDetail,
      this.buildingAmount,
      this.buildingAmountUnit,
      this.buildingWidth,
      this.buildingLength,
      this.buildingStructure,
      this.buildingDecoration,
      this.caseBehavior,
      this.isoDamage,
      this.isoBombLocation,
      this.isoIsNoClue,
      this.isoIsLock,
      this.isoIsClue,
      this.isoClueType1,
      this.isoClueType2,
      this.isoClueType3,
      this.isoClueType4,
      this.isoClueType4Detail,
      this.isoIsDoor,
      this.isoDoorDetail,
      this.isoIsWindows,
      this.isoWindowsDetail,
      this.isoIsCelling,
      this.isoCellingDetail,
      this.isoIsRoof,
      this.isoRoofDetail,
      this.isoIsClueOther,
      this.isoClueOtherDetail,
      this.isoIsTools1,
      this.isoTools1Detail,
      this.isoIsTools2,
      this.isoTools2Detail,
      this.isoIsTools3,
      this.isoTools3Detail,
      this.isoIsTools4,
      this.isoTools4Detail,
      this.isoWidthWound,
      this.isoWidthWoundUnitID,
      this.criminalAmount,
      this.isoIsWeapon,
      this.isoIsWeaponType1,
      this.isoIsWeaponType2,
      this.isoIsWeaponType3,
      this.isoIsWeaponType4,
      this.isoWeaponType4Detail,
      this.isoIsImprisonInRoom,
      this.isoIsImprison,
      this.isoimprison,
      this.isoimprisonDetail,
      this.isoIsCasualty,
      this.isoIsDeceased,
      this.isoCasualtyDetail,
      this.caseEntranceDetails,
      this.isFightingClue,
      this.fightingClueDetails,
      this.isRansackClue,
      this.ransackClueDetails,
      this.isBodyFound,
      this.bobyFoundDetails,
      this.bodyFoundLocation,
      this.foundEvidentDetails,
      this.evidentManagement,
      this.isoIsFinal,
      this.isoIsComplete,
      this.isoIsDeliver,
      this.closeDate,
      this.closeTime,
      this.createBy,
      this.createDate,
      this.updateBy,
      this.updateDate,
      this.remark,
      this.isCaseClose,
      this.caseLadtitude,
      this.caseLongtitude,
      this.fidsStatus,
      this.policeDaily,
      this.policeDailyDate,
      this.buildingWallFront,
      this.buildingWallFrontWindow,
      this.buildingWallFrontDoor,
      this.buildingWallLeft,
      this.buildingWallLeftWindow,
      this.buildingWallLeftDoor,
      this.buildingWallRight,
      this.buildingWallRightWindow,
      this.buildingWallRightDoor,
      this.buildingWallBack,
      this.buildingWallBackWindow,
      this.buildingWallBackDoor,
      this.roomFloor,
      this.roomCeiling,
      this.roof,
      this.arrangeFrontL2R,
      this.arrangeLeftF2B,
      this.arrangeRightF2B,
      this.arrangeBackL2R,
      this.otherLocation,
      this.isoIsBombPackage1,
      this.isoIsBombPackage2,
      this.isoIsBombPackage3,
      this.isoIsBombPackage4,
      this.isoIsBombPackage5,
      this.isoIsBombPackage6,
      this.isoIsBombPackage7,
      this.isoIsBombPackage8,
      this.isoBombPackage8Detail,
      this.isoIsIgnitionType1,
      this.isoIgnitionType1Detail,
      this.isoIsIgnitionType2,
      this.isoIgnitionType1Color,
      this.isoIgnitionType1Length,
      this.isoIsIgnitionType3,
      this.isoIgnitionType3Brand,
      this.isoIgnitionType3Model,
      this.isoIgnitionType3Colour,
      this.isoIgnitionType3SN,
      this.isoIsIgnitionType4,
      this.isoIgnitionType4Brand,
      this.isoIgnitionType4Model,
      this.isoIgnitionType4Colour,
      this.isoIgnitionType4SN,
      this.isoIsIgnitionType5,
      this.isoIgnitionType5Detail,
      this.isoIsIgnitionType6,
      this.isoIgnitionType6Detail,
      this.isoIsIgnitionType7,
      this.isoIgnitionType7Detail,
      this.isoIsFlakType1,
      this.isoFlakType1Size,
      this.isoFlakType1Length,
      this.isoIsFlakType2,
      this.isoFlakType2Size,
      this.isoIsFlakType3,
      this.isoFlakType3Detail,
      this.isoIsMaterial1,
      this.isoMaterial1,
      this.isoIsMaterial2,
      this.isoMaterial2,
      this.isoIsMaterial3,
      this.isoMaterial3,
      this.isoIsMaterial4,
      this.isoMaterial4,
      this.isoIsMaterial5,
      this.isoMaterial5,
      this.isoIsMaterial6,
      this.isoMaterial6,
      this.isoIsMaterial7,
      this.isoMaterial7,
      this.isoIsMaterial8,
      this.isoMaterial8,
      this.isoIsMaterial9,
      this.isoMaterial9,
      this.isoIsMaterial10,
      this.isoMaterial10,
      this.isoIsMaterial11,
      this.isoMaterial11,
      this.isoIsMaterial12,
      this.isoMaterial12,
      this.isoIsMaterial13,
      this.isoMaterial13,
      this.isoIsMaterial14,
      this.isoMaterial14,
      this.isored,
      this.isoyellow,
      this.isogreen,
      this.reportred,
      this.reportyellow,
      this.reportgreen,
      this.flowstatus1,
      this.flowstatus2,
      this.flowstatus3,
      this.flowstatus4,
      this.flowstatus5,
      this.flowstatus6,
      this.deliverBookNo,
      this.deliverBookDate,
      this.caseRelatedPerson,
      this.caseInspection,
      this.caseInspector,
      this.caseInternal,
      this.caseEvidentFound,
      this.caseEvident,
      this.diagramId,
      this.diagram,
      this.diagramRemark,
      this.image,
      this.caseBody,
      this.caseSceneLocation,
      this.subCaseCategoryOther,
      this.reportNo,
      this.caseVehicle,
      this.fireTypeId});

  factory Download.fromJson(Map<String?, dynamic> json) {
    return Download(
      fidsNo: json['fidsno'] ?? '',
      preResultID: json['preResultID'] ?? '',
      grpWorkNo: json['grpWorkNo'] ?? '',
      departmentId: json['departmentid'] ?? '',
      caseCategoryId: json['casecategoryid'] ?? '',
      isoSubcaseCategoryId: json['isosubcasecategoryid'] ?? '',
      caseCategoryName: json['caseCategoryName'] ?? '',
      caseIssueDate: json['caseIssueDate'] ?? '',
      caseIssueTime: json['caseIssueTime'] ?? '',
      isCaseNotification: json['isCaseNotification'] ?? '',
      caseVictimDate: json['caseVictimDate'] ?? '',
      caseVictimTime: json['caseVictimTime'] ?? '',
      caseOfficerDate: json['caseOfficerDate'] ?? '',
      caseOfficerTime: json['caseOfficerTime'] ?? '',
      issueMedia: json['issueMedia'] ?? '',
      issueMediaDetail: json['issueMediaDetail'] ?? '',
      policeStationID: json['policeStationID'] ?? '',
      isoOtherDepartment: json['isoOtherDepartment'] ?? '',
      investigatorTitleID: json['investigatorTitleID'] ?? '',
      investigatorTitleLabel: json['investigatorTitleLabel'] ?? '',
      investigatorName: json['investigatorName'] ?? '',
      isoAllegation: json['isoAllegation'] ?? '',
      isoCaseNo: json['isoCaseNo'] ?? '',
      isoInvestigatorTel: json['isoInvestigatorTel'] ?? '',
      sceneDescription: json['sceneDescription'] ?? '',
      sceneInsideOutsideDescription:
          json['sceneInsideOutsideDescription'] ?? '',
      sceneProvinceID: json['sceneProvinceID'] ?? '',
      sceneAmphurID: json['sceneAmphurID'] ?? '',
      sceneTambolID: json['sceneTambolID'] ?? '',
      isoLatitude: json['isoLatitude'] ?? '',
      isoLongtitude: json['isoLongtitude'] ?? '',
      isSceneProtection: json['isSceneProtection'] ?? '',
      sceneProtectionDetails: json['sceneProtectionDetails'] ?? '',
      lightCondition: json['lightCondition'] ?? '',
      lightConditionDetails: json['lightConditionDetails'] ?? '',
      temperatureCondition: json['temperatureCondition'] ?? '',
      temperatureConditionDetails: json['temperatureConditionDetails'] ?? '',
      isSmell: json['isSmell'] ?? '',
      smellDetails: json['smellDetails'] ?? '',
      isOutside: json['isOutside'] ?? '',
      sceneType: json['sceneType'] ?? '',
      sceneDetails: json['sceneDetails'] ?? '',
      sceneFaceTo: json['sceneFaceTo'] ?? '',
      sceneFront: json['sceneFront'] ?? '',
      sceneBack: json['sceneBack'] ?? '',
      sceneLeft: json['sceneLeft'] ?? '',
      sceneRight: json['sceneRight'] ?? '',
      sceneLocation: json['sceneLocation'] ?? '',
      buildingTypeID: json['buildingTypeID'] ?? '',
      floor: json['floor'] ?? '',
      isoBuildingDetail: json['isoBuildingDetail'] ?? '',
      isMezzanine: json['isMezzanine'] ?? '',
      isFence: json['isFence'] ?? '',
      isDeck: json['isDeck'] ?? '',
      internalDetail: json['internalDetail'] ?? '',
      buildingAmount: json['buildingAmount'] ?? '',
      buildingAmountUnit: json['buildingAmountUnit'] ?? '',
      buildingWidth: json['buildingWidth'] ?? '',
      buildingLength: json['buildingLength'] ?? '',
      buildingStructure: json['buildingStructure'] ?? '',
      buildingDecoration: json['buildingDecoration'] ?? '',
      caseBehavior: json['caseBehavior'] ?? '',
      isoDamage: json['isoDamage'] ?? '',
      isoBombLocation: json['isoBombLocation'] ?? '',
      isoIsNoClue: json['isoIsNoClue'] ?? '',
      isoIsLock: json['isoIsLock'] ?? '',
      isoIsClue: json['isoIsClue'] ?? '',
      isoClueType1: json['isoClueType1'] ?? '',
      isoClueType2: json['isoClueType2'] ?? '',
      isoClueType3: json['isoClueType3'] ?? '',
      isoClueType4: json['isoClueType4'] ?? '',
      isoClueType4Detail: json['isoClueType4Detail'] ?? '',
      isoIsDoor: json['isoIsDoor'] ?? '',
      isoDoorDetail: json['isoDoorDetail'] ?? '',
      isoIsWindows: json['isoIsWindows'] ?? '',
      isoWindowsDetail: json['isoWindowsDetail'] ?? '',
      isoIsCelling: json['isoIsCelling'] ?? '',
      isoCellingDetail: json['isoCellingDetail'] ?? '',
      isoIsRoof: json['isoIsRoof'] ?? '',
      isoRoofDetail: json['isoRoofDetail'] ?? '',
      isoIsClueOther: json['isoIsClueOther'] ?? '',
      isoClueOtherDetail: json['isoClueOtherDetail'] ?? '',
      isoIsTools1: json['isoIsTools1'] ?? '',
      isoTools1Detail: json['isoTools1Detail'] ?? '',
      isoIsTools2: json['isoIsTools2'] ?? '',
      isoTools2Detail: json['isoTools2Detail'] ?? '',
      isoIsTools3: json['isoIsTools3'] ?? '',
      isoTools3Detail: json['isoTools3Detail'] ?? '',
      isoIsTools4: json['isoIsTools4'] ?? '',
      isoTools4Detail: json['isoTools4Detail'] ?? '',
      isoWidthWound: json['isoWidthWound'] ?? '',
      isoWidthWoundUnitID: json['isoWidthWoundUnitID'] ?? '',
      criminalAmount: json['criminalAmount'] ?? '',
      isoIsWeapon: json['isoIsWeapon'] ?? '',
      isoIsWeaponType1: json['isoIsWeaponType1'] ?? '',
      isoIsWeaponType2: json['isoIsWeaponType2'] ?? '',
      isoIsWeaponType3: json['isoIsWeaponType3'] ?? '',
      isoIsWeaponType4: json['isoIsWeaponType4'] ?? '',
      isoWeaponType4Detail: json['isoWeaponType4Detail'] ?? '',
      isoIsImprisonInRoom: json['isoIsImprisonInRoom'] ?? '',
      isoIsImprison: json['isoIsImprison'] ?? '',
      isoimprison: json['isoimprison'] ?? '',
      isoimprisonDetail: json['isoimprisonDetail'] ?? '',
      isoIsCasualty: json['isoIsCasualty'] ?? '',
      isoIsDeceased: json['isoIsDeceased'] ?? '',
      isoCasualtyDetail: json['isoCasualtyDetail'] ?? '',
      caseEntranceDetails: json['caseEntranceDetails'] ?? '',
      isFightingClue: json['isFightingClue'] ?? '',
      fightingClueDetails: json['fightingClueDetails'] ?? '',
      isRansackClue: json['isRansackClue'] ?? '',
      ransackClueDetails: json['ransackClueDetails'] ?? '',
      isBodyFound: json['isBodyFound'] ?? '',
      bobyFoundDetails: json['bobyFoundDetails'] ?? '',
      bodyFoundLocation: json['bodyFoundLocation'] ?? '',
      foundEvidentDetails: json['foundEvidentDetails'] ?? '',
      evidentManagement: json['evidentManagement'] ?? '',
      isoIsFinal: json['isoIsFinal'] ?? '',
      isoIsComplete: json['isoIsComplete'] ?? '',
      isoIsDeliver: json['isoIsDeliver'] ?? '',
      closeDate: json['closeDate'] ?? '',
      closeTime: json['closeTime'] ?? '',
      createBy: json['createBy'] ?? '',
      createDate: json['createDate'] ?? '',
      updateBy: json['updateBy'] ?? '',
      updateDate: json['updateDate'] ?? '',
      remark: json['remark'] ?? '',
      isCaseClose: json['isCaseClose'] ?? '',
      caseLadtitude: json['caseLadtitude'] ?? '',
      caseLongtitude: json['caseLongtitude'] ?? '',
      fidsStatus: json['fidsStatus'] ?? '',
      policeDaily: json['policeDaily'] ?? '',
      policeDailyDate: json['policeDailyDate'] ?? '',
      buildingWallFront: json['buildingWallFront'] ?? '',
      buildingWallFrontWindow: json['buildingWallFrontWindow'] ?? '',
      buildingWallFrontDoor: json['buildingWallFrontDoor'] ?? '',
      buildingWallLeft: json['buildingWallLeft'] ?? '',
      buildingWallLeftWindow: json['buildingWallLeftWindow'] ?? '',
      buildingWallLeftDoor: json['buildingWallLeftDoor'] ?? '',
      buildingWallRight: json['buildingWallRight'] ?? '',
      buildingWallRightWindow: json['buildingWallRightWindow'] ?? '',
      buildingWallRightDoor: json['buildingWallRightDoor'] ?? '',
      buildingWallBack: json['buildingWallBack'] ?? '',
      buildingWallBackWindow: json['buildingWallBackWindow'] ?? '',
      buildingWallBackDoor: json['buildingWallBackDoor'] ?? '',
      roomFloor: json['roomFloor'] ?? '',
      roomCeiling: json['roomCeiling'] ?? '',
      roof: json['roof'] ?? '',
      arrangeFrontL2R: json['arrangeFrontL2R'] ?? '',
      arrangeLeftF2B: json['arrangeLeftF2B'] ?? '',
      arrangeRightF2B: json['arrangeRightF2B'] ?? '',
      arrangeBackL2R: json['arrangeBackL2R'] ?? '',
      otherLocation: json['otherLocation'] ?? '',
      isoIsBombPackage1: json['isoIsBombPackage1'] ?? '',
      isoIsBombPackage2: json['isoIsBombPackage2'] ?? '',
      isoIsBombPackage3: json['isoIsBombPackage3'] ?? '',
      isoIsBombPackage4: json['isoIsBombPackage4'] ?? '',
      isoIsBombPackage5: json['isoIsBombPackage5'] ?? '',
      isoIsBombPackage6: json['isoIsBombPackage6'] ?? '',
      isoIsBombPackage7: json['isoIsBombPackage7'] ?? '',
      isoIsBombPackage8: json['isoIsBombPackage8'] ?? '',
      isoBombPackage8Detail: json['isoBombPackage8Detail'] ?? '',
      isoIsIgnitionType1: json['isoIsIgnitionType1'] ?? '',
      isoIgnitionType1Detail: json['isoIgnitionType1Detail'] ?? '',
      isoIsIgnitionType2: json['isoIsIgnitionType2'] ?? '',
      isoIgnitionType1Color: json['isoIgnitionType1Color'] ?? '',
      isoIgnitionType1Length: json['isoIgnitionType1Length'] ?? '',
      isoIsIgnitionType3: json['isoIsIgnitionType3'] ?? '',
      isoIgnitionType3Brand: json['isoIgnitionType3Brand'] ?? '',
      isoIgnitionType3Model: json['isoIgnitionType3Model'] ?? '',
      isoIgnitionType3Colour: json['isoIgnitionType3Colour'] ?? '',
      isoIgnitionType3SN: json['isoIgnitionType3SN'] ?? '',
      isoIsIgnitionType4: json['isoIsIgnitionType4'] ?? '',
      isoIgnitionType4Brand: json['isoIgnitionType4Brand'] ?? '',
      isoIgnitionType4Model: json['isoIgnitionType4Model'] ?? '',
      isoIgnitionType4Colour: json['isoIgnitionType4Colour'] ?? '',
      isoIgnitionType4SN: json['isoIgnitionType4SN'] ?? '',
      isoIsIgnitionType5: json['isoIsIgnitionType5'] ?? '',
      isoIgnitionType5Detail: json['isoIgnitionType5Detail'] ?? '',
      isoIsIgnitionType6: json['isoIsIgnitionType6'] ?? '',
      isoIgnitionType6Detail: json['isoIgnitionType6Detail'] ?? '',
      isoIsIgnitionType7: json['isoIsIgnitionType7'] ?? '',
      isoIgnitionType7Detail: json['isoIgnitionType7Detail'] ?? '',
      isoIsFlakType1: json['isoIsFlakType1'] ?? '',
      isoFlakType1Size: json['isoFlakType1Size'] ?? '',
      isoFlakType1Length: json['isoFlakType1Length'] ?? '',
      isoIsFlakType2: json['isoIsFlakType2'] ?? '',
      isoFlakType2Size: json['isoFlakType2Size'] ?? '',
      isoIsFlakType3: json['isoIsFlakType3'] ?? '',
      isoFlakType3Detail: json['isoFlakType3Detail'] ?? '',
      isoIsMaterial1: json['isoIsMaterial1'] ?? '',
      isoMaterial1: json['isoMaterial1'] ?? '',
      isoIsMaterial2: json['isoIsMaterial2'] ?? '',
      isoMaterial2: json['isoMaterial2'] ?? '',
      isoIsMaterial3: json['isoIsMaterial3'] ?? '',
      isoMaterial3: json['isoMaterial3'] ?? '',
      isoIsMaterial4: json['isoIsMaterial4'] ?? '',
      isoMaterial4: json['isoMaterial4'] ?? '',
      isoIsMaterial5: json['isoIsMaterial5'] ?? '',
      isoMaterial5: json['isoMaterial5'] ?? '',
      isoIsMaterial6: json['isoIsMaterial6'] ?? '',
      isoMaterial6: json['isoMaterial6'] ?? '',
      isoIsMaterial7: json['isoIsMaterial7'] ?? '',
      isoMaterial7: json['isoMaterial7'] ?? '',
      isoIsMaterial8: json['isoIsMaterial8'] ?? '',
      isoMaterial8: json['isoMaterial8'] ?? '',
      isoIsMaterial9: json['isoIsMaterial9'] ?? '',
      isoMaterial9: json['isoMaterial9'] ?? '',
      isoIsMaterial10: json['isoIsMaterial10'] ?? '',
      isoMaterial10: json['isoMaterial10'] ?? '',
      isoIsMaterial11: json['isoIsMaterial11'] ?? '',
      isoMaterial11: json['isoMaterial11'] ?? '',
      isoIsMaterial12: json['isoIsMaterial12'] ?? '',
      isoMaterial12: json['isoMaterial12'] ?? '',
      isoIsMaterial13: json['isoIsMaterial13'] ?? '',
      isoMaterial13: json['isoMaterial13'] ?? '',
      isoIsMaterial14: json['isoIsMaterial14'] ?? '',
      isoMaterial14: json['isoMaterial14'] ?? '',
      isored: json['isored'] ?? '',
      isoyellow: json['isoyellow'] ?? '',
      isogreen: json['isogreen'] ?? '',
      reportred: json['reportred'] ?? '',
      reportyellow: json['reportyellow'] ?? '',
      reportgreen: json['reportgreen'] ?? '',
      flowstatus1: json['flowstatus1'] ?? '',
      flowstatus2: json['flowstatus2'] ?? '',
      flowstatus3: json['flowstatus3'] ?? '',
      flowstatus4: json['flowstatus4'] ?? '',
      flowstatus5: json['flowstatus5'] ?? '',
      flowstatus6: json['flowstatus6'] ?? '',
      deliverBookNo: json['deliverBookNo'] ?? '',
      deliverBookDate: json['deliverBookDate'] ?? '',
      diagramId: json['diagramId'] ?? '',
      diagram: json['diagram'] ?? '',
      diagramRemark: json['diagramRemark'] ?? '',
      subCaseCategoryOther: json['subCaseCategoryOther'] ?? '',
      reportNo: json['reportNo'] ?? '',
      fireTypeId: json['fireTypeId'] ?? '',
      caseVehicle: List<CaseVehicle>.from(
          json['case_vehicle']?.map((x) => CaseRelatedPerson.fromApi(x)) ?? []),
      caseRelatedPerson: List<CaseRelatedPerson>.from(
          json['case_related_person']
                  ?.map((x) => CaseRelatedPerson.fromApi(x)) ??
              []),
      caseInspection: List<CaseInspection>.from(
          json['case_inspection']?.map((x) => CaseInspection.fromApi(x)) ?? []),
      caseInspector: List<CaseInspector>.from(
          json['case_inspector']?.map((x) => CaseInspector.fromApi(x)) ??
              CaseInspector()),
      caseInternal: List<CaseInternal>.from(
          json['case_internal']?.map((x) => CaseInternal.fromApi(x)) ?? []),
      caseEvidentFound: List<CaseEvidentFound>.from(
          json['case_evident_found']?.map((x) => CaseEvidentFound.fromApi(x)) ??
              []),
      caseEvident: List<CaseEvident>.from(
          json['case_evident']?.map((x) => CaseEvident.fromApi(x)) ?? []),
      caseBody: List<CaseBody>.from(
          json['case_body']?.map((x) => CaseBody.fromApi(x)) ?? []),
      caseSceneLocation: List<CaseSceneLocation>.from(
          json['case_scene_location']
                  ?.map((x) => CaseSceneLocation.fromApi(x)) ??
              []),
    );
  }

  // factory Download.fromJson(String? source) =>
  //     Download.fromMap(json.decode(source));
}
