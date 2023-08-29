// ignore_for_file: file_names
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class VehicleColor {
  int? id;
  String? vehicleColor;

  VehicleColor({this.id, this.vehicleColor});

  factory VehicleColor.fromJson(Map<String, dynamic> json) {
    return VehicleColor(
      id: json['ID'],
      vehicleColor: json['VehicleColor'],
    );
  }

  factory VehicleColor.fromJsonFile(Map<String, dynamic> json) {
    return VehicleColor(
      id: json['ID'],
      vehicleColor: json['VehicleColor'],
    );
  }

  @override
  String toString() => 'VehicleColor(id: $id, vehicleColor: $vehicleColor)';
}

class VehicleColorDao {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  insertVehicleColor(String? json) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('vehicleColor', json!);
  }

  Future<List<VehicleColor>> getVehicleColor() async {
    final SharedPreferences prefs = await _prefs;
    List<VehicleColor> listResult = [];

    var json = prefs.getString('vehicleColor');
    final jsonResult = jsonDecode(json!);

    var listRes = jsonResult['vehicleColor'] as List;

    for (int i = 0; i < listRes.length; i++) {
      Map<String, dynamic> res = listRes[i];
      VehicleColor formResponse = VehicleColor.fromJsonFile(res);
      listResult.add(formResponse);
    }
    return listResult;
  }

  Future<List<String>> getVehicleColorLabelList() async {
    final SharedPreferences prefs = await _prefs;
    List<String> listResult = [];
    var json = prefs.getString('vehicleSide');

    final jsonResult = jsonDecode(json!);
    var listVehicleSide = jsonResult['vehicleSide'] as List;

    for (int i = 0; i < listVehicleSide.length; i++) {
      Map<String, dynamic> res = listVehicleSide[i];
      VehicleColor formResponse = VehicleColor.fromJsonFile(res);
      listResult.add(formResponse.vehicleColor ?? '');
    }
    return listResult;
  }

  Future<String> getVehicleColorLabelById(int id) async {
    final SharedPreferences prefs = await _prefs;

    var json = prefs.getString('vehicleColor');

    final jsonResult = jsonDecode(json!);
    var listPersonal = jsonResult['vehicleColor'] as List;

    for (int i = 0; i < listPersonal.length; i++) {
      Map<String, dynamic> res = listPersonal[i];
      VehicleColor formResponse = VehicleColor.fromJsonFile(res);
      if ('${formResponse.id}' == '$id') {
        return formResponse.vehicleColor ?? '';
      }
    }
    return '';
  }
}
