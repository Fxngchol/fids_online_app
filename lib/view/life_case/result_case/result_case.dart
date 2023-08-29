import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/color.dart';
import '../../../models/CaseCategory.dart';
import '../../../models/FidsCrimeScene.dart';
import '../../../widget/app_bar_widget.dart';
import 'add_result_case.dart';

class ResultCase extends StatefulWidget {
  final int? caseID;
  final String? caseNo;
  final bool isLocal, isWitnessCase;

  const ResultCase(
      {super.key,
      this.caseID,
      this.caseNo,
      this.isLocal = false,
      this.isWitnessCase = false});

  @override
  ResultCaseState createState() => ResultCaseState();
}

class ResultCaseState extends State<ResultCase> {
  bool isPhone = Device.get().isPhone;

  bool isLoading = true;

  FidsCrimeScene? data;

  int _radioValue1 = -1;
  int _radioValue2 = -1;
  String? caseName;

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

      if (data?.isFightingClue == 1) {
        _radioValue1 = 1;
      } else if (data?.isFightingClue == 0) {
        _radioValue1 = 0;
      }

      if (data?.isRansackClue == 1) {
        _radioValue2 = 1;
      } else if (data?.isRansackClue == 0) {
        _radioValue2 = 0;
      }

      isLoading = false;
    });
    await CaseCategoryDAO()
        .getCaseCategoryLabelByid(data?.caseCategoryID ?? -1)
        .then((value) => caseName = value);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBarWidget(
          title: 'ผลการตรวจสถานที่เกิดเหตุ',
          actions: [
            TextButton(
              onPressed: () async {
                //  Navigator.pushNamed(context, '/addresultcase');
                var result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddResultCase(
                            caseID: widget.caseID ?? -1,
                            isLocal: widget.isLocal,
                            isWitnessCase: widget.isWitnessCase)));

                if (result) {
                  asyncCall1();
                }
              },
              child: Icon(Icons.edit,
                  color: Colors.white,
                  size: MediaQuery.of(context).size.height * 0.025),
            ),
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
                      header(
                          widget.isWitnessCase ? 'ผลการตรวจ' : 'พฤติการณ์คดี'),
                      spacer(context),
                      detailView('${_cleanText(data?.caseBehavior)}'),
                      spacer(context),
                      header('ทางเข้า-ทางออก'),
                      spacer(context),
                      detailView('${_cleanText(data?.caseEntranceDetails)}'),
                      spacer(context),
                      fightRadioView(),
                      detailView('${_cleanText(data?.fightingClueDetails)}'),
                      spacer(context),
                      findRadioView(),
                      detailView('${_cleanText(data?.ransackClueDetails)}'),
                      spacer(context),
                    ])))));
  }

  Widget headerView() {
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
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // int _radioValue = 0;
  void _handleRadioValueChange(int value) {
    // setState(() {
    //   _radioValue = value;

    //   switch (_radioValue) {
    //     case 0:
    //       break;
    //     case 1:
    //       break;
    //     case 2:
    //       break;
    //   }
    // });
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Transform.scale(
                      scale: 1.2,
                      child: Radio(
                        value: 1,
                        groupValue: _radioValue1,
                        activeColor: pinkButton,
                        onChanged: (val) {
                          _handleRadioValueChange(val ?? -1);
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
                        onChanged: (val) {
                          _handleRadioValueChange(val ?? -1);
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
      padding: const EdgeInsets.only(bottom: 10, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            'ร่องรอยการรื้อค้น',
            textAlign: TextAlign.start,
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
                        onChanged: (val) {
                          _handleRadioValueChange(val ?? -1);
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
                        onChanged: (val) {
                          _handleRadioValueChange(val ?? -1);
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
