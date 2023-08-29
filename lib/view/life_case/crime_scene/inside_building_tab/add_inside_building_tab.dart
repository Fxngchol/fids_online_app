import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../Utils/color.dart';
import '../../../../models/CaseInternal.dart';
import '../../../../widget/app_bar_widget.dart';
import '../../../../widget/app_button.dart';
import '../../../../widget/text_field_widget.dart';

class AddInsideBuilding extends StatefulWidget {
  final int? caseID;
  final String? caseNo;
  final bool isLocal;
  final bool isEdit;
  final String? insideID;

  const AddInsideBuilding(
      {super.key,
      this.caseID,
      this.caseNo,
      this.isLocal = false,
      this.isEdit = false,
      this.insideID});

  @override
  AddInsideBuildingState createState() => AddInsideBuildingState();
}

class AddInsideBuildingState extends State<AddInsideBuilding> {
  final TextEditingController _floorNoController = TextEditingController();
  final TextEditingController _floorDetailController = TextEditingController();
  bool isPhone = Device.get().isPhone;
  CaseInternal caseInternal = CaseInternal();
  @override
  void initState() {
    super.initState();
    setupData();
  }

  setupData() async {
    if (widget.isEdit) {
      CaseInternal result =
          await CaseInternalDao().getCaseInternalById(widget.insideID ?? '');
      caseInternal = result;
      _floorNoController.text = caseInternal.floorNo ?? '';
      _floorDetailController.text = caseInternal.floorDetail ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBarWidget(
        title: 'เพิ่มลักษณะภายใน',
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
                subtitle('ชั้น', true),
                spacer(),
                textField(_floorNoController, 'กรอกชั้น', (value) {},
                    (_) => node.nextFocus()),
                spacerTitle(),
                subtitle('รายละเอียด', true),
                spacer(),
                InputField(
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    controller: _floorDetailController,
                    hint: 'กรอกรายละเอียด',
                    maxLine: null,
                    onChanged: (value) {}),
                spacerTitle(),
                saveButton()
              ],
            ),
          ),
        ),
      ),
    );
  }

  spacerTitle() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.015,
    );
  }

  spacer() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.01,
    );
  }

  Widget subtitle(String? title, bool isRequire) {
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
        isRequire
            ? Text(
                '*',
                style: GoogleFonts.prompt(
                  textStyle: TextStyle(
                    color: Colors.white,
                    letterSpacing: 0.5,
                    fontSize: MediaQuery.of(context).size.height * 0.025,
                  ),
                ),
              )
            : Text(
                '',
                style: GoogleFonts.prompt(
                  textStyle: TextStyle(
                    color: Colors.white,
                    letterSpacing: 0.5,
                    fontSize: MediaQuery.of(context).size.height * 0.025,
                  ),
                ),
              )
      ],
    );
  }

  textField(
    TextEditingController controller,
    String? hint,
    Function onChanged,
    Function onFieldSubmitted,
  ) {
    return InputField(
      controller: controller,
      hint: '$hint',
      onChanged: (str) {
        onChanged(str);
      },
      onFieldSubmitted: onFieldSubmitted,
    );
  }

  bool validate() {
    return _floorNoController.text != '' && _floorDetailController.text != '';
  }

  Widget saveButton() {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
      child: AppButton(
          color: pinkButton,
          textColor: Colors.white,
          text: 'บันทึกข้อมูล',
          onPressed: () {
            if (kDebugMode) {
              print('ชั้น ${_floorNoController.text}');
              print('รายละเอียด ${_floorDetailController.text}');
            }

            if (validate()) {
              if (widget.isEdit) {
                CaseInternalDao().updateCaseInternal(
                    widget.caseID ?? -1,
                    _floorNoController.text,
                    _floorDetailController.text,
                    int.parse(widget.insideID ?? ''));
              } else {
                CaseInternalDao().createCaseInternal(
                    _floorNoController.text,
                    _floorDetailController.text,
                    widget.caseID ?? -1,
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
          }),
    );
  }
}
