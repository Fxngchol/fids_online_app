// ignore_for_file: file_names
import 'package:flutter/foundation.dart';

import '../../utils/database/database.dart';

class CaseBomb {
  String? id;
  String? fidsId;
  String? isBombPackage1;
  String? isBombPackage2;
  String? isBombPackage3;
  String? isBombPackage4;
  String? isBombPackage5;
  String? isBombPackage6;
  String? isBombPackage7;
  String? isBombPackage8;
  String? bombPackage8Detail;
  String? isIgnitionType1;
  String? ignitionType1Detail;
  String? isIgnitionType2;
  String? ignitionType1Color;
  String? ignitionType1Length;
  String? isIgnitionType3;
  String? ignitionType3Brand;
  String? ignitionType3Model;
  String? ignitionType3Colour;
  String? ignitionType3SN;
  String? isIgnitionType4;
  String? ignitionType4Brand;
  String? ignitionType4Model;
  String? ignitionType4Colour;
  String? ignitionType4SN;
  String? isIgnitionType5;
  String? ignitionType5Detail;
  String? isIgnitionType6;
  String? ignitionType6Detail;
  String? isIgnitionType7;
  String? ignitionType7Detail;
  String? isFlakType1;
  String? flakType1Size;
  String? flakType1Length;
  String? isFlakType2;
  String? flakType2Size;
  String? isFlakType3;
  String? flakType3Detail;
  String? isMaterial1;
  String? material1;
  String? isMaterial2;
  String? material2;
  String? isMaterial3;
  String? material3;
  String? isMaterial4;
  String? material4;
  String? isMaterial5;
  String? material5;
  String? isMaterial6;
  String? material6;
  String? material6V;
  String? isMaterial7;
  String? material7;
  String? isMaterial8;
  String? material8;
  String? isMaterial9;
  String? material9;
  String? isMaterial10;
  String? material10;
  String? isMaterial11;
  String? material11;
  String? isMaterial12;
  String? material12;
  String? isMaterial13;
  String? material13;
  String? isMaterial14;
  String? material14;

  CaseBomb(
      {this.id,
      this.fidsId,
      this.isBombPackage1,
      this.isBombPackage2,
      this.isBombPackage3,
      this.isBombPackage4,
      this.isBombPackage5,
      this.isBombPackage6,
      this.isBombPackage7,
      this.isBombPackage8,
      this.bombPackage8Detail,
      this.isIgnitionType1,
      this.ignitionType1Detail,
      this.isIgnitionType2,
      this.ignitionType1Color,
      this.ignitionType1Length,
      this.isIgnitionType3,
      this.ignitionType3Brand,
      this.ignitionType3Model,
      this.ignitionType3Colour,
      this.ignitionType3SN,
      this.isIgnitionType4,
      this.ignitionType4Brand,
      this.ignitionType4Model,
      this.ignitionType4Colour,
      this.ignitionType4SN,
      this.isIgnitionType5,
      this.ignitionType5Detail,
      this.isIgnitionType6,
      this.ignitionType6Detail,
      this.isIgnitionType7,
      this.ignitionType7Detail,
      this.isFlakType1,
      this.flakType1Size,
      this.flakType1Length,
      this.isFlakType2,
      this.flakType2Size,
      this.isFlakType3,
      this.flakType3Detail,
      this.isMaterial1,
      this.material1,
      this.isMaterial2,
      this.material2,
      this.isMaterial3,
      this.material3,
      this.isMaterial4,
      this.material4,
      this.isMaterial5,
      this.material5,
      this.isMaterial6,
      this.material6,
      this.material6V,
      this.isMaterial7,
      this.material7,
      this.isMaterial8,
      this.material8,
      this.isMaterial9,
      this.material9,
      this.isMaterial10,
      this.material10,
      this.isMaterial11,
      this.material11,
      this.isMaterial12,
      this.material12,
      this.isMaterial13,
      this.material13,
      this.isMaterial14,
      this.material14});

  factory CaseBomb.fromMap(Map<String?, dynamic> map) {
    return CaseBomb(
      id: '${map['ID']}',
      fidsId: '${map['FidsID']}',
      isBombPackage1: map['IsBombPackage1'] ?? '',
      isBombPackage2: map['IsBombPackage2'] ?? '',
      isBombPackage3: map['IsBombPackage3'] ?? '',
      isBombPackage4: map['IsBombPackage4'] ?? '',
      isBombPackage5: map['IsBombPackage5'] ?? '',
      isBombPackage6: map['IsBombPackage6'] ?? '',
      isBombPackage7: map['IsBombPackage7'] ?? '',
      isBombPackage8: map['IsBombPackage8'] ?? '',
      bombPackage8Detail: map['BombPackage8Detail'] ?? '',
      isIgnitionType1: map['IsIgnitionType1'] ?? '',
      ignitionType1Detail: map['IgnitionType1Detail'] ?? '',
      isIgnitionType2: map['IsIgnitionType2'] ?? '',
      ignitionType1Color: map['IgnitionType1Color'] ?? '',
      ignitionType1Length: map['IgnitionType1Length'] ?? '',
      isIgnitionType3: map['IsIgnitionType3'] ?? '',
      ignitionType3Brand: map['IgnitionType3Brand'] ?? '',
      ignitionType3Model: map['IgnitionType3Model'] ?? '',
      ignitionType3Colour: map['IgnitionType3Colour'] ?? '',
      ignitionType3SN: map['IgnitionType3SN'] ?? '',
      isIgnitionType4: map['IsIgnitionType4'] ?? '',
      ignitionType4Brand: map['IgnitionType4Brand'] ?? '',
      ignitionType4Model: map['IgnitionType4Model'] ?? '',
      ignitionType4Colour: map['IgnitionType4Colour'] ?? '',
      ignitionType4SN: map['IgnitionType4SN'] ?? '',
      isIgnitionType5: map['IsIgnitionType5'] ?? '',
      ignitionType5Detail: map['IgnitionType5Detail'] ?? '',
      isIgnitionType6: map['IsIgnitionType6'] ?? '',
      ignitionType6Detail: map['IgnitionType6Detail'] ?? '',
      isIgnitionType7: map['IsIgnitionType7'] ?? '',
      ignitionType7Detail: map['IgnitionType7Detail'] ?? '',
      isFlakType1: map['IsFlakType1'] ?? '',
      flakType1Size: map['FlakType1Size'] ?? '',
      flakType1Length: map['FlakType1Length'] ?? '',
      isFlakType2: map['IsFlakType2'] ?? '',
      flakType2Size: map['FlakType2Size'] ?? '',
      isFlakType3: map['IsFlakType3'] ?? '',
      flakType3Detail: map['FlakType3Detail'] ?? '',
      isMaterial1: map['IsMaterial1'] ?? '',
      material1: map['Material1'] ?? '',
      isMaterial2: map['IsMaterial2'] ?? '',
      material2: map['Material2'] ?? '',
      isMaterial3: map['IsMaterial3'] ?? '',
      material3: map['Material3'] ?? '',
      isMaterial4: map['IsMaterial4'] ?? '',
      material4: map['Material4'] ?? '',
      isMaterial5: map['IsMaterial5'] ?? '',
      material5: map['Material5'] ?? '',
      isMaterial6: map['IsMaterial6'] ?? '',
      material6: map['Material6'] ?? '',
      material6V: map['Material6V'] ?? '',
      isMaterial7: map['IsMaterial7'] ?? '',
      material7: map['Material7'] ?? '',
      isMaterial8: map['IsMaterial8'] ?? '',
      material8: map['Material8'] ?? '',
      isMaterial9: map['IsMaterial9'] ?? '',
      material9: map['Material9'] ?? '',
      isMaterial10: map['IsMaterial10'] ?? '',
      material10: map['Material10'] ?? '',
      isMaterial11: map['IsMaterial11'] ?? '',
      material11: map['Material11'] ?? '',
      isMaterial12: map['IsMaterial12'] ?? '',
      material12: map['Material12'] ?? '',
      isMaterial13: map['IsMaterial13'] ?? '',
      material13: map['Material13'] ?? '',
      isMaterial14: map['IsMaterial14'] ?? '',
      material14: map['Material14'] ?? '',
    );
  }

  Map toJson() => {
        'id': id == '-2' || id == null ? '' : '$id',
        'is_bomb_package1': isBombPackage1 == null || isBombPackage1 == '-1'
            ? ''
            : isBombPackage1,
        'is_bomb_package2': isBombPackage2 == null || isBombPackage2 == '-1'
            ? ''
            : isBombPackage2,
        'is_bomb_package3': isBombPackage3 == null || isBombPackage3 == '-1'
            ? ''
            : isBombPackage3,
        'is_bomb_package4': isBombPackage4 == null || isBombPackage4 == '-1'
            ? ''
            : isBombPackage4,
        'is_bomb_package5': isBombPackage5 == null || isBombPackage5 == '-1'
            ? ''
            : isBombPackage5,
        'is_bomb_package6': isBombPackage6 == null || isBombPackage6 == '-1'
            ? ''
            : isBombPackage6,
        'is_bomb_package7': isBombPackage7 == null || isBombPackage7 == '-1'
            ? ''
            : isBombPackage7,
        'is_bomb_package8': isBombPackage8 == null || isBombPackage8 == '-1'
            ? ''
            : isBombPackage8,
        'bomb_package8_detail': bombPackage8Detail ?? '',
        'is_ignitiontype1': isIgnitionType1 == null || isIgnitionType1 == '-1'
            ? ''
            : isIgnitionType1,
        'ignitionType1_detail': ignitionType1Detail ?? '',
        'is_ignitionType2': isIgnitionType2 == null || isIgnitionType2 == '-1'
            ? ''
            : isIgnitionType2,
        'ignitionType1_color': ignitionType1Color ?? '',
        'ignitionType1_length': ignitionType1Length ?? '',
        'is_ignitionType3': isIgnitionType3 == null || isIgnitionType3 == '-1'
            ? ''
            : isIgnitionType3,
        'ignitionType3_brand': ignitionType3Brand ?? '',
        'ignitionType3_model': ignitionType3Model ?? '',
        'ignitionType3_colour': ignitionType3Colour ?? '',
        'ignitionType3_sn': ignitionType3SN ?? '',
        'is_ignitionType4': isIgnitionType4 == null || isIgnitionType4 == '-1'
            ? ''
            : isIgnitionType4,
        'ignitionType4_brand': ignitionType4Brand ?? '',
        'ignitionType4_model': ignitionType4Model ?? '',
        'ignitionType4_colour':
            ignitionType4Colour == null ? '' : ignitionType3Colour,
        'ignitionType4_sn': ignitionType4SN ?? '',
        'is_ignitionType5': isIgnitionType5 == null || isIgnitionType5 == '-1'
            ? ''
            : isIgnitionType5,
        'ignitionType5_detail': ignitionType5Detail ?? '',
        'is_ignitionType6': isIgnitionType6 == null || isIgnitionType6 == '-1'
            ? ''
            : isIgnitionType6,
        'ignitionType6_detail': ignitionType6Detail ?? '',
        'is_ignitionType7': isIgnitionType7 == null || isIgnitionType7 == '-1'
            ? ''
            : isIgnitionType7,
        'ignitionType7_detail': ignitionType7Detail ?? '',
        'is_flakType1':
            isFlakType1 == null || isFlakType1 == '-1' ? '' : isFlakType1,
        'flakType1_size': flakType1Size ?? '',
        'flakType1_length': flakType1Length ?? '',
        'is_flakType2':
            isFlakType2 == null || isFlakType2 == '-1' ? '' : isFlakType2,
        'flakType2_size': flakType2Size ?? '',
        'is_flakType3':
            isFlakType3 == null || isFlakType3 == '-1' ? '' : isFlakType3,
        'flakType3_detail': flakType3Detail ?? '',
        'is_material1':
            isMaterial1 == null || isMaterial1 == '-1' ? '' : isMaterial1,
        'material1': material1 ?? '',
        'is_material2':
            isMaterial2 == null || isMaterial2 == '-1' ? '' : isMaterial2,
        'material2': material2 ?? '',
        'is_material3':
            isMaterial3 == null || isMaterial3 == '-1' ? '' : isMaterial3,
        'material3': material3 ?? '',
        'is_material4':
            isMaterial4 == null || isMaterial4 == '-1' ? '' : isMaterial4,
        'material4': material4 ?? '',
        'is_material5':
            isMaterial5 == null || isMaterial5 == '-1' ? '' : isMaterial5,
        'material5': material5 ?? '',
        'is_material6':
            isMaterial6 == null || isMaterial6 == '-1' ? '' : isMaterial6,
        'material6': material6 ?? '',
        'material6V': material6V ?? '',
        'is_material7':
            isMaterial7 == null || isMaterial7 == '-1' ? '' : isMaterial7,
        'material7': material7 ?? '',
        'is_material8':
            isMaterial8 == null || isMaterial8 == '-1' ? '' : isMaterial8,
        'material8': material8 ?? '',
        'is_material9':
            isMaterial9 == null || isMaterial9 == '-1' ? '' : isMaterial9,
        'material9': material9 ?? '',
        'is_material10':
            isMaterial10 == null || isMaterial10 == '-1' ? '' : isMaterial10,
        'material10': material10 ?? '',
        'is_material11':
            isMaterial11 == null || isMaterial11 == '-1' ? '' : isMaterial11,
        'material11': material11 ?? '',
        'is_material12':
            isMaterial12 == null || isMaterial12 == '-1' ? '' : isMaterial12,
        'material12': material12 ?? '',
        'is_material13':
            isMaterial13 == null || isMaterial13 == '-1' ? '' : isMaterial13,
        'material13': material13 ?? '',
        'is_material14':
            isMaterial14 == null || isMaterial14 == '-1' ? '' : isMaterial14,
        'material14': material14 ?? '',
      };
}

class CaseBombDao {
  createCaseBomb(
      String? fidsId,
      String? isBombPackage1,
      String? isBombPackage2,
      String? isBombPackage3,
      String? isBombPackage4,
      String? isBombPackage5,
      String? isBombPackage6,
      String? isBombPackage7,
      String? isBombPackage8,
      String? bombPackage8Detail,
      String? isIgnitionType1,
      String? ignitionType1Detail,
      String? isIgnitionType2,
      String? ignitionType1Color,
      String? ignitionType1Length,
      String? isIgnitionType3,
      String? ignitionType3Brand,
      String? ignitionType3Model,
      String? ignitionType3Colour,
      String? ignitionType3SN,
      String? isIgnitionType4,
      String? ignitionType4Brand,
      String? ignitionType4Model,
      String? ignitionType4Colour,
      String? ignitionType4SN,
      String? isIgnitionType5,
      String? ignitionType5Detail,
      String? isIgnitionType6,
      String? ignitionType6Detail,
      String? isIgnitionType7,
      String? ignitionType7Detail,
      String? isFlakType1,
      String? flakType1Size,
      String? flakType1Length,
      String? isFlakType2,
      String? flakType2Size,
      String? isFlakType3,
      String? flakType3Detail,
      String? isMaterial1,
      String? material1,
      String? isMaterial2,
      String? material2,
      String? isMaterial3,
      String? material3,
      String? isMaterial4,
      String? material4,
      String? isMaterial5,
      String? material5,
      String? isMaterial6,
      String? material6,
      String? material6V,
      String? isMaterial7,
      String? material7,
      String? isMaterial8,
      String? material8,
      String? isMaterial9,
      String? material9,
      String? isMaterial10,
      String? material10,
      String? isMaterial11,
      String? material11,
      String? isMaterial12,
      String? material12,
      String? isMaterial13,
      String? material13,
      String? isMaterial14,
      String? material14) async {
    final db = await DBProvider.db.database;
    var res = await db.rawInsert('''
      INSERT INTO CaseBomb (
        FidsID,IsBombPackage1,IsBombPackage2,IsBombPackage3,IsBombPackage4,IsBombPackage5,IsBombPackage6,IsBombPackage7,IsBombPackage8,BombPackage8Detail,IsIgnitionType1,IgnitionType1Detail,IsIgnitionType2,IgnitionType1Color,IgnitionType1Length,IsIgnitionType3,IgnitionType3Brand,IgnitionType3Model,IgnitionType3Colour,IgnitionType3SN,IsIgnitionType4,IgnitionType4Brand,IgnitionType4Model,IgnitionType4Colour,IgnitionType4SN,IsIgnitionType5,IgnitionType5Detail,IsIgnitionType6,IgnitionType6Detail,IsIgnitionType7,IgnitionType7Detail,IsFlakType1,FlakType1Size,FlakType1Length,IsFlakType2,FlakType2Size,IsFlakType3,FlakType3Detail,IsMaterial1,Material1,IsMaterial2,Material2,IsMaterial3,Material3,IsMaterial4,Material4,IsMaterial5,Material5,IsMaterial6,Material6,Material6V,IsMaterial7,Material7,IsMaterial8,Material8,IsMaterial9,Material9,IsMaterial10,Material10,IsMaterial11,Material11,IsMaterial12,Material12,IsMaterial13,Material13,IsMaterial14,Material14
      ) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,? ,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)
    ''', [
      fidsId,
      isBombPackage1,
      isBombPackage2,
      isBombPackage3,
      isBombPackage4,
      isBombPackage5,
      isBombPackage6,
      isBombPackage7,
      isBombPackage8,
      bombPackage8Detail,
      isIgnitionType1,
      ignitionType1Detail,
      isIgnitionType2,
      ignitionType1Color,
      ignitionType1Length,
      isIgnitionType3,
      ignitionType3Brand,
      ignitionType3Model,
      ignitionType3Colour,
      ignitionType3SN,
      isIgnitionType4,
      ignitionType4Brand,
      ignitionType4Model,
      ignitionType4Colour,
      ignitionType4SN,
      isIgnitionType5,
      ignitionType5Detail,
      isIgnitionType6,
      ignitionType6Detail,
      isIgnitionType7,
      ignitionType7Detail,
      isFlakType1,
      flakType1Size,
      flakType1Length,
      isFlakType2,
      flakType2Size,
      isFlakType3,
      flakType3Detail,
      isMaterial1,
      material1,
      isMaterial2,
      material2,
      isMaterial3,
      material3,
      isMaterial4,
      material4,
      isMaterial5,
      material5,
      isMaterial6,
      material6,
      material6V,
      isMaterial7,
      material7,
      isMaterial8,
      material8,
      isMaterial9,
      material9,
      isMaterial10,
      material10,
      isMaterial11,
      material11,
      isMaterial12,
      material12,
      isMaterial13,
      material13,
      isMaterial14,
      material14
    ]);

    return res;
  }

  updateCaseBomb(
      String? id,
      String? fidsId,
      String? isBombPackage1,
      String? isBombPackage2,
      String? isBombPackage3,
      String? isBombPackage4,
      String? isBombPackage5,
      String? isBombPackage6,
      String? isBombPackage7,
      String? isBombPackage8,
      String? bombPackage8Detail,
      String? isIgnitionType1,
      String? ignitionType1Detail,
      String? isIgnitionType2,
      String? ignitionType1Color,
      String? ignitionType1Length,
      String? isIgnitionType3,
      String? ignitionType3Brand,
      String? ignitionType3Model,
      String? ignitionType3Colour,
      String? ignitionType3SN,
      String? isIgnitionType4,
      String? ignitionType4Brand,
      String? ignitionType4Model,
      String? ignitionType4Colour,
      String? ignitionType4SN,
      String? isIgnitionType5,
      String? ignitionType5Detail,
      String? isIgnitionType6,
      String? ignitionType6Detail,
      String? isIgnitionType7,
      String? ignitionType7Detail,
      String? isFlakType1,
      String? flakType1Size,
      String? flakType1Length,
      String? isFlakType2,
      String? flakType2Size,
      String? isFlakType3,
      String? flakType3Detail,
      String? isMaterial1,
      String? material1,
      String? isMaterial2,
      String? material2,
      String? isMaterial3,
      String? material3,
      String? isMaterial4,
      String? material4,
      String? isMaterial5,
      String? material5,
      String? isMaterial6,
      String? material6,
      String? material6V,
      String? isMaterial7,
      String? material7,
      String? isMaterial8,
      String? material8,
      String? isMaterial9,
      String? material9,
      String? isMaterial10,
      String? material10,
      String? isMaterial11,
      String? material11,
      String? isMaterial12,
      String? material12,
      String? isMaterial13,
      String? material13,
      String? isMaterial14,
      String? material14) async {
    final db = await DBProvider.db.database;
    var res = await db.rawUpdate('''
      UPDATE CaseBomb SET
        FidsID = ?,IsBombPackage1 = ?,IsBombPackage2 = ?,IsBombPackage3 = ?,IsBombPackage4 = ?,IsBombPackage5 = ?,IsBombPackage6 = ?,IsBombPackage7 = ?,IsBombPackage8 = ?,BombPackage8Detail = ?,IsIgnitionType1 = ?,IgnitionType1Detail = ?,IsIgnitionType2 = ?,IgnitionType1Color = ?,IgnitionType1Length = ?,IsIgnitionType3 = ?,IgnitionType3Brand = ?,IgnitionType3Model = ?,IgnitionType3Colour = ?,IgnitionType3SN = ?,IsIgnitionType4 = ?,IgnitionType4Brand = ?,IgnitionType4Model = ?,IgnitionType4Colour = ?,IgnitionType4SN = ?,IsIgnitionType5 = ?,IgnitionType5Detail = ?,IsIgnitionType6 = ?,IgnitionType6Detail = ?,IsIgnitionType7 = ?,IgnitionType7Detail = ?,IsFlakType1 = ?,FlakType1Size = ?,FlakType1Length = ?,IsFlakType2 = ?,FlakType2Size = ?,IsFlakType3 = ?,FlakType3Detail = ?,IsMaterial1 = ?,Material1 = ?,IsMaterial2 = ?,Material2 = ?,IsMaterial3 = ?,Material3 = ?,IsMaterial4 = ?,Material4 = ?,IsMaterial5 = ?,Material5 = ?,IsMaterial6 = ?,Material6 = ?,Material6V = ?,IsMaterial7 = ?,Material7 = ?,IsMaterial8 = ?,Material8 = ?,IsMaterial9 = ?,Material9 = ?,IsMaterial10 = ?,Material10 = ?,IsMaterial11 = ?,Material11 = ?,IsMaterial12 = ?,Material12 = ?,IsMaterial13 = ?,Material13 = ?,IsMaterial14 = ?,Material14 = ?  WHERE ID = ?
    ''', [
      fidsId,
      isBombPackage1,
      isBombPackage2,
      isBombPackage3,
      isBombPackage4,
      isBombPackage5,
      isBombPackage6,
      isBombPackage7,
      isBombPackage8,
      bombPackage8Detail,
      isIgnitionType1,
      ignitionType1Detail,
      isIgnitionType2,
      ignitionType1Color,
      ignitionType1Length,
      isIgnitionType3,
      ignitionType3Brand,
      ignitionType3Model,
      ignitionType3Colour,
      ignitionType3SN,
      isIgnitionType4,
      ignitionType4Brand,
      ignitionType4Model,
      ignitionType4Colour,
      ignitionType4SN,
      isIgnitionType5,
      ignitionType5Detail,
      isIgnitionType6,
      ignitionType6Detail,
      isIgnitionType7,
      ignitionType7Detail,
      isFlakType1,
      flakType1Size,
      flakType1Length,
      isFlakType2,
      flakType2Size,
      isFlakType3,
      flakType3Detail,
      isMaterial1,
      material1,
      isMaterial2,
      material2,
      isMaterial3,
      material3,
      isMaterial4,
      material4,
      isMaterial5,
      material5,
      isMaterial6,
      material6,
      material6V,
      isMaterial7,
      material7,
      isMaterial8,
      material8,
      isMaterial9,
      material9,
      isMaterial10,
      material10,
      isMaterial11,
      material11,
      isMaterial12,
      material12,
      isMaterial13,
      material13,
      isMaterial14,
      material14,
      id
    ]);

    return res;
  }

  Future<List<CaseBomb>> getCaseBomb(int fidsID) async {
    final db = await DBProvider.db.database;
    var res = await db
        .query("CaseBomb", where: '"FidsID" = ?', whereArgs: ['$fidsID']);
    if (res.isEmpty) {
      return [];
    } else {
      var result = await db
          .query("CaseBomb", where: '"FidsID" = ?', whereArgs: ['$fidsID']);
      List<CaseBomb> listResult = [];
      for (int i = 0; i < result.length; i++) {
        CaseBomb formResponse = CaseBomb.fromMap(result[i]);
        listResult.add(formResponse);
      }

      return listResult;
    }
  }

  Future<CaseBomb?> getCaseBombById(String? id) async {
    final db = await DBProvider.db.database;
    var res = await db.query("CaseBomb");
    if (res.isEmpty) {
      return null;
    } else {
      var result =
          await db.query("CaseBomb", where: '"ID" = ?', whereArgs: ['$id']);

      CaseBomb response = CaseBomb.fromMap(result[0]);
      return response;
    }
  }

  deleteCaseBomb(String? id) async {
    final db = await DBProvider.db.database;

    var res = await db.rawDelete('''
      DELETE FROM CaseBomb WHERE ID = ?
    ''', [id]);
    if (kDebugMode) {
      print('DELETE Success');
    }
    return res;
  }

  delete(int fidsId) async {
    final db = await DBProvider.db.database;

    var res = await db.rawDelete('''
      DELETE FROM CaseBomb WHERE FidsID = ?
    ''', [fidsId]);
    if (kDebugMode) {
      print('DELETE Success');
    }
    return res;
  }
}
