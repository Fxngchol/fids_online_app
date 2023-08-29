import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../Utils/color.dart';
import '../../../../models/Building.dart';
import '../../../../models/FidsCrimeScene.dart';
import '../../../../widget/app_bar_widget.dart';
import '../../../../widget/app_button.dart';
import '../../../../widget/text_field_widget.dart';
import '../../../../widget/textfield_modal_bottom_sheet.dart';

class AddOutsideBuilding extends StatefulWidget {
  final int? caseID;
  final String? caseNo;
  final bool isLocal;

  const AddOutsideBuilding(
      {super.key, this.caseID, this.caseNo, this.isLocal = false});

  @override
  AddOutsideBuildingState createState() => AddOutsideBuildingState();
}

class AddOutsideBuildingState extends State<AddOutsideBuilding> {
  final TextEditingController _buildingTypeController = TextEditingController();
  final TextEditingController _buildingTypeDetailController =
      TextEditingController();
  final TextEditingController _floorController = TextEditingController();
  final TextEditingController _frontController = TextEditingController();
  final TextEditingController _leftTypeController = TextEditingController();
  final TextEditingController _rightController = TextEditingController();
  final TextEditingController _backController = TextEditingController();
  final TextEditingController _buildingTypeOtherController =
      TextEditingController();

  int _buildingTypeIndexSelected = -1;

  List buildingTypeList = [];
  List<Building> buildingTypes = [];

  int _handleFenceValue = -1;

  bool isPhone = Device.get().isPhone;

  FidsCrimeScene fidsCrimeScene = FidsCrimeScene();
  bool isLoading = true;

  int buildTypeId = -1;

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
    var result2 = await BuildingDao().getBuilding();
    var result3 = await BuildingDao().getBuildingLabel();
    setState(() {
      fidsCrimeScene = result ?? FidsCrimeScene();
      buildingTypes = result2;
      buildingTypeList = result3;
      buildTypeId = fidsCrimeScene.buildingTypeId ?? -1;
      _buildingTypeController.text =
          buildingTypeLabel(fidsCrimeScene.buildingTypeId ?? -1) ?? '';
      _buildingTypeDetailController.text =
          _cleanText(fidsCrimeScene.isoBuildingDetail) ?? '';
      _floorController.text = _cleanText(fidsCrimeScene.floor) ?? '';
      _frontController.text = _cleanText(fidsCrimeScene.sceneFront) ?? '';
      _leftTypeController.text = _cleanText(fidsCrimeScene.sceneLeft) ?? '';
      _rightController.text = _cleanText(fidsCrimeScene.sceneRight) ?? '';
      _backController.text = _cleanText(fidsCrimeScene.sceneBack) ?? '';
      _buildingTypeOtherController.text =
          _cleanText(fidsCrimeScene.buildingTypeOther) ?? '';

      if (fidsCrimeScene.isFence == 1) {
        _handleFenceValue = 1;
      } else {
        _handleFenceValue = 2;
      }
    });
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    if (isLoading) {
      return Container(
        color: darkBlue,
        child: const Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBarWidget(
          title: 'ลักษณะภายนอก',
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
              margin: isPhone
                  ? const EdgeInsets.all(32)
                  : const EdgeInsets.only(
                      left: 32, right: 32, top: 32, bottom: 32),
              child: ListView(
                children: [
                  subtitle('ลักษณะภายนอก', true),
                  spacerTitle(),
                  buildingTypeModal(
                      _buildingTypeController,
                      'เลือกลักษณะภายนอก',
                      'เลือกลักษณะภายนอก',
                      buildingTypeList,
                      _buildingTypeIndexSelected, (index) {
                    setState(() {
                      _buildingTypeIndexSelected = index;
                    });
                    _buildingTypeIndexSelected = index;
                  }, () {
                    setState(() {
                      Navigator.of(context).pop();
                      _buildingTypeController.text =
                          buildingTypes[_buildingTypeIndexSelected].name ?? '';
                      buildTypeId =
                          buildingTypes[_buildingTypeIndexSelected].id ?? -1;
                      if (buildTypeId != 0) {
                        _buildingTypeOtherController.text = '';
                      }
                    });
                  }),
                  spacerTitle(),
                  buildTypeId == 0
                      ? subtitle('ลักษณะอื่นๆ', false)
                      : Container(),
                  buildTypeId == 0 ? spacer() : Container(),
                  buildTypeId == 0
                      ? InputField(
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.newline,
                          controller: _buildingTypeOtherController,
                          hint: 'กรอกลักษณะอื่นๆ',
                          maxLine: null,
                          onChanged: (value) {})
                      : Container(),
                  buildTypeId == 0 ? spacerTitle() : Container(),
                  subtitle('รายละเอียด', true),
                  spacer(),
                  InputField(
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      controller: _buildingTypeDetailController,
                      hint: 'กรอกรายละเอียด',
                      maxLine: null,
                      onChanged: (value) {}),
                  spacerTitle(),
                  subtitle('จำนวนชั้น', false),
                  spacer(),
                  textField(
                      'กรอกจำนวนชั้น', _floorController, (_) => node.unfocus()),
                  spacerTitle(),
                  title('สภาพบริเวณโดยรอบ'),
                  spacer(),
                  frenchView(),
                  spacerTitle(),
                  title('เมื่อหันหน้าเข้าที่เกิดเหตุ'),
                  spacerTitle(),
                  subtitle('ด้านหน้าติด', false),
                  spacer(),
                  InputField(
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      controller: _frontController,
                      hint: 'กรอกข้อมูลด้านหน้า',
                      maxLine: null,
                      onChanged: (value) {}),
                  spacerTitle(),
                  subtitle('ด้านซ้ายติด', false),
                  spacer(),
                  InputField(
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      controller: _leftTypeController,
                      hint: 'กรอกข้อมูลด้านซ้าย',
                      maxLine: null,
                      onChanged: (value) {}),
                  spacerTitle(),
                  subtitle('ด้านขวาติด', false),
                  spacer(),
                  InputField(
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      controller: _rightController,
                      hint: 'กรอกข้อมูลด้านขวา',
                      maxLine: null,
                      onChanged: (value) {}),
                  spacerTitle(),
                  subtitle('ด้านหลังติด', false),
                  spacer(),
                  InputField(
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      controller: _backController,
                      hint: 'กรอกข้อมูลด้านหลัง',
                      maxLine: null,
                      onChanged: (value) {}),
                  spacerTitle(),
                  saveButton()
                ],
              ),
            ),
          ),
        ));
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
              fontSize: MediaQuery.of(context).size.height * 0.03,
            ),
          ),
        ),
      ],
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

  textField(String? hint, TextEditingController controller,
      Function onFieldSubmitted) {
    return InputField(
      controller: controller,
      hint: '$hint',
      onChanged: (_) {},
      onFieldSubmitted: onFieldSubmitted,
    );
  }

  Widget bottomSheetWidget(TextEditingController controller, String? hint,
      String? title, List items, int indexSelected, Function onPressed) {
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
                                      MediaQuery.of(context).size.height * 0.02,
                                ))),
                            onPressed: () {
                              onPressed();
                            },
                          )
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

  Widget buildingTypeModal(
      TextEditingController controller,
      String? hint,
      String? title,
      List items,
      int indexSelected,
      Function onSelectedItemChanged,
      Function onPressed) {
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
                            onPressed: () {
                              onPressed();
                            },
                            child: Text('เลือก',
                                style: GoogleFonts.prompt(
                                    textStyle: TextStyle(
                                  color: darkBlue,
                                  letterSpacing: 0.5,
                                  fontSize:
                                      MediaQuery.of(context).size.height * 0.02,
                                ))),
                          )
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
                        onSelectedItemChanged: (val) {
                          onSelectedItemChanged(val);
                        },
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

  void _handleFenceValueChange(int value) {
    setState(() {
      _handleFenceValue = value;
    });
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
                onChanged: (val) {
                  _handleFenceValueChange(val ?? -1);
                },
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
                onChanged: (val) {
                  _handleFenceValueChange(val ?? -1);
                },
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

  bool validate() {
    return buildTypeId != -1 && _buildingTypeDetailController.text != '';
  }

  Widget saveButton() {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
      child: AppButton(
          color: pinkButton,
          textColor: Colors.white,
          text: 'บันทึกลักษณะที่เกิดเหตุ',
          onPressed: () {
            if (kDebugMode) {
              print(
                  'ลักษณะภายนอก $buildTypeId ${buildingTypeList[_buildingTypeIndexSelected]}');
              print('ลักษณะอื่นๆ ${_buildingTypeOtherController.text}');
              print('รายละเอียด ${_buildingTypeDetailController.text}');
              print('จำนวนชั้น ${_floorController.text}');
              print('มีรั้ว $_handleFenceValue');
              print('หน้า ${_frontController.text}');
              print('ซ้าย ${_leftTypeController.text}');
              print('ขวา ${_rightController.text}');
              print('หลัง ${_backController.text}');
            }

            if (validate()) {
              FidsCrimeSceneDao().updateSceneInternal(
                  buildTypeId,
                  _buildingTypeOtherController.text,
                  _buildingTypeDetailController.text,
                  _floorController.text,
                  _handleFenceValue,
                  _frontController.text,
                  _leftTypeController.text,
                  _rightController.text,
                  _backController.text,
                  '${widget.caseID}');
              Navigator.of(context).pop(true);
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
}
