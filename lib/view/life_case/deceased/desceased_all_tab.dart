import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/color.dart';
import '../../../models/BodyPosition.dart';
import '../../../models/CaseBody.dart';
import '../../../models/CaseBodyReferencePoint.dart';
import '../../../models/CaseBodyWound.dart';
import '../../../models/CaseRelatedPerson.dart';
import '../../../models/Title.dart';
import '../../../models/Unit.dart';
import '../../../models/UnitMeter.dart';
import '../../../widget/app_button.dart';
import '../../../widget/blurry_dialog.dart';
import 'add_body_reference_positon.dart';
import 'add_lesion.dart';
import 'draw_template.dart';
import 'dress.dart';
import 'edit_decease.dart';

class AddDeceased extends StatefulWidget {
  final int? caseID;
  final String? caseNo;
  final int? caseBodyId;
  final bool isEdit;

  const AddDeceased(
      {super.key,
      this.caseID,
      this.caseNo,
      this.caseBodyId,
      this.isEdit = false});

  @override
  AddDeceasedState createState() => AddDeceasedState();
}

class AddDeceasedState extends State<AddDeceased>
    with SingleTickerProviderStateMixin {
  bool isPhone = Device.get().isPhone;
  bool isDrewTemplate = false;

  bool isLoading = true;
  List<UnitMeter> unitMeter = [
    UnitMeter(id: 1, unitLabel: 'เมตร'),
    UnitMeter(id: 2, unitLabel: 'เซนติเมตร')
  ];

  CaseBody caseBody = CaseBody();

  List<String> titleList = [];
  List<MyTitle> titles = [];
  List<Unit> units = [];

  List<BodyPosition> listBodyPositions = [];
  List<CaseBodyReferencePoint> caseBodyReferencePoints = [];
  List<CaseBodyWound> caseBodyWounds = [];
  CaseBodyReferencePoint caseBodyRefPoint = CaseBodyReferencePoint();
  late TabController controller;
  Image imageBody = Image.asset('images/body.png');

  final int _radioClothingValue = 0;
  final int _radioPantsValue = 0;
  final int _radioShoesValue = 0;
  final int _radioBeltValue = 0;
  final int _radioTattooValue = 0;
  int _radioTabFourValue = 2;
  String? personalSelectId;

  final TextEditingController _personalController = TextEditingController();

  List<CaseRelatedPerson> caseRelatedPerson = [];
  List<String> caseRelatedPersonLabel = [];

  String? unitLabel(String? id) {
    for (int i = 0; i < units.length; i++) {
      if ('$id' == '${units[i].id}') {
        return units[i].name;
      }
    }
    return '';
  }

  String? meterLabel(String? id) {
    for (int i = 0; i < unitMeter.length; i++) {
      if ('$id' == '${unitMeter[i].id}') {
        return unitMeter[i].unitLabel;
      }
    }
    return '';
  }

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 5, vsync: this);
    asyncMethod();
    if (kDebugMode) {
      print('widget.isEdit ${widget.isEdit}');
    }
  }

  asyncMethod() async {
    asyncCall1();
  }

  void asyncCall1() async {
    var result = await TitleDao().getTitleLabel();
    var result2 = await TitleDao().getTitle();
    CaseBody? result3;
    var result5 = await UnitDao().getUnit();
    var result7 = await BodyPositionDao().getBodyPosition();

    var getCaseRelatedPerson =
        await CaseRelatedPersonDao().getCaseRelatedPerson(widget.caseID ?? -1);
    var getCaseRelatedPersonLabel = await CaseRelatedPersonDao()
        .getCaseRelatedPersonLabel(widget.caseID ?? -1);

    if (widget.isEdit) {
      result3 = await CaseBodyDao().getCaseBodyById(widget.caseBodyId ?? -1);
    }
    setState(() {
      titleList = result;
      titles = result2;
      units = result5;
      listBodyPositions = result7;

      caseRelatedPerson = getCaseRelatedPerson;
      caseRelatedPersonLabel = getCaseRelatedPersonLabel;
      if (kDebugMode) {
        print('fong ${caseBodyWounds.toString()}');
      }

      if (widget.isEdit) {
        caseBody = result3 ?? CaseBody();
        for (int i = 0; i < caseRelatedPerson.length; i++) {
          if ('${caseRelatedPerson[i].id}' == '${caseBody.personalID}') {
            personalSelectId = caseBody.personalID;
            _personalController.text = personaltLabel(personalSelectId) ?? '';
          }
        }

        if (kDebugMode) {
          print('caseBody.isWound ${caseBody.isWound}');
          print('caseBody.caseBodyWounds ${caseBodyWounds.length}');
          print(
              'caseBody.caseBodyReferencePoints ${caseBodyReferencePoints.length}');
        }

        if (caseBody.isWound != null || caseBody.isWound != '') {
          _radioTabFourValue = int.parse(caseBody.isWound ?? '');
        }

        if (caseBody.bodyDiagram != null && caseBody.bodyDiagram != '') {
          isDrewTemplate = true;
        }
      }
      isLoading = false;
    });
  }

  String? ageLabel(String? id) {
    for (int i = 0; i < caseRelatedPerson.length; i++) {
      if ('$id' == '${caseRelatedPerson[i].id}') {
        return caseRelatedPerson[i].age;
      }
    }
    return '';
  }

  String? personaltLabel(String? id) {
    for (int i = 0; i < caseRelatedPerson.length; i++) {
      if ('$id' == '${caseRelatedPerson[i].id}') {
        return caseRelatedPersonLabel[i];
      }
    }
    return '';
  }

  void asyncCall2() async {
    var result = await CaseBodyReferencePointDao()
        .getCaseBodyReferencePointById(widget.caseBodyId.toString());
    setState(() {
      caseBodyReferencePoints = result;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Container(
            alignment: Alignment.center,
            child: Text(
              'ผู้เสียชีวิต',
              style: GoogleFonts.prompt(
                textStyle: TextStyle(
                  color: Colors.white,
                  letterSpacing: 0,
                  fontSize: MediaQuery.of(context).size.height * 0.025,
                ),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          leading: IconButton(
            icon: isIOS
                ? const Icon(Icons.arrow_back_ios)
                : const Icon(Icons.arrow_back),
            onPressed: () async {
              if (kDebugMode) {
                print('1widget.isEdit ${widget.isEdit}');
              }
              if ((caseBody.labelNo != '' && caseBody.labelNo != null) ||
                  caseBodyReferencePoints.isNotEmpty ||
                  caseBodyWounds.isNotEmpty) {
                if (widget.isEdit) {
                  if (kDebugMode) {
                    print('1_radioTabFourValue $_radioTabFourValue');
                  }
                  await CaseBodyDao().updateCaseBody(
                      caseBody.labelNo,
                      caseBody.bodyTitleName,
                      caseBody.bodyFirstName,
                      caseBody.bodyLastName,
                      caseBody.bodyFoundLocation,
                      caseBody.bodyFoundCondition,
                      caseBody.fidsId == '' || caseBody.fidsId == null
                          ? -2
                          : int.parse(caseBody.fidsId ?? ''),
                      caseBody.isClothing == '' || caseBody.isClothing == null
                          ? -2
                          : int.parse(caseBody.isClothing ?? ''),
                      caseBody.clothingDetail,
                      caseBody.isPants == '' || caseBody.isPants == null
                          ? -2
                          : int.parse(caseBody.isPants ?? ''),
                      caseBody.pantsDetail,
                      caseBody.isShoes == '' || caseBody.isShoes == null
                          ? -2
                          : int.parse(caseBody.isShoes ?? ''),
                      caseBody.shoesDetail,
                      caseBody.isBelt == '' || caseBody.isBelt == null
                          ? -2
                          : int.parse(caseBody.isBelt ?? ''),
                      caseBody.beltDetail,
                      caseBody.isTattoo == '' || caseBody.isTattoo == null
                          ? -2
                          : int.parse(caseBody.isTattoo ?? ''),
                      caseBody.tattooDetail,
                      caseBody.dressOther,
                      caseBody.investigatorDoctor,
                      caseBody.bodyDiagram,
                      _radioTabFourValue,
                      caseBody.personalID,
                      caseBody.createDate,
                      caseBody.createBy,
                      caseBody.updateDate,
                      caseBody.updateBy,
                      caseBody.activeFlag == '' || caseBody.activeFlag == null
                          ? -2
                          : int.parse(caseBody.activeFlag ?? ''),
                      caseBody.id == '' || caseBody.id == null
                          ? -2
                          : int.parse(caseBody.id ?? ''));

                  if (kDebugMode) {
                    print(
                        'caseBodyReferencePoints ${caseBodyReferencePoints.length}');
                  }
                  for (int i = 0; i < caseBodyReferencePoints.length; i++) {
                    if (caseBodyReferencePoints[i].id == null) {
                      if (kDebugMode) {
                        print('createCaseBodyReferencePoint');
                      }
                      caseBodyReferencePoints[i].bodyId =
                          '${widget.caseBodyId}';
                      caseBodyReferencePoints[i].fidsId =
                          widget.caseID.toString();
                      CaseBodyReferencePointDao().createCaseBodyReferencePoint(
                          caseBodyReferencePoints[i].fidsId == '' || caseBodyReferencePoints[i].fidsId == null
                              ? -2
                              : int.parse(
                                  caseBodyReferencePoints[i].fidsId ?? ''),
                          caseBodyReferencePoints[i].bodyId == '' ||
                                  caseBodyReferencePoints[i].bodyId == null
                              ? -2
                              : int.parse(
                                  caseBodyReferencePoints[i].bodyId ?? ''),
                          caseBodyReferencePoints[i].referenceDetail,
                          caseBodyReferencePoints[i].referenceID1 == '' || caseBodyReferencePoints[i].referenceID1 == null
                              ? -2
                              : int.parse(caseBodyReferencePoints[i].referenceID1 ??
                                  ''),
                          caseBodyReferencePoints[i].referenceDistance1 == '' ||
                                  caseBodyReferencePoints[i].referenceDistance1 ==
                                      null
                              ? -2
                              : double.parse(caseBodyReferencePoints[i].referenceDistance1 ??
                                  ''),
                          caseBodyReferencePoints[i].referenceUnitId1 == '' ||
                                  caseBodyReferencePoints[i].referenceUnitId1 == null
                              ? -2
                              : int.parse(caseBodyReferencePoints[i].referenceUnitId1 ?? ''),
                          caseBodyReferencePoints[i].referenceID2 == '' || caseBodyReferencePoints[i].referenceID2 == null ? -2 : int.parse(caseBodyReferencePoints[i].referenceID2 ?? ''),
                          caseBodyReferencePoints[i].referenceDistance2 == '' || caseBodyReferencePoints[i].referenceDistance2 == null ? -2 : double.parse(caseBodyReferencePoints[i].referenceDistance2 ?? ''),
                          caseBodyReferencePoints[i].referenceUnitId2 == '' || caseBodyReferencePoints[i].referenceUnitId2 == null ? -2 : int.parse(caseBodyReferencePoints[i].referenceUnitId2 ?? ''),
                          caseBodyReferencePoints[i].bodyPositionId == '' || caseBodyReferencePoints[i].bodyPositionId == null ? '' : '${caseBodyReferencePoints[i].bodyPositionId}',
                          caseBodyReferencePoints[i].createDate,
                          caseBodyReferencePoints[i].createBy,
                          caseBodyReferencePoints[i].updateDate,
                          caseBodyReferencePoints[i].updateBy,
                          -1);
                    } else {
                      if (kDebugMode) {
                        print('updateCaseBodyReferencePoint');
                      }
                      CaseBodyReferencePointDao().updateCaseBodyReferencePoint(
                          caseBodyReferencePoints[i].fidsId == '' || caseBodyReferencePoints[i].fidsId == null
                              ? -2
                              : int.parse(
                                  caseBodyReferencePoints[i].fidsId ?? ''),
                          caseBodyReferencePoints[i].bodyId == '' ||
                                  caseBodyReferencePoints[i].bodyId == null
                              ? -2
                              : int.parse(
                                  caseBodyReferencePoints[i].bodyId ?? ''),
                          caseBodyReferencePoints[i].referenceDetail,
                          caseBodyReferencePoints[i].referenceID1 == '' || caseBodyReferencePoints[i].referenceID1 == null
                              ? -2
                              : int.parse(caseBodyReferencePoints[i].referenceID1 ??
                                  ''),
                          caseBodyReferencePoints[i].referenceDistance1 == '' ||
                                  caseBodyReferencePoints[i].referenceDistance1 ==
                                      null
                              ? -2
                              : double.parse(caseBodyReferencePoints[i].referenceDistance1 ??
                                  ''),
                          caseBodyReferencePoints[i].referenceUnitId1 == '' ||
                                  caseBodyReferencePoints[i].referenceUnitId1 == null
                              ? -2
                              : int.parse(caseBodyReferencePoints[i].referenceUnitId1 ?? ''),
                          caseBodyReferencePoints[i].referenceID2 == '' || caseBodyReferencePoints[i].referenceID2 == null ? -2 : int.parse(caseBodyReferencePoints[i].referenceID2 ?? ''),
                          caseBodyReferencePoints[i].referenceDistance2 == '' || caseBodyReferencePoints[i].referenceDistance2 == null ? -2 : double.parse(caseBodyReferencePoints[i].referenceDistance2 ?? ''),
                          caseBodyReferencePoints[i].referenceUnitId2 == '' || caseBodyReferencePoints[i].referenceUnitId2 == null ? -2 : int.parse(caseBodyReferencePoints[i].referenceUnitId2 ?? ''),
                          caseBodyReferencePoints[i].bodyPositionId == '' || caseBodyReferencePoints[i].bodyPositionId == null ? '' : '${caseBodyReferencePoints[i].bodyPositionId}',
                          caseBodyReferencePoints[i].createDate,
                          caseBodyReferencePoints[i].createBy,
                          caseBodyReferencePoints[i].updateDate,
                          caseBodyReferencePoints[i].updateBy,
                          -1,
                          caseBodyReferencePoints[i].id == '' || caseBodyReferencePoints[i].id == null ? -2 : int.parse(caseBodyReferencePoints[i].id ?? ''));
                    }
                  }
                  if (kDebugMode) {
                    print('what TEST');
                    print('what ${caseBodyWounds.toString()}');
                  }
                  for (int i = 0; i < caseBodyWounds.length; i++) {
                    if (caseBodyWounds[i].id == null ||
                        caseBodyWounds[i].id == 'null' ||
                        caseBodyWounds[i].id == '') {
                      if (kDebugMode) {
                        print('FONGCHOL createCaseBodyWound');
                      }
                      caseBodyWounds[i].bodyId = '${widget.caseBodyId}';
                      CaseBodyWoundDao().createCaseBodyWound(
                          caseBodyWounds[i].bodyId == '' ||
                                  caseBodyWounds[i].bodyId == null
                              ? -2
                              : int.parse(caseBodyWounds[i].bodyId ?? ''),
                          caseBodyWounds[i].woundDetail,
                          caseBodyWounds[i].woundPosition,
                          caseBodyWounds[i].woundSize == '' ||
                                  caseBodyWounds[i].woundSize == null
                              ? ''
                              : caseBodyWounds[i].woundSize,
                          caseBodyWounds[i].woundUnitId,
                          caseBodyWounds[i].woundAmount,
                          caseBodyWounds[i].createDate,
                          caseBodyWounds[i].createBy,
                          caseBodyWounds[i].updateDate,
                          caseBodyWounds[i].updateBy,
                          1);
                    } else {
                      if (kDebugMode) {
                        print('FONGCHOL updateCaseBodyWound');
                      }

                      CaseBodyWoundDao().updateCaseBodyWound(
                          caseBodyWounds[i].bodyId == '' ||
                                  caseBodyWounds[i].bodyId == null
                              ? -2
                              : int.parse(caseBodyWounds[i].bodyId ?? ''),
                          caseBodyWounds[i].woundDetail,
                          caseBodyWounds[i].woundPosition,
                          caseBodyWounds[i].woundSize == '' ||
                                  caseBodyWounds[i].woundSize == null
                              ? ''
                              : caseBodyWounds[i].woundSize,
                          caseBodyWounds[i].woundUnitId,
                          caseBodyWounds[i].woundAmount,
                          caseBodyWounds[i].createDate,
                          caseBodyWounds[i].createBy,
                          caseBodyWounds[i].updateDate,
                          caseBodyWounds[i].updateBy,
                          1,
                          caseBodyWounds[i].woundUnitId == ''
                              ? -2
                              : int.parse(caseBodyWounds[i].id ?? ''));
                    }
                  }
                } else {
                  if (kDebugMode) {
                    print('_radioTabFourValue $_radioTabFourValue');
                  }
                  var caseBodyId = await CaseBodyDao().createCaseBody(
                      caseBody.labelNo,
                      caseBody.bodyTitleName,
                      caseBody.bodyFirstName,
                      caseBody.bodyLastName,
                      caseBody.bodyFoundLocation,
                      caseBody.bodyFoundCondition,
                      widget.caseID ?? -1,
                      caseBody.isClothing == null
                          ? -2
                          : int.parse(caseBody.isClothing ?? ''),
                      caseBody.clothingDetail,
                      caseBody.isPants == '' || caseBody.isPants == null
                          ? -2
                          : int.parse(caseBody.isPants ?? ''),
                      caseBody.pantsDetail,
                      caseBody.isShoes == '' || caseBody.isShoes == null
                          ? -2
                          : int.parse(caseBody.isShoes ?? ''),
                      caseBody.shoesDetail,
                      caseBody.isBelt == '' || caseBody.isBelt == null
                          ? -2
                          : int.parse(caseBody.isBelt ?? ''),
                      caseBody.beltDetail,
                      caseBody.isTattoo == '' || caseBody.isTattoo == null
                          ? -2
                          : int.parse(caseBody.isTattoo ?? ''),
                      caseBody.tattooDetail,
                      caseBody.dressOther,
                      caseBody.investigatorDoctor,
                      caseBody.bodyDiagram,
                      _radioTabFourValue,
                      caseBody.personalID,
                      caseBody.createDate,
                      caseBody.createBy,
                      caseBody.updateDate,
                      caseBody.updateBy,
                      1);

                  if (kDebugMode) {
                    print('caseBodyId $caseBodyId');
                  }
                  for (int i = 0; i < caseBodyReferencePoints.length; i++) {
                    caseBodyReferencePoints[i].bodyId = '$caseBodyId';
                    caseBodyReferencePoints[i].fidsId =
                        widget.caseID.toString();
                    CaseBodyReferencePointDao().createCaseBodyReferencePoint(
                        caseBodyReferencePoints[i].fidsId == '' ||
                                caseBodyReferencePoints[i].fidsId == null
                            ? -2
                            : int.parse(
                                caseBodyReferencePoints[i].fidsId ?? ''),
                        caseBodyReferencePoints[i].bodyId == '' ||
                                caseBodyReferencePoints[i].bodyId == null
                            ? -2
                            : int.parse(
                                caseBodyReferencePoints[i].bodyId ?? ''),
                        caseBodyReferencePoints[i].referenceDetail,
                        caseBodyReferencePoints[i].referenceID1 == '' ||
                                caseBodyReferencePoints[i].referenceID1 == null
                            ? -2
                            : int.parse(
                                caseBodyReferencePoints[i].referenceID1 ?? ''),
                        caseBodyReferencePoints[i].referenceDistance1 == '' ||
                                caseBodyReferencePoints[i].referenceDistance1 ==
                                    null
                            ? -2
                            : double.parse(caseBodyReferencePoints[i].referenceDistance1 ??
                                ''),
                        caseBodyReferencePoints[i].referenceUnitId1 == '' ||
                                caseBodyReferencePoints[i].referenceUnitId1 == null
                            ? -2
                            : int.parse(caseBodyReferencePoints[i].referenceUnitId1 ?? ''),
                        caseBodyReferencePoints[i].referenceID2 == '' || caseBodyReferencePoints[i].referenceID2 == null ? -2 : int.parse(caseBodyReferencePoints[i].referenceID2 ?? ''),
                        caseBodyReferencePoints[i].referenceDistance2 == '' || caseBodyReferencePoints[i].referenceDistance2 == null ? -2 : double.parse(caseBodyReferencePoints[i].referenceDistance2 ?? ''),
                        caseBodyReferencePoints[i].referenceUnitId2 == '' || caseBodyReferencePoints[i].referenceUnitId2 == null ? -2 : int.parse(caseBodyReferencePoints[i].referenceUnitId2 ?? ''),
                        caseBodyReferencePoints[i].bodyPositionId == '' || caseBodyReferencePoints[i].bodyPositionId == null ? '' : '${caseBodyReferencePoints[i].bodyPositionId}',
                        caseBodyReferencePoints[i].createDate,
                        caseBodyReferencePoints[i].createBy,
                        caseBodyReferencePoints[i].updateDate,
                        caseBodyReferencePoints[i].updateBy,
                        -1);
                  }

                  for (int i = 0; i < caseBodyWounds.length; i++) {
                    caseBodyWounds[i].bodyId = '$caseBodyId';
                    CaseBodyWoundDao()
                        .createCaseBodyWound(
                            caseBodyWounds[i].bodyId == '' ||
                                    caseBodyWounds[i].bodyId == null
                                ? -2
                                : int.parse(caseBodyWounds[i].bodyId ?? ''),
                            caseBodyWounds[i].woundDetail,
                            caseBodyWounds[i].woundPosition,
                            caseBodyWounds[i].woundSize == '' ||
                                    caseBodyWounds[i].woundSize == null
                                ? ''
                                : caseBodyWounds[i].woundSize,
                            caseBodyWounds[i].woundUnitId,
                            caseBodyWounds[i].woundAmount,
                            caseBodyWounds[i].createDate,
                            caseBodyWounds[i].createBy,
                            caseBodyWounds[i].updateDate,
                            caseBodyWounds[i].updateBy,
                            1)
                        .then((value) => Navigator.of(context).pop(true));
                  }
                }
              } else {
                Navigator.of(context).pop();
              }
            },
          ),
          actions: [
            Container(
              width: MediaQuery.of(context).size.width * 0.1,
            )
          ],
          bottom: TabBar(
            indicatorColor: pinkButton,
            indicatorWeight: 10,
            labelColor: const Color(0xffffffff), // สีของข้อความปุ่มที่เลือก
            unselectedLabelColor:
                const Color(0x55ffffff), // สีของข้อความปุ่มที่ไม่ได้เลือก
            tabs: <Tab>[
              Tab(
                // icon: Icon(Icons.domain, color: Colors.white),
                child: Text(
                  'ชื่อ',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.prompt(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: isPhone
                          ? MediaQuery.of(context).size.height * 0.01
                          : MediaQuery.of(context).size.height * 0.02,
                    ),
                  ),
                ),
              ),
              Tab(
                // icon: Icon(Icons.domain_disabled, color: Colors.white),
                child: Text(
                  'ระยะห่าง',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.prompt(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: isPhone
                          ? MediaQuery.of(context).size.height * 0.01
                          : MediaQuery.of(context).size.height * 0.02,
                    ),
                  ),
                ),
              ),
              Tab(
                // icon: Icon(Icons.pin_drop, color: Colors.white),
                child: Text(
                  'การแต่งกาย',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.prompt(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: isPhone
                          ? MediaQuery.of(context).size.height * 0.01
                          : MediaQuery.of(context).size.height * 0.02,
                    ),
                  ),
                ),
              ),
              Tab(
                // icon: Icon(Icons.account_tree, color: Colors.white),
                child: Text(
                  'สภาพรอยแผล',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.prompt(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: isPhone
                          ? MediaQuery.of(context).size.height * 0.01
                          : MediaQuery.of(context).size.height * 0.02,
                    ),
                  ),
                ),
              ),
              Tab(
                // icon: Icon(Icons.account_tree, color: Colors.white),
                child: Text(
                  'แผนผัง',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.prompt(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: isPhone
                          ? MediaQuery.of(context).size.height * 0.01
                          : MediaQuery.of(context).size.height * 0.02,
                    ),
                  ),
                ),
              ),
            ],
            controller: controller,
          ),
        ),
        body: TabBarView(
          controller: controller,
          children: <Widget>[
            _tabOne(),
            _tabTwo(),
            _tabThree(),
            _tabFour(),
            _tabFive()
          ],
        ));
  }

  Widget headerView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          'ผู้เสียชีวิต',
          textAlign: TextAlign.center,
          style: GoogleFonts.prompt(
            textStyle: TextStyle(
              color: Colors.white,
              letterSpacing: .5,
              fontSize: MediaQuery.of(context).size.height * 0.025,
            ),
          ),
        ),
        TextButton(
            onPressed: () async {
              // Navigator.pushNamed(context, '/editdetail');
              var result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditDecease(
                          caseID: widget.caseID ?? -1,
                          caseNo: widget.caseNo,
                          caseBody: caseBody,
                          isEdit: widget.isEdit)));
              if (result != null) {
                setState(() {
                  caseBody = result;

                  for (int i = 0; i < caseRelatedPerson.length; i++) {
                    if ('${caseRelatedPerson[i].id}' ==
                        '${caseBody.personalID}') {
                      personalSelectId = caseBody.personalID;
                      _personalController.text =
                          personaltLabel(personalSelectId) ?? '';
                    }
                  }
                });
              }
            },
            child: Row(
              children: [
                Icon(Icons.edit,
                    color: Colors.white,
                    size: MediaQuery.of(context).size.height * 0.025),
                Text(
                  'แก้ไข',
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
            ))
      ],
    );
  }

  Widget _tabOne() {
    return Container(
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
              : const EdgeInsets.only(left: 32, right: 32, top: 32, bottom: 32),
          child: ListView(shrinkWrap: true, children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: headerView(),
            ),
            subtitle('ป้ายหมายเลข'),
            spacer(context),
            detailView('${_cleanText(caseBody.labelNo)}'),
            spacer(context),
            subtitle('ผู้เสียชีวิต'),
            spacer(context),
            detailView(_personalController.text),
            spacer(context),
            subtitle('ตำแหน่งที่พบศพ'),
            spacer(context),
            detailView('${_cleanText(caseBody.bodyFoundLocation)}'),
            spacer(context),
            subtitle('สภาพศพ'),
            spacer(context),
            detailView('${_cleanText(caseBody.bodyFoundCondition)}'),
            spacer(context),
          ]),
        ),
      ),
    );
  }

  Widget subtitle(String? text) {
    return Text(
      '$text',
      textAlign: TextAlign.left,
      style: GoogleFonts.prompt(
        textStyle: TextStyle(
          color: Colors.white,
          letterSpacing: .5,
          fontSize: MediaQuery.of(context).size.height * 0.022,
        ),
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
          fontSize: MediaQuery.of(context).size.height * 0.03,
        ),
      ),
    );
  }

  Widget spacer(context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.015,
    );
  }

  Widget saveTabOneButton() {
    return AppButton(
        color: pinkButton,
        textColor: Colors.white,
        text: 'บันทึก',
        onPressed: () {
          // Navigator.pushReplacementNamed(context, '/home');
          Navigator.of(context).pop();
        });
  }

  Widget _tabTwo() {
    return Container(
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
                child: Column(
                  children: [
                    headerTabTwoView(),
                    Expanded(
                      child: ListView.builder(
                          itemCount: caseBodyReferencePoints.length,
                          itemBuilder: (BuildContext ctxt, int index) {
                            return _listItem(index);
                          }),
                    ),
                  ],
                ))));
  }

  Widget headerTabTwoView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          'รายละเอียดผู้เสียชีวิต',
          textAlign: TextAlign.center,
          style: GoogleFonts.prompt(
            textStyle: TextStyle(
              color: Colors.white,
              letterSpacing: .5,
              fontSize: MediaQuery.of(context).size.height * 0.025,
            ),
          ),
        ),
        TextButton(
            onPressed: () async {
              var result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddBodyReferencePosition(
                          caseID: widget.caseID ?? -1,
                          caseNo: widget.caseNo,
                          isEdit: false)));
              if (result != null) {
                if (kDebugMode) {
                  print(result);
                }
                setState(() {
                  caseBodyReferencePoints.add(result);
                });
              }
            },
            child: Row(
              children: [
                const Icon(Icons.add, color: Colors.white),
                Text(
                  'เพิ่ม',
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
            ))
      ],
    );
  }

  Widget _listItem(int index) {
    return Slidable(
      endActionPane: ActionPane(
        extentRatio: 0.3,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            flex: 1,
            onPressed: (BuildContext context) {
              confirmRemoveBodyRef(context, index);
            },
            backgroundColor: Colors.red,
            icon: Icons.delete,
            label: 'ลบ',
          ),
        ],
      ),
      child: TextButton(
          style: TextButton.styleFrom(
              padding: EdgeInsets.zero, alignment: Alignment.centerLeft),
          child: Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 10),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'ตำแหน่ง',
                          textAlign: TextAlign.start,
                          style: GoogleFonts.prompt(
                            textStyle: TextStyle(
                              color: textColor,
                              letterSpacing: .5,
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.020,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '${bodyPositionLabel(caseBodyReferencePoints[index].bodyPositionId)}',
                      textAlign: TextAlign.start,
                      style: GoogleFonts.prompt(
                        textStyle: TextStyle(
                          color: textColor,
                          letterSpacing: .5,
                          fontSize: MediaQuery.of(context).size.height * 0.025,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'รายละเอียด',
                          textAlign: TextAlign.start,
                          style: GoogleFonts.prompt(
                            textStyle: TextStyle(
                              color: textColor,
                              letterSpacing: .5,
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.020,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '${caseBodyReferencePoints[index].referenceDetail}',
                      textAlign: TextAlign.start,
                      style: GoogleFonts.prompt(
                        textStyle: TextStyle(
                          color: textColor,
                          letterSpacing: .5,
                          fontSize: MediaQuery.of(context).size.height * 0.025,
                        ),
                      ),
                    ),
                    Text(
                      'จุดอ้างอิงที่ 1',
                      textAlign: TextAlign.start,
                      style: GoogleFonts.prompt(
                        textStyle: TextStyle(
                          color: textColor,
                          letterSpacing: .5,
                          fontSize: MediaQuery.of(context).size.height * 0.020,
                        ),
                      ),
                    ),
                    Text(
                      '${caseBodyReferencePoints[index].referenceDistance1} ${caseBodyReferencePoints[index].referenceUnitId1 == '1' ? 'เมตร' : 'เซนติเมตร'} ',
                      textAlign: TextAlign.start,
                      style: GoogleFonts.prompt(
                        textStyle: TextStyle(
                          color: textColor,
                          letterSpacing: .5,
                          fontSize: MediaQuery.of(context).size.height * 0.025,
                        ),
                      ),
                    ),
                    Text(
                      'จุดอ้างอิงที่ 2',
                      textAlign: TextAlign.start,
                      style: GoogleFonts.prompt(
                        textStyle: TextStyle(
                          color: textColor,
                          letterSpacing: .5,
                          fontSize: MediaQuery.of(context).size.height * 0.020,
                        ),
                      ),
                    ),
                    Text(
                      '${caseBodyReferencePoints[index].referenceDistance2} ${caseBodyReferencePoints[index].referenceUnitId2 == '1' ? 'เมตร' : 'เซนติเมตร'}',
                      textAlign: TextAlign.start,
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
              ],
            ),
          ),
          onPressed: () async {
            var result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddBodyReferencePosition(
                        caseBodyId: widget.caseBodyId,
                        caseBodyReferencePoints: caseBodyReferencePoints[index],
                        caseID: widget.caseID ?? -1,
                        caseNo: widget.caseNo,
                        isEdit: true)));
            if (result != null) {
              if (kDebugMode) {
                print('index: $index');
                print(caseBodyRefPoint.toString());
              }
              caseBodyRefPoint = result;
            }
          }),
    );
  }

  String? bodyPositionLabel(String? id) {
    try {
      for (int i = 0; i < listBodyPositions.length; i++) {
        if ('$id' == '${listBodyPositions[i].id}') {
          return listBodyPositions[i].bodyPosition;
        }
      }
      return '';
    } catch (ex) {
      return '';
    }
  }

  void _displaySnackbar(int index) async {
    await CaseBodyReferencePointDao()
        .deleteCaseBodyReferencePointBy(caseBodyReferencePoints[index].id ?? '')
        .then((value) {
      asyncCall2();
      if (kDebugMode) {
        print('removing');
      }
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: const Duration(milliseconds: 300),
          content: Text(
            'ลบสำเร็จ',
            textAlign: TextAlign.center,
            style: GoogleFonts.prompt(
              textStyle: TextStyle(
                color: Colors.white,
                letterSpacing: .5,
                fontSize: MediaQuery.of(context).size.height * 0.02,
              ),
            ),
          )));
    });
  }

  Widget _tabThree() {
    return Container(
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
                child: ListView(shrinkWrap: true, children: [
                  headerViewTabthree(),
                  spacer(context),
                  radioView('เสื้อ', _radioClothingValue),
                  // header('ป้ายหมายเลข'),
                  spacer(context),
                  detailView('${_cleanText(caseBody.clothingDetail)}'),
                  spacer(context),
                  radioView('กางเกง', _radioPantsValue),
                  spacer(context),
                  detailView('${_cleanText(caseBody.pantsDetail)}'),
                  spacer(context),
                  radioView('รองเท้า / ถุงเท้า', _radioShoesValue),
                  spacer(context),
                  detailView('${_cleanText(caseBody.shoesDetail)}'),
                  spacer(context),
                  radioView('เข็มขัด', _radioBeltValue),
                  spacer(context),
                  detailView('${_cleanText(caseBody.beltDetail)}'),
                  spacer(context),
                  radioView('รอยสักหรือรอยแผลเป็น', _radioTattooValue),
                  spacer(context),
                  detailView('${_cleanText(caseBody.tattooDetail)}'),
                  spacer(context),
                  subtitle('อื่นๆ'),
                  spacer(context),
                  detailView('${_cleanText(caseBody.dressOther)}'),
                ]))));
  }

  Widget headerViewTabthree() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          'การเเต่งกายเเละทรัพย์สิน',
          textAlign: TextAlign.center,
          style: GoogleFonts.prompt(
            textStyle: TextStyle(
              color: Colors.white,
              letterSpacing: .5,
              fontSize: MediaQuery.of(context).size.height * 0.025,
            ),
          ),
        ),
        TextButton(
            //color: Colors.transparent,
            onPressed: () async {
              //Navigator.pushNamed(context, '/dress');

              var result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Dress(
                          caseID: widget.caseID ?? -1,
                          caseNo: widget.caseNo,
                          caseBody: caseBody,
                          isEdit: widget.isEdit)));
              if (result != null) {
                if (kDebugMode) {
                  print('obobjectobjectobjectject');
                }
                setState(() {
                  caseBody = result;
                  if (kDebugMode) {
                    print(caseBody.toString());
                  }
                });
              }
            },
            child: Row(
              children: [
                Icon(Icons.edit,
                    color: Colors.white,
                    size: MediaQuery.of(context).size.height * 0.025),
                Text(
                  'แก้ไข',
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
            ))
      ],
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
        child: Text(
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
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   mainAxisSize: MainAxisSize.max,
        //   children: [
        //     Column(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //         Text(
        //           '$text',
        //           textAlign: TextAlign.left,
        //           style: GoogleFonts.prompt(
        //             textStyle: TextStyle(
        //               color: textColor,
        //               letterSpacing: .5,
        //               fontSize: MediaQuery.of(context).size.height * 0.025,
        //             ),
        //           ),
        //         ),
        //       ],
        //     ),
        //   ],
        // ),
      ),
    );
  }

  void _handleRadioValueChange(int value) {
    setState(() {
      if (kDebugMode) {
        print(value);
      }
    });
  }

  Widget radioView(String? title, int radioValue) {
    if (title == 'เสื้อ') {
      if (caseBody.isClothing == '1') {
        radioValue = 1;
      } else if (caseBody.isClothing == '2') {
        radioValue = 2;
      }
    } else if (title == 'กางเกง') {
      if (caseBody.isPants == '1') {
        radioValue = 1;
      } else if (caseBody.isPants == '2') {
        radioValue = 2;
      }
    } else if (title == 'รองเท้า / ถุงเท้า') {
      if (caseBody.isShoes == '1') {
        radioValue = 1;
      } else if (caseBody.isShoes == '2') {
        radioValue = 2;
      }
    } else if (title == 'เข็มขัด') {
      if (caseBody.isBelt == '1') {
        radioValue = 1;
      } else if (caseBody.isBelt == '2') {
        radioValue = 2;
      }
    } else if (title == 'รอยสักหรือรอยแผลเป็น') {
      if (caseBody.isTattoo == '1') {
        radioValue = 1;
      } else if (caseBody.isTattoo == '2') {
        radioValue = 2;
      }
    }

    return Padding(
      padding: const EdgeInsets.only(left: 0, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            title ?? '',
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
                  Radio(
                    activeColor: pinkButton,
                    value: 1,
                    groupValue: radioValue,
                    onChanged: (val) {
                      _handleRadioValueChange(val ?? -1);
                    },
                  ),
                  Text(
                    'พบ',
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
                  Radio(
                    activeColor: pinkButton,
                    value: 2,
                    groupValue: radioValue,
                    onChanged: (val) {
                      _handleRadioValueChange(val ?? -1);
                    },
                  ),
                  Text(
                    'ไม่พบ',
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

  Widget _tabFour() {
    return Container(
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
                child: Column(children: [
                  spacer(context),
                  radioTabFourView('สภาพรอยแผลเบื้องต้น'),
                  spacer(context),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      header('รายการรอยแผล'),
                      _radioTabFourValue == 1
                          ? TextButton(
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.add,
                                    size: MediaQuery.of(context).size.height *
                                        0.03,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    'เพิ่ม',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.prompt(
                                      textStyle: TextStyle(
                                        color: Colors.white,
                                        letterSpacing: .5,
                                        fontSize:
                                            MediaQuery.of(context).size.height *
                                                0.025,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              onPressed: () async {
                                if (kDebugMode) {
                                  print('onPressed');
                                }
                                var result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddLesion(
                                              caseID: widget.caseID ?? -1,
                                              caseNo: widget.caseNo,
                                              listCaseBodyWound: const [],
                                              isEdit: false,
                                              indexEdit: -1,
                                            )));
                                if (result != null) {
                                  setState(() {
                                    CaseBodyWound data = result;
                                    caseBodyWounds.add(data);
                                    if (kDebugMode) {
                                      print(
                                          'haha ${caseBodyWounds.toString()}');
                                    }
                                  });
                                }
                              },
                            )
                          : Container(),
                    ],
                  ),
                  spacer(context),
                  _listlesion()
                ]))));
  }

  void _handleRadioTabFourValueChange(int value) {
    if (kDebugMode) {
      print(value);
    }
    setState(() {
      _radioTabFourValue = value;
    });
  }

  Widget radioTabFourView(String? title) {
    return Padding(
      padding: const EdgeInsets.only(left: 0, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            title ?? '',
            textAlign: TextAlign.center,
            style: GoogleFonts.prompt(
              textStyle: TextStyle(
                color: Colors.white,
                letterSpacing: .5,
                fontSize: MediaQuery.of(context).size.height * 0.03,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Radio(
                    activeColor: pinkButton,
                    value: 2,
                    groupValue: _radioTabFourValue,
                    onChanged: (val) {
                      _handleRadioTabFourValueChange(val ?? -1);
                    },
                  ),
                  Text(
                    'ไม่พบรอยบาดเเผล',
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
                  Radio(
                    activeColor: pinkButton,
                    value: 1,
                    groupValue: _radioTabFourValue,
                    onChanged: (val) {
                      _handleRadioTabFourValueChange(val ?? -1);
                    },
                  ),
                  Text(
                    'พบรอยบาดแผล',
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

  Widget _listlesion() {
    return Expanded(
      child: ListView.builder(
          itemCount: caseBodyWounds.length,
          itemBuilder: (BuildContext context, int index) {
            return _listLesionItem(index);
          }),
    );
  }

  Widget _listLesionItem(int index) {
    return Slidable(
      endActionPane: ActionPane(
        extentRatio: 0.3,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            flex: 1,
            onPressed: (BuildContext context) {
              confirmRemoveBodyRef(context, index);
            },
            backgroundColor: Colors.red,
            icon: Icons.delete,
            label: 'ลบ',
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () async {
          if (kDebugMode) {
            print('caseBodyWounds befor eidt ${caseBodyWounds.toString()}');
          }
          var result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddLesion(
                      caseID: widget.caseID ?? -1,
                      caseNo: widget.caseNo,
                      listCaseBodyWound: caseBodyWounds,
                      indexEdit: index,
                      isEdit: true)));
          if (result != null) {
            setState(() {
              caseBodyWounds = result;
            });
          }
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ลักษณะ',
                  textAlign: TextAlign.start,
                  style: GoogleFonts.prompt(
                    textStyle: TextStyle(
                      color: textColor,
                      letterSpacing: .5,
                      fontSize: MediaQuery.of(context).size.height * 0.020,
                    ),
                  ),
                ),
                Text(
                  '${caseBodyWounds[index].woundDetail}',
                  textAlign: TextAlign.start,
                  maxLines: null,
                  style: GoogleFonts.prompt(
                    textStyle: TextStyle(
                      color: textColor,
                      letterSpacing: .5,
                      fontSize: MediaQuery.of(context).size.height * 0.025,
                    ),
                  ),
                ),
                Text(
                  'ตำแหน่ง',
                  textAlign: TextAlign.start,
                  style: GoogleFonts.prompt(
                    textStyle: TextStyle(
                      color: textColor,
                      letterSpacing: .5,
                      fontSize: MediaQuery.of(context).size.height * 0.020,
                    ),
                  ),
                ),
                Text(
                  '${caseBodyWounds[index].woundPosition}',
                  textAlign: TextAlign.start,
                  style: GoogleFonts.prompt(
                    textStyle: TextStyle(
                      color: textColor,
                      letterSpacing: .5,
                      fontSize: MediaQuery.of(context).size.height * 0.025,
                    ),
                  ),
                ),
                Text(
                  'ความยาว',
                  textAlign: TextAlign.start,
                  style: GoogleFonts.prompt(
                    textStyle: TextStyle(
                      color: textColor,
                      letterSpacing: .5,
                      fontSize: MediaQuery.of(context).size.height * 0.020,
                    ),
                  ),
                ),
                Text(
                  '${caseBodyWounds[index].woundSize} ${caseBodyWounds[index].woundUnitId}',
                  textAlign: TextAlign.start,
                  style: GoogleFonts.prompt(
                    textStyle: TextStyle(
                      color: textColor,
                      letterSpacing: .5,
                      fontSize: MediaQuery.of(context).size.height * 0.025,
                    ),
                  ),
                ),
                Text(
                  'จำนวน',
                  textAlign: TextAlign.start,
                  style: GoogleFonts.prompt(
                    textStyle: TextStyle(
                      color: textColor,
                      letterSpacing: .5,
                      fontSize: MediaQuery.of(context).size.height * 0.020,
                    ),
                  ),
                ),
                Text(
                  '${caseBodyWounds[index].woundAmount}',
                  textAlign: TextAlign.start,
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
        ),
      ),
    );
  }

  Widget _tabFive() {
    return Container(
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
                child: ListView(shrinkWrap: true, children: [
                  headerViewTabFive(),
                  spacer(context),
                  drawDamage(),
                  spacer(context),
                  spacer(context),
                  subtitle('แพทย์ชันสูตร'),
                  spacer(context),
                  detailView('${_cleanText(caseBody.investigatorDoctor)}'),
                  spacer(context),
                  spacer(context),
                  spacer(context),
                ]))));
  }

  Widget headerViewTabFive() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          'แผนผังแสดงตำแหน่งและบาดแผล',
          textAlign: TextAlign.center,
          style: GoogleFonts.prompt(
            textStyle: TextStyle(
              color: Colors.white,
              letterSpacing: .5,
              fontSize: MediaQuery.of(context).size.height * 0.022,
            ),
          ),
        ),
        TextButton(
            onPressed: () async {
              var result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DrawTemplate(
                          caseID: widget.caseID ?? -1,
                          caseNo: widget.caseNo,
                          caseBody: caseBody,
                          isEdit: isDrewTemplate)));
              if (result != null) {
                setState(() {
                  caseBody = result;
                  if (caseBody.bodyDiagram != null &&
                      caseBody.bodyDiagram != '') {
                    isDrewTemplate = true;
                  } else {
                    isDrewTemplate = false;
                    imageBody = Image.asset('images/body.png');
                  }
                  if (kDebugMode) {
                    print('caseBody.bodyDiagram ${caseBody.bodyDiagram}');
                    print('isDrewTemplate $isDrewTemplate');
                  }
                });
              }
            },
            child: Row(
              children: [
                Icon(Icons.edit,
                    color: Colors.white,
                    size: MediaQuery.of(context).size.height * 0.025),
                Text(
                  'แก้ไข',
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
            ))
      ],
    );
  }

  Widget drawDamage() {
    if (caseBody.bodyDiagram != null && caseBody.bodyDiagram != '') {
      imageBody = Image.memory(base64Decode(caseBody.bodyDiagram ?? ''));
    }
    return Center(
      child: Stack(
        children: [
          imageBody,
        ],
      ),
    );
  }

  String? _cleanText(String? text) {
    try {
      if (text == null || text == '' || text == 'null'|| text == '-1') {
        return '';
      }
      return text;
    } catch (ex) {
      return '';
    }
  }

  String? titleLabel(String? id) {
    for (int i = 0; i < titles.length; i++) {
      if ('$id' == '${titles[i].id}') {
        return titles[i].name;
      }
    }
    return '';
  }

  void confirmRemoveBodyRef(BuildContext context, int index) {
    BlurryDialog alert = BlurryDialog('แจ้งเตือน', 'ยืนยันการลบ', () async {
      _displaySnackbar(index);
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void confirmRemoveBodyWound(BuildContext context, int index) {
    // set up the buttons

    BlurryDialog alert = BlurryDialog('แจ้งเตือน', 'ยืนยันการลบ', () async {
      CaseBodyWoundDao().deleteCaseBodyWound(caseBodyWounds[index].id ?? '');
      caseBodyWounds.removeAt(index);
      asyncCall1();
      if (kDebugMode) {
        print('removing');
      }
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class ImageDialog extends StatelessWidget {
  const ImageDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        // width: 200,
        // height: 200,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: ExactAssetImage('images/test.png'), fit: BoxFit.fill)),
      ),
    );
  }
}
