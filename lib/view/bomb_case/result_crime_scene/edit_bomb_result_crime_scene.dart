import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/color.dart';
import '../../../models/FidsCrimeScene.dart';
import '../../../widget/app_bar_widget.dart';
import '../../../widget/app_button.dart';
import '../../../widget/text_field_widget.dart';

class EditResultCrimesceneBomb extends StatefulWidget {
  final int? caseID;
  const EditResultCrimesceneBomb({super.key, required this.caseID});

  @override
  EditResultCrimesceneBombState createState() =>
      EditResultCrimesceneBombState();
}

class EditResultCrimesceneBombState extends State<EditResultCrimesceneBomb> {
  TextEditingController caseBehaviorController = TextEditingController();
  TextEditingController isoDamageController = TextEditingController();
  TextEditingController isoBombLocationController = TextEditingController();
  TextEditingController isoBombSizeController = TextEditingController();

  bool isLoading = true;
  bool isPhone = Device.get().isPhone;
  FidsCrimeScene? data;
  String? caseName;

  @override
  void initState() {
    super.initState();
    asyncMethod();
  }

  asyncMethod() async {
    asyncCall1();
  }

  void asyncCall1() async {
    var result =
        await FidsCrimeSceneDao().getFidsCrimeSceneById(widget.caseID ?? -1);
    setState(() async {
      data = result;
      caseBehaviorController.text = data?.caseBehavior ?? '';
      isoDamageController.text = data?.isoDamage ?? '';
      isoBombLocationController.text = data?.isoBombLocation ?? '';
      isoBombSizeController.text = data?.isoBombSize ?? '';
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBarWidget(
          title: 'ผลการตรวจสถานที่เกิดเหตุ',
          actions: [
            Container(
              width: 50,
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
                      header('พฤติการณ์คดี'),
                      spacer(),
                      InputField(
                          controller: caseBehaviorController,
                          hint: 'กรอกพฤติการณ์คดี',
                          onChanged: (_) {}),
                      spacer(),
                      header('ความเสียหาย'),
                      spacer(),
                      InputField(
                          controller: isoDamageController,
                          hint: 'กรอกความเสียหาย',
                          onChanged: (_) {}),
                      spacer(),
                      header('ตำแหน่งที่เกิดการระเบิด/หลุมระเบิด'),
                      spacer(),
                      InputField(
                          controller: isoBombLocationController,
                          hint: 'ตำแหน่งที่เกิดการระเบิด/หลุมระเบิด',
                          onChanged: (_) {}),
                      spacer(),
                      header('ขนาด'),
                      spacer(),
                      InputField(
                          controller: isoBombSizeController,
                          hint: 'กรอกขนาด',
                          onChanged: (_) {}),
                      spacer(),
                      spacer(),
                      spacer(),
                      saveButton()
                    ])))));
  }

  Widget header(String? title) {
    return Row(
      children: [
        Text(
          title ?? '',
          style: GoogleFonts.prompt(
            textStyle: TextStyle(
              color: Colors.white,
              letterSpacing: 0.5,
              fontSize: MediaQuery.of(context).size.height * 0.025,
            ),
          ),
        ),
      ],
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
        onPressed: () {
          if (kDebugMode) {
            print('พฤติการณ์คดี ${caseBehaviorController.text}');
            print('ความเสียหาย ${isoDamageController.text}');
            print(
                'ตำแหน่งที่เกิดการระเบิด/หลุมระเบิด ${isoBombLocationController.text}');
          }

          FidsCrimeSceneDao().updateBombResultCase(
              caseBehaviorController.text,
              isoDamageController.text,
              isoBombLocationController.text,
              isoBombSizeController.text,
              widget.caseID.toString());
          Navigator.of(context).pop(true);
        });
  }
}
