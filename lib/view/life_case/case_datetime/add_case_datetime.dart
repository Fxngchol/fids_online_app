import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:google_fonts/google_fonts.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

import '../../../Utils/color.dart';
import '../../../models/CaseCategory.dart';
import '../../../models/FidsCrimeScene.dart';
import '../../../widget/app_bar_widget.dart';
import '../../../widget/app_button.dart';
import '../../../widget/text_field_widget.dart';
import '../../../widget/textfield_modal_bottom_sheet.dart'; //for date format

class AddCaseDateTime extends StatefulWidget {
  final int? caseID;
  final String? caseNo;
  final bool isLocal;

  const AddCaseDateTime(
      {super.key, this.caseID, this.caseNo, this.isLocal = false});

  @override
  AddCaseDateTimeState createState() => AddCaseDateTimeState();
}

class AddCaseDateTimeState extends State<AddCaseDateTime> {
  bool isPhone = Device.get().isPhone;
  DateTime victimDate = DateTime.now();
  DateTime officerDate = DateTime.now();

  String? victimTime = '';
  String? officerTime = '';

  int isCaseNotification = -1;
  final TextEditingController _victimDateController = TextEditingController();
  final TextEditingController _victimTimeController = TextEditingController();
  final TextEditingController _officerDateController = TextEditingController();
  final TextEditingController _officerTimeController = TextEditingController();
  String? caseName;
  FidsCrimeScene? data;

  @override
  void initState() {
    super.initState();
    asyncMethod();
  }

  asyncMethod() async {
    asyncCall1();
    setRadio();
  }

  void asyncCall1() async {
    var result =
        await FidsCrimeSceneDao().getFidsCrimeSceneById(widget.caseID ?? -1);
    await CaseCategoryDAO()
        .getCaseCategoryLabelByid(result?.caseCategoryID ?? -1)
        .then((value) => caseName = value);
    setState(() {
      data = result;
      isCaseNotification = data?.isCaseNotification ?? -1;
      _victimDateController.text = data?.caseVictimDate ?? '';
      _victimTimeController.text = data?.caseVictimTime ?? '';

      _officerDateController.text = data?.caseOfficerDate ?? '';
      _officerTimeController.text = data?.caseOfficerTime ?? '';
    });
  }

  void setRadio() {
    try {
      setState(() {
        if (data?.isCaseNotification == 1) {
          _radioValue = 0;
        } else {
          _radioValue = 1;
        }
      });
    } catch (ex) {
      _radioValue = -1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        // resizeToAvoidBottomInset: false,
        appBar: AppBarWidget(
          title: 'วันเวลาที่ทราบเหตุ/เกิดเหตุ',
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
                  headerRaidoView(),
                  spacer(),
                  victimView(),
                  titleWidget('วันที่'),
                  spacer(),
                  victimDateView(),
                  spacer(),
                  titleWidget('เวลาประมาณ'),
                  spacer(),
                  victimTimeView(),
                  spacer(),
                  officerView(),
                  spacer(),
                  titleWidget('วันที่'),
                  spacer(),
                  officerDateView(),
                  spacer(),
                  titleWidget('เวลาประมาณ*'),
                  spacer(),
                  officerTimeView(),
                  spacer(),
                  saveButton()
                ],
              ),
            ),
          ),
        ));
  }

  Widget headerRaidoView() {
    return Padding(
      padding: const EdgeInsets.only(left: 24, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            'หมายเลขคดี',
            textAlign: TextAlign.center,
            style: GoogleFonts.prompt(
              textStyle: TextStyle(
                color: Colors.white,
                letterSpacing: .5,
                fontSize: MediaQuery.of(context).size.height * 0.025,
              ),
            ),
          ),
          Text(
            '${widget.caseNo}',
            textAlign: TextAlign.center,
            style: GoogleFonts.prompt(
              textStyle: TextStyle(
                color: Colors.white,
                letterSpacing: .5,
                fontSize: MediaQuery.of(context).size.height * 0.03,
              ),
            ),
          ),
          Text(
            'ประเภทคดี : $caseName',
            textAlign: TextAlign.center,
            style: GoogleFonts.prompt(
              textStyle: TextStyle(
                color: Colors.white,
                letterSpacing: .5,
                fontSize: MediaQuery.of(context).size.height * 0.025,
              ),
            ),
          )
        ],
      ),
    );
  }

  int _radioValue = 0;

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;
      switch (_radioValue) {
        case 0:
          isCaseNotification = 1;
          if (kDebugMode) {
            print(isCaseNotification);
          }
          break;
        case 1:
          isCaseNotification = 2;
          if (kDebugMode) {
            print(isCaseNotification);
          }
          break;
      }
    });
  }

  Widget victimView() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            'วันเวลาที่ผู้เสียหาย ทราบเหตุ/เกิดเหตุ',
            textAlign: TextAlign.center,
            style: GoogleFonts.prompt(
              textStyle: TextStyle(
                color: Colors.white,
                letterSpacing: .5,
                fontSize: MediaQuery.of(context).size.height * 0.03,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Transform.scale(
                scale: 1.2,
                child: Radio(
                  value: 0,
                  activeColor: pinkButton,
                  groupValue: _radioValue,
                  onChanged: (val) {
                    _handleRadioValueChange(val ?? 0);
                  },
                ),
              ),
              Text(
                'ทราบเหตุ',
                textAlign: TextAlign.center,
                style: GoogleFonts.prompt(
                  textStyle: TextStyle(
                    color: Colors.white,
                    letterSpacing: .5,
                    fontSize: MediaQuery.of(context).size.height * 0.025,
                  ),
                ),
              ),
              Transform.scale(
                scale: 1.2,
                child: Radio(
                  value: 1,
                  activeColor: pinkButton,
                  groupValue: _radioValue,
                  onChanged: (val) {
                    _handleRadioValueChange(val ?? 0);
                  },
                ),
              ),
              Text(
                'เกิดเหตุ',
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
      ),
    );
  }

  Widget officerView() {
    return Padding(
      padding: const EdgeInsets.only(left: 24, bottom: 12, top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            'วันเวลาที่พนักงานสอบสวนทราบเหตุ',
            textAlign: TextAlign.center,
            style: GoogleFonts.prompt(
              textStyle: TextStyle(
                color: Colors.white,
                letterSpacing: .5,
                fontSize: MediaQuery.of(context).size.height * 0.03,
              ),
            ),
          ),
        ],
      ),
    );
  }

  spacer() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.01,
    );
  }

  Widget titleWidget(String? title) {
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

  timeField() {
    return InputField(
      hint: 'กรุณากรอกเวลา',
      onChanged: (value) {
        //print(value);
      },
      onFieldSubmitted: (value) {
        //print(value);
      },
    );
  }

  victimDateView() {
    return TextFieldModalBottomSheet(
      controller: _victimDateController,
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
          _victimDateController.text = result ?? '';
          victimDate = DateFormat('dd/MM/yyyy').parse(result ?? '');
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

  victimTimeView() {
    var timeformat = DateFormat('HH:mm');
    DateTime caseIssueTime = DateTime.now();
    return TextFieldModalBottomSheet(
      controller: _victimTimeController,
      hint: 'กรุณาเลือกเวลา',
      onPress: () => {
        FocusScope.of(context).unfocus(),
        _victimTimeController.text = timeformat.format(caseIssueTime),
        DatePicker.showTimePicker(context,
            showSecondsColumn: false,
            // theme: DatePickerTheme(
            //   doneStyle: TextStyle(
            //       fontFamily: GoogleFonts.prompt().fontFamily,
            //       fontSize: MediaQuery.of(context).size.height * 0.017,
            //       color: darkBlue),
            //   cancelStyle: TextStyle(
            //       fontFamily: GoogleFonts.prompt().fontFamily,
            //       fontSize: MediaQuery.of(context).size.height * 0.017,
            //       color: Colors.grey),
            //   itemStyle: TextStyle(
            //       fontFamily: GoogleFonts.prompt().fontFamily,
            //       fontSize: MediaQuery.of(context).size.height * 0.018,
            //       color: darkBlue),
            // ),
            showTitleActions: true,
            onChanged: (date) {}, onConfirm: (date) {
          var inputDate = timeformat.format(date);
          victimTime = inputDate;
          _victimTimeController.text = inputDate;
          if (kDebugMode) {
            print(victimTime);
          }
        }, currentTime: DateTime.now(), locale: LocaleType.th)
      },
    );
  }

  officerDateView() {
    return TextFieldModalBottomSheet(
        controller: _officerDateController,
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
            _officerDateController.text = result ?? '';
            officerDate = DateFormat('dd/MM/yyyy').parse(result ?? '');
          });
        });
  }

  officerTimeView() {
    var timeformat = DateFormat('HH:mm');
    DateTime caseIssueTime = DateTime.now();
    return TextFieldModalBottomSheet(
      controller: _officerTimeController,
      hint: 'กรุณาเลือกเวลา',
      onPress: () => {
        FocusScope.of(context).unfocus(),
        _officerTimeController.text = timeformat.format(caseIssueTime),
        DatePicker.showTimePicker(context,
            showSecondsColumn: false,
            // theme: DatePickerTheme(
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
          officerTime = inputDate;
          _officerTimeController.text = inputDate;
          if (kDebugMode) {
            print(officerTime);
          }
        }, currentTime: DateTime.now(), locale: LocaleType.th)
      },
    );
  }

  // ignore: unused_element
  Widget _buildBottomPicker(Widget picker) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      padding: const EdgeInsets.only(top: 6.0),
      color: CupertinoColors.white,
      child: DefaultTextStyle(
        style: GoogleFonts.prompt(
            textStyle: TextStyle(
          color: darkBlue,
          letterSpacing: 0.5,
          fontSize: MediaQuery.of(context).size.height * 0.02,
        )),
        child: GestureDetector(
          onTap: () {},
          child: SafeArea(
            top: false,
            child: picker,
          ),
        ),
      ),
    );
  }

  Widget saveButton() {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
      child: AppButton(
          color: pinkButton,
          textColor: Colors.white,
          text: 'บันทึกข้อมูล',
          onPressed: () {
            // print('วันเวลาที่ผู้เสียหายทราบเหตุ/เกิดเหตุ');
            // print('วันที่ ${_victimDateController.text}');
            // print('เวลาประมาณ ${_victimTimeController.text}');
            // print('วันเวลาที่พนักงานสอบสวนทราบเหตุ');
            // print('วันที่ ${_officerDateController.text}');
            // print('เวลาประมาณ ${_officerTimeController.text}');

            FidsCrimeSceneDao().updateCaseDateTime(
                isCaseNotification,
                _victimDateController.text,
                _victimTimeController.text,
                _officerDateController.text,
                _officerTimeController.text,
                '${widget.caseID}');

            Navigator.of(context).pop(true);
            // } else {
            //   final snackBar = SnackBar(
            //     content: Text(
            //       'กรุณากรอกข้อมูลที่มีเครื่องหมายดอกจัน (*) ให้​ครบถ้วน',
            //       textAlign: TextAlign.center,
            //       style: GoogleFonts.prompt(
            //         textStyle: TextStyle(
            //           color: Colors.white,
            //           letterSpacing: .5,
            //           fontSize: MediaQuery.of(context).size.height * 0.02,
            //         ),
            //       ),
            //     ),
            //   );
            //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
            // }
          }),
    );
  }

  // bool validate() {
  //   return _victimDateController.text != '' &&
  //       _officerDateController.text != '' &&
  //       _officerTimeController.text != '';
  // }
}
