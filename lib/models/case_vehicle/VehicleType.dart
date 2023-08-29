// ignore_for_file: file_names
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class VehicleType {
  int? id;
  String? vehicleType;

  VehicleType({this.id, this.vehicleType});

  factory VehicleType.fromJson(Map<String, dynamic> json) {
    return VehicleType(
      id: json['ID'],
      vehicleType: json['VehicleType'],
    );
  }

  factory VehicleType.fromJsonFile(Map<String, dynamic> json) {
    return VehicleType(
      id: json['ID'],
      vehicleType: json['VehicleType'],
    );
  }

  @override
  String toString() => 'VehicleType(id: $id, vehicleType: $vehicleType)';
}

class VehicleTypeDao {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  insertVehicleType(String? json) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('vehicleType', json!);
  }

  Future<List<VehicleType>> getVehicleTypeList() async {
    final SharedPreferences prefs = await _prefs;
    List<VehicleType> listResult = [];

    var json = prefs.getString('vehicleType');
    final jsonResult = jsonDecode(json!);

    var listRes = jsonResult['vehicleType'] as List;

    for (int i = 0; i < listRes.length; i++) {
      Map<String, dynamic> res = listRes[i];
      VehicleType formResponse = VehicleType.fromJsonFile(res);
      listResult.add(formResponse);
    }
    return listResult;
  }

  Future<List<String>> getVehicleTypeLabelList() async {
    final SharedPreferences prefs = await _prefs;
    List<String> listResult = [];
    var json = prefs.getString('vehicleType');

    final jsonResult = jsonDecode(json!);
    var listVehicleType = jsonResult['vehicleType'] as List;

    for (int i = 0; i < listVehicleType.length; i++) {
      Map<String, dynamic> res = listVehicleType[i];
      VehicleType formResponse = VehicleType.fromJsonFile(res);
      listResult.add(formResponse.vehicleType ?? '');
    }
    return listResult;
  }

  Future<String> getVehicleTypeLabelById(int id) async {
    final SharedPreferences prefs = await _prefs;

    var json = prefs.getString('vehicleType');

    final jsonResult = jsonDecode(json!);
    var listPersonal = jsonResult['vehicleType'] as List;

    for (int i = 0; i < listPersonal.length; i++) {
      Map<String, dynamic> res = listPersonal[i];
      VehicleType formResponse = VehicleType.fromJsonFile(res);
      if ('${formResponse.id}' == '$id') {
        return formResponse.vehicleType ?? '';
      }
    }
    return '';
  }
}
