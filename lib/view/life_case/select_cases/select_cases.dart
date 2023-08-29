import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

import '../../../Utils/color.dart';
import '../../../models/CaseInspection.dart';
import '../../../models/CaseInspector.dart';
import '../../../models/CaseRelatedPerson.dart';
import '../../../models/Download.dart';
import '../../../models/FidsCrimeScene.dart';
import '../../../models/case_vehicle/CaseVehicleDao.dart';
import '../../../widget/app_bar_widget.dart';

class SelectCasePage extends StatefulWidget {
  const SelectCasePage({super.key});

  @override
  SelectCasePageState createState() => SelectCasePageState();
}

class SelectCasePageState extends State<SelectCasePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isPhone = Device.get().isPhone;
  bool isLoading = true;
  String? uGroup;
  FidsCrimeScene fidsCrimeScene = FidsCrimeScene();
  List<Download> caseList = [];

  @override
  void initState() {
    super.initState();
    getUGroup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      key: _scaffoldKey,
      appBar: AppBarWidget(
        title: 'เลือกคดีที่ต้องการดาวน์โหลด',
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
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              margin: isPhone
                  ? const EdgeInsets.all(16)
                  : const EdgeInsets.only(
                      left: 32, right: 32, top: 32, bottom: 32),
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : caseList.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: caseList.length,
                          itemBuilder: (context, index) {
                            var fireType = caseList[index].caseCategoryId == '2'
                                ? (caseList[index].fireTypeId != '' &&
                                        caseList[index].fireTypeId != null)
                                    ? caseList[index].fireTypeId == '1'
                                        ? '(อาคาร)'
                                        : '(ยานพาหนะ)'
                                    : ''
                                : '';
                            return Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: TextButton(
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20,
                                          right: 20,
                                          top: 12,
                                          bottom: 12),
                                      child: Column(
                                        children: [
                                          _rowHeadInCard(
                                              'FIDS-ID: ${caseList[index].fidsNo}'),
                                          _rowInCard(
                                              'แจ้งเมื่อ: ${caseList[index].caseIssueDate}'),
                                          _rowInCard(
                                              'ประเภทคดี: ${caseList[index].caseCategoryName}  $fireType'),
                                          caseList[index].reportNo != null ||
                                                  caseList[index].reportNo != ''
                                              ? _rowInCard(
                                                  'เลขรายงาน : ${caseList[index].reportNo}')
                                              : _rowInCard('เลขรายงาน : -'),
                                          _rowInCard(
                                              'ผู้แจ้ง: ${caseList[index].investigatorTitleLabel} ${caseList[index].investigatorName}')
                                        ],
                                      )),
                                ),
                                onPressed: () {
                                  showAlertDialog(context, index);
                                },
                              ),
                            );
                          })
                      : Center(
                          child: Text(
                            'ไม่มีคดี',
                            style: GoogleFonts.prompt(
                              textStyle: TextStyle(
                                color: Colors.white,
                                letterSpacing: 0.5,
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.025,
                              ),
                            ),
                          ),
                        )),
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context, int index) {
    // set up the buttons
    // ignore: deprecated_member_use
    Widget cancelButton = TextButton(
      child: Text("ยกเลิก",
          style: GoogleFonts.prompt(
              textStyle: TextStyle(
                  color: Colors.red,
                  letterSpacing: 0.5,
                  fontSize: MediaQuery.of(context).size.height * 0.015))),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    // ignore: deprecated_member_use
    Widget continueButton = TextButton(
      child: Text("ยืนยัน",
          style: GoogleFonts.prompt(
              textStyle: TextStyle(
                  color: darkBlue,
                  letterSpacing: 0.5,
                  fontSize: MediaQuery.of(context).size.height * 0.015))),
      onPressed: () {
        Navigator.of(context).pop(true);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("แจ้งเตือน",
          style: GoogleFonts.prompt(
              textStyle: TextStyle(
            fontWeight: FontWeight.w600,
            color: darkBlue,
            letterSpacing: 0.5,
            fontSize: MediaQuery.of(context).size.height * 0.025,
          ))),
      content: Text("ยืนยันการดาวน์โหลด",
          style: GoogleFonts.prompt(
              textStyle: TextStyle(
            color: darkBlue,
            letterSpacing: 0.5,
            fontSize: MediaQuery.of(context).size.height * 0.02,
          ))),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    ).then((value) {
      if (value) {
        if (kDebugMode) {
          print(value);
        }
        setState(() {
          isLoading = true;
        });
        Future.delayed(const Duration(seconds: 2), () {
          // deleayed code here
          if (kDebugMode) {
            print('delayed execution');
          }
          downloadCaseAtIndex(index);
        });
      }
    });
  }

  Widget _rowHeadInCard(String? label) {
    return Align(
      alignment: Alignment.topLeft,
      child: Wrap(
        children: [
          Text(
            label ?? '',
            style: GoogleFonts.prompt(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: textColor,
                letterSpacing: 0.5,
                fontSize: MediaQuery.of(context).size.height * 0.022,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _rowInCard(String? label) {
    return Align(
      alignment: Alignment.topLeft,
      child: Wrap(
        children: [
          Text(
            label ?? '',
            style: GoogleFonts.prompt(
              textStyle: TextStyle(
                color: Colors.black,
                letterSpacing: 0.5,
                fontSize: MediaQuery.of(context).size.height * 0.018,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future updateCase(String? fidsNo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    var url =
        'https://crimescene.fids.police.go.th/mobile/api/Crimescene/Update/$fidsNo:2:$userId';
    return http.post(Uri.parse(url));
  }

  Future getCases() {
    if (kDebugMode) {
      print('getCases : $uGroup');
    }
    var url =
        'https://crimescene.fids.police.go.th/mobile/api/Crimescene/Download/$uGroup';
    return http.get(Uri.parse(url));
  }

  _updateCase(index, String? fidsNo) {
    updateCase(fidsNo).then((response) {
      setState(() {
        isLoading = false;
      });
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('response.statusCode ${response.statusCode}');
        }
      } else {
        _displaySnackBar(context, 'อัพเดทไม่สำเร็จ');
        throw Exception('อัพเดทไม่สำเร็จ');
      }
    }, onError: (e) {
      setState(() {
        isLoading = false;
      });
      throw e;
    });
  }

  _getCases() {
    getCases().then((response) {
      setState(() {
        isLoading = false;
      });
      if (kDebugMode) {
        print(
            'response.statusCode  ${response.statusCode} \n ${response.body}');
      }
      if (response.statusCode == 200) {
        try {
          if (kDebugMode) {
            print('${response.body}');
          }
          if ('[]' == '${response.body}') {
            _displaySnackBar(context, 'ไม่มีข้อมูล');
          } else {
            if (kDebugMode) {
              print('response.body ${response.body}');
            }
            setState(() {
              Iterable l = json.decode(response.body);
              caseList = List<Download>.from(
                  l.map((model) => Download.fromJson(model)));
            });
          }
        } catch (ex) {
          if (kDebugMode) {
            print(ex);
          }
          _displaySnackBar(context, 'ดาวน์โหลดไม่สำเร็จ');
        }
      } else {
        _displaySnackBar(context, 'ดาวน์โหลดไม่สำเร็จ');
        throw Exception('ดาวน์โหลดไม่สำเร็จ');
      }
    }, onError: (e) {
      setState(() {
        isLoading = false;
      });
      throw e;
    });
  }

  void downloadCaseAtIndex(index) async {
    if (kDebugMode) {
      print('index  $index');
      print('isoSubCaseCategoryID  ${caseList[index].isoSubcaseCategoryId}');
      print('caseCategoryID  ${caseList[index].caseCategoryId}');
      print('issueMedia  ${caseList[index].issueMedia}');
      print('policeStationID  ${caseList[index].policeStationID}');
      print('investigatorTitleID  ${caseList[index].investigatorTitleID}');
      print('isOutside  ${caseList[index].isOutside}');
    }

    await FidsCrimeSceneDao().createFidsCrimeScene(
        caseList[index].fidsNo,
        caseList[index].caseCategoryId == ''
            ? -2
            : int.parse(caseList[index].caseCategoryId ?? ''),
        caseList[index].isoSubcaseCategoryId == ''
            ? -2
            : int.parse(caseList[index].isoSubcaseCategoryId ?? ''),
        caseList[index].isoCaseNo,
        caseList[index].caseIssueDate,
        caseList[index].caseIssueTime,
        caseList[index].issueMedia == ''
            ? -2
            : int.parse(caseList[index].issueMedia ?? ''),
        caseList[index].issueMediaDetail,
        caseList[index].deliverBookNo,
        caseList[index].deliverBookDate,
        caseList[index].policeStationID == ''
            ? -2
            : int.parse(caseList[index].policeStationID ?? ''),
        caseList[index].isoOtherDepartment,
        caseList[index].policeDaily,
        caseList[index].policeDailyDate,
        caseList[index].investigatorTitleID == '' ||
                caseList[index].investigatorTitleID == 'null'
            ? -2
            : int.parse(caseList[index].investigatorTitleID ?? ''),
        caseList[index].investigatorName,
        caseList[index].isoInvestigatorTel,
        caseList[index].sceneProvinceID == ''
            ? -2
            : int.parse(caseList[index].sceneProvinceID ?? ''),
        caseList[index].subCaseCategoryOther,
        caseList[index].reportNo,
        caseList[index].fireTypeId);
    if (kDebugMode) {
      print('terk1 ${caseList[index].caseRelatedPerson.toString()}');
      print('terk2 ${caseList[index].fidsNo}');
    }

    _updateCase(index, caseList[index].fidsNo);
    updateLocalDB(caseList[index].fidsNo, index);
  }

  void updateLocalDB(String? fidsNo, int index) async {
    var result = await FidsCrimeSceneDao().getFidsCrimeSceneByFidsNo(fidsNo);
    setState(() {
      fidsCrimeScene = result ?? FidsCrimeScene();
      if (kDebugMode) {
        print('fidsCrimeScene.fidsid: ${fidsCrimeScene.fidsid}');
      }
    });

    await FidsCrimeSceneDao().updateTrafficObj(fidsCrimeScene.fidsid.toString(),
        fidsCrimeScene.trafficObjective, fidsCrimeScene.trafficObjectiveOther);
    //รถของกลาง
    if (caseList[index].caseVehicle != null) {
      for (int i = 0; i < caseList[index].caseRelatedPerson!.length; i++) {
        if (kDebugMode) {
          print('caseRelatedPersoncaseRelatedPersoncaseRelatedPerson');
        }
        await CaseVehicleDao().createCaseVehicle(
            fidsCrimeScene.fidsid.toString(),
            (caseList[index].caseVehicle?[i].vehicleTypeId == ''
                    ? -2
                    : caseList[index].caseVehicle?[i].vehicleTypeId == '')
                as String?,
            caseList[index].caseVehicle?[i].vehicleTypeOther,
            caseList[index].caseVehicle?[i].vehicleBrandId,
            caseList[index].caseVehicle?[i].vehicleBrandOther,
            caseList[index].caseVehicle?[i].vehicleModel,
            caseList[index].caseVehicle?[i].colorId1,
            caseList[index].caseVehicle?[i].colorId2,
            caseList[index].caseVehicle?[i].colorOther,
            caseList[index].caseVehicle?[i].detail,
            caseList[index].caseVehicle?[i].isVehicleRegistrationPlate,
            caseList[index].caseVehicle?[i].vehicleRegistrationPlateNo1,
            caseList[index].caseVehicle?[i].provinceId,
            caseList[index].caseVehicle?[i].vehicleRegistrationPlateNo2,
            caseList[index].caseVehicle?[i].vehicleOther,
            caseList[index].caseVehicle?[i].chassisNumber,
            caseList[index].caseVehicle?[i].engineNumber,
            caseList[index].caseVehicle?[i].provinceOtherId);
      }
    }

    // ข้อ 2 สถานที่เกิเหตุ
    await FidsCrimeSceneDao().updateLocationCase(
        caseList[index].sceneDescription,
        caseList[index].sceneTambolID == ''
            ? -2
            : int.parse(caseList[index].sceneTambolID ?? ''),
        caseList[index].sceneAmphurID == ''
            ? -2
            : int.parse(caseList[index].sceneAmphurID ?? ''),
        caseList[index].sceneProvinceID == ''
            ? -2
            : int.parse(caseList[index].sceneProvinceID ?? ''),
        caseList[index].isoLatitude,
        caseList[index].isoLongtitude,
        '${fidsCrimeScene.fidsid}');

    // ข้อ 2.1 ผู้เกี่ยวข้อง ขาด CaseRelatedPerson

    if (kDebugMode) {
      print(
          'ผู้เกี่ยวข้องผู้เกี่ยวข้อง ${caseList[index].caseRelatedPerson.toString()}');
      print(
          'ผู้เกี่ยวข้องผู้เกี่ยวข้อง ${caseList[index].caseRelatedPerson!.length}');
    }
    if (caseList[index].caseRelatedPerson != null) {
      for (int i = 0; i < caseList[index].caseRelatedPerson!.length; i++) {
        if (kDebugMode) {
          print('caseRelatedPersoncaseRelatedPersoncaseRelatedPerson');
        }
        await CaseRelatedPersonDao().createCaseRelatedPerson(
            fidsCrimeScene.fidsid ?? -1,
            caseList[index].caseRelatedPerson?[i].relatedPersonTypeId == ''
                ? -2
                : int.parse(
                    caseList[index].caseRelatedPerson?[i].relatedPersonTypeId ??
                        ''),
            caseList[index].caseRelatedPerson?[i].relatedPersonOther,
            caseList[index].caseRelatedPerson?[i].isoTitleName,
            caseList[index].caseRelatedPerson?[i].isoFirstName,
            caseList[index].caseRelatedPerson?[i].isoLastName,
            caseList[index].caseRelatedPerson?[i].isoIdCard,
            caseList[index].caseRelatedPerson?[i].typeCardID,
            caseList[index].caseRelatedPerson?[i].age,
            caseList[index].caseRelatedPerson?[i].isoConcernpeoplecareerId == ''
                ? -2
                : int.parse(caseList[index]
                        .caseRelatedPerson?[i]
                        .isoConcernpeoplecareerId ??
                    ''),
            caseList[index].caseRelatedPerson?[i].isoConcernPeopleCareeerOther,
            caseList[index].caseRelatedPerson?[i].isoConcernPeopleDetails,
            caseList[index].caseRelatedPerson?[i].relatedPersonImage,
            '',
            '',
            '',
            '',
            1);

        if (kDebugMode) {
          print('terk2.1');
          var result = await CaseRelatedPersonDao()
              .getCaseRelatedPerson(fidsCrimeScene.fidsid ?? -1);
          print('count: ${result.length}');
          print(result.toString());
          print('terk2.2');
        }
      }
    }

    // ข้อ 3 วันเวลาที่ทราบเหตุ
    await FidsCrimeSceneDao().updateCaseDateTime(
        caseList[index].sceneProvinceID == ''
            ? -2
            : int.parse(caseList[index].sceneProvinceID ?? ''),
        caseList[index].caseVictimDate,
        caseList[index].caseVictimTime,
        caseList[index].caseOfficerDate,
        caseList[index].caseOfficerTime,
        '${fidsCrimeScene.fidsid}');
    if (kDebugMode) {
      print('terk3');
    }

    // ข้อ 4 วันเวลาที่ตรวจเหตุ
    if (caseList[index].caseInspection != null) {
      for (int i = 0; i < caseList[index].caseInspection!.length; i++) {
        if (kDebugMode) {
          print('caseInspection caseInspection caseInspection caseInspection');
        }
        await CaseInspectionDao().createCaseInspection(
            caseList[index].caseInspection![i].inspectDate ?? '',
            caseList[index].caseInspection![i].inspectTime ?? '',
            1,
            fidsCrimeScene.fidsid ?? -1);

        // var result =
        //     await CaseInspectionDao().getCaseInspection(fidsCrimeScene.fidsid);
        // print('count: ${result.length}');
        // print(result.toString());
        if (kDebugMode) {
          print('terk 4');
        }
      }
    }

    // ข้อ 5 ผู้ตรวจสอบสถานที่เกิดเหตุ

    // await CaseInspectorDao().createCaseInspector(fidsCrimeScene.fidsid, caseList[index].caseInspector[i].personalId, positionId, inspectorPosition, activeFlag)
    if (kDebugMode) {
      if (caseList[index].caseInspector != null) {
        print('count from API : ${caseList[index].caseInspector!.length}');
        print('count from API : ${caseList[index].caseInspector.toString()}');
      }
    }

    if (caseList[index].caseInspector != null) {
      for (int i = 0; i < caseList[index].caseInspector!.length; i++) {
        if (kDebugMode) {
          print(caseList[index].caseInspector![i].titleId);
        }
        await CaseInspectorDao().createCaseInspector(
            fidsCrimeScene.fidsid ?? -1,
            caseList[index].caseInspector?[i].titleId,
            caseList[index].caseInspector?[i].firstname,
            caseList[index].caseInspector?[i].lastname,
            caseList[index].caseInspector?[i].positionID,
            caseList[index].caseInspector?[i].positionOther,
            caseList[index].caseInspector?[i].departmentID,
            caseList[index].caseInspector?[i].subDepartmentID);
      }

      // print('count from DB: ${result.toString()}');
      if (kDebugMode) {
        print('terk 5');
        var result = await CaseInspectorDao()
            .getCaseInspector(fidsCrimeScene.fidsid ?? -1);
        print(result.toString());
      }
    }

    // ข้อ 6.1 สภาพของสถานที่เกิดเหตุ

    // print('${caseList[index].isSceneProtection}');
    // await FidsCrimeSceneDao().updateSceneLocation(
    //     caseList[index].isSceneProtection == '' ||
    //             caseList[index].isSceneProtection == 'True' ||
    //             caseList[index].isSceneProtection == 'False'
    //         ? -2
    //         : int.parse(caseList[index].isSceneProtection),
    //     caseList[index].sceneProtectionDetails,
    //     caseList[index].lightCondition,
    //     caseList[index].lightConditionDetails,
    //     caseList[index].temperatureCondition,
    //     caseList[index].temperatureConditionDetails,
    //     caseList[index].isSmell == '' ||
    //             caseList[index].isSmell == 'True' ||
    //             caseList[index].isSmell == 'False'
    //         ? -2
    //         : int.parse(caseList[index].isSmell),
    //     caseList[index].smellDetails,
    //     '${fidsCrimeScene.fidsid}');
    // print('terk 6.1');

    // // ข้อ 6.2

    // // นอกอาคาร
    // await FidsCrimeSceneDao().updateSceneExternal(
    //     caseList[index].sceneType,
    //     caseList[index].sceneDetails,
    //     caseList[index].sceneFront,
    //     caseList[index].sceneLeft,
    //     caseList[index].sceneRight,
    //     caseList[index].sceneBack,
    //     caseList[index].sceneLocation,
    //     '${fidsCrimeScene.fidsid}');

    // print('terk นอกอาคาร');

    // // ในอาคาร
    // await FidsCrimeSceneDao().updateSceneInternal(
    //     caseList[index].buildingTypeID == ''
    //         ? -2
    //         : int.parse(caseList[index].buildingTypeID),
    //     caseList[index].isoBuildingDetail,
    //     caseList[index].floor,
    //     caseList[index].isFence == '' ? -2 : int.parse(caseList[index].isFence),
    //     caseList[index].sceneFront,
    //     caseList[index].sceneLeft,
    //     caseList[index].sceneRight,
    //     caseList[index].sceneBack,
    //     '${fidsCrimeScene.fidsNo}');
    // print('terk ในอาคาร');

    // if (caseList[index].caseSceneLocation != null) {
    //   for (int i = 0; i < caseList[index].caseSceneLocation.length; i++) {
    //     print('caseSceneLocationcaseSceneLocationcaseSceneLocation');
    //     await CaseSceneLocationDao().createCaseSceneLocation(
    //         caseList[index].caseSceneLocation[i].sceneLocation,
    //         caseList[index].caseSceneLocation[i].sceneLocationSize,
    //         caseList[index].caseSceneLocation[i].unitId == ''
    //             ? -2
    //             : int.parse(caseList[index].caseSceneLocation[i].unitId),
    //         caseList[index].caseSceneLocation[i].buildingStructure,
    //         caseList[index].caseSceneLocation[i].buildingWallFront,
    //         caseList[index].caseSceneLocation[i].buildingWallLeft,
    //         caseList[index].caseSceneLocation[i].buildingWallRight,
    //         caseList[index].caseSceneLocation[i].buildingWallBack,
    //         caseList[index].caseSceneLocation[i].roomFloor,
    //         caseList[index].caseSceneLocation[i].roof,
    //         caseList[index].caseSceneLocation[i].placement,
    //         fidsCrimeScene.fidsid,
    //         '',
    //         '',
    //         '',
    //         '',
    //         1);

    //     print('ในอาคาร 2.1');
    //   }
    // }

    // // ข้อ 7.1 ผลการตรวจสอบที่เกิดเหตุ
    // await FidsCrimeSceneDao().updateResultCase(
    //     caseList[index].caseBehavior,
    //     caseList[index].caseEntranceDetails,
    //     caseList[index].isFightingClue == '' ||
    //             caseList[index].isFightingClue == 'True' ||
    //             caseList[index].isFightingClue == 'False'
    //         ? -2
    //         : int.parse(caseList[index].isRansackClue),
    //     caseList[index].fightingClueDetails,
    //     caseList[index].isRansackClue == '' ||
    //             caseList[index].isRansackClue == 'True' ||
    //             caseList[index].isRansackClue == 'False'
    //         ? -2
    //         : int.parse(caseList[index].isRansackClue),
    //     caseList[index].ransackClueDetails,
    //     '${fidsCrimeScene.fidsNo}');

    // print('terk 7.1');

    // // ข้อ 7.2 ผู้เสียชีวิต

    // if (caseList[index].caseBody != null) {
    //   for (int i = 0; i < caseList[index].caseBody.length; i++) {
    //     print('caseBodycaseBodycaseBodycaseBodycaseBodycaseBody');
    //     var caseBodyId = await CaseBodyDao().createCaseBody(
    //         caseList[index].caseBody[i].labelNo,
    //         caseList[index].caseBody[i].bodyTitleId == ''
    //             ? -2
    //             : int.parse(caseList[index].caseBody[i].bodyTitleId),
    //         caseList[index].caseBody[i].bodyFirstName,
    //         caseList[index].caseBody[i].bodyLastName,
    //         caseList[index].caseBody[i].bodyFoundLocation,
    //         caseList[index].caseBody[i].bodyFoundCondition,
    //         fidsCrimeScene.fidsid,
    //         caseList[index].caseBody[i].isClothing == '' ||
    //                 caseList[index].caseBody[i].isClothing == 'True' ||
    //                 caseList[index].caseBody[i].isClothing == 'False'
    //             ? -2
    //             : int.parse(caseList[index].caseBody[i].isClothing),
    //         caseList[index].caseBody[i].clothingDetail,
    //         caseList[index].caseBody[i].isPants == '' ||
    //                 caseList[index].caseBody[i].isPants == 'True' ||
    //                 caseList[index].caseBody[i].isPants == 'False'
    //             ? -2
    //             : int.parse(caseList[index].caseBody[i].isPants),
    //         caseList[index].caseBody[i].pantsDetail,
    //         caseList[index].caseBody[i].isShoes == '' ||
    //                 caseList[index].caseBody[i].isShoes == 'True' ||
    //                 caseList[index].caseBody[i].isShoes == 'False'
    //             ? -2
    //             : int.parse(caseList[index].caseBody[i].isShoes),
    //         caseList[index].caseBody[i].shoesDetail,
    //         caseList[index].caseBody[i].isBelt == '' ||
    //                 caseList[index].caseBody[i].isBelt == 'True' ||
    //                 caseList[index].caseBody[i].isBelt == 'False'
    //             ? -2
    //             : int.parse(caseList[index].caseBody[i].isBelt),
    //         caseList[index].caseBody[i].beltDetail,
    //         caseList[index].caseBody[i].isTattoo == '' ||
    //                 caseList[index].caseBody[i].isTattoo == 'True' ||
    //                 caseList[index].caseBody[i].isTattoo == 'False'
    //             ? -2
    //             : int.parse(caseList[index].caseBody[i].isTattoo),
    //         caseList[index].caseBody[i].tattooDetail,
    //         caseList[index].caseBody[i].dressOther,
    //         caseList[index].caseBody[i].investigatorDoctor,
    //         caseList[index].caseBody[i].bodyDiagram,
    //         caseList[index].caseBody[i].isWound == '' ||
    //                 caseList[index].caseBody[i].isWound == 'True' ||
    //                 caseList[index].caseBody[i].isWound == 'False'
    //             ? -2
    //             : int.parse(caseList[index].caseBody[i].isWound),
    //         '',
    //         '',
    //         '',
    //         '',
    //         1);

    //     for (int i = 0;
    //         i < caseList[index].caseBody[i].bodyReferencePoint.length;
    //         i++) {
    //       CaseBodyReferencePointDao().createCaseBodyReferencePoint(
    //           fidsCrimeScene.fidsid,
    //           caseBodyId,
    //           caseList[index].caseBody[i].bodyReferencePoint[i].referenceDetail,
    //           caseList[index].caseBody[i].bodyReferencePoint[i].referenceID1 == ''
    //               ? -2
    //               : int.parse(caseList[index]
    //                   .caseBody[i]
    //                   .bodyReferencePoint[i]
    //                   .referenceID1),
    //           caseList[index].caseBody[i].bodyReferencePoint[i].referenceDistance1 == ''
    //               ? -2
    //               : int.parse(caseList[index]
    //                   .caseBody[i]
    //                   .bodyReferencePoint[i]
    //                   .referenceDistance1),
    //           caseList[index].caseBody[i].bodyReferencePoint[i].referenceUnitId1 == ''
    //               ? -2
    //               : int.parse(caseList[index]
    //                   .caseBody[i]
    //                   .bodyReferencePoint[i]
    //                   .referenceUnitId1),
    //           caseList[index].caseBody[i].bodyReferencePoint[i].referenceID2 == ''
    //               ? -2
    //               : int.parse(caseList[index]
    //                   .caseBody[i]
    //                   .bodyReferencePoint[i]
    //                   .referenceID2),
    //           caseList[index].caseBody[i].bodyReferencePoint[i].referenceDistance2 == ''
    //               ? -2
    //               : int.parse(caseList[index]
    //                   .caseBody[i]
    //                   .bodyReferencePoint[i]
    //                   .referenceDistance2),
    //           caseList[index].caseBody[i].bodyReferencePoint[i].referenceUnitId2 == '' ? -2 : int.parse(caseList[index].caseBody[i].bodyReferencePoint[i].referenceUnitId2),
    //           caseList[index].caseBody[i].bodyReferencePoint[i].createDate,
    //           caseList[index].caseBody[i].bodyReferencePoint[i].createBy,
    //           caseList[index].caseBody[i].bodyReferencePoint[i].updateDate,
    //           caseList[index].caseBody[i].bodyReferencePoint[i].updateBy,
    //           caseList[index].caseBody[i].bodyReferencePoint[i].activeFlag == '' ? -2 : int.parse(caseList[index].caseBody[i].bodyReferencePoint[i].activeFlag));
    //     }

    //     for (int i = 0; i < caseList[index].caseBody[i].caseBodyWound.length; i++) {

    //                 CaseBodyWoundDao().createCaseBodyWound(
    //                     caseBodyId,
    //                     caseList[index].caseBody[i].caseBodyWound[i].isWound == '1' ? true :  caseList[index].caseBody[i].caseBodyWound[i].isWound == '2' ? false : null,
    //                     caseList[index].caseBody[i].caseBodyWound[i].woundDetail,
    //                     caseList[index].caseBody[i].caseBodyWound[i].woundPosition,
    //                     caseList[index].caseBody[i].caseBodyWound[i].woundSize == '' ? -2 : double.parse(caseList[index].caseBody[i].caseBodyWound[i].woundUnitId),
    //                     caseList[index].caseBody[i].caseBodyWound[i].woundUnitId == '' ? -2 : int.parse(caseList[index].caseBody[i].caseBodyWound[i].woundUnitId),
    //                     caseList[index].caseBody[i].caseBodyWound[i].woundAmount == '' ? -2 : double.parse(caseList[index].caseBody[i].caseBodyWound[i].woundUnitId),
    //                     '',
    //                     '',
    //                     '',
    //                     '',
    //                     1);
    //               }
    //   }
    // }

    // // ข้อ 7.3 วัตถุพยานที่ตรวจพบ

    // if (caseList[index].caseEvidentFound != null) {
    //   for (int i = 0; i < caseList[index].caseEvidentFound.length; i++) {
    //     print(
    //         'caseEvidentFoundcaseEvidentFoundcaseEvidentFoundcaseEvidentFound');
    //     await CaseEvidentFoundDao().createCaseEvidentFound(
    //         fidsCrimeScene.fidsid,
    //         caseList[index].caseEvidentFound[i].evidentTypeId == ''
    //             ? -2
    //             : int.parse(caseList[index].caseEvidentFound[i].evidentTypeId),
    //         caseList[index].caseEvidentFound[i].isoLabelNo,
    //         caseList[index].caseEvidentFound[i].evidentDetails,
    //         caseList[index].caseEvidentFound[i].isoEvidentPosition,
    //         caseList[index].caseEvidentFound[i].evidentAmount,
    //         caseList[index].caseEvidentFound[i].isoEvidentUnitId == ''
    //             ? -2
    //             : int.parse(
    //                 caseList[index].caseEvidentFound[i].isoEvidentUnitId),
    //         caseList[index].caseEvidentFound[i].isoReferenceId1 == ''
    //             ? -2
    //             : int.parse(
    //                 caseList[index].caseEvidentFound[i].isoReferenceId1),
    //         caseList[index].caseEvidentFound[i].isoReferenceDistance1 == ''
    //             ? -2
    //             : double.parse(
    //                 caseList[index].caseEvidentFound[i].isoReferenceId1),
    //         caseList[index].caseEvidentFound[i].isoReferenceUnitId1 == ''
    //             ? -2
    //             : int.parse(
    //                 caseList[index].caseEvidentFound[i].isoReferenceUnitId1),
    //         caseList[index].caseEvidentFound[i].isoReferenceId2 == ''
    //             ? -2
    //             : int.parse(
    //                 caseList[index].caseEvidentFound[i].isoReferenceId2),
    //         caseList[index].caseEvidentFound[i].isoReferenceDistance2 == ''
    //             ? -2
    //             : double.parse(
    //                 caseList[index].caseEvidentFound[i].isoReferenceDistance2),
    //         caseList[index].caseEvidentFound[i].isoReferenceUnitId2 == ''
    //             ? -2
    //             : int.parse(
    //                 caseList[index].caseEvidentFound[i].isoReferenceUnitId2),
    //         caseList[index].caseEvidentFound[i].isoIsTestStains == '' ||
    //                 caseList[index].caseEvidentFound[i].isoIsTestStains ==
    //                     'True' ||
    //                 caseList[index].caseEvidentFound[i].isoIsTestStains ==
    //                     'False'
    //             ? -2
    //             : int.parse(
    //                 caseList[index].caseEvidentFound[i].isoIsTestStains),
    //         caseList[index].caseEvidentFound[i].isoIsHermastix == '' || caseList[index].caseEvidentFound[i].isoIsHermastix == 'True' || caseList[index].caseEvidentFound[i].isoIsHermastix == 'False'
    //             ? -2
    //             : int.parse(caseList[index].caseEvidentFound[i].isoIsHermastix),
    //         caseList[index].caseEvidentFound[i].isoIsHermastixChange == '' ||
    //                 caseList[index].caseEvidentFound[i].isoIsHermastixChange ==
    //                     'True' ||
    //                 caseList[index].caseEvidentFound[i].isoIsHermastixChange ==
    //                     'False'
    //             ? -2
    //             : int.parse(
    //                 caseList[index].caseEvidentFound[i].isoIsHermastixChange),
    //         caseList[index].caseEvidentFound[i].isoIsPhenolphthaiein == '' ||
    //                 caseList[index].caseEvidentFound[i].isoIsPhenolphthaiein ==
    //                     'True' ||
    //                 caseList[index].caseEvidentFound[i].isoIsPhenolphthaiein ==
    //                     'False'
    //             ? -2
    //             : int.parse(caseList[index].caseEvidentFound[i].isoIsPhenolphthaiein),
    //         caseList[index].caseEvidentFound[i].isoIsPhenolphthaieinChange == '' || caseList[index].caseEvidentFound[i].isoIsPhenolphthaieinChange == 'True' || caseList[index].caseEvidentFound[i].isoIsPhenolphthaieinChange == 'False' ? -2 : int.parse(caseList[index].caseEvidentFound[i].isoIsPhenolphthaieinChange),
    //         '',
    //         '',
    //         '',
    //         '',
    //         1);

    //     print('ข้อ 7.4');
    //   }
    // }

    // // ข้อ 7.4 วัตถุพยานที่ตรวจเก็บ

    // if (caseList[index].caseEvident != null) {
    //   for (int i = 0; i < caseList[index].caseEvident.length; i++) {
    //     print(
    //         'CaseEvidentDaoCaseEvidentDaoCaseEvidentDaoCaseEvidentDaoCaseEvidentDaoCaseEvidentDao');
    //     await CaseEvidentDao().createCaseEvident(
    //         fidsCrimeScene.fidsid,
    //         caseList[index].caseEvident[i].evidentNo,
    //         caseList[index].caseEvident[i].evidentTypeId == ''
    //             ? -2
    //             : int.parse(caseList[index].caseEvident[i].evidentTypeId),
    //         caseList[index].caseEvident[i].evidentDetail,
    //         caseList[index].caseEvident[i].evidentAmount == ''
    //             ? -2
    //             : int.parse(caseList[index].caseEvident[i].evidentAmount),
    //         caseList[index].caseEvident[i].evidentUnitId == ''
    //             ? -2
    //             : int.parse(caseList[index].caseEvident[i].evidentUnitId),
    //         caseList[index].caseEvident[i].packageId == ''
    //             ? -2
    //             : int.parse(caseList[index].caseEvident[i].packageId),
    //         caseList[index].caseEvident[i].isEvidentOperate == '' ||
    //                 caseList[index].caseEvident[i].isEvidentOperate == 'True' ||
    //                 caseList[index].caseEvident[i].isEvidentOperate == 'False'
    //             ? -2
    //             : int.parse(caseList[index].caseEvident[i].isEvidentOperate),
    //         caseList[index].caseEvident[i].departmentId == ''
    //             ? -2
    //             : int.parse(caseList[index].caseEvident[i].departmentId),
    //         caseList[index].caseEvident[i].workGroupId == ''
    //             ? -2
    //             : int.parse(caseList[index].caseEvident[i].workGroupId),
    //         caseList[index].caseEvident[i].caseEvidentFoundId == ''
    //             ? -2
    //             : int.parse(caseList[index].caseEvident[i].caseEvidentFoundId),
    //         caseList[index].caseEvident[i].deliverWorkGroupID == ''
    //             ? -2
    //             : int.parse(caseList[index].caseEvident[i].deliverWorkGroupID),
    //         '',
    //         '',
    //         '',
    //         '',
    //         1);

    //     print('ข้อ 7.4');
    //   }
    // }

    // // ข้อ 7.5 การส่งมอบสถานที่เกิดเหตุ

    // await FidsCrimeSceneDao().updateReleaseCase(
    //     caseList[index].isoIsFinal == '' ||
    //             caseList[index].isoIsFinal == 'True' ||
    //             caseList[index].isoIsFinal == 'False'
    //         ? -2
    //         : int.parse(caseList[index].isoIsFinal),
    //     caseList[index].isoIsComplete == '' ||
    //             caseList[index].isoIsComplete == 'True' ||
    //             caseList[index].isoIsComplete == 'False'
    //         ? -2
    //         : int.parse(caseList[index].isoIsComplete),
    //     caseList[index].isoIsDeliver == '' ||
    //             caseList[index].isoIsDeliver == 'True' ||
    //             caseList[index].isoIsDeliver == 'False'
    //         ? -2
    //         : int.parse(caseList[index].isoIsDeliver),
    //     caseList[index].closeDate,
    //     caseList[index].closeTime,
    //     '${fidsCrimeScene.fidsNo}');

    // print('terk นอกอาคาร');

    // //  ข้อ 7.6 แผนผังสถานที่เกิดเหตุ

    setState(() {
      isLoading = false;
    });
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop(true);
    if (kDebugMode) {
      print('downloadCaseAtIndexdownloadCaseAtIndexdownloadCaseAtIndex');
    }
  }

  _displaySnackBar(BuildContext context, String? msg) {
    final snackBar = SnackBar(
      content: Text(
        '$msg',
        textAlign: TextAlign.center,
        style: GoogleFonts.prompt(
          textStyle: TextStyle(
            color: Colors.white,
            letterSpacing: 0.5,
            fontSize: MediaQuery.of(context).size.height * 0.02,
          ),
        ),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    isLoading = false;
  }

  getUGroup() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uGroup = prefs.getString('uGroup');
    if (kDebugMode) {
      print('uGroupuGroupuGroupuGroup $uGroup');
    }
    _getCases();
  }
}
