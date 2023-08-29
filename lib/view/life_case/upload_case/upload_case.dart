// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Utils/color.dart';
import '../../../models/CaseAreaClue.dart';
import '../../../models/CaseAsset.dart';
import '../../../models/CaseAssetArea.dart';
import '../../../models/CaseBody.dart';
import '../../../models/CaseBodyReferencePoint.dart';
import '../../../models/CaseBodyWound.dart';
import '../../../models/CaseBomb.dart';
import '../../../models/CaseCategory.dart';
import '../../../models/CaseClue.dart';
import '../../../models/CaseEvident.dart';
import '../../../models/CaseEvidentDeliver.dart';
import '../../../models/CaseEvidentFound.dart';
import '../../../models/CaseEvidentLocation.dart';
import '../../../models/CaseExhibit.dart';
import '../../../models/CaseImage.dart';
import '../../../models/CaseInspection.dart';
import '../../../models/CaseInspector.dart';
import '../../../models/CaseInternal.dart';
import '../../../models/CaseRansacked.dart';
import '../../../models/CaseReferencePoint.dart';
import '../../../models/CaseRelatedPerson.dart';
import '../../../models/CaseSceneLocation.dart';
import '../../../models/CrimesceneAPI.dart';
import '../../../models/CrimesceneAssetApi.dart';
import '../../../models/CrimesceneBombApi.dart';
import '../../../models/CrimesceneWitnessCaseCrimeSceneAPI.dart';
import '../../../models/CrimesceneWitnessCaseObjAPI.dart';
import '../../../models/CrimesceneWitnessCasePersonApi.dart';
import '../../../models/DiagramLocation.dart';
import '../../../models/FidsCrimeScene.dart';
import '../../../models/FidsCrimeSceneAPI.dart';
import '../../../models/FidsCrimeSceneAssetAPI.dart';
import '../../../models/FidsCrimeSceneBombAPI.dart';
import '../../../models/FidsCrimeSceneWitnessCaseCrimeSceneAPI.dart';
import '../../../models/FidsCrimeSceneWitnessCaseObjAPI.dart';
import '../../../models/FidsCrimeSceneWitnessCasePersonAPI.dart';
import '../../../models/PoliceStation.dart';
import '../../../models/Title.dart';
import '../../../models/case_fire/CaseFireAreaDoa.dart';
import '../../../models/case_fire/CaseFireSideAreaDao.dart';
import '../../../models/case_fire/UploadFire.dart';
import '../../../models/case_vehicle/CaseDamaged.dart';
import '../../../models/case_vehicle/CaseVehicleCompare.dart';
import '../../../models/case_vehicle/CaseVehicleCompareDetail.dart';
import '../../../models/case_vehicle/CaseVehicleDao.dart';
import '../../../models/case_vehicle/CaseVehicleOpinion.dart';
import '../../../models/case_vehicle/UploadTrafficCase.dart';
import '../../../widget/app_bar_widget.dart';
import '../../../widget/blurry_dialog.dart';

class UploadCase extends StatefulWidget {
  const UploadCase({super.key});

  @override
  UploadCaseState createState() => UploadCaseState();
}

class UploadCaseState extends State<UploadCase> {
  List<FidsCrimeScene> data = [];
  List<CaseCategory> categories = [];
  List<PoliceStation> policeStations = [];
  List<MyTitle> title = [];

  bool isPhone = Device.get().isPhone;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    asyncMethod();
  }

  Future<dynamic> asyncMethod() async {
    var result = await FidsCrimeSceneDao().getFidsCrimeScene();
    var result2 = await CaseCategoryDAO().getCaseCategory();
    var result3 = await PoliceStationDao().getPoliceStation();
    var result4 = await TitleDao().getTitle();

    setState(() {
      List<FidsCrimeScene> reversedList =
          List<FidsCrimeScene>.from(result.reversed);
      data = reversedList;
      categories = result2;
      policeStations = result3;
      title = result4;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    if (isLoading) {
      return Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/bgNew.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBarWidget(
        title: 'เลือกคดีที่ต้องการอัพโหลด',
        actions: [
          Container(
            width: MediaQuery.of(context).size.width * 0.1,
          )
        ],
        leading: IconButton(
          icon: isIOS
              ? const Icon(Icons.arrow_back_ios)
              : const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
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
            child: Stack(fit: StackFit.expand, children: [
              data.isNotEmpty
                  ? _listCase()
                  : Center(
                      child: Text(
                        'ไม่มีคดี',
                        style: GoogleFonts.prompt(
                          textStyle: TextStyle(
                            color: textColor,
                            letterSpacing: 0.5,
                            fontSize:
                                MediaQuery.of(context).size.height * 0.025,
                          ),
                        ),
                      ),
                    ),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _listCase() {
    return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          return _caseCard(index);
        });
  }

  Widget _caseCard(int index) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              Colors.white,
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ))),
        child: Stack(
          children: [
            Container(
              width: 30,
              height: 100,
              color: green,
            ),
            Container(
              margin: const EdgeInsets.only(left: 30),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _rowHeadInCard('FIDS-ID : ${data[index].fidsNo}'),
                    _rowInCard('เเจ้งเมื่อ : ${data[index].caseIssueDate}'),
                    _rowInCard(
                        'ประเภทคดี : ${caseCategoryLabel(data[index].caseCategoryID ?? -1)}'),
                    _rowInCard('เลขรายงาน : ${data[index].reportNo}'),
                    _rowInCard(
                        'หน่วยผู้เเจ้ง : ${policeStationLabel(data[index].policeStationID ?? -1)}'),
                    _rowInCard(
                        'ผู้แจ้ง : ${titleLabel(data[index].investigatorTitleID ?? -1)} ${data[index].investigatorName}'),
                  ],
                ),
              ),
            ),
          ],
        ),
        onPressed: () async {
          showAlertDialog(context, data[index].fidsNo, data[index]);
        },
      ),
    );
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
                color: darkBlue,
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
            label ?? "",
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

  String? caseCategoryLabel(int id) {
    for (int i = 0; i < categories.length; i++) {
      if ('$id' == '${categories[i].id}') {
        return categories[i].name;
      }
    }
    return '';
  }

  String? policeStationLabel(int id) {
    for (int i = 0; i < policeStations.length; i++) {
      if ('$id' == '${policeStations[i].id}') {
        return policeStations[i].name;
      }
    }
    return '';
  }

  String? titleLabel(int id) {
    for (int i = 0; i < title.length; i++) {
      if ('$id' == '${title[i].id}') {
        return title[i].name;
      }
    }
    return '';
  }

  showAlertDialog(BuildContext context, String? text, FidsCrimeScene res) {
    // AlertDialog alert = AlertDialog(
    //   title: Text("แจ้งเตือน"),
    //   content: Text("ยืนยันการอัพโหลดคดี\nFids-ID : $text"),
    //   actions: [
    //     cancelButton,
    //     continueButton,
    //   ],
    // );
    BlurryDialog alert = BlurryDialog('แจ้งเตือน', 'ยืนยันการอัพโหลดคดี', () {
      setState(() {
        isLoading = true;
      });
      if (res.caseCategoryID == 3) {
        uploadLifeCase(res);
      } else if (res.caseCategoryID == 2) {
        uploadFireCase(res);
      } else if (res.caseCategoryID == 4) {
        uploadBombCase(res);
      } else if (res.caseCategoryID == 1) {
        uploadAssetCase(res);
      } else if (res.caseCategoryID == 6) {
        uploadWitnessCaseObj(res);
      } else if (res.caseCategoryID == 9) {
        uploadWitnessCaseCrimeScene(res);
      } else if (res.caseCategoryID == 8) {
        uploadWittnessCasePerson(res);
      }
      //จราจร
      else if (res.caseCategoryID == 5) {
        uploadTrafficCase(res);
      }
    });

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> uploadWittnessCasePerson(FidsCrimeScene res) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var uid = prefs.getString('uid');
    CrimesceneWitnessCasePersonApi? request;
    if (res.fidsNo == '') {
      var detail =
          await FidsCrimeSceneWitnessCasePersonAPI().generateModel(res);
      request = CrimesceneWitnessCasePersonApi(
          fidsNo: res.fidsNo,
          action: 'new',
          userId: uid,
          fidsCrimeScene: detail);
    } else {
      var detail =
          await FidsCrimeSceneWitnessCasePersonAPI().generateModel(res);
      request = CrimesceneWitnessCasePersonApi(
          fidsNo: res.fidsNo,
          action: 'update',
          userId: uid,
          fidsCrimeScene: detail);
    }

    //   debugPrint(' text terk : ${request.toJson()}', wrapWidth: 1024);

    printWrapped(' text terk : ${jsonEncode(request)}');

    await http
        .post(
            Uri.parse(
                'https://crimescene.fids.police.go.th/mobile/api/Crimescene/Upload'),
            headers: <String, String>{
              "Content-Type": "application/json",
            },
            body: jsonEncode(request))
        .then((response) async {
      if (kDebugMode) {
        print(
            'response.code : ${response.statusCode} : response.body  ${response.body} ');
      }

      if (response.statusCode != 200) {
        if (kDebugMode) {
          print('response.statusCode != 200');
        }
        Map map = json.decode(response.body);
        var error = map['errors'];

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('เกิดข้อผิดพลาด ไม่สามารถอัปโหลดได้'),
          ),
        );
        Navigator.of(context).pop(true);
        //throw Exception(error);
      } else if (response.statusCode == 200) {
        Map map = json.decode(response.body);
        if (kDebugMode) {
          print('map : ${map.toString()}');
        }
        await FidsCrimeSceneDao().deleteFidsCrimeScene(res.fidsid ?? -1);
        await CaseInternalDao().delete(res.fidsid ?? -1);
        await CaseRelatedPersonDao().delete(res.fidsid ?? -1);
        await CaseSceneLocationDao().delete(res.fidsid ?? -1);
        await CaseInspectionDao().delete(res.fidsid ?? -1);

        for (int i = 0;
            i < request!.fidsCrimeScene![0].caseInspector!.length;
            i++) {
          await CaseInspectorDao().deleteById(
              request.fidsCrimeScene![0].caseInspector![i].id.toString());
        }

        await CaseImagesDao().deleteCaseImagesAll('${res.fidsid ?? -1}');
        await CaseEvidentDeliverDao().deleteAll(res.fidsid ?? -1);
        await CaseEvidentFoundDao().delete(res.fidsid ?? -1);
        await CaseEvidentDao().delete(res.fidsid ?? -1);
        await DiagramLocationDao().delete(res.fidsid ?? -1);
        await asyncMethod().then((value) => Navigator.of(context).pop(true));
      }

      setState(() {
        isLoading = false;
      });
    });
  }

  Future<void> uploadWitnessCaseObj(FidsCrimeScene res) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var uid = prefs.getString('uid');
    CrimesceneWitnessCaseObjApi? request;
    if (res.fidsNo == '') {
      var detail = await FidsCrimeSceneWitnessCaseObjAPI().generateModel(res);
      request = CrimesceneWitnessCaseObjApi(
          fidsNo: res.fidsNo,
          action: 'new',
          userId: uid,
          fidsCrimeScene: detail);
    } else {
      var detail = await FidsCrimeSceneWitnessCaseObjAPI().generateModel(res);
      request = CrimesceneWitnessCaseObjApi(
          fidsNo: res.fidsNo,
          action: 'update',
          userId: uid,
          fidsCrimeScene: detail);
    }

    //   debugPrint(' text terk : ${request.toJson()}', wrapWidth: 1024);

    printWrapped(' text terk : ${jsonEncode(request)}');

    await http
        .post(
            Uri.parse(
                'https://crimescene.fids.police.go.th/mobile/api/Crimescene/Upload'),
            headers: <String, String>{
              "Content-Type": "application/json",
            },
            body: jsonEncode(request))
        .then((response) async {
      if (kDebugMode) {
        print(
            'response.code : ${response.statusCode} : response.body  ${response.body} ');
      }

      if (response.statusCode != 200) {
        if (kDebugMode) {
          print('response.statusCode != 200');
        }
        Map map = json.decode(response.body);
        var error = map['errors'];

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('เกิดข้อผิดพลาด ไม่สามารถอัปโหลดได้'),
          ),
        );
        Navigator.of(context).pop(true);
        //throw Exception(error);
      } else if (response.statusCode == 200) {
        Map map = json.decode(response.body);
        if (kDebugMode) {
          print('map : ${map.toString()}');
        }
        await FidsCrimeSceneDao().deleteFidsCrimeScene(res.fidsid ?? -1);
        await CaseInternalDao().delete(res.fidsid ?? -1);
        await CaseRelatedPersonDao().delete(res.fidsid ?? -1);
        await CaseSceneLocationDao().delete(res.fidsid ?? -1);
        // await CaseInspectionDao().delete(res.fidsid?? -1);

        if (request != null) {
          if (request.fidsCrimeScene != null) {
            if (request.fidsCrimeScene![0].caseInspector != null) {}
            for (int i = 0;
                i < request.fidsCrimeScene![0].caseInspector!.length;
                i++) {
              await CaseInspectorDao().deleteById(
                  request.fidsCrimeScene![0].caseInspector![i].id.toString());
            }
          }
        }

        // for (int i = 0; i < request.fidsCrimeScene[0].caseBody.length; i++) {
        //   await CaseBodyWoundDao()
        //       .deleteCaseBodyWound(request.fidsCrimeScene[0].caseBody[i].id);
        // }

        //await CaseBodyDao().delete(res.fidsid?? -1);
        // await CaseReferencePointDao().deleteCaseReferencePointFidsID(res.fidsid?? -1);
        // await CaseBodyReferencePointDao()
        //     .deleteCaseBodyReferencePointFidsID(res.fidsid?? -1);

        await CaseImagesDao().deleteCaseImagesAll('${res.fidsid}');
        await CaseExhibitDao().delete(res.fidsid ?? -1);
        // await CaseEvidentDeliverDao().deleteAll(res.fidsid?? -1);
        // await CaseEvidentLocationDao().deleteAll(res.fidsid?? -1);
        // await CaseEvidentFoundDao().delete(res.fidsid?? -1);
        await CaseEvidentDao().delete(res.fidsid ?? -1);
        await DiagramLocationDao().delete(res.fidsid ?? -1);
        await asyncMethod().then((value) => Navigator.of(context).pop(true));
      }

      // getUGroup();

      setState(() {
        isLoading = false;
      });
    });
  }

  Future<void> uploadBombCase(FidsCrimeScene res) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var uid = prefs.getString('uid');
    CrimesceneBombApi request;
    if (res.fidsNo == '') {
      var detail = await FidsCrimeSceneBombAPI().generateModel(res);
      request = CrimesceneBombApi(
          fidsNo: res.fidsNo,
          action: 'new',
          userId: uid,
          fidsCrimeScene: detail);
    } else {
      var detail = await FidsCrimeSceneBombAPI().generateModel(res);
      request = CrimesceneBombApi(
          fidsNo: res.fidsNo,
          action: 'update',
          userId: uid,
          fidsCrimeScene: detail);
    }

    //   debugPrint(' text terk : ${request.toJson()}', wrapWidth: 1024);

    printWrapped(' text terk : ${jsonEncode(request)}');

    await http
        .post(
            Uri.parse(
                'https://crimescene.fids.police.go.th/mobile/api/Crimescene/Upload'),
            headers: <String, String>{
              "Content-Type": "application/json",
            },
            body: jsonEncode(request))
        .then((response) async {
      if (kDebugMode) {
        print(
            'response.code : ${response.statusCode} : response.body  ${response.body} ');
      }

      if (response.statusCode != 200) {
        if (kDebugMode) {
          print('response.statusCode != 200');
        }
        Map map = json.decode(response.body);
        var error = map['errors'];

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('เกิดข้อผิดพลาด ไม่สามารถอัปโหลดได้'),
          ),
        );
        Navigator.of(context).pop(true);
        //throw Exception(error);
      } else if (response.statusCode == 200) {
        Map map = json.decode(response.body);
        if (kDebugMode) {
          print('map : ${map.toString()}');
        }
        await FidsCrimeSceneDao().deleteFidsCrimeScene(res.fidsid ?? -1);
        await CaseInternalDao().delete(res.fidsid ?? -1);
        await CaseRelatedPersonDao().delete(res.fidsid ?? -1);
        await CaseSceneLocationDao().delete(res.fidsid ?? -1);
        await CaseInspectionDao().delete(res.fidsid ?? -1);

        if (request.fidsCrimeScene != null) {
          if (request.fidsCrimeScene![0].caseInspector != null) {}

          for (int i = 0;
              i < request.fidsCrimeScene![0].caseInspector!.length;
              i++) {
            await CaseInspectorDao().deleteById(
                request.fidsCrimeScene![0].caseInspector![i].id.toString());
          }
        }

        if (request.fidsCrimeScene != null) {
          if (request.fidsCrimeScene?[0].caseBody != null) {}

          for (int i = 0;
              i < request.fidsCrimeScene![0].caseBody!.length;
              i++) {
            await CaseBodyWoundDao().deleteCaseBodyWound(
                request.fidsCrimeScene![0].caseBody![i].id ?? '');
          }
        }

        await CaseBodyDao().delete(res.fidsid ?? -1);
        await CaseReferencePointDao()
            .deleteCaseReferencePointFidsID(res.fidsid ?? -1);
        await CaseBodyReferencePointDao()
            .deleteCaseBodyReferencePointFidsID(res.fidsid ?? -1);

        await CaseImagesDao().deleteCaseImagesAll('${res.fidsid}');
        await CaseEvidentDeliverDao().deleteAll(res.fidsid ?? -1);
        await CaseEvidentLocationDao().deleteAll(res.fidsid ?? -1);
        await CaseEvidentFoundDao().delete(res.fidsid ?? -1);
        await CaseEvidentDao().delete(res.fidsid ?? -1);
        await DiagramLocationDao().delete(res.fidsid ?? -1);
        await CaseBombDao().delete(res.fidsid ?? -1);
        await asyncMethod().then((value) => Navigator.of(context).pop(true));

        setState(() {
          isLoading = false;
        });
      }
    });
  }

  Future<void> uploadAssetCase(FidsCrimeScene res) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var uid = prefs.getString('uid');
    CrimesceneAssetApi request;
    if (res.fidsNo == '') {
      var detail = await FidsCrimeSceneAssetAPI().generateModel(res);
      request = CrimesceneAssetApi(
          fidsNo: res.fidsNo,
          action: 'new',
          userId: uid,
          fidsCrimeScene: detail);
    } else {
      var detail = await FidsCrimeSceneAssetAPI().generateModel(res);
      request = CrimesceneAssetApi(
          fidsNo: res.fidsNo,
          action: 'update',
          userId: uid,
          fidsCrimeScene: detail);
    }

    //   debugPrint(' text terk : ${request.toJson()}', wrapWidth: 1024);

    printWrapped(' text terk : ${jsonEncode(request)}');

    await http
        .post(
            Uri.parse(
                'https://crimescene.fids.police.go.th/mobile/api/Crimescene/Upload'),
            headers: <String, String>{
              "Content-Type": "application/json",
            },
            body: jsonEncode(request))
        .then((response) async {
      if (kDebugMode) {
        print(
            'response.code : ${response.statusCode} : response.body  ${response.body} ');
      }

      if (response.statusCode != 200) {
        if (kDebugMode) {
          print('response.statusCode != 200');
        }
        Map map = json.decode(response.body);
        var error = map['errors'];

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('เกิดข้อผิดพลาด ไม่สามารถอัปโหลดได้'),
          ),
        );
        Navigator.of(context).pop(true);
        //throw Exception(error);
      } else if (response.statusCode == 200) {
        Map map = json.decode(response.body);
        if (kDebugMode) {
          print('map : ${map.toString()}');
        }

        // List<CaseInternal> caseInternal;
        // List<CaseRelatedPerson> caseRelatedPerson;
        // List<CaseSceneLocation> caseSceneLocation;
        // List<CaseInspection> caseInspection;
        // List<CaseInspector> caseInspector;
        // List<CaseBody> caseBody;
        // List<CaseReferencePoint> referencePoint;
        // List<CaseEvidentForm> caseEvident;
        // List<CaseImages> caseimage;
        // List<CaseClue> caseClues;
        // List<CaseAssetArea> caseAssetAreas;
        // List<CaseAsset> caseAssets;

        // await FidsCrimeSceneDao().deleteFidsCrimeScene(res.fidsid?? -1);

        // for (int i = 0; i < request.fidsCrimeScene[0].caseInternal.length; i++) {
        //   await CaseInternalDao().deleteById(
        //       request.fidsCrimeScene[0].caseInternal[i].id.toString());
        // }

        // for (int i = 0;
        //     i < request.fidsCrimeScene[0].caseRelatedPerson.length;
        //     i++) {
        //   await CaseRelatedPersonDao().deleteCaseRelatedPerson(
        //       request.fidsCrimeScene[0].caseRelatedPerson[i].id.toString());
        // }

        // for (int i = 0;
        //     i < request.fidsCrimeScene[0].caseSceneLocation.length;
        //     i++) {
        //   await CaseSceneLocationDao().deleteById(
        //       request.fidsCrimeScene[0].caseSceneLocation[i].id.toString());
        // }

        // for (int i = 0;
        //     i < request.fidsCrimeScene[0].caseInspection.length;
        //     i++) {
        //   await CaseInspectionDao().deleteCaseInspection(
        //       request.fidsCrimeScene[0].caseInspection[i].id.toString());
        // }

        // for (int i = 0; i < request.fidsCrimeScene[0].caseInspector.length; i++) {
        //   await CaseInspectorDao().deleteById(
        //       request.fidsCrimeScene[0].caseInspector[i].id.toString());
        // }

        // for (int i = 0; i < request.fidsCrimeScene[0].caseBody.length; i++) {
        //   await CaseBodyDao().deleteCaseBody(
        //       int.parse(request.fidsCrimeScene[0].caseBody[i].id));
        //   await CaseBodyReferencePointDao().deleteAllCaseBodyReferencePoint(
        //       request.fidsCrimeScene[0].caseBody[i].id);
        //   await CaseBodyWoundDao()
        //       .deleteAllCaseBodyWound(request.fidsCrimeScene[0].caseBody[i].id);
        // }

        // for (int i = 0;
        //     i < request.fidsCrimeScene[0].referencePoint.length;
        //     i++) {
        //   await CaseReferencePointDao().deleteCaseReferencePoint(
        //       request.fidsCrimeScene[0].referencePoint[i].id);
        // }

        // for (int i = 0; i < request.fidsCrimeScene[0].caseEvident.length; i++) {
        //   await CaseEvidentDao()
        //       .deleteCaseEvidentBy(request.fidsCrimeScene[0].caseEvident[i].id);
        // }

        // for (int i = 0; i < request.fidsCrimeScene[0].caseImage.length; i++) {
        //   await CaseImagesDao().deleteCaseImages(
        //       request.fidsCrimeScene[0].caseImage[i].id.toString());
        // }

        // for (int i = 0; i < request.fidsCrimeScene[0].caseClues.length; i++) {
        //   await CaseClueDao().deleteCaseClueById(
        //       request.fidsCrimeScene[0].caseClues[i].id.toString());
        // }

        // for (int i = 0;
        //     i < request.fidsCrimeScene[0].caseAssetAreas.length;
        //     i++) {
        //   await CaseAreaClueDao().deleteCaseAreaClueAll(
        //       request.fidsCrimeScene[0].caseAssetAreas[i].id.toString());
        //   await CaseRansackedDao().deleteCaseRansackedAll(
        //       request.fidsCrimeScene[0].caseAssetAreas[i].id.toString());
        // }

        // for (int i = 0; i < request.fidsCrimeScene[0].caseAssets.length; i++) {
        //   await CaseAssetDao().deleteCaseAssetById(
        //       request.fidsCrimeScene[0].caseAssets[i].id.toString());
        // }

        await CaseEvidentLocationDao().deleteAll(res.fidsid ?? -1);
        await CaseEvidentDeliverDao().deleteAll(res.fidsid ?? -1);

        await CaseInternalDao().delete(res.fidsid ?? -1);
        await CaseRelatedPersonDao().delete(res.fidsid ?? -1);
        await CaseSceneLocationDao().delete(res.fidsid ?? -1);
        await CaseInspectionDao().delete(res.fidsid ?? -1);

        if (request.fidsCrimeScene != null) {
          if (request.fidsCrimeScene![0].caseInspector != null) {
            for (int i = 0;
                i < request.fidsCrimeScene![0].caseInspector!.length;
                i++) {
              await CaseInspectorDao().deleteById(
                  request.fidsCrimeScene![0].caseInspector![i].id.toString());
            }
          }
        }

        await CaseImagesDao().deleteCaseImagesAll('${res.fidsid}');
        await CaseEvidentDeliverDao().deleteAll(res.fidsid ?? -1);
        await CaseEvidentLocationDao().deleteAll(res.fidsid ?? -1);
        await CaseEvidentFoundDao().delete(res.fidsid ?? -1);
        await CaseEvidentDao().delete(res.fidsid ?? -1);
        await DiagramLocationDao().delete(res.fidsid ?? -1);
        await CaseClueDao().delete('${res.fidsid}');
        await CaseAssetAreaDao().delete(res.fidsid ?? -1);
        await CaseAssetDao().delete(res.fidsid ?? -1);

        if (request.fidsCrimeScene != null) {
          if (request.fidsCrimeScene![0].caseAssetAreas != null) {
            for (int i = 0;
                i < request.fidsCrimeScene![0].caseAssetAreas!.length;
                i++) {
              await CaseAreaClueDao().deleteCaseAreaClueAll(
                  request.fidsCrimeScene![0].caseAssetAreas![i].id.toString());
              await CaseRansackedDao().deleteCaseRansackedAll(
                  request.fidsCrimeScene![0].caseAssetAreas![i].id.toString());
            }
          }
        }

        await asyncMethod().then((value) => Navigator.of(context).pop(true));
      }

      setState(() {
        isLoading = false;
      });
    });
  }

  void printWrapped(String? text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    // ignore: avoid_print
    pattern.allMatches(text ?? '').forEach((match) => print(match.group(0)));
  }

  Future<void> uploadLifeCase(FidsCrimeScene res) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var uid = prefs.getString('uid');
    CrimesceneApi? request;
    if (res.fidsNo == '') {
      var detail = await FidsCrimeSceneAPI().generateModel(res);
      request = CrimesceneApi(
          fidsNo: res.fidsNo,
          action: 'new',
          userId: uid,
          fidsCrimeScene: detail);
    } else {
      var detail = await FidsCrimeSceneAPI().generateModel(res);
      request = CrimesceneApi(
          fidsNo: res.fidsNo,
          action: 'update',
          userId: uid,
          fidsCrimeScene: detail);
    }

    //   debugPrint(' text terk : ${request.toJson()}', wrapWidth: 1024);

    printWrapped(' text terk : ${jsonEncode(request)}');

    await http
        .post(
            Uri.parse(
                'https://crimescene.fids.police.go.th/mobile/api/Crimescene/Upload'),
            headers: <String, String>{
              "Content-Type": "application/json",
            },
            body: jsonEncode(request))
        .then((response) async {
      if (kDebugMode) {
        print(
            'response.code : ${response.statusCode} : response.body  ${response.body} ');
      }

      if (response.statusCode != 200) {
        if (kDebugMode) {
          print('response.statusCode != 200');
        }
        Map map = json.decode(response.body);
        var error = map['errors'];
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('เกิดข้อผิดพลาด ไม่สามารถอัปโหลดได้'),
          ),
        );
        Navigator.of(context).pop(true);
      } else if (response.statusCode == 200) {
        Map map = json.decode(response.body);
        if (kDebugMode) {
          print('map : ${map.toString()}');
        }
        await FidsCrimeSceneDao().deleteFidsCrimeScene(res.fidsid ?? -1);
        await CaseInternalDao().delete(res.fidsid ?? -1);
        await CaseRelatedPersonDao().delete(res.fidsid ?? -1);
        await CaseSceneLocationDao().delete(res.fidsid ?? -1);
        await CaseInspectionDao().delete(res.fidsid ?? -1);

        if (request?.fidsCrimeScene != null) {
          if (request?.fidsCrimeScene![0].caseInspector != null) {
            for (int i = 0;
                i < request!.fidsCrimeScene![0].caseInspector!.length;
                i++) {
              await CaseInspectorDao().deleteById(
                  request.fidsCrimeScene![0].caseInspector![i].id.toString());
            }
          }
        }

        if (request?.fidsCrimeScene != null) {
          if (request?.fidsCrimeScene![0].caseBody != null) {
            for (int i = 0;
                i < request!.fidsCrimeScene![0].caseBody!.length;
                i++) {
              await CaseBodyWoundDao().deleteCaseBodyWound(
                  request.fidsCrimeScene![0].caseBody![i].id ?? '');
            }
          }
        }

        await CaseBodyDao().delete(res.fidsid ?? -1);
        await CaseReferencePointDao()
            .deleteCaseReferencePointFidsID(res.fidsid ?? -1);
        await CaseBodyReferencePointDao()
            .deleteCaseBodyReferencePointFidsID(res.fidsid ?? -1);
        await CaseImagesDao().deleteCaseImagesAll('${res.fidsid}');
        await CaseEvidentDeliverDao().deleteAll(res.fidsid ?? -1);
        await CaseEvidentLocationDao().deleteAll(res.fidsid ?? -1);
        await CaseEvidentFoundDao().delete(res.fidsid ?? -1);
        await CaseEvidentDao().delete(res.fidsid ?? -1);
        await DiagramLocationDao().delete(res.fidsid ?? -1);
        await asyncMethod().then((value) => Navigator.of(context).pop(true));
      }
      setState(() {
        isLoading = false;
      });
    });
  }

  Future<void> uploadWitnessCaseCrimeScene(FidsCrimeScene res) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var uid = prefs.getString('uid');
    CrimesceneWitnessCaseCrimeSceneApi request;
    if (res.fidsNo == '') {
      var detail =
          await FidsCrimeSceneWitnessCaseCrimeSceneAPI().generateModel(res);
      request = CrimesceneWitnessCaseCrimeSceneApi(
          fidsNo: res.fidsNo,
          action: 'new',
          userId: uid,
          fidsCrimeScene: detail);
    } else {
      var detail =
          await FidsCrimeSceneWitnessCaseCrimeSceneAPI().generateModel(res);
      request = CrimesceneWitnessCaseCrimeSceneApi(
          fidsNo: res.fidsNo,
          action: 'update',
          userId: uid,
          fidsCrimeScene: detail);
    }

    //   debugPrint(' text terk : ${request.toJson()}', wrapWidth: 1024);

    printWrapped(' text terk : ${jsonEncode(request)}');

    await http
        .post(
            Uri.parse(
                'https://crimescene.fids.police.go.th/mobile/api/Crimescene/Upload'),
            headers: <String, String>{
              "Content-Type": "application/json",
            },
            body: jsonEncode(request))
        .then((response) async {
      if (response.statusCode != 200) {
        Map map = json.decode(response.body);
        var error = map['errors'];

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('เกิดข้อผิดพลาด ไม่สามารถอัปโหลดได้'),
          ),
        );
        Navigator.of(context).pop(true);
        //throw Exception(error);
      } else if (response.statusCode == 200) {
        Map map = json.decode(response.body);
        if (kDebugMode) {
          print('map : ${map.toString()}');
        }
        await FidsCrimeSceneDao().deleteFidsCrimeScene(res.fidsid ?? -1);
        await CaseInternalDao().delete(res.fidsid ?? -1);
        await CaseRelatedPersonDao().delete(res.fidsid ?? -1);
        await CaseSceneLocationDao().delete(res.fidsid ?? -1);
        await CaseInspectionDao().delete(res.fidsid ?? -1);

        for (int i = 0;
            i < request.fidsCrimeScene![0].caseInspector!.length;
            i++) {
          await CaseInspectorDao().deleteById(
              request.fidsCrimeScene![0].caseInspector![i].id.toString());
        }
        await CaseReferencePointDao()
            .deleteCaseReferencePointFidsID(res.fidsid ?? -1);
        await CaseBodyReferencePointDao()
            .deleteCaseBodyReferencePointFidsID(res.fidsid ?? -1);

        await CaseImagesDao().deleteCaseImagesAll('${res.fidsid}');
        await CaseEvidentDeliverDao().deleteAll(res.fidsid ?? -1);
        await CaseEvidentLocationDao().deleteAll(res.fidsid ?? -1);
        await CaseEvidentFoundDao().delete(res.fidsid ?? -1);
        await CaseEvidentDao().delete(res.fidsid ?? -1);
        await DiagramLocationDao().delete(res.fidsid ?? -1);
        await asyncMethod().then((value) => Navigator.of(context).pop(true));
      }
      setState(() {
        isLoading = false;
      });
    });
  }

  Future<void> uploadTrafficCase(FidsCrimeScene res) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var uid = prefs.getString('uid');
    TrafficAPI? request;
    if (res.fidsNo == '') {
      var detail = await FidsCrimeSceneTraffic().generateModel(res);
      request = TrafficAPI(
          fidsNo: res.fidsNo,
          action: 'new',
          userId: uid,
          fidsCrimeScene: detail);
    } else {
      var detail = await FidsCrimeSceneTraffic().generateModel(res);
      request = TrafficAPI(
          fidsNo: res.fidsNo,
          action: 'update',
          userId: uid,
          fidsCrimeScene: detail);
    }

    printWrapped(' fongchol : ${jsonEncode(request)}');

    await http
        .post(
            Uri.parse(
                'https://crimescene.fids.police.go.th/mobile/api/Crimescene/Upload'),
            headers: <String, String>{
              "Content-Type": "application/json",
            },
            body: jsonEncode(request))
        .then((response) async {
      if (response.statusCode != 200) {
        Map map = json.decode(response.body);
        var error = map['errors'];

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('เกิดข้อผิดพลาด ไม่สามารถอัปโหลดได้'),
          ),
        );
        Navigator.of(context).pop(true);
        //throw Exception(error);
      } else if (response.statusCode == 200) {
        Map map = json.decode(response.body);

        await FidsCrimeSceneDao().deleteFidsCrimeScene(res.fidsid ?? -1);
        await CaseRelatedPersonDao().delete(res.fidsid ?? -1);

        for (int i = 0;
            i < request!.fidsCrimeScene![0].caseInspection!.length;
            i++) {
          await CaseInspectionDao().deleteCaseInspection(
              request.fidsCrimeScene![0].caseInspection![i].id.toString());
        }

        for (int i = 0;
            i < request.fidsCrimeScene![0].caseInspector!.length;
            i++) {
          await CaseInspectorDao().deleteById(
              request.fidsCrimeScene![0].caseInspector![i].id.toString());
        }

        for (int i = 0;
            i < request.fidsCrimeScene![0].caseVehicle!.length;
            i++) {
          await CaseVehicleDao().deleteCaseVehicle(
              request.fidsCrimeScene![0].caseVehicle![i].id.toString());
        }
        for (int i = 0;
            i < request.fidsCrimeScene![0].caseVehicleDamaged!.length;
            i++) {
          await CaseDamagedDao().deleteCaseVehicleDamaged(
              request.fidsCrimeScene![0].caseVehicleDamaged![i].id.toString());
        }

        for (int i = 0;
            i < request.fidsCrimeScene![0].caseVehicleCompare!.length;
            i++) {
          await CaseVehicleCompareDao().deleteCaseVehicleCompared(
              request.fidsCrimeScene![0].caseVehicleCompare![i].id.toString());
        }

        for (int i = 0;
            i < request.fidsCrimeScene![0].caseVehicleCompareDetail!.length;
            i++) {
          await CaseVehicleCompareDetailDao().deleteCaseVehicleCompareDetail(
              request.fidsCrimeScene![0].caseVehicleCompareDetail![i].id
                  .toString());
        }

        for (int i = 0;
            i < request.fidsCrimeScene![0].caseVehicleOpinion!.length;
            i++) {
          await CaseVehicleOpinionDao().deleteCaseVehicleOpinion(
              request.fidsCrimeScene![0].caseVehicleOpinion![i].id.toString());
        }

        for (int i = 0; i < request.fidsCrimeScene![0].image!.length; i++) {
          await CaseImagesDao().deleteCaseImages(
              request.fidsCrimeScene![0].image![i].id.toString());
        }

        await CaseImagesDao().deleteCaseImagesAll('${res.fidsid}');
        await CaseEvidentDao().delete(res.fidsid ?? -1);
        await asyncMethod().then((value) => Navigator.of(context).pop(true));
      }
      setState(() {
        isLoading = false;
      });
    });
  }

  Future<void> uploadFireCase(FidsCrimeScene res) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var uid = prefs.getString('uid');
    FireAPI request;
    if (res.fidsNo == '') {
      var detail = await FidsCrimeSceneFireCase().generateModel(res);
      request = FireAPI(
          fidsNo: res.fidsNo,
          action: 'new',
          userId: uid,
          fidsCrimeScene: detail);
    } else {
      var detail = await FidsCrimeSceneFireCase().generateModel(res);
      request = FireAPI(
          fidsNo: res.fidsNo,
          action: 'update',
          userId: uid,
          fidsCrimeScene: detail);
    }

    printWrapped(' fongchol : ${jsonEncode(request)}');

    await http
        .post(
            Uri.parse(
                'https://crimescene.fids.police.go.th/mobile/api/Crimescene/Upload'),
            headers: <String, String>{
              "Content-Type": "application/json",
            },
            body: jsonEncode(request))
        .then((response) async {
      if (response.statusCode != 200) {
        Map map = json.decode(response.body);
        var error = map['errors'];
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('เกิดข้อผิดพลาด ไม่สามารถอัปโหลดได้'),
          ),
        );
        Navigator.of(context).pop(true);
      } else if (response.statusCode == 200) {
        Map map = json.decode(response.body);
        await FidsCrimeSceneDao().deleteFidsCrimeScene(res.fidsid ?? -1);
        await CaseInternalDao().delete(res.fidsid ?? -1);
        await CaseRelatedPersonDao().delete(res.fidsid ?? -1);
        await CaseSceneLocationDao().delete(res.fidsid ?? -1);
        await CaseInspectionDao().delete(res.fidsid ?? -1);
        for (int i = 0;
            i < request.fidsCrimeScene![0].caseInspector!.length;
            i++) {
          await CaseInspectorDao().deleteById(
              request.fidsCrimeScene![0].caseInspector![i].id.toString());
        }
        for (int i = 0;
            i < request.fidsCrimeScene![0].caseVehicle!.length;
            i++) {
          await CaseVehicleDao().deleteCaseVehicle(
              request.fidsCrimeScene![0].caseVehicle![i].id.toString());
        }
        await CaseBodyDao().delete(res.fidsid ?? -1);
        await CaseReferencePointDao()
            .deleteCaseReferencePointFidsID(res.fidsid ?? -1);
        await CaseBodyReferencePointDao()
            .deleteCaseBodyReferencePointFidsID(res.fidsid ?? -1);
        await CaseImagesDao().deleteCaseImagesAll('${res.fidsid}');
        await CaseEvidentDeliverDao().deleteAll(res.fidsid ?? -1);
        await CaseEvidentLocationDao().deleteAll(res.fidsid ?? -1);
        await CaseEvidentFoundDao().delete(res.fidsid ?? -1);
        await CaseEvidentDao().delete(res.fidsid ?? -1);
        await DiagramLocationDao().delete(res.fidsid ?? -1);
        await CaseFireAreaDao().delete(res.fidsid ?? -1);
        await CaseFireSideAreaDao()
            .delete(res.fidsid ?? -1)
            .then((value) => Navigator.of(context).pop(true));
      }
      setState(() {
        isLoading = false;
      });
    });
  }
}
