import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/color.dart';
import '../../../models/Building.dart';
import '../../../models/FidsCrimeScene.dart';
import '../../../widget/app_bar_widget.dart';
import '../../../widget/app_button.dart';
import '../../../widget/text_field_widget.dart';
import '../../../widget/textfield_modal_bottom_sheet.dart';

class EditCrimeSceneFirstTab extends StatefulWidget {
  final int? caseID;
  final bool isEdit;

  const EditCrimeSceneFirstTab({super.key, this.caseID, this.isEdit = false});

  @override
  EditCrimeSceneFirstTabState createState() => EditCrimeSceneFirstTabState();
}

class EditCrimeSceneFirstTabState extends State<EditCrimeSceneFirstTab> {
  bool isLoading = true;
  bool isPhone = Device.get().isPhone;
  int isFenceValue = 0,
      isSceneProtectionValue = 0,
      buildingTypeId = 0,
      buildingTypeIndex = 0;
  List<Building> buildingTypes = [];
  FidsCrimeScene fidsCrimeScene = FidsCrimeScene();

  TextEditingController sceneProtectionDetailsText = TextEditingController();
  TextEditingController buildingTypeText = TextEditingController();
  TextEditingController buildingTypeOtherText = TextEditingController();

  TextEditingController isoBuildingDetailText = TextEditingController();
  TextEditingController floorText = TextEditingController();
  TextEditingController sceneFrontText = TextEditingController();
  TextEditingController sceneLeftText = TextEditingController();
  TextEditingController sceneRightText = TextEditingController();
  TextEditingController sceneBackText = TextEditingController();

  @override
  void initState() {
    asyncMethod();
    // print('widget.isEdit ${widget.isEdit}');
    super.initState();
  }

  asyncMethod() async {
    var buildingTypeList = await BuildingDao().getBuilding();
    if (kDebugMode) {
      print(buildingTypeList);
    }
    buildingTypes = buildingTypeList;
    if (kDebugMode) {
      print(buildingTypes.toString());
    }
    if (widget.isEdit) {
      await FidsCrimeSceneDao()
          .getFidsCrimeSceneById(widget.caseID ?? -1)
          .then((value) async {
        fidsCrimeScene = value ?? FidsCrimeScene();
      });
      setupData(fidsCrimeScene);
    }
    setState(() {
      isLoading = false;
    });
  }

  setupData(FidsCrimeScene fidsCrimeScene) {
    isSceneProtectionValue = fidsCrimeScene.isSceneProtection ?? -1;
    sceneProtectionDetailsText.text =
        fidsCrimeScene.sceneProtectionDetails ?? '';
    buildingTypeId = fidsCrimeScene.buildingTypeId ?? -1;
    buildingTypeText.text =
        buildingTypeLabel(fidsCrimeScene.buildingTypeId ?? -1) ?? '';
    isoBuildingDetailText.text = fidsCrimeScene.isoBuildingDetail ?? '';
    floorText.text = fidsCrimeScene.floor ?? '';
    isFenceValue = fidsCrimeScene.isFence ?? -1;
    sceneFrontText.text = fidsCrimeScene.sceneFront ?? '';
    sceneBackText.text = fidsCrimeScene.sceneBack ?? '';
    sceneLeftText.text = fidsCrimeScene.sceneLeft ?? '';
    sceneRightText.text = fidsCrimeScene.sceneRight ?? '';
    buildingTypeOtherText.text = fidsCrimeScene.buildingTypeOther ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBarWidget(
        title: 'ลักษณะที่เกิดเหตุ',
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
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              margin: isPhone
                  ? const EdgeInsets.all(32)
                  : const EdgeInsets.only(
                      left: 32, right: 32, top: 32, bottom: 32),
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      child: Column(children: [
                        // headerView(),
                        header('การรักษาสถานที่เกิดเหตุ*'),
                        spacer(),
                        sceneProtectionView(),
                        spacer(),
                        InputField(
                            controller: sceneProtectionDetailsText,
                            hint: 'กรอกการรักษาสถานที่เกิดเหตุ',
                            onChanged: (value) {},
                            onFieldSubmitted: (value) {
                              Focus.of(context).nextFocus();
                            }),
                        spacer(),
                        header('ลักษณะที่เกิดเหตุ'),
                        spacer(),
                        title('ลักษณะภายนอก*'),
                        spacer(),
                        modal(
                            buildingTypeText,
                            'ลักษณะภายนอก',
                            'เลือกลักษณะภายนอก',
                            buildingTypes,
                            buildingTypeIndex, (index) {
                          setState(() {
                            buildingTypeIndex = index;
                          });
                        }, () {
                          setState(() {
                            Navigator.of(context).pop();
                            buildingTypeText.text =
                                buildingTypes[buildingTypeIndex].name ?? '';
                            buildingTypeId =
                                buildingTypes[buildingTypeIndex].id ?? -1;
                            if (kDebugMode) {
                              print(buildingTypeId);
                            }
                          });
                        }),
                        spacer(),
                        buildingTypeId == 0
                            ? InputField(
                                controller: buildingTypeOtherText,
                                hint: 'กรอกลักษณะภายนอกอื่นๆ',
                                onChanged: (value) {},
                                onFieldSubmitted: (value) {
                                  Focus.of(context).nextFocus();
                                })
                            : Container(),
                        spacer(),
                        title('รายละเอียด'),
                        spacer(),
                        InputField(
                            controller: isoBuildingDetailText,
                            hint: 'กรอกรายละเอียด',
                            onChanged: (value) {},
                            onFieldSubmitted: (value) {
                              Focus.of(context).nextFocus();
                            }),
                        spacer(),
                        title('จำนวนชั้น'),
                        spacer(),
                        InputField(
                            controller: floorText,
                            hint: 'กรอกจำนวนชั้น',
                            onChanged: (value) {},
                            onFieldSubmitted: (value) {
                              Focus.of(context).unfocus();
                            }),
                        spacer(),
                        title('สภาพบริเวณโดยรอบ'),
                        spacer(),
                        frenchView(),
                        spacer(),
                        title('ด้านหน้าติด'),
                        spacer(),
                        InputField(
                            controller: sceneFrontText,
                            hint: 'กรอกบริเวณด้านหน้า',
                            onChanged: (value) {},
                            onFieldSubmitted: (value) {
                              Focus.of(context).nextFocus();
                            }),
                        spacer(),
                        title('ด้านซ้ายติด'),
                        spacer(),
                        InputField(
                            controller: sceneLeftText,
                            hint: 'กรอกบริเวณด้านซ้าย',
                            onChanged: (value) {},
                            onFieldSubmitted: (value) {
                              Focus.of(context).nextFocus();
                            }),
                        spacer(),
                        title('ด้านขวาติด'),
                        spacer(),
                        InputField(
                            controller: sceneRightText,
                            hint: 'กรอกบริเวณด้านขวา',
                            onChanged: (value) {},
                            onFieldSubmitted: (value) {
                              Focus.of(context).nextFocus();
                            }),
                        spacer(),
                        title('ด้านหลังติด'),
                        spacer(),
                        InputField(
                            controller: sceneBackText,
                            hint: 'กรอกบริเวณด้านหลัง',
                            onChanged: (value) {},
                            onFieldSubmitted: (value) {
                              Focus.of(context).unfocus();
                            }),
                        spacer(),
                        spacer(),
                        saveButton()
                      ]),
                    )),
        ),
      ),
    );
  }

  spacer() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.01,
    );
  }

  Widget header(String? title) {
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

  Widget title(String? title) {
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
                  groupValue: isSceneProtectionValue,
                  onChanged: (value) {
                    setState(() {
                      isSceneProtectionValue = value ?? -1;
                    });
                  }),
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
                groupValue: isSceneProtectionValue,
                onChanged: (value) {
                  setState(() {
                    isSceneProtectionValue = value ?? -1;
                  });
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
      ],
    );
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
                groupValue: isFenceValue,
                onChanged: (vlaue) {
                  setState(() {
                    isFenceValue = vlaue ?? -1;
                  });
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
                groupValue: isFenceValue,
                onChanged: (value) {
                  setState(() {
                    isFenceValue = value ?? -1;
                  });
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

  Widget modal(
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
                  height: MediaQuery.of(context).copyWith().size.height / 2.5,
                  child: Scaffold(
                    appBar: AppBar(
                      backgroundColor: Colors.white,
                      bottomOpacity: 0,
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
                                color: textColor,
                                letterSpacing: 0.5,
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.025,
                              ))),
                          MaterialButton(
                            child: Text('เลือก',
                                style: GoogleFonts.prompt(
                                    textStyle: TextStyle(
                                  color: textColor,
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
                        backgroundColor: whiteOpacity,
                        onSelectedItemChanged: (str) {
                          onSelectedItemChanged(str);
                        },
                        children:
                            List<Widget>.generate(items.length, (int index) {
                          return Center(
                            child: Text(
                              items[index].name,
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
    return isSceneProtectionValue != 0 &&
        isSceneProtectionValue != -1 &&
        buildingTypeId != -1;
  }

  Widget saveButton() {
    return AppButton(
        color: pinkButton,
        textColor: Colors.white,
        text: 'บันทึก',
        onPressed: () {
          if (validate()) {
            bool isNumb = true;
            try {
              if (floorText.text != '') {
                double.parse(floorText.text);
              }
            } catch (ex) {
              isNumb = false;
            }

            if (isNumb) {
              FidsCrimeSceneDao().updateCrimeSceneBomb(
                  isSceneProtectionValue,
                  sceneProtectionDetailsText.text,
                  buildingTypeId,
                  buildingTypeOtherText.text,
                  isoBuildingDetailText.text,
                  floorText.text,
                  isFenceValue,
                  sceneFrontText.text,
                  sceneLeftText.text,
                  sceneRightText.text,
                  sceneBackText.text,
                  widget.caseID.toString());
              Navigator.of(context).pop(true);
            } else {
              final snackBar = SnackBar(
                content: Text(
                  'กรุณากรอกข้อมูลจำนวนชั้นด้วยตัวเลข',
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
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
            ));
          }
        });
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
