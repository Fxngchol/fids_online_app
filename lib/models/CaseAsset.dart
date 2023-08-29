// ignore_for_file: file_names

import 'package:flutter/foundation.dart';

import '../../utils/database/database.dart';

class CaseAsset {
  String? id;
  String? fidsId;
  String? asset;
  String? assetAmount;
  String? assetUnit;
  String? areaDetail;
  String? ransackedDetail;

  CaseAsset(
      {this.id,
      this.fidsId,
      this.asset,
      this.assetAmount,
      this.assetUnit,
      this.areaDetail,
      this.ransackedDetail});

  factory CaseAsset.fromJson(Map<String, dynamic> json) {
    return CaseAsset(
      id: '${json['ID']}',
      fidsId: '${json['FidsID']}',
      asset: json['Asset'],
      assetAmount: '${json['AssetAmount']}',
      assetUnit: json['AssetUnit'],
      areaDetail: json['AreaDetail'],
      ransackedDetail: '${json['RansackedDeatil']}',
    );
  }

  Map toJson() => {
        'id': '$id',
        'asset': asset,
        'asset_amount': assetAmount,
        'asset_unit': assetUnit,
        'area_detail': areaDetail,
        'ransacked_detail': ransackedDetail,
      };

  @override
  String toString() {
    return 'CaseAsset{id: $id, fidsId: $fidsId, asset: $asset, assetAmount: $assetAmount, assetUnit: $assetUnit, areaDetail: $areaDetail, ransackedDeatil: $ransackedDetail}';
  }
}

class CaseAssetDao {
  Future<dynamic> createCaseAsset(
      String? asset,
      String? assetAmount,
      String? assetUnit,
      String? areaId,
      String? caseRansacked,
      int fidsId) async {
    final db = await DBProvider.db.database;
    var res = await db.rawInsert('''
      INSERT INTO CaseAsset (
        Asset,AssetAmount,AssetUnit,AreaDetail,RansackedDeatil,FidsID
      ) VALUES (?,?,?,?,?,?)
    ''', [asset, assetAmount, assetUnit, areaId, caseRansacked, fidsId]);

    return res;
  }

  Future<dynamic> updateCaseAsset(
      String? fidsId,
      String? asset,
      String? assetAmount,
      String? assetUnit,
      String? areaId,
      String? caseRansacked,
      int id) async {
    final db = await DBProvider.db.database;
    var res = await db.rawInsert('''
      UPDATE CaseAsset SET FidsID = ?,Asset = ?, AssetAmount = ?, AssetUnit = ?, AreaDetail = ?, RansackedDeatil = ? WHERE ID = ?
      ''', [fidsId, asset, assetAmount, assetUnit, areaId, caseRansacked, id]);
    return res;
  }

  Future<dynamic> deleteCaseAssetById(String? id) async {
    final db = await DBProvider.db.database;

    var res = await db.rawDelete('''
      DELETE FROM CaseAsset WHERE ID = ?
    ''', [id]);
    return res;
  }

  Future<List<CaseAsset>> getCaseAsset(int fidsId) async {
    final db = await DBProvider.db.database;
    var res = await db.query("CaseAsset");
    if (res.isEmpty) {
      return [];
    } else {
      var result = await db
          .query("CaseAsset", where: '"FidsID" = ?', whereArgs: ['$fidsId']);

      List<CaseAsset> listResult = [];
      for (int i = 0; i < result.length; i++) {
        Map<String, dynamic> res = result[i];
        CaseAsset formResponse = CaseAsset.fromJson(res);
        listResult.add(formResponse);
      }
      return listResult;
    }
  }

  Future<CaseAsset> getCaseAssetById(String? id) async {
    final db = await DBProvider.db.database;
    var res = await db.query("CaseAsset");
    if (res.isEmpty) {
      return CaseAsset();
    } else {
      var result =
          await db.query("CaseAsset", where: '"ID" = ?', whereArgs: ['$id']);
      CaseAsset response = CaseAsset.fromJson(result[0]);
      if (kDebugMode) {
        print('CaseAsset $response');
      }
      return response;
    }
  }

  Future<dynamic> delete(int fidsId) async {
    final db = await DBProvider.db.database;

    var res = await db.rawDelete('''
      DELETE FROM CaseAsset WHERE FidsID = ?
    ''', [fidsId]);
    if (kDebugMode) {
      print('DELETE Success');
    }
    return res;
  }
}
