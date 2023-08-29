import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/color.dart';
import '../../../models/CaseCategory.dart';
import '../../../models/FidsCrimeScene.dart';
import '../../../widget/app_bar_widget.dart';
import 'outside_building/edit_outside_building.dart';

class CrimeSceneOutsideBuilding {
  String? sceneType;
  int? sceneTypeValue;
  String? sceneTypeDetail;
  String? sceneFront;
  String? sceneLeft;
  String? sceneRight;
  String? sceneBack;
  String? sceneLocation;
}

class OutsideBuilding extends StatefulWidget {
  final int? caseID;
  final String? caseNo;
  final bool isLocal;

  const OutsideBuilding(
      {super.key, this.caseID, this.caseNo, this.isLocal = false});

  @override
  OutsideBuildingState createState() => OutsideBuildingState();
}

class OutsideBuildingState extends State<OutsideBuilding> {
  bool isPhone = Device.get().isPhone;
  int _sceneTypeValue = -1;

  CrimeSceneOutsideBuilding crimeSceneOutsideBuilding =
      CrimeSceneOutsideBuilding();

  bool isLoading = true;

  FidsCrimeScene? fidsCrimeScene;
  String? caseName;
  bool isEmptyArea = false;

  @override
  void initState() {
    super.initState();
    asyncMethod();
  }

  asyncMethod() async {
    asyncCall1();
  }

  void asyncCall1() async {
    var result =
        await FidsCrimeSceneDao().getFidsCrimeSceneById(widget.caseID ?? -1);
    setState(() {
      fidsCrimeScene = result;

      if (fidsCrimeScene?.sceneType == '1') {
        _sceneTypeValue = 1;
      } else if (fidsCrimeScene?.sceneType == '2') {
        _sceneTypeValue = 2;
      } else if (fidsCrimeScene?.sceneType == '3') {
        _sceneTypeValue = 3;
      } else if (fidsCrimeScene?.sceneType == '4') {
        _sceneTypeValue = 4;
      } else if (fidsCrimeScene?.sceneType == '5') {
        _sceneTypeValue = 5;
      }
    });
    isLoading = false;
    await CaseCategoryDAO()
        .getCaseCategoryLabelByid(fidsCrimeScene?.caseCategoryID ?? -1)
        .then((value) {
      caseName = value;
      if (fidsCrimeScene?.caseCategoryID == 3 ||
          fidsCrimeScene?.caseCategoryID == 4) {
        isEmptyArea = true;
      }
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
      appBar: AppBarWidget(
        title: 'กรณีเกิดเหตุภายนอกอาคาร',
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
            child: Row(
              children: [
                Icon(Icons.edit,
                    color: Colors.white,
                    size: MediaQuery.of(context).size.height * 0.025),
              ],
            ),
            onPressed: () async {
              var result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditOutsideBuilding(
                          caseNo: widget.caseNo,
                          caseID: widget.caseID ?? -1,
                          isLocal: widget.isLocal)));

              if (result) {
                asyncCall1();
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
                headerView(),
                selectLocation(),
                spacer(),
                detailView('${_cleanText(fidsCrimeScene?.sceneDetails)}'),
                spacer(),
                spacer(),
                title('สภาพบริเวณโดยรอบเมื่อหันหน้าเข้าที่เกิดเหตุ'),
                spacer(),
                titleWidget('ด้านหน้าติด'),
                spacer(),
                detailView('${_cleanText(fidsCrimeScene?.sceneFront)}'),
                spacer(),
                titleWidget('ด้านซ้ายติด'),
                spacer(),
                detailView('${_cleanText(fidsCrimeScene?.sceneLeft)}'),
                spacer(),
                titleWidget('ด้านขวาติด'),
                spacer(),
                detailView('${_cleanText(fidsCrimeScene?.sceneRight)}'),
                spacer(),
                titleWidget('ด้านหลังติด'),
                spacer(),
                detailView('${_cleanText(fidsCrimeScene?.sceneBack)}'),
                spacer(),
                spacer(),
                title('บริเวณที่เกิดเหตุ'),
                spacer(),
                titleWidget('เกิดเหตุที่'),
                spacer(),
                detailView('${_cleanText(fidsCrimeScene?.sceneLocation)}'),
                spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  spacer() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.01,
    );
  }

  title(String? title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        '$title',
        textAlign: TextAlign.left,
        style: GoogleFonts.prompt(
          textStyle: TextStyle(
            color: Colors.white,
            letterSpacing: .5,
            fontSize: MediaQuery.of(context).size.height * 0.03,
          ),
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
          ),
          Text(
            'ประเภทคดี : $caseName',
            textAlign: TextAlign.center,
            style: GoogleFonts.prompt(
              textStyle: TextStyle(
                color: Colors.white,
                letterSpacing: .5,
                fontSize: MediaQuery.of(context).size.height * 0.025,
              ),
            ),
          )
        ],
      ),
    );
  }

  selectLocation() {
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
                groupValue: _sceneTypeValue,
                onChanged: (_) {},
              ),
            ),
            Text(
              'ถนน',
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
                groupValue: _sceneTypeValue,
                onChanged: (_) {},
              ),
            ),
            Text(
              'สนามหญ้า',
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
                value: 3,
                activeColor: pinkButton,
                groupValue: _sceneTypeValue,
                onChanged: (_) {},
              ),
            ),
            Text(
              'ในสวน',
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
        isEmptyArea
            ? Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Transform.scale(
                    scale: 1.2,
                    child: Radio(
                      value: 4,
                      activeColor: pinkButton,
                      groupValue: _sceneTypeValue,
                      onChanged: (_) {},
                    ),
                  ),
                  Text(
                    'ที่ว่าง',
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
              )
            : Container(),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Transform.scale(
              scale: 1.2,
              child: Radio(
                value: 5,
                activeColor: pinkButton,
                groupValue: _sceneTypeValue,
                onChanged: (_) {},
              ),
            ),
            Text(
              'อื่นๆ',
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

  Widget titleWidget(String? title) {
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
          borderRadius: BorderRadius.circular(8), color: whiteOpacity),
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
                    '${text == '' ? '' : text}',
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
