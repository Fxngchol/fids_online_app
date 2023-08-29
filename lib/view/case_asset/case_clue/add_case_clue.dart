import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/color.dart';
import '../../../models/CaseClue.dart';
import '../../../widget/app_bar_widget.dart';
import '../../../widget/app_button.dart';
import '../../../widget/text_field_widget.dart';

class AddCaseClue extends StatefulWidget {
  final int? caseID;
  final bool isEdit;
  final String? caseClueID;

  const AddCaseClue(
      {super.key, this.caseID, this.isEdit = false, this.caseClueID});

  @override
  AddCaseClueState createState() => AddCaseClueState();
}

class AddCaseClueState extends State<AddCaseClue> {
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
  int isDoorValue = -1,
      isWindowsValue = -1,
      isCellingValue = -1,
      isRoofValue = -1,
      isClueOtherValue = -1,
      isTools1Value = -1,
      isTools2Value = -1,
      isTools3value = -1,
      isTools4Value = -1;
  String? unitId, width = '';

  CaseClue? caseClue;

  int isoIsClue = -1;

  TextEditingController clueTypeDetailController = TextEditingController();
  TextEditingController doorDetailController = TextEditingController();
  TextEditingController windowsDetailController = TextEditingController();
  TextEditingController cellingDetailController = TextEditingController();
  TextEditingController roofDetailController = TextEditingController();
  TextEditingController clueOtherDetailController = TextEditingController();
  TextEditingController tools4DetailController = TextEditingController();
  TextEditingController widthController = TextEditingController();
  TextEditingController widthUnitIDController = TextEditingController();
  TextEditingController labelNoController = TextEditingController();
  TextEditingController villainEntranceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    asyncMethod();
  }

  asyncMethod() async {
    if (widget.isEdit) {
      if (kDebugMode) {
        print('object');
      }
      await CaseClueDao()
          .getCaseClueById(widget.caseClueID ?? '')
          .then((value) {
        if (kDebugMode) {
          print(value);
        }

        setState(() {
          caseClue = value;
          if (value?.caseClueId != null && value?.caseClueId != '') {
            clueTypeId = int.parse(value?.caseClueId ?? '');
          }
          isoIsClue = int.parse(value?.isoIsClue ?? '');
          isDoor = caseClue?.isDoor == '1' ? true : false;
          isWindows = caseClue?.isWindows == '1' ? true : false;
          isCelling = caseClue?.isCelling == '1' ? true : false;
          isRoof = caseClue?.isRoof == '1' ? true : false;
          isClueOther = caseClue?.isClueOther == '1' ? true : false;
          isTools1 = caseClue?.isTools1 == '1' ? true : false;
          isTools2 = caseClue?.isTools2 == '1' ? true : false;
          isTools3 = caseClue?.isTools3 == '1' ? true : false;
          isTools4 = caseClue?.isTools4 == '1' ? true : false;

          isDoorValue = caseClue?.isDoor == '1' ? 1 : 2;
          isWindowsValue = caseClue?.isWindows == '1' ? 1 : 2;
          isCellingValue = caseClue?.isCelling == '1' ? 1 : 2;
          isRoofValue = caseClue?.isRoof == '1' ? 1 : 2;
          isClueOtherValue = caseClue?.isClueOther == '1' ? 1 : 2;
          isTools1Value = caseClue?.isTools1 == '1' ? 1 : 2;
          isTools2Value = caseClue?.isTools2 == '1' ? 1 : 2;
          isTools3value = caseClue?.isTools3 == '1' ? 1 : 2;
          isTools4Value = caseClue?.isTools4 == '1' ? 1 : 2;

          clueTypeDetailController.text = caseClue?.clueTypeDetail ?? '';
          doorDetailController.text = caseClue?.doorDetail ?? '';
          windowsDetailController.text = caseClue?.windowsDetail ?? '';
          cellingDetailController.text = caseClue?.cellingDetail ?? '';
          roofDetailController.text = caseClue?.roofDetail ?? '';
          clueOtherDetailController.text = caseClue?.clueOtherDetail ?? '';
          tools4DetailController.text = caseClue?.tools4Detail ?? '';
          widthController.text = caseClue?.width ?? '';
          width = caseClue?.width;
          widthUnitIDController.text = caseClue?.widthUnitID ?? '';
          unitId = caseClue?.widthUnitID;
          labelNoController.text = caseClue?.labelNo ?? '';
          villainEntranceController.text = caseClue?.villainEntrance ?? '';
        });
      });
    }
  }

//  setupData(CaseClue caseClue) {
//
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBarWidget(
        title: 'ทางเข้าของคนร้าย',
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
                        saveButton(),
                      ])
                    : Column(children: [
                        isoIsclueView(),
                        spacer(),
                        header('ป้ายหมายเลข'),
                        spacer(),
                        InputField(
                            hint: 'กรอกป้ายหมายเลข',
                            controller: labelNoController,
                            onChanged: (value) {}),
                        spacer(),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 12, right: 12, top: 12, bottom: 12),
                          child: clueTypeView(),
                        ),
                        spacer(),
                        InputField(
                            hint: 'กรอกร่องรอยอื่นๆ',
                            controller: clueTypeDetailController,
                            onChanged: (value) {}),
                        spacer(),
                        header('ที่'),
                        spacer(),
                        checkbox('ประตู', isDoor, (value) {
                          setState(() {
                            isDoor = value;
                            isDoor == true ? isDoorValue = 1 : isDoorValue = 2;
                            if (kDebugMode) {
                              print(isDoorValue);
                            }
                          });
                        }),
                        spacer(),
                        InputField(
                            hint: 'กรอกรายระเอียด',
                            controller: doorDetailController,
                            onChanged: (value) {}),
                        spacer(),
                        checkbox('หน้าต่าง', isWindows, (value) {
                          setState(() {
                            isWindows = value;
                            isWindows == true
                                ? isWindowsValue = 1
                                : isWindowsValue = 2;
                          });
                        }),
                        spacer(),
                        InputField(
                            hint: 'กรอกรายระเอียด',
                            controller: windowsDetailController,
                            onChanged: (value) {}),
                        spacer(),
                        checkbox('ฝ้าเพดาน', isCelling, (value) {
                          setState(() {
                            isCelling = value;
                            isCelling == true
                                ? isCellingValue = 1
                                : isCellingValue = 2;
                          });
                        }),
                        spacer(),
                        InputField(
                            hint: 'กรอกรายระเอียด',
                            controller: cellingDetailController,
                            onChanged: (value) {}),
                        spacer(),
                        checkbox('หลังคา', isRoof, (value) {
                          setState(() {
                            isRoof = value;
                            isRoof == true ? isRoofValue = 1 : isRoofValue = 2;
                          });
                        }),
                        spacer(),
                        InputField(
                            hint: 'กรอกรายระเอียด',
                            controller: roofDetailController,
                            onChanged: (value) {}),
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
                        InputField(
                            hint: 'กรอกรายระเอียด',
                            controller: clueOtherDetailController,
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
                        checkbox('คีมตัดโลหะ', isTools3, (value) {
                          setState(() {
                            isTools3 = value;
                            isTools3 == true
                                ? isTools3value = 1
                                : isTools3value = 2;
                          });
                        }),
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
                        InputField(
                            hint: 'กรอกเครื่องมืออื่นๆ',
                            controller: tools4DetailController,
                            onChanged: (value) {}),
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
                  toggleable: true,
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
                toggleable: true,
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
                toggleable: true,
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
                toggleable: true,
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
            onChanged: (value) {}),
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

  Widget saveButton() {
    return AppButton(
        color: pinkButton,
        textColor: Colors.white,
        text: 'บันทึก',
        onPressed: () async {
          // bool isNumb = true;
          // try {
          //   if (width != '') {
          //     double.parse(width);
          //   }
          // } catch (ex) {
          //   isNumb = false;
          // }

          String isClue = '';
          if (isoIsClue == 1 || isoIsClue == 2 || isoIsClue == 3) {
            isClue = '$isoIsClue';
          } else {
            isClue = '';
          }

          if (widget.isEdit) {
            if (kDebugMode) {
              print("testtt :${isRoofValue.toString()}");
            }

            await CaseClueDao()
                .updateCaseClueDao(
                    clueTypeId == 0 ? '' : clueTypeId.toString(),
                    isClue,
                    clueTypeDetailController.text,
                    isDoorValue.toString(),
                    doorDetailController.text,
                    isWindowsValue.toString(),
                    windowsDetailController.text,
                    isCellingValue.toString(),
                    cellingDetailController.text,
                    isRoofValue.toString(),
                    roofDetailController.text,
                    isClueOtherValue.toString(),
                    clueOtherDetailController.text,
                    isTools1Value.toString(),
                    '',
                    isTools2Value.toString(),
                    '',
                    isTools3value.toString(),
                    '',
                    isTools4Value.toString(),
                    tools4DetailController.text,
                    width.toString(),
                    widthUnitIDController.text,
                    labelNoController.text,
                    villainEntranceController.text,
                    caseClue?.id)
                .then((value) => Navigator.of(context).pop(true));
          } else {
            if (kDebugMode) {
              print(clueTypeId.toString());
            }
            await CaseClueDao()
                .createCaseClueDao(
                    widget.caseID ?? -1,
                    clueTypeId == 0 ? '' : clueTypeId.toString(),
                    isClue,
                    clueTypeDetailController.text,
                    isDoorValue.toString(),
                    doorDetailController.text,
                    isWindowsValue.toString(),
                    windowsDetailController.text,
                    isCellingValue.toString(),
                    cellingDetailController.text,
                    isRoofValue.toString(),
                    roofDetailController.text,
                    isClueOtherValue.toString(),
                    clueOtherDetailController.text,
                    isTools1Value.toString(),
                    '',
                    isTools2Value.toString(),
                    '',
                    isTools3value.toString(),
                    '',
                    isTools4Value.toString(),
                    tools4DetailController.text,
                    width.toString(),
                    widthUnitIDController.text,
                    labelNoController.text,
                    villainEntranceController.text)
                .then((value) => Navigator.of(context).pop(true));
          }
        });
  }

  String? caseClueLabel(String? id) {
    String? caseClueLabel = '';
    if (id == '1') {
      caseClueLabel = 'การงัด';
    } else if (id == '2') {
      caseClueLabel = 'การตัด';
    } else if (id == '3') {
      caseClueLabel = 'การเจาะ';
    } else if (id == '4') {
      caseClueLabel = 'ร่องรอยอื่นๆ';
    }
    return caseClueLabel;
  }
}
