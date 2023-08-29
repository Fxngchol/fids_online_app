import 'package:fids_online_app/view/traffic_case/case_compare/select_vehicle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/color.dart';
import '../../../models/CaseCategory.dart';
import '../../../models/FidsCrimeScene.dart';
import '../../../models/Province.dart';
import '../../../models/case_vehicle/CaseDamaged.dart';
import '../../../models/case_vehicle/CaseVehicle.dart';
import '../../../models/case_vehicle/CaseVehicleCompare.dart';
import '../../../models/case_vehicle/CaseVehicleCompareDetail.dart';
import '../../../models/case_vehicle/CaseVehicleDao.dart';
import '../../../models/case_vehicle/VehicleBrand.dart';
import '../../../models/case_vehicle/VehicleColor.dart';
import '../../../models/case_vehicle/VehicleSide.dart';
import '../../../models/case_vehicle/VehicleType.dart';
import '../../../widget/app_bar_widget.dart';
import '../../../widget/app_button.dart';
import '../../../widget/textfield_modal_bottom_sheet.dart';

class AddComparePage extends StatefulWidget {
  final int? caseID;
  final String? caseNo, vehicleCompareId;
  final bool isEdit;
  final CaseVehicleCompare? caseVehicleCompare;

  const AddComparePage(
      {super.key,
      this.caseID,
      this.caseNo,
      this.isEdit = false,
      this.caseVehicleCompare,
      this.vehicleCompareId});

  @override
  State<AddComparePage> createState() => AddComparePageState();
}

class AddComparePageState extends State<AddComparePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = true;
  bool isPhone = Device.get().isPhone;
  final TextEditingController _vehicle1Controller = TextEditingController();
  final TextEditingController _vehicle2Controller = TextEditingController();
  int vehicle1Index = 0, vehicle2Index = 0;
  String vehicle1ID = '', vehicle2ID = '';
  List<CaseVehicle>? caseVehicles = [];
  List<VehicleBrand>? vehicleBrands = [];
  List<VehicleType>? vehicleTypes = [];
  List<VehicleColor>? vehicleColors = [];
  List<Province>? provinces = [];
  List<String> caseVehicleString = [];
  List<CaseDamaged>? caseDamaged1 = [];
  List<CaseDamaged>? caseDamaged2 = [];
  List<CaseVehicleCompareDetail>? caseCompareDetail = [];
  List<VehicleSide>? sides = [];
  String caseName = '';
  List<bool> _isChecked1 = [];
  List<bool> _isChecked2 = [];
  CaseVehicle caseVehicle1 = CaseVehicle();
  CaseVehicle caseVehicle2 = CaseVehicle();

  @override
  void initState() {
    asyncCall();
    super.initState();
  }

  asyncCall() async {
    await FidsCrimeSceneDao()
        .getFidsCrimeSceneById(widget.caseID ?? -1)
        .then((value) async {
      await CaseCategoryDAO()
          .getCaseCategoryLabelByid(value?.caseCategoryID ?? -1)
          .then((value) => caseName = value);
    });

    caseVehicles = await CaseVehicleDao().getCaseVehicle(widget.caseID ?? -1);
    vehicleBrands = await VehicleBrandDao().getVehicleBrand();
    vehicleTypes = await VehicleTypeDao().getVehicleTypeList();
    vehicleColors = await VehicleColorDao().getVehicleColor();
    provinces = await ProvinceDao().getProvince();
    sides = await VehicleSideDao().getVehicleSideList();

    setState(() {
      isLoading = false;
    });

    asyncCallString();
    if (kDebugMode) {
      print('widget.caseVehicleCompare: ${widget.caseVehicleCompare}');
    }
    if (widget.isEdit) {
      setState(() {
        isLoading = true;
      });
      vehicle1ID = widget.caseVehicleCompare?.caseVehicleId1 ?? '';
      vehicle2ID = widget.caseVehicleCompare?.caseVehicleId2 ?? '';
      caseVehicle1 = (await CaseVehicleDao().getCaseVehicleById(vehicle1ID)) ??
          CaseVehicle();
      caseVehicle2 = (await CaseVehicleDao().getCaseVehicleById(vehicle2ID)) ??
          CaseVehicle();
      String plate1 = caseVehicle1.isVehicleRegistrationPlate == '1'
          ? 'แผ่นป้ายทะเบียนหมายเลข ${caseVehicle1.vehicleRegistrationPlateNo1} ${getProvinceLabal(caseVehicle1.provinceId ?? '')}'
          : 'ไม่ติดแผ่นป้ายทะเบียน';

      String otherPlate1 =
          'แผ่นป้ายทะเบียนหมายเลขส่วนพ่วง ${caseVehicle1.vehicleRegistrationPlateNo2} ${getProvinceLabal(caseVehicle1.provinceOtherId ?? '')}';

      String plate2 = caseVehicle2.isVehicleRegistrationPlate == '1'
          ? 'แผ่นป้ายทะเบียนหมายเลข ${caseVehicle2.vehicleRegistrationPlateNo1} ${getProvinceLabal(caseVehicle2.provinceId ?? '')}'
          : 'ไม่ติดแผ่นป้ายทะเบียน';

      String otherPlate2 =
          'แผ่นป้ายทะเบียนหมายเลขส่วนพ่วง ${caseVehicle2.vehicleRegistrationPlateNo2} ${getProvinceLabal(caseVehicle2.provinceOtherId ?? '')}';

      _vehicle1Controller.text =
          '${caseVehicle1.vehicleTypeId == '0' ? '${caseVehicle1.vehicleTypeOther}' : getVehicleTypeLabal(caseVehicle1.vehicleTypeId ?? '')} - ${caseVehicle1.vehicleBrandId == '0' ? '${caseVehicle1.vehicleBrandOther}' : getVehicleBrandLabal(caseVehicle1.vehicleBrandId ?? '')} - ${getVehicleColorLabal(caseVehicle1.colorId1 ?? '')} ${caseVehicle1.colorId2 != '' ? ',${getVehicleColorLabal(caseVehicle1.colorId2 ?? '')}' : ''} $plate1 ${caseVehicle1.vehicleRegistrationPlateNo2 == null || caseVehicle1.vehicleRegistrationPlateNo2 == '' ? '' : ',$otherPlate1'}'
          '';
      _vehicle2Controller.text =
          '${caseVehicle2.vehicleTypeId == '0' ? '${caseVehicle2.vehicleTypeOther}' : getVehicleTypeLabal(caseVehicle2.vehicleTypeId ?? '')} - ${caseVehicle2.vehicleBrandId == '0' ? '${caseVehicle2.vehicleBrandOther}' : getVehicleBrandLabal(caseVehicle2.vehicleBrandId ?? '')} - ${getVehicleColorLabal(caseVehicle2.colorId1 ?? '')} ${caseVehicle2.colorId2 != '' ? ',${getVehicleColorLabal(caseVehicle2.colorId2 ?? '')}' : ''} $plate2 ${caseVehicle2.vehicleRegistrationPlateNo2 == null || caseVehicle2.vehicleRegistrationPlateNo2 == '' ? '' : ',$otherPlate2'}'
          '';
      vehicle1Index = caseVehicles
              ?.indexWhere((caseVehicle) => vehicle1ID == caseVehicle.id) ??
          -1;
      vehicle2Index = caseVehicles
              ?.indexWhere((caseVehicle) => vehicle2ID == caseVehicle.id) ??
          -1;
      getDamaged1(int.parse(vehicle1ID));
      getDamaged2(int.parse(vehicle2ID));
      caseCompareDetail = await CaseVehicleCompareDetailDao()
          .getCaseVehicleCompareDetail(
              widget.caseID ?? -1, widget.vehicleCompareId);
      if (caseDamaged1 != null && caseCompareDetail != null) {
        for (var i = 0; i < caseDamaged1!.length; i++) {
          for (var j = 0; j < caseCompareDetail!.length; j++) {
            if (caseDamaged1![i].id ==
                caseCompareDetail![j].caseVehicleDamagedId) {
              if (kDebugMode) {
                print(caseDamaged1![i].id);
              }
              final index = caseDamaged1!.indexWhere(
                  (caseDamaged) => caseDamaged.id == caseDamaged1![i].id);
              _isChecked1[index] = true;
            }
          }
        }
      }

      if (caseDamaged2 != null && caseCompareDetail != null) {}
      for (var i = 0; i < caseDamaged2!.length; i++) {
        for (var j = 0; j < caseCompareDetail!.length; j++) {
          if (caseDamaged2![i].id ==
              caseCompareDetail![j].caseVehicleDamagedId) {
            if (kDebugMode) {
              print(caseDamaged2![i].id);
            }
            final index = caseDamaged2!.indexWhere(
                (caseDamaged) => caseDamaged.id == caseDamaged2![i].id);
            _isChecked2[index] = true;
            if (kDebugMode) {
              print(_isChecked2);
            }
          }
        }
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  asyncCallString() {
    if (caseVehicles != null) {
      for (int i = 0; i < caseVehicles!.length; i++) {
        String plate = caseVehicles![i].isVehicleRegistrationPlate == '1'
            ? 'แผ่นป้ายทะเบียนหมายเลข ${caseVehicles![i].vehicleRegistrationPlateNo1} ${getProvinceLabal(caseVehicles![i].provinceId ?? '')}'
            : 'ไม่ติดแผ่นป้ายทะเบียน';
        String otherPlate =
            'แผ่นป้ายทะเบียนหมายเลขส่วนพ่วง ${caseVehicles![i].vehicleRegistrationPlateNo2} ${getProvinceLabal(caseVehicles![i].provinceOtherId ?? '')}';
        caseVehicleString.add(
            '${caseVehicles?[i].vehicleTypeId == '0' ? '${caseVehicles![i].vehicleTypeOther}' : getVehicleTypeLabal(caseVehicles![i].vehicleTypeId ?? '')} - ${caseVehicles![i].vehicleBrandId == '0' ? '${caseVehicles![i].vehicleBrandOther}' : getVehicleBrandLabal(caseVehicles![i].vehicleBrandId ?? '')} - ${getVehicleColorLabal(caseVehicles![i].colorId1 ?? '')} ${caseVehicles![i].colorId2 != '' ? ',${getVehicleColorLabal(caseVehicles![i].colorId2 ?? '')}' : ''} $plate ${caseVehicles![i].vehicleRegistrationPlateNo2 == null || caseVehicles![i].vehicleRegistrationPlateNo2 == '' ? '' : ',$otherPlate'}'
            '');
      }
    }
  }

  getDamaged1(int id) async {
    await CaseDamagedDao()
        .getCaseDamagesForCompare(widget.caseID ?? -1, id)
        .then((val) {
      setState(() {
        caseDamaged1 = val;
        _isChecked1 = List<bool>.filled(caseDamaged1?.length ?? 0, false);
      });
    });
  }

  getDamaged2(int id) async {
    await CaseDamagedDao()
        .getCaseDamagesForCompare(widget.caseID ?? -1, id)
        .then((val) {
      setState(() {
        caseDamaged2 = val;
        _isChecked2 = List<bool>.filled(caseDamaged2?.length ?? 0, false);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    return Scaffold(
        extendBodyBehindAppBar: true,
        key: _scaffoldKey,
        appBar: AppBarWidget(
          leading: IconButton(
              icon: isIOS
                  ? const Icon(Icons.arrow_back_ios)
                  : const Icon(Icons.arrow_back),
              onPressed: () async {
                Navigator.of(context).pop(true);
              }),
          title: 'รายละเอียดการตรวจเปรียบเทียบ',
          actions: [
            Container(
              width: MediaQuery.of(context).size.width * 0.02,
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
                : SingleChildScrollView(
                    child: SafeArea(
                        child: Container(
                            margin: isPhone
                                ? const EdgeInsets.all(32)
                                : const EdgeInsets.only(
                                    left: 32, right: 32, top: 32, bottom: 32),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                headerView(),
                                spacer(),
                                // modalBottomSheet(
                                //     _vehicle1Controller,
                                //     'กรุณาเลือกรถของกลางลำดับที่ 1',
                                //     'เลือกรถของกลาง',
                                //     caseVehicleString,
                                //     vehicle1Index, (context, index) {
                                // if (vehicle1ID != caseVehicles[index].id) {
                                //   _vehicle1Controller.text =
                                //       caseVehicleString[index];
                                //   vehicle1ID = caseVehicles[index].id;
                                //   print(vehicle1ID);
                                //   getDamaged1(int.parse(vehicle1ID));
                                // }

                                //   Navigator.of(context).pop();
                                // }, null, false),
                                _selectVehicle1(),
                                spacer(),
                                ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true, // Set this
                                    itemCount: caseDamaged1?.length,
                                    itemBuilder:
                                        (BuildContext ctxt, int index) {
                                      return _listItem(
                                          caseDamaged1 ?? [], index, true);
                                    }),
                                spacer(),
                                // modalBottomSheet(
                                //     _vehicle2Controller,
                                //     'กรุณาเลือกรถของกลางลำดับที่ 2',
                                //     'เลือกรถของกลาง',
                                //     caseVehicleString,
                                //     vehicle2Index, (context, index) {
                                //   if (vehicle2ID != caseVehicles[index].id) {
                                //     _vehicle2Controller.text =
                                //         caseVehicleString[index];
                                //     vehicle2ID = caseVehicles[index].id;
                                //     print(vehicle2ID);
                                //     getDamaged2(int.parse(vehicle2ID));
                                //   }
                                //   Navigator.of(context).pop();
                                // }, null, false),
                                _selectVehicle2(),
                                spacer(),
                                ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true, // Set this
                                    itemCount: caseDamaged2?.length,
                                    itemBuilder:
                                        (BuildContext ctxt, int index) {
                                      return _listItem(
                                          caseDamaged2 ?? [], index, false);
                                    }),
                                spacer(),
                                saveButton()
                              ],
                            ))),
                  )));
  }

  Widget _listItem(List<CaseDamaged> list, int index, isFirst) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(10)),
      child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            checkColor: Colors.white,
            activeColor: pinkButton,
            title: Text(
              '${getVehicleSideLabel(list[index].vehicleSideId ?? '')} - ${list[index].damagedDetail}',
              style: GoogleFonts.prompt(
                textStyle: TextStyle(
                  color: textColor,
                  letterSpacing: .5,
                  fontSize: MediaQuery.of(context).size.height * 0.022,
                ),
              ),
            ),
            value: isFirst ? _isChecked1[index] : _isChecked2[index],
            onChanged: (val) {
              setState(() {
                isFirst
                    ? _isChecked1[index] = val ?? false
                    : _isChecked2[index] = val ?? false;
                if (kDebugMode) {
                  print(_isChecked1);
                }
              });
            },
          )),
    );
  }

  spacer() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.015,
    );
  }

  _selectVehicle1() {
    return Column(
      children: [
        TextButton(
          onPressed: () async {
            var result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SelectVehicle(
                        caseID: widget.caseID ?? -1,
                        title: 'เลือกรถของกลางลำดับที่ 1')));
            if (result != null) {
              if (vehicle1ID != result.id) {
                vehicle1ID = result.id.toString();
                var index = caseVehicles?.indexWhere(
                        (caseVehicle) => result.id == caseVehicle.id) ??
                    0;
                _vehicle1Controller.text = caseVehicleString[index];
                if (kDebugMode) {
                  print(vehicle1ID);
                }
                getDamaged1(int.parse(vehicle1ID));
              }
            }
          },
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.zero,
          ),
          child: _textfieldWithAction(
              'กรุณาเลือกรถของกลางลำดับที่ 1', _vehicle1Controller),
        ),
      ],
    );
  }

  _selectVehicle2() {
    return Column(
      children: [
        TextButton(
          onPressed: () async {
            var result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SelectVehicle(
                        caseID: widget.caseID ?? -1,
                        title: 'เลือกรถของกลางลำดับที่ 2')));
            if (result != null) {
              if (vehicle2ID != result.id) {
                vehicle2ID = result.id.toString();
                var index = caseVehicles?.indexWhere(
                        (caseVehicle) => result.id == caseVehicle.id) ??
                    0;
                _vehicle2Controller.text = caseVehicleString[index];
                if (kDebugMode) {
                  print(vehicle2ID);
                }
                getDamaged2(int.parse(vehicle2ID));
              }
            }
          },
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.zero,
          ),
          child: _textfieldWithAction(
              'กรุณาเลือกรถของกลางลำดับที่ 2', _vehicle2Controller),
        ),
      ],
    );
  }

  Widget _textfieldWithAction(
      String hintText, TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: whiteOpacity,
      ),
      child: TextFormField(
        maxLines: null,
        controller: controller,
        enabled: false,
        style: GoogleFonts.prompt(
            textStyle: TextStyle(
          color: textColor,
          letterSpacing: 0.5,
          fontSize: MediaQuery.of(context).size.height * 0.02,
        )),
        decoration: InputDecoration(
          suffixIcon: Icon(Icons.arrow_forward_ios,
              size: MediaQuery.of(context).size.height * 0.02,
              color: textColor),
          contentPadding:
              const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 16),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          hintText: hintText,
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

  // _selectVehicle2() {
  //   return Column(
  //     children: [
  //       TextButton(
  //         onPressed: () async {
  //           var result = await Navigator.push(context,
  //               MaterialPageRoute(builder: (context) => SelectVehicle()));
  //           print('${result.brandTH}');
  //           if (result != null) {
  //             setState(() {
  //               _vehicleBrandCntl.text = result.id == 0
  //                   ? 'อื่นๆ'
  //                   : '${result.brandTH} (${result.brandEN})';
  //               vehicleBrandId = result.id;
  //               if (result.id != 0) {
  //                 _vehicleBrandOtherCntl.text = '';
  //               }
  //               print(_vehicleBrandCntl.text);
  //             });
  //           }
  //         },
  //         style: OutlinedButton.styleFrom(
  //           padding: EdgeInsets.zero,
  //         ),
  //         child: _textfieldWithAction('กรุณาเลือกยี่ห้อรถ', _vehicleBrandCntl),
  //       ),
  //     ],
  //   );
  // }

  Widget headerView() {
    return Padding(
      padding: const EdgeInsets.only(left: 24, bottom: 24),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              'หมายเลขคดี',
              textAlign: TextAlign.center,
              style: GoogleFonts.prompt(
                textStyle: TextStyle(
                  color: Colors.white,
                  letterSpacing: .5,
                  fontSize: MediaQuery.of(context).size.height * 0.025,
                ),
              ),
            ),
            Text(
              '${widget.caseNo}',
              textAlign: TextAlign.center,
              style: GoogleFonts.prompt(
                textStyle: TextStyle(
                  color: Colors.white,
                  letterSpacing: .5,
                  fontSize: MediaQuery.of(context).size.height * 0.03,
                ),
              ),
            ),
            Text(
              'ประเภทคดี : $caseName',
              textAlign: TextAlign.center,
              style: GoogleFonts.prompt(
                textStyle: TextStyle(
                  color: Colors.white,
                  letterSpacing: .5,
                  fontSize: MediaQuery.of(context).size.height * 0.025,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget modalBottomSheet(
      TextEditingController controller,
      String hint,
      String title,
      List items,
      int indexSelected,
      Function onPressed,
      Widget sufflixIcon,
      bool isCanClear) {
    return TextFieldModalBottomSheet(
      suffixIcon: sufflixIcon,
      controller: controller,
      hint: hint,
      isCanClear: isCanClear,
      onPress: () => {
        FocusScope.of(context).unfocus(),
        showModalBottomSheet(
          context: context,
          builder: (mycontext) {
            return Container(
                color: Colors.transparent,
                child: SizedBox(
                  height: MediaQuery.of(context).copyWith().size.height / 2.5,
                  child: Scaffold(
                    appBar: AppBar(
                      backgroundColor: Colors.white,
                      bottomOpacity: 0.3,
                      elevation: 0.5,
                      automaticallyImplyLeading: false,
                      titleSpacing: 0.0,
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          MaterialButton(
                            child: Text('ยกเลิก',
                                style: GoogleFonts.prompt(
                                    textStyle: TextStyle(
                                  color: darkBlue,
                                  letterSpacing: 0.5,
                                  fontSize:
                                      MediaQuery.of(context).size.height * 0.02,
                                ))),
                            onPressed: () {
                              if (controller.text == '') {
                                controller.clear();
                                indexSelected = 0;
                              }
                              Navigator.pop(context);
                            },
                          ),
                          Text(title,
                              style: GoogleFonts.prompt(
                                  textStyle: TextStyle(
                                color: darkBlue,
                                letterSpacing: 0.5,
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.025,
                              ))),
                          MaterialButton(
                              child: Text('เลือก',
                                  style: GoogleFonts.prompt(
                                      textStyle: TextStyle(
                                    color: darkBlue,
                                    letterSpacing: 0.5,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.02,
                                  ))),
                              onPressed: () =>
                                  onPressed(mycontext, indexSelected))
                        ],
                      ),
                    ),
                    body: CupertinoPicker(
                        squeeze: 2,
                        diameterRatio: 1,
                        useMagnifier: true,
                        looping: false,
                        scrollController: FixedExtentScrollController(
                          initialItem: indexSelected,
                        ),
                        itemExtent: isPhone ? 40.0 : 100.0,
                        backgroundColor: Colors.white,
                        onSelectedItemChanged: (int index) => setState(() {
                              indexSelected = index;
                            }),
                        children:
                            List<Widget>.generate(items.length, (int index) {
                          return Center(
                            child: Text(
                              items[index],
                              style: GoogleFonts.prompt(
                                textStyle: TextStyle(
                                  color: darkBlue,
                                  letterSpacing: 0.5,
                                  fontSize:
                                      MediaQuery.of(context).size.height * 0.02,
                                ),
                              ),
                            ),
                          );
                        })),
                  ),
                ));
          },
        )
      },
    );
  }

  Widget saveButton() {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
      child: AppButton(
          color: pinkButton,
          textColor: Colors.white,
          text: 'บันทึก',
          onPressed: () async {
            setState(() {
              isLoading = true;
            });
            if (vehicle1ID != '' && vehicle2ID != '') {
              if (kDebugMode) {
                print('vehicle1ID : $vehicle1ID');
                print('vehicle2ID : $vehicle2ID');
              }
              if (widget.isEdit) {
                await CaseVehicleCompareDao()
                    .updateCaseVehicleCompared(vehicle1ID, vehicle2ID,
                        int.parse(widget.caseVehicleCompare?.id ?? ''))
                    .then((_) async {
                  await CaseVehicleCompareDetailDao()
                      .deleteCaseVehicleCompareDetail(widget.vehicleCompareId)
                      .then((_) async {
                    var data = await CaseVehicleCompareDetailDao()
                        .getCaseVehicleCompareDetail(
                            widget.caseID ?? -1, widget.vehicleCompareId);
                    if (kDebugMode) {
                      print('data $data');
                      print('_isChecked1 $_isChecked1');
                    }

                    for (var i = 0; i < _isChecked1.length; i++) {
                      if (_isChecked1[i]) {
                        if (kDebugMode) {
                          print(caseDamaged1?[i].id);
                          print(caseDamaged1?[i].damagedDetail);
                        }

                        await CaseVehicleCompareDetailDao()
                            .createCaseVehicleCompareDetail(
                                widget.caseID.toString(),
                                vehicle1ID,
                                caseDamaged1?[i].id,
                                int.parse(widget.vehicleCompareId ?? ''));
                      }
                    }
                    for (var i = 0; i < _isChecked2.length; i++) {
                      if (_isChecked2[i]) {
                        if (kDebugMode) {
                          print(caseDamaged2?[i].id);
                          print(caseDamaged2?[i].damagedDetail);
                        }

                        await CaseVehicleCompareDetailDao()
                            .createCaseVehicleCompareDetail(
                                widget.caseID.toString(),
                                vehicle2ID,
                                caseDamaged2?[i].id,
                                int.parse(widget.vehicleCompareId ?? ''))
                            .then((value) => Navigator.of(context).pop(true));
                      }
                    }
                  });
                });
              } else {
                await CaseVehicleCompareDao().createCaseVehicleCompared(
                    widget.caseID.toString(), vehicle1ID, vehicle2ID);
                await CaseVehicleCompareDao()
                    .getCaseVehicleCompare(widget.caseID ?? -1)
                    .then((value) async {
                  for (var i = 0; i < _isChecked1.length; i++) {
                    if (_isChecked1[i]) {
                      if (kDebugMode) {
                        print(caseDamaged1?[i].id);
                        print(caseDamaged1?[i].damagedDetail);
                      }

                      await CaseVehicleCompareDetailDao()
                          .createCaseVehicleCompareDetail(
                              widget.caseID.toString(),
                              vehicle1ID,
                              caseDamaged1?[i].id,
                              int.parse(value.last.id ?? ''));
                    }
                  }
                  for (var i = 0; i < _isChecked2.length; i++) {
                    if (_isChecked2[i]) {
                      if (kDebugMode) {
                        print(caseDamaged2?[i].id);
                        print(caseDamaged2?[i].damagedDetail);
                      }

                      await CaseVehicleCompareDetailDao()
                          .createCaseVehicleCompareDetail(
                              widget.caseID.toString(),
                              vehicle2ID,
                              caseDamaged2?[i].id,
                              int.parse(value.last.id ?? ''))
                          .then((value) => Navigator.of(context).pop(true));
                    }
                  }
                });
              }
            } else {
              final snackBar = SnackBar(
                content: Text(
                  'กรุณาเลือกรถของกลางให้ครบถ้วน',
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
          }),
    );
  }

  String getVehicleTypeLabal(String id) {
    if (vehicleTypes != null) {
      for (int i = 0; i < vehicleTypes!.length; i++) {
        if (id == '${vehicleTypes?[i].id}') {
          return vehicleTypes?[i].vehicleType ?? '';
        }
      }
    }

    return '';
  }

  String getVehicleBrandLabal(String id) {
    if (vehicleBrands != null) {
      for (int i = 0; i < vehicleBrands!.length; i++) {
        if (id == '${vehicleBrands![i].id}') {
          return '${vehicleBrands![i].brandTH?.trim()} (${vehicleBrands![i].brandEN?.trim()})';
        }
      }
    }

    return '';
  }

  String getVehicleColorLabal(String id) {
    if (vehicleColors != null) {
      for (int i = 0; i < vehicleColors!.length; i++) {
        if (id == '${vehicleColors![i].id}') {
          return '${vehicleColors![i].vehicleColor}';
        }
      }
    }
    return '';
  }

  String getProvinceLabal(String id) {
    if (provinces != null) {
      for (int i = 0; i < provinces!.length; i++) {
        if (id == '${provinces![i].id}') {
          return '${provinces![i].province}';
        }
      }
    }
    return '';
  }

  String getVehicleSideLabel(String id) {
    if (sides != null) {
      for (int i = 0; i < sides!.length; i++) {
        if (id == '${sides![i].id}') {
          return sides![i].vehicleSide ?? '';
        }
      }
    }
    return '';
  }
}
