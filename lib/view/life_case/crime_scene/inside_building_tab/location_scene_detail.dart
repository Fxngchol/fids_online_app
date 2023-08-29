import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../Utils/color.dart';
import '../../../../models/CaseSceneLocation.dart';
import '../../../../models/Unit.dart';
import '../../../../widget/app_bar_widget.dart';
import '../../../../widget/app_button.dart';
import 'add_scene_location_tab.dart';

class LocationSceneDetail extends StatefulWidget {
  final int? caseID, caseSceneLocationId;
  final String? caseNo;
  final bool? isLocal;

  const LocationSceneDetail(
      {super.key,
      this.caseSceneLocationId,
      this.caseID,
      this.caseNo,
      this.isLocal = false});

  @override
  LocationSceneDetailState createState() => LocationSceneDetailState();
}

class LocationSceneDetailState extends State<LocationSceneDetail> {
  bool isPhone = Device.get().isPhone;

  List unitList = [];
  List<Unit> units = [];

  bool isLoading = true;

  CaseSceneLocation caseSceneLocation = CaseSceneLocation();

  @override
  void initState() {
    super.initState();
    asyncMethod();
    if (kDebugMode) {
      print(
          'caseID ${widget.caseID}, caseSceneLocationId ${widget.caseSceneLocationId}');
    }
  }

  asyncMethod() async {
    // asyncCall1();
    asyncgetCaseSceneLocationById();
  }

  void asyncgetCaseSceneLocationById() async {
    if (widget.caseSceneLocationId != null && widget.caseID != null) {
      var result = await CaseSceneLocationDao().getCaseSceneLocationById(
          widget.caseSceneLocationId!, widget.caseID!);
      setState(() {
        caseSceneLocation = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBarWidget(
        title: 'ลักษณะภายใน',
        leading: IconButton(
          icon: isIOS
              ? const Icon(Icons.arrow_back_ios)
              : const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
        actions: [
          TextButton(
            child: Icon(Icons.edit,
                color: Colors.white,
                size: MediaQuery.of(context).size.height * 0.03),
            onPressed: () async {
              var result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddSceneLocation(
                            isEdit: true,
                            caseSceneLocationId: widget.caseSceneLocationId,
                            caseID: widget.caseID ?? -1,
                            caseNo: widget.caseNo,
                            isLocal: widget.isLocal,
                          )));

              if (result) {
                asyncMethod();
              }
            },
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
            margin: isPhone
                ? const EdgeInsets.all(32)
                : const EdgeInsets.only(
                    left: 32, right: 32, top: 32, bottom: 32),
            child: ListView(
              children: [
                subtitle('เกิดเหตุที่'),
                spacer(),
                detailView('${_cleanText(caseSceneLocation.sceneLocation)}'),
                spacerTitle(),
                subtitle('ขนาดกว้างxยาว(ประมาณ)'),
                spacer(),
                detailView(
                    '${_cleanText(caseSceneLocation.sceneLocationSize)} ${caseSceneLocation.unitId == '1' ? 'เมตร' : 'เซนติเมตร'}'),
                spacerTitle(),
                subtitle('ลักษณะโครงสร้าง'),
                spacer(),
                detailView(
                    '${_cleanText(caseSceneLocation.buildingStructure)}'),
                spacerTitle(),
                subtitle('ผนังด้านหน้า'),
                spacer(),
                detailView(
                    '${_cleanText(caseSceneLocation.buildingWallFront)}'),
                spacerTitle(),
                subtitle('ผนังด้านซ้าย'),
                spacer(),
                detailView('${_cleanText(caseSceneLocation.buildingWallLeft)}'),
                spacerTitle(),
                subtitle('ผนังด้านขวา'),
                spacer(),
                detailView(
                    '${_cleanText(caseSceneLocation.buildingWallRight)}'),
                spacerTitle(),
                subtitle('ผนังด้านหลัง'),
                spacer(),
                detailView('${_cleanText(caseSceneLocation.buildingWallBack)}'),
                spacerTitle(),
                subtitle('พื้นห้อง'),
                spacer(),
                detailView('${_cleanText(caseSceneLocation.roomFloor)}'),
                spacerTitle(),
                subtitle('หลังคา'),
                spacer(),
                detailView('${_cleanText(caseSceneLocation.roof)}'),
                spacerTitle(),
                subtitle('ผ้า/เพดาน'),
                spacer(),
                detailView('${_cleanText(caseSceneLocation.ceiling)}'),
                spacerTitle(),
                spacer(),
                title('ลักษณะการจัดวางสิ่งของ'),
                spacerTitle(),
                subtitle('ชิดฝาผนังด้านหน้าเรียงจากซ้ายไปขวา'),
                spacer(),
                detailView('${_cleanText(caseSceneLocation.frontLeftToRight)}'),
                spacerTitle(),
                subtitle('ชิดฝาผนังด้านซ้ายเรียงจากหน้าไปหลัง'),
                spacer(),
                detailView('${_cleanText(caseSceneLocation.leftFrontToBack)}'),
                spacerTitle(),
                subtitle('ชิดฝาผนังด้านขวาเรียงจากหน้าไปหลัง'),
                spacer(),
                detailView('${_cleanText(caseSceneLocation.rightFrontToBack)}'),
                spacerTitle(),
                subtitle('ชิดฝาผนังด้านหลังเรียงจากซ้ายไปขวา'),
                spacer(),
                detailView('${_cleanText(caseSceneLocation.backLeftToRight)}'),
                spacerTitle(),
                subtitle('บริเวณอื่นๆ'),
                spacer(),
                detailView('${_cleanText(caseSceneLocation.areaOther)}'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  spacerTitle() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.015,
    );
  }

  spacer() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.01,
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

  Widget title(String? title) {
    return Row(
      children: [
        Text(
          title ?? '',
          style: GoogleFonts.prompt(
            textStyle: TextStyle(
              color: Colors.white,
              letterSpacing: 0.5,
              fontWeight: FontWeight.w500,
              fontSize: MediaQuery.of(context).size.height * 0.025,
            ),
          ),
        ),
      ],
    );
  }

  detailView(
    String? text,
  ) {
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

  Widget saveButton() {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
      child: AppButton(
          color: pinkButton,
          textColor: Colors.white,
          text: 'บันทึกข้อมูล',
          onPressed: () {
            Navigator.pop(context);
          }),
    );
  }

  String? _cleanText(String? text) {
    try {
      if (text == null || text == '' || text == 'null' || text == '-1') {
        return '';
      }
      return text;
    } catch (ex) {
      return '';
    }
  }
}
