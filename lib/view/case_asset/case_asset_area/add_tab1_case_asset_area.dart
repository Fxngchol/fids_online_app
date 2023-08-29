import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../Utils/color.dart';
import '../../../models/CaseAreaClue.dart';
import '../../../models/CaseAssetArea.dart';
import '../../../models/UnitMeter.dart';
import '../../../widget/app_bar_widget.dart';
import '../../../widget/app_button.dart';
import '../../../widget/text_field_widget.dart';
import '../../../widget/textfield_modal_bottom_sheet.dart';

class AddTab1CaseAssetArea extends StatefulWidget {
  final int? caseID;
  final String? caseNo;
  final bool isEdit;
  final CaseAssetArea? caseAssetArea;

  const AddTab1CaseAssetArea(
      {super.key,
      this.caseID,
      this.caseNo,
      this.isEdit = false,
      this.caseAssetArea});

  @override
  AddTab1CaseAssetAreaState createState() => AddTab1CaseAssetAreaState();
}

class AddTab1CaseAssetAreaState extends State<AddTab1CaseAssetArea> {
  bool isLoading = true;
  bool isPhone = Device.get().isPhone;
  int clueTypeId = 0;
  bool isDoor = false,
      isWindows = false,
      isCelling = false,
      isRoof = false,
      isClueOther = false,
      isTools1 = false,
      isTools2 = false,
      isTools3 = false,
      isTools4 = false;
  int isDoorValue = 2,
      isWindowsValue = 2,
      isCellingValue = 2,
      isRoofValue = 2,
      isClueOtherValue = 2,
      isTools1Value = 2,
      isTools2Value = 2,
      isTools3Value = 2,
      isTools4Value = 2;
  String? unitId, width = '';

  CaseAreaClue caseAreaClue = CaseAreaClue();

  int isoIsClue = -1;

  TextEditingController labelNoController = TextEditingController();

  TextEditingController clueTypeDetailController = TextEditingController();
  TextEditingController doorDetailController = TextEditingController();
  TextEditingController windowsDetailController = TextEditingController();
  TextEditingController cellingDetailController = TextEditingController();
  TextEditingController roofDetailController = TextEditingController();
  TextEditingController clueOtherDetailController = TextEditingController();

  TextEditingController tools1DetailController = TextEditingController();
  TextEditingController tools2DetailController = TextEditingController();
  TextEditingController tools3DetailController = TextEditingController();
  TextEditingController tools4DetailController = TextEditingController();
  TextEditingController widthController = TextEditingController();
  TextEditingController widthUnitIDController = TextEditingController();
  TextEditingController villainEntranceController = TextEditingController();

  List<UnitMeter> unitMeter = [
    UnitMeter(id: 1, unitLabel: 'เมตร'),
    UnitMeter(id: 2, unitLabel: 'เซนติเมตร'),
    UnitMeter(id: 3, unitLabel: 'มิลลิเมตร'),
  ];

  @override
  void initState() {
    asyncMethod();
    super.initState();
    if (kDebugMode) {
      print('111 ${widget.caseAssetArea?.caseAreaClues?.isClue}');
    }
  }

  asyncMethod() async {
    if (kDebugMode) {
      print('isoIsClueisoIsClueisoIsClue1111 $isoIsClue');
    }

    if (widget.isEdit) {
      if (kDebugMode) {
        print(
            'isoIsClueisoIsClueisoIsClue2222 ${widget.caseAssetArea?.caseAreaClues?.clueTypeID}');
      }

      setState(() {
        caseAreaClue = widget.caseAssetArea?.caseAreaClues ?? CaseAreaClue();
        widget.caseAssetArea?.caseAreaClues?.clueTypeID != null &&
                widget.caseAssetArea?.caseAreaClues?.clueTypeID != ''
            ? clueTypeId =
                int.parse(widget.caseAssetArea?.caseAreaClues?.clueTypeID ?? '')
            : clueTypeId = -1;
        isoIsClue =
            int.parse(widget.caseAssetArea?.caseAreaClues?.isClue ?? '');
        isDoor = caseAreaClue.isDoor == '1' ? true : false;
        isDoorValue = caseAreaClue.isDoor == '1' ? 1 : 2;
        isWindows = caseAreaClue.isWindows == '1' ? true : false;
        isWindowsValue = caseAreaClue.isWindows == '1' ? 1 : 2;
        isCelling = caseAreaClue.isCelling == '1' ? true : false;
        isCellingValue = caseAreaClue.isCelling == '1' ? 1 : 2;
        isRoof = caseAreaClue.isRoof == '1' ? true : false;
        isRoofValue = caseAreaClue.isRoof == '1' ? 1 : 2;
        isClueOther = caseAreaClue.isClueOther == '1' ? true : false;
        isClueOtherValue = caseAreaClue.isClueOther == '1' ? 1 : 2;
        isTools1 = caseAreaClue.isTools1 == '1' ? true : false;
        isTools2 = caseAreaClue.isTools2 == '1' ? true : false;
        isTools3 = caseAreaClue.isTools3 == '1' ? true : false;
        isTools4 = caseAreaClue.isTools4 == '1' ? true : false;
        isTools1Value = caseAreaClue.isTools1 == '1' ? 1 : 2;
        isTools2Value = caseAreaClue.isTools2 == '1' ? 1 : 2;
        isTools3Value = caseAreaClue.isTools3 == '1' ? 1 : 2;
        isTools4Value = caseAreaClue.isTools4 == '1' ? 1 : 2;
        labelNoController.text = caseAreaClue.labelNo ?? '';
        clueTypeDetailController.text = caseAreaClue.clueTypeDetail ?? '';
        doorDetailController.text = caseAreaClue.doorDetail ?? '';
        windowsDetailController.text = caseAreaClue.windowsDetail ?? '';
        cellingDetailController.text = caseAreaClue.cellingDetail ?? '';
        roofDetailController.text = caseAreaClue.roofDetail ?? '';
        clueOtherDetailController.text = caseAreaClue.clueOtherDetail ?? '';
        tools1DetailController.text = caseAreaClue.tools1Detail ?? '';
        tools2DetailController.text = caseAreaClue.tools2Detail ?? '';
        tools3DetailController.text = caseAreaClue.tools3Detail ?? '';
        tools4DetailController.text = caseAreaClue.tools4Detail ?? '';

        widthController.text = caseAreaClue.width ?? '';
        width = caseAreaClue.width;
        widthUnitIDController.text = caseAreaClue.widthUnitID ?? '';
        villainEntranceController.text = caseAreaClue.villainEntrance ?? '';
        // unitId = caseAreaClue.widthUnitID;
      });
    }
  }

//  setupData(caseAreaClue caseAreaClue) {
//
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBarWidget(
        title: 'ทางเข้า',
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
              child: SingleChildScrollView(
                child: isoIsClue != 1
                    ? Column(children: [
                        isoIsclueView(),
                        spacer(),
                        spacer(),
                        saveButton(),
                      ])
                    : Column(children: [
                        isoIsclueView(),
                        spacer(),
                        Padding(
                          padding: const EdgeInsets.all(32),
                          child: clueTypeView(),
                        ),
                        spacer(),
                        clueTypeId == 4
                            ? InputField(
                                hint: 'กรอกร่องรอยอื่นๆ',
                                controller: clueTypeDetailController,
                                onChanged: (value) {})
                            : Container(),
                        spacer(),
                        header('ที่'),
                        spacer(),
                        checkbox('ประตู', isDoor, (value) {
                          setState(() {
                            isDoor = value;
                            isDoor ? isDoorValue = 1 : isDoorValue = 2;
                            if (isDoorValue == 2) {
                              doorDetailController.text = '';
                            }
                            if (kDebugMode) {
                              print(isDoorValue);
                            }
                          });
                        }),
                        spacer(),
                        isDoor
                            ? InputField(
                                hint: 'กรอกรายระเอียด',
                                controller: doorDetailController,
                                onChanged: (value) {})
                            : Container(),
                        spacer(),
                        checkbox('หน้าต่าง', isWindows, (value) {
                          setState(() {
                            isWindows = value;
                            isWindows ? isWindowsValue = 1 : isWindowsValue = 2;
                            if (isWindowsValue == 2) {
                              windowsDetailController.text = '';
                            }
                          });
                        }),
                        spacer(),
                        isWindows
                            ? InputField(
                                hint: 'กรอกรายระเอียด',
                                controller: windowsDetailController,
                                onChanged: (value) {})
                            : Container(),
                        spacer(),
                        checkbox('ฝ้าเพดาน', isCelling, (value) {
                          setState(() {
                            isCelling = value;
                            isCelling == true
                                ? isCellingValue = 1
                                : isCellingValue = 2;
                            if (isCellingValue == 2) {
                              cellingDetailController.text = '';
                            }
                          });
                        }),
                        spacer(),
                        isCelling
                            ? InputField(
                                hint: 'กรอกรายระเอียด',
                                controller: cellingDetailController,
                                onChanged: (value) {})
                            : Container(),
                        spacer(),
                        checkbox('หลังคา', isRoof, (value) {
                          setState(() {
                            isRoof = value;
                            isRoof == true ? isRoofValue = 1 : isRoofValue = 2;
                            if (isRoofValue == 2) {
                              roofDetailController.text = '';
                            }
                          });
                        }),
                        spacer(),
                        isRoof
                            ? InputField(
                                hint: 'กรอกรายระเอียด',
                                controller: roofDetailController,
                                onChanged: (value) {})
                            : Container(),
                        spacer(),
                        checkbox('อื่นๆ', isClueOther, (value) {
                          setState(() {
                            isClueOther = value;
                            isClueOther == true
                                ? isClueOtherValue = 1
                                : isClueOtherValue = 2;
                          });
                        }),
                        spacer(),
                        isClueOther
                            ? InputField(
                                hint: 'กรอกรายระเอียด',
                                controller: clueOtherDetailController,
                                onChanged: (value) {})
                            : Container(),
                        spacer(),
                        header('ป้ายหมายเลข'),
                        spacer(),
                        InputField(
                            hint: 'กรอกป้ายหมายเลข',
                            controller: labelNoController,
                            onChanged: (value) {}),
                        spacer(),
                        header('เครื่องมือที่คนร้ายใช้ในการโจรกรรม'),
                        spacer(),
                        checkbox('ไขควง', isTools1, (value) {
                          setState(() {
                            isTools1 = value;
                            isTools1 == true
                                ? isTools1Value = 1
                                : isTools1Value = 2;
                          });
                        }),
                        isTools1Value == 1
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(top: 12, bottom: 12),
                                child: InputField(
                                    hint: 'กรอกรายระเอียด',
                                    controller: tools1DetailController,
                                    onChanged: (value) {}),
                              )
                            : Container(),
                        spacer(),
                        checkbox('ชะแลง', isTools2, (value) {
                          setState(() {
                            isTools2 = value;
                            isTools2 == true
                                ? isTools2Value = 1
                                : isTools2Value = 2;
                          });
                        }),
                        spacer(),
                        isTools2Value == 1
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(top: 12, bottom: 12),
                                child: InputField(
                                    hint: 'กรอกรายระเอียด',
                                    controller: tools2DetailController,
                                    onChanged: (value) {}),
                              )
                            : Container(),
                        spacer(),
                        checkbox('คีมตัดโลหะ', isTools3, (value) {
                          setState(() {
                            isTools3 = value;
                            isTools3 == true
                                ? isTools3Value = 1
                                : isTools3Value = 2;
                          });
                        }),
                        spacer(),
                        isTools3Value == 1
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(top: 12, bottom: 12),
                                child: InputField(
                                    hint: 'กรอกรายระเอียด',
                                    controller: tools3DetailController,
                                    onChanged: (value) {}),
                              )
                            : Container(),
                        spacer(),
                        checkbox('อื่นๆ', isTools4, (value) {
                          setState(() {
                            isTools4 = value;
                            isTools4 == true
                                ? isTools4Value = 1
                                : isTools4Value = 2;
                          });
                        }),
                        spacer(),
                        isTools4Value == 1
                            ? InputField(
                                hint: 'กรอกเครื่องมืออื่นๆ',
                                controller: tools4DetailController,
                                onChanged: (value) {})
                            : Container(),
                        spacer(),
                        header('ขนาดความกว้างของรอยประมาณ'),
                        spacer(),
                        InputField(
                            hint: 'กรอกความกว้างของรอย',
                            controller: widthController,
                            onChanged: (value) {
                              width = value;
                            }),
                        spacer(),
                        InputField(
                            hint: 'กรอกหน่วย',
                            controller: widthUnitIDController,
                            onChanged: (value) {}),
                        spacer(),
                        spacer(),
                        saveButton()
                      ]),
              )),
        ),
      ),
    );
  }

  checkbox(String? text, bool isChecked, Function onChanged) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Transform.scale(
        scale: 1.7,
        child: Checkbox(
            value: isChecked,
            checkColor: Colors.white,
            activeColor: pinkButton,
            onChanged: (str) {
              onChanged(str);
            }),
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

  clueTypeView() {
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
                  groupValue: clueTypeId,
                  onChanged: (value) {
                    setState(() {
                      clueTypeId = value ?? -1;
                    });
                  }),
            ),
            Text(
              'การงัด',
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
                groupValue: clueTypeId,
                onChanged: (value) {
                  setState(() {
                    clueTypeId = value ?? -1;
                  });
                },
              ),
            ),
            Text(
              'การตัด',
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
                groupValue: clueTypeId,
                onChanged: (value) {
                  setState(() {
                    clueTypeId = value ?? -1;
                  });
                },
              ),
            ),
            Text(
              'การเจาะ',
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
                groupValue: clueTypeId,
                onChanged: (value) {
                  setState(() {
                    clueTypeId = value ?? -1;
                  });
                },
              ),
            ),
            Text(
              'ร่องรอยอื่นๆ',
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

  isoIsclueView() {
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
                  value: 2,
                  activeColor: pinkButton,
                  groupValue: isoIsClue,
                  onChanged: (value) {
                    setState(() {
                      isoIsClue = value ?? -1;
                      if (kDebugMode) {
                        print(isoIsClue);
                      }
                    });
                  }),
            ),
            Text(
              'ไม่พบร่องรอยใดๆ บริเวณสถานที่เกิดเหตุ',
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
                groupValue: isoIsClue,
                onChanged: (value) {
                  setState(() {
                    isoIsClue = value ?? -1;
                    if (kDebugMode) {
                      print(isoIsClue);
                    }
                  });
                },
              ),
            ),
            Text(
              'ผู้เสียหายไม่ได้ทำการปิดล็อคประตู/หน้าต่าง',
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
        title('รายละเอียด'),
        InputField(
            hint: 'กรอกรายละเอียด',
            controller: villainEntranceController,
            onChanged: (value) {
              if (kDebugMode) {
                print(villainEntranceController.text);
              }
            }),
        spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Transform.scale(
              scale: 1.2,
              child: Radio(
                value: 1,
                activeColor: pinkButton,
                groupValue: isoIsClue,
                onChanged: (value) {
                  setState(() {
                    isoIsClue = value ?? -1;
                    if (kDebugMode) {
                      print(isoIsClue);
                    }
                  });
                },
              ),
            ),
            Text(
              'พบร่องรอย',
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

  Widget modal(TextEditingController controller, String? hint, String? title,
      List<UnitMeter> items, int indexSelected) {
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
                                  unitId =
                                      unitMeter[indexSelected].id.toString();
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

  Widget saveButton() {
    return AppButton(
        color: pinkButton,
        textColor: Colors.white,
        text: 'บันทึก',
        onPressed: () async {
          caseAreaClue = CaseAreaClue();
          if (isoIsClue == 1) {
            if (kDebugMode) {
              print('1111111111111111111111111111111111111111');
            }
            caseAreaClue.fidsId = '${widget.caseID}';
            caseAreaClue.isClue = isoIsClue.toString();
            caseAreaClue.clueTypeID = '$clueTypeId';
            caseAreaClue.clueTypeDetail = clueTypeDetailController.text;
            caseAreaClue.isDoor = isDoorValue.toString();
            caseAreaClue.doorDetail = doorDetailController.text;
            caseAreaClue.isWindows = isWindowsValue.toString();
            caseAreaClue.windowsDetail = windowsDetailController.text;
            caseAreaClue.isCelling = isCellingValue.toString();
            caseAreaClue.cellingDetail = cellingDetailController.text;
            caseAreaClue.isRoof = isRoofValue.toString();
            caseAreaClue.roofDetail = roofDetailController.text;
            caseAreaClue.isClueOther = isClueOtherValue.toString();
            caseAreaClue.clueOtherDetail = clueOtherDetailController.text;
            caseAreaClue.labelNo = labelNoController.text;
            caseAreaClue.isTools1 = isTools1Value.toString();
            caseAreaClue.isTools2 = isTools2Value.toString();
            caseAreaClue.isTools3 = isTools3Value.toString();
            caseAreaClue.isTools4 = isTools4Value.toString();
            caseAreaClue.tools1Detail = tools1DetailController.text;
            caseAreaClue.tools2Detail = tools2DetailController.text;
            caseAreaClue.tools3Detail = tools3DetailController.text;
            caseAreaClue.tools4Detail = tools4DetailController.text;
            caseAreaClue.width = widthController.text;
            caseAreaClue.widthUnitID = widthUnitIDController.text == ''
                ? ''
                : widthUnitIDController.text;

            caseAreaClue.caseAssetAreaID =
                (int.parse(widget.caseAssetArea?.id ?? ''));
            caseAreaClue.villainEntrance = '';
          } else {
            if (kDebugMode) {
              print('22222222222222222222222222222222222222222222');
            }
            caseAreaClue.fidsId = '${widget.caseID}';
            caseAreaClue.isClue = isoIsClue.toString();
            caseAreaClue.clueTypeID = '';
            caseAreaClue.clueTypeDetail = '';
            caseAreaClue.isDoor = '';
            caseAreaClue.doorDetail = '';
            caseAreaClue.isWindows = '';
            caseAreaClue.windowsDetail = '';
            caseAreaClue.isCelling = '';
            caseAreaClue.cellingDetail = '';
            caseAreaClue.isRoof = '';
            caseAreaClue.roofDetail = '';
            caseAreaClue.isClueOther = '';
            caseAreaClue.clueOtherDetail = '';
            caseAreaClue.labelNo = '';
            caseAreaClue.isTools1 = '';
            caseAreaClue.isTools2 = '';
            caseAreaClue.isTools3 = '';
            caseAreaClue.isTools4 = '';
            caseAreaClue.tools1Detail = '';
            caseAreaClue.tools2Detail = '';
            caseAreaClue.tools3Detail = '';
            caseAreaClue.tools4Detail = '';
            caseAreaClue.villainEntrance = villainEntranceController.text;
            caseAreaClue.caseAssetAreaID =
                int.parse(widget.caseAssetArea?.id ?? '');
          }
          widget.caseAssetArea?.caseAreaClues = caseAreaClue;
          Navigator.of(context).pop(widget.caseAssetArea);
        });
  }

  String? caseAreaClueLabel(String? id) {
    String? caseAreaClueLabel = '';
    if (id == '1') {
      caseAreaClueLabel = 'การงัด';
    } else if (id == '2') {
      caseAreaClueLabel = 'การตัด';
    } else if (id == '3') {
      caseAreaClueLabel = 'การเจาะ';
    } else if (id == '4') {
      caseAreaClueLabel = 'ร่องรอยอื่นๆ';
    }
    return caseAreaClueLabel;
  }
}
