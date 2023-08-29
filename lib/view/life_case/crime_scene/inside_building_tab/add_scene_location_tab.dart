import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../Utils/color.dart';
import '../../../../models/CaseSceneLocation.dart';
import '../../../../models/Unit.dart';
import '../../../../models/UnitMeter.dart';
import '../../../../widget/app_bar_widget.dart';
import '../../../../widget/app_button.dart';
import '../../../../widget/text_field_widget.dart';
import '../../../../widget/textfield_modal_bottom_sheet.dart';

class AddSceneLocation extends StatefulWidget {
  final int? caseID, caseSceneLocationId;
  final String? caseNo;
  final bool? isLocal;
  final bool isEdit;
  const AddSceneLocation(
      {super.key,
      this.caseSceneLocationId,
      this.caseID,
      this.caseNo,
      this.isLocal = false,
      this.isEdit = false});

  @override
  AddSceneLocationState createState() => AddSceneLocationState();
}

class AddSceneLocationState extends State<AddSceneLocation> {
  bool isPhone = Device.get().isPhone;
  List<UnitMeter> unitMeter = [
    UnitMeter(id: 1, unitLabel: 'เมตร'),
    UnitMeter(id: 2, unitLabel: 'เซนติเมตร')
  ];
  final int _unitId = 0;
  final int _unitIndexSelected = 0;

  List<Unit> units = [];

  int unitId = -1;
  CaseSceneLocation caseSceneLocation = CaseSceneLocation();

  final TextEditingController _sceneLocationController =
      TextEditingController();
  final TextEditingController _sceneLocationSizeController =
      TextEditingController();
  final TextEditingController _unitController = TextEditingController();
  final TextEditingController _structureController = TextEditingController();
  final TextEditingController _frontWallController = TextEditingController();
  final TextEditingController _leftWallController = TextEditingController();
  final TextEditingController _rightWallController = TextEditingController();
  final TextEditingController _backWallController = TextEditingController();
  final TextEditingController _roomFloorController = TextEditingController();
  final TextEditingController _roofController = TextEditingController();
  final TextEditingController _placementController = TextEditingController();
  final TextEditingController _frontLeftToRighController =
      TextEditingController();
  final TextEditingController _leftFrontToBackController =
      TextEditingController();
  final TextEditingController _rightFrontToBackController =
      TextEditingController();
  final TextEditingController _backLeftToRightController =
      TextEditingController();
  final TextEditingController _ceilingController = TextEditingController();
  final TextEditingController _areaOtherController = TextEditingController();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    asyncMethod();
    if (widget.isEdit) {
      asyncgetCaseSceneLocationById();
    }
  }

  void asyncgetCaseSceneLocationById() async {
    await CaseSceneLocationDao()
        .getCaseSceneLocationById(
            widget.caseSceneLocationId ?? -1, widget.caseID ?? -1)
        .then((value) {
      setState(() {
        caseSceneLocation = value;
        _sceneLocationController.text = caseSceneLocation.sceneLocation ?? '';
        _sceneLocationSizeController.text =
            caseSceneLocation.sceneLocationSize ?? '';

        if (caseSceneLocation.unitId != null) {
          unitId = int.parse(caseSceneLocation.unitId ?? '');
        }

        _unitController.text =
            caseSceneLocation.unitId == '1' ? 'เมตร' : 'เซนติเมตร';
        _structureController.text = caseSceneLocation.buildingStructure ?? '';
        _frontWallController.text = caseSceneLocation.buildingWallFront ?? '';
        _leftWallController.text = caseSceneLocation.buildingWallLeft ?? '';
        _rightWallController.text = caseSceneLocation.buildingWallRight ?? '';
        _backWallController.text = caseSceneLocation.buildingWallBack ?? '';
        _roomFloorController.text = caseSceneLocation.roomFloor ?? '';
        _roofController.text = caseSceneLocation.roof ?? '';
        _placementController.text = caseSceneLocation.placement ?? '';
        _ceilingController.text = caseSceneLocation.ceiling ?? '';
        _areaOtherController.text = caseSceneLocation.areaOther ?? '';
        _frontLeftToRighController.text =
            caseSceneLocation.frontLeftToRight ?? '';
        _leftFrontToBackController.text =
            caseSceneLocation.leftFrontToBack ?? '';
        _rightFrontToBackController.text =
            caseSceneLocation.rightFrontToBack ?? '';
        _backLeftToRightController.text =
            caseSceneLocation.backLeftToRight ?? '';
      });
    });
  }

  asyncMethod() async {
    asyncCall1();
  }

  void asyncCall1() async {
    var result = await UnitDao().getUnit();
    setState(() {
      units = result;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBarWidget(
        title: 'เพิ่มลักษณะภายใน',
        actions: [
          Container(
            width: MediaQuery.of(context).size.width * 0.1,
          )
        ],
        leading: IconButton(
          icon: isIOS
              ? const Icon(Icons.arrow_back_ios)
              : const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
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
                subtitle('เกิดเหตุที่', true),
                spacer(),
                InputField(
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    controller: _sceneLocationController,
                    hint: 'กรอกสถานที่เกิดเหตุ',
                    maxLine: null,
                    onChanged: (value) {}),
                spacerTitle(),
                subtitle('มีขนาดกว้างxยาว', false),
                spacer(),
                InputField(
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    controller: _sceneLocationSizeController,
                    hint: 'กรอกความกว้าง',
                    maxLine: null,
                    onChanged: (value) {}),
                spacerTitle(),
                subtitle('หน่วย', false),
                spacer(),
                casetypeModal(_unitController, 'กรุณาเลือกหน่วย', 'เลือกหน่วย',
                    unitMeter, _unitIndexSelected),
                spacerTitle(),
                subtitle('ลักษณะโครงสร้าง', false),
                spacer(),
                InputField(
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    controller: _structureController,
                    hint: 'กรอกลักษณะโครงสร้าง',
                    maxLine: null,
                    onChanged: (value) {}),
                spacerTitle(),
                subtitle('ผนังด้านหน้า', false),
                spacer(),
                InputField(
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    controller: _frontWallController,
                    hint: 'กรอกผนังด้านหน้า',
                    maxLine: null,
                    onChanged: (value) {}),
                spacerTitle(),
                subtitle('ผนังด้านซ้าย', false),
                spacer(),
                InputField(
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    controller: _leftWallController,
                    hint: 'กรอกผนังด้านซ้าย',
                    maxLine: null,
                    onChanged: (value) {}),
                spacerTitle(),
                subtitle('ผนังด้านขวา', false),
                spacer(),
                InputField(
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    controller: _rightWallController,
                    hint: 'กรอกผนังด้านขวา',
                    maxLine: null,
                    onChanged: (value) {}),
                spacerTitle(),
                subtitle('ผนังด้านหลัง', false),
                spacer(),
                InputField(
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    controller: _backWallController,
                    hint: 'กรอกผนังด้านหลัง',
                    maxLine: null,
                    onChanged: (value) {}),
                spacerTitle(),
                subtitle('พื้นห้อง', false),
                spacer(),
                InputField(
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    controller: _roomFloorController,
                    hint: 'กรอกพื้นห้อง',
                    maxLine: null,
                    onChanged: (value) {}),
                spacerTitle(),
                subtitle('หลังคา', false),
                spacer(),
                InputField(
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    controller: _roofController,
                    hint: 'กรอกหลังคา',
                    maxLine: null,
                    onChanged: (value) {}),
                spacerTitle(),
                subtitle('ฝ้า/เพดาน', false),
                spacer(),
                InputField(
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    controller: _ceilingController,
                    hint: 'กรอกฝ้า/เพดาน',
                    maxLine: null,
                    onChanged: (value) {}),
                spacer(),
                spacerTitle(),
                title('ลักษณะการจัดวางสิ่งของ'),
                spacerTitle(),
                subtitle('ชิดฝาผนังด้านหน้าเรียงจากซ้ายไปขวา', false),
                spacer(),
                InputField(
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    controller: _frontLeftToRighController,
                    hint: 'กรอกข้อมูล',
                    maxLine: null,
                    onChanged: (value) {}),
                spacerTitle(),
                subtitle('ชิดฝาผนังด้านซ้ายเรียงจากหน้าไปหลัง', false),
                spacer(),
                InputField(
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    controller: _leftFrontToBackController,
                    hint: 'กรอกข้อมูล',
                    maxLine: null,
                    onChanged: (value) {}),
                spacerTitle(),
                subtitle('ชิดฝาผนังด้านขวาเรียงจากหน้าไปหลัง', false),
                spacer(),
                InputField(
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    controller: _rightFrontToBackController,
                    hint: 'กรอกข้อมูล',
                    maxLine: null,
                    onChanged: (value) {}),
                spacerTitle(),
                subtitle('ชิดฝาผนังด้านหลังเรียงจากซ้ายไปขวา', false),
                spacer(),
                InputField(
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    controller: _backLeftToRightController,
                    hint: 'กรอกข้อมูล',
                    maxLine: null,
                    onChanged: (value) {}),
                spacerTitle(),
                subtitle('บริเวณอื่นๆ', false),
                spacer(),
                InputField(
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    controller: _areaOtherController,
                    hint: 'กรอกข้อมูล',
                    maxLine: null,
                    onChanged: (value) {}),
                spacerTitle(),
                saveButton()
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

  Widget subtitle(String? title, bool isRequire) {
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
        isRequire
            ? Text(
                '*',
                style: GoogleFonts.prompt(
                  textStyle: TextStyle(
                    color: Colors.white,
                    letterSpacing: 0.5,
                    fontSize: MediaQuery.of(context).size.height * 0.025,
                  ),
                ),
              )
            : Text(
                '',
                style: GoogleFonts.prompt(
                  textStyle: TextStyle(
                    color: Colors.white,
                    letterSpacing: 0.5,
                    fontSize: MediaQuery.of(context).size.height * 0.025,
                  ),
                ),
              )
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

  textField(
    TextEditingController controller,
    String? hint,
    Function onChanged,
    Function onFieldSubmitted,
  ) {
    return InputField(
      controller: controller,
      hint: '$hint',
      onChanged: (str) {
        onChanged(str);
      },
      onFieldSubmitted: onFieldSubmitted,
      maxLine: null,
    );
  }

  Widget casetypeModal(TextEditingController controller, String? hint,
      String? title, List<UnitMeter> items, int indexSelected) {
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
                                  if (kDebugMode) {
                                    print(items[indexSelected].id);
                                  }
                                  controller.text =
                                      items[indexSelected].unitLabel ?? '';
                                  unitId = units[indexSelected].id ?? -1;
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
                              if (kDebugMode) {
                                print(items[index].id);
                              }
                            }),
                        children:
                            List<Widget>.generate(items.length, (int index) {
                          return Center(
                            child: Text(
                              items[index].unitLabel ?? '',
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

  bool validate() {
    return _sceneLocationController.text != '';
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
              print('เกิดเหตุที่ ${_sceneLocationController.text}');
              print('ความกว้างxยาว ${_sceneLocationSizeController.text}');
              print('หน่วย $_unitId');
              print('ลักษณะโครงสร้าง ${_structureController.text}');
              print('ผนังด้านหน้า ${_frontWallController.text}');
              print('ผนังด้านซ้าย ${_leftWallController.text}');
              print('ผนังด้านขวา ${_rightWallController.text}');
              print('ผนังด้านหลัง ${_backWallController.text}');
              print('พื้นห้อง ${_roomFloorController.text}');
              print('หลังคา ${_roofController.text}');
              print('ลักษณะการจัดวางสิ่งของ ${_placementController.text}');
            }

            if (validate()) {
              if (widget.isEdit) {
                CaseSceneLocationDao().updateCaseSceneLocation(
                  _sceneLocationController.text,
                  _sceneLocationSizeController.text,
                  unitId,
                  _structureController.text,
                  _frontWallController.text,
                  _leftWallController.text,
                  _rightWallController.text,
                  _backWallController.text,
                  _roomFloorController.text,
                  _roofController.text,
                  _placementController.text,
                  _ceilingController.text,
                  _areaOtherController.text,
                  _frontLeftToRighController.text,
                  _leftFrontToBackController.text,
                  _rightFrontToBackController.text,
                  _backLeftToRightController.text,
                  '',
                  '',
                  '',
                  '',
                  1,
                  widget.caseSceneLocationId ?? -1,
                );
                Navigator.of(context).pop(true);
              } else {
                CaseSceneLocationDao().createCaseSceneLocation(
                    _sceneLocationController.text,
                    _sceneLocationSizeController.text,
                    unitId,
                    _structureController.text,
                    _frontWallController.text,
                    _leftWallController.text,
                    _rightWallController.text,
                    _backWallController.text,
                    _roomFloorController.text,
                    _roofController.text,
                    _placementController.text,
                    _ceilingController.text,
                    _areaOtherController.text,
                    _frontLeftToRighController.text,
                    _leftFrontToBackController.text,
                    _rightFrontToBackController.text,
                    _backLeftToRightController.text,
                    widget.caseID ?? -1,
                    '',
                    '',
                    '',
                    '',
                    1);
                Navigator.of(context).pop(true);
              }
            } else {
              final snackBar = SnackBar(
                content: Text(
                  'กรุณากรอกข้อมูลที่มีเครื่องหมายดอกจัน (*) ให้​ครบถ้วน',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.prompt(
                    textStyle: TextStyle(
                      color: Colors.white,
                      letterSpacing: .5,
                      fontSize: MediaQuery.of(context).size.height * 0.02,
                    ),
                  ),
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          }),
    );
  }
}
