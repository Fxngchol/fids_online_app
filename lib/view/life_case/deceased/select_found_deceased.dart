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
import 'deceased_detail.dart';

class SelectFoundDecease extends StatefulWidget {
  final int? caseID;
  final String? caseNo;
  final bool isLocal;

  const SelectFoundDecease(
      {super.key, this.caseID, this.caseNo, this.isLocal = false});

  @override
  SelectFoundDeceaseState createState() => SelectFoundDeceaseState();
}

class SelectFoundDeceaseState extends State<SelectFoundDecease> {
  bool isLoading = true;
  bool isPhone = Device.get().isPhone;
  bool isFoundDecease = false;

  String? isFoundDeceaseValue;
  FidsCrimeScene fidsCrimeScene = FidsCrimeScene();
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
      fidsCrimeScene = value ?? FidsCrimeScene();
      if (kDebugMode) {
        print('fidsCrimeScene.isBodyFound ${fidsCrimeScene.isBodyFound}');
      }
      setState(() {
        if (fidsCrimeScene.isBodyFound == null) {
          isFoundDecease = false;
        } else {
          if (fidsCrimeScene.isBodyFound == '1') {
            isFoundDecease = true;
          } else {
            isFoundDecease = false;
          }
        }
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const AppBarWidget(
        title: 'ผู้เสียชีวิต',
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
                          _menuItem('พบศพ', Icons.person, () {
                            setState(() {
                              isFoundDecease = true;
                              if (kDebugMode) {
                                print(isFoundDecease);
                              }
                            });
                          }, 1),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.01),
                          _menuItem('ไม่พบศพ', Icons.person, () {
                            setState(() {
                              isFoundDecease = false;
                              if (kDebugMode) {
                                print(isFoundDecease);
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
                              if (isFoundDecease) {
                                pushDeceasedDetail();
                              } else {
                                Navigator.of(context).pop(true);
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
                ? isFoundDecease
                    ? whiteOpacity
                    : Colors.transparent
                : isFoundDecease
                    ? Colors.transparent
                    : whiteOpacity,
            margin: const EdgeInsets.only(left: 5, right: 5),
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: () {
                onPress();
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.transparent,
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ))),
              child: AspectRatio(
                aspectRatio: 1 / 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    Icon(icon,
                        color: tag == 1
                            ? isFoundDecease
                                ? textColor
                                : whiteOpacity
                            : isFoundDecease
                                ? whiteOpacity
                                : textColor,
                        size: MediaQuery.of(context).size.height * 0.05),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    Text(
                      label ?? '',
                      style: GoogleFonts.prompt(
                        textStyle: TextStyle(
                            color: tag == 1
                                ? isFoundDecease
                                    ? textColor
                                    : whiteOpacity
                                : isFoundDecease
                                    ? whiteOpacity
                                    : textColor),
                        letterSpacing: 0.5,
                        fontSize: MediaQuery.of(context).size.height * 0.02,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void asyncUpdate() async {
    if (isFoundDecease) {
      isFoundDeceaseValue = '1';
    } else {
      isFoundDeceaseValue = '2';
    }
    await FidsCrimeSceneDao()
        .updateIsBodyFound(isFoundDeceaseValue ?? '', widget.caseID ?? -1);
  }

  pushDeceasedDetail() async {
    var result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DeceasedDetail(
                caseID: widget.caseID ?? -1,
                caseNo: widget.caseNo,
                isLocal: widget.isLocal)));
    if (result != null) {
      asyncGetFidsCrimeSceneById();
    }
  }
}
