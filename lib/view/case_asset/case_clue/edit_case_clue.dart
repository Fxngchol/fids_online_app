import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_device_type/flutter_device_type.dart';

import '../../../Utils/color.dart';
import '../../../models/FidsCrimeScene.dart';
import '../../../widget/app_bar_widget.dart';
import '../../../widget/app_button.dart';

class EditCaseClue extends StatefulWidget {
  final int? caseID;
  const EditCaseClue({super.key, this.caseID});

  @override
  EditCaseClueState createState() => EditCaseClueState();
}

class EditCaseClueState extends State<EditCaseClue> {
  int isoIsClueValue = -1;
  bool isoIsLock = false;
  FidsCrimeScene? fidsCrimeScene;

  @override
  void initState() {
    asyncCall1();
    super.initState();
  }

  void asyncCall1() async {
    await FidsCrimeSceneDao()
        .getFidsCrimeSceneById(widget.caseID ?? -1)
        .then((value) async {
      setState(() {
        fidsCrimeScene = value;
        if (fidsCrimeScene?.isoIsClue != null &&
            fidsCrimeScene?.isoIsClue != '') {
          fidsCrimeScene?.isoIsClue == '1'
              ? isoIsClueValue = 1
              : isoIsClueValue = 2;
        }
        if (fidsCrimeScene?.isoIsLock != null &&
            fidsCrimeScene?.isoIsLock != '') {
          fidsCrimeScene?.isoIsLock == '1'
              ? isoIsLock = true
              : isoIsLock = false;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isPhone = Device.get().isPhone;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBarWidget(
        title: 'ร่องรอย',
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
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              margin: isPhone
                  ? const EdgeInsets.all(32)
                  : const EdgeInsets.only(
                      left: 32, right: 32, top: 32, bottom: 32),
              child: SingleChildScrollView(
                child: Column(children: [clueDetailView()]),
              )),
        ),
      ),
    );
  }

  clueDetailView() {
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
                  groupValue: isoIsClueValue,
                  onChanged: (value) {
                    setState(() {
                      isoIsClueValue = value ?? -1;
                    });
                  }),
            ),
            Text(
              'ไม่พบร่องรอยใดๆ บริเวณสถานที่เกิดเหตุ',
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
        spacer(),
        checkbox('ผู้เสียหายไม่ได้ทำการปิดล็อคประตู/หน้าต่าง', isoIsLock,
            (value) {
          setState(() {
            isoIsLock = value;
          });
        }),
        spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Transform.scale(
              scale: 1.2,
              child: Radio(
                value: 1,
                activeColor: pinkButton,
                groupValue: isoIsClueValue,
                onChanged: (value) {
                  setState(() {
                    isoIsClueValue = value ?? -1;
                    isoIsLock = false;
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
        spacer(),
        spacer(),
        saveButton()
      ],
    );
  }

  checkbox(String? text, bool isChecked, Function onChanged) {
    return Padding(
      padding: const EdgeInsets.only(left: 32),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Transform.scale(
          scale: 1.7,
          child: Checkbox(
              value: isChecked,
              checkColor: Colors.white,
              activeColor: pinkButton,
              onChanged: (str) {
                onChanged(str);
              }),
        ),
        SizedBox(width: MediaQuery.of(context).size.width * 0.02),
        Flexible(
          child: Text(
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
        ),
      ]),
    );
  }

  spacer() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.01,
    );
  }

  Widget saveButton() {
    return AppButton(
        color: pinkButton,
        textColor: Colors.white,
        text: 'บันทึก',
        onPressed: () async {
          await FidsCrimeSceneDao()
              .updateAssetClueCase(isoIsClueValue.toString(),
                  isoIsLock == true ? '1' : '2', widget.caseID.toString())
              .then((value) => Navigator.of(context).pop(true));
        });
  }
}
