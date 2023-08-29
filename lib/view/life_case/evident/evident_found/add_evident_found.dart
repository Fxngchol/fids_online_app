import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../Utils/color.dart';
import '../../../../models/CaseEvidentFound.dart';
import '../../../../models/CaseReferencePoint.dart';
import '../../../../models/EvidentType.dart';
import '../../../../models/FidsCrimeScene.dart';
import '../../../../models/Unit.dart';
import '../../../../models/UnitMeter.dart';
import '../../../../widget/app_bar_widget.dart';
import '../../../../widget/app_button.dart';
import '../../../../widget/text_field_widget.dart';
import '../../../../widget/textfield_modal_bottom_sheet.dart';
import '../../deceased/reference_point/reference_point.dart';

class AddEvidentFound extends StatefulWidget {
  final int? caseID;
  final String? caseNo;
  final bool isEdit;
  final String? id;
  final FidsCrimeScene? caseFids;

  const AddEvidentFound(
      {super.key,
      this.caseID,
      this.caseNo,
      this.isEdit = false,
      this.id,
      this.caseFids});

  @override
  AddEvidentFoundState createState() => AddEvidentFoundState();
}

class AddEvidentFoundState extends State<AddEvidentFound> {
  bool isPhone = Device.get().isPhone;

  List<UnitMeter> unitMeter = [
    UnitMeter(id: 1, unitLabel: 'เมตร'),
    UnitMeter(id: 2, unitLabel: 'เซนติเมตร')
  ];

  final TextEditingController _labelNoController = TextEditingController();
  final TextEditingController _evidentDetailsController =
      TextEditingController();
  final TextEditingController _evidentPositionController =
      TextEditingController();
  final TextEditingController _evidentAmountController =
      TextEditingController();
  // TextEditingController _evidentUnitController = TextEditingController();
  final TextEditingController _reference1Controller = TextEditingController();
  final TextEditingController _referenceDistance1Controller =
      TextEditingController();
  final TextEditingController _referenceUnitID1Controller =
      TextEditingController();
  final TextEditingController _reference2Controller = TextEditingController();
  final TextEditingController _referenceDistance2Controller =
      TextEditingController();
  final TextEditingController _referenceUnitID2Controller =
      TextEditingController();
  final TextEditingController _evidenceUnitController = TextEditingController();

  final TextEditingController _sizeController = TextEditingController();
  final TextEditingController _sizeUnitController = TextEditingController();

  int _referenceID1IndexSelected = 0,
      _referenceID2IndexSelected = 0,
      _referenceUnitID1IndexSelected = 0,
      _referenceUnitID2IndexSelected = 0;

  int evidentTypeId = 0,
      evidentTypeUnitId = 0,
      referenceID1 = 0,
      referenceID2 = 0,
      referenceUnitID1 = 0,
      referenceUnitID2 = 0;

  bool isLoading = true;

  List evidentList = [];
  late List<EvidentType>? evidentTypes;

  List evidentUnit = [];

  CaseEvidentFound caseEvidentFound = CaseEvidentFound();

  List<String> unitList = [];
  List<Unit>? units;

  Unit? unitSelected;

  List<CaseReferencePoint> ref1List = [];

  List<CaseReferencePoint> ref2List = [];

  List<EvidentType>? evidentypes;

  String? text1 = '';
  String? text2 = '';

  int? amount, firstDistance, secondDistance;

  int? _isBloodValue, _isTestValue, _hermastixValue, _phenolphthaleinValue;
  bool _isTestStains = false,
      _isBlood = false,
      _isPhenolphthaieinChanged = false,
      _isHermastixChanged = false;

  void _handleBloodValueChange(int value) {
    setState(() {
      _isBloodValue = value;
    });
    switch (_isBloodValue) {
      case 1:
        _isBlood = true;
        break;
      case 2:
        _isTestValue = -1;
        _hermastixValue = -1;
        _phenolphthaleinValue = -1;
        _isBlood = false;
        _isPhenolphthaieinChanged = false;
        _isHermastixChanged = false;
        break;
    }
  }

  void _handleTestValueChange(int value) {
    if (_isBlood) {
      setState(() {
        _isTestValue = value;
        switch (_isTestValue) {
          case 1:
            _isTestStains = true;
            _isHermastixChanged = true;
            break;
          case 2:
            _hermastixValue = -1;
            _phenolphthaleinValue = -1;
            _isTestStains = false;
            _isPhenolphthaieinChanged = false;
            _isHermastixChanged = false;
            break;
        }
      });
    }
  }

  void _handleHermastixChanged(int value) {
    if (_isTestStains && _isBlood) {
      setState(() {
        _hermastixValue = value;
        switch (_hermastixValue) {
          case 1:
            _isPhenolphthaieinChanged = true;
            break;
          case 2:
            _isPhenolphthaieinChanged = false;
            _phenolphthaleinValue = -1;

            break;
        }
      });
    }
  }

  void _handlePhenolphthaieinChange(int value) {
    if (_isTestStains && _isBlood && _isHermastixChanged) {
      setState(() {
        _phenolphthaleinValue = value;
      });
    }
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
    var result = await EvidentypeDao().getEvidentType();
    var result2 = await EvidentypeDao().getEvidentTypeLabel();
    var result3 = await UnitDao().getUnit();
    var result4 = await UnitDao().getUnitLabel();
    var result5 =
        await CaseReferencePointDao().getCaseReferencePoint('${widget.caseID}');
    await CaseReferencePointDao().getCaseReferencePoint('${widget.caseID}');
    setState(() {
      evidentTypes = result;
      evidentList = result2;
      units = result3;
      unitList = result4;
      evidentUnit = result4;
      ref1List = result5;
      ref2List = result5;
      isLoading = false;
    });
    if (widget.isEdit) {
      caseEvidentFound = (await CaseEvidentFoundDao()
          .getCaseEvidentFoundById(widget.id ?? ''))!;
      if (kDebugMode) {
        print('CaseEvidentFound ${caseEvidentFound.toString()}');
      }

      setUpData();
    }
  }

  setUpData() {
    setState(() {
      setReference1(caseEvidentFound.isoReferenceId1);
      setReference2(caseEvidentFound.isoReferenceId2);
      setReferenceUnitID1(caseEvidentFound.isoReferenceUnitId1);
      setReferenceUnitID2(caseEvidentFound.isoReferenceUnitId2);
      _evidenceUnitController.text = caseEvidentFound.evidenceUnit ?? '';
      _evidentDetailsController.text = caseEvidentFound.evidentDetails ?? '';
      _labelNoController.text = caseEvidentFound.isoLabelNo ?? '';
      _evidentPositionController.text =
          caseEvidentFound.isoEvidentPosition ?? '';
      _evidentAmountController.text = caseEvidentFound.evidentAmount ?? '';
      _referenceDistance1Controller.text =
          caseEvidentFound.isoReferenceDistance1 ?? '';
      _referenceDistance2Controller.text =
          caseEvidentFound.isoReferenceDistance2 ?? '';

      if (widget.caseFids?.caseCategoryID == 4) {
        _sizeController.text = caseEvidentFound.size ?? '';
        _sizeUnitController.text = caseEvidentFound.sizeUnit ?? '';
      }

      if (caseEvidentFound.isBlood != null && caseEvidentFound.isBlood == '1') {
        _isBlood = true;
        _isBloodValue = 1;
      } else if (caseEvidentFound.isBlood != null &&
          caseEvidentFound.isBlood == '2') {
        _isBloodValue = 2;
      }
      if (caseEvidentFound.isoIsTestStains != null &&
          caseEvidentFound.isoIsTestStains == '1') {
        _isTestStains = true;
        _isTestValue = 1;
      } else if (caseEvidentFound.isoIsTestStains != null &&
          caseEvidentFound.isoIsTestStains == '2') {
        _isTestValue = 2;
      } else {
        _isTestValue = -1;
      }

      if (caseEvidentFound.isoIsHermastixChange != null &&
          caseEvidentFound.isoIsHermastixChange == '1') {
        _isHermastixChanged = true;
      } else if (caseEvidentFound.isoIsHermastixChange != null &&
          caseEvidentFound.isoIsHermastixChange == '2') {
        _isHermastixChanged = false;
      }

      if (caseEvidentFound.isoIsHermastix != null &&
          caseEvidentFound.isoIsHermastix == '1') {
        _isHermastixChanged = true;
        _hermastixValue = 1;
      } else if (caseEvidentFound.isoIsHermastix != null &&
          caseEvidentFound.isoIsHermastix == '2') {
        _hermastixValue = 2;
      } else {
        _hermastixValue = -1;
      }

      if (caseEvidentFound.isoIsPhenolphthaiein != null &&
          caseEvidentFound.isoIsPhenolphthaiein == '1') {
        _phenolphthaleinValue = 1;
      } else if (caseEvidentFound.isoIsPhenolphthaiein != null &&
          caseEvidentFound.isoIsPhenolphthaiein == '2') {
        _phenolphthaleinValue = 2;
      } else {
        _phenolphthaleinValue = -1;
      }

      if (caseEvidentFound.isoIsPhenolphthaieinChange != null &&
          caseEvidentFound.isoIsPhenolphthaieinChange == '1') {
        _isPhenolphthaieinChanged = true;
      } else if (caseEvidentFound.isoIsPhenolphthaieinChange != null &&
          caseEvidentFound.isoIsPhenolphthaieinChange == '2') {
        _isPhenolphthaieinChanged = false;
      }
    });
  }

  // setEvidentType(String?id) async {
  //   try {
  //     // await PoliceStationDao().getPoliceStationLabelById(id);
  //     _evidentTypeController.text =
  //         await EvidentypeDao().getEvidentTypeLabelById(id);
  //     evidentTypeId = int.parse(id);
  //   } catch (ex) {
  //     _evidentTypeController.text = '';
  //   }
  // }

  // setEvidentUnit(String?id) async {
  //   try {
  //     _evidentUnitController.text = await UnitDao().getUnitLabelById(id);
  //     id != null || id != ''
  //         ? evidentTypeUnitId = int.parse(id)
  //         : evidentTypeUnitId = -1;
  //   } catch (ex) {
  //     _evidentUnitController.text = '';
  //   }
  // }

  setReference1(String? id) async {
    try {
      var reference1 =
          await CaseReferencePointDao().getCaseReferencePointById(id);
      _reference1Controller.text = reference1.referencePointNo ?? '';
      text1 = reference1.referencePointDetail;
      referenceID1 = reference1.id ?? -1;
    } catch (ex) {
      _reference1Controller.text = '';
    }
  }

  setReference2(String? id) async {
    try {
      // await PoliceStationDao().getPoliceStationLabelById(id);
      var reference2 =
          await CaseReferencePointDao().getCaseReferencePointById(id);
      _reference2Controller.text = reference2.referencePointNo ?? '';
      text2 = reference2.referencePointDetail;
      referenceID2 = reference2.id ?? -1;
    } catch (ex) {
      _reference1Controller.text = '';
    }
  }

  setReferenceUnitID1(String? id) async {
    try {
      id == '1'
          ? _referenceUnitID1Controller.text = 'เมตร'
          : _referenceUnitID1Controller.text = 'เซนติเมตร';
      referenceUnitID1 = int.parse(id ?? '');
    } catch (ex) {
      _referenceUnitID1Controller.text = '';
    }
  }

  setReferenceUnitID2(String? id) async {
    try {
      id == '1'
          ? _referenceUnitID2Controller.text = 'เมตร'
          : _referenceUnitID2Controller.text = 'เซนติเมตร';
      referenceUnitID2 = int.parse(id ?? '');
    } catch (ex) {
      _referenceUnitID2Controller.text = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isPhone = Device.get().isPhone;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBarWidget(
        title: 'วัตถุพยานที่ตรวจพบ',
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
                // titleWidget('ประเภทวัตถุพยาน'),
                // spacer(),
                // modalBottomSheet(
                //     _evidentTypeController,
                //     'กรุณาเลือกประเภทวัตถุพยาน',
                //     'เลือกประเภทวัตถุพยาน',
                //     evidentList,
                //     _evidentTypeIndexSelected, (index) {
                //   _evidentTypeIndexSelected = index;
                // }, () {
                //   setState(() {
                //     Navigator.of(context).pop();
                //     _evidentTypeController.text =
                //         evidentList[_evidentTypeIndexSelected];
                //     evidentTypeId = evidentTypes[_evidentTypeIndexSelected].id;
                //   });
                // }),
                // spacerTitle(),
                spacerTitle(),
                titleWidget('ลักษณะ/สภาพ', true),
                spacer(),
                textField(_evidentDetailsController, 'กรอกลักษณะ'),
                spacerTitle(),
                widget.caseFids?.caseCategoryID == 4
                    ? titleWidget('ขนาด', false)
                    : Container(),
                widget.caseFids?.caseCategoryID == 4 ? spacer() : Container(),
                widget.caseFids?.caseCategoryID == 4 ? sizeView() : Container(),
                widget.caseFids?.caseCategoryID == 4
                    ? spacerTitle()
                    : Container(),
                titleWidget('บริเวณ', true),
                spacer(),
                textField(_evidentPositionController, 'กรอกบริเวณ'),
                spacerTitle(),
                titleWidget('จำนวน', false),
                spacer(),
                amountView(),
                spacerTitle(),
                titleWidget('ป้ายหมายเลข', true),
                spacer(),
                textField(_labelNoController, 'กรอกป้ายหมายเลข'),
                spacerTitle(),
                refHeaer(),
                spacerTitle(),
                titleWidget('จุดอ้างอิงที่ 1', false),
                spacer(),
                firstReferencePointView(),
                spacer(),
                distance1View(),
                spacerTitle(),
                titleWidget('จุดอ้างอิงที่ 2', false),
                spacer(),
                secondReferencePointView(),
                spacer(),
                distance2View(),
                spacerTitle(),
                spacerTitle(),
                bloodView(),
                spacerTitle(),
                titleWidget('ทดสอบด้วยชุดทดสอบคราบโลหิตเบื้องต้น', false),
                spacer(),
                testView(),
                spacerTitle(),
                checkbox('Hemastix', _isHermastixChanged, (value) {
                  setState(() {
                    _isHermastixChanged = value;
                    if (kDebugMode) {
                      print(_isHermastixChanged);
                    }
                  });
                }),
                hermastixChangeView(),
                spacerTitle(),
                checkbox('Phenolphthalein', _isPhenolphthaieinChanged, (value) {
                  setState(() {
                    _isPhenolphthaieinChanged = value;
                    if (kDebugMode) {
                      print(_isPhenolphthaieinChanged);
                    }
                  });
                }),
                phenolphthaieinChangeView(),
                spacerTitle(),
                saveButton()
              ],
            ),
          ),
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
              fontSize: MediaQuery.of(context).size.height * 0.03,
            ),
          ),
        ),
      ),
    ]);
  }

  refHeaer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        headerWidget('จุดอ้างอิง'),
        TextButton(
          child: Row(
            children: [
              Icon(
                Icons.add,
                size: MediaQuery.of(context).size.height * 0.03,
                color: Colors.white,
              ),
              Text(
                'เพิ่ม',
                textAlign: TextAlign.center,
                style: GoogleFonts.prompt(
                  textStyle: TextStyle(
                    color: Colors.white,
                    letterSpacing: .5,
                    fontSize: MediaQuery.of(context).size.height * 0.03,
                  ),
                ),
              ),
            ],
          ),
          onPressed: () async {
            // Navigator.pushNamed(context, '/addevidentfound');
            var result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ReferencePoint(
                        caseID: widget.caseID ?? -1,
                        caseNo: widget.caseNo,
                        isEdit: false)));
            if (result) {
              asyncCall1();
            }
          },
        ),
      ],
    );
  }

  amountView() {
    return Row(
      children: [
        Expanded(
            child: textFieldOnlyInt(_evidentAmountController, 'กรอกจำนวน',
                (value) {
          try {
            setState(() {
              amount = int.parse(value);
            });
          } catch (_) {
            if (value != '') {
              setState(() {
                amount = 0;
                _evidentAmountController.text = '';
              });
              showAlertDialog(context);
            }
          }
        })),
        const SizedBox(
          width: 12,
        ),
        Expanded(
            child: textFieldUnit(
                _evidenceUnitController, 'กรอกหน่วย', (value) {})),
      ],
    );
  }

  sizeView() {
    return Row(
      children: [
        Expanded(child: textFieldUnit(_sizeController, 'กรอกขนาด', (value) {})),
        const SizedBox(
          width: 12,
        ),
        Expanded(
            child: textFieldUnit(_sizeUnitController, 'กรอกหน่วย', (value) {
          // _evidenceUnitController.text = value;
        })),
      ],
    );
  }

  // textfieldWithBtnTitle() {
  //   return TextButton(
  //     onPressed: () async {
  //       var result = await Navigator.push(context,
  //           MaterialPageRoute(builder: (context) => SelectUnitListPage()));
  //       if (result != null) {
  //         print('object');
  //         setState(() {
  //           unitSelected = result;
  //           _evidentUnitController.text = unitSelected.name;
  //           evidentTypeUnitId = unitSelected.id;
  //         });
  //       }
  //     },
  //     style: OutlinedButton.styleFrom(
  //       padding: EdgeInsets.zero,
  //     ),
  //     child: Container(
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(10),
  //         color: whiteOpacity,
  //       ),
  //       child: TextFormField(
  //         controller: _evidentUnitController,
  //         enabled: false,
  //         style: GoogleFonts.prompt(
  //             textStyle: TextStyle(
  //           color: textColor,
  //           letterSpacing: 0.5,
  //           fontSize: MediaQuery.of(context).size.height * 0.02,
  //         )),
  //         decoration: InputDecoration(
  //           suffixIcon: Icon(Icons.arrow_drop_down_sharp,
  //               size: MediaQuery.of(context).size.height * 0.05,
  //               color: textColorHint),
  //           contentPadding:
  //               const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 16),
  //           focusedBorder: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(10),
  //           ),
  //           hintText: 'กรุณาเลือกหน่วย',
  //           hintStyle: GoogleFonts.prompt(
  //             textStyle: TextStyle(
  //               color: textColorHint,
  //               letterSpacing: 0.5,
  //               fontSize: MediaQuery.of(context).size.height * 0.02,
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  distance1View() {
    return Row(
      children: [
        Expanded(
          child: textFieldOnlyInt(
              _referenceDistance1Controller, 'กรอกระยะห่าง', (value) {}),
        ),
        const SizedBox(
          width: 12,
        ),
        Expanded(
          child: refUnitModalBottomSheet(
              _referenceUnitID1Controller,
              'กรุณาเลือกหน่วย',
              'เลือกหน่วย',
              unitMeter,
              _referenceUnitID1IndexSelected, (index) {
            _referenceUnitID1IndexSelected = index;
          }, () {
            setState(() {
              Navigator.of(context).pop();
              _referenceUnitID1Controller.text =
                  unitMeter[_referenceUnitID1IndexSelected].unitLabel ?? '';
              referenceUnitID1 =
                  unitMeter[_referenceUnitID1IndexSelected].id ?? -1;
            });
          }),
        ),
      ],
    );
  }

  distance2View() {
    return Row(
      children: [
        Expanded(
          child: textFieldOnlyInt(
              _referenceDistance2Controller, 'กรอกระยะห่าง', (value) {}),
        ),
        const SizedBox(
          width: 12,
        ),
        Expanded(
          child: refUnitModalBottomSheet(
              _referenceUnitID2Controller,
              'กรุณาเลือกหน่วย',
              'เลือกหน่วย',
              unitMeter,
              _referenceUnitID2IndexSelected, (index) {
            _referenceUnitID2IndexSelected = index;
          }, () {
            setState(() {
              Navigator.of(context).pop();
              _referenceUnitID2Controller.text =
                  unitMeter[_referenceUnitID2IndexSelected].unitLabel ?? '';
              referenceUnitID2 =
                  unitMeter[_referenceUnitID2IndexSelected].id ?? -1;
            });
          }),
        ),
      ],
    );
  }

  firstReferencePointView() {
    return Row(
      children: [
        Expanded(
          child: referenceBottomSheet(
              _reference1Controller,
              'กรุณาเลือกจุดอ้างอิง',
              'เลือกจุดอ้างอิง',
              ref1List,
              _referenceID1IndexSelected, (index) {
            _referenceID1IndexSelected = index;
          }, () {
            setState(() {
              Navigator.of(context).pop();
              _reference1Controller.text =
                  'จุดอ้างอิงที่ ${ref1List[_referenceID1IndexSelected].referencePointNo.toString()}';
              referenceID1 = ref2List[_referenceID1IndexSelected].id ?? -1;

              text1 = ref1List[_referenceID1IndexSelected].referencePointDetail;
            });
          }),
        ),
        const SizedBox(
          width: 12,
        ),
        Expanded(
          child: text1 != null ? detailView(' $text1') : detailView(''),
        ),
      ],
    );
  }

  secondReferencePointView() {
    return Row(
      children: [
        Expanded(
          child: referenceBottomSheet(
              _reference2Controller,
              'กรุณาเลือกจุดอ้างอิง',
              'เลือกจุดอ้างอิง',
              ref2List,
              _referenceID2IndexSelected, (index) {
            _referenceID2IndexSelected = index;
          }, () {
            setState(() {
              Navigator.of(context).pop();
              _reference2Controller.text =
                  'จุดอ้างอิงที่ ${ref2List[_referenceID2IndexSelected].referencePointNo.toString()}';
              referenceID2 = ref2List[_referenceID2IndexSelected].id ?? -1;
              text2 = ref2List[_referenceID2IndexSelected].referencePointDetail;
            });
          }),
        ),
        const SizedBox(
          width: 12,
        ),
        Expanded(child: text2 != null ? detailView(' $text2') : detailView('')),
      ],
    );
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

  Widget headerWidget(String? title) {
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

  Widget titleWidget(String? title, bool isRequire) {
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

  textField(
    TextEditingController controller,
    String? hint,
  ) {
    return InputField(
      controller: controller,
      hint: '$hint',
      onChanged: (_) {},
    );
  }

  textFieldOnlyInt(
    TextEditingController controller,
    String? hint,
    Function onChanged,
  ) {
    return InputField(
      controller: controller,
      hint: '$hint',
      onChanged: (val) {
        onChanged(val);
      },
    );
  }

  textFieldUnit(
    TextEditingController controller,
    String? hint,
    Function onChanged,
  ) {
    return InputField(
      controller: controller,
      hint: '$hint',
      onChanged: (val) {
        onChanged(val);
      },
    );
  }

  Widget referenceBottomSheet(
      TextEditingController controller,
      String? hint,
      String? title,
      List<CaseReferencePoint> items,
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
                              'จุดอ้างอิงที่ ${items[index].referencePointNo.toString()}',
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

  Widget evidentTypeUnitModalBottomSheet(
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
                  height: MediaQuery.of(context).copyWith().size.height / 2,
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

  Widget refUnitModalBottomSheet(
      TextEditingController controller,
      String? hint,
      String? title,
      List<UnitMeter> items,
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
                        backgroundColor: Colors.white,
                        onSelectedItemChanged: (val) {
                          onSelectedItemChanged(val);
                        },
                        children:
                            List<Widget>.generate(items.length, (int index) {
                          return Center(
                            child: Text(
                              items[index].unitLabel ?? '',
                              style: GoogleFonts.prompt(
                                textStyle: TextStyle(
                                  color: textColor,
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

  Widget modalBottomSheet(
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
          builder: (mycontext) {
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
                                onPressed();
                              })
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  testView() {
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: Column(
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
                  groupValue: _isTestValue,
                  onChanged: (val) {
                    _handleTestValueChange(val ?? -1);
                  },
                ),
              ),
              Text(
                'ทดสอบ',
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
                  groupValue: _isTestValue,
                  onChanged: (val) {
                    _handleTestValueChange(val ?? -1);
                  },
                ),
              ),
              Text(
                'ไม่ทดสอบ',
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
      ),
    );
  }

  bloodView() {
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: Column(
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
                  groupValue: _isBloodValue,
                  onChanged: (val) {
                    _handleBloodValueChange(val ?? -1);
                  },
                ),
              ),
              Text(
                'วัตถุพยานอื่นๆ (ประเภทอื่นๆ ที่ไม่ใช่คราบโลหิต)',
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
                  value: 1,
                  activeColor: pinkButton,
                  groupValue: _isBloodValue,
                  onChanged: (val) {
                    _handleBloodValueChange(val ?? -1);
                  },
                ),
              ),
              Text(
                'คราบสีแดงคล้ายโลหิต',
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
      ),
    );
  }

  phenolphthaieinChangeView() {
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: Column(
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
                  groupValue: _phenolphthaleinValue,
                  onChanged: (val) {
                    _handlePhenolphthaieinChange(val ?? -1);
                  },
                ),
              ),
              Text(
                'เกิดการเปลี่ยนแปลง',
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
                  groupValue: _phenolphthaleinValue,
                  onChanged: (val) {
                    _handlePhenolphthaieinChange(val ?? -1);
                  },
                ),
              ),
              Text(
                'ไม่เกิดการเปลี่ยนแปลง',
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
      ),
    );
  }

  hermastixChangeView() {
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: Column(
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
                  groupValue: _hermastixValue,
                  onChanged: (val) {
                    _handleHermastixChanged(val ?? -1);
                  },
                ),
              ),
              Text(
                'เกิดการเปลี่ยนแปลง',
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
                  groupValue: _hermastixValue,
                  onChanged: (val) {
                    _handleHermastixChanged(val ?? -1);
                  },
                ),
              ),
              Text(
                'ไม่เกิดการเปลี่ยนแปลง',
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
      ),
    );
  }

  bool validate() {
    return _evidentDetailsController.text != '' &&
        _evidentPositionController.text != '';
    // _evidentAmountController.text != '' &&
    // _evidenceUnitController.text != '';
    // _reference1Controller.text != '' &&
    // _referenceDistance1Controller.text != '' &&
    // _referenceUnitID1Controller.text != '' &&
    // _reference2Controller.text != '' &&
    // _referenceDistance2Controller.text != '' &&
    // _referenceUnitID2Controller.text != '';
  }

  Widget saveButton() {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
      child: AppButton(
          color: pinkButton,
          textColor: Colors.white,
          text: 'บันทึก',
          onPressed: () async {
            // Navigator.pop(context);
            // print('ประเภทวัตถุพยาน: $evidentTypeId');
            // print('ป้ายหมายเลข: ${_labelNoController.text}');
            // print('ลักษณะ: ${_evidentDetailsController.text}');
            // print('บริเวณ: ${_evidentPositionController.text}');
            // print('จำนวน: ${_evidentAmountController.text}');
            // print('หน่วยนับ: $evidentTypeUnitId');
            // print('id จุดอ้างอิงที่1: $referenceID1');
            // print('ระยะห่าง: ${_referenceDistance1Controller.text}');
            // print('หน่วยนับ: ${referenceUnitID1.toString()}');
            // print('id จุดอ้างอิงที่ 2: $referenceID2');
            // print('ระยะห่าง: ${_referenceDistance2Controller.text}');
            // print('หน่วยนับ: ${referenceUnitID2.toString()}');
            // print('ทดสอบชุดโลหิต: $_isTestStains');
            // print('Hermastix: $_isHermastix');
            // print('การเปลี่ยนแปลงHermastix: $_isHermastixChanged');
            // print('Phenolphthaiein: $_isPhenolphthaiein');
            // print('การเปลี่ยนแปลง: $_phenolphthaleinValue');

            if (validate()) {
              bool isNumber = true;
              try {
                if (_referenceDistance1Controller.text != '') {}
                if (_referenceDistance2Controller.text != '') {}
              } catch (ex) {
                isNumber = false;
              }

              if (isNumber) {
                if (widget.isEdit) {
                  await CaseEvidentFoundDao()
                      .updateCaseEvidentFound(
                          widget.caseID ?? -1,
                          _labelNoController.text,
                          _evidentDetailsController.text,
                          _evidentPositionController.text,
                          widget.caseFids?.caseCategoryID == 4
                              ? _sizeController.text
                              : '',
                          widget.caseFids?.caseCategoryID == 4
                              ? _sizeUnitController.text
                              : '',
                          _evidentAmountController.text,
                          _evidenceUnitController.text,
                          referenceID1,
                          double.parse(_referenceDistance1Controller.text),
                          referenceUnitID1,
                          referenceID2,
                          double.parse(_referenceDistance2Controller.text),
                          referenceUnitID2,
                          _isTestValue ?? -1,
                          _hermastixValue ?? -1,
                          _isHermastixChanged == true ? 1 : 2,
                          _phenolphthaleinValue ?? -1,
                          _isPhenolphthaieinChanged == true ? 1 : 2,
                          widget.id,
                          _isBloodValue ?? -1)
                      .then((value) => Navigator.of(context).pop(true));
                } else {
                  if (kDebugMode) {
                    print('เลือด: $_isBloodValue');
                  }

                  await CaseEvidentFoundDao()
                      .createCaseEvidentFound(
                          widget.caseID ?? -1,
                          _labelNoController.text,
                          _evidentDetailsController.text,
                          _evidentPositionController.text,
                          widget.caseFids?.caseCategoryID == 4
                              ? _sizeController.text
                              : '',
                          widget.caseFids?.caseCategoryID == 4
                              ? _sizeUnitController.text
                              : '',
                          _evidentAmountController.text,
                          _evidenceUnitController.text,
                          referenceID1,
                          _referenceDistance1Controller.text == ''
                              ? 0
                              : double.parse(
                                  _referenceDistance1Controller.text),
                          referenceUnitID1,
                          referenceID2,
                          _referenceDistance2Controller.text == ''
                              ? 0
                              : double.parse(
                                  _referenceDistance2Controller.text),
                          referenceUnitID2,
                          _isTestValue ?? -1,
                          _hermastixValue ?? -1,
                          _isHermastixChanged == true ? 1 : 2,
                          _phenolphthaleinValue ?? -1,
                          _isPhenolphthaieinChanged == true ? 1 : 2,
                          _isBloodValue ?? -1,
                          '',
                          '',
                          '',
                          '',
                          1)
                      .then((value) => Navigator.of(context).pop(true));
                }
              } else {
                final snackBar = SnackBar(
                  content: Text(
                    'กรุณากรอกข้อมูลระยะห่างด้วยตัวเลข',
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

  showAlertDialog(BuildContext context) {
    Widget okButton = TextButton(
      child: Text(
        'ตกลง',
        textAlign: TextAlign.left,
        style: GoogleFonts.prompt(
          textStyle: TextStyle(
            color: pinkButton,
            letterSpacing: .5,
            fontSize: MediaQuery.of(context).size.height * 0.02,
          ),
        ),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      contentPadding: const EdgeInsets.all(32),
      title: Text(
        'แจ้งเตือน',
        textAlign: TextAlign.left,
        style: GoogleFonts.prompt(
          textStyle: TextStyle(
            color: textColor,
            letterSpacing: .5,
            fontSize: MediaQuery.of(context).size.height * 0.025,
          ),
        ),
      ),
      content: Text(
        'กรุณากรอกจำนวนเป็นตัวเลข',
        textAlign: TextAlign.left,
        style: GoogleFonts.prompt(
          textStyle: TextStyle(
            color: textColor,
            letterSpacing: .5,
            fontSize: MediaQuery.of(context).size.height * 0.02,
          ),
        ),
      ),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
