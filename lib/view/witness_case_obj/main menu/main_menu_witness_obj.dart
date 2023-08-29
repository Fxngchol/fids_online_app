import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/color.dart';
import '../../../models/CaseEvident.dart';
import '../../../models/CaseExhibit.dart';
import '../../../models/CaseImage.dart';
import '../../../models/CaseInspector.dart';
import '../../../models/FidsCrimeScene.dart';
import '../../../widget/app_bar_widget.dart';
import '../../life_case/case_datetime/case_datetime.dart';
import '../../life_case/case_image/case_Image_list.dart';
import '../../life_case/evident/evident_kept/evident_kept.dart';
import '../../life_case/evident/model/CaseEvidentForm.dart';
import '../../life_case/inspector_case/inspector_case.dart';
import '../../life_case/location_case/location_case.dart';
import '../../life_case/request_case/request_case_detail.dart';
import '../case exhibit/case_exhibit_list.dart';
import '../inspection results/inspection_result.dart';

class MainMenuWitnessObj extends StatefulWidget {
  final int? caseID;
  final String? caseNo;
  final bool isLocal;

  const MainMenuWitnessObj(
      {super.key, required this.caseID, this.caseNo, this.isLocal = false});

  @override
  MainMenuWitnessObjState createState() => MainMenuWitnessObjState();
}

class MainMenuWitnessObjState extends State<MainMenuWitnessObj> {
  bool isPhone = Device.get().isPhone;

  bool isLoading = true;
  FidsCrimeScene data = FidsCrimeScene();
  List<CaseInspector> caseInspectorList = [];
  List<CaseEvidentForm> caseEvidents = [];
  List<CaseImages> caseImageList = [];
  List<CaseExhibit> caseExhibitList = [];

  bool _isFinish1 = false,
      _isCaseLocation = false,
      _isCaseVictim = false,
      _isCaseInspector = false,
      _isCaseEvident = false,
      isCaseExhibit = false,
      _isCaseImages = false,
      _isInspectionResult = false;

  @override
  void initState() {
    if (kDebugMode) {
      print('fidsNo : ${widget.caseNo}');
      print('fidsId : ${widget.caseID}');
    }

    super.initState();
    asyncCall1();
  }

  void asyncCall1() async {
    var result =
        await FidsCrimeSceneDao().getFidsCrimeSceneById(widget.caseID ?? -1);
    var result2 =
        await CaseInspectorDao().getCaseInspector(widget.caseID ?? -1);
    var result3 = await CaseEvidentDao().getCaseEvident(widget.caseID ?? -1);
    var result4 = await CaseImagesDao().getCaseImages(widget.caseID ?? -1);
    var result5 = await CaseExhibitDao().getCaseExhibit(widget.caseID ?? -1);

    setState(() {
      data = result ?? FidsCrimeScene();

      caseInspectorList = result2;
      caseEvidents = result3 ?? [];
      caseImageList = result4;
      caseExhibitList = result5;

      //การรับแจ้งเหตุ
      if (data.fidsNo != null &&
          data.fidsNo != '' &&
          data.fidsNo != 'null' &&
          data.fidsNo != 'Null') {
        _isFinish1 = true;
      } else {
        _isFinish1 = false;
      }

      //สถานที่เกิดเหตุ
      if (data.isoLatitude != null &&
          data.isoLatitude != '' &&
          data.isoLatitude != 'null' &&
          data.isoLatitude != 'Null' &&
          data.isoLongtitude != null &&
          data.isoLongtitude != '' &&
          data.isoLongtitude != 'null' &&
          data.isoLongtitude != 'Null') {
        _isCaseLocation = true;
      } else {
        _isCaseLocation = false;
      }

      // วันเวลาที่ทราบเหตุ/เกิดเหตุ
      if (data.caseVictimDate != null &&
          data.caseVictimDate != '' &&
          data.caseVictimDate != 'null' &&
          data.caseVictimDate != 'Null') {
        _isCaseVictim = true;
      } else {
        _isCaseVictim = false;
      }

      //ผู้ตรวจเก็บวัตถุพยาน
      if (caseInspectorList.isNotEmpty) {
        _isCaseInspector = true;
      } else {
        _isCaseInspector = false;
      }

      //รายการของกลาง
      if (caseExhibitList.isNotEmpty) {
        isCaseExhibit = true;
      } else {
        isCaseExhibit = false;
      }

      //ผลการตรวจ
      if (data.exhibitLocation != '' && data.exhibitLocation != null) {
        _isInspectionResult = true;
      } else {
        _isInspectionResult = false;
      }
      //วัตถุพยานที่ตรวจเก็บ
      if (caseEvidents.isNotEmpty) {
        _isCaseEvident = true;
      } else {
        _isCaseEvident = false;
      }

      //รูปภาพ
      if (caseImageList.isNotEmpty) {
        _isCaseImages = true;
      } else {
        _isCaseImages = false;
      }

      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBarWidget(
        title: 'ตรวจเก็บวัตถุพยาน',
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
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : Container(
                  margin: isPhone
                      ? const EdgeInsets.all(32)
                      : const EdgeInsets.only(
                          left: 32, right: 32, top: 32, bottom: 32),
                  child: ListView(
                    children: [
                      headerView(),
                      header('การรับแจ้ง'),
                      requestView('การรับแจ้งเหตุ', '', _isFinish1, () async {
                        var result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RequestCaseDetail(
                                    caseID: widget.caseID ?? -1,
                                    isLocal: widget.isLocal,
                                    caseNo: widget.caseNo)));
                        if (result != null) {
                          asyncCall1();
                        }
                      }),
                      spacer(context),
                      requestView('สถานที่เกิดเหตุ', '', _isCaseLocation,
                          () async {
                        //Navigator.pushNamed(context, '/locationcase');

                        var result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LocationCase(
                                      caseID: widget.caseID ?? -1,
                                      caseNo: widget.caseNo,
                                      isLocal: widget.isLocal,
                                    )));

                        if (result != null) {
                          asyncCall1();
                        }
                      }),
                      spacer(context),
                      requestView(
                          'วันเวลาที่ทราบเหตุ/เกิดเหตุ', '', _isCaseVictim,
                          () async {
                        var result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CaseDatetime(
                                      caseID: widget.caseID ?? -1,
                                      caseNo: widget.caseNo,
                                      isLocal: widget.isLocal,
                                    )));
                        if (result != null) {
                          asyncCall1();
                        }
                      }),
                      spacer(context),
                      requestView(
                          'ผู้ตรวจเก็บวัตถุพยาน (${caseInspectorList.length})',
                          '',
                          _isCaseInspector, () async {
                        var result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => InspectorCase(
                                      caseID: widget.caseID ?? -1,
                                      caseNo: widget.caseNo,
                                      isLocal: widget.isLocal,
                                    )));
                        if (result != null) {
                          asyncCall1();
                        }
                      }),
                      spacer(context),
                      requestView('รายการของกลาง (${caseExhibitList.length})',
                          '', caseExhibitList.isNotEmpty, () async {
                        var result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CaseExhibitList(
                                    caseID: widget.caseID ?? -1,
                                    isLocal: widget.isLocal)));
                        if (result != null) {
                          asyncCall1();
                        }
                      }),
                      spacer(context),
                      header('ผลการตรวจ'),
                      spacer(context),
                      requestView('ผลการตรวจ', '', _isInspectionResult,
                          () async {
                        var result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => InspectionResultCase(
                                    caseID: widget.caseID ?? -1,
                                    caseNo: widget.caseNo,
                                    isLocal: widget.isLocal)));
                        if (result != null) {
                          asyncCall1();
                        }
                      }),
                      spacer(context),
                      requestView(
                          'วัตถุพยานที่ตรวจเก็บ (${caseEvidents.length})',
                          '',
                          _isCaseEvident, () async {
                        var result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EvidentKept(
                                    caseID: widget.caseID ?? -1,
                                    caseNo: widget.caseNo,
                                    isLocal: widget.isLocal,
                                    isLifeCase: false)));
                        if (result != null) {
                          asyncCall1();
                        }
                      }),
                      spacer(context),
                      requestView('รูปภาพ', '', _isCaseImages, () async {
                        var result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CaseImage(
                                    caseID: widget.caseID ?? -1,
                                    caseNo: widget.caseNo,
                                    isLocal: widget.isLocal)));
                        if (result != null) {
                          asyncCall1();
                        }
                      }),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget spacer(context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.015,
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
          )
        ],
      ),
    );
  }

  Widget requestView(String? text, String? desc, bool event, Function onTap) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(12)),
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
                    desc != ''
                        ? Text(
                            '$desc',
                            textAlign: TextAlign.left,
                            style: GoogleFonts.prompt(
                              textStyle: TextStyle(
                                color: textColor,
                                letterSpacing: .5,
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.025,
                              ),
                            ),
                            maxLines: 2,
                          )
                        : Container(),
                  ],
                ),
              ),
              event
                  ? Icon(
                      Icons.check_box_rounded,
                      size: MediaQuery.of(context).size.height * 0.03,
                      color: pinkButton,
                    )
                  : Icon(
                      Icons.check_box_outline_blank,
                      size: MediaQuery.of(context).size.height * 0.03,
                      color: Colors.white,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
