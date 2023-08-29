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
import '../../../../widget/text_field_widget.dart';
import '../../../../widget/textfield_modal_bottom_sheet.dart';
import 'add_evident_found.dart';

class EvidentFoundDetail extends StatefulWidget {
  final int? caseID;
  final String? caseNo;
  final String? id;
  final bool isEdit;
  final FidsCrimeScene? caseFids;

  const EvidentFoundDetail(
      {super.key,
      this.caseID,
      this.id,
      this.caseNo,
      this.isEdit = false,
      this.caseFids});

  @override
  EvidentFoundDetailState createState() => EvidentFoundDetailState();
}

class EvidentFoundDetailState extends State<EvidentFoundDetail> {
  bool isPhone = Device.get().isPhone;
  List evidentTypes = ['โลหิต', 'โลหิต', 'โลหิต', 'โลหิต'];
  CaseEvidentFound? caseEvidentFound;

  List<UnitMeter> unitMeter = [
    UnitMeter(id: 1, unitLabel: 'เมตร'),
    UnitMeter(id: 2, unitLabel: 'เซนติเมตร')
  ];

  List unitTypes = [];
  List ref1 = [
    'จุดอ้างอิงที่ 1',
    'จุดอ้างอิงที่ 2',
    'จุดอ้างอิงที่ 3',
    'จุดอ้างอิงที่ 4'
  ];
  List ref2 = [
    'จุดอ้างอิงที่ 1',
    'จุดอ้างอิงที่ 2',
    'จุดอ้างอิงที่ 3',
    'จุดอ้างอิงที่ 4'
  ];
  List ref1location = [
    'ประตูทางเข้า',
    'ประตูทางออก',
    'หน้าต่าง',
    'กระถางต้นไม้'
  ];

  List ref2location = [
    'ประตูทางเข้า',
    'ประตูทางออก',
    'หน้าต่าง',
    'กระถางต้นไม้'
  ];

  int _isBloodValue = 0,
      _isTestValue = 0,
      _isHermestixValue = 0,
      _isPhenolphthaieinValue = 0;
  bool _isHermastixChange = false, _isPhenolphthaieinChanged = false;

  void _handleValue(int value) {}

  final TextEditingController _unitTypesController = TextEditingController();
  int evidentTypeIndexSelected = 0;
  int unitTypesIndexSelected = 0;
  int ref1IndexSelected = 0, ref2IndexSelected = 0;

  bool isLoading = true;

  List<EvidentType>? evidentList = [];

  List<CaseReferencePoint>? caseReferencePoints = [];

  @override
  void initState() {
    super.initState();
    asyncMethod();
  }

  asyncMethod() async {
    asyncCall1();
    asyncCall2();
  }

  void asyncCall1() async {
    var result = await EvidentypeDao().getEvidentType();
    var result2 = await UnitDao().getUnit();
    var result3 =
        await CaseReferencePointDao().getCaseReferencePoint('${widget.caseID}');
    setState(() {
      evidentList = result;
      unitTypes = result2;
      caseReferencePoints = result3;

      if (caseEvidentFound?.isBlood != null &&
          caseEvidentFound?.isBlood == '1') {
        _isBloodValue = 1;
      } else if (caseEvidentFound?.isBlood != null &&
          caseEvidentFound?.isBlood == '2') {
        _isBloodValue = 2;
      }
      if (caseEvidentFound?.isoIsTestStains != null &&
          caseEvidentFound?.isoIsTestStains == '1') {
        _isTestValue = 1;
      } else if (caseEvidentFound?.isoIsTestStains != null &&
          caseEvidentFound?.isoIsTestStains == '2') {
        _isTestValue = 2;
      } else {
        _isTestValue = -1;
      }

      if (caseEvidentFound?.isoIsHermastix != null &&
          caseEvidentFound?.isoIsHermastix == '1') {
        _isHermestixValue = 1;
      } else if (caseEvidentFound?.isoIsHermastix != null &&
          caseEvidentFound?.isoIsHermastix == '2') {
        _isHermestixValue = 2;
      } else {
        _isHermestixValue = -1;
      }

      if (caseEvidentFound?.isoIsHermastixChange != null &&
          caseEvidentFound?.isoIsHermastixChange == '1') {
        _isHermastixChange = true;
      } else if (caseEvidentFound?.isoIsHermastixChange != null &&
          caseEvidentFound?.isoIsHermastixChange == '2') {
        _isHermastixChange = false;
      }

      if (caseEvidentFound?.isoIsPhenolphthaiein != null &&
          caseEvidentFound?.isoIsPhenolphthaiein == '1') {
        _isPhenolphthaieinValue = 1;
      } else if (caseEvidentFound?.isoIsPhenolphthaiein != null &&
          caseEvidentFound?.isoIsPhenolphthaiein == '2') {
        _isPhenolphthaieinValue = 2;
      } else {
        _isPhenolphthaieinValue = -1;
      }

      if (caseEvidentFound?.isoIsPhenolphthaieinChange != null &&
          caseEvidentFound?.isoIsPhenolphthaieinChange == '1') {
        _isPhenolphthaieinChanged = true;
      } else if (caseEvidentFound?.isoIsPhenolphthaieinChange != null &&
          caseEvidentFound?.isoIsPhenolphthaieinChange == '2') {
        _isPhenolphthaieinChanged = false;
      }

      isLoading = false;
    });
  }

  void asyncCall2() async {
    var result =
        await CaseEvidentFoundDao().getCaseEvidentFoundById(widget.id ?? '');
    setState(() {
      caseEvidentFound = result;
      if (kDebugMode) {
        print('CaseEvidentFound? ${caseEvidentFound?.toString()}');
      }
    });
    asyncCall1();
  }

  @override
  Widget build(BuildContext context) {
    bool isPhone = Device.get().isPhone;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBarWidget(
        title: 'วัตถุพยานที่ตรวจพบ',
        leading: IconButton(
          icon: isPhone
              ? const Icon(Icons.arrow_back_ios)
              : const Icon(Icons.arrow_back),
          onPressed: () async {
            Navigator.of(context).pop(true);
          },
        ),
        actions: [
          TextButton(
            child: Row(
              children: [
                Icon(
                  Icons.edit,
                  size: MediaQuery.of(context).size.height * 0.025,
                  color: Colors.white,
                ),
              ],
            ),
            onPressed: () async {
              var result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddEvidentFound(
                          id: widget.id,
                          caseNo: widget.caseNo,
                          caseID: widget.caseID ?? -1,
                          isEdit: true,
                          caseFids: widget.caseFids)));

              if (result) {
                asyncCall2();
              }
            },
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
            margin: isPhone
                ? const EdgeInsets.all(32)
                : const EdgeInsets.only(
                    left: 32, right: 32, top: 32, bottom: 32),
            child: ListView(
              children: [
                // titleWidget('ประเภทวัตถุพยาน'),
                // spacer(),
                // detailView(
                //     '${evidentypeLabel(caseEvidentFound?.evidentTypeId)}'),
                // spacerTitle(),
                // titleWidget('ป้ายหมายเลข'),
                // spacer(),
                // detailView('${caseEvidentFound?.isoLabelNo}'),
                titleWidget('ป้ายหมายเลข'),
                spacer(),
                detailView('${caseEvidentFound?.isoLabelNo}'),
                spacerTitle(),
                widget.caseFids?.caseCategoryID == 4
                    ? titleWidget('ขนาด')
                    : Container(),
                widget.caseFids?.caseCategoryID == 4 ? spacer() : Container(),
                widget.caseFids?.caseCategoryID == 4
                    ? detailView(
                        '${caseEvidentFound?.size} ${caseEvidentFound?.sizeUnit}')
                    : Container(),
                widget.caseFids?.caseCategoryID == 4
                    ? spacerTitle()
                    : Container(),
                titleWidget('ลักษณะ'),
                spacer(),
                detailView('${caseEvidentFound?.evidentDetails}'),
                spacerTitle(),
                titleWidget('บริเวณ'),
                spacer(),
                detailView('${caseEvidentFound?.isoEvidentPosition}'),
                titleWidget('จำนวน'),
                spacer(),
                detailView(
                    '${caseEvidentFound?.evidentAmount} ${caseEvidentFound?.evidenceUnit}'),
                spacerTitle(),
                titleWidget('จุดอ้างอิงที่ 1'),
                spacer(),
                firstReferencePointView(),
                spacerTitle(),
                titleWidget('ระยะห่าง'),
                spacer(),
                detailView(
                    '${caseEvidentFound?.isoReferenceDistance1} ${meterLabel(caseEvidentFound?.isoReferenceUnitId1)}'),
                spacerTitle(),
                titleWidget('จุดอ้างอิงที่ 2'),
                spacer(),
                secondReferencePointView(),
                spacerTitle(),
                titleWidget('ระยะห่าง'),
                spacer(),
                detailView(
                    '${caseEvidentFound?.isoReferenceDistance1} ${meterLabel(caseEvidentFound?.isoReferenceUnitId1)}'),
                spacerTitle(),
                bloodView(),
                spacerTitle(),
                titleWidget('ทดสอบด้วยชุดทดสอบคราบโลหิตเบื้องต้น'),
                spacer(),
                testView(),
                spacerTitle(),
                checkbox('Hemastix', _isHermastixChange, (value) {
                  setState(() {
                    _isHermastixChange = value;
                  });
                }),
                changeView1(),
                spacerTitle(),
                checkbox('Phenolphthalein', _isPhenolphthaieinChanged, (value) {
                  setState(() {
                    _isPhenolphthaieinChanged = value;
                  });
                }),
                changeView2(),
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

  distance1View() {
    final node = FocusScope.of(context);
    return Row(
      children: [
        Expanded(
          child: textField('กรอกระยะห่าง', (value) {}, (_) => node.unfocus()),
        ),
        const SizedBox(
          width: 12,
        ),
        Expanded(
          child: typeModalBottomSheet(_unitTypesController, 'กรุณาเลือกหน่วย',
              'เลือกหน่วย', unitTypes, unitTypesIndexSelected, () {}),
        ),
      ],
    );
  }

  distance2View() {
    final node = FocusScope.of(context);
    return Row(
      children: [
        Expanded(
          child: textField('กรอกระยะห่าง', (value) {}, (_) => node.nextFocus()),
        ),
        const SizedBox(
          width: 12,
        ),
        Expanded(
          child: typeModalBottomSheet(_unitTypesController, 'กรุณาเลือกหน่วย',
              'เลือกหน่วย', unitTypes, unitTypesIndexSelected, () {}),
        ),
      ],
    );
  }

  firstReferencePointView() {
    return Row(
      children: [
        Expanded(
            child: detailView(
                '${caseReferencePointLabel(caseEvidentFound?.isoReferenceId1)}')),
        const SizedBox(
          width: 12,
        ),
        Expanded(
          child: detailView(
              '${caseReferencePointDetail(caseEvidentFound?.isoReferenceId1)}'),
        ),
      ],
    );
  }

  secondReferencePointView() {
    return Row(
      children: [
        Expanded(
            child: detailView(
                '${caseReferencePointLabel(caseEvidentFound?.isoReferenceId2)}')),
        const SizedBox(
          width: 12,
        ),
        Expanded(
          child: detailView(
              '${caseReferencePointDetail(caseEvidentFound?.isoReferenceId2)}'),
        ),
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

  textField(String? hint, Function onChanged, Function onFieldSubmitted) {
    return InputField(
      hint: '$hint',
      onChanged: (val) {
        onChanged(val);
      },
      onFieldSubmitted: onFieldSubmitted,
    );
  }

  Widget typeModalBottomSheet(TextEditingController controller, String? hint,
      String? title, List items, int indexSelected, Function onPressed) {
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
                              onPressed: () =>
                                  onPressed(mycontext, indexSelected))
                          // () {
                          //   Navigator.pop(context);
                          //   setState(() {
                          //     controller.text = items[indexSelected];
                          //   });
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
                  onChanged: (v) {
                    _handleValue(v ?? -1);
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
                  onChanged: (v) {
                    _handleValue(v ?? -1);
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
                  onChanged: (v) {
                    _handleValue(v ?? -1);
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
                  onChanged: (v) {
                    _handleValue(v ?? -1);
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

  changeView1() {
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
                  groupValue: _isHermestixValue,
                  onChanged: (v) {
                    _handleValue(v ?? -1);
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
                  groupValue: _isHermestixValue,
                  onChanged: (v) {
                    _handleValue(v ?? -1);
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

  changeView2() {
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
                  groupValue: _isPhenolphthaieinValue,
                  onChanged: (v) {
                    _handleValue(v ?? -1);
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
                  groupValue: _isPhenolphthaieinValue,
                  onChanged: (v) {
                    _handleValue(v ?? -1);
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

  String? evidentypeLabel(String? id) {
    for (int i = 0; i < evidentList!.length; i++) {
      if ('$id' == '${evidentList?[i].id}') {
        return evidentList?[i].name;
      }
    }
    return '';
  }

  String? unitLabel(String? id) {
    for (int i = 0; i < unitTypes.length; i++) {
      if ('$id' == '${unitTypes[i].id}') {
        return unitTypes[i].name;
      }
    }
    return '';
  }

  String? meterLabel(String? id) {
    for (int i = 0; i < unitMeter.length; i++) {
      if ('$id' == '${unitMeter[i].id}') {
        return unitMeter[i].unitLabel;
      }
    }
    return '';
  }

  String? caseReferencePointLabel(String? id) {
    for (int i = 0; i < caseReferencePoints!.length; i++) {
      if ('$id' == '${caseReferencePoints?[i].id}') {
        return caseReferencePoints?[i].referencePointNo;
      }
    }
    return '';
  }

  String? caseReferencePointDetail(String? id) {
    for (int i = 0; i < caseReferencePoints!.length; i++) {
      if ('$id' == '${caseReferencePoints?[i].id}') {
        return caseReferencePoints?[i].referencePointDetail;
      }
    }
    return '';
  }
}
