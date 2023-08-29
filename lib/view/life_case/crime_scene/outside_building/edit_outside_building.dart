import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../Utils/color.dart';
import '../../../../models/CaseCategory.dart';
import '../../../../models/FidsCrimeScene.dart';
import '../../../../widget/app_bar_widget.dart';
import '../../../../widget/app_button.dart';
import '../../../../widget/text_field_widget.dart';
import '../outside_building.dart';

class EditOutsideBuilding extends StatefulWidget {
  final int? caseID;
  final String? caseNo;
  final bool isLocal;

  const EditOutsideBuilding(
      {super.key, this.caseID, this.caseNo, this.isLocal = false});

  @override
  EditOutsideBuildingState createState() => EditOutsideBuildingState();
}

class EditOutsideBuildingState extends State<EditOutsideBuilding> {
  final TextEditingController _sceneTypeDetailController =
      TextEditingController();
  final TextEditingController _sceneFrontController = TextEditingController();
  final TextEditingController _sceneLeftController = TextEditingController();
  final TextEditingController _sceneRightController = TextEditingController();
  final TextEditingController _sceneBackController = TextEditingController();
  final TextEditingController _sceneLocationController =
      TextEditingController();

  CrimeSceneOutsideBuilding crimeSceneOutsideBuilding =
      CrimeSceneOutsideBuilding();

  bool isPhone = Device.get().isPhone;
  int _sceneTypeValue = -1;
  bool isLoading = true;
  FidsCrimeScene? fidsCrimeScene;
  String? caseName;
  bool isEmptyArea = false;

  void _handleRadioValueChange(int value) {
    setState(() {
      _sceneTypeValue = value;
    });
  }

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

      _sceneTypeDetailController.text = fidsCrimeScene?.sceneDetails ?? '';
      _sceneFrontController.text = fidsCrimeScene?.sceneFront ?? '';
      _sceneLeftController.text = fidsCrimeScene?.sceneLeft ?? '';
      _sceneRightController.text = fidsCrimeScene?.sceneRight ?? '';
      _sceneBackController.text = fidsCrimeScene?.sceneBack ?? '';
      _sceneLocationController.text = fidsCrimeScene?.sceneLocation ?? '';
      if (kDebugMode) {
        print(fidsCrimeScene?.sceneType ?? '');
      }
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
      if (kDebugMode) {
        print(_sceneTypeValue.toString());
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
    if (isLoading) {
      return Container(
        color: darkBlue,
        child: const Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBarWidget(title: 'กรณีเกิดเหตุภายนอกอาคาร', actions: [
        Container(
          width: MediaQuery.of(context).size.width * 0.1,
        )
      ]),
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
                spacer(),
                title('สภาพบริเวณโดยรอบเมื่อหันหน้าเข้าที่เกิดเหตุ'),
                spacer(),
                titleWidget('ด้านหน้าติด'),
                spacer(),
                InputField(
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    controller: _sceneFrontController,
                    hint: 'กรอกข้อมูลด้านหน้า',
                    maxLine: null,
                    onChanged: (value) {}),
                spacer(),
                titleWidget('ด้านซ้ายติด'),
                spacer(),
                InputField(
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    controller: _sceneLeftController,
                    hint: 'กรอกข้อมูลด้านซ้าย',
                    maxLine: null,
                    onChanged: (value) {}),
                spacer(),
                titleWidget('ด้านขวาติด'),
                spacer(),
                InputField(
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    controller: _sceneRightController,
                    hint: 'กรอกข้อมูลด้านขวา',
                    maxLine: null,
                    onChanged: (value) {}),
                spacer(),
                titleWidget('ด้านหลังติด'),
                spacer(),
                InputField(
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    controller: _sceneBackController,
                    hint: 'กรอกข้อมูลด้านหลัง',
                    maxLine: null,
                    onChanged: (value) {}),
                spacer(),
                spacer(),
                title('บริเวณที่เกิดเหตุ'),
                spacer(),
                titleWidget('เกิดเหตุที่'),
                spacer(),
                InputField(
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    controller: _sceneLocationController,
                    hint: 'กรอกบริเวณที่เเกิดเหตุ',
                    maxLine: null,
                    onChanged: (value) {}),
                spacer(),
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
                onChanged: (val) {
                  _handleRadioValueChange(val ?? -1);
                },
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
                onChanged: (val) {
                  _handleRadioValueChange(val ?? -1);
                },
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
                onChanged: (val) {
                  _handleRadioValueChange(val ?? -1);
                },
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
                      onChanged: (val) {
                        _handleRadioValueChange(val ?? -1);
                      },
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
                onChanged: (val) {
                  _handleRadioValueChange(val ?? -1);
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
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            hint: 'กรอกบริเวณเกิดเหตุอื่นๆ',
            controller: _sceneTypeDetailController,
            onChanged: (value) {
              // _sceneTypeDetailController.text = value;
            })
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

  textField(
    TextEditingController controller,
    String? hint,
    Function onChanged,
  ) {
    return InputField(
      controller: controller,
      hint: '$hint',
      onChanged: (str) {
        onChanged(str);
      },
      onFieldSubmitted: onChanged,
    );
  }

  Widget saveButton() {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
      child: AppButton(
          color: pinkButton,
          textColor: Colors.white,
          text: 'บันทึกข้อมูลบริเวณที่เกิดเหตุ',
          onPressed: () {
            crimeSceneOutsideBuilding.sceneTypeDetail =
                _sceneTypeDetailController.text;
            crimeSceneOutsideBuilding.sceneFront = _sceneFrontController.text;
            crimeSceneOutsideBuilding.sceneLeft = _sceneLeftController.text;
            crimeSceneOutsideBuilding.sceneRight = _sceneRightController.text;
            crimeSceneOutsideBuilding.sceneBack = _sceneBackController.text;
            crimeSceneOutsideBuilding.sceneLocation =
                _sceneLocationController.text;

            if (kDebugMode) {
              print('บริเวณ ${_sceneTypeValue.toString()}');
              print('อื่นๆ ${crimeSceneOutsideBuilding.sceneTypeDetail}');
              print('หน้า ${crimeSceneOutsideBuilding.sceneFront}');
              print('ซ้าย ${crimeSceneOutsideBuilding.sceneLeft}');
              print('ขวา ${crimeSceneOutsideBuilding.sceneRight}');
              print('หลัง ${crimeSceneOutsideBuilding.sceneBack}');
              print('สถานที่ ${crimeSceneOutsideBuilding.sceneLocation}');
            }

            FidsCrimeSceneDao().updateSceneExternal(
                _sceneTypeValue.toString(),
                crimeSceneOutsideBuilding.sceneTypeDetail,
                crimeSceneOutsideBuilding.sceneFront,
                crimeSceneOutsideBuilding.sceneLeft,
                crimeSceneOutsideBuilding.sceneRight,
                crimeSceneOutsideBuilding.sceneBack,
                crimeSceneOutsideBuilding.sceneLocation,
                '${widget.caseID}');

            Navigator.of(context).pop(true);
          }),
    );
  }
}
