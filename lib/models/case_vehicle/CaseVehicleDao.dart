// ignore_for_file: file_names

import 'package:flutter/foundation.dart';

import '../../utils/database/database.dart';

import 'CaseVehicle.dart';

class CaseVehicleDao {
  Future<dynamic> createCaseVehicle(
      String? fidsId,
      String? vehicleTypeId,
      String? vehicleTypeOther,
      String? vehicleBrandId,
      String? vehicleBrandOther,
      String? vehicleModel,
      String? colorId1,
      String? colorId2,
      String? colorOther,
      String? detail,
      String? isVehicleRegistrationPlate,
      String? isVehicleRegistrationPlateNo1,
      String? provinceId,
      String? isVehicleRegistrationPlateNo2,
      String? vehicleOther,
      String? chassisNumber,
      String? engineNumber,
      String? provinceOtherId) async {
    final db = await DBProvider.db.database;
    var res = await db.rawInsert('''
      INSERT INTO CaseVehicle (
        FidsID,VehicleTypeID,VehicleTypeOther, VehicleBrandID,VehicleBrandOther,
          VehicleModel, ColorID1, ColorID2,
          ColorOther, Detail, IsVehicleRegistrationPlate,
          VehicleRegistrationPlateNo1, ProvinceID, VehicleRegistrationPlateNo2,
          VehicleOther,ChassisNumber,EngineNumber,ProvinceOtherID
      ) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)
    ''', [
      fidsId,
      vehicleTypeId,
      vehicleTypeOther,
      vehicleBrandId,
      vehicleBrandOther,
      vehicleModel,
      colorId1,
      colorId2,
      colorOther,
      detail,
      isVehicleRegistrationPlate,
      isVehicleRegistrationPlateNo1,
      provinceId,
      isVehicleRegistrationPlateNo2,
      vehicleOther,
      chassisNumber,
      engineNumber,
      provinceOtherId
    ]);

    return res;
  }

  Future<dynamic> updateCaseVehicle(
      int id,
      String? vehicleTypeId,
      String? vehicleTypeOther,
      String? vehicleBrandId,
      String? vehicleBrandOther,
      String? vehicleModel,
      String? colorId1,
      String? colorId2,
      String? colorOther,
      String? detail,
      String? isVehicleRegistrationPlate,
      String? vehicleRegistrationPlateNo1,
      String? provinceId,
      String? vehicleRegistrationPlateNo2,
      String? vehicleOther,
      String? chassisNumber,
      String? engineNumber,
      String? provinceOtherId) async {
    final db = await DBProvider.db.database;
    var res = await db.rawUpdate('''
      UPDATE CaseVehicle SET 
      VehicleTypeID = ?,VehicleTypeOther = ?, VehicleBrandID = ?,VehicleBrandOther = ?,
          VehicleModel = ?, ColorID1 = ?, ColorID2= ?,
          ColorOther= ?, Detail= ?, IsVehicleRegistrationPlate= ?,
          VehicleRegistrationPlateNo1 = ?, ProvinceID = ?, VehicleRegistrationPlateNo2 = ?,
          VehicleOther= ?,ChassisNumber = ?,EngineNumber = ?,ProvinceOtherID = ? WHERE ID = ?
    ''', [
      vehicleTypeId,
      vehicleTypeOther,
      vehicleBrandId,
      vehicleBrandOther,
      vehicleModel,
      colorId1,
      colorId2,
      colorOther,
      detail,
      isVehicleRegistrationPlate,
      vehicleRegistrationPlateNo1,
      provinceId,
      vehicleRegistrationPlateNo2,
      vehicleOther,
      chassisNumber,
      engineNumber,
      provinceOtherId,
      id
    ]);

    return res;
  }

  Future<dynamic> updateCaseVehicleMap(
    int id,
    String? vehicleMap,
  ) async {
    final db = await DBProvider.db.database;
    var res = await db.rawUpdate('''
      UPDATE CaseVehicle SET 
    VehicleMap = ? WHERE ID = ?
    ''', [vehicleMap, id]);

    return res;
  }

  Future<List<CaseVehicle>> getCaseVehicle(int fidsID) async {
    final db = await DBProvider.db.database;
    var res = await db
        .query("CaseVehicle", where: '"FidsID" = ?', whereArgs: ['$fidsID']);
    if (res.isEmpty) {
      return [];
    } else {
      var result = await db
          .query("CaseVehicle", where: '"FidsID" = ?', whereArgs: ['$fidsID']);
      List<CaseVehicle> listResult = [];
      for (int i = 0; i < result.length; i++) {
        Map<String, dynamic> res = result[i];
        CaseVehicle formResponse = CaseVehicle.fromJson(res);
        listResult.add(formResponse);
      }

      listResult.sort((a, b) => a.id!.compareTo(b.id!));
      return listResult;
    }
  }

  Future<CaseVehicle?> getCaseVehicleById(String? id) async {
    final db = await DBProvider.db.database;
    var res = await db.query("CaseVehicle");
    if (res.isEmpty) {
      return null;
    } else {
      var result =
          await db.query("CaseVehicle", where: '"ID" = ?', whereArgs: ['$id']);
      CaseVehicle response = CaseVehicle.fromJson(result[0]);
      return response;
    }
  }

  Future<dynamic> deleteCaseVehicle(String? id) async {
    final db = await DBProvider.db.database;

    var res = await db.rawDelete('''
      DELETE FROM CaseVehicle WHERE ID = ?
    ''', [id]);
    if (kDebugMode) {
      print('DELETE Success');
    }
    return res;
  }

  Future<dynamic> delete(int fidsId) async {
    final db = await DBProvider.db.database;

    var res = await db.rawDelete('''
      DELETE FROM CaseVehicle WHERE FidsID = ?
    ''', [fidsId]);
    if (kDebugMode) {
      print('DELETE Success');
    }
    return res;
  }
}
