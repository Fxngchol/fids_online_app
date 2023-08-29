import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../Utils/color.dart';
import '../../../../models/case_vehicle/CaseDamaged.dart';
import '../../../../models/case_vehicle/CaseVehicle.dart';
import '../../../../models/case_vehicle/CaseVehicleDao.dart';
import '../../../../models/case_vehicle/VehicleSide.dart';
import '../../../../widget/app_bar_widget.dart';
import '../../../../widget/app_button.dart';
import '../../../../widget/text_field_widget.dart';

class AddFisrtTab extends StatefulWidget {
  final int? caseID, vehicleId, vehicleDamagedId, sideId;
  final String? caseNo, vehicleDetail, sideName;
  final bool isEdit;
  const AddFisrtTab({
    super.key,
    this.vehicleId,
    this.vehicleDetail,
    this.vehicleDamagedId,
    this.caseID,
    this.caseNo,
    this.sideId,
    this.sideName,
    this.isEdit = false,
  });

  @override
  State<AddFisrtTab> createState() => AddFisrtTabState();
}

class AddFisrtTabState extends State<AddFisrtTab> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = true;
  bool isPhone = Device.get().isPhone;
  List<VehicleSide> sides = [];
  CaseVehicle vehicle = CaseVehicle();
  int vehicleSideId = -1, isDamagedVal = 2;
  final TextEditingController _vehicleSideCntl = TextEditingController();
  final TextEditingController _dmgDetailCntl = TextEditingController();
  final TextEditingController _heightDetailCntl = TextEditingController();
  final TextEditingController _damagedOtherCntl = TextEditingController();

  @override
  void initState() {
    if (kDebugMode) {
      print(widget.vehicleId);
    }
    acyncCall();
    super.initState();
  }

  void acyncCall() async {
    vehicleSideId = widget.sideId ?? -1;
    sides = await VehicleSideDao().getVehicleSideList();
    vehicle = (await CaseVehicleDao()
            .getCaseVehicleById(widget.vehicleId.toString())) ??
        CaseVehicle();
    if (widget.isEdit) {
      await CaseDamagedDao()
          .getCaseVehicleDamagedById(widget.vehicleDamagedId.toString())
          .then((value) async {
        var sideLabel = await VehicleSideDao()
            .getVehicleSideLabelById(value?.vehicleSideId ?? '');
        setState(() {
          isDamagedVal = int.parse(value?.isDamaged ?? '');
          _vehicleSideCntl.text = sideLabel;
          _dmgDetailCntl.text = value?.damagedDetail ?? '';
          _heightDetailCntl.text = value?.height ?? '';
          _damagedOtherCntl.text = value?.damagedOther ?? '';
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
          title:
              widget.isEdit ? 'แก้ไขการตรวจพิสูจน์' : 'เพิ่มผลการตรวจพิสูจน์',
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
                              vehicleDetail(),
                              _spacer(),
                              _spacer(),
                              _isDemagedView(),
                              isDamagedVal == 1
                                  ? _damagedDetailView()
                                  : Container(),
                              _spacer(),
                              _header('อื่นๆ'),
                              InputField(
                                  hint: 'กรอกรายละเอียดอื่นๆ',
                                  controller: _damagedOtherCntl,
                                  onChanged: (val) {}),
                              _spacer(),
                              saveButton()
                            ],
                          ),
                        )))));
  }

  Widget vehicleDetail() {
    return Center(
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.03,
                  vertical: MediaQuery.of(context).size.width * 0.01),
              child: Text(
                '${widget.vehicleDetail}',
                textAlign: TextAlign.left,
                style: GoogleFonts.prompt(
                  textStyle: TextStyle(
                    color: textColor,
                    letterSpacing: .5,
                    fontSize: MediaQuery.of(context).size.height * 0.022,
                  ),
                ),
              ),
            ),
          ),
          _spacer(),
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.03,
                  vertical: MediaQuery.of(context).size.width * 0.01),
              child: Text(
                '${widget.sideName}',
                textAlign: TextAlign.left,
                style: GoogleFonts.prompt(
                  textStyle: TextStyle(
                    color: textColor,
                    letterSpacing: .5,
                    fontSize: MediaQuery.of(context).size.height * 0.022,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _damagedDetailView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _spacer(),
        _header('ตรวจพบ'),
        InputField(
            hint: 'กรอกรายละเอียดที่ตรวจพบ',
            controller: _dmgDetailCntl,
            onChanged: (val) {}),
        _spacer(),
        _header('ที่ระดับความสูงจากพื้นประมาณ'),
        InputField(
            hint: 'กรอกความสูง',
            keyboardType: TextInputType.number,
            controller: _heightDetailCntl,
            onChanged: (val) {}),
      ],
    );
  }

  Widget _header(String text) {
    return Column(
      children: [
        Text(
          text,
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

  Widget _spacer() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.015,
    );
  }

  // ignore: unused_element
  Widget _textfieldWithAction(
      String hintText, TextEditingController controller) {
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

  _isDemagedView() {
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
                  groupValue: isDamagedVal,
                  onChanged: (value) {
                    setState(() {
                      isDamagedVal = value ?? -1;
                      if (kDebugMode) {
                        print(isDamagedVal);
                      }
                    });
                  }),
            ),
            Text(
              'ตรวจไม่พบสภาพและความเสียหาย',
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
                groupValue: isDamagedVal,
                onChanged: (value) {
                  setState(() {
                    isDamagedVal = value ?? -1;
                    if (kDebugMode) {
                      print(isDamagedVal);
                    }
                  });
                },
              ),
            ),
            Text(
              'ตรวจพบ',
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

  Widget saveButton() {
    return AppButton(
        color: pinkButton,
        textColor: Colors.white,
        text: 'บันทึก',
        onPressed: () async {
          if (kDebugMode) {
            print('1 ${_vehicleSideCntl.text}');
            print('2 ${_dmgDetailCntl.text}');
            print('3 ${_heightDetailCntl.text}');
            print('4 ${_damagedOtherCntl.text}');
            print('5 ${vehicleSideId.toString()}');
            print('6 ${isDamagedVal.toString()}');
          }

          if (widget.isEdit) {
            CaseDamagedDao().updateCaseVehicleDamaged(
                vehicleSideId.toString(),
                isDamagedVal.toString(),
                _dmgDetailCntl.text,
                _heightDetailCntl.text,
                _damagedOtherCntl.text,
                widget.vehicleDamagedId ?? -1);
            Navigator.of(context).pop(true);
          } else {
            await CaseDamagedDao()
                .createCaseVehicleDamaged(
                    widget.caseID.toString(),
                    vehicleSideId.toString(),
                    isDamagedVal.toString(),
                    _dmgDetailCntl.text,
                    _heightDetailCntl.text,
                    _damagedOtherCntl.text,
                    widget.vehicleId.toString())
                .then((value) => Navigator.of(context).pop(true));
          }
        });
  }
}
