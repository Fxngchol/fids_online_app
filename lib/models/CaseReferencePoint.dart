// ignore_for_file: file_names
import '../../utils/database/database.dart';

class CaseReferencePoint {
  int? id;
  int? fidsId;
  String? referencePointNo;
  String? referencePointDetail;
  String? createDate;
  String? createBy;
  String? updateDate;
  String? updateBy;
  int? activeFlag;

  CaseReferencePoint(
      {this.id,
      this.fidsId,
      this.referencePointNo,
      this.referencePointDetail,
      this.createDate,
      this.createBy,
      this.updateDate,
      this.updateBy,
      this.activeFlag});

  factory CaseReferencePoint.fromApi(Map<String, dynamic> json) {
    return CaseReferencePoint(
      id: int.parse(json['id']),
      fidsId: int.parse(json['fidsno']),
      referencePointNo: json['referenc_point_no'] ?? '',
      referencePointDetail: json['referenc_point_detail'] ?? '',
    );
  }
  factory CaseReferencePoint.fromJson(Map<String, dynamic> json) {
    return CaseReferencePoint(
      id: json['ID'],
      fidsId: json['FidsID'],
      referencePointNo: json['ReferencePointNo'],
      referencePointDetail: json['ReferencePointDetail'],
      createDate: json['CreateDate'],
      createBy: json['CreateBy'],
      updateDate: json['UpdateDate'],
      updateBy: json['UpdateBy'],
      activeFlag: json['ActiveFlag'],
    );
  }
  Map toJson() => {
        'id': id == -2 || id == null ? null : '$id',
        'referenc_point_no': referencePointNo ?? '',
        'referenc_point_detail': referencePointDetail ?? '',
        'active_flag': '1',
      };

  @override
  String toString() {
    return 'CaseReferencePoint(id: $id, fidsId: $fidsId, referencePointNo: $referencePointNo, referencePointDetail: $referencePointDetail, createDate: $createDate, createBy: $createBy, updateDate: $updateDate, updateBy: $updateBy, activeFlag: $activeFlag)';
  }
}

class CaseReferencePointDao {
  Future<void> createCaseReferencePointl(
      int fidsId,
      String? referencePointNo,
      String? referencePointDetail,
      String? createDate,
      String? createBy,
      String? updateDate,
      String? updateBy,
      int activeFlag) async {
    final db = await DBProvider.db.database;
    await db.rawInsert('''
      INSERT INTO CaseReferencePoint (
        FidsID,ReferencePointNo,ReferencePointDetail,CreateDate,CreateBy,UpdateDate,UpdateBy,ActiveFlag
      ) VALUES (?,?,?,?,?,?,?,?)
    ''', [
      fidsId,
      referencePointNo,
      referencePointDetail,
      createDate,
      createBy,
      updateDate,
      updateBy,
      activeFlag
    ]);
  }

  Future<void> updateCaseReferencePointl(
    int id,
    String? referencePointNo,
    String? referencePointDetail,
  ) async {
    final db = await DBProvider.db.database;
    await db.rawUpdate('''
      UPDATE CaseReferencePoint SET
        ReferencePointNo = ?, ReferencePointDetail = ? WHERE ID = ?
    ''', [
      referencePointNo,
      referencePointDetail,
      id,
    ]);
  }

  Future<void> deleteCaseReferencePoint(int id) async {
    final db = await DBProvider.db.database;

    await db.rawDelete('''
      DELETE FROM CaseReferencePoint WHERE ID = ?
    ''', [id]);
  }

  Future<void> deleteCaseReferencePointFidsID(int id) async {
    final db = await DBProvider.db.database;

    await db.rawDelete('''
      DELETE FROM CaseReferencePoint WHERE FidsID = ?
    ''', [id]);
  }

  Future<List<CaseReferencePoint>> getCaseReferencePoint(String? fidsID) async {
    final db = await DBProvider.db.database;
    var res = await db.query("CaseReferencePoint",
        where: '"FidsID" = ?', whereArgs: ['$fidsID']);
    if (res.isEmpty) {
      return [];
    } else {
      var result = await db.query("CaseReferencePoint",
          where: '"FidsID" = ?', whereArgs: ['$fidsID']);

      List<CaseReferencePoint> listResult = [];

      for (int i = 0; i < result.length; i++) {
        Map<String, dynamic> res = result[i];
        CaseReferencePoint formResponse = CaseReferencePoint.fromJson(res);
        listResult.add(formResponse);
      }
      return listResult;
    }
  }

  Future<CaseReferencePoint> getCaseReferencePointById(String? id) async {
    final db = await DBProvider.db.database;
    var res = await db.query("CaseReferencePoint");
    if (res.isEmpty) {
      return CaseReferencePoint();
    } else {
      // var result = await db.query("CaseInspector",
      //     where: '"FidsID" = ?', whereArgs: ['$fidsID']);

      var result = await db.query("CaseReferencePoint");

      // List<CaseReferencePoint> listResult = [];
      // print('result : ${result.toString()}');
      // CaseInspector response = CaseInspector.fromJson(result[0]);

      for (int i = 0; i < result.length; i++) {
        Map<String, dynamic> res = result[i];
        CaseReferencePoint formResponse = CaseReferencePoint.fromJson(res);
        if ('$id' == '${formResponse.id}') {
          return formResponse;
        }
      }
      return CaseReferencePoint();
    }
  }
}
