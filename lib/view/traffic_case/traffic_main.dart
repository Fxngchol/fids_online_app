// ignore_for_file: unused_local_variable

import 'package:fids_online_app/view/traffic_case/traffic_objective/traffic_objective.dart';
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
import '../../models/case_vehicle/CaseVehicle.dart';
import '../../models/case_vehicle/CaseVehicleCompare.dart';
import '../../models/case_vehicle/CaseVehicleDao.dart';
import '../../models/case_vehicle/CaseVehicleOpinion.dart';
import '../../widget/app_bar_widget.dart';
import '../life_case/case_datetime/case_datetime.dart';
import '../life_case/case_image/case_Image_list.dart';
import '../life_case/date_time_inspect_case/date_time_inspect_case.dart';
import '../life_case/evident/model/CaseEvidentForm.dart';
import '../life_case/inspector_case/inspector_case.dart';
import '../life_case/location_case/location_case.dart';
import '../life_case/relate_person/relate_person.dart';
import '../life_case/request_case/request_case_detail.dart';
import 'case_behavior.dart/case_behavior.dart';
import 'case_compare/compare_list.dart';
import 'case_vehicle/case_vehicle_list.dart';
import 'case_vehicle_opinion/opinion_list.dart';
import 'damaged_result/vehicle_list.dart';

class TrafficMainPage extends StatefulWidget {
  final int? caseID;
  final String? caseNo;
  final bool isLocal;

  const TrafficMainPage(
      {super.key, required this.caseID, this.caseNo, this.isLocal = false});

  @override
  TrafficMainPageState createState() => TrafficMainPageState();
}

class TrafficMainPageState extends State<TrafficMainPage> {
  bool isPhone = Device.get().isPhone;

  bool isLoading = true;
  FidsCrimeScene? data;
  List<CaseRelatedPerson> relatedPersons = [];
  List<CaseInspection> caseInspectionList = [];
  List<CaseInspector> caseInspectorList = [];
  List<CaseEvidentFound> caseEvidentFounds = [];
  List<CaseEvidentForm> caseEvidents = [];
  DiagramLocation diagramLocation = DiagramLocation();
  List<CaseReferencePoint> referencePointList = [];
  List<CaseImages> caseImageList = [];
  List<CaseVehicle> caseVehicles = [];
  List<CaseVehicleOpinion> caseOpinions = [];

  bool _relatedPersonNotEmpty = false;

  bool _isFidsNoNotEmpty = false,
      _isLocationNotEmpty = false,
      _isCaseVehicleNotEmpty = false,
      _isVictimDateNotEmpty = false,
      _isCaseInspectionNotEmpty = false,
      _isCaseInspectorNotEmpty = false,
      _isCaseBehaviorNotEmpty = false,
      _isOpinionNotEmpty = false,
      _isImageNotEmpty = false,
      _isTrafficObjectiveNotEmpty = false,
      _isCaseCompareNotEmpty = false;

  @override
  void initState() {
    if (kDebugMode) {
      print('fidsNo : ${widget.caseNo}');
      print('fidsId : ${widget.caseID}');
    }

    super.initState();
    asyncCall();
  }

  void asyncCall() async {
    var fidsCrimeScene =
        await FidsCrimeSceneDao().getFidsCrimeSceneById(widget.caseID ?? -1);
    var vehicles = await CaseVehicleDao().getCaseVehicle(widget.caseID ?? -1);
    var relatedPerson =
        await CaseRelatedPersonDao().getCaseRelatedPerson(widget.caseID ?? -1);
    var inspections =
        await CaseInspectionDao().getCaseInspection(widget.caseID ?? -1);
    var inspectors =
        await CaseInspectorDao().getCaseInspector(widget.caseID ?? -1);
    var evident = await CaseEvidentDao().getCaseEvident(widget.caseID ?? -1);
    var image = await CaseImagesDao().getCaseImages(widget.caseID ?? -1);
    var caseVehiclesOpinions = await CaseVehicleOpinionDao()
        .getCaseVehicleOpinions(widget.caseID ?? -1);
    var caseCompare = await CaseVehicleCompareDao()
        .getCaseVehicleCompare(widget.caseID ?? -1);

    setState(() {
      data = fidsCrimeScene;
      relatedPersons = relatedPerson;
      caseInspectionList = inspections;
      caseInspectorList = inspectors;
      caseEvidents = evident = [];
      caseImageList = image;
      caseOpinions = caseVehiclesOpinions;
      caseVehicles = vehicles;
      _isFidsNoNotEmpty = data?.fidsNo != null &&
          data?.fidsNo != '' &&
          data?.fidsNo != 'null' &&
          data?.fidsNo != 'Null';
      _isLocationNotEmpty = data?.isoLatitude != null &&
          data?.isoLatitude != '' &&
          data?.isoLatitude != 'null' &&
          data?.isoLatitude != 'Null' &&
          data?.isoLongtitude != null &&
          data?.isoLongtitude != '' &&
          data?.isoLongtitude != 'null' &&
          data?.isoLongtitude != 'Null';
      _isCaseVehicleNotEmpty = caseVehicles.isNotEmpty;
      _relatedPersonNotEmpty = relatedPersons.isNotEmpty;
      _isVictimDateNotEmpty = data?.caseVictimDate != null &&
          data?.caseVictimDate != '' &&
          data?.caseVictimDate != 'null' &&
          data?.caseVictimDate != 'Null';
      _isCaseInspectionNotEmpty = caseInspectionList.isNotEmpty;
      _isCaseInspectorNotEmpty = caseInspectorList.isNotEmpty;
      _isTrafficObjectiveNotEmpty = fidsCrimeScene?.trafficObjective != -1;
      _isCaseBehaviorNotEmpty = data?.caseBehavior != null &&
          data?.caseBehavior != '' &&
          data?.caseBehavior != 'null' &&
          data?.caseBehavior != 'Null';
      _isImageNotEmpty = caseImageList.isNotEmpty;
      _isOpinionNotEmpty = caseVehiclesOpinions.isNotEmpty;
      _isCaseCompareNotEmpty = caseCompare.isNotEmpty;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBarWidget(
        title: 'คดีจราจร',
        leading: IconButton(
            icon: isIOS
                ? const Icon(Icons.arrow_back_ios)
                : const Icon(Icons.arrow_back),
            onPressed: () async {
              Navigator.of(context).pop(true);
            }),
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
                      requestView('1.การรับแจ้งเหตุ', '', _isFidsNoNotEmpty,
                          () async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RequestCaseDetail(
                                    caseID: widget.caseID ?? -1,
                                    isLocal: widget.isLocal,
                                    caseNo: widget.caseNo)));
                        asyncCall();
                      }),
                      spacer(context),
                      requestView('รถของกลาง (${caseVehicles.length})', '',
                          _isCaseVehicleNotEmpty, () async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CaseVehicleList(
                                      caseID: widget.caseID ?? -1,
                                      caseNo: widget.caseNo,
                                      isLocal: widget.isLocal,
                                    )));

                        asyncCall();
                      }),
                      spacer(context),
                      requestView('สถานที่เกิดเหตุ', '', _isLocationNotEmpty,
                          () async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LocationCase(
                                      caseID: widget.caseID ?? -1,
                                      caseNo: widget.caseNo,
                                      isLocal: widget.isLocal,
                                    )));

                        asyncCall();
                      }),
                      spacer(context),
                      requestView('ผู้เกี่ยวข้อง (${relatedPersons.length})',
                          '', _relatedPersonNotEmpty, () async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RelatePerson(
                                    caseID: widget.caseID ?? -1,
                                    caseNo: widget.caseNo,
                                    isLocal: widget.isLocal,
                                    isWitnessCasePerson: false)));
                        asyncCall();
                      }),
                      spacer(context),
                      requestView('วันเวลาที่ทราบเหตุ/เกิดเหตุ', '',
                          _isVictimDateNotEmpty, () async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CaseDatetime(
                                      caseID: widget.caseID ?? -1,
                                      caseNo: widget.caseNo,
                                      isLocal: widget.isLocal,
                                    )));
                        asyncCall();
                      }),
                      spacer(context),
                      requestView(
                          'วันเวลาที่ตรวจเหตุ (${caseInspectionList.length})',
                          '',
                          _isCaseInspectionNotEmpty, () async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DateTimeInspectCase(
                                      caseID: widget.caseID ?? -1,
                                      caseNo: widget.caseNo,
                                      isLocal: widget.isLocal,
                                    )));

                        asyncCall();
                      }),
                      spacer(context),
                      requestView('2.จุดประสงค์ในการตรวจพิสูจน์', '',
                          _isTrafficObjectiveNotEmpty, () async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TrafficObjectivePage(
                                      caseID: widget.caseID ?? -1,
                                      caseNo: widget.caseNo,
                                      isLocal: widget.isLocal,
                                    )));
                        asyncCall();
                      }),
                      spacer(context),
                      requestView(
                          '3.ผู้ตรวจพิสูจน์ (${caseInspectorList.length})',
                          '',
                          _isCaseInspectorNotEmpty, () async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => InspectorCase(
                                      caseID: widget.caseID ?? -1,
                                      caseNo: widget.caseNo,
                                      isLocal: widget.isLocal,
                                    )));
                        asyncCall();
                      }),
                      spacer(context),
                      header('4.ผลการตรวจพิสูจน์'),
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
                                    fieldName: 'CaseBehavior')));
                        asyncCall();
                      }),
                      spacer(context),
                      requestView(
                          'ผลการตรวจพิสูจน์', '', _isCaseVehicleNotEmpty,
                          () async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VehicleList(
                                    caseID: widget.caseID ?? -1,
                                    caseNo: widget.caseNo,
                                    isLocal: widget.isLocal)));
                        asyncCall();
                      }),
                      spacer(context),
                      requestView(
                          '5.ผลการตรวจเปรียบเทียบ', '', _isCaseCompareNotEmpty,
                          () async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CompareListPage(
                                      caseID: widget.caseID ?? -1,
                                      caseNo: widget.caseNo ?? '',
                                      isLocal: widget.isLocal,
                                    )));
                        asyncCall();
                      }),
                      spacer(context),
                      requestView('6.ความเห็น (${caseOpinions.length})', '',
                          _isOpinionNotEmpty, () async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CaseVehicleOpinionList(
                                      caseID: widget.caseID ?? -1,
                                      caseNo: widget.caseNo,
                                    )));
                        asyncCall();
                      }),
                      spacer(context),
                      requestView('รูปภาพ (${caseImageList.length})', '',
                          _isImageNotEmpty, () async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CaseImage(
                                    caseID: widget.caseID ?? -1,
                                    caseNo: widget.caseNo,
                                    isLocal: widget.isLocal)));
                        asyncCall();
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
