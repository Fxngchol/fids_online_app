// ignore_for_file: file_names

import 'package:flutter/foundation.dart';

import '../../utils/database/database.dart';

class CaseImages {
  String? id;
  String? fidsId;
  String? imageFile;
  String? imageDetail;
  CaseImages({
    this.id,
    this.fidsId,
    this.imageFile,
    this.imageDetail,
  });

  Map toJson() => {
        'id': id == '-1' || id == null ? '' : '$id',
        'image_file': imageFile,
        'image_detail': imageDetail
      };

  factory CaseImages.fromJson(Map<String, dynamic> json) {
    return CaseImages(
      id: '${json['ID']}',
      fidsId: '${json['FidsID']}',
      imageFile: json['ImageFile'],
      imageDetail: json['ImageDetail'],
    );
  }

  @override
  String toString() {
    return 'CaseImages(id: $id, fidsId: $fidsId, imageFile: $imageFile, imageDetail: $imageDetail)';
  }
}

class CaseImagesDao {
  Future<dynamic> createCaseImages(
    int fidsId,
    String? imageFile,
    String? imageDetail,
  ) async {
    final db = await DBProvider.db.database;
    var res = await db.rawInsert('''
      INSERT INTO CaseImages (
        FidsID,ImageFile,ImageDetail
      ) VALUES (?,?,?)
    ''', [
      fidsId,
      imageFile,
      imageDetail,
    ]);
    return res;
  }

  Future<dynamic> updateCaseImages(
      String? imageFile, String? imageDetail, int id) async {
    final db = await DBProvider.db.database;

    var res = await db.rawUpdate('''
      UPDATE CaseImages SET  ImageFile = ? ,ImageDetail = ? WHERE ID = ?
    ''', [imageFile, imageDetail, id]);
    return res;
  }

  Future<dynamic> deleteCaseImages(String? id) async {
    final db = await DBProvider.db.database;

    var res = await db.rawDelete('''
      DELETE FROM CaseImages WHERE ID = ?
    ''', [id]);
    return res;
  }

  Future<dynamic> deleteCaseImagesAll(String? fidsId) async {
    final db = await DBProvider.db.database;

    var res = await db.rawDelete('''
      DELETE FROM CaseImages WHERE FidsID = ?
    ''', [fidsId]);
    return res;
  }

  Future<List<CaseImages>> getCaseImages(int caseId) async {
    final db = await DBProvider.db.database;
    var res = await db.query("CaseImages");
    if (res.isEmpty) {
      return [];
    } else {
      var result = await db
          .query("CaseImages", where: '"FidsID" = ?', whereArgs: ['$caseId']);

      List<CaseImages> listResult = [];

      for (int i = 0; i < result.length; i++) {
        Map<String, dynamic> res = result[i];
        CaseImages formResponse = CaseImages.fromJson(res);
        listResult.add(formResponse);
      }
      return listResult;
    }
  }

  Future<CaseImages> getCaseImagesById(int caseId, int caseImageId) async {
    final db = await DBProvider.db.database;
    var res = await db.query("CaseImages");
    if (res.isEmpty) {
      return CaseImages();
    } else {
      var result = await db
          .query("CaseImages", where: '"FidsID" = ?', whereArgs: ['$caseId']);

      CaseImages caseRelatedPerson = CaseImages();

      for (int i = 0; i < result.length; i++) {
        Map<String, dynamic> res = result[i];
        CaseImages formResponse = CaseImages.fromJson(res);
        if ('${formResponse.id}' == '$caseImageId') {
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
