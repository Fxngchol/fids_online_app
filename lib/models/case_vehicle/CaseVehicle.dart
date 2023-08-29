// ignore_for_file: file_names

class CaseVehicle {
  String? id;
  String? vehicleTypeId;
  String? vehicleTypeOther;
  String? vehicleBrandId;
  String? vehicleBrandOther;
  String? vehicleModel;
  String? colorId1;
  String? colorId2;
  String? colorOther;
  String? detail;
  String? isVehicleRegistrationPlate;
  String? vehicleRegistrationPlateNo1;
  String? provinceId;
  String? vehicleRegistrationPlateNo2;
  String? vehicleOther;
  String? vehicleMap;
  String? chassisNumber;
  String? engineNumber;
  String? provinceOtherId;
  CaseVehicle(
      {this.id,
      this.vehicleTypeId,
      this.vehicleTypeOther,
      this.vehicleBrandId,
      this.vehicleBrandOther,
      this.vehicleModel,
      this.colorId1,
      this.colorId2,
      this.colorOther,
      this.detail,
      this.isVehicleRegistrationPlate,
      this.vehicleRegistrationPlateNo1,
      this.provinceId,
      this.vehicleRegistrationPlateNo2,
      this.vehicleOther,
      this.vehicleMap,
      this.chassisNumber,
      this.engineNumber,
      this.provinceOtherId});

  CaseVehicle.fromJson(Map<String, dynamic> json) {
    id = '${json['ID']}';
    vehicleTypeId = json['VehicleTypeID'];
    vehicleTypeOther = json['VehicleTypeOther'];
    vehicleBrandId = json['VehicleBrandID'];
    vehicleBrandOther = json['VehicleBrandOther'];
    vehicleModel = json['VehicleModel'];
    colorId1 = json['ColorID1'];
    colorId2 = json['ColorID2'];
    colorOther = json['ColorOther'];
    detail = json['Detail'];
    isVehicleRegistrationPlate = json['IsVehicleRegistrationPlate'];
    vehicleRegistrationPlateNo1 = json['VehicleRegistrationPlateNo1'];
    provinceId = json['ProvinceID'];
    vehicleRegistrationPlateNo2 = json['VehicleRegistrationPlateNo2'];
    vehicleOther = json['VehicleOther'];
    vehicleMap = json['VehicleMap'];
    chassisNumber = json['ChassisNumber'];
    engineNumber = json['EngineNumber'];
    provinceOtherId = json['ProvinceOtherID'];
  }

  Map toJson() => {
        'id': id == '-2' || id == null ? '' : '$id',
        'vehicle_type_id':
            vehicleTypeId == null || vehicleTypeId == '-1' ? '' : vehicleTypeId,
        'vehicle_type_other': vehicleTypeOther ?? '',
        'vehicle_brand_id': vehicleBrandId == null || vehicleBrandId == '-1'
            ? ''
            : vehicleBrandId,
        'vehicle_brand_other': vehicleBrandOther ?? '',
        'vehicle_model': vehicleModel ?? '',
        'color_id1': colorId1 == null || colorId1 == '-1' ? '' : colorId1,
        'color_id2': colorId2 == null || colorId2 == '-1' ? '' : colorId2,
        'color_other': colorOther ?? '',
        'detail': detail ?? '',
        'is_vehicle_registration_plate': isVehicleRegistrationPlate ?? '2',
        'vehicle_registration_plate_no1': vehicleRegistrationPlateNo1 ?? '',
        'province_id':
            provinceId == null || provinceId == '-1' ? '' : provinceId ?? '',
        'vehicle_registration_plate_no2': vehicleRegistrationPlateNo2 ?? '',
        'vehicle_other': vehicleOther ?? '',
        'vehicle_map': vehicleMap ?? '',
        'chassis_number': vehicleOther ?? '',
        'engin_number': vehicleMap ?? '',
        'province_other_id': provinceOtherId == null || provinceOtherId == '-1'
            ? ''
            : provinceOtherId ?? '',
      };

  @override
  String toString() {
    return 'CaseVehicle(id: $id, vehicleTypeId: $vehicleTypeId, vehicleTypeOther: $vehicleTypeOther, vehicleBrandId: $vehicleBrandId, vehicleBrandOther: $vehicleBrandOther, vehicleModel: $vehicleModel, colorId1: $colorId1, colorId2: $colorId2, colorOther: $colorOther, detail: $detail, isVehicleRegistrationPlate: $isVehicleRegistrationPlate, vehicleRegistrationPlateNo1: $vehicleRegistrationPlateNo1, provinceId: $provinceId, vehicleRegistrationPlateNo2: $vehicleRegistrationPlateNo2, provinceOtherId: $provinceOtherId, vehicleOther: $vehicleOther, vehicleMap: $vehicleMap, chassisNumber: $chassisNumber, engineNumber: $engineNumber)';
  }
}
