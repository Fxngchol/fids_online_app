import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/color.dart';
import '../../../models/CaseBodyWound.dart';
import '../../../models/UnitMeter.dart';
import '../../../widget/app_bar_widget.dart';
import '../../../widget/app_button.dart';
import '../../../widget/text_field_widget.dart';

class AddLesion extends StatefulWidget {
  final int? caseID;
  final String? caseNo;
  final int? bodyId;
  final List<CaseBodyWound>? listCaseBodyWound;
  final int indexEdit;
  final bool isEdit;

  const AddLesion(
      {super.key,
      this.caseID,
      this.caseNo,
      this.bodyId,
      this.listCaseBodyWound,
      required this.indexEdit,
      this.isEdit = false});

  @override
  AddLesionState createState() => AddLesionState();
}

class AddLesionState extends State<AddLesion> {
  bool isPhone = Device.get().isPhone;
  CaseBodyWound caseBodyWound = CaseBodyWound();

  List<UnitMeter> unitMeter = [
    UnitMeter(id: 1, unitLabel: 'เมตร'),
    UnitMeter(id: 2, unitLabel: 'เซนติเมตร')
  ];
  final TextEditingController _woundDetailController = TextEditingController();
  final TextEditingController _woundPositionController =
      TextEditingController();
  final TextEditingController _woundSizeController = TextEditingController();
  final TextEditingController _woundUnitController = TextEditingController();
  final TextEditingController _woundAmountController = TextEditingController();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      setupData();
    }
    if (kDebugMode) {
      print(widget.isEdit);
    }
    //asyncMethod();
  }

  setupData() {
    _woundDetailController.text =
        widget.listCaseBodyWound?[widget.indexEdit].woundDetail == null
            ? ''
            : widget.listCaseBodyWound?[widget.indexEdit].woundDetail ?? '';
    _woundPositionController.text =
        widget.listCaseBodyWound?[widget.indexEdit].woundPosition == null
            ? ''
            : widget.listCaseBodyWound?[widget.indexEdit].woundPosition ?? '';
    _woundSizeController.text =
        widget.listCaseBodyWound?[widget.indexEdit].woundSize == null
            ? ''
            : widget.listCaseBodyWound?[widget.indexEdit].woundSize ?? '';
    _woundUnitController.text =
        widget.listCaseBodyWound?[widget.indexEdit].woundUnitId ?? '';

    if (kDebugMode) {
      print('${widget.listCaseBodyWound![widget.indexEdit].woundUnitId}++++++');
    }

    _woundAmountController.text =
        widget.listCaseBodyWound?[widget.indexEdit].woundAmount == null
            ? ''
            : widget.listCaseBodyWound?[widget.indexEdit].woundAmount ?? '';
  }

  String? meterLabel(String? id) {
    for (int i = 0; i < unitMeter.length; i++) {
      if ('$id' == '${unitMeter[i].id}') {
        return unitMeter[i].unitLabel;
      }
    }
    return '';
  }

  // asyncMethod() async {
  //   asyncCall1();
  // }

  // void asyncCall1() async {
  //   var result = await UnitDao().getUnit();
  //   setState(() {
  //     unitList = result;
  //     isLoading = false;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBarWidget(
          title: 'ลักษณะบาดแผล',
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
                    child: ListView(children: [
                      header('ลักษณะ*'),
                      spacer(context),
                      InputField(
                          controller: _woundDetailController,
                          hint: 'กรอกลักษณะ',
                          maxLine: null,
                          onChanged: (value) {}),
                      spacer(context),
                      header('ตำแหน่ง*'),
                      spacer(context),
                      InputField(
                          controller: _woundPositionController,
                          hint: 'กรอกตำแหน่ง',
                          onChanged: (value) {}),
                      spacer(context),
                      header('ขนาด'),
                      spacer(context),
                      InputField(
                          controller: _woundSizeController,
                          hint: 'กรอกขนาด',
                          onChanged: (value) {}),
                      spacer(context),
                      InputField(
                          controller: _woundUnitController,
                          hint: 'กรอกหน่วย',
                          onChanged: (value) {}),
                      spacer(context),
                      header('จำนวน (รอย)*'),
                      spacer(context),
                      InputField(
                          keyboardType: const TextInputType.numberWithOptions(
                              signed: true),
                          controller: _woundAmountController,
                          hint: 'กรอกจำนวน (รอย)',
                          onChanged: (value) {}),
                      spacer(context),
                      spacer(context),
                      saveButton(),
                      spacer(context),
                      spacer(context),
                    ])))));
  }

  Widget header(String? text) {
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

  Widget spacer(context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.015,
    );
  }

  Widget saveButton() {
    return AppButton(
        color: pinkButton,
        textColor: Colors.white,
        text: 'บันทึก',
        onPressed: () {
          if (validate()) {
            // Navigator.of(context).pop();
            if (kDebugMode) {
              print('WoundDetail: ${_woundDetailController.text}');
              print('WoundPosition: ${_woundPositionController.text}');
              print('WoundSize: ${_woundSizeController.text}');
              print('WoundAmount: ${_woundAmountController.text}');
            }

            // bool numValidate = true;
            // try {
            //   if (_woundSizeController.text != '') {
            //     double.parse(_woundSizeController.text);
            //   }
            //   if (_woundAmountController.text != '') {
            //     double.parse(_woundAmountController.text);
            //   }
            // } catch (ex) {
            //   numValidate = false;
            // }

            // if (numValidate) {
            if (widget.isEdit) {
              var data = CaseBodyWound();
              data.id = widget.listCaseBodyWound?[widget.indexEdit].id;
              data.woundDetail = _woundDetailController.text;
              data.woundPosition = _woundPositionController.text;
              data.woundSize = _woundSizeController.text;
              data.woundUnitId = _woundUnitController.text;
              data.woundAmount = _woundAmountController.text;
              data.createBy = '';
              data.createDate = '';
              data.updateBy = '';
              data.updateDate = '';
              data.activeFlag = '1';
              widget.listCaseBodyWound?[widget.indexEdit] = data;
              Navigator.of(context).pop(widget.listCaseBodyWound);
            } else {
              var data = CaseBodyWound();
              data.woundDetail = _woundDetailController.text;
              data.woundPosition = _woundPositionController.text;
              data.woundSize = _woundSizeController.text;
              data.woundUnitId = _woundUnitController.text;
              data.woundAmount = _woundAmountController.text;
              data.createBy = '';
              data.createDate = '';
              data.updateBy = '';
              data.updateDate = '';
              data.activeFlag = '1';
              Navigator.of(context).pop(data);
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

  bool validate() {
    return _woundDetailController.text != '' &&
        _woundPositionController.text != '' &&
        _woundAmountController.text != '';
  }
}
