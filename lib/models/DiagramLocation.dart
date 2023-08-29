// ignore_for_file: file_names

import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../utils/database/database.dart';

class DiagramLocation {
  String? id;
  String? fidsId;
  String? diagramId;
  String? diagram;
  String? diagramRemark;
  String? action;

  DiagramLocation({
    this.id,
    this.fidsId,
    this.diagramId,
    this.diagram,
    this.diagramRemark,
    this.action,
  });

  factory DiagramLocation.fromMap(Map<String, dynamic> map) {
    return DiagramLocation(
      id: map['ID'],
      fidsId: map['FidsNo'],
      diagramId: map['DiagramID'],
      diagram: map['Diagram'],
      diagramRemark: map['DiagramRemark'],
      action: map['Action'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ID': id == '-2' || id == null ? '' : '$id',
      'FidsID': fidsId == '-2' || fidsId == null ? '' : '$fidsId',
      'DiagramID': diagramId == '-2' || diagramId == null ? '' : '$diagramId',
      'Diagram': diagram,
      'DiagramRemark': diagramRemark,
      'Action': action,
    };
  }

  String toJson() => json.encode(toMap());

  factory DiagramLocation.fromJson(Map<String, dynamic> json) {
    return DiagramLocation(
        id: '${json['ID']}',
        fidsId: '${json['FidsID']}',
        diagramId: '${json['DiagramID']}',
        diagram: json['Diagram'] ?? '',
        diagramRemark: json['DiagramRemark'] ?? '',
        action: json['Action']);
  }
}

class DiagramLocationDao {
  createDiagramLocation(
      String diagram, String diagramRemark, int fidsId) async {
    final db = await DBProvider.db.database;

    var res = await db.rawInsert('''
      INSERT INTO DiagramLocation (
        Diagram,DiagramRemark,FidsID
      ) VALUES (?,?,?)
    ''', [diagram, diagramRemark, fidsId]);
    return res;
  }

  Future<DiagramLocation> getDiagramLocation(String caseId) async {
    final db = await DBProvider.db.database;
    var res = await db.query("DiagramLocation");
    if (res.isEmpty) {
      return DiagramLocation();
    } else {
      var result = await db
          .query("DiagramLocation", where: '"FidsID" = ?', whereArgs: [caseId]);
      // print('result : ${result.toString()}');
      DiagramLocation response;
      try {
        response = DiagramLocation.fromJson(result[0]);
      } catch (ex) {
        response = DiagramLocation();
      }

      return response;
    }
  }

  updateLocationCase(String diagram, String diagramRemark, int id) async {
    final db = await DBProvider.db.database;

    if (kDebugMode) {
      print('updateLocationCase ID $id');
    }
    var res = await db.rawUpdate('''
      UPDATE DiagramLocation SET Diagram = ?,DiagramRemark = ? WHERE ID = ?
    ''', [diagram, diagramRemark, id]);
    return res;
  }

  delete(int fidsId) async {
    final db = await DBProvider.db.database;

    var res = await db.rawDelete('''
      DELETE FROM DiagramLocation WHERE FidsID = ?
    ''', [fidsId]);
    if (kDebugMode) {
      print('DELETE Success');
    }
    return res;
  }
}
