import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/color.dart';
import '../../../models/CaseAssetArea.dart';
import '../../../models/CaseRansacked.dart';
import '../../../widget/app_bar_widget.dart';
import '../../../widget/app_button.dart';
import '../../../widget/text_field_widget.dart';

class AddCaseRansacked extends StatefulWidget {
  final int? caseID;
  final String? caseNo;
  final bool isEdit;
  final int? indexEdit;
  final CaseAssetArea? caseAssetArea;
  final String? ransackedTypeID;

  const AddCaseRansacked(
      {super.key,
      this.caseID,
      this.caseNo,
      this.isEdit = false,
      this.caseAssetArea,
      this.indexEdit,
      this.ransackedTypeID});

  @override
  AddCaseRansackedState createState() => AddCaseRansackedState();
}

class AddCaseRansackedState extends State<AddCaseRansacked> {
  bool isPhone = Device.get().isPhone;

  TextEditingController areaDetailController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  TextEditingController labelNoController = TextEditingController();
  var maxPreId = 0;
  int isClueValue = -1;
  @override
  void initState() {
    super.initState();
    setupData();
    var preIdArr = [];
    if (widget.caseAssetArea != null) {
      if (widget.caseAssetArea!.caseRansackeds != null) {
        for (int i = 0; i < widget.caseAssetArea!.caseRansackeds!.length; i++) {
          if (widget.caseAssetArea!.caseRansackeds![i].preId != null) {
            preIdArr.add(widget.caseAssetArea!.caseRansackeds![i].preId);
            maxPreId = preIdArr
                .reduce((value, element) => value > element ? value : element);
            if (kDebugMode) {
              print(
                  'fff ${preIdArr.reduce((value, element) => value > element ? value : element)}');
            }
          } else {
            maxPreId = 0;
          }
        }
      }
    }
  }

  setupData() {
    if (widget.isEdit) {
      isClueValue = int.parse(
          widget.caseAssetArea?.caseRansackeds?[widget.indexEdit!].isClue ??
              '');
      areaDetailController.text =
          widget.caseAssetArea?.caseRansackeds?[widget.indexEdit!].areaDetail ??
              '';
      detailController.text =
          widget.caseAssetArea?.caseRansackeds?[widget.indexEdit!].detail ?? '';
      labelNoController.text =
          widget.caseAssetArea?.caseRansackeds?[widget.indexEdit!].labelNo ??
              '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBarWidget(
          title: widget.ransackedTypeID == '1'
              ? 'รอยงัด'
              : widget.ransackedTypeID == '2'
                  ? 'ร่องรอยรื้อค้น'
                  : 'วัตถุพยาน',
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
                  spacerTitle(),
                  clueTypeView(),
                  spacerTitle(),
                  title('รายละเอียด*'),
                  textField(
                      detailController, 'กรอกรายละเอียด', isClueValue == 1),
                  spacer(context),
                  widget.ransackedTypeID == '3'
                      ? title('ตรวจพบที่*')
                      : title('บริเวณ*'),
                  textField(
                      areaDetailController, 'กรอกรายละเอียด', isClueValue == 1),
                  spacer(context),
                  title('ป้ายหมายเลข'),
                  textField(
                      labelNoController, 'กรอกป้ายหมายเลข', isClueValue == 1),
                  spacerTitle(),
                  spacerTitle(),
                  saveButton()
                ],
              ),
            ),
          ),
        ));
  }

  clueTypeView() {
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
                  groupValue: isClueValue,
                  onChanged: (value) {
                    setState(() {
                      isClueValue = value ?? -1;
                    });
                  }),
            ),
            Text(
              'ไม่พบร่องรอย',
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
                groupValue: isClueValue,
                onChanged: (value) {
                  setState(() {
                    isClueValue = value ?? -1;
                  });
                },
              ),
            ),
            Text(
              'พบร่องรอย',
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

  bool validate() {
    return (isClueValue == 1 || isClueValue == 2) &&
        areaDetailController.text != '' &&
        detailController.text != '';
  }

  Widget saveButton() {
    return Padding(
        padding:
            EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
        child: AppButton(
            color: pinkButton,
            textColor: Colors.white,
            text: 'บันทึก',
            onPressed: () async {
              if (isClueValue == 1) {
                CaseRansacked ransacked = CaseRansacked();
                if (validate()) {
                  ransacked.fidsId = '${widget.caseID}';
                  ransacked.preId = maxPreId + 1;
                  ransacked.isClue = isClueValue.toString();
                  ransacked.areaDetail = areaDetailController.text;
                  ransacked.detail = detailController.text;
                  ransacked.labelNo = labelNoController.text;
                  ransacked.ransackedTypeID = widget.ransackedTypeID;
                  if (widget.isEdit) {
                    ransacked.id = widget
                        .caseAssetArea?.caseRansackeds?[widget.indexEdit!].id;
                    widget.caseAssetArea?.caseRansackeds?[widget.indexEdit!] =
                        ransacked;
                  } else {
                    widget.caseAssetArea?.caseRansackeds?.add(ransacked);
                  }
                  Navigator.of(context).pop(widget.caseAssetArea);

                  // if (widget.isEdit == false) {
                  //   print(widget.caseAssetArea.caseRansackeds.length + 1);
                  //   ransacked.fidsId = '${widget.caseID}';
                  //   ransacked.preId =
                  //       widget.caseAssetArea.caseRansackeds.length + 1;
                  //   ransacked.isClue = isClueValue .toString();
                  //   ransacked.areaDetail = areaDetailController.text;
                  //   ransacked.detail = detailController.text;
                  //   ransacked.labelNo = labelNoController.text;
                  //   ransacked.ransackedTypeID = widget.ransackedTypeID;
                  //   widget.caseAssetArea.caseRansackeds.add(ransacked);
                  //   Navigator.of(context).pop(widget.caseAssetArea);
                  // } else {
                  //   ransacked.preId = widget
                  //       .caseAssetArea.caseRansackeds[widget.indexEdit].preId;
                  //   ransacked.id = widget
                  //       .caseAssetArea.caseRansackeds[widget.indexEdit].id;
                  //   ransacked.fidsId = '${widget.caseID}';
                  //   ransacked.isClue = isClueValue .toString();
                  //   ransacked.areaDetail = areaDetailController.text;
                  //   ransacked.detail = detailController.text;
                  //   ransacked.labelNo = labelNoController.text;
                  //   ransacked.ransackedTypeID = widget.ransackedTypeID;

                  //   widget.caseAssetArea.caseRansackeds[widget.indexEdit] =
                  //       ransacked;
                  //   Navigator.of(context).pop(widget.caseAssetArea);
                  // }
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
              } else {
                CaseRansacked ransacked = CaseRansacked();
                ransacked.fidsId = '${widget.caseID}';
                ransacked.preId = maxPreId + 1;
                ransacked.isClue = isClueValue.toString();
                ransacked.areaDetail = '';
                ransacked.detail = '';
                ransacked.labelNo = '';
                ransacked.ransackedTypeID = widget.ransackedTypeID;

                widget.caseAssetArea?.caseRansackeds?.add(ransacked);

                Navigator.of(context).pop(widget.caseAssetArea);
                // if (widget.isEdit == false) {
                //   ransacked.isClue = isClueValue .toString();
                //   ransacked.preId =
                //       widget.caseAssetArea.caseRansackeds.length + 1;

                //   Navigator.of(context).pop(widget.caseAssetArea);
                // } else {
                //   ransacked.isClue = isClueValue .toString();
                //   ransacked.preId = widget
                //       .caseAssetArea.caseRansackeds[widget.indexEdit].preId;
                //   ransacked.id =
                //       widget.caseAssetArea.caseRansackeds[widget.indexEdit].id;
                //   ransacked.fidsId = '${widget.caseID}';
                //   ransacked.isClue = '';
                //   ransacked.areaDetail = '';
                //   ransacked.detail = '';
                //   ransacked.labelNo = '';
                //   ransacked.ransackedTypeID = widget.ransackedTypeID;
                //   widget.caseAssetArea.caseRansackeds[widget.indexEdit] =
                //       ransacked;
                // }
              }
            }));
  }

  spacerTitle() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.015,
    );
  }

  textField(TextEditingController controller, String? hint, bool isEnabled) {
    return InputField(
      isEnabled: isEnabled,
      controller: controller,
      hint: '$hint',
      onChanged: (_) {},
    );
  }

  Widget spacer(context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.015,
    );
  }

  title(String? title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        '$title',
        textAlign: TextAlign.left,
        style: GoogleFonts.prompt(
          textStyle: TextStyle(
            color: Colors.white,
            letterSpacing: .5,
            fontSize: MediaQuery.of(context).size.height * 0.03,
          ),
        ),
      ),
    );
  }
}
