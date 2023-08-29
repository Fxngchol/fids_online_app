import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/color.dart';
import '../../../models/CaseSceneLocation.dart';
import '../../../widget/app_bar_widget.dart';
import '../../../widget/app_button.dart';
import '../../../widget/text_field_widget.dart';

class EditCrimeSceneThirdTab extends StatefulWidget {
  final int? caseID;
  final String? caseNo;
  final bool isLocal;
  final bool isEdit;
  final CaseSceneLocation? caseSceneLocation;

  const EditCrimeSceneThirdTab(
      {super.key,
      this.caseID,
      this.caseNo,
      this.isLocal = false,
      this.isEdit = false,
      this.caseSceneLocation});

  @override
  EditCrimeSceneThirdTabState createState() => EditCrimeSceneThirdTabState();
}

class EditCrimeSceneThirdTabState extends State<EditCrimeSceneThirdTab> {
  TextEditingController sceneLocationText = TextEditingController();
  bool isPhone = Device.get().isPhone;

  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      sceneLocationText.text = widget.caseSceneLocation?.sceneLocation ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBarWidget(
        title: 'บริเวณที่เกิดเหตุ',
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
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      spacer(),
                      Text(
                        'เกิดเหตุดดที่*',
                        style: GoogleFonts.prompt(
                          textStyle: TextStyle(
                            color: Colors.white,
                            letterSpacing: 0.5,
                            fontSize:
                                MediaQuery.of(context).size.height * 0.025,
                          ),
                        ),
                      ),
                      spacer(),
                      InputField(
                          controller: sceneLocationText,
                          hint: 'กรอกบริเวณที่เกิดเหตุ',
                          onChanged: (value) {},
                          onFieldSubmitted: (value) {
                            Focus.of(context).nextFocus();
                          }),
                      spacer(),
                      saveButton()
                    ]),
              )),
        ),
      ),
    );
  }

  spacer() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.01,
    );
  }

  bool validate() {
    return sceneLocationText.text != '';
  }

  Widget saveButton() {
    return AppButton(
        color: pinkButton,
        textColor: Colors.white,
        text: 'บันทึก',
        onPressed: () async {
          if (validate()) {
            if (widget.isEdit) {
              await CaseSceneLocationDao().updateMyCaseSceneLocation(
                  sceneLocationText.text, widget.caseSceneLocation?.id ?? '');
            } else {
              await CaseSceneLocationDao()
                  .createCaseSceneLocationBomb(
                      sceneLocationText.text, widget.caseID ?? -1)
                  .then((value) => Navigator.of(context).pop(true));
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                'กรุณากรอกข้อมูลที่มีเครื่องหมายดอกจัน (*) ให้ครบถ้วน',
                textAlign: TextAlign.center,
                style: GoogleFonts.prompt(
                  textStyle: TextStyle(
                    color: Colors.white,
                    letterSpacing: .5,
                    fontSize: MediaQuery.of(context).size.height * 0.02,
                  ),
                ),
              ),
            ));
          }
        });
  }
}
