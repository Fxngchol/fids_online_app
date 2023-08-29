import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/color.dart';
import '../../../models/CaseCategory.dart';
import '../../../models/CaseInspector.dart';
import '../../../models/FidsCrimeScene.dart';
import '../../../models/Personal.dart';
import '../../../models/Position.dart';
import '../../../models/Title.dart';
import '../../../widget/app_bar_widget.dart';
import 'add_release_scene.dart';

class ReleaseScene extends StatefulWidget {
  final int? caseID;
  final String? caseNo;
  final bool isLocal;

  const ReleaseScene(
      {super.key, this.caseID, this.caseNo, this.isLocal = false});

  @override
  ReleaseSceneState createState() => ReleaseSceneState();
}

class ReleaseSceneState extends State<ReleaseScene> {
  bool isPhone = Device.get().isPhone;

  FidsCrimeScene? data;
  bool isLoading = true;

  bool isFinal = false;
  bool isComplete = false;
  bool isDeliver = false;
  String positionId = '';
  Image? receiveSignImage, sendertSignImage;

  List<MyTitle> titleList = [];
  List<Personal> personalList = [];
  List<Position> positionList = [];
  String? caseName;

  List<CaseInspector> caseInspectorList = [];

  @override
  void initState() {
    super.initState();
    asyncMethod();
  }

  asyncMethod() async {
    asyncCall1();
  }

  void asyncCall1() async {
    var titles = await TitleDao().getTitle();
    var personals = await PersonalDao().getPersonal();
    var positionResult = await PositionDao().getPosition();
    var caseInspectorResult =
        await CaseInspectorDao().getCaseInspector(widget.caseID ?? -1);

    positionList = positionResult;
    titleList = titles;
    personalList = personals;
    caseInspectorList = caseInspectorResult;

    var result =
        await FidsCrimeSceneDao().getFidsCrimeSceneById(widget.caseID ?? -1);
    await CaseCategoryDAO()
        .getCaseCategoryLabelByid(result?.caseCategoryID ?? -1)
        .then((value) => caseName = value);

    setState(() {
      // printWrapped(result.toString());
      data = result;

      positionId = getPositionId(data?.sendPersonID) ?? '';

      if (data?.isoIsFinal == 1) {
        isFinal = true;
      } else {
        isFinal = false;
      }

      if (data?.isoIsComplete == 1) {
        isComplete = true;
      } else {
        isComplete = false;
      }

      if (data?.isoIsDeliver == 1) {
        isDeliver = true;
      } else {
        isDeliver = false;
      }

      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Container(
        color: darkBlue,
        child: const Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBarWidget(
        title: 'การส่งมอบสถานที่เกิดเหตุ',
        actions: [
          TextButton(
            child: Row(
              children: [
                Icon(
                  Icons.edit,
                  size: MediaQuery.of(context).size.height * 0.025,
                  color: Colors.white,
                ),
              ],
            ),
            onPressed: () async {
              var result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddReleaseScene(
                          caseNo: widget.caseNo,
                          caseID: widget.caseID ?? -1,
                          isLocal: widget.isLocal,
                          receiveIsSign: data?.receiveSignature != '' &&
                              data?.receiveSignature != null,
                          senderIsSign: data?.sendSignature != '' &&
                              data?.sendSignature != null)));

              if (result) {
                asyncCall1();
              }
            },
          ),
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
                checkbox('การตรวจสอบครั้งสุดท้าย', isFinal),
                spacer(),
                checkbox('ตรวจเก็บวัตถุพยานครบถ้วน', isComplete),
                spacer(),
                checkbox(
                    'ถ่ายภาพสถานที่เกิดเหตุและดำเนินการส่งมอบสถานที่เกิดเหตุให้แก่พนักงานสอบสวน',
                    isDeliver),
                spacerTitle(),
                spacerTitle(),
                title('วันเวลาที่ทำการตรวจสถานที่เกิดเหตุเสร็จสิ้น'),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            subtitle('วันที่'),
                            detailView('${_cleanText(data?.closeDate)}')
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            subtitle('เวลา'),
                            detailView('${_cleanText(data?.closeTime)}'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                spacerTitle(),
                title('ผู้รับมอบสถานที่เกิดเหตุ'),
                getImagenBase64(data?.receiveSignature),
                spacerTitle(),
                detailView(
                    '${_cleanText(titleLabel(data?.receiveTitleID))} ${_cleanText((data?.receiveName))}'),
                spacerTitle(),
                title('ตำแหน่ง'),
                detailView('${_cleanText(data?.receivePosition)}'),
                spacerTitle(),
                title('ผู้ส่งมอบสถานที่เกิดเหตุ'),
                getImagenBase64(data?.sendSignature),
                spacerTitle(),
                detailView(
                    '${_cleanText(caseInspectorLabel(data?.sendPersonID))}'),
                spacerTitle(),
                title('ตำแหน่ง'),
                detailView('${_cleanText(data?.sendPosition)}'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getImagenBase64(String? image) {
    if (data?.receiveSignature != null) {
      if (kDebugMode) {
        print('data.receiveSignature ${data?.receiveSignature}');
      }
      const letter = 'data:image/png;base64,';
      const newLetter = '';
      var img = image?.replaceAll(letter, newLetter);
      const Base64Codec base64 = Base64Codec();
      if (image == null) return Container();
      var bytes = base64.decode(img ?? '');
      return Image.memory(
        bytes,
        height: 300,
        fit: BoxFit.fitWidth,
      );
    } else {
      return Container(
        color: Colors.white,
        height: 300,
      );
    }
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

  checkbox(String? text, bool isChecked) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Transform.scale(
        scale: 1.7,
        child: Checkbox(
            value: isChecked,
            checkColor: Colors.white,
            activeColor: pinkButton,
            onChanged: (value) {}),
      ),
      SizedBox(width: MediaQuery.of(context).size.width * 0.02),
      Flexible(
        child: Text(
          '$text',
          textAlign: TextAlign.left,
          style: GoogleFonts.prompt(
            textStyle: TextStyle(
              color: Colors.white,
              letterSpacing: .5,
              fontSize: MediaQuery.of(context).size.height * 0.025,
            ),
          ),
        ),
      ),
    ]);
  }

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
              fontWeight: FontWeight.w500,
              fontSize: MediaQuery.of(context).size.height * 0.025,
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

  String? titleLabel(String? id) {
    for (int i = 0; i < titleList.length; i++) {
      if ('$id' == '${titleList[i].id}') {
        return titleList[i].name?.trim();
      }
    }
    return '';
  }

  String? caseInspectorLabel(String? id) {
    if (kDebugMode) {
      print('personalLabel $id');
    }
    for (int i = 0; i < caseInspectorList.length; i++) {
      if ('${caseInspectorList[i].id}' == '$id') {
        if (kDebugMode) {
          print(
              '${caseInspectorList[i].firstname?.trim()} ${caseInspectorList[i].lastname?.trim()}');
        }
        return '${titleLabel(caseInspectorList[i].titleId)} ${caseInspectorList[i].firstname?.trim()} ${caseInspectorList[i].lastname?.trim()}';
      }
    }
    return '';
  }

  String? personalLabel(String? id) {
    if (kDebugMode) {
      print('personalLabel $id');
    }
    for (int i = 0; i < personalList.length; i++) {
      if ('${personalList[i].id}' == '$id') {
        if (kDebugMode) {
          print(
              '${personalList[i].firstName?.trim()} ${personalList[i].lastName?.trim()}');
        }
        return '${titleLabel(personalList[i].titleId)} ${personalList[i].firstName?.trim()} ${personalList[i].lastName?.trim()}';
      }
    }
    return '';
  }

  String? getPositionId(String? id) {
    for (int i = 0; i < personalList.length; i++) {
      if ('${personalList[i].id}' == '$id') {
        return '${personalList[i].positionId}';
      }
    }
    return '';
  }

  // ignore: unused_element
  String? _positionLabel(String? id) {
    if (kDebugMode) {
      print('objectobresultresultresultjectobjectobject $id');
    }
    for (int i = 0; i < positionList.length; i++) {
      if ('$id' == '${positionList[i].id}') {
        return positionList[i].name;
      }
    }
    return '';
  }
}
