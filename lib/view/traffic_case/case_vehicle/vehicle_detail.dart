import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/color.dart';
import '../../../models/CaseCategory.dart';
import '../../../models/FidsCrimeScene.dart';
import '../../../models/Province.dart';
import '../../../models/case_vehicle/CaseVehicle.dart';
import '../../../models/case_vehicle/CaseVehicleDao.dart';
import '../../../models/case_vehicle/VehicleBrand.dart';
import '../../../models/case_vehicle/VehicleColor.dart';
import '../../../models/case_vehicle/VehicleType.dart';
import '../../../widget/app_bar_widget.dart';
import 'add_vehicle.dart';

class VehicleDetail extends StatefulWidget {
  final int? caseID, vehicleId;
  final String? caseNo;

  const VehicleDetail({super.key, this.vehicleId, this.caseID, this.caseNo});

  @override
  State<VehicleDetail> createState() => VehicleDetailState();
}

class VehicleDetailState extends State<VehicleDetail> {
  String? caseName;
  bool isPhone = Device.get().isPhone;
  bool isLoading = true;
  CaseVehicle caseVehicle = CaseVehicle();
  List<VehicleBrand> vehicleBrands = [];
  List<VehicleType> vehicleTypes = [];
  List<VehicleColor> vehicleColors = [];
  List<Province> provinces = [];
  int isRegisVal = -1;

  @override
  void initState() {
    super.initState();
    asyncMethod();
  }

  asyncMethod() async {
    isLoading = true;
    asyncCall1();
    if (kDebugMode) {
      print('caseID: ${widget.caseID}, caseNo: ${widget.caseNo}');
    }
  }

  void asyncCall1() async {
    var fidsCrimescene =
        await FidsCrimeSceneDao().getFidsCrimeSceneById(widget.caseID ?? -1);
    var caseVehicle =
        await CaseVehicleDao().getCaseVehicleById(widget.vehicleId.toString());
    var vehicleBrands = await VehicleBrandDao().getVehicleBrand();
    var vehicleTypeList = await VehicleTypeDao().getVehicleTypeList();
    var vehicleColorList = await VehicleColorDao().getVehicleColor();
    var provinceList = await ProvinceDao().getProvince();

    await CaseCategoryDAO()
        .getCaseCategoryLabelByid(fidsCrimescene?.caseCategoryID ?? -1)
        .then((value) => caseName = value);
    setState(() {
      this.caseVehicle = caseVehicle ?? CaseVehicle();
      this.vehicleBrands = vehicleBrands;
      vehicleTypes = vehicleTypeList;
      vehicleColors = vehicleColorList;
      provinces = provinceList;
      isRegisVal = int.parse(caseVehicle?.isVehicleRegistrationPlate ?? '');
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBarWidget(
          title: 'รายละเอีดยรถของกลาง',
          leading: IconButton(
              icon: isIOS
                  ? const Icon(Icons.arrow_back_ios)
                  : const Icon(Icons.arrow_back),
              onPressed: () async {
                Navigator.of(context).pop(true);
              }),
          actions: [
            TextButton(
                child: Icon(
                  Icons.edit,
                  size: MediaQuery.of(context).size.height * 0.03,
                  color: Colors.white,
                ),
                onPressed: () async {
                  var result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddVehiclePage(
                                vehicleId: widget.vehicleId ?? -1,
                                isEdit: true,
                                caseNo: widget.caseNo,
                                caseID: widget.caseID ?? -1,
                              )));
                  if (result != null) {
                    asyncMethod();
                  }
                }),
          ],
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : _body());
  }

  Widget _body() {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
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
              : const EdgeInsets.only(left: 32, right: 32, top: 32, bottom: 32),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header('ประเภทรถ'),
                caseVehicle.vehicleTypeId == '0'
                    ? _detailView(caseVehicle.vehicleTypeOther)
                    : _detailView(
                        getVehicleTypeLabal(caseVehicle.vehicleTypeId)),
                _spacer(context),
                _header('ยี่ห้อรถ'),
                caseVehicle.vehicleBrandId == '0'
                    ? _detailView(caseVehicle.vehicleBrandOther)
                    : _detailView(
                        getVehicleBrandLabal(caseVehicle.vehicleBrandId)),
                _spacer(context),
                _header('รุ่น'),
                _detailView(caseVehicle.vehicleModel),
                _spacer(context),
                // caseVehicle.vehicleModel == ''
                //     ? Container()
                //     : Column(
                //         children: [
                //           _detailView(caseVehicle.vehicleModel),
                //           _spacer(context),
                //         ],
                //       ),
                _header('สีรถ'),
                caseVehicle.colorId1 == '0'
                    ? _detailView(caseVehicle.colorOther)
                    : _detailView(
                        '${getVehicleColorLabal(caseVehicle.colorId1)} ${getVehicleColorLabal(caseVehicle.colorId2)}'),
                _spacer(context),
                _header('สภาพรถ'),
                _detailView(caseVehicle.detail),
                _spacer(context),
                _isRegistrationPlateView(),
                _spacer(context),
                isRegisVal == 1
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _spacer(context),
                          _header('แผ่นป้ายทะเบียนหมายเลข'),
                          _detailView(
                              '${caseVehicle.vehicleRegistrationPlateNo1} ${getProvinceLabal(caseVehicle.provinceId)}'),
                          _spacer(context),
                        ],
                      )
                    : Container(),
                _spacer(context),
                _header('แผ่นป้ายทะเบียนหมายเลขส่วนพ่วง'),
                _detailView(
                    '${caseVehicle.vehicleRegistrationPlateNo2} ${getProvinceLabal(caseVehicle.provinceOtherId)}'),
                _spacer(context),
                _header('หมายเลขตัวถัง'),
                _detailView(caseVehicle.chassisNumber ?? ''),
                _spacer(context),
                _header('หมายเลขเครื่อง'),
                _detailView(caseVehicle.engineNumber ?? ''),
                _spacer(context),
                _header('อื่นๆ'),
                _detailView(caseVehicle.vehicleOther ?? ''),
                _spacer(context),
              ],
            ),
          ),
        )));
  }

  Widget _header(String? text) {
    return Text(
      '$text',
      textAlign: TextAlign.left,
      style: GoogleFonts.prompt(
        textStyle: TextStyle(
          color: Colors.white,
          letterSpacing: .5,
          fontSize: MediaQuery.of(context).size.height * 0.025,
        ),
      ),
    );
  }

  Widget _spacer(context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.015,
    );
  }

  // ignore: unused_element
  String? _cleanText(String? text) {
    try {
      if (text == null || text == '' || text == 'null' || text == '-1') {
        return '';
      }
      return text;
    } catch (ex) {
      return '';
    }
  }

  _isRegistrationPlateView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Transform.scale(
              scale: 1.2,
              child: Radio(
                  value: 2,
                  activeColor: pinkButton,
                  groupValue: isRegisVal,
                  onChanged: (value) {}),
            ),
            Text(
              'ไม่ติดแผ่นป้ายทะเบียน',
              textAlign: TextAlign.center,
              style: GoogleFonts.prompt(
                textStyle: TextStyle(
                  color: Colors.white,
                  letterSpacing: .5,
                  fontSize: MediaQuery.of(context).size.height * 0.025,
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Transform.scale(
              scale: 1.2,
              child: Radio(
                value: 1,
                activeColor: pinkButton,
                groupValue: isRegisVal,
                onChanged: (value) {},
              ),
            ),
            Text(
              'ติดแผ่นป้ายทะเบียน',
              textAlign: TextAlign.center,
              style: GoogleFonts.prompt(
                textStyle: TextStyle(
                  color: Colors.white,
                  letterSpacing: .5,
                  fontSize: MediaQuery.of(context).size.height * 0.025,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _detailView(String? text) {
    return Container(
      decoration: BoxDecoration(
          color: whiteOpacity, borderRadius: BorderRadius.circular(8)),
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: isPhone
            ? const EdgeInsets.only(left: 24, right: 24, top: 10, bottom: 10)
            : const EdgeInsets.only(left: 32, right: 32, top: 20, bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$text',
                    textAlign: TextAlign.left,
                    style: GoogleFonts.prompt(
                      textStyle: TextStyle(
                        color: textColor,
                        letterSpacing: .5,
                        fontSize: MediaQuery.of(context).size.height * 0.025,
                      ),
                    ),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
        return '${vehicleBrands[i].brandTH} (${vehicleBrands[i].brandEN})';
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
        return '(${provinces[i].province})';
      }
    }
    return '';
  }
}
