// ignore_for_file: file_names
import 'package:flutter/foundation.dart';

import '../../utils/database/database.dart';

import 'RelatedPersonType.dart';

class CaseRelatedPerson {
  String? id;
  String? fidsId;
  String? relatedPersonTypeId;
  String? relatedPersonOther;
  String? isoTitleName;
  String? name;
  String? isoFirstName;
  String? isoLastName;
  String? age;
  String? isoIdCard;
  String? typeCardID;
  String? isoConcernpeoplecareerId;
  String? isoConcernPeopleCareeerOther;
  String? isoConcernPeopleDetails;
  String? relatedPersonImage;

  CaseRelatedPerson(
      {this.id,
      this.fidsId,
      this.relatedPersonTypeId,
      this.relatedPersonOther,
      this.isoTitleName,
      this.name,
      this.isoFirstName,
      this.isoLastName,
      this.age,
      this.isoIdCard,
      this.typeCardID,
      this.isoConcernpeoplecareerId,
      this.isoConcernPeopleCareeerOther,
      this.isoConcernPeopleDetails,
      this.relatedPersonImage});

  factory CaseRelatedPerson.fromJson(Map<String, dynamic> json) {
    return CaseRelatedPerson(
      id: '${json['ID']}',
      fidsId: '${json['FidsID']}',
      relatedPersonTypeId: '${json['RelatedPersonTypeID']}',
      relatedPersonOther: json['RelatedPersonOther'],
      isoTitleName: '${json['Iso_Iso_TitleName']}',
      name: json['Name'],
      isoFirstName: json['Iso_FirstName'],
      isoLastName: json['Iso_lastName'],
      age: json['Age'],
      isoIdCard: json['Iso_Idcard'],
      typeCardID: json['TypeCardID'],
      isoConcernpeoplecareerId: '${json['Iso_ConcernpeoplecareerID']}',
      isoConcernPeopleCareeerOther: json['Iso_ConcernpeoplecareerOther'],
      isoConcernPeopleDetails: json['Iso_Concernpeopledetails'],
      relatedPersonImage: json['RelatedPersonImage'],
    );
  }

  factory CaseRelatedPerson.fromApi(Map<String, dynamic> json) {
    return CaseRelatedPerson(
      id: json['id'],
      fidsId: json['fidsno'],
      relatedPersonTypeId: json['related_person_type_id'],
      relatedPersonOther: json['related_person_other'],
      isoTitleName: json['iso_iso_title_name'],
      name: json['name'],
      isoFirstName: json['iso_firstname'],
      isoLastName: json['iso_lastname'],
      age: json['age'],
      isoIdCard: json['iso_idcard'],
      typeCardID: json['TypeCardID'],
      isoConcernpeoplecareerId: json['iso_concern_people_career_id'],
      isoConcernPeopleCareeerOther: json['iso_concern_people_career_other'],
      isoConcernPeopleDetails: json['iso_concern_people_details'],
      relatedPersonImage: json['related_person_image'],
    );
  }

  Map toJson() => {
        'id': id == '-2' || id == null ? '' : '$id',
        'related_person_type_id':
            relatedPersonTypeId == '-2' || relatedPersonTypeId == null
                ? ''
                : '$relatedPersonTypeId',
        'related_person_other': relatedPersonOther ?? '',
        'iso_iso_title_name': isoTitleName ?? '',
        'name': name ?? '',
        'iso_firstname': isoFirstName ?? '',
        'iso_lastname': isoLastName ?? '',
        'age': age ?? '',
        'iso_idcard': isoIdCard ?? '',
        'type_card_id':
            typeCardID == null || typeCardID == '-1' ? '' : typeCardID,
        'iso_concern_people_career_id': isoConcernpeoplecareerId == '-2' ||
                isoConcernpeoplecareerId == '-1' ||
                isoConcernpeoplecareerId == null
            ? ''
            : '$isoConcernpeoplecareerId',
        'iso_concern_people_career_other': isoConcernPeopleCareeerOther ?? '',
        'iso_concern_people_details': isoConcernPeopleDetails ?? '',
        'related_person_image': relatedPersonImage ?? '',
      };

  @override
  String toString() {
    return 'CaseRelatedPerson(id: $id, fidsId: $fidsId, relatedPersonTypeId: $relatedPersonTypeId, relatedPersonOther: $relatedPersonOther, isoTitleName: $isoTitleName, name: $name, isoFirstName: $isoFirstName, isoLastName: $isoLastName, age: $age, isoIdCard: $isoIdCard, typeCardID: $typeCardID, isoConcernpeoplecareerId: $isoConcernpeoplecareerId, isoConcernPeopleCareeerOther: $isoConcernPeopleCareeerOther, isoConcernPeopleDetails: $isoConcernPeopleDetails, relatedPersonImage: $relatedPersonImage)';
  }
}

class CaseRelatedPersonDao {
  Future<void> createCaseRelatedPerson(
      int fidsId,
      int relatedPersonTypeId,
      String? isoTitleName,
      String? isoRelatedPersonTitleId,
      String? isoFirstname,
      String? isoLastName,
      String? isoIdCard,
      String? typeCardID,
      String? age,
      int? isoConcernpeopleCareerId,
      String? isoConcernPeoplecareerOther,
      String? isoConcernPeopleDetails,
      String? relatedPersonImage,
      String? createDate,
      String? createBy,
      String? updateDate,
      String? updateBy,
      int activeFlag) async {
    final db = await DBProvider.db.database;

    await db.rawInsert('''
      INSERT INTO CaseRelatedPerson (
        FidsID,RelatedPersonTypeID,RelatedPersonOther,Iso_Iso_TitleName,Iso_FirstName,
        Iso_lastName,Age,Iso_Idcard,TypeCardID,Iso_ConcernpeoplecareerID,Iso_ConcernpeoplecareerOther,
        Iso_Concernpeopledetails,RelatedPersonImage,CreateDate,CreateBy,UpdateDate,UpdateBy,ActiveFlag
      ) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)
    ''', [
      fidsId,
      relatedPersonTypeId,
      isoTitleName,
      isoRelatedPersonTitleId,
      isoFirstname,
      isoLastName,
      age,
      isoIdCard,
      typeCardID,
      isoConcernpeopleCareerId,
      isoConcernPeoplecareerOther,
      isoConcernPeopleDetails,
      relatedPersonImage,
      createDate,
      createBy,
      updateDate,
      updateBy,
      activeFlag
    ]);
  }

  Future<void> updateCaseRelatedPerson(
      int relatedPersonTypeId,
      String? isoTitleName,
      String? relatedPersonOther,
      String? isoFirstname,
      String? isoLastName,
      String? isoIdCard,
      String? typeCardID,
      String? age,
      int isoConcernpeopleCareerId,
      String? isoConcernPeoplecareerOther,
      String? isoConcernPeopleDetails,
      String? relatedPersonImage,
      String? createDate,
      String? createBy,
      String? updateDate,
      String? updateBy,
      int activeFlag,
      int id) async {
    final db = await DBProvider.db.database;

    await db.rawUpdate('''
      UPDATE CaseRelatedPerson SET  RelatedPersonImage = ?, RelatedPersonTypeID = ?, RelatedPersonOther = ?,Iso_Iso_TitleName = ?,Iso_FirstName = ?,Iso_lastName = ?,Age = ?,Iso_Idcard = ?,TypeCardID = ?,Iso_ConcernpeoplecareerID = ?,Iso_ConcernpeoplecareerOther = ?,Iso_Concernpeopledetails = ?,CreateDate = ?,CreateBy = ?,UpdateDate = ?,UpdateBy = ? ,ActiveFlag = ? WHERE ID = ?
    ''', [
      relatedPersonImage,
      relatedPersonTypeId,
      relatedPersonOther,
      isoTitleName,
      isoFirstname,
      isoLastName,
      age,
      isoIdCard,
      typeCardID,
      isoConcernpeopleCareerId,
      isoConcernPeoplecareerOther,
      isoConcernPeopleDetails,
      createDate,
      createBy,
      updateDate,
      updateBy,
      activeFlag,
      id
    ]);
  }

  Future<void> deleteCaseRelatedPerson(String id) async {
    final db = await DBProvider.db.database;

    await db.rawDelete('''
      DELETE FROM CaseRelatedPerson WHERE ID = ?
    ''', [id]);
  }

  Future<void> delete(int fidsId) async {
    final db = await DBProvider.db.database;

    await db.rawDelete('''
      DELETE FROM CaseRelatedPerson WHERE FidsID = ?
    ''', [fidsId]);
    if (kDebugMode) {
      print('DELETE Success');
    }
  }

  Future<List<CaseRelatedPerson>> getCaseRelatedPerson(int caseId) async {
    final db = await DBProvider.db.database;
    var res = await db.query("CaseRelatedPerson");
    if (res.isEmpty) {
      return [];
    } else {
      var result = await db.query("CaseRelatedPerson",
          where: '"FidsID" = ?', whereArgs: ['$caseId']);

      List<CaseRelatedPerson> listResult = [];

      for (int i = 0; i < result.length; i++) {
        Map<String, dynamic> res = result[i];
        CaseRelatedPerson formResponse = CaseRelatedPerson.fromJson(res);
        listResult.add(formResponse);
      }
      return listResult;
    }
  }

  Future<List<String>> getCaseRelatedPersonLabel(int caseId) async {
    final db = await DBProvider.db.database;
    var res = await db.query("CaseRelatedPerson");
    if (res.isEmpty) {
      return [];
    } else {
      var result = await db.query("CaseRelatedPerson",
          where: '"FidsID" = ?', whereArgs: ['$caseId']);

      List<String> listResult = [];

      for (int i = 0; i < result.length; i++) {
        Map<String, dynamic> res = result[i];
        CaseRelatedPerson formResponse = CaseRelatedPerson.fromJson(res);
        List<RelatedPersonType> relatedPersonTypes = [];
        var result3 = await RelatedPersonTypeDao().getRelatedPersonType();
        var type = '';
        relatedPersonTypes = result3;
        for (int i = 0; i < relatedPersonTypes.length; i++) {
          if (kDebugMode) {
            print('${relatedPersonTypes[i].id}');
          }

          if ('${formResponse.relatedPersonTypeId}' ==
              '${relatedPersonTypes[i].id}') {
            if (formResponse.relatedPersonTypeId == '0') {
              type = formResponse.relatedPersonOther ?? '';
            } else {
              type = relatedPersonTypes[i].name ?? '';
            }
          }
        }
        listResult.add(
            '${formResponse.isoTitleName} ${formResponse.isoFirstName} ${formResponse.isoLastName} ( $type )');
      }
      return listResult;
    }
  }

  Future<CaseRelatedPerson> getCaseRelatedPersonById(
      int caseId, int relatepersonId) async {
    final db = await DBProvider.db.database;
    var res = await db.query("CaseRelatedPerson");
    if (res.isEmpty) {
      return CaseRelatedPerson();
    } else {
      var result = await db.query("CaseRelatedPerson",
          where: '"FidsID" = ?', whereArgs: ['$caseId']);

      CaseRelatedPerson caseRelatedPerson = CaseRelatedPerson();

      for (int i = 0; i < result.length; i++) {
        Map<String, dynamic> res = result[i];
        CaseRelatedPerson formResponse = CaseRelatedPerson.fromJson(res);
        if ('${formResponse.id}' == '$relatepersonId') {
          caseRelatedPerson = formResponse;
          if (kDebugMode) {
            print('formResponseformResponse: $formResponse');
          }
          return caseRelatedPerson;
        }
      }
      return caseRelatedPerson;
    }
  }
}
