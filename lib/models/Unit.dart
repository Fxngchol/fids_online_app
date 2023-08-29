// ignore_for_file: file_names

import 'dart:convert';

// class Unit {
//   int? id;
//   String? name;

//   Unit({
//     this.id,
//     this.name,
//   });

//   factory Unit.fromJson(Map<String, dynamic> json) {
//     return Unit(id: json['ID'], name: json['Name']);
//   }

//   // @override
//   // String toString() => 'Unit(unitId: $unitId, unitName: $unitName)';

//   // Map<String, dynamic> toMap() {
//   //   return {
//   //     'unitId': unitId,
//   //     'unitName': unitName,
//   //   };
//   // }

//   // factory Unit.fromMap(Map<String, dynamic> map) {
//   //   if (map == null) return null;

//   //   return Unit(
//   //     unitId: map['unitId'],
//   //     unitName: map['unitName'],
//   //   );
//   // }

//   // String toJson() => json.encode(toMap());
//   // factory Unit.fromJson(String source) => Unit.fromMap(json.decode(source));
// }

// class UnitDao {
//   insertUnit(int id, String name) async {
//     final db = await DBProvider.db.database;

//     List<Map> result = await db.query("Unit");
//     // result.forEach((row) => print('farmid : ${row['farmid']}'));

//     bool isAdded = false;
//     for (int i = 0; i < result.length; i++) {
//       if (id == result[i]['ID']) {
//         isAdded = true;
//       }
//     }
//
//     if (isAdded) {
//   var res = await db.rawUpdate('''
//       UPDATE Unit SET Name = ? WHERE ID = ?
//     ''', [name, id]);
//     } else {
//   var res = await db.rawInsert('''
//       INSERT INTO Unit (
//         ID,Name
//       ) VALUES (?,?)
//     ''', [id, name]);
//     }
//     return res;
//   }

//   Future<List<Unit>> getUnit() async {
//     final db = await DBProvider.db.database;
//     var res = await  db.query("Unit");
//     if (res.isEmpty) {
//       return [];
//     } else {
//       var result = await db.query(
//         "Unit",
//       );

//       List<Unit> listResult = [];
//       print('result unit : ${result.toString()}');
//       Unit response = Unit.fromJson(result[0]);

//       for (int i = 0; i < result.length; i++) {
//         Map<String, dynamic> res = result[i];
//         Unit formResponse = Unit.fromJson(res);
//         listResult.add(formResponse);
//       }
//       return listResult;
//     }
//   }

//   Future<List<String>> getUnitLabel() async {
//     final db = await DBProvider.db.database;
//     var res = await  db.query("Unit");
//     if (res.isEmpty) {
//       return [];
//     } else {
//       var result = await db.query(
//         "Unit",
//       );

//       List<String> listResult = [];
//       // print('result : ${result.toString()}');
//       Unit response = Unit.fromJson(result[0]);
//       for (int i = 0; i < result.length; i++) {
//         Map<String, dynamic> res = result[i];
//         Unit formResponse = Unit.fromJson(res);
//         listResult.add(formResponse.name ?? '');
//       }
//       return listResult;
//     }
//   }
// }

import 'package:shared_preferences/shared_preferences.dart';

class Unit {
  int? id;
  String? name;

  Unit({
    this.id,
    this.name,
  });

  factory Unit.fromJson(Map<String, dynamic> json) {
    return Unit(id: json['ID'], name: json['Name']);
  }

  factory Unit.fromJsonFile(Map<String, dynamic> json) {
    return Unit(id: json['id'], name: json['name']);
  }
}

class UnitDao {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  insertUnit(String json) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('unit', json);
  }

  Future<List<Unit>> getUnit() async {
    final SharedPreferences prefs = await _prefs;
    List<Unit> listResult = [];

    var json = prefs.getString('unit');
    final jsonResult = jsonDecode(json!);

    var listRes = jsonResult['unit'] as List;

    for (int i = 0; i < listRes.length; i++) {
      Map<String, dynamic> res = listRes[i];
      Unit formResponse = Unit.fromJsonFile(res);
      listResult.add(formResponse);
    }
    return listResult;
  }

  Future<List<String>> getUnitLabel() async {
    final SharedPreferences prefs = await _prefs;
    List<String> listResult = [];

    var json = prefs.getString('unit');
    final jsonResult = jsonDecode(json!);

    var listRes = jsonResult['unit'] as List;

    for (int i = 0; i < listRes.length; i++) {
      Map<String, dynamic> res = listRes[i];
      Unit formResponse = Unit.fromJsonFile(res);
      listResult.add(formResponse.name ?? '');
    }
    return listResult;
  }

  Future<String> getUnitLabelById(String id) async {
    final SharedPreferences prefs = await _prefs;

    var json = prefs.getString('unit');
    final jsonResult = jsonDecode(json!);

    var listRes = jsonResult['unit'] as List;

    for (int i = 0; i < listRes.length; i++) {
      Map<String, dynamic> res = listRes[i];
      Unit formResponse = Unit.fromJsonFile(res);
      if (id == '${formResponse.id}') {
        return formResponse.name ?? '';
      }
    }
    return '';
  }
}
