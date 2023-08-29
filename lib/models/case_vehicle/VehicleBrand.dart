// ignore_for_file: file_names

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VehicleBrand {
  int? id;
  String? brandTH;
  String? brandEN;

  VehicleBrand({this.id, this.brandTH, this.brandEN});

  factory VehicleBrand.fromJson(Map<String, dynamic> json) {
    return VehicleBrand(
        id: json['ID'], brandTH: json['BrandTH'], brandEN: json['BrandEN']);
  }

  factory VehicleBrand.fromJsonFile(Map<String, dynamic> json) {
    return VehicleBrand(
      id: json['ID'],
      brandTH: json['BrandTH'],
      brandEN: json['BrandEN'],
    );
  }

  @override
  String toString() =>
      'VehicleBrand(id: $id, brandTH: $brandTH, brandEN: $brandEN)';
}

class VehicleBrandDao {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  insertVehicleBrand(String? json) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('vehicleBrand', json!);
  }

  Future<List<VehicleBrand>> getVehicleBrand() async {
    final SharedPreferences prefs = await _prefs;
    List<VehicleBrand> listResult = [];

    var json = prefs.getString('vehicleBrand');
    final jsonResult = jsonDecode(json!);
    var listRes = jsonResult['vehicleBrand'] as List;
    for (int i = 0; i < listRes.length; i++) {
      Map<String, dynamic> res = listRes[i];
      VehicleBrand formResponse = VehicleBrand.fromJsonFile(res);
      listResult.add(formResponse);
    }
    return listResult;
  }

  Future<List<String>> getVehicleBrandLabelList() async {
    final SharedPreferences prefs = await _prefs;
    List<String> listResult = [];
    var json = prefs.getString('vehicleBrand');

    final jsonResult = jsonDecode(json!);
    var listVehicleBrand = jsonResult['vehicleBrand'] as List;
    for (int i = 0; i < listVehicleBrand.length; i++) {
      Map<String, dynamic> res = listVehicleBrand[i];
      VehicleBrand formResponse = VehicleBrand.fromJsonFile(res);
      listResult.add('${formResponse.brandTH}(${formResponse.brandEN})');
      if (kDebugMode) {
        print('${formResponse.brandTH}(${formResponse.brandEN})');
      }
    }
    return listResult;
  }

  Future<String> getVehicleBrandLabelById(int id) async {
    final SharedPreferences prefs = await _prefs;
    var json = prefs.getString('vehicleBrand');
    final jsonResult = jsonDecode(json!);
    var listPersonal = jsonResult['brandTH'] as List;

    for (int i = 0; i < listPersonal.length; i++) {
      Map<String, dynamic> res = listPersonal[i];
      VehicleBrand formResponse = VehicleBrand.fromJsonFile(res);
      if ('${formResponse.id}' == '$id') {
        return formResponse.brandTH ?? '';
      }
    }
    return '';
  }
}
