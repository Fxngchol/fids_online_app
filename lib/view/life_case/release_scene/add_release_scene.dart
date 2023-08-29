// ignore_for_file: must_be_immutable, unnecessary_import, depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:screenshot/screenshot.dart';
import 'package:signature/signature.dart';

import '../../../Utils/color.dart';
import '../../../models/CaseCategory.dart';
import '../../../models/CaseInspector.dart';
import '../../../models/FidsCrimeScene.dart';
import '../../../models/Position.dart';
import '../../../models/Title.dart';
import '../../../widget/app_bar_widget.dart';
import '../../../widget/app_button.dart';
import '../../../widget/text_field_widget.dart';
import '../../../widget/textfield_modal_bottom_sheet.dart';
import '../inspector_case/select_inspector.dart';
import '../request_case/select_title.dart'; //for date format

class AddReleaseScene extends StatefulWidget {
  final int? caseID;
  final String? caseNo;
  final bool? isLocal;
  bool? receiveIsSign;
  bool? senderIsSign;

  AddReleaseScene(
      {super.key,
      this.caseID,
      this.isLocal = false,
      this.caseNo,
      this.receiveIsSign = false,
      this.senderIsSign = false});

  @override
  AddReleaseSceneState createState() => AddReleaseSceneState();
}

class AddReleaseSceneState extends State<AddReleaseScene> {
  String? closeDateTime = '', sendPersonId;
  String? recieve64string, sender64string;
  String? sendSignatureBase64, receiveSignatureBase64;
  bool hasSendSignatureBase64 = false, hasReceiveSignatureBase64 = false;
  int? titleId;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isFinal = false;
  bool _isComplete = false;
  bool _isDelivery = false;
  bool isLoading = true;
  bool isPhone = Device.get().isPhone;
  String? caseName;

  MyTitle selectedTitle = MyTitle();
  FidsCrimeScene data = FidsCrimeScene();
  CaseInspector personalSelected = CaseInspector();

  List<MyTitle> titleList = [];
  List<CaseInspector> personalList = [];
  List<Position> positionList = [];

  final TextEditingController _closeDateController = TextEditingController();
  final TextEditingController _closeTimeController = TextEditingController();
  final TextEditingController _receiveTitleIdController =
      TextEditingController();
  final TextEditingController _receiveNameController = TextEditingController();
  final TextEditingController _receivePositionController =
      TextEditingController();
  final TextEditingController _senderPositionController =
      TextEditingController();
  final TextEditingController _sendPersonIdController = TextEditingController();
  final ScreenshotController _recieveScreenshotController =
      ScreenshotController();
  final ScreenshotController _senderScreenshotController =
      ScreenshotController();

  final SignatureController _recieveController = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  final SignatureController _senderController = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  @override
  void initState() {
    super.initState();
    asyncMethod();
  }

  asyncMethod() async {
    asyncCall1();
    if (kDebugMode) {
      print(widget.caseID ?? -1);
    }

    setState(() {
      isLoading = false;
    });
  }

  void asyncCall1() async {
    var titles = await TitleDao().getTitle();
    var personals =
        await CaseInspectorDao().getCaseInspector(widget.caseID ?? -1);
    await FidsCrimeSceneDao()
        .getFidsCrimeSceneById(widget.caseID ?? -1)
        .then((value) => data = value ?? FidsCrimeScene());
    var positionResult = await PositionDao().getPosition();

    await CaseCategoryDAO()
        .getCaseCategoryLabelByid(data.caseCategoryID ?? -1)
        .then((value) => caseName = value);
    if (kDebugMode) {
      print('caseName: $caseName');
    }

    titleList = titles;
    personalList = personals;
    positionList = positionResult;

    setState(() {
      _closeDateController.text = data.closeDate ?? '';
      _closeTimeController.text = data.closeTime ?? '';
      _receiveTitleIdController.text = titleLabel(data.receiveTitleID) ?? '';
      data.receiveTitleID != '' && data.receiveTitleID != null
          ? titleId = int.parse(data.receiveTitleID ?? '')
          : titleId = -1;
      _receiveNameController.text = data.receiveName ?? '';
      _receivePositionController.text = data.receivePosition ?? '';
      _sendPersonIdController.text = personalLabel(data.sendPersonID) ?? '';
      sendPersonId = data.sendPersonID ?? '';

      var posId = getPositionId(data.sendPersonID);
      _senderPositionController.text = _positionLabel(posId) ?? '';

      if (data.isoIsFinal == 1) {
        _isFinal = true;
      } else {
        _isFinal = false;
      }

      if (data.isoIsComplete == 1) {
        _isComplete = true;
      } else {
        _isComplete = false;
      }

      if (data.isoIsDeliver == 1) {
        _isDelivery = true;
      } else {
        _isDelivery = false;
      }

      if (data.receiveSignature != null && data.receiveSignature != '') {
        recieve64string =
            data.receiveSignature?.replaceAll("data:image/png;base64,", "");
        hasReceiveSignatureBase64 = true;
        if (kDebugMode) {
          print('fong $recieve64string');
        }
      }

      if (data.sendSignature != null && data.sendSignature != '') {
        sender64string =
            data.sendSignature?.replaceAll("data:image/png;base64,", "");
        hasSendSignatureBase64 = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // if (isLoading) {
    //   return Container(
    //     color: darkBlue,
    //     child: Center(child: CircularProgressIndicator()),
    //   );
    // }
    return Scaffold(
      key: _scaffoldKey,
      extendBodyBehindAppBar: true,
      appBar: AppBarWidget(
        title: 'การส่งมอบสถานที่เกิดเหตุ',
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
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : Container(
                  margin: isPhone
                      ? const EdgeInsets.all(32)
                      : const EdgeInsets.only(
                          left: 32, right: 32, top: 32, bottom: 32),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        headerView(),
                        checkbox('การตรวจสอบครั้งสุดท้าย', _isFinal, (value) {
                          setState(() {
                            _isFinal = value;
                          });
                        }),
                        spacer(),
                        checkbox('ตรวจเก็บวัตถุพยานครบถ้วน', _isComplete,
                            (value) {
                          setState(() {
                            _isComplete = value;
                          });
                        }),
                        spacer(),
                        checkbox(
                            'ถ่ายภาพสถานที่เกิดเหตุและดำเนินการส่งมอบสถานที่เกิดเหตุให้แก่พนักงานสอบสวน',
                            _isDelivery, (value) {
                          setState(() {
                            _isDelivery = value;
                          });
                        }),
                        spacerTitle(),
                        spacerTitle(),
                        title('วันเวลาที่ทำการตรวจสถานที่เกิดเหตุเสร็จสิ้น'),
                        spacerTitle(),
                        subtitle('วันที่'),
                        spacer(),
                        closeDate(),
                        spacer(),
                        subtitle('เวลา'),
                        spacer(),
                        closeTimeView(),
                        spacer(),
                        title('ลงชื่อผู้รับมอบสถานที่เกิดเหตุ'),
                        spacer(),
                        recieveSignatureView(),
                        spacer(),
                        subtitle('คำนำหน้า'),
                        spacer(),
                        textfieldWithBtnTitle(),
                        spacer(),
                        InputField(
                            controller: _receiveNameController,
                            hint: 'ชื่อ',
                            onChanged: (_) {}),
                        spacer(),
                        InputField(
                            controller: _receivePositionController,
                            hint: 'กรอกตำแหน่ง',
                            onChanged: (_) {}),
                        spacer(),
                        title('ลงชื่อผู้ส่งมอบสถานที่เกิดเหตุ'),
                        spacer(),
                        senderSignatureView(),
                        spacer(),
                        personalSelectPage(),
                        spacer(),
                        InputField(
                            isEnabled: false,
                            controller: _senderPositionController,
                            hint: 'กรอกตำแหน่ง',
                            onChanged: (_) {}),
                        spacer(),
                        saveButton()
                      ],
                    ),
                  ),
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

  checkbox(String? text, bool isChecked, Function onChanged) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Transform.scale(
        scale: 1.7,
        child: Checkbox(
            value: isChecked,
            checkColor: Colors.white,
            activeColor: pinkButton,
            onChanged: (val) {
              onChanged(val);
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
              fontSize: MediaQuery.of(context).size.height * 0.028,
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

  closeDate() {
    return TextFieldModalBottomSheet(
      controller: _closeDateController,
      hint: 'กรุณาเลือกวันที่',
      onPress: () async {
        DateTime? newDateTime = await showRoundedDatePicker(
            theme: ThemeData(
              primarySwatch: Colors.pink,
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  textStyle: GoogleFonts.prompt(
                      textStyle: TextStyle(
                    color: pinkButton,
                    letterSpacing: .5,
                    fontSize: isPhone
                        ? MediaQuery.of(context).size.height * 0.018
                        : MediaQuery.of(context).size.height * 0.025,
                    fontWeight: FontWeight.bold,
                  )),
                ),
              ),
            ),
            fontFamily: GoogleFonts.prompt().fontFamily,
            context: context,
            initialDate: DateTime.now(),
            borderRadius: 16,
            locale: const Locale("th", "TH"),
            era: EraMode.BUDDHIST_YEAR);

        setState(() {
          final dateFormat = DateFormat('dd/MM/yyyy');
          var result = convertToBudd(dateFormat.format(newDateTime!));
          _closeDateController.text = result ?? '';
          closeDateTime =
              DateFormat('dd/MM/yyyy').parse(result ?? '').toString();
        });
      },
    );
  }

  String? convertToBudd(String? date) {
    var start = date?.substring(0, 6);
    var process = date?.substring(6, 10);
    var cal = int.parse(process ?? '') + 543;
    var result = '$start$cal';
    return result;
  }

  closeTimeView() {
    var timeformat = DateFormat('HH:mm');
    return TextFieldModalBottomSheet(
      controller: _closeTimeController,
      hint: 'กรุณาเลือกเวลา',
      onPress: () => {
        FocusScope.of(context).unfocus(),
        // _closeTimeController.text = timeformat.format(now),
        DatePicker.showTimePicker(context,
            showSecondsColumn: false,
            // theme: DatePickerTheme(
            //   containerHeight: MediaQuery.of(context).size.height / 2.5,
            //   doneStyle: TextStyle(
            //       fontFamily: GoogleFonts.prompt().fontFamily,
            //       fontSize: MediaQuery.of(context).size.height * 0.017,
            //       color: darkBlue),
            //   cancelStyle: TextStyle(
            //       fontFamily: GoogleFonts.prompt().fontFamily,
            //       fontSize: MediaQuery.of(context).size.height * 0.017,
            //       color: Colors.grey),
            //   itemStyle: TextStyle(
            //       fontFamily: GoogleFonts.prompt().fontFamily,
            //       fontSize: MediaQuery.of(context).size.height * 0.018,
            //       color: darkBlue),
            // ),
            showTitleActions: true,
            onChanged: (date) {}, onConfirm: (date) {
          if (kDebugMode) {
            print('TEST');
          }
          var inputDate = timeformat.format(date);
          closeDateTime = inputDate;
          _closeTimeController.text = inputDate;
          if (kDebugMode) {
            print(closeDateTime);
          }
        }, currentTime: DateTime.now(), locale: LocaleType.th)
      },
    );
  }

  recieveSignatureView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        hasReceiveSignatureBase64
            ? Image.memory(base64Decode(recieve64string ?? ''))
            : Screenshot(
                controller: _recieveScreenshotController,
                child: Signature(
                  controller: _recieveController,
                  height: 300,
                  backgroundColor: Colors.white,
                ),
              ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: pinkButton,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 8),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    hasReceiveSignatureBase64 = false;
                    recieve64string = '';
                  });
                  _recieveController.clear();
                  widget.receiveIsSign = false;
                },
                child: Text(
                  'Clear Signature',
                  textAlign: TextAlign.left,
                  style: GoogleFonts.prompt(
                    textStyle: TextStyle(
                      color: Colors.white,
                      letterSpacing: .5,
                      fontSize: MediaQuery.of(context).size.height * 0.02,
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  senderSignatureView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        hasSendSignatureBase64
            ? Image.memory(base64Decode(sender64string ?? ''))
            : Screenshot(
                controller: _senderScreenshotController,
                child: Signature(
                  controller: _senderController,
                  height: 300,
                  backgroundColor: Colors.white,
                ),
              ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: pinkButton,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 8),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    hasSendSignatureBase64 = false;
                    sender64string = '';
                  });
                  _senderController.clear();
                  widget.senderIsSign = false;
                },
                child: Text(
                  'Clear Signature',
                  textAlign: TextAlign.left,
                  style: GoogleFonts.prompt(
                    textStyle: TextStyle(
                      color: Colors.white,
                      letterSpacing: .5,
                      fontSize: MediaQuery.of(context).size.height * 0.02,
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  textfieldWithBtnTitle() {
    return TextButton(
      onPressed: () async {
        var result = await Navigator.push(context,
            MaterialPageRoute(builder: (context) => const SelectTitle()));
        if (result != null) {
          if (kDebugMode) {
            print('object');
          }
          setState(() {
            selectedTitle = result;
            _receiveTitleIdController.text = selectedTitle.name ?? '';
            titleId = selectedTitle.id;
          });
        }
      },
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.zero,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: whiteOpacity,
        ),
        child: TextFormField(
          controller: _receiveTitleIdController,
          enabled: false,
          style: GoogleFonts.prompt(
              textStyle: TextStyle(
            color: textColor,
            letterSpacing: 0.5,
            fontSize: MediaQuery.of(context).size.height * 0.02,
          )),
          decoration: InputDecoration(
            suffixIcon: Icon(Icons.arrow_drop_down_sharp,
                size: MediaQuery.of(context).size.height * 0.05,
                color: textColorHint),
            contentPadding:
                const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 16),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            hintText: 'กรุณาเลือกคำนำหน้า',
            hintStyle: GoogleFonts.prompt(
              textStyle: TextStyle(
                color: textColorHint,
                letterSpacing: 0.5,
                fontSize: MediaQuery.of(context).size.height * 0.02,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget personalSelectPage() {
    return TextButton(
      onPressed: () async {
        var result = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SelectInspector(widget.caseID ?? -1)));
        if (result != null) {
          setState(() {
            personalSelected = result;
            _sendPersonIdController.text =
                '${titleLabel(personalSelected.titleId)} ${personalSelected.firstname?.trim()} ${personalSelected.lastname?.trim()}';
            sendPersonId = '${personalSelected.id}';
            if (kDebugMode) {
              print(personalSelected.positionID);
            }
            // print(
            //     'personalSelected.positionOther ${personalSelected.positionOther}');

            personalSelected.positionID == '0'
                ? _senderPositionController.text =
                    personalSelected.positionOther ?? ''
                : _senderPositionController.text =
                    _positionLabel('${personalSelected.positionID}') ?? '';
            // print('personalSelected.positionId ${personalSelected.positionID}');
          });
        }
      },
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.zero,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: whiteOpacity,
        ),
        child: TextFormField(
          maxLines: null,
          controller: _sendPersonIdController,
          enabled: false,
          style: GoogleFonts.prompt(
              textStyle: TextStyle(
            color: textColor,
            letterSpacing: 0.5,
            fontSize: MediaQuery.of(context).size.height * 0.02,
          )),
          decoration: InputDecoration(
            suffixIcon: Icon(Icons.arrow_drop_down_sharp,
                size: MediaQuery.of(context).size.height * 0.05,
                color: textColor),
            contentPadding:
                const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 16),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            hintText: 'เลือกผู้ส่งมอบสถานที่เกิดเหตุ',
            hintStyle: GoogleFonts.prompt(
              textStyle: TextStyle(
                color: textColorHint,
                letterSpacing: 0.5,
                fontSize: MediaQuery.of(context).size.height * 0.02,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget saveButton() {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
      child: AppButton(
          color: pinkButton,
          textColor: Colors.white,
          text: 'บันทึก',
          onPressed: () {
            _recieveScreenshotController
                .capture(delay: const Duration(milliseconds: 100))
                .then((capturedImage) {
              widget.receiveIsSign ?? false
                  ? recieve64string = 'data:image/png;base64,$recieve64string'
                  : recieve64string =
                      'data:image/png;base64,${base64.encode(capturedImage ?? [])}';
              _senderScreenshotController
                  .capture(delay: const Duration(milliseconds: 100))
                  .then((capturedImage) {
                widget.senderIsSign ?? false
                    ? sender64string = 'data:image/png;base64,$sender64string'
                    : sender64string =
                        'data:image/png;base64,${base64.encode(capturedImage ?? [])}';
              }).then((value) {
                int variable1;
                if (_isFinal) {
                  variable1 = 1;
                } else {
                  variable1 = 0;
                }

                int variable2;
                if (_isComplete) {
                  variable2 = 1;
                } else {
                  variable2 = 0;
                }

                int variable3;
                if (_isDelivery) {
                  variable3 = 1;
                } else {
                  variable3 = 0;
                }

                FidsCrimeSceneDao().updateReleaseCase(
                    variable1,
                    variable2,
                    variable3,
                    _closeDateController.text,
                    _closeTimeController.text,
                    recieve64string,
                    titleId.toString(),
                    _receiveNameController.text,
                    _receivePositionController.text,
                    sender64string,
                    sendPersonId,
                    _senderPositionController.text,
                    '${widget.caseID}');
                setState(() {
                  isLoading = false;
                });
                Navigator.of(context).pop(true);
              });
            }).catchError((onError) {
              final snackBar = SnackBar(content: Text('$onError'));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              if (kDebugMode) {
                print('$onError');
              }
              setState(() {
                isLoading = false;
              });
            });
          }),
    );
  }

  String? titleLabel(String? id) {
    if (kDebugMode) {
      print('object $id');
    }
    for (int i = 0; i < titleList.length; i++) {
      if ('$id' == '${titleList[i].id}') {
        return titleList[i].name;
      }
    }
    return '';
  }

  String? personalLabel(String? id) {
    for (int i = 0; i < personalList.length; i++) {
      if ('${personalList[i].id}' == '$id') {
        if (kDebugMode) {
          print(
              '${personalList[i].firstname?.trim()} ${personalList[i].lastname?.trim()}');
        }
        return '${titleLabel(personalList[i].titleId)}  ${personalList[i].firstname?.trim()} ${personalList[i].lastname?.trim()}';
      }
    }
    return '';
  }

  String? getPositionId(String? id) {
    for (int i = 0; i < personalList.length; i++) {
      if ('${personalList[i].id}' == '$id') {
        return '${personalList[i].positionID}';
      }
    }
    return '';
  }

  String? _positionLabel(String? id) {
    for (int i = 0; i < positionList.length; i++) {
      if ('$id' == '${positionList[i].id}') {
        return positionList[i].name;
      }
    }
    return '';
  }
}
