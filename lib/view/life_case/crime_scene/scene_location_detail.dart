import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/color.dart';
import '../../../models/FidsCrimeScene.dart';
import '../../../widget/app_bar_widget.dart';
import 'edit_scene_location.dart';

class SceneLocate {
  int? isSceneProtectionValue,
      lightConditionValue,
      temperatureConditionValue,
      isSmellValue;

  bool? isSceneProtection;
  String? sceneProtectionDetails;
  String? lightCondition;
  String? lightConditionDetails;
  String? temperatureCondition;
  String? temperatureConditionDetails;
  bool? isSmell;
  String? smellDetails;
  SceneLocate(
      {this.isSceneProtectionValue,
      this.lightConditionValue,
      this.temperatureConditionValue,
      this.isSmellValue,
      this.isSceneProtection,
      this.sceneProtectionDetails,
      this.lightCondition,
      this.lightConditionDetails,
      this.temperatureCondition,
      this.temperatureConditionDetails,
      this.isSmell = false,
      this.smellDetails});
}

class SceneLocationDetail extends StatefulWidget {
  final int? caseID;
  final bool isLocal;

  const SceneLocationDetail({super.key, this.caseID, this.isLocal = false});

  @override
  SceneLocationDetailState createState() => SceneLocationDetailState();
}

class SceneLocationDetailState extends State<SceneLocationDetail> {
  bool isPhone = Device.get().isPhone;
  SceneLocate sceneLocation = SceneLocate();

  FidsCrimeScene? fidsCrimeScene;

  bool isLoading = true;

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
      if (kDebugMode) {
        print('object : ${fidsCrimeScene?.isSceneProtection}');
      }
      if (fidsCrimeScene?.isSceneProtection == 1) {
        sceneLocation.isSceneProtectionValue = 1;
        sceneLocation.isSceneProtection = true;
      } else if (fidsCrimeScene?.isSceneProtection == 2) {
        sceneLocation.isSceneProtectionValue = 2;
        sceneLocation.isSceneProtection = false;
      }

      if (fidsCrimeScene?.lightCondition == '1') {
        sceneLocation.lightConditionValue = 1;
      } else if (fidsCrimeScene?.lightCondition == '2') {
        sceneLocation.lightConditionValue = 2;
      } else if (fidsCrimeScene?.lightCondition == '3') {
        sceneLocation.lightConditionValue = 3;
      } else if (fidsCrimeScene?.lightCondition == '4') {
        sceneLocation.lightConditionValue = 4;
      }

      if (fidsCrimeScene?.temperatureCondition == '1') {
        sceneLocation.temperatureConditionValue = 1;
      } else if (fidsCrimeScene?.temperatureCondition == '2') {
        sceneLocation.temperatureConditionValue = 2;
      } else if (fidsCrimeScene?.temperatureCondition == '3') {
        sceneLocation.temperatureConditionValue = 3;
      } else if (fidsCrimeScene?.temperatureCondition == '4') {
        sceneLocation.temperatureConditionValue = 4;
      }

      if (fidsCrimeScene?.isSmell == 1) {
        sceneLocation.isSmellValue = 1;
      } else if (fidsCrimeScene?.isSmell == 2) {
        sceneLocation.isSmellValue = 2;
      }
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBarWidget(
        title: 'สภาพสถานที่เกิดเหตุเมื่อไปถึง',
        actions: [
          TextButton(
            onPressed: () async {
              // var result =
              //     await Navigator.pushNamed(context, '/scenelocationcondition');
              var result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SceneLocation(
                          caseID: widget.caseID ?? -1,
                          isLocal: widget.isLocal)));

              if (result) {
                setState(() async {
                  asyncCall1();
                });
              }
            },
            child: Icon(
              Icons.edit,
              size: MediaQuery.of(context).size.height * 0.03,
              color: Colors.white,
            ),
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
            margin:
                isPhone ? const EdgeInsets.all(32) : const EdgeInsets.all(48),
            child: ListView(
              children: [
                titleWidget('การรักษาสถานที่เกิดเหตุ'),
                spacer(),
                sceneProtectionView(),
                spacer(),
                titleWidget('หมายเหตุ'),
                spacer(),
                fidsCrimeScene?.sceneProtectionDetails == null
                    ? detailView('')
                    : detailView(
                        '${_cleanText(fidsCrimeScene?.sceneProtectionDetails)}'),
                spacerView(),
                titleWidget('แสงสว่าง(ที่สังเกตเห็น)'),
                spacer(),
                lightConditionView(),
                spacer(),
                fidsCrimeScene?.lightConditionDetails == null
                    ? detailView('')
                    : detailView(
                        '${_cleanText(fidsCrimeScene?.lightConditionDetails)}'),
                spacerView(),
                titleWidget('อุณหภูมิ'),
                spacer(),
                temperatureConditionView(),
                spacer(),
                fidsCrimeScene?.tempetatureConditionDetails == null
                    ? detailView('')
                    : detailView(
                        '${_cleanText(fidsCrimeScene?.tempetatureConditionDetails)}'),
                spacerView(),
                titleWidget('กลิ่น'),
                spacer(),
                smellView(),
                spacer(),
                titleWidget('หมายเหตุ'),
                spacer(),
                fidsCrimeScene?.smellDetails == null
                    ? detailView('')
                    : detailView('${_cleanText(fidsCrimeScene?.smellDetails)}'),
                spacerView(),
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

  spacerView() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.02,
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
              fontSize: MediaQuery.of(context).size.height * 0.03,
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
                groupValue: sceneLocation.isSceneProtectionValue,
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
                groupValue: sceneLocation.isSceneProtectionValue,
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

  lightConditionView() {
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
                groupValue: sceneLocation.lightConditionValue,
                onChanged: (_) {},
              ),
            ),
            Text(
              'สว่าง',
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
                groupValue: sceneLocation.lightConditionValue,
                onChanged: (_) {},
              ),
            ),
            Text(
              'มืด',
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
                groupValue: sceneLocation.lightConditionValue,
                onChanged: (_) {},
              ),
            ),
            Text(
              'เสาไฟส่องสว่าง',
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
                value: 4,
                activeColor: pinkButton,
                groupValue: sceneLocation.lightConditionValue,
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

  temperatureConditionView() {
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
                groupValue: sceneLocation.temperatureConditionValue,
                onChanged: (_) {},
              ),
            ),
            Text(
              'ร้อน',
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
                groupValue: sceneLocation.temperatureConditionValue,
                onChanged: (_) {},
              ),
            ),
            Text(
              'เย็น',
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
                groupValue: sceneLocation.temperatureConditionValue,
                onChanged: (_) {},
              ),
            ),
            Text(
              'เครื่องปรับอากาศ',
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
                value: 4,
                activeColor: pinkButton,
                groupValue: sceneLocation.temperatureConditionValue,
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

  smellView() {
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
                groupValue: sceneLocation.isSmellValue,
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
                groupValue: sceneLocation.isSmellValue,
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
