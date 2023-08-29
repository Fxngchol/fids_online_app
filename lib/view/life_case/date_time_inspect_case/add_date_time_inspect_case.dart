import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:google_fonts/google_fonts.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

import '../../../Utils/color.dart';
import '../../../models/CaseInspection.dart';
import '../../../widget/app_bar_widget.dart';
import '../../../widget/app_button.dart';
import '../../../widget/textfield_modal_bottom_sheet.dart'; //for date format

class AddDateTimeInspectCase extends StatefulWidget {
  final int? caseID;
  final String? caseNo;
  final bool isLocal;

  const AddDateTimeInspectCase(
      {super.key, this.caseID, this.caseNo, this.isLocal = false});

  @override
  AddDateTimeInspectCaseState createState() => AddDateTimeInspectCaseState();
}

class AddDateTimeInspectCaseState extends State<AddDateTimeInspectCase> {
  bool isPhone = Device.get().isPhone;
  DateTime caseIssueDate = DateTime.now();
  final TextEditingController _caseIssueDateController =
      TextEditingController();
  final TextEditingController _caseIssueTimeController =
      TextEditingController();
  String? time = '';

  CaseInspection caseInspection = CaseInspection();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBarWidget(
          title: 'วันเวลาที่ตรวจเหตุ',
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
                    headerView(),
                    header('วันที่*'),
                    spacer(context),
                    dateView(),
                    spacer(context),
                    spacer(context),
                    header('เวลาประมาณ*'),
                    spacer(context),
                    timeView(),
                    spacer(context),
                    spacer(context),
                    saveButton(),
                    spacer(context),
                  ])),
            )));
  }

  Widget headerView() {
    return Padding(
      padding: const EdgeInsets.only(left: 24, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            'วันเวลาที่ตรวจสถานที่เกิดเหตุ',
            textAlign: TextAlign.center,
            style: GoogleFonts.prompt(
              textStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                letterSpacing: .5,
                fontSize: MediaQuery.of(context).size.height * 0.025,
              ),
            ),
          ),
        ],
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

  dateView() {
    return TextFieldModalBottomSheet(
      controller: _caseIssueDateController,
      hint: 'กรุณาเลือกวันที่',
      onPress: () async {
        DateTime? newDateTime = await showRoundedDatePicker(
            theme: ThemeData(
              primarySwatch: Colors.pink,
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  textStyle: GoogleFonts.prompt(
                      textStyle: TextStyle(
                    color: pinkButton,
                    letterSpacing: .5,
                    fontSize: isPhone
                        ? MediaQuery.of(context).size.height * 0.018
                        : MediaQuery.of(context).size.height * 0.025,
                    fontWeight: FontWeight.bold,
                  )),
                ),
              ),
            ),
            fontFamily: GoogleFonts.prompt().fontFamily,
            context: context,
            initialDate: DateTime.now(),
            borderRadius: 16,
            locale: const Locale("th", "TH"),
            era: EraMode.BUDDHIST_YEAR);

        setState(() {
          final dateFormat = DateFormat('dd/MM/yyyy');
          var result = convertToBudd(dateFormat.format(newDateTime!));
          _caseIssueDateController.text = result ?? '';
          caseIssueDate = DateFormat('dd/MM/yyyy').parse(result ?? '');
        });
      },
    );
  }

  String? convertToBudd(String? date) {
    var start = date?.substring(0, 6);
    var process = date?.substring(6, 10);
    var cal = int.parse(process ?? '') + 543;
    var result = '$start$cal';
    return result;
  }

  timeView() {
    var timeformat = DateFormat('HH:mm');
    DateTime caseIssueTime = DateTime.now();
    return TextFieldModalBottomSheet(
      controller: _caseIssueTimeController,
      hint: 'กรุณาเลือกเวลา',
      onPress: () => {
        FocusScope.of(context).unfocus(),
        _caseIssueTimeController.text = timeformat.format(caseIssueTime),
        DatePicker.showTimePicker(context,
            // showSecondsColumn: false,
            // theme: DatePickerTheme(
            //   containerHeight: MediaQuery.of(context).size.height * 0.3,
            //   doneStyle: TextStyle(
            //       fontFamily: GoogleFonts.prompt().fontFamily,
            //       fontSize: MediaQuery.of(context).size.height * 0.02,
            //       color: darkBlue),
            //   cancelStyle: TextStyle(
            //       fontFamily: GoogleFonts.prompt().fontFamily,
            //       fontSize: MediaQuery.of(context).size.height * 0.02,
            //       color: Colors.grey),
            //   itemStyle: TextStyle(
            //       fontFamily: GoogleFonts.prompt().fontFamily,
            //       fontSize: MediaQuery.of(context).size.height * 0.02,
            //       color: darkBlue),
            // ),
            showTitleActions: true,
            onChanged: (date) {}, onConfirm: (date) {
          var inputDate = timeformat.format(date);
          time = inputDate;
          _caseIssueTimeController.text = inputDate;
          if (kDebugMode) {
            print(time);
          }
        }, currentTime: DateTime.now(), locale: LocaleType.th)
      },
    );
  }

  // Widget _buildBottomPicker(Widget picker) {
  //   return Container(
  //     height: MediaQuery.of(context).size.height / 3,
  //     padding: const EdgeInsets.only(top: 6.0),
  //     color: CupertinoColors.white,
  //     child: DefaultTextStyle(
  //       style: GoogleFonts.prompt(
  //           textStyle: TextStyle(
  //         color: darkBlue,
  //         letterSpacing: 0.5,
  //         fontSize: MediaQuery.of(context).size.height * 0.02,
  //       )),
  //       child: GestureDetector(
  //         onTap: () {},
  //         child: SafeArea(
  //           top: false,
  //           child: picker,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget saveButton() {
    return AppButton(
        color: pinkButton,
        textColor: Colors.white,
        text: 'บันทึก',
        onPressed: () {
          if (validate()) {
            caseInspection.inspectDate = _caseIssueDateController.text;
            caseInspection.inspectTime = _caseIssueTimeController.text;
            if (kDebugMode) {
              print(
                  '${caseInspection.inspectDate} ${caseInspection.inspectTime}');
            }
            CaseInspectionDao().createCaseInspection(
                caseInspection.inspectDate ?? '',
                caseInspection.inspectTime ?? '',
                1,
                widget.caseID ?? -1);
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
    return _caseIssueDateController.text != '' &&
        _caseIssueTimeController.text != '';
  }
}
