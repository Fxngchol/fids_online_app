import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/color.dart';
import '../../../models/CaseInternal.dart';
import '../../../models/CaseSceneLocation.dart';
import '../../../models/FidsCrimeScene.dart';
import '../../../widget/app_bar_widget.dart';
import '../../../widget/app_button.dart';
import '../../../widget/blurry_dialog.dart';
import 'inside_building.dart';
import 'outside_building.dart';

class SelectLocation extends StatefulWidget {
  final int? caseID;
  final String? caseNo;
  final bool? isLocal;

  const SelectLocation(
      {super.key, this.caseID, this.caseNo, this.isLocal = false});

  @override
  SelectLocationState createState() => SelectLocationState();
}

class SelectLocationState extends State<SelectLocation> {
  bool isLoading = true;
  bool isPhone = Device.get().isPhone;
  bool isInternalBuilding = true;
  int isCreatedInternal = 3;

  int? internalBuildingValue;
  FidsCrimeScene? fidsCrimeScene = FidsCrimeScene();
  List<CaseInternal> caseInternals = [];
  List<CaseSceneLocation> caseSceneLocations = [];

  @override
  void initState() {
    asyncGetFidsCrimeSceneById();
    super.initState();
  }

  Future<void> asyncGetFidsCrimeSceneById() async {
    await FidsCrimeSceneDao()
        .getFidsCrimeSceneById(widget.caseID ?? -1)
        .then((value) {
      fidsCrimeScene = value;
      if (kDebugMode) {
        print('fidsCrimeScene?.isOutside ${fidsCrimeScene?.isOutside}');
      }
      setState(() {
        if (fidsCrimeScene?.isOutside == 1) {
          isInternalBuilding = true;
        } else {
          isInternalBuilding = false;
        }
      });
    });

    asyncCall2();
    asyncCall3();
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
    caseSceneLocations = result;

    if (fidsCrimeScene?.buildingTypeId != null &&
            fidsCrimeScene?.buildingTypeId != 0 ||
        (caseInternals.isNotEmpty) ||
        caseSceneLocations.isNotEmpty) {
      isCreatedInternal = 1;
      if (kDebugMode) {
        print('1');
      }
    } else if (fidsCrimeScene?.sceneType != null &&
        fidsCrimeScene?.sceneType != '') {
      isCreatedInternal = 2;
      if (kDebugMode) {
        print('2');
      }
    } else {
      isCreatedInternal = 3;
      if (kDebugMode) {
        print('3');
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const AppBarWidget(
        title: 'สถานที่เกิดเหตุ',
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
                  height: MediaQuery.of(context).size.height,
                  margin: isPhone
                      ? const EdgeInsets.all(32)
                      : const EdgeInsets.only(
                          left: 128, right: 128, top: 32, bottom: 32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'เลือกสถานที่เกิดเหตุ',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.prompt(
                          textStyle: TextStyle(
                            color: Colors.white,
                            letterSpacing: .5,
                            fontSize: MediaQuery.of(context).size.height * 0.03,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          _menuItem('ภายในอาคาร', Icons.business, () {
                            setState(() {
                              isInternalBuilding = true;
                              if (kDebugMode) {
                                print(isInternalBuilding);
                              }
                            });
                          }, 1),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.01),
                          _menuItem('ภายนอกอาคาร', Icons.domain_disabled, () {
                            setState(() {
                              isInternalBuilding = false;
                              if (kDebugMode) {
                                print(isInternalBuilding);
                              }
                            });
                          }, 2),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      Flexible(
                        child: AppButton(
                            color: pinkButton,
                            textColor: Colors.white,
                            text: 'บันทึก',
                            onPressed: () async {
                              asyncUpdate();
                              if (isCreatedInternal == 1) {
                                if (isInternalBuilding == false) {
                                  BlurryDialog alert = BlurryDialog('แจ้งเตือน',
                                      'คุณได้กรอกข้อมูลสถานที่เกิดเหตุภายในอาคารไปแล้ว หากต้องการกรอกข้อมูลสถานที่เกิดเหตุภายนอกอาคาร ข้อมูลภายสถานที่เกิดเหตุภายในอาคารจะถูกลบทั้งหมด',
                                      () async {
                                    await CaseInternalDao()
                                        .delete(widget.caseID ?? -1);

                                    await CaseSceneLocationDao()
                                        .delete(widget.caseID ?? -1);

                                    await FidsCrimeSceneDao()
                                        .updateSceneInternal(-1, '', '', '', -1,
                                            '', '', '', '', '${widget.caseID}');
                                    pushOutsideBuilding();
                                  });
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return alert;
                                    },
                                  );
                                } else {
                                  pushInsideBuilding();
                                }
                              } else if (isCreatedInternal == 2) {
                                // outside สร้างแล้ว
                                if (isInternalBuilding) {
                                  BlurryDialog alert = BlurryDialog('แจ้งเตือน',
                                      'คุณได้กรอกข้อมูลสถานที่เกิดเหตุภายนอกอาคารไปแล้ว หากต้องการกรอกข้อมูลสถานที่เกิดเหตุภายในอาคาร ข้อมูลภายสถานที่เกิดเหตุภายนอกอาคารจะถูกลบทั้งหมด',
                                      () async {
                                    await FidsCrimeSceneDao().updateIsOutside(
                                        -1, widget.caseID ?? -1);
                                    await FidsCrimeSceneDao()
                                        .updateSceneExternal('', '', '', '', '',
                                            '', '', '${widget.caseID}');

                                    pushInsideBuilding();
                                  });
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return alert;
                                    },
                                  );
                                } else {
                                  pushOutsideBuilding();
                                }
                              } else {
                                if (isInternalBuilding) {
                                  pushInsideBuilding();
                                } else {
                                  pushOutsideBuilding();
                                }
                              }
                            }),
                      )
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _menuItem(String? label, IconData icon, Function onPress, int tag) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            color: tag == 1
                ? isInternalBuilding
                    ? whiteOpacity
                    : Colors.transparent
                : isInternalBuilding
                    ? Colors.transparent
                    : whiteOpacity,
            margin: const EdgeInsets.only(left: 5, right: 5),
            alignment: Alignment.center,
            child: ElevatedButton(
              child: AspectRatio(
                aspectRatio: 1 / 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    Icon(icon,
                        color: tag == 1
                            ? isInternalBuilding
                                ? textColor
                                : whiteOpacity
                            : isInternalBuilding
                                ? whiteOpacity
                                : textColor,
                        size: MediaQuery.of(context).size.height * 0.05),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    Text(
                      label ?? '',
                      style: GoogleFonts.prompt(
                        textStyle: TextStyle(
                            color: tag == 1
                                ? isInternalBuilding
                                    ? textColor
                                    : whiteOpacity
                                : isInternalBuilding
                                    ? whiteOpacity
                                    : textColor),
                        letterSpacing: 0.5,
                        fontSize: MediaQuery.of(context).size.height * 0.02,
                      ),
                    ),
                  ],
                ),
              ),
              onPressed: () {
                onPress();
              },
            ),
          ),
        ],
      ),
    );
  }

  void asyncUpdate() async {
    if (isInternalBuilding) {
      internalBuildingValue = 1;
    } else {
      internalBuildingValue = 2;
    }
    await FidsCrimeSceneDao()
        .updateIsOutside(internalBuildingValue ?? -1, widget.caseID ?? -1);
  }

  pushInsideBuilding() async {
    var result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => InsideBuilding(
                caseID: widget.caseID ?? -1,
                caseNo: widget.caseNo,
                isLocal: widget.isLocal ?? false)));
    if (result != null) {
      asyncGetFidsCrimeSceneById();
    }
  }

  pushOutsideBuilding() async {
    var result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => OutsideBuilding(
                caseID: widget.caseID ?? -1,
                caseNo: widget.caseNo,
                isLocal: widget.isLocal ?? false)));
    if (result != null) {
      asyncGetFidsCrimeSceneById();
    }
  }
}
