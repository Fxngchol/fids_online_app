import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/color.dart';
import '../../../models/CaseBody.dart';
import '../../../models/CaseBomb.dart';
import '../../../models/CaseEvident.dart';
import '../../../models/CaseEvidentFound.dart';
import '../../../models/CaseImage.dart';
import '../../../models/CaseInspection.dart';
import '../../../models/CaseInspector.dart';
import '../../../models/CaseReferencePoint.dart';
import '../../../models/CaseRelatedPerson.dart';
import '../../../models/DiagramLocation.dart';
import '../../../models/FidsCrimeScene.dart';
import '../../../widget/app_bar_widget.dart';
import '../../life_case/case_datetime/case_datetime.dart';
import '../../life_case/case_image/case_Image_list.dart';
import '../../life_case/crime_scene/scene_location_detail.dart';
import '../../life_case/crime_scene/select_location.dart';
import '../../life_case/date_time_inspect_case/date_time_inspect_case.dart';
import '../../life_case/deceased/reference_point/reference_point.dart';
import '../../life_case/deceased/select_found_deceased.dart';
import '../../life_case/evident/evident_found/evident_found.dart';
import '../../life_case/evident/evident_kept/evident_kept.dart';
import '../../life_case/evident/model/CaseEvidentForm.dart';
import '../../life_case/inspector_case/inspector_case.dart';
import '../../life_case/location_case/location_case.dart';
import '../../life_case/plan_case/show_plan_case.dart';
import '../../life_case/relate_person/relate_person.dart';
import '../../life_case/release_scene/release_scene.dart';
import '../../life_case/request_case/request_case_detail.dart';
import '../bomb_evident_found/bomb_evident_found.dart';
import '../result_crime_scene/bomb_result_crime_scene.dart';

class MainMenuBombCase extends StatefulWidget {
  final int? caseID;
  final String? caseNo;
  final bool isLocal;

  const MainMenuBombCase(
      {super.key, required this.caseID, this.caseNo, this.isLocal = false});

  @override
  MainMenuBombCaseState createState() => MainMenuBombCaseState();
}

class MainMenuBombCaseState extends State<MainMenuBombCase> {
  bool isPhone = Device.get().isPhone;

  bool isLoading = true;
  FidsCrimeScene data = FidsCrimeScene();
  List<CaseRelatedPerson> relatedPersons = [];
  List<CaseInspection> caseInspectionList = [];
  List<CaseInspector> caseInspectorList = [];
  List<CaseBody> casebodys = [];
  List<CaseEvidentFound> caseEvidentFounds = [];
  List<CaseEvidentForm> caseEvidents = [];
  DiagramLocation diagramLocation = DiagramLocation();
  List<CaseReferencePoint> referencePointList = [];
  List<CaseImages> caseImageList = [];
  List<CaseBomb> caseBombs = [];

  bool _relatedPerson = false;

  bool _isFinish1 = false,
      _isFinish2 = false,
      _isFinish3 = false,
      _isFinish4 = false,
      _isFinish5 = false,
      _isFinish6 = false,
      _isFinish62 = false,
      _isFinish71 = false,
      _isFinish711 = false,
      _isFinish72 = false,
      _isFinish73 = false,
      _isFinish74 = false,
      _isFinish75 = false,
      _isFinish76 = false,
      _isFinish77 = false,
      _isFinishBomb1 = false;

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
    var result5 = await CaseBodyDao().getCaseBody(widget.caseID ?? -1);
    var result6 =
        await CaseEvidentFoundDao().getCaseEvidentFound(widget.caseID ?? -1);
    var result7 = await CaseEvidentDao().getCaseEvident(widget.caseID ?? -1);
    var result8 =
        await DiagramLocationDao().getDiagramLocation('${widget.caseID}');
    var result9 =
        await CaseReferencePointDao().getCaseReferencePoint('${widget.caseID}');
    var result10 = await CaseImagesDao().getCaseImages(widget.caseID ?? -1);

    var result11 = await CaseBombDao().getCaseBomb(widget.caseID ?? -1);

    setState(() {
      data = result ?? FidsCrimeScene();
      relatedPersons = result2;
      caseInspectionList = result3;
      caseInspectorList = result4;
      casebodys = result5;
      caseEvidentFounds = result6;
      caseEvidents = result7 ?? [];
      diagramLocation = result8;
      referencePointList = result9;
      referencePointList = result9;
      caseImageList = result10;
      caseBombs = result11;
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

      //ผู้เกี่ยวข้อง
      if (relatedPersons.isNotEmpty) {
        _relatedPerson = true;
      } else {
        _relatedPerson = false;
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
      if (caseInspectionList.isNotEmpty) {
        _isFinish4 = true;
      } else {
        _isFinish4 = false;
      }

      //ข้อ 5
      if (caseInspectorList.isNotEmpty) {
        _isFinish5 = true;
      } else {
        _isFinish5 = false;
      }

      //ข้อ 6.1
      if (data.isSceneProtection != null &&
          data.isSceneProtection != -1 &&
          data.isSceneProtection != 0) {
        _isFinish6 = true;
      } else {
        _isFinish6 = false;
      }

      //ข้อ 6.2
      if (data.isOutside == 1 || data.isOutside == 2) {
        _isFinish62 = true;
      } else {
        _isFinish62 = false;
      }

      //ข้อ 7.1
      if (data.caseBehavior != null &&
          data.caseBehavior != '' &&
          data.caseBehavior != 'null' &&
          data.caseBehavior != 'Null') {
        _isFinish71 = true;
      } else {
        _isFinish71 = false;
      }

      //ข้อ 7.2
      if (casebodys.isNotEmpty) {
        _isFinish72 = true;
      } else if (data.isBodyFound == '2') {
        _isFinish72 = true;
      } else {
        _isFinish72 = false;
      }

      //ข้อ 7.3
      if (caseEvidentFounds.isNotEmpty) {
        _isFinish73 = true;
      } else {
        _isFinish73 = false;
      }

      //ข้อ 7.4
      if (caseEvidents.isNotEmpty) {
        _isFinish74 = true;
      } else {
        _isFinish74 = false;
      }

      //ข้อ 7.5
      if (data.isoIsFinal != null &&
          data.isoIsFinal != -1 &&
          data.isoIsFinal != 0) {
        _isFinish75 = true;
      } else {
        _isFinish75 = false;
      }

      //ข้อ 7.6
      if (diagramLocation.diagram != null &&
          diagramLocation.diagram != '' &&
          diagramLocation.diagram != 'null' &&
          diagramLocation.diagram != 'Null') {
        _isFinish76 = true;
      } else {
        _isFinish76 = false;
      }

      //ข้อจุดอ้างอิง
      if (referencePointList.isNotEmpty) {
        _isFinish711 = true;
      } else {
        _isFinish711 = false;
      }

      //รูปภาพ
      if (caseImageList.isNotEmpty) {
        _isFinish77 = true;
      } else {
        _isFinish77 = false;
      }

      if (caseBombs.isNotEmpty) {
        _isFinishBomb1 = true;
      } else {
        _isFinishBomb1 = false;
      }
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBarWidget(
        title: 'คดีระเบิด',
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
                      requestView('1.การรับแจ้งเหตุ', '', _isFinish1, () async {
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
                      requestView('2.สถานที่เกิดเหตุ', '', _isFinish2,
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
                      requestView('ผู้เกี่ยวข้อง (${relatedPersons.length})',
                          '', _relatedPerson, () async {
                        var result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RelatePerson(
                                    caseID: widget.caseID ?? -1,
                                    caseNo: widget.caseNo,
                                    isLocal: widget.isLocal,
                                    isWitnessCasePerson: false)));
                        if (result != null) {
                          asyncCall1();
                        }
                      }),
                      spacer(context),
                      spacer(context),
                      requestView(
                          '3.วันเวลาที่ทราบเหตุ/เกิดเหตุ', '', _isFinish3,
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
                          '4.วันเวลาที่ตรวจเหตุ (${caseInspectionList.length})',
                          '',
                          _isFinish4, () async {
                        var result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DateTimeInspectCase(
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
                          '5.ผู้ตรวจสถานที่เกิดเหตุ (${caseInspectorList.length})',
                          '',
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
                      header('6.ลักษณะสถานที่เกิดเหตุ'),
                      spacer(context),
                      requestView(
                          'สภาพของที่เกิดเหตุเมื่อไปถึง', '', _isFinish6,
                          () async {
                        var result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SceneLocationDetail(
                                    caseID: widget.caseID ?? -1,
                                    isLocal: widget.isLocal)));
                        if (result != null) {
                          asyncCall1();
                        }
                      }),
                      spacer(context),
                      requestView('ลักษณะบริเวณที่เกิดเหตุ', '', _isFinish62,
                          () async {
                        var result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SelectLocation(
                                    caseID: widget.caseID ?? -1,
                                    caseNo: widget.caseNo,
                                    isLocal: widget.isLocal)));
                        if (result != null) {
                          asyncCall1();
                        }
                      }),
                      spacer(context),
                      header('7.ผลการตรวจสถานที่เกิดเหตุ'),
                      spacer(context),
                      requestView('ผลตรวจสถานที่เกิดเหตุ', '', _isFinish71,
                          () async {
                        var result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ResultCrimesceneBomb(
                                    caseID: widget.caseID ?? -1,
                                    caseNo: widget.caseNo,
                                    isLocal: widget.isLocal)));
                        if (result != null) {
                          asyncCall1();
                        }
                      }),
                      spacer(context),
                      requestView('จุดอ้างอิง (${referencePointList.length})',
                          '', _isFinish711, () async {
                        var result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReferencePoint(
                                    caseID: widget.caseID ?? -1,
                                    caseNo: widget.caseNo,
                                    isEdit: false)));
                        if (result != null) {
                          asyncCall1();
                        }
                      }),
                      spacer(context),
                      requestView(
                          'ผู้เสียชีวิต (${casebodys.length})', '', _isFinish72,
                          () async {
                        var result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SelectFoundDecease(
                                    caseID: widget.caseID ?? -1,
                                    caseNo: widget.caseNo,
                                    isLocal: widget.isLocal)));
                        if (result != null) {
                          asyncCall1();
                        }
                      }),
                      spacer(context),
                      requestView(
                          'วัตถุพยานระเบิดที่ตรวจพบ (${caseBombs.length})',
                          '',
                          _isFinishBomb1, () async {
                        var result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BombEvidentFound(
                                    caseID: widget.caseID ?? -1,
                                    caseNo: widget.caseNo)));
                        if (result != null) {
                          asyncCall1();
                        }
                      }),
                      spacer(context),
                      requestView(
                          'วัตถุพยานที่ตรวจพบ (${caseEvidentFounds.length})',
                          '',
                          _isFinish73, () async {
                        var result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EvidentFound(
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
                          _isFinish74, () async {
                        var result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EvidentKept(
                                    caseID: widget.caseID ?? -1,
                                    caseNo: widget.caseNo,
                                    isLocal: widget.isLocal)));
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
                      requestView('แผนผังสถานที่เกิดเหตุ', '', _isFinish76,
                          () async {
                        var result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ShowPlancase(
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
