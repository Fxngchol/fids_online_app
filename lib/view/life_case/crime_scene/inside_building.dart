import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/color.dart';
import '../../../models/Building.dart';
import '../../../models/CaseInternal.dart';
import '../../../models/CaseSceneLocation.dart';
import '../../../models/FidsCrimeScene.dart';
import '../../../models/UnitMeter.dart';
import '../../../widget/blurry_dialog.dart';
import '../../../widget/textfield_modal_bottom_sheet.dart';
import 'inside_building_tab/add_inside_building_tab.dart';
import 'inside_building_tab/add_outside_building_tab.dart';
import 'inside_building_tab/add_scene_location_tab.dart';
import 'inside_building_tab/location_scene_detail.dart';

class InsideBuilding extends StatefulWidget {
  final int? caseID;
  final String? caseNo;
  final bool isLocal;

  const InsideBuilding(
      {super.key, this.caseID, this.caseNo, this.isLocal = false});

  @override
  InsideBuildingState createState() => InsideBuildingState();
}

class InsideBuildingState extends State<InsideBuilding>
    with SingleTickerProviderStateMixin {
  late TabController controller;

  List buildingTypeList = [];
  late List<Building> buildingTypes = [];

  bool isPhone = Device.get().isPhone;
  int _handleFenceValue = 0;

  FidsCrimeScene? fidsCrimeScene;
  bool isLoading = true;

  List<CaseInternal> caseInternals = [];
  List<CaseSceneLocation> caseSceneLocations = [];
  List<UnitMeter> unitMeter = [
    UnitMeter(id: 1, unitLabel: 'เมตร'),
    UnitMeter(id: 2, unitLabel: 'เซนติเมตร')
  ];

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 3, vsync: this);
    asyncMethod();
  }

  asyncMethod() async {
    asyncCall1();
    asyncCall2();
    asyncCall3();
  }

  void asyncCall1() async {
    var result =
        await FidsCrimeSceneDao().getFidsCrimeSceneById(widget.caseID ?? -1);
    var result2 = await BuildingDao().getBuilding();
    var result3 = await BuildingDao().getBuildingLabel();
    setState(() {
      fidsCrimeScene = result;
      buildingTypes = result2;
      buildingTypeList = result3;

      if (fidsCrimeScene?.isFence == 1) {
        _handleFenceValue = 1;
      } else if (fidsCrimeScene?.isFence == 2) {
        _handleFenceValue = 2;
      }
    });
  }

  void asyncCall2() async {
    var result = await CaseInternalDao().getCaseInternal(widget.caseID ?? -1);
    setState(() {
      caseInternals = result;
    });
  }

  void asyncCall3() async {
    var result =
        await CaseSceneLocationDao().getCaseSceneLocation(widget.caseID ?? -1);
    setState(() {
      caseSceneLocations = result;
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
              'กรณีเกิดเหตุภายในอาคาร',
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
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
          actions: [
            Container(
              width: MediaQuery.of(context).size.width * 0.1,
            )
          ],
          bottom: TabBar(
            indicatorColor: pinkButton,
            indicatorWeight: 6,
            labelColor: const Color(0xffffffff), // สีของข้อความปุ่มที่เลือก
            unselectedLabelColor:
                const Color(0x55ffffff), // สีของข้อความปุ่มที่ไม่ได้เลือก
            tabs: <Tab>[
              Tab(
                // icon: Icon(Icons.domain, color: Colors.white),
                child: Text(
                  'ลักษณะภายนอก',
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
                  'ลักษณะภายใน',
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
                  'สถานที่เกิดเหตุ',
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
              // Tab(
              //   // icon: Icon(Icons.account_tree, color: Colors.white),
              //   child: Text(
              //     'โครงสร้าง',
              //     textAlign: TextAlign.center,
              //     style: GoogleFonts.prompt(
              //       textStyle: TextStyle(
              //         color: Colors.white,
              //         fontSize: isPhone
              //             ? MediaQuery.of(context).size.height * 0.01
              //             : MediaQuery.of(context).size.height * 0.02,
              //       ),
              //     ),
              //   ),
              // ),
            ],
            controller: controller,
          ),
        ),
        body: TabBarView(
          controller: controller,
          children: <Widget>[
            firstPage(),
            secondPage(),
            thirdPage(),
            // fourthPage()
          ],
        ));
  }

  Widget firstPage() {
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
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  title('ลักษณะภายนอก'),
                  TextButton(
                    child: Row(
                      children: [
                        Icon(
                          Icons.edit,
                          size: MediaQuery.of(context).size.height * 0.03,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    onPressed: () async {
                      var result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddOutsideBuilding(
                                  caseID: widget.caseID ?? -1,
                                  caseNo: widget.caseNo,
                                  isLocal: widget.isLocal)));

                      if (result) {
                        asyncCall1();
                      }
                    },
                  ),
                ],
              ),
              spacerTitle(),
              subtitle('ลักษณะ'),
              spacer(),
              detailView(
                  '${buildingTypeLabel(fidsCrimeScene?.buildingTypeId ?? -1)}'),
              spacerTitle(),
              fidsCrimeScene?.buildingTypeId == 0
                  ? subtitle('ลักษณะอื่นๆ')
                  : Container(),
              fidsCrimeScene?.buildingTypeId == 0 ? spacer() : Container(),
              fidsCrimeScene?.buildingTypeId == 0
                  ? detailView(
                      '${_cleanText(fidsCrimeScene?.buildingTypeOther)}')
                  : Container(),
              fidsCrimeScene?.buildingTypeId == 0 ? spacerTitle() : Container(),
              subtitle('รายละเอียด'),
              spacer(),
              detailView('${_cleanText(fidsCrimeScene?.isoBuildingDetail)}'),
              spacerTitle(),
              subtitle('จำนวนชั้น'),
              spacer(),
              detailView('${_cleanText(fidsCrimeScene?.floor)}'),
              spacerTitle(),
              title('สภาพบริเวณโดยรอบ'),
              spacer(),
              frenchView(),
              spacerTitle(),
              title('เมื่อหันหน้าเข้าที่เกิดเหตุ'),
              spacerTitle(),
              subtitle('ด้านหน้าติด'),
              spacer(),
              detailView('${_cleanText(fidsCrimeScene?.sceneFront)}'),
              spacerTitle(),
              subtitle('ด้านซ้ายติด'),
              spacer(),
              detailView('${_cleanText(fidsCrimeScene?.sceneLeft)}'),
              spacerTitle(),
              subtitle('ด้านขวาติด'),
              spacer(),
              detailView('${_cleanText(fidsCrimeScene?.sceneRight)}'),
              spacerTitle(),
              subtitle('ด้านหลังติด'),
              spacer(),
              detailView('${_cleanText(fidsCrimeScene?.sceneBack)}'),
              spacerTitle(),
            ],
          ),
        ),
      ),
    );
  }

  Widget secondPage() {
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
          child: Stack(
            children: [
              spacerTitle(),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        title('รายการลักษณะภายใน'),
                        TextButton(
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
                                        MediaQuery.of(context).size.height *
                                            0.03,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          onPressed: () async {
                            var result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddInsideBuilding(
                                        caseID: widget.caseID ?? -1,
                                        caseNo: widget.caseNo,
                                        isLocal: widget.isLocal,
                                        isEdit: false)));

                            if (result) {
                              asyncCall2();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: caseInternals.length,
                        itemBuilder: (BuildContext ctxt, int index) {
                          return _listInsideItem(index);
                        }),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _listInsideItem(index) {
    return Slidable(
      endActionPane: ActionPane(
        extentRatio: 0.3,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            flex: 1,
            onPressed: (BuildContext context) {
              confirmRemove(context, index, true);
            },
            backgroundColor: Colors.red,
            icon: Icons.delete,
            label: 'ลบ',
          ),
        ],
      ),
      child: TextButton(
        onPressed: () async {
          var result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddInsideBuilding(
                      caseID: widget.caseID ?? -1,
                      caseNo: widget.caseNo,
                      isLocal: widget.isLocal,
                      isEdit: true,
                      insideID: caseInternals[index].id)));
          if (result) {
            asyncMethod();
          }
        },
        child: Container(
          padding:
              const EdgeInsets.only(left: 20, right: 20, bottom: 12, top: 12),
          margin: const EdgeInsets.only(top: 6, bottom: 6),
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'ชั้น ${caseInternals[index].floorNo}',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.prompt(
                              textStyle: TextStyle(
                                color: textColor,
                                letterSpacing: .5,
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.025,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              '${caseInternals[index].floorDetail}',
                              textAlign: TextAlign.left,
                              style: GoogleFonts.prompt(
                                textStyle: TextStyle(
                                  color: textColor,
                                  letterSpacing: .5,
                                  fontSize:
                                      MediaQuery.of(context).size.height * 0.02,
                                ),
                              ),
                              maxLines: null,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget thirdPage() {
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
          child: Stack(
            children: [
              spacerTitle(),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      title('รายการสถานที่เกิดเหตุ'),
                      TextButton(
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
                        onPressed: () async {
                          var result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddSceneLocation(
                                      caseID: widget.caseID ?? -1,
                                      caseNo: widget.caseNo,
                                      isEdit: false,
                                      isLocal: widget.isLocal)));

                          if (result) {
                            asyncCall3();
                          }
                        },
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: caseSceneLocations.length,
                        itemBuilder: (BuildContext context, int index) {
                          return _listLocationSceneItem(index);
                        }),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _listLocationSceneItem(index) {
    return Slidable(
      endActionPane: ActionPane(
        extentRatio: 0.3,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            flex: 1,
            onPressed: (BuildContext context) {
              confirmRemove(context, index, true);
            },
            backgroundColor: Colors.red,
            icon: Icons.delete,
            label: 'ลบ',
          ),
        ],
      ),
      child: TextButton(
        onPressed: () async {
          var result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => LocationSceneDetail(
                        caseSceneLocationId:
                            int.parse(caseSceneLocations[index].id ?? ''),
                        caseID: widget.caseID ?? -1,
                        caseNo: widget.caseNo,
                      )));
          if (result) {
            asyncCall3();
          }
        },
        child: Container(
          padding:
              const EdgeInsets.only(left: 24, right: 24, bottom: 12, top: 12),
          margin: const EdgeInsets.only(top: 6, bottom: 6),
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              '${caseSceneLocations[index].sceneLocation}',
                              textAlign: TextAlign.left,
                              style: GoogleFonts.prompt(
                                textStyle: TextStyle(
                                  color: textColor,
                                  letterSpacing: .5,
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.025,
                                ),
                              ),
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'กว้างxยาว ${caseSceneLocations[index].sceneLocationSize} ${caseSceneLocations[index].unitId == '1' ? 'เมตร' : 'เซนติเมตร'}',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.prompt(
                              textStyle: TextStyle(
                                color: textColor,
                                letterSpacing: .5,
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.02,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: textColor,
                size: MediaQuery.of(context).size.height * 0.02,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget fourthPage() {
    return Container(
      color: darkBlue,
      child: SafeArea(
        child: Container(
          margin: isPhone
              ? const EdgeInsets.all(32)
              : const EdgeInsets.only(left: 32, right: 32, top: 32, bottom: 32),
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  title('ลักษณะโครงสร้าง'),
                  TextButton(
                    child: Row(
                      children: [
                        Icon(
                          Icons.edit,
                          size: MediaQuery.of(context).size.height * 0.025,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'แก้ไข',
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
                    onPressed: () {
                      Navigator.pushNamed(context, '/addstructure');
                    },
                  ),
                ],
              ),
              spacerTitle(),
              subtitle('ลักษณะ'),
              spacer(),
              detailView('บ้านคอนกรีต'),
              spacerTitle(),
              subtitle('ผนัง'),
              spacer(),
              detailView('ผนังปูน'),
              spacerTitle(),
              subtitle('ด้านหน้า'),
              spacer(),
              detailView('ถนนหน้าหมู่บ้าน'),
              spacerTitle(),
              subtitle('ด้านซ้าย'),
              spacer(),
              detailView('บ้านพักอาศัย'),
              spacerTitle(),
              subtitle('ด้านขวา'),
              spacer(),
              detailView('ลานจอดรถ'),
              spacerTitle(),
              subtitle('ด้านหลัง'),
              spacer(),
              detailView('ที่โล่ง'),
              spacerTitle(),
              subtitle('พื้นห้อง'),
              spacer(),
              detailView('กระเบื้อง'),
              spacerTitle(),
              subtitle('หลังคา'),
              spacer(),
              detailView('ฝ้าปิด'),
              spacerTitle(),
              subtitle('ลักษณะการจัดวางสิ่งของ'),
              spacer(),
              detailView('เตียงนอนชิดผนังด้านซ้าย'),
            ],
          ),
        ),
      ),
    );
  }

  // void _handleFenceValueChange(int value) {
  //   setState(() {
  //     _handleFenceValue = value;
  //     switch (_handleFenceValue) {
  //       case 1:
  //         break;
  //       case 2:
  //         break;
  //     }
  //   });
  // }

  spacer() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.01,
    );
  }

  spacerTitle() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.015,
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
              fontSize: MediaQuery.of(context).size.height * 0.03,
            ),
          ),
        ),
      ],
    );
  }

  Widget subtitle(String? title) {
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

  detailView(String? text) {
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
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomSheetWidget(TextEditingController controller, String? hint,
      String? title, List items, int indexSelected) {
    return TextFieldModalBottomSheet(
      controller: controller,
      hint: '$hint',
      onPress: () => {
        FocusScope.of(context).unfocus(),
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
                color: Colors.transparent,
                child: SizedBox(
                  height: MediaQuery.of(context).copyWith().size.height / 3,
                  child: Scaffold(
                    appBar: AppBar(
                      backgroundColor: Colors.white,
                      bottomOpacity: 0.3,
                      elevation: 0.5,
                      automaticallyImplyLeading: false,
                      titleSpacing: 0.0,
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          MaterialButton(
                            child: Text('ยกเลิก',
                                style: GoogleFonts.prompt(
                                    textStyle: TextStyle(
                                  color: darkBlue,
                                  letterSpacing: 0.5,
                                  fontSize:
                                      MediaQuery.of(context).size.height * 0.02,
                                ))),
                            onPressed: () {
                              if (controller.text == '') {
                                controller.clear();
                                indexSelected = 0;
                              }
                              Navigator.pop(context);
                            },
                          ),
                          Text('$title',
                              style: GoogleFonts.prompt(
                                  textStyle: TextStyle(
                                color: darkBlue,
                                letterSpacing: 0.5,
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.025,
                              ))),
                          MaterialButton(
                              child: Text('เลือก',
                                  style: GoogleFonts.prompt(
                                      textStyle: TextStyle(
                                    color: darkBlue,
                                    letterSpacing: 0.5,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.02,
                                  ))),
                              onPressed: () {
                                Navigator.pop(context);
                                setState(() {
                                  controller.text = items[indexSelected];
                                });
                              }),
                        ],
                      ),
                    ),
                    body: CupertinoPicker(
                        squeeze: 1.5,
                        diameterRatio: 1,
                        useMagnifier: true,
                        looping: false,
                        scrollController: FixedExtentScrollController(
                          initialItem: indexSelected,
                        ),
                        itemExtent: isPhone ? 40.0 : 50.0,
                        backgroundColor: Colors.white,
                        onSelectedItemChanged: (int index) => setState(() {
                              indexSelected = index;
                            }),
                        children:
                            List<Widget>.generate(items.length, (int index) {
                          return Center(
                            child: Text(
                              items[index],
                              style: GoogleFonts.prompt(
                                textStyle: TextStyle(
                                  color: darkBlue,
                                  letterSpacing: 0.5,
                                  fontSize:
                                      MediaQuery.of(context).size.height * 0.02,
                                ),
                              ),
                            ),
                          );
                        })),
                  ),
                ));
          },
        )
      },
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
                groupValue: _handleFenceValue,
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
                groupValue: _handleFenceValue,
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

  String? _cleanText(String? text) {
    try {
      if (text == null || text == '' || text == 'null') {
        return '';
      }
      return text;
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

  String? unitLabel(String? id) {
    if (id == null) {
      return '';
    } else {
      for (int i = 0; i < unitMeter.length; i++) {
        if (id == '${unitMeter[i].id}') {
          return unitMeter[i].unitLabel;
        }
      }
    }
    return '';
  }

  confirmRemove(BuildContext context, int index, bool isInside) {
    BlurryDialog alert = BlurryDialog('แจ้งเตือน', 'ยืนยันการลบ', () async {
      if (isInside) {
        await CaseInternalDao()
            .deleteById(caseInternals[index].id ?? '')
            .then((value) {
          asyncMethod();
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
      } else {
        await CaseSceneLocationDao()
            .deleteById(caseSceneLocations[index].id ?? '')
            .then((value) {
          asyncMethod();
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
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
