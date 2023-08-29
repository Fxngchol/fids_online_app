import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/color.dart';
import '../../../models/Province.dart';
import '../../../models/case_vehicle/CaseVehicle.dart';
import '../../../models/case_vehicle/CaseVehicleDao.dart';
import '../../../models/case_vehicle/VehicleBrand.dart';
import '../../../models/case_vehicle/VehicleColor.dart';
import '../../../models/case_vehicle/VehicleType.dart';
import '../../../widget/app_bar_widget.dart';

class SelectVehicle extends StatefulWidget {
  final int? caseID;
  final String? title;
  const SelectVehicle({super.key, this.caseID, this.title});
  @override
  SelectVehicleState createState() => SelectVehicleState();
}

class SelectVehicleState extends State<SelectVehicle> {
  bool isPhone = Device.get().isPhone;
  List<CaseVehicle> data = [];
  List<CaseVehicle> masterData = [];
  List<CaseVehicle> caseVehicles = [];
  List<String> caseVehicleString = [];
  List<VehicleBrand> vehicleBrands = [];
  List<VehicleType> vehicleTypes = [];
  List<VehicleColor> vehicleColors = [];
  List<Province> provinces = [];

  @override
  void initState() {
    asyncCall();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBarWidget(
        title: widget.title,
        actions: [
          Container(
            width: MediaQuery.of(context).size.width * 0.1,
          )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/bgNew.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Container(
            margin: isPhone
                ? const EdgeInsets.all(32)
                : const EdgeInsets.only(
                    left: 32, right: 32, top: 32, bottom: 32),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, i) {
                        String? plate = caseVehicles[i]
                                    .isVehicleRegistrationPlate ==
                                '1'
                            ? 'หมายเลขทะเบียน ${caseVehicles[i].vehicleRegistrationPlateNo1} ${getProvinceLabal(caseVehicles[i].provinceId)}'
                            : 'ไม่ติดแผ่นป้ายทะเบียน';

                        String? otherPlate =
                            'แผ่นป้ายทะเบียนหมายเลขส่วนพ่วง ${caseVehicles[i].vehicleRegistrationPlateNo2} ${getProvinceLabal(caseVehicles[i].provinceOtherId)}';
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 0, right: 16, top: 0, bottom: 16),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: whiteOpacity,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 24, right: 24, bottom: 12, top: 12),
                              child: TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(data[i]);
                                },
                                style: OutlinedButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                ),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                            '${i + 1}. ${caseVehicles[i].vehicleTypeId == '0' ? '${caseVehicles[i].vehicleTypeOther}' : getVehicleTypeLabal(caseVehicles[i].vehicleTypeId)} - ${caseVehicles[i].vehicleBrandId == '0' ? '${caseVehicles[i].vehicleBrandOther}' : getVehicleBrandLabal(caseVehicles[i].vehicleBrandId)} - ${getVehicleColorLabal(caseVehicles[i].colorId1)} ${caseVehicles[i].colorId2 != '' ? ',${getVehicleColorLabal(caseVehicles[i].colorId2)!}' : ''} $plate ${caseVehicles[i].vehicleRegistrationPlateNo2 == null || caseVehicles[i].vehicleRegistrationPlateNo2 == '' ? '' : ',$otherPlate'}',
                                            textAlign: TextAlign.start,
                                            style: GoogleFonts.prompt(
                                              textStyle: TextStyle(
                                                color: textColor,
                                                letterSpacing: 0,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.02,
                                              ),
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void asyncCall() async {
    vehicleBrands = await VehicleBrandDao().getVehicleBrand();
    vehicleTypes = await VehicleTypeDao().getVehicleTypeList();
    vehicleColors = await VehicleColorDao().getVehicleColor();
    provinces = await ProvinceDao().getProvince();
    caseVehicles = await CaseVehicleDao().getCaseVehicle(widget.caseID ?? -1);
    setState(() {
      masterData = caseVehicles;
      data = List<CaseVehicle>.from(masterData);
    });
  }

  String? getVehicleTypeLabal(String? id) {
    for (int i = 0; i < vehicleTypes.length; i++) {
      if ('$id' == '${vehicleTypes[i].id}') {
        return vehicleTypes[i].vehicleType;
      }
    }
    return '';
  }

  String? getVehicleBrandLabal(String? id) {
    for (int i = 0; i < vehicleBrands.length; i++) {
      if ('$id' == '${vehicleBrands[i].id}') {
        return '${vehicleBrands[i].brandTH?.trim()} (${vehicleBrands[i].brandEN?.trim()})';
      }
    }
    return '';
  }

  String? getVehicleColorLabal(String? id) {
    for (int i = 0; i < vehicleColors.length; i++) {
      if ('$id' == '${vehicleColors[i].id}') {
        return '${vehicleColors[i].vehicleColor}';
      }
    }
    return '';
  }

  String? getProvinceLabal(String? id) {
    for (int i = 0; i < provinces.length; i++) {
      if ('$id' == '${provinces[i].id}') {
        return '${provinces[i].province}';
      }
    }
    return '';
  }
}
