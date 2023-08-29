// ignore_for_file: file_names
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class VehicleSide {
  int? id;
  String? vehicleSide;

  VehicleSide({this.id, this.vehicleSide});

  factory VehicleSide.fromJson(Map<String, dynamic> json) {
    return VehicleSide(
      id: json['ID'],
      vehicleSide: json['VehicleSide'],
    );
  }

  factory VehicleSide.fromJsonFile(Map<String, dynamic> json) {
    return VehicleSide(
      id: json['ID'],
      vehicleSide: json['VehicleSide'],
    );
  }

  @override
  String toString() => 'VehicleSide(id: $id, VehicleSide: $vehicleSide)';
}

class VehicleSideDao {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  insertVehicleSide(String? json) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('vehicleSide', json!);
  }

  Future<List<VehicleSide>> getVehicleSideList() async {
    final SharedPreferences prefs = await _prefs;
    List<VehicleSide> listResult = [];

    var json = prefs.getString('vehicleSide');
    final jsonResult = jsonDecode(json!);

    var listRes = jsonResult['vehicleSide'] as List;

    for (int i = 0; i < listRes.length; i++) {
      Map<String, dynamic> res = listRes[i];
      VehicleSide formResponse = VehicleSide.fromJsonFile(res);
      listResult.add(formResponse);
    }
    return listResult;
  }

  Future<List<String>> getVehicleSideListLabel() async {
    final SharedPreferences prefs = await _prefs;
    List<String> listResult = [];
    var json = prefs.getString('vehicleSide');

    final jsonResult = jsonDecode(json!);
    var listVehicleSide = jsonResult['vehicleSide'] as List;

    for (int i = 0; i < listVehicleSide.length; i++) {
      Map<String, dynamic> res = listVehicleSide[i];
      VehicleSide formResponse = VehicleSide.fromJsonFile(res);
      listResult.add(formResponse.vehicleSide ?? '');
    }
    return listResult;
  }

  Future<String> getVehicleSideLabelById(String? id) async {
    final SharedPreferences prefs = await _prefs;

    var json = prefs.getString('vehicleSide');

    final jsonResult = jsonDecode(json!);
    var listPersonal = jsonResult['vehicleSide'] as List;

    for (int i = 0; i < listPersonal.length; i++) {
      Map<String, dynamic> res = listPersonal[i];
      VehicleSide formResponse = VehicleSide.fromJsonFile(res);
      if ('${formResponse.id}' == '$id') {
        return formResponse.vehicleSide ?? '';
      }
    }
    return '';
  }
}
