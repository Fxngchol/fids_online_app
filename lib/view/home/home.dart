import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../Utils/color.dart';
import '../../models/Amphur.dart';
import '../../models/BodyPosition.dart';
import '../../models/Building.dart';
import '../../models/Career.dart';
import '../../models/CaseCategory.dart';
import '../../models/Department.dart';
import '../../models/EvidenceCheck.dart';
import '../../models/EvidenceGroup.dart';
import '../../models/EvidentType.dart';
import '../../models/FidsCrimeScene.dart';
import '../../models/Package.dart';
import '../../models/Personal.dart';
import '../../models/PoliceStation.dart';
import '../../models/Position.dart';
import '../../models/Province.dart';
import '../../models/RelatedPersonType.dart';
import '../../models/SubCaseCategory.dart';
import '../../models/Tambol.dart';
import '../../models/Title.dart';
import '../../models/TypeCard.dart';
import '../../models/Unit.dart';
import '../../models/WorkGroup.dart';
import '../../models/case_vehicle/VehicleBrand.dart';
import '../../models/case_vehicle/VehicleColor.dart';
import '../../models/case_vehicle/VehicleSide.dart';
import '../../models/case_vehicle/VehicleType.dart';
import '../../widget/blurry_dialog.dart';
import '../../widget/text_field_widget_with_icon.dart';
import '../bomb_case/main_menu/main_menu_bomb.dart';
import '../case_asset/main_menu/main_menu_asset.dart';
import '../fire_case/main_fire_case.dart';
import '../life_case/life_case.dart';
import '../life_case/request_case/edit_request_case.dart';
import '../life_case/select_cases/select_cases.dart';
import '../life_case/upload_case/upload_case.dart';
import '../traffic_case/traffic_main.dart';
import '../witness_case_crime_scene/main menu/main_menu_witness_crime_scene.dart';
import '../witness_case_obj/main menu/main_menu_witness_obj.dart';
import '../witness_case_person/main_menu_witness_case_person.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> with SingleTickerProviderStateMixin {
  bool isPhone = Device.get().isPhone;

  List<FidsCrimeScene> data = [];
  List<FidsCrimeScene> masterData = [];
  List<CaseCategory> categories = [];
  List<PoliceStation> policeStations = [];
  List<MyTitle> title = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late AnimationController _animationController;

  bool isLoading = true;
  bool isLoadingView = true;

  double percent = 0;
  String? name;
  String? userId;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );

    _animationController.addListener(() => setState(() {}));
    _animationController.repeat();
    asyncMethod();
    if (kDebugMode) {
      print('initState initState initState');
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  asyncMethod() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isLookup = prefs.getBool('isLookup');
    name = prefs.getString('username');
    userId = prefs.getString('userId');
    if (kDebugMode) {
      print('isLookup $isLookup');
      print('userId $userId');
    }

    if (isLookup == null) {
      await updateLookUp();
      setState(() {
        isLoading = false;
        percent = 1;
      });
    } else {
      isLoading = false;
    }
    await updateLookUp();
    asyncCall1();
  }

  void asyncCall1() async {
    var result = await FidsCrimeSceneDao().getFidsCrimeScene();
    var result2 = await CaseCategoryDAO().getCaseCategory();
    var result3 = await PoliceStationDao().getPoliceStation();
    var result4 = await TitleDao().getTitle();
    setState(() {
      masterData = result;
      if (kDebugMode) {
        print('masterData $masterData');
      }
      data = List<FidsCrimeScene>.from(masterData);
      if (kDebugMode) {
        print('data $data');
      }
      categories = result2;
      policeStations = result3;
      title = result4;
      isLoadingView = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Material(
        type: MaterialType.transparency,
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/bgNew.png"),
              fit: BoxFit.cover,
            ),
          ),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Container(
              width: double.infinity,
              height: 50.0,
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: LiquidLinearProgressIndicator(
                value: percent,
                backgroundColor: whiteOpacity,
                valueColor: const AlwaysStoppedAnimation(Colors.blue),
                borderRadius: 12.0,
                center: Text(
                  "กำลังโหลดข้อมูล ${percent * 100}%",
                  style: GoogleFonts.prompt(
                    textStyle: TextStyle(
                      color: Colors.white,
                      letterSpacing: .5,
                      fontSize: isPhone
                          ? MediaQuery.of(context).size.height * 0.02
                          : MediaQuery.of(context).size.height * 0.025,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/bgNew.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: isLoadingView
            ? const Center(child: CircularProgressIndicator())
            : SafeArea(
                child: Container(
                  margin: isPhone
                      ? const EdgeInsets.all(32)
                      : const EdgeInsets.only(
                          left: 32, right: 32, top: 32, bottom: 32),
                  child: Stack(fit: StackFit.expand, children: [
                    Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'สวัสดี ${name?.trim()}',
                            style: GoogleFonts.prompt(
                              textStyle: TextStyle(
                                color: Colors.white,
                                letterSpacing: .5,
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.03,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        _menuBar(),
                        const SizedBox(
                          height: 15,
                        ),
                        _searchBar(),
                        const SizedBox(
                          height: 5,
                        ),
                        _listCase()
                      ],
                    ),
                  ]),
                ),
              ),
      ),
    );
  }

  Widget _menuBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _menuItem('ดาวน์โหลดคดี', Icons.download_sharp, () async {
          var result = await Navigator.push(context,
              MaterialPageRoute(builder: (context) => const SelectCasePage()));
          if (result != null) {
            asyncCall1();
          }
        }),
        _menuItem('อัปโหลดคดี', Icons.upload_sharp, () async {
          var result = await Navigator.push(context,
              MaterialPageRoute(builder: (context) => const UploadCase()));
          if (result) {
            asyncCall1();
          }
        }),
        _menuItem('รับเเจ้งเหตุ', Icons.assignment, () async {
          var result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const RequestCasePage(
                      caseID: null, isLocal: false, isEdit: false)));
          if (result != null) {
            asyncCall1();
          }
        }),
        _menuItem('ออกจากระบบ', Icons.logout, () async {
          confirmLogout(context);
        }),
      ],
    );
  }

  void confirmLogout(BuildContext context) {
    BlurryDialog alert = BlurryDialog('ยืนยันการออกจากระบบ',
        'ยืนยันการออกจากระบบ ข้อมูลคดีที่กำลังทำอยู่จะถูกลบออกทั้งหมดและต้องทำการดาวน์โหลดใหม่',
        () async {
      // ignore: avoid_function_literals_in_foreach_calls
      data.forEach((element) async {
        await deleteCaseLogout(
                element.fidsid.toString(), element.fidsNo, context)
            .then((value) async {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          await preferences.clear().then((value) {
            Navigator.pop(context);
            Navigator.pushReplacementNamed(context, '/login');
          });
        });
      });
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget _searchBar() {
    return InputFieldWithIcon(
      label: 'ค้นหาคดี',
      prefixIcon: Icons.search,
      obscureText: false,
      isLastField: true,
      onChanged: (value) {
        if (value.isEmpty || value == '') {
          setState(() {
            data = List<FidsCrimeScene>.from(masterData);
          });
          return;
        }

        data.clear();
        for (int i = 0; i < masterData.length; i++) {
          if ('${masterData[i].fidsNo}'.contains('$value'.trim())) {
            data.add(masterData[i]);
          }
        }
        setState(() {});
      },
    );
  }

  Widget _menuItem(String? label, IconData icon, Function onPress) {
    return Expanded(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 5, right: 5),
            alignment: Alignment.center,
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.white.withOpacity(0.5),
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ))),
              child: AspectRatio(
                aspectRatio: isPhone ? 1 / 2 : 1 / 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(icon,
                        color: Colors.white,
                        size: MediaQuery.of(context).size.height * 0.05),
                  ],
                ),
              ),
              onPressed: () {
                onPress();
              },
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          Text(
            label ?? '',
            style: GoogleFonts.prompt(
              textStyle: TextStyle(
                color: Colors.white,
                letterSpacing: 0.5,
                fontSize: MediaQuery.of(context).size.height * 0.02,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _listCase() {
    return Expanded(
        child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              return _caseCard(index);
            }));
  }

  Widget _caseCard(int index) {
    var fireType = data[index].caseCategoryID == 2
        ? data[index].fireTypeID == '1'
            ? '(อาคาร)'
            : '(ยานพาหนะ)'
        : '';

    return Slidable(
      endActionPane: ActionPane(
        extentRatio: 0.3,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            flex: 1,
            onPressed: (BuildContext context) {
              showAlertDialog(
                  context, data[index].fidsNo, '${data[index].fidsid}');
            },
            backgroundColor: Colors.red,
            icon: Icons.delete,
            label: 'ลบ',
          ),
        ],
      ),
      child: Container(
          decoration: BoxDecoration(
              color: textColor, borderRadius: BorderRadius.circular(10.0)),
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
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _rowHeadInCard('FIDS-ID : ${data[index].fidsNo}'),
                        _rowInCard(
                            'เเจ้งเมื่อ : ${data[index].caseIssueDate} ${data[index].caseIssueTime}'),
                        _rowInCard(
                            'ประเภทคดี : ${caseCategoryLabel(data[index].caseCategoryID ?? -1)} $fireType'),
                        data[index].reportNo != null ||
                                data[index].reportNo != ''
                            ? _rowInCard('เลขรายงาน : ${data[index].reportNo}')
                            : _rowInCard('เลขรายงาน : -'),
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
              if (kDebugMode) {
                print(data[index].caseCategoryID);
              }
              if (data[index].caseCategoryID == 3) {
                var result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LifeCase(
                            caseID: data[index].fidsid,
                            caseNo: data[index].fidsNo,
                            isLocal: true)));
                if (result) {
                  asyncCall1();
                }
              } else if (data[index].caseCategoryID == 4) {
                var result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MainMenuBombCase(
                            caseID: data[index].fidsid,
                            caseNo: data[index].fidsNo,
                            isLocal: true)));
                if (result) {
                  asyncCall1();
                }
              } else if (data[index].caseCategoryID == 1) {
                var result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MainMenuAssetCase(
                            caseID: data[index].fidsid,
                            caseNo: data[index].fidsNo,
                            isLocal: true)));
                if (result) {
                  asyncCall1();
                }
              } else if (data[index].caseCategoryID == 5) {
                var result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TrafficMainPage(
                            caseID: data[index].fidsid,
                            caseNo: data[index].fidsNo,
                            isLocal: true)));
                if (result) {
                  asyncCall1();
                }
              } else if (data[index].caseCategoryID == 6) {
                var result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MainMenuWitnessObj(
                            caseID: data[index].fidsid,
                            caseNo: data[index].fidsNo,
                            isLocal: true)));
                if (result) {
                  asyncCall1();
                }
              } else if (data[index].caseCategoryID == 8) {
                var result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MainMenuWitnessPerson(
                            caseID: data[index].fidsid,
                            caseNo: data[index].fidsNo,
                            isLocal: true)));
                if (result) {
                  asyncCall1();
                }
              } else if (data[index].caseCategoryID == 9) {
                var result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MainMenuWitnessCrimeScene(
                            caseID: data[index].fidsid,
                            caseNo: data[index].fidsNo,
                            isLocal: true)));
                if (result) {
                  asyncCall1();
                }
              } else if (data[index].caseCategoryID == 2) {
                var result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MainFireCase(
                            caseID: data[index].fidsid,
                            caseNo: data[index].fidsNo,
                            isLocal: true)));
                if (result) {
                  asyncCall1();
                }
              }
            },
          )),
    );
  }

  showAlertDialog(BuildContext context, String? fidsno, String? fidsId) {
    BlurryDialog alert =
        BlurryDialog('แจ้งเตือน', 'ยืนยันการลบคดี \n$fidsno', () async {
      setState(() {
        isLoading = true;
      });
      await deleteCase(fidsId, fidsno, context);
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> deleteCase(
      String? fidsId, String? fidsNo, BuildContext maincontext) async {
    if (fidsNo == null && fidsNo == '') {
      FidsCrimeScene? fidsCrimeScene =
          await FidsCrimeSceneDao().getFidsCrimeSceneByFidsNo(fidsNo);
      await FidsCrimeSceneDao()
          .deleteFidsCrimeScene(fidsCrimeScene?.fidsid ?? -1)
          .then((value) => Navigator.pushReplacementNamed(context, '/home'));
    } else {
      await http
          .post(Uri.parse(
              'https://crimescene.fids.police.go.th/mobile/api/Crimescene/Update/$fidsNo:1:0'))
          .then((response) async {
        if (response.statusCode == 200) {
          try {
            if (kDebugMode) {
              print(response.body);
              print('=================================');
            }
            await FidsCrimeSceneDao()
                .getFidsCrimeSceneByFidsNo(fidsNo)
                .then((fidsCrimeScene) async {
              await FidsCrimeSceneDao()
                  .deleteFidsCrimeScene(fidsCrimeScene?.fidsid ?? -1)
                  .then((value) =>
                      Navigator.pushReplacementNamed(context, '/home'));
            });
          } catch (ex) {
            if (kDebugMode) {
              _displaySnackBar(maincontext);
              print('vvvv ${ex.toString()}');
            }
          }
        }
      });
    }
  }

  Future<http.Response?> deleteCaseLogout(
      String? fidsId, String? fidsNo, BuildContext maincontext) async {
    if (fidsNo == null && fidsNo == '') {
      FidsCrimeScene? fidsCrimeScene =
          await FidsCrimeSceneDao().getFidsCrimeSceneByFidsNo(fidsNo);
      await FidsCrimeSceneDao()
          .deleteFidsCrimeScene(fidsCrimeScene?.fidsid ?? -1)
          .then((value) => Navigator.pushReplacementNamed(context, '/home'));
    } else {
      final response = await http.post(Uri.parse(
          'https://crimescene.fids.police.go.th/mobile/api/Crimescene/Update/$fidsNo:1:0'));
      if (response.statusCode == 200) {
        try {
          if (kDebugMode) {
            print(response.body);
          }
          FidsCrimeScene? fidsCrimeScene =
              await FidsCrimeSceneDao().getFidsCrimeSceneByFidsNo(fidsNo);
          await FidsCrimeSceneDao()
              .deleteFidsCrimeScene(fidsCrimeScene?.fidsid ?? -1)
              .then(
                  (value) => Navigator.pushReplacementNamed(context, '/home'));
        } catch (ex) {
          if (kDebugMode) {
            print('vvvv ${ex.toString()}');
          }
          // _displaySnackBar(maincontext);
        }
      } else {
        if (kDebugMode) {
          print('ลบคดีไม่สำเร็จ');
        }
        // _displaySnackBar(maincontext);
        throw Exception('ลบคดีไม่สำเร็จ');
      }
    }
    return null;
  }

  _displaySnackBar(BuildContext context) {
    const snackBar = SnackBar(content: Text('ลบคดีไม่สำเร็จ'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
                fontSize: MediaQuery.of(context).size.height * 0.02,
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

  Widget showLogo() {
    return Image.asset(
      "images/logo.png",
      // height: MediaQuery.of(context).size.height * 0.1,
      width: MediaQuery.of(context).size.width * 0.15,
      fit: BoxFit.contain,
    );
  }

  updateLookUp() async {
    await loadCaseCategory();
    setState(() {
      percent = 0.06;
    });
    await loadSubCaseCategory();
    setState(() {
      percent = 0.12;
    });
    await loadProvince();
    setState(() {
      percent = 0.18;
    });
    await loadAmphur();
    setState(() {
      percent = 0.24;
    });
    await loadTambol();
    setState(() {
      percent = 0.30;
    });
    await loadPoliceStation();
    setState(() {
      percent = 0.36;
    });
    await loadTitle();
    setState(() {
      percent = 0.42;
    });
    await loadCareer();
    setState(() {
      percent = 0.48;
    });
    await loadPersonal();

    setState(() {
      percent = 0.54;
    });
    await loadUnit();
    setState(() {
      percent = 0.60;
    });
    await loadDepartment();
    setState(() {
      percent = 0.66;
    });
    await loadEvidentType();
    setState(() {
      percent = 0.72;
    });
    await loadSceneType();
    setState(() {
      percent = 0.78;
    });

    await loadVehicleBrand();
    await loadVehicleColor();
    await loadVehicleSide();
    await loadVehicleType();
    await loadWorkgroup();
    setState(() {
      percent = 0.84;
    });
    await loadRelatedPersonType();
    setState(() {
      percent = 0.90;
    });
    await loadPosition();
    setState(() {
      percent = 0.93;
    });
    await loadPackage();
    setState(() {
      percent = 0.96;
    });

    await loadEvidenceCheck();
    await loadEvidenceGroup();
    setState(() {
      percent = 0.98;
    });

    loadBodyTypeCard();
    setState(() {
      percent = 0.97;
    });
    loadBodyPosition();
    setState(() {
      percent = 0.99;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLookup', true);
  }

  loadEvidenceCheck() async {
    String? eg = await DefaultAssetBundle.of(context)
        .loadString("json/evidenceCheck.json");
    await EvidenceCheckDao().insertEvidenceCheck(eg);
  }

  loadEvidenceGroup() async {
    String? eg = await DefaultAssetBundle.of(context)
        .loadString("json/evidenceGroup.json");
    await EvidenceGroupDao().insertEvidenceGroup(eg);
  }

  loadBodyTypeCard() async {
    String? bs =
        await DefaultAssetBundle.of(context).loadString("json/typeCard.json");
    await TypeCardDao().insertTypeCard(bs);
  }

  loadBodyPosition() async {
    String? bs = await DefaultAssetBundle.of(context)
        .loadString("json/bodyPosition.json");
    await BodyPositionDao().insertBodyPosition(bs);
  }

  loadWorkgroup() async {
    String? wg =
        await DefaultAssetBundle.of(context).loadString("json/workgroup.json");
    await WorkGroupDao().insertWorkGroup(wg);
  }

  loadRelatedPersonType() async {
    String? rlpt = await DefaultAssetBundle.of(context)
        .loadString("json/relatedPersonType.json");
    await RelatedPersonTypeDao().insertRelatedPersonType(rlpt);
  }

  loadPosition() async {
    String? pt =
        await DefaultAssetBundle.of(context).loadString("json/position.json");
    await PositionDao().insertPosition(pt);
  }

  loadPackage() async {
    String? pk =
        await DefaultAssetBundle.of(context).loadString("json/mypackage.json");
    await PackageDao().insertPackage(pk);
  }

  loadSceneType() async {
    String? et =
        await DefaultAssetBundle.of(context).loadString("json/sceneType.json");
    BuildingDao().insertBuildingSharedPref(et);
  }

  loadEvidentType() async {
    String? et = await DefaultAssetBundle.of(context)
        .loadString("json/evidentType.json");
    EvidentypeDao().insertEvidentType(et);
  }

  loadCaseCategory() async {
    String? tb = await DefaultAssetBundle.of(context)
        .loadString("json/caseCategory.json");
    await CaseCategoryDAO().insertCaseCategorySharedPref(tb);
  }

  loadAmphur() async {
    String? ap =
        await DefaultAssetBundle.of(context).loadString("json/amphur.json");
    await AmphurDao().insertAmphurSharedPref(ap);
  }

  loadTambol() async {
    String? tb =
        await DefaultAssetBundle.of(context).loadString("json/tambol.json");
    await TambolDao().insertTambolSharedPref(tb);
  }

  loadSubCaseCategory() async {
    String? scc = await DefaultAssetBundle.of(context)
        .loadString("json/subCaseCategory.json");
    await SubCaseCategoryDao().insertSubCaseCategorySharedPref(scc);
  }

  loadProvince() async {
    String? p =
        await DefaultAssetBundle.of(context).loadString("json/province.json");
    await ProvinceDao().insertProvince(p);
  }

  loadPoliceStation() async {
    String? ps = await DefaultAssetBundle.of(context)
        .loadString("json/policeStation.json");
    await PoliceStationDao().insertPoliceStation(ps);
  }

  loadCareer() async {
    String? cr =
        await DefaultAssetBundle.of(context).loadString("json/career.json");
    await CareerDao().insertCareer(cr);
  }

  loadTitle() async {
    String? tt =
        await DefaultAssetBundle.of(context).loadString("json/title.json");
    await TitleDao().insertTitle(tt);
  }

  loadPersonal() async {
    String? psn =
        await DefaultAssetBundle.of(context).loadString("json/personal.json");
    await PersonalDao().insertPersonalSharedPref(psn);
  }

  loadDepartment() async {
    String? dpm =
        await DefaultAssetBundle.of(context).loadString("json/department.json");
    await DepartmentDao().insertDepartment(dpm);
  }

  loadUnit() async {
    String? unit =
        await DefaultAssetBundle.of(context).loadString("json/unit.json");
    await UnitDao().insertUnit(unit);
  }

  loadVehicleBrand() async {
    String? vehicleBrands = await DefaultAssetBundle.of(context)
        .loadString("json/vehicleBrand.json");
    await VehicleBrandDao().insertVehicleBrand(vehicleBrands);
  }

  loadVehicleSide() async {
    String? vehicleSides = await DefaultAssetBundle.of(context)
        .loadString("json/vehicleSide.json");
    await VehicleSideDao().insertVehicleSide(vehicleSides);
  }

  loadVehicleType() async {
    String? vehicleTypes = await DefaultAssetBundle.of(context)
        .loadString("json/vehicleType.json");
    await VehicleTypeDao().insertVehicleType(vehicleTypes);
  }

  loadVehicleColor() async {
    String? vehicleColors = await DefaultAssetBundle.of(context)
        .loadString("json/vehicleColor.json");
    await VehicleColorDao().insertVehicleColor(vehicleColors);
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
}
