import 'package:fids_online_app/view/traffic_case/case_vehicle/select_vehicle_brand.dart';
import 'package:fids_online_app/view/traffic_case/case_vehicle/select_vehicle_color.dart';
import 'package:fids_online_app/view/traffic_case/case_vehicle/select_vehicle_type.dart';
import 'package:flutter/foundation.dart';
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
import '../../../widget/app_button.dart';
import '../../../widget/text_field_widget.dart';
import '../../life_case/location_case/select_province.dart';

class AddVehiclePage extends StatefulWidget {
  final int? caseID, vehicleId;
  final String? caseNo;
  final bool isEdit;

  const AddVehiclePage({
    super.key,
    this.vehicleId,
    this.caseID,
    this.caseNo,
    this.isEdit = false,
  });

  @override
  State<AddVehiclePage> createState() => AddVehiclePageState();
}

class AddVehiclePageState extends State<AddVehiclePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isPhone = Device.get().isPhone;
  bool isLoading = true;

  final _vehicleTypeCntl = TextEditingController();
  final _vehicleTypeOtherCntl = TextEditingController();
  final _vehicleBrandCntl = TextEditingController();
  final _vehicleBrandOtherCntl = TextEditingController();
  final _vehicleModelCntl = TextEditingController();
  final _color1Cntl = TextEditingController();
  final _color2Cntl = TextEditingController();
  final _colorOtherCntl = TextEditingController();
  final _detailCntl = TextEditingController();
  final _vehicleRegistrationPlateNo1Cntl = TextEditingController();
  final _provinceCntl = TextEditingController();
  final _provinceOtherCntl = TextEditingController();
  final _vehicleRegistrationPlateNo2Cntl = TextEditingController();
  final _vehicleOtherCntl = TextEditingController();
  final _chassisNumberCntl = TextEditingController();
  final _engineNumberCntl = TextEditingController();

  int vehicleTypeId = -1;
  int vehicleBrandId = -1;
  int colorId1 = -1;
  int colorId2 = -1;
  int provinceId = -1;
  int provinceOtherId = -1;

  int isRegisVal = 2;
  CaseVehicle caseVehicle = CaseVehicle();
  List<VehicleBrand> vehicleBrands = [];
  List<VehicleType> vehicleTypes = [];
  List<VehicleColor> vehicleColors = [];
  List<Province> provinces = [];

  @override
  void initState() {
    super.initState();
    setupData();
  }

  setupData() async {
    if (widget.isEdit) {
      var vehicleBrands = await VehicleBrandDao().getVehicleBrand();
      var vehicleTypeList = await VehicleTypeDao().getVehicleTypeList();
      var vehicleColorList = await VehicleColorDao().getVehicleColor();
      var provinceList = await ProvinceDao().getProvince();
      setState(() {
        this.vehicleBrands = vehicleBrands;
        vehicleTypes = vehicleTypeList;
        vehicleColors = vehicleColorList;
        provinces = provinceList;
      });
      await CaseVehicleDao()
          .getCaseVehicleById(widget.vehicleId.toString())
          .then((value) {
        setState(() {
          caseVehicle = value ?? CaseVehicle();
          isRegisVal = caseVehicle.isVehicleRegistrationPlate != null
              ? int.parse(caseVehicle.isVehicleRegistrationPlate ?? '')
              : 2;
          vehicleTypeId = caseVehicle.vehicleTypeId != null
              ? int.parse(caseVehicle.vehicleTypeId ?? '')
              : -1;
          vehicleBrandId = caseVehicle.vehicleBrandId != null
              ? int.parse(caseVehicle.vehicleBrandId ?? '')
              : -1;
          colorId1 = int.parse(caseVehicle.colorId1 ?? '');
          colorId2 = caseVehicle.colorId2 != '-1'
              ? int.parse(caseVehicle.colorId2 ?? '')
              : -1;
          provinceId = caseVehicle.provinceId != '-1'
              ? int.parse(caseVehicle.provinceId ?? '')
              : -1;

          if (kDebugMode) {
            print(colorId2);
            print(vehicleTypeId);
            print(vehicleBrandId);
            print(colorId1);
            print(colorId2);
          }
          /////////
          _vehicleTypeCntl.text =
              getVehicleTypeLabal(caseVehicle.vehicleTypeId) ?? '';
          _vehicleTypeOtherCntl.text = (caseVehicle.vehicleTypeId == '0'
                  ? caseVehicle.vehicleTypeOther
                  : '') ??
              '';
          _vehicleBrandCntl.text = (caseVehicle.vehicleBrandId == '0'
                  ? 'อื่นๆ'
                  : getVehicleBrandLabal(caseVehicle.vehicleBrandId)) ??
              '';

          _vehicleBrandOtherCntl.text = (caseVehicle.vehicleBrandId == '0'
                  ? caseVehicle.vehicleBrandOther
                  : '') ??
              '';
          _vehicleModelCntl.text = caseVehicle.vehicleModel ?? '';
          _color1Cntl.text = getVehicleColorLabal(caseVehicle.colorId1) ?? '';
          _color2Cntl.text = getVehicleColorLabal(caseVehicle.colorId2) ?? '';
          _colorOtherCntl.text =
              (caseVehicle.colorId1 == '0' ? caseVehicle.colorOther : '') ?? '';
          _detailCntl.text = caseVehicle.detail ?? '';
          _vehicleRegistrationPlateNo1Cntl.text =
              caseVehicle.vehicleRegistrationPlateNo1 ?? '';
          _provinceCntl.text = getProvinceLabal(caseVehicle.provinceId) ?? '';
          _provinceOtherCntl.text =
              getProvinceLabal(caseVehicle.provinceOtherId) ?? '';
          _vehicleRegistrationPlateNo2Cntl.text =
              caseVehicle.vehicleRegistrationPlateNo2 ?? '';
          _vehicleOtherCntl.text = caseVehicle.vehicleOther ?? '';
          _chassisNumberCntl.text = caseVehicle.chassisNumber ?? '';
          _engineNumberCntl.text = caseVehicle.engineNumber ?? '';
          isLoading = false;
        });
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        key: _scaffoldKey,
        appBar: AppBarWidget(
          title: widget.isEdit ? 'แก้ไขรถของกลาง' : 'เพิ่มรถของกลาง',
          actions: [
            Container(
              width: MediaQuery.of(context).size.width * 0.1,
            )
          ],
        ),
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/bgNew.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : SafeArea(
                    child: Container(
                        margin: isPhone
                            ? const EdgeInsets.all(32)
                            : const EdgeInsets.only(
                                left: 32, right: 32, top: 32, bottom: 32),
                        child: SingleChildScrollView(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _header('ประเภทรถ*'),
                                _selectVehicleTypeView(),
                                vehicleTypeId == 0
                                    ? _otherView(
                                        'ประเภทรถอื่นๆ',
                                        'กรอกประเภทรถอื่นๆ',
                                        _vehicleTypeOtherCntl)
                                    : Container(),
                                _spacer(context),
                                _header('ยี่ห้อรถ*'),
                                _selectVehicleBrandView(),
                                vehicleBrandId == 0
                                    ? _otherView(
                                        'ยี่ห้อรถอื่นๆ',
                                        'กรอกยี่ห้อรถอื่นๆ',
                                        _vehicleBrandOtherCntl)
                                    : Container(),
                                _spacer(context),
                                _header('รุ่น'),
                                InputField(
                                    controller: _vehicleModelCntl,
                                    hint: 'กรอกรุ่นรถ',
                                    onChanged: (value) {}),
                                _spacer(context),
                                _header('สีรถ*'),
                                _selectColorView(
                                  'เลือกสีรถหลัก (บังคับเลือก)',
                                  _color1Cntl,
                                  () async {
                                    var result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const SelectVehicleColor()));
                                    if (kDebugMode) {
                                      print('${result.vehicleColor}');
                                    }
                                    if (result != null) {
                                      setState(() {
                                        _color1Cntl.text = result.vehicleColor;
                                        colorId1 = result.id;
                                        if (result.id != 0) {
                                          _colorOtherCntl.text = '';
                                        }
                                      });
                                    }
                                  },
                                ),
                                _spacer(context),
                                _selectColorView(
                                  'เลือกสีรถรอง (เลือกหรือไม่เลือกก็ได้)',
                                  _color2Cntl,
                                  () async {
                                    var result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const SelectVehicleColor()));
                                    if (kDebugMode) {
                                      print('${result.vehicleColor}');
                                    }
                                    if (result != null) {
                                      setState(() {
                                        _color2Cntl.text = result.vehicleColor;
                                        colorId2 = result.id;
                                      });
                                    }
                                  },
                                ),
                                colorId1 == 0
                                    ? _otherView('สีรถอื่นๆ', 'กรอกสีรถอื่นๆ',
                                        _colorOtherCntl)
                                    : Container(),
                                _spacer(context),
                                _header('สภาพรถ'),
                                InputField(
                                    controller: _detailCntl,
                                    hint: 'สภาพรถ',
                                    onChanged: (value) {}),
                                _spacer(context),
                                _isRegistrationPlateView(),
                                isRegisVal == 1
                                    ? _otherView(
                                        'แผ่นป้ายทะเบียนหมายเลข*',
                                        'กรอกแผ่นป้ายทะเบียนหมายเลข',
                                        _vehicleRegistrationPlateNo1Cntl)
                                    : Container(),
                                isRegisVal == 1
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                            _spacer(context),
                                            _header('จังหวัด*'),
                                            _selectProvinceView()
                                          ])
                                    : Container(),
                                _otherView(
                                    'แผ่นป้ายทะเบียนหมายเลขส่วนพ่วง',
                                    'กรอกแผ่นป้ายทะเบียนหมายเลขส่วนพ่วง',
                                    _vehicleRegistrationPlateNo2Cntl),
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _spacer(context),
                                      _header('จังหวัด'),
                                      _selectProvinceOtherView()
                                    ]),
                                _spacer(context),
                                _header('หมายเลขตัวถัง'),
                                InputField(
                                    controller: _chassisNumberCntl,
                                    hint: 'กรอกหมายเลขตัวถัง',
                                    onChanged: (value) {}),
                                _spacer(context),
                                _header('หมายเลขเครื่อง'),
                                InputField(
                                    controller: _engineNumberCntl,
                                    hint: 'กรอกหมายเลขเครื่อง',
                                    onChanged: (value) {}),
                                _spacer(context),
                                _header('อื่นๆ'),
                                InputField(
                                    controller: _vehicleOtherCntl,
                                    hint: 'อื่นๆ',
                                    onChanged: (value) {}),
                                _spacer(context),
                                saveButton()
                              ]),
                        )))));
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
                  onChanged: (value) {
                    setState(() {
                      isRegisVal = value ?? -1;
                      if (kDebugMode) {
                        print(isRegisVal);
                      }
                      provinceId = -1;
                      _provinceCntl.text = '';
                      _vehicleRegistrationPlateNo1Cntl.text = '';
                    });
                  }),
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
                onChanged: (value) {
                  setState(() {
                    isRegisVal = value ?? -1;
                    if (kDebugMode) {
                      print(isRegisVal);
                    }
                  });
                },
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

  _otherView(String? header, String? hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _spacer(context),
        _header('$header'),
        InputField(
            controller: controller,
            hint: '$hint',
            onChanged: (value) {
              if (kDebugMode) {
                print(controller.text);
              }
            }),
      ],
    );
  }

  _selectVehicleTypeView() {
    return Column(
      children: [
        TextButton(
            onPressed: () async {
              var result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SelectVehicleType()));
              if (kDebugMode) {
                print('${result.vehicleType}');
              }
              if (result != null) {
                setState(() {
                  _vehicleTypeCntl.text = result.vehicleType;
                  vehicleTypeId = result.id;
                  if (result.id != 0) {
                    _vehicleOtherCntl.text = '';
                  }
                });
              }
            },
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.zero,
            ),
            child: _textfieldWithAction('กรุณาประเภทรถ', _vehicleTypeCntl)),
      ],
    );
  }

  _selectColorView(
      String? title, TextEditingController cntl, Function() onPressed) {
    return Column(
      children: [
        TextButton(
            onPressed: onPressed,
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.zero,
            ),
            child: _textfieldWithAction('$title', cntl)),
      ],
    );
  }

  _selectVehicleBrandView() {
    return Column(
      children: [
        TextButton(
          onPressed: () async {
            var result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const SelectVehicleBrand()));
            if (kDebugMode) {
              print('${result.brandTH}');
            }
            if (result != null) {
              setState(() {
                _vehicleBrandCntl.text = result.id == 0
                    ? 'อื่นๆ'
                    : '${result.brandTH} (${result.brandEN})';
                vehicleBrandId = result.id;
                if (result.id != 0) {
                  _vehicleBrandOtherCntl.text = '';
                }
                if (kDebugMode) {
                  print(_vehicleBrandCntl.text);
                }
              });
            }
          },
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.zero,
          ),
          child: _textfieldWithAction('กรุณาเลือกยี่ห้อรถ', _vehicleBrandCntl),
        ),
      ],
    );
  }

  _selectProvinceView() {
    return TextButton(
        onPressed: () async {
          var result = await Navigator.push(context,
              MaterialPageRoute(builder: (context) => const SelectProvince()));
          if (kDebugMode) {
            print('${result.province}');
          }
          if (result != null) {
            setState(() {
              _provinceCntl.text = result.province;
              provinceId = result.id;
            });
          }
        },
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
        ),
        child: _textfieldWithAction('กรุณาเลือกจังหวัด', _provinceCntl));
  }

  _selectProvinceOtherView() {
    return TextButton(
        onPressed: () async {
          var result = await Navigator.push(context,
              MaterialPageRoute(builder: (context) => const SelectProvince()));
          if (kDebugMode) {
            print('${result.province}');
          }
          if (result != null) {
            setState(() {
              _provinceOtherCntl.text = result.province;
              provinceOtherId = result.id;
            });
          }
        },
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
        ),
        child: _textfieldWithAction('กรุณาเลือกจังหวัด', _provinceOtherCntl));
  }

  Widget _header(String? text) {
    return Column(
      children: [
        Text(
          '$text',
          textAlign: TextAlign.left,
          style: GoogleFonts.prompt(
            textStyle: TextStyle(
              color: Colors.white,
              letterSpacing: .5,
              fontSize: MediaQuery.of(context).size.height * 0.025,
            ),
          ),
        ),
      ],
    );
  }

  Widget _spacer(context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.015,
    );
  }

  Widget _textfieldWithAction(
      String? hintText, TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: whiteOpacity,
      ),
      child: TextFormField(
        controller: controller,
        enabled: false,
        style: GoogleFonts.prompt(
            textStyle: TextStyle(
          color: textColor,
          letterSpacing: 0.5,
          fontSize: MediaQuery.of(context).size.height * 0.02,
        )),
        decoration: InputDecoration(
          suffixIcon: Icon(Icons.arrow_drop_down_sharp,
              size: MediaQuery.of(context).size.height * 0.05,
              color: textColor),
          contentPadding:
              const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 16),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          hintText: '$hintText',
          hintStyle: GoogleFonts.prompt(
            textStyle: TextStyle(
              color: textColor,
              letterSpacing: 0.5,
              fontSize: MediaQuery.of(context).size.height * 0.02,
            ),
          ),
        ),
      ),
    );
  }

  Widget saveButton() {
    return AppButton(
        color: pinkButton,
        textColor: Colors.white,
        text: 'บันทึก',
        onPressed: () async {
          if (kDebugMode) {
            print('1 ${_vehicleTypeCntl.text}');
            print('2 ${_vehicleTypeOtherCntl.text}');
            print('3 ${_vehicleBrandCntl.text}');
            print('4 ${_vehicleBrandOtherCntl.text}');
            print('5 ${_vehicleModelCntl.text}');
            print('6 ${_color1Cntl.text}');
            print('7 ${_color2Cntl.text}');
            print('8 ${_colorOtherCntl.text}');
            print('9 ${_detailCntl.text}');
            print('10 ${_vehicleRegistrationPlateNo1Cntl.text}');
            print('11 provinceId $provinceId ${_provinceCntl.text}');
            print('12 ${_vehicleRegistrationPlateNo2Cntl.text}');
            print('13 ${_vehicleOtherCntl.text}');
          }

          if (isValidate()) {
            if (widget.isEdit) {
              CaseVehicleDao().updateCaseVehicle(
                  widget.vehicleId ?? -1,
                  vehicleTypeId.toString(),
                  _vehicleTypeOtherCntl.text,
                  vehicleBrandId.toString(),
                  _vehicleBrandOtherCntl.text,
                  _vehicleModelCntl.text,
                  colorId1.toString(),
                  colorId2.toString(),
                  _colorOtherCntl.text,
                  _detailCntl.text,
                  isRegisVal.toString(),
                  _vehicleRegistrationPlateNo1Cntl.text,
                  provinceId.toString(),
                  _vehicleRegistrationPlateNo2Cntl.text,
                  _vehicleOtherCntl.text,
                  _chassisNumberCntl.text,
                  _engineNumberCntl.text,
                  provinceOtherId.toString());
              Navigator.of(context).pop(true);
            } else {
              await CaseVehicleDao()
                  .createCaseVehicle(
                      widget.caseID.toString(),
                      vehicleTypeId.toString(),
                      _vehicleTypeOtherCntl.text,
                      vehicleBrandId.toString(),
                      _vehicleBrandOtherCntl.text,
                      _vehicleModelCntl.text,
                      colorId1.toString(),
                      colorId2.toString(),
                      _colorOtherCntl.text,
                      _detailCntl.text,
                      isRegisVal.toString(),
                      _vehicleRegistrationPlateNo1Cntl.text,
                      provinceId.toString(),
                      _vehicleRegistrationPlateNo2Cntl.text,
                      _vehicleOtherCntl.text,
                      _chassisNumberCntl.text,
                      _engineNumberCntl.text,
                      provinceOtherId.toString())
                  .then((value) => Navigator.of(context).pop(true));
            }
          } else {
            final snackBar = SnackBar(
              content: Text(
                'กรุณากรอกข้อมูลที่มีเครื่องหมายดอกจัน (*) ให้​ครบถ้วน',
                textAlign: TextAlign.center,
                style: GoogleFonts.prompt(
                  textStyle: TextStyle(
                    color: Colors.white,
                    letterSpacing: .5,
                    fontSize: MediaQuery.of(context).size.height * 0.02,
                  ),
                ),
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        });
  }

  bool isValidate() {
    return _vehicleTypeCntl.text != '' &&
        _vehicleBrandCntl.text != '' &&
        colorId1 != -1 &&
        isRegis();
  }

  bool isRegis() {
    return (isRegisVal == 1 && _vehicleRegistrationPlateNo1Cntl.text != '') ||
        isRegisVal == 2;
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
        return '${provinces[i].province}';
      }
    }
    return '';
  }
}
