import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Utils/color.dart';
import '../../models/CaseBody.dart';
import '../../models/CaseEvident.dart';
import '../../models/CaseEvidentFound.dart';
import '../../models/CaseImage.dart';
import '../../models/CaseInspection.dart';
import '../../models/CaseInspector.dart';
import '../../models/CaseReferencePoint.dart';
import '../../models/CaseRelatedPerson.dart';
import '../../models/DiagramLocation.dart';
import '../../models/FidsCrimeScene.dart';
import '../../models/case_fire/CaseFireArea.dart';
import '../../models/case_fire/CaseFireAreaDoa.dart';
import '../../models/case_fire/CaseFireSideArea.dart';
import '../../models/case_fire/CaseFireSideAreaDao.dart';
import '../../models/case_vehicle/CaseVehicle.dart';
import '../../models/case_vehicle/CaseVehicleDao.dart';
import '../../widget/app_bar_widget.dart';
import '../life_case/case_datetime/case_datetime.dart';
import '../life_case/case_image/case_Image_list.dart';
import '../life_case/crime_scene/select_location.dart';
import '../life_case/date_time_inspect_case/date_time_inspect_case.dart';
import '../life_case/deceased/reference_point/reference_point.dart';
import '../life_case/evident/evident_found/evident_found.dart';
import '../life_case/evident/evident_kept/evident_kept.dart';
import '../life_case/evident/model/CaseEvidentForm.dart';
import '../life_case/inspector_case/inspector_case.dart';
import '../life_case/location_case/location_case.dart';
import '../life_case/plan_case/show_plan_case.dart';
import '../life_case/relate_person/relate_person.dart';
import '../life_case/release_scene/release_scene.dart';
import '../life_case/request_case/request_case_detail.dart';
import '../traffic_case/case_behavior.dart/case_behavior.dart';
import '../traffic_case/case_vehicle/case_vehicle_list.dart';
import 'case_fire_area/case_fire_area_list.dart';
import 'case_fire_side/case_fire_side_area_list.dart';
import 'fire_result.dart';

class MainFireCase extends StatefulWidget {
  final int? caseID;
  final String? caseNo;
  final bool isLocal;

  const MainFireCase(
      {super.key, this.caseID, this.caseNo, this.isLocal = false});

  @override
  MainFireCaseState createState() => MainFireCaseState();
}

class MainFireCaseState extends State<MainFireCase> {
  bool isPhone = Device.get().isPhone;

  bool isLoading = true;
  FidsCrimeScene? data;
  List<CaseRelatedPerson> relatedPersons = [];
  List<CaseInspection> caseInspectionList = [];
  List<CaseInspector> caseInspectorList = [];
  List<CaseBody> casebodys = [];
  List<CaseEvidentFound> caseEvidentFounds = [];
  List<CaseEvidentForm> caseEvidents = [];
  DiagramLocation diagramLocation = DiagramLocation();
  List<CaseReferencePoint> referencePointList = [];
  List<CaseImages> caseImageList = [];
  List<CaseVehicle> caseVehicles = [];
  List<CaseFireArea> caseFireArea = [];
  List<CaseFireSideArea> caseFireSideArea = [];
  var fireType = '';
  bool _relatedPerson = false;

  bool _isFinish1 = false,
      _isFinish2 = false,
      _isFinish3 = false,
      _isFinish4 = false,
      _isFinish5 = false,
      _isFinish62 = false,
      _isFinish711 = false,
      _isFinish73 = false,
      _isFinish74 = false,
      _isFinish75 = false,
      _isFinish76 = false,
      _isFinish77 = false,
      _isCaseBehaviorNotEmpty = false,
      _isCaseVehicleNotEmpty = false,
      _isCaseFireAreaNotEmpty = false,
      _isCaseFireSideAreaNotEmpty = false;

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
    caseVehicles = await CaseVehicleDao().getCaseVehicle(widget.caseID ?? -1);
    caseFireArea = await CaseFireAreaDao().getCaseFireArea(widget.caseID ?? -1);
    caseFireSideArea =
        await CaseFireSideAreaDao().getAllCaseFireSideArea(widget.caseID ?? -1);
    setState(() {
      data = result;
      fireType = data?.caseCategoryID == 2
          ? data?.fireTypeID == '1'
              ? '(อาคาร)'
              : '(ยานพาหนะ)'
          : '';
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
      _isCaseFireSideAreaNotEmpty = caseFireSideArea.isNotEmpty;
      _isCaseFireAreaNotEmpty = caseFireArea.isNotEmpty;
      _isCaseVehicleNotEmpty = caseVehicles.isNotEmpty;
      _isCaseBehaviorNotEmpty = data?.caseBehavior != null &&
          data?.caseBehavior != '' &&
          data?.caseBehavior != 'null' &&
          data?.caseBehavior != 'Null';

      //ข้อ1
      if (data?.fidsNo != null &&
          data?.fidsNo != '' &&
          data?.fidsNo != 'null' &&
          data?.fidsNo != 'Null') {
        _isFinish1 = true;
      } else {
        _isFinish1 = false;
      }

      //ข้อ 2
      if (data?.isoLatitude != null &&
          data?.isoLatitude != '' &&
          data?.isoLatitude != 'null' &&
          data?.isoLatitude != 'Null' &&
          data?.isoLongtitude != null &&
          data?.isoLongtitude != '' &&
          data?.isoLongtitude != 'null' &&
          data?.isoLongtitude != 'Null') {
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
      if (data?.caseVictimDate != null &&
          data?.caseVictimDate != '' &&
          data?.caseVictimDate != 'null' &&
          data?.caseVictimDate != 'Null') {
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

      //ข้อ 6.2
      if (data?.isOutside == 1 || data?.isOutside == 2) {
        _isFinish62 = true;
      } else {
        _isFinish62 = false;
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
      if (data?.isoIsFinal != null &&
          data?.isoIsFinal != -1 &&
          data?.isoIsFinal != 0) {
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

      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBarWidget(
        title: 'คดีเพลิงไหม้ $fireType',
        leading: IconButton(
            icon: isIOS
                ? const Icon(Icons.arrow_back_ios)
                : const Icon(Icons.arrow_back),
            onPressed: () async {
              Navigator.of(context).pop(true);
            }),
        actions: [
          Container(
            width: MediaQuery.of(context).size.width * 0.03,
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
                        await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RequestCaseDetail(
                                        caseID: widget.caseID ?? -1,
                                        isLocal: widget.isLocal,
                                        caseNo: widget.caseNo)))
                            .then((value) => asyncCall1());
                      }),
                      spacer(context),
                      requestView('2.สถานที่เกิดเหตุ', '', _isFinish2,
                          () async {
                        //Navigator.pushNamed(context, '/locationcase');

                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LocationCase(
                                      caseID: widget.caseID ?? -1,
                                      caseNo: widget.caseNo,
                                      isLocal: widget.isLocal,
                                    ))).then((value) => asyncCall1());
                      }),
                      spacer(context),
                      requestView('ผู้เกี่ยวข้อง (${relatedPersons.length})',
                          '', _relatedPerson, () async {
                        await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RelatePerson(
                                        caseID: widget.caseID ?? -1,
                                        caseNo: widget.caseNo,
                                        isLocal: widget.isLocal,
                                        isWitnessCasePerson: false)))
                            .then((value) => asyncCall1());
                      }),
                      spacer(context),
                      requestView(
                          '3.วันเวลาที่ทราบเหตุ/เกิดเหตุ', '', _isFinish3,
                          () async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CaseDatetime(
                                      caseID: widget.caseID ?? -1,
                                      caseNo: widget.caseNo,
                                      isLocal: widget.isLocal,
                                    ))).then((value) => asyncCall1());
                      }),
                      spacer(context),
                      requestView(
                          '4.วันเวลาที่ตรวจเหตุ (${caseInspectionList.length})',
                          '',
                          _isFinish4, () async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DateTimeInspectCase(
                                      caseID: widget.caseID ?? -1,
                                      caseNo: widget.caseNo,
                                      isLocal: widget.isLocal,
                                    ))).then((value) => asyncCall1());
                      }),
                      spacer(context),
                      requestView(
                          '5.ผู้ตรวจสถานที่เกิดเหตุ (${caseInspectorList.length})',
                          '',
                          _isFinish5, () async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => InspectorCase(
                                      caseID: widget.caseID ?? -1,
                                      caseNo: widget.caseNo,
                                      isLocal: widget.isLocal,
                                    ))).then((value) => asyncCall1());
                      }),
                      spacer(context),
                      header('6.ลักษณะสถานที่เกิดเหตุ'),
                      spacer(context),
                      data?.fireTypeID == '1'
                          ? requestView(
                              'ลักษณะบริเวณที่เกิดเหตุ', '', _isFinish62,
                              () async {
                              await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SelectLocation(
                                              caseID: widget.caseID ?? -1,
                                              caseNo: widget.caseNo,
                                              isLocal: widget.isLocal)))
                                  .then((value) => asyncCall1());
                            })
                          : requestView('ยานพาหนะ (${caseVehicles.length})', '',
                              _isCaseVehicleNotEmpty, () async {
                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CaseVehicleList(
                                            caseID: widget.caseID ?? -1,
                                            caseNo: widget.caseNo,
                                            isLocal: widget.isLocal,
                                          ))).then((value) => asyncCall1());
                            }),
                      spacer(context),
                      header('7.ผลการตรวจสถานที่เกิดเหตุ'),
                      spacer(context),
                      requestView('พฤติการณ์คดี', '', _isCaseBehaviorNotEmpty,
                          () async {
                        await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CaseBehaviorPage(
                                        caseID: widget.caseID ?? -1,
                                        isLocal: widget.isLocal,
                                        isEdit: _isCaseBehaviorNotEmpty,
                                        fieldName: 'CaseBehavior')))
                            .then((value) => asyncCall1());
                      }),
                      spacer(context),
                      requestView('จุดอ้างอิง (${referencePointList.length})',
                          '', _isFinish711, () async {
                        await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ReferencePoint(
                                        caseID: widget.caseID ?? -1,
                                        caseNo: widget.caseNo,
                                        isEdit: false)))
                            .then((value) => asyncCall1());
                      }),
                      spacer(context),
                      requestView(
                          data?.fireTypeID == '2'
                              ? 'สภาพความเสียหายของยานพาหนะ'
                              : 'สภาพความเสียหายของโครงสร้าง',
                          '',
                          data?.fireDamagedDetail != null &&
                              data?.fireDamagedDetail != '', () async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CaseBehaviorPage(
                                      fireTypeID: data?.fireTypeID,
                                      caseID: widget.caseID ?? -1,
                                      isLocal: widget.isLocal,
                                      isEdit: _isCaseBehaviorNotEmpty,
                                      fieldName: 'FireDamagedDetail',
                                    ))).then((value) => asyncCall1());
                      }),
                      spacer(context),
                      requestView(
                          data?.fireTypeID == '2'
                              ? 'สภาพความเสียหายของโครงสร้างยานพาหนะ'
                              : 'สภาพความเสียหายของโครงสร้างอาคาร',
                          '',
                          _isCaseFireAreaNotEmpty, () async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CaseFireAreaList(
                                    caseID: widget.caseID ?? -1,
                                    caseNo: widget.caseNo,
                                    isVehicleType: data?.fireTypeID ==
                                        '2'))).then((value) => asyncCall1());
                      }),
                      spacer(context),
                      requestView(
                          'บริเวณที่เกิดเพลิงไหม้ขึ้นก่อน',
                          '',
                          data?.fireAreaDetail != null &&
                              data?.fireAreaDetail != '', () async {
                        await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CaseBehaviorPage(
                                        caseID: widget.caseID ?? -1,
                                        isLocal: widget.isLocal,
                                        isEdit: _isCaseBehaviorNotEmpty,
                                        fieldName: 'FireAreaDetail')))
                            .then((value) => asyncCall1());
                      }),
                      spacer(context),
                      requestView(
                          'สภาพของเมนสวิทช์ควบคุมไฟฟ้า',
                          '',
                          data?.fireMainSwitch != null &&
                              data?.fireMainSwitch != '', () async {
                        await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CaseBehaviorPage(
                                        caseID: widget.caseID ?? -1,
                                        isLocal: widget.isLocal,
                                        isEdit: _isCaseBehaviorNotEmpty,
                                        fieldName: 'FireMainSwitch')))
                            .then((value) => asyncCall1());
                      }),
                      spacer(context),
                      requestView('สภาพความเสียหายบริเวณข้างเคียง', '',
                          _isCaseFireSideAreaNotEmpty, () async {
                        await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CaseFireSideAreaList(
                                        caseID: widget.caseID ?? -1,
                                        caseNo: widget.caseNo,
                                        isVehicleType: data?.fireTypeID == '2',
                                        isSideAreaDetail: true)))
                            .then((value) => asyncCall1());
                      }),
                      spacer(context),
                      requestView(
                          'วัตถุพยานที่ตรวจพบ (${caseEvidentFounds.length})',
                          '',
                          _isFinish73, () async {
                        await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EvidentFound(
                                        caseID: widget.caseID ?? -1,
                                        caseNo: widget.caseNo,
                                        isLocal: widget.isLocal)))
                            .then((value) => asyncCall1());
                      }),
                      spacer(context),
                      requestView(
                          'วัตถุพยานที่ตรวจเก็บ (${caseEvidents.length})',
                          '',
                          _isFinish74, () async {
                        await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EvidentKept(
                                        caseID: widget.caseID ?? -1,
                                        caseNo: widget.caseNo,
                                        isLocal: widget.isLocal,
                                        isLifeCase: true)))
                            .then((value) => asyncCall1());
                      }),
                      spacer(context),
                      requestView(
                          'สรุปผลการตรวจ',
                          '',
                          (data?.fireSourceArea != null &&
                                  data?.fireSourceArea != '') ||
                              (data?.fireFuel != null &&
                                  data?.fireFuel != '') ||
                              (data?.fireHeatSource != null &&
                                  data?.fireHeatSource != ''), () async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FireResultPage(
                                      caseID: widget.caseID ?? -1,
                                      caseNo: widget.caseNo,
                                      isLocal: widget.isLocal,
                                    ))).then((value) => asyncCall1());
                      }),
                      spacer(context),
                      requestView('ความเห็น', '',
                          data?.fireOpinion != null && data?.fireOpinion != '',
                          () async {
                        await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CaseBehaviorPage(
                                        caseID: widget.caseID ?? -1,
                                        isLocal: widget.isLocal,
                                        isEdit: _isCaseBehaviorNotEmpty,
                                        fieldName: 'FireOpinion')))
                            .then((value) => asyncCall1());
                      }),
                      spacer(context),
                      requestView('การส่งมอบสถานที่เกิดเหตุ', '', _isFinish75,
                          () async {
                        await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ReleaseScene(
                                        caseID: widget.caseID ?? -1,
                                        caseNo: widget.caseNo,
                                        isLocal: widget.isLocal)))
                            .then((value) => asyncCall1());
                      }),
                      spacer(context),
                      requestView('แผนผังสถานที่เกิดเหตุ', '', _isFinish76,
                          () async {
                        await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ShowPlancase(
                                        caseID: widget.caseID ?? -1,
                                        caseNo: widget.caseNo,
                                        isLocal: widget.isLocal)))
                            .then((value) => asyncCall1());
                      }),
                      spacer(context),
                      requestView('รูปภาพ', '', _isFinish77, () async {
                        await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CaseImage(
                                        caseID: widget.caseID ?? -1,
                                        caseNo: widget.caseNo,
                                        isLocal: widget.isLocal)))
                            .then((value) => asyncCall1());
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
