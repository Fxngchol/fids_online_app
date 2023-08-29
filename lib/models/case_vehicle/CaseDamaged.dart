// ignore_for_file: file_names

import 'package:flutter/foundation.dart';

import '../../utils/database/database.dart';

class CaseDamaged {
  String? id;
  String? vehicleSideId;
  String? isDamaged;
  String? damagedDetail;
  String? height;
  String? damagedOther;
  String? caseVehicleId;
  CaseDamaged(
      {this.id,
      this.vehicleSideId,
      this.isDamaged,
      this.damagedDetail,
      this.height,
      this.damagedOther,
      this.caseVehicleId});

  CaseDamaged.fromJson(Map<String, dynamic> json) {
    id = '${json['ID']}';
    vehicleSideId = json['VehicleSideID'];
    isDamaged = json['IsDamaged'];
    damagedDetail = json['DamagedDetail'];
    height = json['Height'];
    damagedOther = json['DamagedOther'];
    damagedOther = json['DamagedOther'];
    caseVehicleId = json['CaseVehicelID'];
  }

  Map toJson() => {
        'id': id == '-2' || id == null ? '' : '$id',
        'vehicle_side_id':
            vehicleSideId == null || vehicleSideId == '-1' ? '' : vehicleSideId,
        'is_damaged': isDamaged ?? 2,
        'damaged_detail': damagedDetail ?? '',
        'height': height ?? '',
        'damaged_other': damagedOther ?? '',
        'case_vehicle_id': caseVehicleId ?? '',
      };

  @override
  String toString() {
    return 'CaseDamaged(id: $id, vehicleSideId: $vehicleSideId, isDamaged: $isDamaged, damagedDetail: $damagedDetail, height: $height, damagedOther: $damagedOther, caseVehicleId: $caseVehicleId)';
  }
}

class CaseDamagedDao {
  Future<dynamic> createCaseVehicleDamaged(
    String? fidsId,
    String? vehicleSideId,
    String? isDamaged,
    String? damagedDetail,
    String? height,
    String? damagedOther,
    String? vehicleId,
  ) async {
    final db = await DBProvider.db.database;
    var res = await db.rawInsert('''
      INSERT INTO CaseVehicleDamaged (
        FidsID,VehicleSideID,IsDamaged,DamagedDetail,Height,DamagedOther,CaseVehicelID
      ) VALUES (?,?,?,?,?,?,?)
    ''', [
      fidsId,
      vehicleSideId,
      isDamaged,
      damagedDetail,
      height,
      damagedOther,
      vehicleId
    ]);

    return res;
  }

  Future<dynamic> updateCaseVehicleDamaged(
    String? vehicleSideId,
    String? isDamaged,
    String? damagedDetail,
    String? height,
    String? damagedOther,
    int id,
  ) async {
    final db = await DBProvider.db.database;
    var res = await db.rawUpdate('''
      UPDATE CaseVehicleDamaged SET 
     VehicleSideID = ?, IsDamaged = ?, DamagedDetail = ?, Height = ?, DamagedOther = ? WHERE ID = ?
    ''', [vehicleSideId, isDamaged, damagedDetail, height, damagedOther, id]);
    return res;
  }

  Future<List<CaseDamaged>> getAllCaseDamages(int fidsID) async {
    final db = await DBProvider.db.database;
    var res = await db.query("CaseVehicleDamaged",
        where: '"FidsID" = ?', whereArgs: ['$fidsID']);
    if (res.isEmpty) {
      return [];
    } else {
      var result = await db.query("CaseVehicleDamaged",
          where: '"FidsID" = ?', whereArgs: ['$fidsID']);
      List<CaseDamaged> listResult = [];

      for (int i = 0; i < result.length; i++) {
        Map<String, dynamic> res = result[i];
        CaseDamaged formResponse = CaseDamaged.fromJson(res);
        listResult.add(formResponse);
      }

      return listResult;
    }
  }

  Future<List<CaseDamaged>> getCaseDamages(
      int fidsID, int caseVehicleId) async {
    final db = await DBProvider.db.database;
    var res = await db.query("CaseVehicleDamaged",
        where: '"FidsID" = ?', whereArgs: ['$fidsID']);
    if (res.isEmpty) {
      return [];
    } else {
      var result = await db.query("CaseVehicleDamaged",
          where: '"FidsID" = ?', whereArgs: ['$fidsID']);
      List<CaseDamaged> listResult = [];

      for (int i = 0; i < result.length; i++) {
        Map<String, dynamic> res = result[i];
        CaseDamaged formResponse = CaseDamaged.fromJson(res);
        if (formResponse.caseVehicleId == caseVehicleId.toString()) {
          listResult.add(formResponse);
        }
      }

      return listResult;
    }
  }

  Future<int> getCountOfCaseDamagesBySide(
      int fidsID, int caseVehicleId, int sideId) async {
    final db = await DBProvider.db.database;
    var res = await db.query("CaseVehicleDamaged",
        where: '"FidsID" = ?', whereArgs: ['$fidsID']);
    if (res.isEmpty) {
      return 0;
    } else {
      var result = await db.query("CaseVehicleDamaged",
          where: '"FidsID" = ?', whereArgs: ['$fidsID']);
      List<CaseDamaged> listResult = [];

      for (int i = 0; i < result.length; i++) {
        Map<String, dynamic> res = result[i];
        CaseDamaged formResponse = CaseDamaged.fromJson(res);
        if (formResponse.vehicleSideId == sideId.toString() &&
            formResponse.caseVehicleId == caseVehicleId.toString()) {
          listResult.add(formResponse);
        }
      }

      return listResult.length;
    }
  }

  Future<List<CaseDamaged>> getCaseDamagesBySide(
      int fidsID, int caseVehicleId, int sideId) async {
    final db = await DBProvider.db.database;
    var res = await db.query("CaseVehicleDamaged",
        where: '"FidsID" = ?', whereArgs: ['$fidsID']);
    if (res.isEmpty) {
      return [];
    } else {
      var result = await db.query("CaseVehicleDamaged",
          where: '"FidsID" = ?', whereArgs: ['$fidsID']);
      List<CaseDamaged> listResult = [];

      for (int i = 0; i < result.length; i++) {
        Map<String, dynamic> res = result[i];
        CaseDamaged formResponse = CaseDamaged.fromJson(res);
        if (formResponse.vehicleSideId == sideId.toString() &&
            formResponse.caseVehicleId == caseVehicleId.toString()) {
          listResult.add(formResponse);
        }
      }

      return listResult;
    }
  }

  Future<List<CaseDamaged>> getCaseDamagesForCompare(
      int fidsID, int caseVehicleId) async {
    final db = await DBProvider.db.database;
    var res = await db.query("CaseVehicleDamaged",
        where: '"FidsID" = ?', whereArgs: ['$fidsID']);
    if (res.isEmpty) {
      return [];
    } else {
      var result = await db.query("CaseVehicleDamaged",
          where: '"FidsID" = ?', whereArgs: ['$fidsID']);
      List<CaseDamaged> listResult = [];

      for (int i = 0; i < result.length; i++) {
        Map<String, dynamic> res = result[i];
        CaseDamaged formResponse = CaseDamaged.fromJson(res);
        if (formResponse.caseVehicleId == caseVehicleId.toString() &&
            formResponse.isDamaged == '1') {
          listResult.add(formResponse);
        }
      }
      listResult.sort((a, b) => a.vehicleSideId!.compareTo(b.vehicleSideId!));
      return listResult;
    }
  }

  Future<List<String>> getCaseDamagesLabel(
      int fidsID, int caseVehicleId) async {
    final db = await DBProvider.db.database;
    var res = await db.query("CaseVehicleDamaged",
        where: '"FidsID" = ?', whereArgs: ['$fidsID']);
    if (res.isEmpty) {
      return [];
    } else {
      var result = await db.query("CaseVehicleDamaged",
          where: '"FidsID" = ?', whereArgs: ['$fidsID']);
      List<String> listResult = [];

      for (int i = 0; i < result.length; i++) {
        Map<String, dynamic> res = result[i];
        CaseDamaged formResponse = CaseDamaged.fromJson(res);
        if (kDebugMode) {
          print(formResponse.toString());
        }
        if (formResponse.caseVehicleId == caseVehicleId.toString() &&
            formResponse.isDamaged == '1') {
          String? string = '${formResponse.damagedDetail}';
          listResult.add(string);
        }
      }

      return listResult;
    }
  }

  Future<CaseDamaged?> getCaseVehicleDamagedById(String? id) async {
    final db = await DBProvider.db.database;
    var res = await db.query("CaseVehicleDamaged");
    if (res.isEmpty) {
      return null;
    } else {
      var result = await db
          .query("CaseVehicleDamaged", where: '"ID" = ?', whereArgs: ['$id']);
      CaseDamaged response = CaseDamaged.fromJson(result[0]);
      return response;
    }
  }

  Future<dynamic> deleteCaseVehicleDamaged(String? id) async {
    final db = await DBProvider.db.database;

    var res = await db.rawDelete('''
      DELETE FROM CaseVehicleDamaged WHERE ID = ?
    ''', [id]);
    if (kDebugMode) {
      print('DELETE Success');
    }
    return res;
  }

  Future<dynamic> delete(int fidsId) async {
    final db = await DBProvider.db.database;

    var res = await db.rawDelete('''
      DELETE FROM CaseVehicleDamaged WHERE FidsID = ?
    ''', [fidsId]);
    if (kDebugMode) {
      print('DELETE Success');
    }
    return res;
  }
}
