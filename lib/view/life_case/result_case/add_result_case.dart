import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/color.dart';
import '../../../models/FidsCrimeScene.dart';
import '../../../widget/app_bar_widget.dart';
import '../../../widget/app_button.dart';
import '../../../widget/text_field_widget.dart';

class AddResultCase extends StatefulWidget {
  final int? caseID;
  final bool? isLocal, isWitnessCase;

  const AddResultCase(
      {super.key,
      this.caseID,
      this.isLocal = false,
      this.isWitnessCase = false});

  @override
  AddResultCaseState createState() => AddResultCaseState();
}

class AddResultCaseState extends State<AddResultCase> {
  bool isPhone = Device.get().isPhone;

  bool _isFightingClue = false, _isRansackClue = false;
  final TextEditingController _caseBehaviorController = TextEditingController();
  final TextEditingController _caseEntranceDetails = TextEditingController();

  final TextEditingController _fightingClueDetails = TextEditingController();
  final TextEditingController _ransackClueDetails = TextEditingController();

  FidsCrimeScene? data;

  int _radioValue1 = -1;
  int _radioValue2 = -1;

  bool isLoading = true;

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
    setState(() {
      data = result;

      _caseBehaviorController.text = _cleanText(data?.caseBehavior) ?? '';
      _caseEntranceDetails.text = _cleanText(data?.caseEntranceDetails) ?? '';
      _fightingClueDetails.text = _cleanText(data?.fightingClueDetails) ?? '';
      _ransackClueDetails.text = _cleanText(data?.ransackClueDetails) ?? '';

      if (data?.isFightingClue == 1) {
        _radioValue1 = 1;
        _isFightingClue = true;
      } else if (data?.isFightingClue == 0) {
        _radioValue1 = 0;
        _isFightingClue = false;
      }

      if (data?.isRansackClue == 1) {
        _radioValue2 = 1;
        _isRansackClue = true;
      } else if (data?.isRansackClue == 0) {
        _radioValue2 = 0;
        _isRansackClue = false;
      }

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
                      // headerView(),

                      header(
                          widget.isWitnessCase ?? false
                              ? 'ผลการตรวจ'
                              : 'พฤติการณ์คดี',
                          true),
                      spacer(context),
                      InputField(
                          controller: _caseBehaviorController,
                          hint: 'กรอกพฤติการณ์คดี',
                          maxLine: 8,
                          onChanged: (value) {}),
                      spacer(context),
                      spacer(context),
                      header('ทางเข้า-ทางออก', false),
                      spacer(context),
                      InputField(
                          controller: _caseEntranceDetails,
                          hint: 'กรอกทางเข้า-ทางออก',
                          maxLine: 2,
                          onChanged: (value) {}),

                      spacer(context),
                      spacer(context),
                      fightRadioView(),
                      spacer(context),
                      InputField(
                          controller: _fightingClueDetails,
                          hint: 'กรอกร่องรอยการต่อสู้',
                          maxLine: 2,
                          onChanged: (value) {}),
                      spacer(context),
                      spacer(context),
                      findRadioView(),
                      spacer(context),
                      InputField(
                          controller: _ransackClueDetails,
                          hint: 'กรอกร่องรอยการรื้อค้น',
                          maxLine: 2,
                          onChanged: (value) {},
                          onFieldSubmitted: (_) {
                            Focus.of(context).unfocus();
                          }),
                      spacer(context),
                      spacer(context),
                      saveButton(),
                      spacer(context),
                      spacer(context),
                    ])))));
  }

  Widget header(String? text, bool isRequire) {
    return Row(
      children: [
        Text(
          '$text',
          textAlign: TextAlign.left,
          style: GoogleFonts.prompt(
            textStyle: TextStyle(
              color: Colors.white,
              letterSpacing: .5,
              fontSize: MediaQuery.of(context).size.height * 0.025,
            ),
          ),
        ),
        isRequire
            ? Text(
                '*',
                textAlign: TextAlign.left,
                style: GoogleFonts.prompt(
                  textStyle: TextStyle(
                    color: Colors.white,
                    letterSpacing: .5,
                    fontSize: MediaQuery.of(context).size.height * 0.025,
                  ),
                ),
              )
            : Text(
                '',
                textAlign: TextAlign.left,
                style: GoogleFonts.prompt(
                  textStyle: TextStyle(
                    color: Colors.white,
                    letterSpacing: .5,
                    fontSize: MediaQuery.of(context).size.height * 0.025,
                  ),
                ),
              )
      ],
    );
  }

  Widget spacer(context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.015,
    );
  }

  void _handleFightingClueValueChange(int value) {
    setState(() {
      _radioValue1 = value;
      switch (_radioValue1) {
        case 0:
          _isFightingClue = false;
          break;
        case 1:
          _isFightingClue = true;
          break;
      }
    });
  }

  // ignore: unused_element
  void _handleRansackClueValueChange(int value) {
    setState(() {
      _radioValue2 = value;
      switch (_radioValue2) {
        case 0:
          _isRansackClue = false;
          break;
        case 1:
          _isRansackClue = true;
          break;
      }
    });
  }

  Widget fightRadioView() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            'ร่องรอยการต่อสู้',
            textAlign: TextAlign.center,
            style: GoogleFonts.prompt(
              textStyle: TextStyle(
                color: Colors.white,
                letterSpacing: .5,
                fontSize: MediaQuery.of(context).size.height * 0.025,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Transform.scale(
                      scale: 1.2,
                      child: Radio(
                        value: 1,
                        activeColor: pinkButton,
                        groupValue: _radioValue1,
                        onChanged: (str) {
                          _handleFightingClueValueChange(str ?? -1);
                        },
                      )),
                  Text(
                    'มี',
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
              Row(
                children: [
                  Transform.scale(
                      scale: 1.2,
                      child: Radio(
                        value: 0,
                        activeColor: pinkButton,
                        groupValue: _radioValue1,
                        onChanged: (str) {
                          _handleFightingClueValueChange(str ?? -1);
                        },
                      )),
                  Text(
                    'ไม่มี',
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
        ],
      ),
    );
  }

  Widget findRadioView() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            'ร่องรอยการรื้อค้น',
            textAlign: TextAlign.center,
            style: GoogleFonts.prompt(
              textStyle: TextStyle(
                color: Colors.white,
                letterSpacing: .5,
                fontSize: MediaQuery.of(context).size.height * 0.025,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Transform.scale(
                      scale: 1.2,
                      child: Radio(
                        value: 1,
                        activeColor: pinkButton,
                        groupValue: _radioValue2,
                        onChanged: (str) {
                          _handleFightingClueValueChange(str ?? -1);
                        },
                      )),
                  Text(
                    'มี',
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
              Row(
                children: [
                  Transform.scale(
                      scale: 1.2,
                      child: Radio(
                        value: 0,
                        activeColor: pinkButton,
                        groupValue: _radioValue2,
                        onChanged: (str) {
                          _handleFightingClueValueChange(str ?? -1);
                        },
                      )),
                  Text(
                    'ไม่มี',
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
        ],
      ),
    );
  }

  bool isValidate() {
    return _caseBehaviorController.text != '';
  }

  Widget saveButton() {
    return AppButton(
        color: pinkButton,
        textColor: Colors.white,
        text: 'บันทึก',
        onPressed: () {
          if (kDebugMode) {
            print('พฤติการณ์คดี ${_caseBehaviorController.text}');
            print('ทางเข้า-ออก  ${_caseEntranceDetails.text}');
            print('ร่องรอยการต่อสู้  $_isFightingClue');
            print('รายละเอียดร่องรอยการต่อสู้  ${_fightingClueDetails.text}');
            print('ร่องรอยการรื้อค้น $_isRansackClue');
            print('รายละเอียดร่องรอยการรื้อค้น  ${_ransackClueDetails.text}');
          }

          if (isValidate()) {
            int variable1;
            if (_isFightingClue) {
              variable1 = 1;
            } else {
              variable1 = 0;
            }

            int variable2;
            if (_isRansackClue) {
              variable2 = 1;
            } else {
              variable2 = 0;
            }

            FidsCrimeSceneDao().updateResultCase(
                _caseBehaviorController.text,
                _caseEntranceDetails.text,
                variable1,
                _fightingClueDetails.text,
                variable2,
                _ransackClueDetails.text,
                '${widget.caseID}');

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

  String? _cleanText(String? text) {
    try {
      if (text == null || text == '' || text == 'null' || text == '-1') {
        return '';
      }
      return text;
    } catch (ex) {
      return '';
    }
  }
}
