// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../Utils/color.dart';
import '../../../widget/app_bar_widget.dart';
import '../../../widget/app_button.dart';
import '../../../widget/text_field_widget.dart';
import '../../../widget/textfield_modal_bottom_sheet.dart';

class AddWitnessCase extends StatefulWidget {
  const AddWitnessCase({super.key});

  @override
  AddWitnessCaseState createState() => AddWitnessCaseState();
}

class AddWitnessCaseState extends State<AddWitnessCase> {
  bool isPhone = Device.get().isPhone;
  DateTime witnessDate = DateTime.now();

  final TextEditingController _witnessDateController = TextEditingController();
  final TextEditingController _witnessTimeController = TextEditingController();
  final TextEditingController _packController = TextEditingController();
  final TextEditingController _processController = TextEditingController();

  String? witnessTime = '';

  List packList = ['item1', 'item2', 'item3'];
  List processList = ['item1', 'item2', 'item3'];

  int _packIndexSelected = 0;
  int _processIndexSelected = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(
          title: 'จัดเก็บวัตถุพยาน',
          actions: [
            Container(
              width: MediaQuery.of(context).size.width * 0.1,
            )
          ],
        ),
        body: Container(
            color: darkBlue,
            child: SafeArea(
                child: Container(
                    margin: isPhone
                        ? const EdgeInsets.all(32)
                        : const EdgeInsets.only(
                            left: 32, right: 32, top: 32, bottom: 32),
                    child: ListView(children: [
                      header('วัตถุพยาน'),
                      spacer(context),
                      InputField(hint: 'กรอกวัตถุพยาน', onChanged: (value) {}),
                      spacer(context),
                      header('ป้ายหมายเลข'),
                      spacer(context),
                      InputField(
                          hint: 'กรอกป้ายหมายเลข', onChanged: (value) {}),
                      spacer(context),
                      header('จำนวน'),
                      spacer(context),
                      InputField(hint: 'กรอกจำนวน', onChanged: (value) {}),
                      spacer(context),
                      header('บริเวณที่ตรวจพบ'),
                      spacer(context),
                      InputField(
                          hint: 'กรอกบริเวณที่ตรวจพบ',
                          maxLine: 4,
                          onChanged: (value) {}),
                      spacer(context),
                      header('วันเวลาที่ตรวจเก็บวัตถุพยาน'),
                      spacer(context),
                      witnessDateView(),
                      spacer(context),
                      witnessTimeView(),
                      spacer(context),
                      header('บรรจุหีบห่อ'),
                      spacer(context),
                      packModal(),
                      spacer(context),
                      header('การดำเนินการ'),
                      processModal(),
                      spacer(context),
                      header('หมายเหตุ'),
                      spacer(context),
                      InputField(
                          hint: 'กรอกหมายเหตุ',
                          maxLine: 4,
                          onChanged: (value) {}),
                      spacer(context),
                      spacer(context),
                      saveButton(),
                      spacer(context),
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

  witnessDateView() {
    return TextFieldModalBottomSheet(
      controller: _witnessDateController,
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
          _witnessDateController.text = result ?? '';
          witnessDate = DateFormat('dd/MM/yyyy').parse(result ?? '');
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

  witnessTimeView() {
    var timeformat = DateFormat('HH:mm');
    DateTime caseIssueTime = DateTime.now();
    return TextFieldModalBottomSheet(
      controller: _witnessTimeController,
      hint: 'กรุณาเลือกเวลา',
      onPress: () => {
        FocusScope.of(context).unfocus(),
        _witnessTimeController.text = timeformat.format(caseIssueTime),
        DatePicker.showTimePicker(context,
            showSecondsColumn: false,
            showTitleActions: true,
            onChanged: (date) {}, onConfirm: (date) {
          var inputDate = timeformat.format(date);
          witnessTime = inputDate;
          _witnessTimeController.text = inputDate;
          if (kDebugMode) {
            print(witnessTime);
          }
        }, currentTime: DateTime.now(), locale: LocaleType.th)
      },
    );
  }

  Widget packModal() {
    return TextFieldModalBottomSheet(
      controller: _packController,
      hint: 'เพิ่มผู้ตรวจสถานที่เกิดเหตุ',
      onPress: () => {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
                color: Colors.transparent,
                child: SizedBox(
                  height: MediaQuery.of(context).copyWith().size.height / 3,
                  child: Scaffold(
                    appBar: AppBar(
                      backgroundColor: Colors.white,
                      bottomOpacity: 0.3,
                      elevation: 0.5,
                      automaticallyImplyLeading: false,
                      titleSpacing: 0.0,
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          MaterialButton(
                            child: Text('ยกเลิก',
                                style: GoogleFonts.prompt(
                                    textStyle: TextStyle(
                                  color: darkBlue,
                                  letterSpacing: 0.5,
                                  fontSize:
                                      MediaQuery.of(context).size.height * 0.02,
                                ))),
                            onPressed: () {
                              if (_packController.text == '') {
                                _packController.clear();
                                _packIndexSelected = 0;
                              }
                              Navigator.pop(context);
                            },
                          ),
                          Text('เลือกประเภทคดี',
                              style: GoogleFonts.prompt(
                                  textStyle: TextStyle(
                                color: darkBlue,
                                letterSpacing: 0.5,
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.025,
                              ))),
                          MaterialButton(
                              child: Text('เลือก',
                                  style: GoogleFonts.prompt(
                                      textStyle: TextStyle(
                                    color: darkBlue,
                                    letterSpacing: 0.5,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.02,
                                  ))),
                              onPressed: () {
                                Navigator.pop(context);
                                setState(() {
                                  _packController.text =
                                      packList[_packIndexSelected];
                                });
                              }),
                        ],
                      ),
                    ),
                    body: CupertinoPicker(
                        squeeze: 1.5,
                        diameterRatio: 1,
                        useMagnifier: true,
                        looping: false,
                        scrollController: FixedExtentScrollController(
                          initialItem: _packIndexSelected,
                        ),
                        itemExtent: isPhone ? 40.0 : 50.0,
                        backgroundColor: Colors.white,
                        onSelectedItemChanged: (int index) => setState(() {
                              _packIndexSelected = index;
                            }),
                        children:
                            List<Widget>.generate(packList.length, (int index) {
                          return Center(
                            child: Text(
                              packList[index],
                              style: GoogleFonts.prompt(
                                textStyle: TextStyle(
                                  color: darkBlue,
                                  letterSpacing: 0.5,
                                  fontSize:
                                      MediaQuery.of(context).size.height * 0.02,
                                ),
                              ),
                            ),
                          );
                        })),
                  ),
                ));
          },
        )
      },
    );
  }

  Widget processModal() {
    return TextFieldModalBottomSheet(
      controller: _processController,
      hint: 'เพิ่มผู้ตรวจสถานที่เกิดเหตุ',
      onPress: () => {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
                color: Colors.transparent,
                child: SizedBox(
                  height: MediaQuery.of(context).copyWith().size.height / 3,
                  child: Scaffold(
                    appBar: AppBar(
                      backgroundColor: Colors.white,
                      bottomOpacity: 0.3,
                      elevation: 0.5,
                      automaticallyImplyLeading: false,
                      titleSpacing: 0.0,
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          MaterialButton(
                            child: Text('ยกเลิก',
                                style: GoogleFonts.prompt(
                                    textStyle: TextStyle(
                                  color: darkBlue,
                                  letterSpacing: 0.5,
                                  fontSize:
                                      MediaQuery.of(context).size.height * 0.02,
                                ))),
                            onPressed: () {
                              if (_processController.text == '') {
                                _processController.clear();
                                _processIndexSelected = 0;
                              }
                              Navigator.pop(context);
                            },
                          ),
                          Text('เลือกประเภทคดี',
                              style: GoogleFonts.prompt(
                                  textStyle: TextStyle(
                                color: darkBlue,
                                letterSpacing: 0.5,
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.025,
                              ))),
                          MaterialButton(
                              child: Text('เลือก',
                                  style: GoogleFonts.prompt(
                                      textStyle: TextStyle(
                                    color: darkBlue,
                                    letterSpacing: 0.5,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.02,
                                  ))),
                              onPressed: () {
                                Navigator.pop(context);
                                setState(() {
                                  _processController.text =
                                      processList[_processIndexSelected];
                                });
                              }),
                        ],
                      ),
                    ),
                    body: CupertinoPicker(
                        squeeze: 1.5,
                        diameterRatio: 1,
                        useMagnifier: true,
                        looping: false,
                        scrollController: FixedExtentScrollController(
                          initialItem: _processIndexSelected,
                        ),
                        itemExtent: isPhone ? 40.0 : 50.0,
                        backgroundColor: Colors.white,
                        onSelectedItemChanged: (int index) => setState(() {
                              _processIndexSelected = index;
                            }),
                        children: List<Widget>.generate(processList.length,
                            (int index) {
                          return Center(
                            child: Text(
                              processList[index],
                              style: GoogleFonts.prompt(
                                textStyle: TextStyle(
                                  color: darkBlue,
                                  letterSpacing: 0.5,
                                  fontSize:
                                      MediaQuery.of(context).size.height * 0.02,
                                ),
                              ),
                            ),
                          );
                        })),
                  ),
                ));
          },
        )
      },
    );
  }

  Widget saveButton() {
    return AppButton(
        color: pinkButton,
        textColor: Colors.white,
        text: 'บันทึก',
        onPressed: () {
          // Navigator.pushReplacementNamed(context, '/home');
          Navigator.of(context).pop();
        });
  }
}
