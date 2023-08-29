import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/color.dart';
import '../../../models/Building.dart';
import '../../../models/CaseInternal.dart';
import '../../../models/CaseSceneLocation.dart';
import '../../../models/FidsCrimeScene.dart';
import '../../../widget/blurry_dialog.dart';
import 'edit_crime_scene_asset_first_tab.dart';
import 'edit_crime_scene_asset_second_tab.dart';
import 'edit_crime_scene_asset_third_tab.dart';

class CrimesceneAssetAlltab extends StatefulWidget {
  final int? caseID;
  final String? caseNo;
  final bool isLocal;
  final bool isEdit;

  const CrimesceneAssetAlltab(
      {super.key,
      this.caseID,
      this.caseNo,
      this.isLocal = false,
      this.isEdit = false});
  @override
  CrimesceneAssetAlltabState createState() => CrimesceneAssetAlltabState();
}

class CrimesceneAssetAlltabState extends State<CrimesceneAssetAlltab>
    with SingleTickerProviderStateMixin {
  bool isLoading = true;
  bool isPhone = Device.get().isPhone;
  String? caseName;
  FidsCrimeScene fidsCrimeScene = FidsCrimeScene();
  List<Building> buildingTypes = [];
  List<CaseInternal> caseInternals = [];
  List<CaseSceneLocation> caseSceneLocations = [];

  late TabController controller;

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      print(widget.isEdit);
    }
    controller = TabController(length: 3, vsync: this);
    asyncMethod();
  }

  asyncMethod() async {
    // if  (widget.isEdit) {
    asyncCall1();

    // }
  }

  void asyncCall1() async {
    //get buildingType List
    var buildingTypeList = await BuildingDao().getBuilding();
    buildingTypes = buildingTypeList;

    await FidsCrimeSceneDao()
        .getFidsCrimeSceneById(widget.caseID ?? -1)
        .then((value) async {
      fidsCrimeScene = value ?? FidsCrimeScene();
    });
    await CaseInternalDao().getCaseInternal(widget.caseID ?? -1);
    var result = await CaseInternalDao().getCaseInternal(widget.caseID ?? -1);
    setState(() {
      caseInternals = result;
    });
    if (kDebugMode) {
      print(caseInternals);
    }
    await CaseSceneLocationDao()
        .getCaseSceneLocation(widget.caseID ?? -1)
        .then((value) {
      caseSceneLocations = value;
    });
    setState(() {
      isLoading = false;
    });
  }

  // void asyncCall2() async {}

  // void asyncCall3() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Container(
            alignment: Alignment.center,
            child: Text(
              'สภาพสถานที่เกิดเหตุเมื่อไปถึง',
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
          actions: [
            Container(
              width: 50,
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
                  'ลักษณะที่เกิดเหตุ',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.prompt(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: isPhone
                          ? MediaQuery.of(context).size.height * 0.01
                          : MediaQuery.of(context).size.height * 0.022,
                    ),
                  ),
                ),
              ),
              Tab(
                // icon: Icon(Icons.pin_drop, color: Colors.white),
                child: Text(
                  'ลักษณะภายใน',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.prompt(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: isPhone
                          ? MediaQuery.of(context).size.height * 0.01
                          : MediaQuery.of(context).size.height * 0.022,
                    ),
                  ),
                ),
              ),
              Tab(
                // icon: Icon(Icons.account_tree, color: Colors.white),
                child: Text(
                  'บริเวณที่เกิดเหตุ',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.prompt(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: isPhone
                          ? MediaQuery.of(context).size.height * 0.01
                          : MediaQuery.of(context).size.height * 0.022,
                    ),
                  ),
                ),
              ),
            ],
            controller: controller,
          ),
        ),
        body: isLoading
            ? Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("images/bgNew.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: const Center(child: CircularProgressIndicator()))
            : TabBarView(
                controller: controller,
                children: <Widget>[
                  _firstTab(),
                  _secondTab(),
                  _thirdTab(),
                ],
              ));
  }

  Widget _firstTab() {
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
            child: SingleChildScrollView(
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [header('การรักษาสถานที่เกิดเหตุ'), firstTabEdit()],
                ),
                spacer(),
                sceneProtectionView(),
                spacer(),
                detailView(
                    _cleanText(fidsCrimeScene.sceneProtectionDetails ?? '')),
                spacer(),
                header('ลักษณะที่เกิดเหตุ'),
                spacer(),
                title('ลักษณะภายนอก'),
                spacer(),
                detailView(_cleanText(fidsCrimeScene.buildingTypeId != null
                    ? buildingTypeLabel(fidsCrimeScene.buildingTypeId ?? -1)
                    : '')),
                spacer(),
                fidsCrimeScene.buildingTypeId == 0
                    ? detailView(_cleanText(fidsCrimeScene.buildingTypeOther))
                    : Container(),
                title('รายละเอียด'),
                spacer(),
                detailView(_cleanText(fidsCrimeScene.isoBuildingDetail ?? '')),
                spacer(),
                title('จำนวนชั้น'),
                spacer(),
                detailView(_cleanText(fidsCrimeScene.floor ?? '')),
                spacer(),
                title('สภาพบริเวณโดยรอบ'),
                spacer(),
                frenchView(),
                spacer(),
                title('ด้านหน้าติด'),
                spacer(),
                detailView(_cleanText(fidsCrimeScene.sceneFront ?? '')),
                spacer(),
                title('ด้านซ้ายติด'),
                spacer(),
                detailView(_cleanText(fidsCrimeScene.sceneLeft ?? '')),
                spacer(),
                title('ด้านขวาติด'),
                spacer(),
                detailView(_cleanText(fidsCrimeScene.sceneRight ?? '')),
                spacer(),
                title('ด้านหลังติด'),
                spacer(),
                detailView(_cleanText(fidsCrimeScene.sceneBack ?? '')),
                spacer(),
              ]),
            )),
      ),
    );
  }

  Widget _secondTab() {
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
              spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  header('รายการลักษณะภายใน'),
                  TextButton(
                    onPressed: () async {
                      var result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditCrimeSceneSecondTab(
                                  caseID: widget.caseID ?? -1, isEdit: false)));
                      if (result != null) {
                        setState(() {
                          asyncCall1();
                        });
                      }
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.add,
                          size: MediaQuery.of(context).size.height * 0.03,
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
                                  MediaQuery.of(context).size.height * 0.03,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: caseInternals.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Slidable(
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              flex: 1,
                              onPressed: (BuildContext context) {
                                confirmRemoveInternal(context, index);
                              },
                              backgroundColor: Colors.red,
                              icon: Icons.delete,
                              label: 'ลบ',
                            ),
                          ],
                        ),
                        child: GestureDetector(
                          onTap: () async {
                            var result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        EditCrimeSceneSecondTab(
                                          caseID: widget.caseID ?? -1,
                                          isEdit: true,
                                          caseInternal: caseInternals[index],
                                        )));
                            if (result != null) {
                              setState(() {
                                asyncCall1();
                              });
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                const SizedBox(width: 10),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 24.0,
                                    top: 12,
                                  ),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: Text(
                                      'ชั้น ${caseInternals[index].floorNo}',
                                      textAlign: TextAlign.start,
                                      style: GoogleFonts.prompt(
                                        textStyle: TextStyle(
                                          color: textColor,
                                          letterSpacing: .5,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.025,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 24.0, bottom: 12),
                                  child: Text(
                                    '${caseInternals[index].floorDetail}',
                                    textAlign: TextAlign.start,
                                    maxLines: null,
                                    style: GoogleFonts.prompt(
                                      textStyle: TextStyle(
                                        color: textColor,
                                        letterSpacing: .5,
                                        fontSize:
                                            MediaQuery.of(context).size.height *
                                                0.020,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ])),
      ),
    );
  }

  Widget _thirdTab() {
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
              spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  header('รายการบริเวณที่เกิดเหตุ'),
                  TextButton(
                    onPressed: () async {
                      var result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditCrimeSceneThirdTab(
                                  caseID: widget.caseID ?? -1, isEdit: false)));
                      if (result != null) {
                        setState(() {
                          asyncCall1();
                        });
                      }
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.add,
                          size: MediaQuery.of(context).size.height * 0.03,
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
                                  MediaQuery.of(context).size.height * 0.03,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: caseSceneLocations.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Slidable(
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              flex: 1,
                              onPressed: (BuildContext context) {
                                confirmRemoveSceneLocation(context, index);
                              },
                              backgroundColor: Colors.red,
                              icon: Icons.delete,
                              label: 'ลบ',
                            ),
                          ],
                        ),
                        child: GestureDetector(
                          onTap: () async {
                            var result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        EditCrimeSceneThirdTab(
                                            caseID: widget.caseID ?? -1,
                                            isEdit: true,
                                            caseSceneLocation:
                                                caseSceneLocations[index])));
                            if (result != null) {
                              setState(() {
                                asyncCall1();
                              });
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12.0, bottom: 12, top: 12),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: Text(
                                      '${caseSceneLocations[index].sceneLocation}',
                                      textAlign: TextAlign.left,
                                      style: GoogleFonts.prompt(
                                        textStyle: TextStyle(
                                          color: textColor,
                                          letterSpacing: .5,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.020,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ])),
      ),
    );
  }

  firstTabEdit() {
    return TextButton(
        onPressed: () async {
          var result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditCrimeSceneFirstTab(
                        caseID: widget.caseID ?? -1,
                        isEdit: fidsCrimeScene.isSceneProtection != null ||
                                fidsCrimeScene.isSceneProtection != -1
                            ? true
                            : false,
                      )));
          if (result != null) {
            setState(() {
              asyncCall1();
            });
          }
        },
        child: Row(
          children: [
            Icon(
              Icons.edit,
              color: Colors.white,
              size: MediaQuery.of(context).size.height * 0.025,
            ),
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
        ));
  }

  void confirmRemoveInternal(BuildContext context, int index) {
    BlurryDialog alert = BlurryDialog('แจ้งเตือน', 'ยืนยันการลบ', () async {
      CaseInternalDao().deleteById(caseInternals[index].id ?? '');
      caseInternals.removeAt(index);
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

  void confirmRemoveSceneLocation(BuildContext context, int index) {
    BlurryDialog alert = BlurryDialog('แจ้งเตือน', 'ยืนยันการลบ', () async {
      CaseSceneLocationDao().deleteById(caseSceneLocations[index].id ?? '');
      caseSceneLocations.removeAt(index);
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

  spacer() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.01,
    );
  }

  Widget header(String? title) {
    return Row(
      children: [
        Text(
          title ?? '',
          style: GoogleFonts.prompt(
            textStyle: TextStyle(
              color: Colors.white,
              letterSpacing: 0.5,
              fontSize: MediaQuery.of(context).size.height * 0.03,
            ),
          ),
        ),
      ],
    );
  }

  Widget title(String? title) {
    return Row(
      children: [
        Text(
          title ?? '',
          style: GoogleFonts.prompt(
            textStyle: TextStyle(
              color: Colors.white,
              letterSpacing: 0.5,
              fontSize: MediaQuery.of(context).size.height * 0.025,
            ),
          ),
        ),
      ],
    );
  }

  sceneProtectionView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Transform.scale(
              scale: 1.2,
              child: Radio(
                value: 1,
                activeColor: pinkButton,
                groupValue: fidsCrimeScene.isSceneProtection == null ||
                        fidsCrimeScene.isSceneProtection == -1
                    ? -1
                    : fidsCrimeScene.isSceneProtection,
                onChanged: (_) {},
              ),
            ),
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Transform.scale(
              scale: 1.2,
              child: Radio(
                value: 2,
                activeColor: pinkButton,
                groupValue: fidsCrimeScene.isSceneProtection == null ||
                        fidsCrimeScene.isSceneProtection == -1
                    ? -1
                    : fidsCrimeScene.isSceneProtection,
                onChanged: (_) {},
              ),
            ),
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
    );
  }

  frenchView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Transform.scale(
              scale: 1.2,
              child: Radio(
                value: 1,
                activeColor: pinkButton,
                groupValue: fidsCrimeScene.isFence,
                onChanged: (_) {},
              ),
            ),
            Text(
              'มีรั้ว',
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Transform.scale(
              scale: 1.2,
              child: Radio(
                value: 2,
                activeColor: pinkButton,
                groupValue: fidsCrimeScene.isFence,
                onChanged: (_) {},
              ),
            ),
            Text(
              'ไม่มีรั้ว',
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
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _cleanText(String? text) {
    try {
      if (text == null || text == '' || text == 'null' || text == '-1') {
        return '';
      } else {
        return text;
      }
    } catch (ex) {
      return '';
    }
  }

  String? buildingTypeLabel(int id) {
    if (id == -1) {
      return '';
    } else {
      for (int i = 0; i < buildingTypes.length; i++) {
        if ('$id' == '${buildingTypes[i].id}') {
          return buildingTypes[i].name;
        }
      }
    }
    return '';
  }
}
