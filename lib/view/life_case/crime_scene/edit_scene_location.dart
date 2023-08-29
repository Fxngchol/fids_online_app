import 'package:fids_online_app/view/life_case/crime_scene/scene_location_detail.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/color.dart';
import '../../../models/FidsCrimeScene.dart';
import '../../../widget/app_bar_widget.dart';
import '../../../widget/app_button.dart';
import '../../../widget/text_field_widget.dart';

class SceneLocation extends StatefulWidget {
  final int? caseID;
  final bool isLocal;

  const SceneLocation({super.key, this.caseID, this.isLocal = false});

  @override
  SceneLocationState createState() => SceneLocationState();
}

class SceneLocationState extends State<SceneLocation> {
  bool isPhone = Device.get().isPhone;
  SceneLocate sceneLocation = SceneLocate();
  FidsCrimeScene? fidsCrimeScene;

  bool isLoading = true;

  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();
  final TextEditingController _controller4 = TextEditingController();

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

      _controller1.text =
          _cleanText(fidsCrimeScene?.sceneProtectionDetails) ?? '';
      sceneLocation.sceneProtectionDetails =
          fidsCrimeScene?.sceneProtectionDetails;

      _controller2.text =
          _cleanText(fidsCrimeScene?.lightConditionDetails) ?? '';
      sceneLocation.lightConditionDetails =
          fidsCrimeScene?.lightConditionDetails;

      _controller3.text =
          _cleanText(fidsCrimeScene?.tempetatureConditionDetails) ?? '';
      sceneLocation.temperatureConditionDetails =
          fidsCrimeScene?.tempetatureConditionDetails;

      _controller4.text = _cleanText(fidsCrimeScene?.smellDetails) ?? '';
      sceneLocation.smellDetails = fidsCrimeScene?.smellDetails;

      if (fidsCrimeScene?.isSceneProtection == 1) {
        sceneLocation.isSceneProtectionValue = 1;
        sceneLocation.isSceneProtection = true;
      } else if (fidsCrimeScene?.isSceneProtection == 2) {
        sceneLocation.isSceneProtectionValue = 2;
        sceneLocation.isSceneProtection = false;
      }

      if (fidsCrimeScene?.lightCondition == '1') {
        sceneLocation.lightConditionValue = 1;
        sceneLocation.lightCondition = 'มืด';
      } else if (fidsCrimeScene?.lightCondition == '2') {
        sceneLocation.lightConditionValue = 2;
        sceneLocation.lightCondition = 'สว่าง';
      } else if (fidsCrimeScene?.lightCondition == '3') {
        sceneLocation.lightConditionValue = 3;
        sceneLocation.lightCondition = 'เสาไฟส่องสว่าง';
      } else if (fidsCrimeScene?.lightCondition == '4') {
        sceneLocation.lightConditionValue = 4;
        sceneLocation.lightCondition = 'อื่นๆ';
      }

      if (fidsCrimeScene?.temperatureCondition == '1') {
        sceneLocation.temperatureConditionValue = 1;
        sceneLocation.temperatureCondition = 'ร้อน';
      } else if (fidsCrimeScene?.temperatureCondition == '2') {
        sceneLocation.temperatureConditionValue = 2;
        sceneLocation.temperatureCondition = 'เย็น';
      } else if (fidsCrimeScene?.temperatureCondition == '3') {
        sceneLocation.temperatureConditionValue = 3;
        sceneLocation.temperatureCondition = 'เครื่องปรับอากาศ';
      } else if (fidsCrimeScene?.temperatureCondition == '4') {
        sceneLocation.temperatureConditionValue = 4;
        sceneLocation.temperatureCondition = 'อื่นๆ';
      }

      if (fidsCrimeScene?.isSmell == 1) {
        sceneLocation.isSmellValue = 1;
        sceneLocation.isSmell = true;
      } else if (fidsCrimeScene?.isSmell == 2) {
        sceneLocation.isSmellValue = 2;
        sceneLocation.isSmell = false;
      }
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBarWidget(
        title: 'สภาพสถานที่เกิดเหตุเมื่อไปถึง',
        actions: [
          Container(
            width: MediaQuery.of(context).size.width * 0.1,
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
            margin:
                isPhone ? const EdgeInsets.all(32) : const EdgeInsets.all(48),
            child: ListView(
              children: [
                titleWidget('การรักษาสถานที่เกิดเหตุ'),
                spacer(),
                sceneProtectionView(),
                spacerView(),
                titleWidget('แสงสว่าง(ที่สังเกตเห็น)'),
                spacer(),
                lightConditionView(),
                spacerView(),
                titleWidget('อุณหภูมิ'),
                spacer(),
                temperatureConditionView(),
                spacerView(),
                titleWidget('กลิ่น'),
                spacer(),
                smellView(),
                spacerView(),
                saveButton()
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

  void _handleSceneProtectionValueChange(int value) {
    setState(() {
      sceneLocation.isSceneProtectionValue = value;
      // switch (sceneLocation.isSceneProtectionValue) {
      //   case 1:
      //     sceneLocation.isSceneProtectionValue = 0;
      //     sceneLocation.isSceneProtection = false;
      //     break;
      //   case 2:
      //     sceneLocation.isSceneProtection = true;
      //     sceneLocation.isSceneProtectionValue = 1;
      //     break;
      // }
    });
  }

  void _handleLightConditionValueChange(int value) {
    setState(() {
      sceneLocation.lightConditionValue = value;
      // switch (sceneLocation.lightConditionValue) {
      //   case 1:
      //     sceneLocation.lightCondition = 'มืด';
      //     sceneLocation.lightConditionValue = 1;
      //     break;
      //   case 2:
      //     sceneLocation.lightCondition = 'สว่าง';

      //     sceneLocation.lightConditionValue = 2;
      //     break;
      //   case 3:
      //     sceneLocation.lightCondition = 'เสาไฟส่องสว่าง';

      //     sceneLocation.lightConditionValue = 3;
      //     break;
      //   case 4:
      //     sceneLocation.lightCondition = 'อื่นๆ';

      //     sceneLocation.lightConditionValue = 4;
      //     break;
      // }
    });
  }

  void _handleTemperatureConditionValueChange(int value) {
    setState(() {
      sceneLocation.temperatureConditionValue = value;
      // switch (sceneLocation.temperatureConditionValue) {
      //   case 1:
      //     sceneLocation.temperatureCondition = 'ร้อน';
      //     sceneLocation.temperatureConditionValue = 1;
      //     break;
      //   case 2:
      //     sceneLocation.temperatureCondition = 'เย็น';
      //     sceneLocation.temperatureConditionValue = 2;
      //     break;
      //   case 3:
      //     sceneLocation.temperatureCondition = 'เครื่องปรับอากาศ';
      //     sceneLocation.temperatureConditionValue = 3;
      //     break;
      //   case 4:
      //     sceneLocation.temperatureCondition = 'อื่นๆ';
      //     sceneLocation.temperatureConditionValue = 4;
      //     break;
      // }
    });
  }

  void _handleSmellValueChange(int value) {
    setState(() {
      sceneLocation.isSmellValue = value;
      // switch (sceneLocation.isSmellValue) {
      //   case 1:
      //     sceneLocation.isSmell = false;
      //     sceneLocation.isSmellValue = 1;
      //     break;
      //   case 2:
      //     sceneLocation.isSmell = true;
      //     sceneLocation.isSmellValue = 2;
      //     break;
      // }
    });
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
                onChanged: (val) {
                  _handleSceneProtectionValueChange(val ?? -1);
                },
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
                onChanged: (val) {
                  _handleSceneProtectionValueChange(val ?? -1);
                },
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
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.01,
        ),
        titleWidget('หมายเหตุ'),
        spacer(),
        InputField(
            controller: _controller1,
            hint: 'กรอกข้อมูลการรักษาสถานที่เกิดเหตุอื่นๆ',
            onChanged: (value) {
              sceneLocation.sceneProtectionDetails = value;
            })
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
                onChanged: (val) {
                  _handleLightConditionValueChange(val ?? -1);
                },
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
                onChanged: (val) {
                  _handleLightConditionValueChange(val ?? -1);
                },
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
                onChanged: (val) {
                  _handleLightConditionValueChange(val ?? -1);
                },
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
                onChanged: (val) {
                  _handleLightConditionValueChange(val ?? -1);
                },
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
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.01,
        ),
        InputField(
            controller: _controller2,
            hint: 'กรอกข้อมูลบริเวณเกิดเหตุอื่นๆ',
            onChanged: (value) {
              sceneLocation.lightConditionDetails = value;
            })
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
                onChanged: (val) {
                  _handleLightConditionValueChange(val ?? -1);
                },
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
                onChanged: (val) {
                  _handleTemperatureConditionValueChange(val ?? -1);
                },
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
                onChanged: (val) {
                  _handleTemperatureConditionValueChange(val ?? -1);
                },
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
                onChanged: (val) {
                  _handleTemperatureConditionValueChange(val ?? -1);
                },
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
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.01,
        ),
        InputField(
            controller: _controller3,
            hint: 'กรอกข้อมูลอุณหภูมิอื่นๆ',
            onChanged: (value) {
              sceneLocation.temperatureConditionDetails = value;
            })
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
                onChanged: (val) {
                  _handleSmellValueChange(val ?? -1);
                },
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
                onChanged: (val) {
                  _handleSmellValueChange(val ?? -1);
                },
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
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.01,
        ),
        titleWidget('หมายเหตุ'),
        spacer(),
        InputField(
            controller: _controller4,
            hint: 'กรอกข้อมูลกลิ่นอื่นๆ',
            onChanged: (value) {
              sceneLocation.smellDetails = value;
            },
            onFieldSubmitted: (value) {
              Focus.of(context).unfocus();
              sceneLocation.smellDetails = value;
            })
      ],
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
            if (kDebugMode) {
              print(
                  'การรักษาสถานที่เกิดเหตุ ${sceneLocation.isSceneProtection}');
              print('รายละเอียด ${sceneLocation.sceneProtectionDetails}');
              print('แสงสว่าง ${sceneLocation.lightConditionValue.toString()}');
              print('รายละเอียด ${sceneLocation.lightConditionDetails}');
              print(
                  'อุณหภูมิ ${sceneLocation.temperatureConditionValue.toString()}');
              print('รายละเอียด ${sceneLocation.temperatureConditionDetails}');
              print('กลิ่น ${sceneLocation.isSmellValue}');
              print('รายละเอียด ${sceneLocation.smellDetails}');
            }

            FidsCrimeSceneDao().updateSceneLocation(
                sceneLocation.isSceneProtectionValue,
                sceneLocation.sceneProtectionDetails,
                sceneLocation.lightConditionValue.toString(),
                sceneLocation.lightConditionDetails,
                sceneLocation.temperatureConditionValue.toString(),
                sceneLocation.temperatureConditionDetails,
                sceneLocation.isSmellValue,
                sceneLocation.smellDetails,
                '${widget.caseID}');

            Navigator.of(context).pop(true);
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
