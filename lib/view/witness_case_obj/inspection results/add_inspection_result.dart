// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../Utils/color.dart';
import '../../../models/CaseCategory.dart';
import '../../../models/FidsCrimeScene.dart';
import '../../../widget/app_bar_widget.dart';
import '../../../widget/app_button.dart';
import '../../../widget/text_field_widget.dart';
import '../../../widget/textfield_modal_bottom_sheet.dart';

class AddInspectionResultCase extends StatefulWidget {
  final int? caseID;
  final String? caseNo;
  final bool isLocal;

  const AddInspectionResultCase(
      {super.key, required this.caseID, this.caseNo, this.isLocal = false});

  @override
  ResultCaseState createState() => ResultCaseState();
}

class ResultCaseState extends State<AddInspectionResultCase> {
  bool isPhone = Device.get().isPhone;
  bool isLoading = true;
  FidsCrimeScene fidsCrimeScene = FidsCrimeScene();
  String? caseName;

  TextEditingController objectiveController = TextEditingController();
  TextEditingController exhibitLocationController = TextEditingController();
  TextEditingController exhibitDateController = TextEditingController();
  TextEditingController exhibitTimeController = TextEditingController();

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
    fidsCrimeScene = result ?? FidsCrimeScene();
    await CaseCategoryDAO()
        .getCaseCategoryLabelByid(fidsCrimeScene.caseCategoryID!)
        .then((value) => caseName = value);
    setState(() {
      isLoading = false;
    });

    objectiveController.text = fidsCrimeScene.objective ?? '';
    exhibitLocationController.text = fidsCrimeScene.exhibitLocation ?? '';
    exhibitDateController.text = fidsCrimeScene.exhibitDate ?? '';
    exhibitTimeController.text = fidsCrimeScene.exhibitTime ?? '';
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: const AppBarWidget(
          title: 'ผลการตรวจสถานที่เกิดเหตุ',
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
                      header('จุดประสงค์ในการตรวจ'),
                      InputField(
                          controller: objectiveController,
                          hint: 'กรอกจุดประสงค์ในการตรวจ',
                          onChanged: (val) {}),
                      spacer(context),
                      header('ได้ทำการตรวจของกลางที่'),
                      InputField(
                          controller: exhibitLocationController,
                          hint: 'กรอกจุดประสงค์ในการตรวจ',
                          onChanged: (val) {}),
                      spacer(context),
                      header('วันที่'),
                      dateField(),
                      spacer(context),
                      header('เวลา'),
                      timeBottomSheet(),
                      spacer(context),
                      spacer(context),
                      save()
                    ])))));
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

  dateField() {
    return TextFieldModalBottomSheet(
      controller: exhibitDateController,
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
          exhibitDateController.text = result!;
          // caseIssueDateTime = DateFormat('dd/MM/yyyy').parse(result);
        });
      },
    );
  }

  String? convertToBudd(String? date) {
    var start = date!.substring(0, 6);
    var process = date.substring(6, 10);
    var cal = int.parse(process) + 543;
    var result = '$start$cal';
    return result;
  }

  timeBottomSheet() {
    var timeformat = DateFormat('HH:mm');
    DateTime caseIssueTime = DateTime.now();
    return TextFieldModalBottomSheet(
      controller: exhibitTimeController,
      hint: 'กรุณาเลือกเวลา',
      onPress: () => {
        // ignore: avoid_print
        print('object ${timeformat.format(caseIssueTime)}'),
        FocusScope.of(context).unfocus(),
        exhibitTimeController.text = timeformat.format(caseIssueTime),
        DatePicker.showTimePicker(context,
            showTitleActions: true, onChanged: (date) {}, onConfirm: (date) {
          var inputDate = timeformat.format(date);
          exhibitTimeController.text = inputDate;
        }, currentTime: DateTime.now(), locale: LocaleType.th)
      },
    );
  }

  save() {
    return AppButton(
        color: pinkButton,
        textColor: Colors.white,
        text: 'บันทึก',
        onPressed: () {
          FidsCrimeSceneDao().updateInspectionResult(
              objectiveController.text,
              exhibitLocationController.text,
              exhibitDateController.text,
              exhibitTimeController.text,
              widget.caseID.toString());
          Navigator.of(context).pop(true);
        });
  }
}
