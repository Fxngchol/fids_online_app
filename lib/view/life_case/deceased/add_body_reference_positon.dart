// ignore_for_file: must_be_immutable

import 'package:fids_online_app/view/life_case/deceased/reference_point/reference_point.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/color.dart';
import '../../../models/BodyPosition.dart';
import '../../../models/CaseBodyReferencePoint.dart';
import '../../../models/CaseReferencePoint.dart';
import '../../../models/Title.dart';
import '../../../models/Unit.dart';
import '../../../widget/app_bar_widget.dart';
import '../../../widget/app_button.dart';
import '../../../widget/text_field_widget.dart';
import '../../../widget/textfield_modal_bottom_sheet.dart';

class AddBodyReferencePosition extends StatefulWidget {
  final int? caseID, caseBodyId;
  final String? caseNo;
  final bool isEdit;
  CaseBodyReferencePoint? caseBodyReferencePoints;
  AddBodyReferencePosition(
      {super.key,
      this.caseID,
      this.caseNo,
      this.caseBodyId,
      this.isEdit = false,
      this.caseBodyReferencePoints});

  @override
  AddBodyReferencePositionState createState() =>
      AddBodyReferencePositionState();
}

class AddBodyReferencePositionState extends State<AddBodyReferencePosition> {
  bool isPhone = Device.get().isPhone;

  List<Unit> unitList = [
    Unit(id: 1, name: 'เมตร'),
    Unit(id: 2, name: 'เซนติเมตร'),
  ];

  List<CaseReferencePoint> ref1List = [];
  List<CaseReferencePoint> ref2List = [];
  final TextEditingController _refDetailController = TextEditingController();
  final TextEditingController _firstReferenController = TextEditingController();
  final TextEditingController _referenceDistance1Controller =
      TextEditingController();
  final TextEditingController _firstUnitController = TextEditingController();
  final TextEditingController _secondReferenceController =
      TextEditingController();
  final TextEditingController _referenceDistance2Controller =
      TextEditingController();
  final TextEditingController _secondUnitController = TextEditingController();
  final TextEditingController _bodyPositionController = TextEditingController();

  int _firstReferenceIndexSelected = 0, _secondReferenceIndexSelected = 0;
  int _firstUnitIndexSelected = 0, _secondUnitIndexSelected = 0;
  int _firstUnitId = 0, _secondUnitId = 0, _bodyPosition = 0;

  String? text1 = '';
  String? text2 = '';

  List<String> titleList = [];
  List<MyTitle> titles = [];
  bool isLoading = true;

  String? referenceID1 = '', referenceID2 = '';
  String? bodyPositionId = '';

  CaseBodyReferencePoint caseBodyRef = CaseBodyReferencePoint();

  List<BodyPosition> listBodyPositions = [];
  List<String> listBodyPositionsLabel = [];

  @override
  void initState() {
    super.initState();
    asyncMethod();
    // print('isEdit ${widget.isEdit}');
    if (kDebugMode) {
      print(widget.caseBodyReferencePoints.toString());
    }
  }

  asyncMethod() async {
    asyncCall1();
  }

  void asyncCall1() async {
    var result = await TitleDao().getTitleLabel();
    var result2 = await TitleDao().getTitle();
    var result3 =
        await CaseReferencePointDao().getCaseReferencePoint('${widget.caseID}');
    var result4 = await BodyPositionDao().getBodyPosition();
    var result5 = await BodyPositionDao().getBodyPositionLabel();

    setState(() {
      titleList = result;
      titles = result2;
      ref1List = result3;
      ref2List = result3;
      listBodyPositions = result4;
      listBodyPositionsLabel = result5;
      isLoading = false;
    });
    setDefaultData();
  }

  setDefaultData() {
    if (widget.isEdit) {
      caseBodyRef = widget.caseBodyReferencePoints ?? CaseBodyReferencePoint();
      setState(() {
        referenceID1 = caseBodyRef.referenceID1;
        referenceID2 = caseBodyRef.referenceID2;
        _firstUnitId = int.parse(caseBodyRef.referenceUnitId1 ?? '');
        _secondUnitId = int.parse(caseBodyRef.referenceUnitId2 ?? '');

        text1 = ref1().referencePointDetail;
        text2 = ref2().referencePointDetail;
        _firstReferenController.text = ref1().referencePointNo ?? '';
        _secondReferenceController.text = ref2().referencePointNo ?? '';
        _refDetailController.text = caseBodyRef.referenceDetail ?? '';
        _referenceDistance1Controller.text =
            caseBodyRef.referenceDistance1 ?? '';
        caseBodyRef.referenceUnitId1 == '1'
            ? _firstUnitController.text = 'เมตร'
            : _firstUnitController.text = 'เซนติเมตร';
        _referenceDistance2Controller.text =
            caseBodyRef.referenceDistance2 ?? '';
        caseBodyRef.referenceUnitId2 == '1'
            ? _secondUnitController.text = 'เมตร'
            : _secondUnitController.text = 'เซนติเมตร';
        bodyPositionId = caseBodyRef.bodyPositionId;
        _bodyPositionController.text =
            bodyPositionLabel(caseBodyRef.bodyPositionId) ?? '';
      });
    }
  }

  CaseReferencePoint ref1() {
    for (int i = 0; i < ref1List.length; i++) {
      if (ref1List[i].id == int.parse(caseBodyRef.referenceID1 ?? '')) {
        return ref1List[i];
      }
    }
    return CaseReferencePoint();
  }

  CaseReferencePoint ref2() {
    for (int i = 0; i < ref2List.length; i++) {
      if (ref2List[i].id == int.parse(caseBodyRef.referenceID2 ?? '')) {
        return ref2List[i];
      }
    }
    return CaseReferencePoint();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBarWidget(
          title: 'เพิ่มระยะอ้างอิง',
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
                    child: ListView(children: [
                      subtitle('ตำแหน่ง*'),
                      spacer(context),
                      bodyppositionBottomSheet(
                          _bodyPositionController,
                          'กรุณาเลือกตำแหน่ง',
                          'เลือกตำแหน่ง',
                          listBodyPositions,
                          _bodyPosition, (index) {
                        _bodyPosition = index;
                      }, () {
                        setState(() {
                          Navigator.of(context).pop();
                          _bodyPositionController.text =
                              listBodyPositionsLabel[_bodyPosition];
                          bodyPositionId =
                              '${listBodyPositions[_bodyPosition].id}';
                        });
                      }),
                      spacer(context),
                      header('รายละเอียด'),
                      spacer(context),
                      InputField(
                          controller: _refDetailController,
                          hint: 'กรอกรายละเอียด',
                          maxLine: null,
                          onChanged: (value) {}),
                      spacer(context),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          header('จุดอ้างอิง'),
                          TextButton(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.add,
                                  size:
                                      MediaQuery.of(context).size.height * 0.03,
                                  color: Colors.white,
                                ),
                                Text(
                                  'เพิ่ม',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.prompt(
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                      letterSpacing: .5,
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.03,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            onPressed: () async {
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
                      ),
                      spacer(context),
                      subtitle('จุดอ้างอิงที่ 1*'),
                      spacer(context),
                      referenceBottomSheet(
                          _firstReferenController,
                          'กรุณาเลือกจุดอ้างอิง',
                          'เลือกจุดอ้างอิง',
                          ref1List,
                          _firstReferenceIndexSelected, (index) {
                        _firstReferenceIndexSelected = index;
                      }, () {
                        setState(() {
                          Navigator.of(context).pop();
                          _firstReferenController.text =
                              'จุดอ้างอิงที่ ${ref1List[_firstReferenceIndexSelected].referencePointNo.toString()}';
                          text1 = ref1List[_firstReferenceIndexSelected]
                              .referencePointDetail;
                          referenceID1 = ref1List[_firstReferenceIndexSelected]
                              .id
                              .toString();
                        });
                      }),
                      spacer(context),
                      detailView('$text1'),
                      spacer(context),
                      subtitle('ระยะห่าง*'),
                      spacer(context),
                      InputField(
                          keyboardType: const TextInputType.numberWithOptions(
                              signed: true),
                          controller: _referenceDistance1Controller,
                          hint: 'กรอกระยะห่าง',
                          maxLine: null,
                          onChanged: (_) {}),
                      spacer(context),
                      unitModalBottomSheet(
                          _firstUnitController,
                          'กรุณาเลือกหน่วย*',
                          'เลือกหน่วย*',
                          unitList,
                          _firstUnitIndexSelected, (index) {
                        _firstUnitIndexSelected = index;
                      }, () {
                        setState(() {
                          _firstUnitController.text =
                              unitList[_firstUnitIndexSelected].name ?? '';
                          _firstUnitId =
                              unitList[_firstUnitIndexSelected].id ?? -1;

                          Navigator.of(context).pop();
                        });
                      }),
                      spacer(context),
                      subtitle('จุดอ้างอิงที่ 2*'),
                      spacer(context),
                      referenceBottomSheet(
                          _secondReferenceController,
                          'กรุณาเลือกจุดอ้างอิง',
                          'เลือกจุดอ้างอิง',
                          ref2List,
                          _secondReferenceIndexSelected, (index) {
                        _secondReferenceIndexSelected = index;
                      }, () {
                        setState(() {
                          Navigator.of(context).pop();
                          _secondReferenceController.text =
                              'จุดอ้างอิงที่ ${ref2List[_secondReferenceIndexSelected].referencePointNo.toString()}';
                          text2 = ref2List[_secondReferenceIndexSelected]
                              .referencePointDetail;
                          referenceID2 = ref2List[_firstReferenceIndexSelected]
                              .id
                              .toString();
                        });
                      }),
                      spacer(context),
                      detailView('$text2'),
                      spacer(context),
                      subtitle('ระยะห่าง*'),
                      spacer(context),
                      InputField(
                          keyboardType: const TextInputType.numberWithOptions(
                              signed: true),
                          controller: _referenceDistance2Controller,
                          hint: 'กรอกระยะห่าง',
                          maxLine: null,
                          onChanged: (_) {}),
                      spacer(context),
                      unitModalBottomSheet(
                          _secondUnitController,
                          'กรุณาเลือกหน่วย*',
                          'เลือกหน่วย*',
                          unitList,
                          _secondUnitIndexSelected, (index) {
                        _secondUnitIndexSelected = index;
                      }, () {
                        setState(() {
                          Navigator.of(context).pop();
                          _secondUnitController.text =
                              unitList[_secondUnitIndexSelected].name ?? '';
                          _secondUnitId =
                              unitList[_secondUnitIndexSelected].id ?? -1;
                        });
                      }),
                      spacer(context),
                      spacer(context),
                      saveButton(),
                      spacer(context),
                      spacer(context),
                    ])))));
  }

  Widget subtitle(String? text) {
    return Text(
      '$text',
      textAlign: TextAlign.left,
      style: GoogleFonts.prompt(
        textStyle: TextStyle(
          color: Colors.white,
          letterSpacing: .5,
          fontSize: MediaQuery.of(context).size.height * 0.025,
        ),
      ),
    );
  }

  Widget header(String? text) {
    return Text(
      '$text',
      textAlign: TextAlign.left,
      style: GoogleFonts.prompt(
        textStyle: TextStyle(
          color: Colors.white,
          letterSpacing: .5,
          fontSize: MediaQuery.of(context).size.height * 0.03,
        ),
      ),
    );
  }

  Widget spacer(context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.015,
      width: MediaQuery.of(context).size.width * 0.015,
    );
  }

  Widget unitModalBottomSheet(
      TextEditingController controller,
      String? hint,
      String? title,
      List<Unit> items,
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
                              items[index].name ?? '',
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

  Widget detailView(String? text) {
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

  Widget saveButton() {
    return AppButton(
        color: pinkButton,
        textColor: Colors.white,
        text: 'บันทึก',
        onPressed: () {
          if (validate()) {
            bool isNumDis1 = true;
            try {
              if (_referenceDistance1Controller.text != '') {
                double.parse(_referenceDistance1Controller.text);
              }
              if (_referenceDistance1Controller.text != '') {
                double.parse(_referenceDistance2Controller.text);
              }
            } catch (ex) {
              isNumDis1 = false;
            }

            if (isNumDis1) {
              if (widget.isEdit) {
                _editCaseBodyRef();
              } else {
                if (ref1List.isNotEmpty && ref2List.isNotEmpty) {
                  _addNewCaseBodyRef();
                } else {
                  _showDialog(context);
                }
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
                'กรุณากรอกข้อมูลที่มีเครื่องหมายดอกจัน (*) ให้ครบถ้วน',
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
        });
  }

  bool validate() {
    return bodyPositionId != '' &&
        referenceID1 != '' &&
        _referenceDistance1Controller.text != '' &&
        _firstUnitId != 0 &&
        referenceID2 != '' &&
        _referenceDistance2Controller.text != '' &&
        _secondUnitId != 0;
  }

  void _editCaseBodyRef() {
    caseBodyRef.fidsId = widget.caseID.toString();
    caseBodyRef.bodyId = widget.caseBodyId.toString();
    caseBodyRef.referenceDetail = _refDetailController.text;
    caseBodyRef.referenceID1 = referenceID1;
    caseBodyRef.referenceDistance1 = _referenceDistance1Controller.text;
    caseBodyRef.referenceUnitId1 = _firstUnitId.toString();
    caseBodyRef.referenceID2 = referenceID2;
    caseBodyRef.referenceDistance2 = _referenceDistance2Controller.text;
    caseBodyRef.referenceUnitId2 = _secondUnitId.toString();
    caseBodyRef.bodyPositionId = bodyPositionId;
    caseBodyRef.createDate = '';
    caseBodyRef.createBy = '';
    caseBodyRef.updateDate = '';
    caseBodyRef.updateBy = '';
    caseBodyRef.activeFlag = '1';
    if (kDebugMode) {
      print(caseBodyRef);
    }
    Navigator.of(context).pop(caseBodyRef);
  }

  void _addNewCaseBodyRef() {
    referenceID1 = ref1List[_firstReferenceIndexSelected].id.toString();
    referenceID2 = ref2List[_secondReferenceIndexSelected].id.toString();
    var caseBodyRefPoint = CaseBodyReferencePoint();
    caseBodyRefPoint.fidsId = widget.caseID.toString();
    caseBodyRefPoint.bodyId = widget.caseBodyId.toString();
    caseBodyRefPoint.referenceDetail = _refDetailController.text;
    caseBodyRefPoint.referenceID1 = referenceID1;
    caseBodyRefPoint.referenceDistance1 = _referenceDistance1Controller.text;
    caseBodyRefPoint.referenceUnitId1 = _firstUnitId.toString();
    caseBodyRefPoint.referenceID2 = referenceID2;
    caseBodyRefPoint.referenceDistance2 = _referenceDistance2Controller.text;
    caseBodyRefPoint.referenceUnitId2 = _secondUnitId.toString();
    caseBodyRefPoint.bodyPositionId = bodyPositionId;
    caseBodyRefPoint.createDate = '';
    caseBodyRefPoint.createBy = '';
    caseBodyRefPoint.updateDate = '';
    caseBodyRefPoint.updateBy = '';
    caseBodyRefPoint.activeFlag = '1';
    if (kDebugMode) {
      print('ActiveFlag: ');
    }
    Navigator.of(context).pop(caseBodyRefPoint);
  }

  void _showDialog(context) {
    Widget okButton = TextButton(
      child: const Text("ตกลง"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    AlertDialog alert = AlertDialog(
      title: const Text('เกิดข้อผิดพลาด'),
      content: const Text('กรุณาเพิ่มและเลือกจุดอ้างอิง'),
      actions: [
        okButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget bodyppositionBottomSheet(
      TextEditingController controller,
      String? hint,
      String? title,
      List<BodyPosition> items,
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
                              '${items[index].bodyPosition}',
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

  String? bodyPositionLabel(String? id) {
    try {
      for (int i = 0; i < listBodyPositions.length; i++) {
        if ('$id' == '${listBodyPositions[i].id}') {
          return listBodyPositions[i].bodyPosition;
        }
      }
      return '';
    } catch (ex) {
      return '';
    }
  }
}
