import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../Utils/color.dart';
import '../../../../models/CaseReferencePoint.dart';
import '../../../../widget/app_bar_widget.dart';
import '../../../../widget/app_button.dart';
import '../../../../widget/text_field_widget.dart';

class AddReferencePoint extends StatefulWidget {
  final int? caseID;
  final String? caseNo;
  final CaseReferencePoint? caseReferencePoint;
  final bool isEdit;

  const AddReferencePoint(
      {super.key,
      this.caseID,
      this.caseNo,
      this.isEdit = false,
      this.caseReferencePoint});

  @override
  AddReferencePointState createState() => AddReferencePointState();
}

class AddReferencePointState extends State<AddReferencePoint> {
  bool isPhone = Device.get().isPhone;
  final TextEditingController _referencePointNo = TextEditingController();
  final TextEditingController _referencePointDetail = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      _referencePointNo.text =
          widget.caseReferencePoint?.referencePointNo ?? '';
      _referencePointDetail.text =
          widget.caseReferencePoint?.referencePointDetail ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBarWidget(
        title: 'เพิ่มจุดอ้างอิง',
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
            child: ListView(
              children: [
                header('จุดอ้างอิงที่* (หมายเลข)'),
                spacer(context),
                InputField(
                    controller: _referencePointNo,
                    hint: 'กรอกจุดอ้างอิง',
                    maxLine: 1,
                    onChanged: (_) {}),
                spacer(context),
                header('รายละเอียด*'),
                spacer(context),
                InputField(
                    controller: _referencePointDetail,
                    hint: 'กรอกรายละเอียด',
                    maxLine: null,
                    onChanged: (_) {}),
                spacer(context),
                spacer(context),
                saveButton()
              ],
            ),
          ),
        ),
      ),
    );
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
            // ReferencePointModel referencePoint = ReferencePointModel();
            // referencePoint.id = 0;
            // referencePoint.referencePointNo = int.parse(_referencePointNo.text);
            // referencePoint.referencePointDetail = _referencePointDetail.text;

            // print('${referencePoint.id}');
            // print('${referencePoint.referencePointNo}');
            // print('${referencePoint.referencePointDetail}');

            if (widget.isEdit) {
              CaseReferencePointDao().updateCaseReferencePointl(
                widget.caseReferencePoint?.id ?? -1,
                _referencePointNo.text,
                _referencePointDetail.text,
              );
            } else {
              CaseReferencePointDao().createCaseReferencePointl(
                  widget.caseID ?? -1,
                  _referencePointNo.text,
                  _referencePointDetail.text,
                  '',
                  '',
                  '',
                  '',
                  1);
            }

            Navigator.of(context).pop(true);
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
    return _referencePointNo.text != '' && _referencePointDetail.text != '';
  }
}
