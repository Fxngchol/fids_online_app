import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Utils/color.dart';
import '../../models/CaseEvident.dart';
import '../../models/CaseEvidentFound.dart';
import '../../models/CaseImage.dart';
import '../../models/CaseInspection.dart';
import '../../models/CaseInspector.dart';
import '../../models/CaseReferencePoint.dart';
import '../../models/CaseRelatedPerson.dart';
import '../../models/DiagramLocation.dart';
import '../../models/FidsCrimeScene.dart';
import '../../widget/app_bar_widget.dart';
import '../life_case/case_datetime/case_datetime.dart';
import '../life_case/case_image/case_Image_list.dart';
import '../life_case/evident/evident_kept/evident_kept.dart';
import '../life_case/evident/model/CaseEvidentForm.dart';
import '../life_case/inspector_case/inspector_case.dart';
import '../life_case/location_case/location_case.dart';
import '../life_case/relate_person/relate_person.dart';
import '../life_case/release_scene/release_scene.dart';
import '../life_case/request_case/request_case_detail.dart';
import '../witness_case_obj/inspection results/inspection_result.dart';

class MainMenuWitnessPerson extends StatefulWidget {
  final int? caseID;
  final String? caseNo;
  final bool isLocal;

  const MainMenuWitnessPerson(
      {super.key, required this.caseID, this.caseNo, this.isLocal = false});

  @override
  MainMenuWitnessPersonState createState() => MainMenuWitnessPersonState();
}

class MainMenuWitnessPersonState extends State<MainMenuWitnessPerson> {
  bool isPhone = Device.get().isPhone;

  bool isLoading = true;
  FidsCrimeScene data = FidsCrimeScene();
  List<CaseRelatedPerson> relatedPersons = [];
  List<CaseInspection> caseInspectionList = [];
  List<CaseInspector> caseInspectorList = [];
  List<CaseEvidentFound> caseEvidentFounds = [];
  List<CaseEvidentForm> caseEvidents = [];
  DiagramLocation diagramLocation = DiagramLocation();
  List<CaseReferencePoint> referencePointList = [];
  List<CaseImages> caseImageList = [];

  bool _relatedPerson = false;

  bool _isFinish1 = false,
      _isFinish2 = false,
      _isFinish3 = false,
      // _isFinish4 = false,
      _isFinish5 = false,
      // _isFinish71 = false,
      // _isFinish74 = false,
      _isFinish75 = false,
      _isFinish77 = false,
      _isInspectionResult = false,
      _isCaseEvident = false;

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
        await CaseRelatedPersonDao().getCaseRelatedPerson(widget.caseID ?? -1);
    var result3 =
        await CaseInspectionDao().getCaseInspection(widget.caseID ?? -1);
    var result4 =
        await CaseInspectorDao().getCaseInspector(widget.caseID ?? -1);
    var result6 =
        await CaseEvidentFoundDao().getCaseEvidentFound(widget.caseID ?? -1);
    var result7 = await CaseEvidentDao().getCaseEvident(widget.caseID ?? -1);
    var result8 =
        await DiagramLocationDao().getDiagramLocation('${widget.caseID ?? -1}');
    var result9 =
        await CaseReferencePointDao().getCaseReferencePoint('${widget.caseID}');
    var result10 = await CaseImagesDao().getCaseImages(widget.caseID ?? -1);

    setState(() {
      data = result ?? FidsCrimeScene();
      relatedPersons = result2;
      caseInspectionList = result3;
      caseInspectorList = result4;
      // casebodys = result5;
      caseEvidentFounds = result6;
      caseEvidents = result7 ?? [];
      diagramLocation = result8;
      referencePointList = result9;
      referencePointList = result9;
      caseImageList = result10;
      //ข้อ1
      if (data.fidsNo != null &&
          data.fidsNo != '' &&
          data.fidsNo != 'null' &&
          data.fidsNo != 'Null') {
        _isFinish1 = true;
      } else {
        _isFinish1 = false;
      }

      //ข้อ 2
      if (data.isoLatitude != null &&
          data.isoLatitude != '' &&
          data.isoLatitude != 'null' &&
          data.isoLatitude != 'Null' &&
          data.isoLongtitude != null &&
          data.isoLongtitude != '' &&
          data.isoLongtitude != 'null' &&
          data.isoLongtitude != 'Null') {
        _isFinish2 = true;
      } else {
        _isFinish2 = false;
      }

      //ข้อ 3
      if (data.caseVictimDate != null &&
          data.caseVictimDate != '' &&
          data.caseVictimDate != 'null' &&
          data.caseVictimDate != 'Null') {
        _isFinish3 = true;
      } else {
        _isFinish3 = false;
      }

      //ข้อ 4
      // if (caseInspectionList.length > 0) {
      //   _isFinish4 = true;
      // } else {
      //   _isFinish4 = false;
      // }

      //ข้อ 5
      if (caseInspectorList.isNotEmpty) {
        _isFinish5 = true;
      } else {
        _isFinish5 = false;
      }

      //ข้อ 7.1
      // if (data.caseBehavior != null &&
      //     data.caseBehavior != '' &&
      //     data.caseBehavior != 'null' &&
      //     data.caseBehavior != 'Null') {
      //   _isFinish71 = true;
      // } else {
      //   _isFinish71 = false;
      // }

      //ข้อ 7.4
      if (caseEvidents.isNotEmpty) {
        _isCaseEvident = true;
      } else {
        _isCaseEvident = false;
      }

      //ข้อ 7.5
      if (data.isoIsFinal != null &&
          data.isoIsFinal != -1 &&
          data.isoIsFinal != 0) {
        _isFinish75 = true;
      } else {
        _isFinish75 = false;
      }

      //รูปภาพ
      if (caseImageList.isNotEmpty) {
        _isFinish77 = true;
      } else {
        _isFinish77 = false;
      }

      //รายการบุคคล
      if (relatedPersons.isNotEmpty) {
        _relatedPerson = true;
      } else {
        _relatedPerson = false;
      }

      isLoading = false;
    });

    //ผลการตรวจ
    if (data.exhibitLocation != '' && data.exhibitLocation != null) {
      _isInspectionResult = true;
    } else {
      _isInspectionResult = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBarWidget(
        title: 'คดีตรวจเก็บวัตถุพยานบุคคล',
        leading: IconButton(
            icon: isIOS
                ? const Icon(Icons.arrow_back_ios)
                : const Icon(Icons.arrow_back),
            onPressed: () async {
              Navigator.of(context).pop(true);
            }),
        actions: [
          Container(
            width: MediaQuery.of(context).size.width * 0.05,
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
                      requestView('สถานที่เกิดเหตุ', '', _isFinish2, () async {
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
                      requestView('วันเวลาที่ทราบเหตุ/เกิดเหตุ', '', _isFinish3,
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
                      requestView('ผู้ตรวจ (${caseInspectorList.length})', '',
                          _isFinish5, () async {
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
                      requestView('รายการบุคคล (${relatedPersons.length})', '',
                          _relatedPerson, () async {
                        var result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RelatePerson(
                                    caseID: widget.caseID ?? -1,
                                    caseNo: widget.caseNo,
                                    isLocal: widget.isLocal,
                                    isWitnessCasePerson: true)));
                        if (result != null) {
                          asyncCall1();
                        }
                      }),
                      spacer(context),
                      header('ผลการตรวจ'),
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
                      requestView('การส่งมอบสถานที่เกิดเหตุ', '', _isFinish75,
                          () async {
                        var result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReleaseScene(
                                    caseID: widget.caseID ?? -1,
                                    caseNo: widget.caseNo,
                                    isLocal: widget.isLocal)));
                        if (result != null) {
                          asyncCall1();
                        }
                      }),
                      spacer(context),
                      requestView('รูปภาพ', '', _isFinish77, () async {
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
