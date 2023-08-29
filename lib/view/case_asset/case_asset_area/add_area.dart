import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/color.dart';
import '../../../models/CaseAssetArea.dart';
import '../../../widget/app_bar_widget.dart';
import '../../../widget/app_button.dart';
import '../../../widget/text_field_widget.dart';

class AddAreaPage extends StatefulWidget {
  final int? caseID;
  final String? caseNo;
  final bool isEdit;
  final CaseAssetArea? caseAssetArea;

  const AddAreaPage(
      {super.key,
      this.caseID,
      this.caseNo,
      this.isEdit = false,
      this.caseAssetArea});
  @override
  AddAreaPageState createState() => AddAreaPageState();
}

class AddAreaPageState extends State<AddAreaPage> {
  bool isPhone = Device.get().isPhone;
  TextEditingController areaController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBarWidget(
        title: 'บริเวณ',
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
              child: contentWidget()),
        ),
      ),
    );
  }

  contentWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.015,
        ),
        Text(
          'บริเวณที่ตรวจพบ',
          textAlign: TextAlign.left,
          style: GoogleFonts.prompt(
            textStyle: TextStyle(
              color: Colors.white,
              letterSpacing: .5,
              fontSize: MediaQuery.of(context).size.height * 0.03,
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.015,
        ),
        InputField(
          controller: areaController,
          hint: 'กรอกบริเวณ',
          onChanged: (_) {},
        ),
        saveButton()
      ],
    );
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
              CaseAssetAreaDao().createCaseAssetArea(
                  widget.caseID.toString(), areaController.text);
              Navigator.of(context).pop(true);

              // await Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => CaseAssetAreaForm(
              //             caseAssetArea: widget.caseAssetArea,
              //             caseID: widget.caseID ?? -1,
              //             caseNo: widget.caseNo,
              //             isEdit: false,
              //             area: areaController.text)));
            }));
  }
}
