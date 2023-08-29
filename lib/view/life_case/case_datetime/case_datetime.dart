import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/color.dart';
import '../../../models/CaseCategory.dart';
import '../../../models/FidsCrimeScene.dart';
import '../../../widget/app_bar_widget.dart';
import '../../../widget/app_button.dart';
import '../../../widget/text_field_widget.dart';
import 'add_case_datetime.dart';

class CaseDatetime extends StatefulWidget {
  final int? caseID;
  final String? caseNo;
  final bool isLocal;

  const CaseDatetime(
      {super.key, this.caseID, this.caseNo, this.isLocal = false});

  @override
  CaseDatetimeState createState() => CaseDatetimeState();
}

class CaseDatetimeState extends State<CaseDatetime> {
  bool isLoading = true;

  bool isPhone = Device.get().isPhone;
  DateTime victimDate = DateTime.now();
  DateTime officerDate = DateTime.now();

  String? victimTime = '';
  String? officerTime = '';

  FidsCrimeScene? data;
  int _radioValue = -1;
  String? caseName;

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
      if (kDebugMode) {
        print('isCaseNotification ${data?.isCaseNotification}');
      }
      isLoading = false;
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
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
        extendBodyBehindAppBar: true,
        // resizeToAvoidBottomInset: false,
        appBar: AppBarWidget(
          title: 'วันเวลาที่ทราบเหตุ/เกิดเหตุ',
          actions: [
            TextButton(
              child: Icon(Icons.edit,
                  color: Colors.white,
                  size: MediaQuery.of(context).size.height * 0.025),
              onPressed: () async {
                var result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddCaseDateTime(
                              caseID: widget.caseID ?? -1,
                              caseNo: widget.caseNo,
                            )));
                if (result) {
                  asyncCall1();
                  setRadio();
                }
              },
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
                  detailView('${_cleanText(data?.caseVictimDate)}'),
                  spacer(),
                  titleWidget('เวลาประมาณ'),
                  spacer(),
                  detailView('${_cleanText(data?.caseVictimTime)}'),
                  spacer(),
                  officerView(),
                  spacer(),
                  titleWidget('วันที่'),
                  spacer(),
                  detailView('${_cleanText(data?.caseOfficerDate)}'),
                  spacer(),
                  titleWidget('เวลาประมาณ'),
                  spacer(),
                  detailView('${_cleanText(data?.caseOfficerTime)}'),
                  spacer(),
                  //saveButton()
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
            '${data?.fidsNo}',
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

  void _handleRadioValueChange(int value) {
    setState(() {
      //_radioValue = value;
      // switch (_radioValue) {
      //   case 0:
      //     break;
      //   case 1:
      //     break;
      //   case 2:
      //     break;
      // }
    });
  }

  Widget victimView() {
    return Padding(
      padding: const EdgeInsets.only(left: 24, bottom: 24),
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
                fontWeight: FontWeight.w500,
                fontSize: MediaQuery.of(context).size.height * 0.025,
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
      padding: const EdgeInsets.only(left: 24, bottom: 12, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            'วันเวลาที่พนักงานสอบสวนทราบเหตุ',
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
            Navigator.pop(context);
          }),
    );
  }

  Widget detailView(String? text) {
    return Container(
      decoration: BoxDecoration(
          color: whiteOpacity, borderRadius: BorderRadius.circular(8)),
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: isPhone
            ? const EdgeInsets.only(left: 24, right: 24, top: 10, bottom: 10)
            : const EdgeInsets.only(left: 32, right: 32, top: 20, bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$text',
                    textAlign: TextAlign.left,
                    style: GoogleFonts.prompt(
                      textStyle: TextStyle(
                        color: textColor,
                        letterSpacing: .5,
                        fontSize: MediaQuery.of(context).size.height * 0.025,
                      ),
                    ),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
