import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/color.dart';
import '../../../models/CaseInternal.dart';
import '../../../widget/app_bar_widget.dart';
import '../../../widget/app_button.dart';
import '../../../widget/text_field_widget.dart';

class EditCrimeSceneSecondTab extends StatefulWidget {
  final int? caseID;
  final String? caseNo;
  final bool isLocal;
  final bool isEdit;
  final CaseInternal? caseInternal;

  const EditCrimeSceneSecondTab(
      {super.key,
      this.caseID,
      this.caseNo,
      this.isLocal = false,
      this.isEdit = false,
      this.caseInternal});

  @override
  EditCrimeSceneSecondTabState createState() => EditCrimeSceneSecondTabState();
}

class EditCrimeSceneSecondTabState extends State<EditCrimeSceneSecondTab> {
  TextEditingController floorNoText = TextEditingController();
  TextEditingController floorDetailText = TextEditingController();
  bool isPhone = Device.get().isPhone;

  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      floorNoText.text = widget.caseInternal?.floorNo ?? '';
      floorDetailText.text = widget.caseInternal?.floorDetail ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBarWidget(
        title: 'ลักษณะภายใน',
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
                child: Column(children: [
                  spacer(),
                  title('ชั้น*'),
                  spacer(),
                  InputField(
                      controller: floorNoText,
                      hint: 'กรอกชั้น',
                      onChanged: (value) {},
                      onFieldSubmitted: (value) {
                        Focus.of(context).nextFocus();
                      }),
                  spacer(),
                  title('รายละเอียด*'),
                  spacer(),
                  InputField(
                      controller: floorDetailText,
                      hint: 'กรอกรายละเอียด',
                      onChanged: (value) {},
                      onFieldSubmitted: (value) {
                        Focus.of(context).unfocus();
                      }),
                  spacer(),
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

  Widget title(String? title) {
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

  bool validate() {
    return floorNoText.text != '' && floorDetailText.text != '';
  }

  Widget saveButton() {
    return AppButton(
        color: pinkButton,
        textColor: Colors.white,
        text: 'บันทึก',
        onPressed: () async {
          if (validate()) {
            if (widget.isEdit) {
              await CaseInternalDao()
                  .updateMyCaseInternal(floorNoText.text, floorDetailText.text,
                      widget.caseInternal?.id ?? '')
                  .then((value) => Navigator.of(context).pop(true));
            } else {
              await CaseInternalDao()
                  .createCaseInternal(floorNoText.text, floorDetailText.text,
                      widget.caseID ?? -1, '', '', '', '', 1)
                  .then((value) => Navigator.of(context).pop(true));
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
            ));
          }
        });
  }
}
