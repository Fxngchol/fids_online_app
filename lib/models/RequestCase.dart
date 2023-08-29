// ignore_for_file: file_names

import 'dart:convert';

class RequestCase {
  String? uID;
  String? action;
  String? fidsNo;
  String? year;
  String? uGroup;
  String? caseCategoryID;
  String? iSOSubCaseCategoryID;
  String? isoCaseNo;
  String? caseIssueDate;
  String? caseIssueTime;
  String? issueMedia;
  String? issueMediaDetail;
  String? isCaseNotification;
  String? caseVictimDate;
  String? caseVictimTime;
  String? caseOfficerDate;
  String? caseOfficerTime;
  String? deliverBookNo;
  String? deliverBookDate;
  String? policeStationID;
  String? isoOtherDepartment;
  String? policeDaily;
  String? policeDailyDate;
  String? investigatorTitleID;
  String? investigatorName;
  String? isoInvestigatorTel;
  String? sceneProvinceID;

  String? isReportNo;
  String? reportNo;

  RequestCase(
      {this.action,
      this.fidsNo,
      this.uID,
      this.year,
      this.uGroup,
      this.caseCategoryID,
      this.iSOSubCaseCategoryID,
      this.isoCaseNo,
      this.caseIssueDate,
      this.caseIssueTime,
      this.issueMedia,
      this.issueMediaDetail,
      this.isCaseNotification,
      this.caseVictimDate,
      this.caseVictimTime,
      this.caseOfficerDate,
      this.caseOfficerTime,
      this.deliverBookNo,
      this.deliverBookDate,
      this.policeStationID,
      this.isoOtherDepartment,
      this.policeDaily,
      this.policeDailyDate,
      this.investigatorTitleID,
      this.investigatorName,
      this.isoInvestigatorTel,
      this.sceneProvinceID,
      this.reportNo,
      this.isReportNo});

  Map<String, dynamic> toMap() {
    return {
      'fidsno': fidsNo ?? '',
      'action': action ?? '',
      'uID': uID ?? '',
      'Year': year ?? '',
      'uGroup': uGroup ?? '',
      'CaseCategoryID': caseCategoryID ?? '',
      'ISO_SubCaseCategoryID': iSOSubCaseCategoryID ?? '',
      'Iso_CaseNo': isoCaseNo ?? '',
      'caseIssueDate': caseIssueDate ?? '',
      'caseIssueTime': caseIssueTime ?? '',
      'issueMedia': issueMedia ?? '',
      'issueMediaDetail': issueMediaDetail ?? '',
      'isCaseNotification': isCaseNotification ?? '',
      'caseVictimDate': caseVictimDate ?? '',
      'caseVictimTime': caseVictimTime ?? '',
      'caseOfficerDate': caseOfficerDate ?? '',
      'caseOfficerTime': caseOfficerTime ?? '',
      'deliverBookNo': deliverBookNo ?? '',
      'deliverBookDate': deliverBookDate ?? '',
      'policeStationID': policeStationID ?? '',
      'iso_OtherDepartment': isoOtherDepartment ?? '',
      'PoliceDaily': policeDaily ?? '',
      'PoliceDailyDate': policeDailyDate ?? '',
      'investigatorTitleID': investigatorTitleID ?? '',
      'investigatorName': investigatorName ?? '',
      'Iso_InvestigatorTel': isoInvestigatorTel ?? '',
      'SceneProvinceID': sceneProvinceID ?? '',
      'IsReportNo': isReportNo ?? '',
      'ReportNo': reportNo ?? '',
    };
  }

  factory RequestCase.fromMap(Map<String, dynamic> map) {
    return RequestCase(
        fidsNo: map['fidsNo'] == null ? '' : '${map['fidsNo']}',
        uID: map['uID'] == null ? '' : '${map['uID']}',
        year: map['Year'] == null ? '' : '${map['Year']}',
        action: map['action'] == null ? '' : '${map['action']}',
        uGroup: map['uGroup'] == null ? '' : '${map['uGroup']}',
        caseCategoryID:
            map['CaseCategoryID'] == null ? '' : '${map['CaseCategoryID']}',
        iSOSubCaseCategoryID: map['ISO_SubCaseCategoryID'] == null
            ? ''
            : '${map['ISO_SubCaseCategoryID']}',
        isoCaseNo: map['Iso_CaseNo'] == null ? '' : '${map['Iso_CaseNo']}',
        caseIssueDate:
            map['caseIssueDate'] == null ? '' : '${map['caseIssueDate']}',
        caseIssueTime:
            map['caseIssueTime'] == null ? '' : '${map['caseIssueTime']}',
        issueMedia: map['issueMedia'] == null ? '' : '${map['issueMedia']}',
        issueMediaDetail:
            map['issueMediaDetail'] == null ? '' : '${map['issueMediaDetail']}',
        isCaseNotification: map['isCaseNotification'] == null
            ? ''
            : '${map['isCaseNotification']}',
        caseVictimDate:
            map['caseVictimDate'] == null ? '' : '${map['caseVictimDate']}',
        caseVictimTime:
            map['caseVictimTime'] == null ? '' : '${map['caseVictimTime']}',
        caseOfficerDate:
            map['caseOfficerDate'] == null ? '' : '${map['caseOfficerDate']}',
        caseOfficerTime:
            map['caseOfficerTime'] == null ? '' : '${map['caseOfficerTime']}',
        deliverBookNo:
            map['deliverBookNo'] == null ? '' : '${map['deliverBookNo']}',
        deliverBookDate:
            map['deliverBookDate'] == null ? '' : '${map['deliverBookDate']}',
        policeStationID:
            map['policeStationID'] == null ? '' : '${map['policeStationID']}',
        isoOtherDepartment: map['iso_OtherDepartment'] == null
            ? ''
            : '${map['iso_OtherDepartment']}',
        policeDaily: map['PoliceDaily'] == null ? '' : '${map['PoliceDaily']}',
        policeDailyDate:
            map['PoliceDailyDate'] == null ? '' : '${map['PoliceDailyDate']}',
        investigatorTitleID: map['investigatorTitleID'] == null
            ? ''
            : '${map['investigatorTitleID']}',
        investigatorName:
            map['investigatorName'] == null ? '' : '${map['investigatorName']}',
        isoInvestigatorTel: map['Iso_InvestigatorTel'] == null
            ? ''
            : '${map['Iso_InvestigatorTel']}',
        isReportNo: map['IsReportNo'] == null ? '' : '${map['IsReportNo']}',
        reportNo: map['ReportNo'] == null ? '' : '${map['ReportNo']}');
  }

  String? toJson() => json.encode(toMap());

  factory RequestCase.fromJson(String source) =>
      RequestCase.fromMap(json.decode(source));

  @override
  String toString() {
    return 'RequestCase(fidsNo: $fidsNo,action: $action,uID: $uID, year: $year, uGroup: $uGroup, caseCategoryID: $caseCategoryID, iSOSubCaseCategoryID: $iSOSubCaseCategoryID, isoCaseNo: $isoCaseNo, caseIssueDate: $caseIssueDate, caseIssueTime: $caseIssueTime, issueMedia: $issueMedia, issueMediaDetail: $issueMediaDetail, isCaseNotification: $isCaseNotification, caseVictimDate: $caseVictimDate, caseVictimTime: $caseVictimTime, caseOfficerDate: $caseOfficerDate, caseOfficerTime: $caseOfficerTime, deliverBookNo: $deliverBookNo, deliverBookDate: $deliverBookDate, policeStationID: $policeStationID, isoOtherDepartment: $isoOtherDepartment, policeDaily: $policeDaily, policeDailyDate: $policeDailyDate, investigatorTitleID: $investigatorTitleID, investigatorName: $investigatorName, isoInvestigatorTel: $isoInvestigatorTel)';
  }
}
