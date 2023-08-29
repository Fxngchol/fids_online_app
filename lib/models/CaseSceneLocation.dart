// ignore_for_file: file_names

import 'package:flutter/foundation.dart';

import '../../utils/database/database.dart';

class CaseSceneLocation {
  String? id;
  String? sceneLocation;
  String? sceneLocationSize;

  String? unitId;
  String? buildingStructure;
  String? buildingWallFront;
  String? buildingWallLeft;
  String? buildingWallRight;
  String? buildingWallBack;
  String? roomFloor;
  String? roof;
  String? placement;
  String? ceiling;
  String? areaOther;
  String? frontLeftToRight;
  String? leftFrontToBack;
  String? rightFrontToBack;
  String? backLeftToRight;
  String? fidsID;
  String? createDate;
  String? createBy;
  String? updateDate;
  String? updateBy;
  String? activeFlag;

  CaseSceneLocation({
    this.id,
    this.sceneLocation,
    this.sceneLocationSize,
    this.unitId,
    this.buildingStructure,
    this.buildingWallFront,
    this.buildingWallLeft,
    this.buildingWallRight,
    this.buildingWallBack,
    this.roomFloor,
    this.roof,
    this.placement,
    this.ceiling,
    this.areaOther,
    this.frontLeftToRight,
    this.leftFrontToBack,
    this.rightFrontToBack,
    this.backLeftToRight,
    this.fidsID,
    this.createDate,
    this.createBy,
    this.updateDate,
    this.updateBy,
    this.activeFlag,
  });

  factory CaseSceneLocation.fromJson(Map<String, dynamic> json) {
    return CaseSceneLocation(
      id: '${json['ID']}',
      sceneLocation: json['SceneLocation'],
      sceneLocationSize: json['SceneLocationSize'],
      unitId: '${json['UnitId']}',
      buildingStructure: json['BuildingStructure'],
      buildingWallFront: json['BuildingWallFront'],
      buildingWallLeft: json['BuildingWallLeft'],
      buildingWallRight: json['BuildingWallRight'],
      buildingWallBack: json['BuildingWallBack'],
      roomFloor: json['RoomFloor'],
      roof: json['Roof'],
      placement: json['Placement'],
      frontLeftToRight: json['FrontLeftToRight'],
      leftFrontToBack: json['LeftFrontToBack'],
      rightFrontToBack: json['RightFrontToBack'],
      backLeftToRight: json['BackLeftToRight'],
      fidsID: '${json['FidsID']}',
      createDate: json['CreateDate'],
      createBy: json['CreateBy'],
      updateDate: json['UpdateDate'],
      updateBy: json['UpdateBy'],
      activeFlag: '${json['ActiveFlag']}',
      ceiling: json['Ceiling'],
      areaOther: json['AreaOther'],
    );
  }

  factory CaseSceneLocation.fromApi(Map<String, dynamic> json) {
    return CaseSceneLocation(
      id: json['id'],
      sceneLocation: json['scene_location'],
      sceneLocationSize: json['scene_location_size'],
      unitId: json['unit_id'],
      buildingStructure: json['building_structure'],
      buildingWallFront: json['building_wall_front'],
      buildingWallLeft: json['building_wall_left'],
      buildingWallRight: json['building_wall_right'],
      buildingWallBack: json['building_wall_back'],
      frontLeftToRight: json['frontLeftToRight'],
      leftFrontToBack: json['leftFrontToBack'],
      rightFrontToBack: json['rightFrontToBack'],
      backLeftToRight: json['backLeftToRight'],
      roomFloor: json['room_floor'],
      roof: json['roof'],
      placement: json['placement'],
      fidsID: json['fidsno'],
      ceiling: json['Ceiling'],
      areaOther: json['AreaOther'],
    );
  }

  Map toJson() => {
        'id': id == '-2' || id == null ? '' : '$id',
        'scene_location': sceneLocation ?? '',
        'scene_location_size': sceneLocationSize ?? '',
        'unit_id': unitId == '-2' || unitId == null || unitId == 'null'
            ? ''
            : '$unitId',
        'building_structure': buildingStructure ?? '',
        'building_wall_front': buildingWallFront ?? '',
        'building_wall_left': buildingWallLeft ?? '',
        'building_wall_right': buildingWallRight ?? '',
        'building_wall_back': buildingWallBack ?? '',
        'frontLeftToRight': frontLeftToRight ?? '',
        'leftFrontToBack': leftFrontToBack ?? '',
        'rightFrontToBack': rightFrontToBack ?? '',
        'backLeftToRight': backLeftToRight ?? '',
        'room_floor': roomFloor ?? '',
        'roof': roof ?? '',
        'placement': placement ?? '',
        'ceiling': ceiling ?? '',
        'areaOther': areaOther ?? '',
      };

  @override
  String toString() {
    return 'CaseSceneLocation{id: $id, sceneLocation: $sceneLocation, sceneLocationSize: $sceneLocationSize, unitId: $unitId, buildingStructure: $buildingStructure, buildingWallFront: $buildingWallFront, buildingWallLeft: $buildingWallLeft, buildingWallRight: $buildingWallRight, buildingWallBack: $buildingWallBack, roomFloor: $roomFloor, roof: $roof, placement: $placement, frontLeftToRight: $frontLeftToRight, leftFrontToBack: $leftFrontToBack, rightFrontToBack: $rightFrontToBack, backLeftToRight: $backLeftToRight, fidsID: $fidsID, createDate: $createDate, createBy: $createBy, updateDate: $updateDate, updateBy: $updateBy, activeFlag: $activeFlag}';
  }
}

class CaseSceneLocationDao {
  createCaseSceneLocation(
      String? sceneLocation,
      String? sceneLocationSize,
      int? unitId,
      String? buildingStructure,
      String? buildingWallFront,
      String? buildingWallLeft,
      String? buildingWallRight,
      String? buildingWallBack,
      String? roomFloor,
      String? roof,
      String? placement,
      String? ceiling,
      String? areaOther,
      String? frontLeftToRight,
      String? leftFrontToBack,
      String? rightFrontToBack,
      String? backLeftToRight,
      int fidsID,
      String? createDate,
      String? createBy,
      String? updateDate,
      String? updateBy,
      int activeFlag) async {
    final db = await DBProvider.db.database;

    var res = await db.rawInsert('''
      INSERT INTO CaseSceneLocation (
        SceneLocation,SceneLocationSize,UnitId,BuildingStructure,BuildingWallFront,BuildingWallLeft,BuildingWallRight,BuildingWallBack,RoomFloor,Roof,Placement,Ceiling,AreaOther,FrontLeftToRight,LeftFrontToBack,RightFrontToBack,BackLeftToRight,FidsID,CreateDate,CreateBy,UpdateDate,UpdateBy,ActiveFlag
      ) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)
    ''', [
      sceneLocation,
      sceneLocationSize,
      unitId,
      buildingStructure,
      buildingWallFront,
      buildingWallLeft,
      buildingWallRight,
      buildingWallBack,
      roomFloor,
      roof,
      placement,
      ceiling,
      areaOther,
      frontLeftToRight,
      leftFrontToBack,
      rightFrontToBack,
      backLeftToRight,
      fidsID,
      createDate,
      createBy,
      updateDate,
      updateBy,
      activeFlag
    ]);
    return res;
  }

  updateCaseSceneLocation(
      String? sceneLocation,
      String? sceneLocationSize,
      int unitId,
      String? buildingStructure,
      String? buildingWallFront,
      String? buildingWallLeft,
      String? buildingWallRight,
      String? buildingWallBack,
      String? roomFloor,
      String? roof,
      String? placement,
      String? ceiling,
      String? areaOther,
      String? frontLeftToRight,
      String? leftFrontToBack,
      String? rightFrontToBack,
      String? backLeftToRight,
      String? createDate,
      String? createBy,
      String? updateDate,
      String? updateBy,
      int activeFlag,
      int id) async {
    final db = await DBProvider.db.database;

    var res = await db.rawUpdate('''
      UPDATE CaseSceneLocation SET
        SceneLocation = ?,SceneLocationSize = ?,UnitId = ?,BuildingStructure = ?, BuildingWallFront = ?,BuildingWallLeft = ?,BuildingWallRight = ?,
        BuildingWallBack = ?,RoomFloor = ?,Roof = ?,Placement = ?,Ceiling= ?,AreaOther= ?,FrontLeftToRight = ?,LeftFrontToBack = ?,RightFrontToBack = ?,BackLeftToRight = ?,
        CreateDate = ?,CreateBy = ?,UpdateDate = ?,UpdateBy = ?,
        ActiveFlag = ? WHERE ID = ?
    ''', [
      sceneLocation,
      sceneLocationSize,
      unitId,
      buildingStructure,
      buildingWallFront,
      buildingWallLeft,
      buildingWallRight,
      buildingWallBack,
      roomFloor,
      roof,
      placement,
      ceiling,
      areaOther,
      frontLeftToRight,
      leftFrontToBack,
      rightFrontToBack,
      backLeftToRight,
      createDate,
      createBy,
      updateDate,
      updateBy,
      activeFlag,
      id
    ]);
    return res;
  }

  Future<List<CaseSceneLocation>> getCaseSceneLocation(int fidsID) async {
    final db = await DBProvider.db.database;
    var res = await db.query("CaseSceneLocation");
    if (res.isEmpty) {
      return [];
    } else {
      // var result = await db.query("CaseInspector",
      //     where: '"FidsID" = ?', whereArgs: ['$fidsID']);

      var result = await db.query("CaseSceneLocation",
          where: '"FidsID" = ?', whereArgs: ['$fidsID']);

      List<CaseSceneLocation> listResult = [];
      // print('result : ${result.toString()}');
      // CaseInspector response = CaseInspector.fromJson(result[0]);

      for (int i = 0; i < result.length; i++) {
        Map<String, dynamic> res = result[i];
        CaseSceneLocation formResponse = CaseSceneLocation.fromJson(res);
        listResult.add(formResponse);
      }
      return listResult;
    }
  }

  Future<CaseSceneLocation> getCaseSceneLocationById(
      int caseSceneLocationId, int fidsId) async {
    final db = await DBProvider.db.database;
    var res = await db.query("CaseSceneLocation");
    if (res.isEmpty) {
      return CaseSceneLocation();
    } else {
      // var result = await db.query("CaseInspector",
      //     where: '"FidsID" = ?', whereArgs: ['$fidsID']);

      var result = await db.query("CaseSceneLocation",
          where: '"FidsID" = ?', whereArgs: ['$fidsId']);

      for (int i = 0; i < result.length; i++) {
        Map<String, dynamic> res = result[i];
        CaseSceneLocation formResponse = CaseSceneLocation.fromJson(res);
        // listResult.add(formResponse);
        if (formResponse.id == caseSceneLocationId.toString()) {
          return formResponse;
        }
      }
      return CaseSceneLocation();
    }
  }

  Future<dynamic> delete(int fidsId) async {
    final db = await DBProvider.db.database;

    var res = await db.rawDelete('''
      DELETE FROM CaseSceneLocation WHERE FidsID = ?
    ''', [fidsId]);
    if (kDebugMode) {
      print('DELETE Success');
    }
    return res;
  }

  Future<dynamic> deleteById(String id) async {
    final db = await DBProvider.db.database;

    var res = await db.rawDelete('''
      DELETE FROM CaseSceneLocation WHERE ID = ?
    ''', [id]);
    if (kDebugMode) {
      print('DELETE Success');
    }
    return res;
  }

  ////// BOMB /////

  Future<dynamic> createCaseSceneLocationBomb(
      String sceneLocation, int fidsID) async {
    final db = await DBProvider.db.database;

    var res = await db.rawInsert('''
      INSERT INTO CaseSceneLocation (
        SceneLocation,FidsID
      ) VALUES (?,?)
    ''', [
      sceneLocation,
      fidsID,
    ]);
    return res;
  }

  Future<dynamic> updateMyCaseSceneLocation(
      String sceneLocation, String id) async {
    final db = await DBProvider.db.database;
    var res = await db.rawUpdate('''
      UPDATE CaseSceneLocation SET
        SceneLocation = ? WHERE ID = ?
    ''', [sceneLocation, id]);

    return res;
  }
}
