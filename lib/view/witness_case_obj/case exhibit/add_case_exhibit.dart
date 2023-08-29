import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/color.dart';
import '../../../models/CaseExhibit.dart';
import '../../../widget/app_bar_widget.dart';
import '../../../widget/app_button.dart';
import '../../../widget/text_field_widget.dart';

class AddCaseExhibit extends StatefulWidget {
  final int? caseID;
  final String? caseNo;
  final bool isEdit;
  final int caseExhibitById;

  const AddCaseExhibit(
      {super.key,
      required this.caseID,
      this.caseNo,
      this.isEdit = false,
      required this.caseExhibitById});

  @override
  AddCaseExhibitState createState() => AddCaseExhibitState();
}

class AddCaseExhibitState extends State<AddCaseExhibit> {
  bool isPhone = Device.get().isPhone;
  bool isLoading = false;
  CaseExhibit caseExhibit = CaseExhibit();
  TextEditingController exhibitNameController = TextEditingController();
  TextEditingController exhibitDetailController = TextEditingController();
  TextEditingController exhibitAmountController = TextEditingController();
  TextEditingController exhibitUnitController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      print(widget.caseExhibitById);
      print(widget.isEdit);
    }

    if (widget.isEdit) {
      asyncMethod();
    }
  }

  asyncMethod() async {
    asyncCall1();
  }

  void asyncCall1() async {
    CaseExhibitDao()
        .getCaseExhibitById(widget.caseID ?? -1, widget.caseExhibitById)
        .then((value) {
      caseExhibit = value;
      exhibitNameController.text = caseExhibit.exhibitName ?? '';
      exhibitDetailController.text = caseExhibit.exhibitDetail ?? '';
      exhibitAmountController.text = caseExhibit.exhibitAmount ?? '';
      exhibitUnitController.text = caseExhibit.exhibitUnit ?? '';
    });

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBarWidget(
        title: 'เพิ่มของกลาง',
        actions: [
          Container(
            width: MediaQuery.of(context).size.width * 0.1,
          )
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/bgNew.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  children: [
                    Container(
                      margin: isPhone
                          ? const EdgeInsets.all(32)
                          : const EdgeInsets.only(
                              left: 32, right: 32, top: 32, bottom: 32),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            header('ของกลาง'),
                            spacer(context),
                            InputField(
                                controller: exhibitNameController,
                                hint: 'กรอกของกลาง',
                                onChanged: (value) {}),
                            spacer(context),
                            header('รายละเอียด'),
                            spacer(context),
                            InputField(
                                controller: exhibitDetailController,
                                hint: 'กรอกรายละเอียด',
                                onChanged: (value) {}),
                            spacer(context),
                            header('จำนวน'),
                            spacer(context),
                            InputField(
                                controller: exhibitAmountController,
                                hint: 'กรอกจำนวน',
                                onChanged: (value) {}),
                            spacer(context),
                            header('หน่วยนับ'),
                            spacer(context),
                            InputField(
                                controller: exhibitUnitController,
                                hint: 'กรอกหน่วยนับ',
                                onChanged: (value) {}),
                            spacer(context),
                            spacer(context),
                            save()
                          ]),
                    ),
                  ],
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

  save() {
    return AppButton(
      color: pinkButton,
      onPressed: () {
        if (widget.isEdit) {
          CaseExhibitDao().updateCaseExhibit(
              exhibitNameController.text,
              exhibitDetailController.text,
              exhibitAmountController.text,
              exhibitUnitController.text,
              widget.caseExhibitById);
          Navigator.of(context).pop(true);
        } else {
          CaseExhibitDao().createCaseExhibit(
              widget.caseID ?? -1,
              exhibitNameController.text,
              exhibitDetailController.text,
              exhibitAmountController.text,
              exhibitUnitController.text);
          Navigator.of(context).pop(true);
        }
      },
      text: 'บันทึก',
      textColor: Colors.white,
    );
  }
}
