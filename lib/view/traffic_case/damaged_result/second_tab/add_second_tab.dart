import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../Utils/color.dart';
import '../../../../models/CaseEvident.dart';
import '../../../../models/CaseEvidentLocation.dart';
import '../../../../models/CaseRelatedPerson.dart';
import '../../../../models/Department.dart';
import '../../../../models/EvidenceGroup.dart';
import '../../../../models/EvidentType.dart';
import '../../../../models/FidsCrimeScene.dart';
import '../../../../models/Package.dart';
import '../../../../models/WorkGroup.dart';
import '../../../../widget/app_button.dart';
import '../../../../widget/text_field_widget.dart';
import '../../../../widget/textfield_modal_bottom_sheet.dart';
import '../../../life_case/evident/model/CaseEvidentForm.dart';

class AddSecondTab extends StatefulWidget {
  final int? caseID;
  final String? caseNo, vehicleDetail, lastEvidentNo;
  final int? count, vehicleId;
  final bool isEdit;
  final CaseEvidentForm? caseEvidentForm;

  const AddSecondTab(
      {super.key,
      this.caseID,
      this.caseNo,
      this.isEdit = false,
      this.count,
      this.caseEvidentForm,
      this.vehicleDetail,
      this.vehicleId,
      this.lastEvidentNo});

  @override
  AddSecondTabState createState() => AddSecondTabState();
}

class AddSecondTabState extends State<AddSecondTab>
    with SingleTickerProviderStateMixin {
  bool isPhone = Device.get().isPhone;

  final TextEditingController _evidentDetailController =
      TextEditingController();
  final TextEditingController _vehiclePositionController =
      TextEditingController();
  final TextEditingController _evidentAmountController =
      TextEditingController();
  final TextEditingController _evidentUnitController = TextEditingController();
  final TextEditingController _workGroupController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();

  int personalSelected = 0;
  int evidentGroupIndexSelected = 0;
  int workGroupIndexSelected = 0;
  int devliverWorkGroupIndexSelected = 0;
  int departmentIndexSelected = 0;

  int? evidentFoundID,
      evidentLocationID,
      unitId,
      workGroupId,
      departmentId,
      deliverWorkGroupId;

  String evidentNo = '';
  String personalSelectId = '';

  List evidentTypeList = [];
  List<EvidentType>? evidentTypes;

  List caseEvidenteFoundList = [];
  List<EvidentType> caseEvidenteFounds = [];
  List evidenceGroupLabels = [];
  List<EvidenceGroup> evidenceGroups = [];
  int evidenceGroupSelectId = -1;

  String evidentLocationDetail = '';
  String evidentLocationPosition = '';
  String evidentLocationText = '';

  List packageList = [];
  List<Package> packages = [];

  List workGroupList = [];
  List<WorkGroup> workGroups = [];

  List departmentList = [];
  List<Department> departments = [];

  List<CaseEvidentLocation> caseEvidentLocations = [];

  int _evidentOperateValue = 1;

  var uGroup = -1;
  var number = '';
  String amount = '';

  CaseEvidentLocation caseEvidentLocation = CaseEvidentLocation();

  List<CaseRelatedPerson> caseRelatedPerson = [];
  late List<String> caseRelatedPersonLabel = [];
  FidsCrimeScene? fidsCrimeScene;

  bool isLoading = true;

  @override
  void initState() {
    if (widget.isEdit) {
      asyncCall1();
    }
    if (kDebugMode) {
      print(widget.lastEvidentNo);
    }
    super.initState();
  }

  void asyncCall1() async {
    var workgroups = await WorkGroupDao().getWorkGroup();
    var workGroupLabel = await WorkGroupDao().getWorkGroupLabel();
    var departments = await DepartmentDao().getDepartment();
    var departmentLabels = await DepartmentDao().getDepartmentLabel();
    var fidsCrimeScene =
        await FidsCrimeSceneDao().getFidsCrimeSceneById(widget.caseID ?? -1);

    setState(() {
      workGroups = workgroups;
      workGroupList = workGroupLabel;
      this.departments = departments;
      departmentList = departmentLabels;
      this.fidsCrimeScene = fidsCrimeScene;
      isLoading = false;
    });

    setupData();
  }

  setupData() {
    setState(() {
      var newAmt = '';
      if (!widget.isEdit) {
        if (widget.caseNo != '' && widget.caseNo != null) {
          var caseNo = widget.caseNo;
          var caseNoSubString = caseNo?.substring(0, 16);
          number = caseNoSubString ?? '';
          if (kDebugMode) {
            print('widget.lastEvidentNo: ${widget.lastEvidentNo}');
          }
          if (widget.lastEvidentNo == '0') {
            newAmt = '001';
          } else {
            int amt = int.parse(widget.lastEvidentNo ?? '') + 1;
            amount = amt.toString();

            if (amount.length == 1) {
              newAmt = '00$amount';
            } else if (amount.length > 3) {
              newAmt = '$amount}';
            } else {
              newAmt = '0$amount';
            }
          }
          evidentNo = '$number$newAmt';
        }
      } else {
        evidentNo = widget.caseEvidentForm?.evidentNo ?? '';
        _evidentDetailController.text =
            widget.caseEvidentForm?.evidentDetail ?? '';
        _evidentAmountController.text =
            widget.caseEvidentForm?.evidentAmount ?? '';
        _evidentUnitController.text = widget.caseEvidentForm?.evidentUnit ?? '';
        _vehiclePositionController.text =
            widget.caseEvidentForm?.vehiclePosition ?? '';
        if (widget.caseEvidentForm?.isEvidentOperate == '1') {
          _evidentOperateValue = 1;
        } else if (widget.caseEvidentForm?.isEvidentOperate == '2') {
          _evidentOperateValue = 2;
        }

        if (_evidentOperateValue == 2) {
          for (int i = 0; i < workGroups.length; i++) {
            if ('${workGroups[i].id}' ==
                '${widget.caseEvidentForm?.workGroupID}') {
              workGroupId =
                  int.parse(widget.caseEvidentForm?.workGroupID ?? '');
              workGroupIndexSelected = i;
              _workGroupController.text = workGroups[i].name ?? '';
            }
          }

          for (int i = 0; i < departments.length; i++) {
            if ('${departments[i].id}' ==
                '${widget.caseEvidentForm?.departmentID}') {
              departmentId =
                  int.parse(widget.caseEvidentForm?.departmentID ?? '');
              departmentIndexSelected = i;
              _departmentController.text = departments[i].name ?? '';
            }
          }
        }
      }
    });
  }

  Widget vehicleDetail() {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.03,
              vertical: MediaQuery.of(context).size.width * 0.01),
          child: Text(
            '${widget.vehicleDetail}',
            textAlign: TextAlign.left,
            style: GoogleFonts.prompt(
              textStyle: TextStyle(
                color: textColor,
                letterSpacing: .5,
                fontSize: MediaQuery.of(context).size.height * 0.022,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Container(
            alignment: Alignment.center,
            child: Text(
              'วัตถุพยานที่ตรวจเก็บ',
              style: GoogleFonts.prompt(
                textStyle: TextStyle(
                  color: Colors.white,
                  letterSpacing: 0,
                  fontSize: MediaQuery.of(context).size.height * 0.025,
                ),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          actions: [
            Container(
              width: MediaQuery.of(context).size.width * 0.1,
            )
          ],
        ),
        body: _body());
  }

  Widget _body() {
    return Container(
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
              : const EdgeInsets.only(left: 32, right: 32, top: 32, bottom: 32),
          child: ListView(
            children: [
              vehicleDetail(),
              spacer(),
              title('Evidence No.'),
              detailView(evidentNo),
              spacer(),
              title('รายละเอียด'),
              InputField(
                  hint: 'กรอกรายละเอียด',
                  controller: _evidentDetailController,
                  onChanged: (val) {}),
              spacer(),
              title('ตำแหน่งการจัดเก็บ'),
              InputField(
                  hint: 'กรอกตำแหน่งการจัดเก็บ',
                  controller: _vehiclePositionController,
                  onChanged: (val) {}),
              spacer(),
              amountView(),
              spacer(),
              title('การดำเนินการเกี่ยวกับวัตถุพยาน'),
              isEvidentOperate(),
              spacer(),
              _evidentOperateValue == 1
                  ? Container()
                  : modalBottomSheet(
                      _workGroupController,
                      'กรุณาเลือกกลุ่มงานที่ดำเนินการ',
                      'เลือกกลุ่มงานที่ดำเนินการ',
                      workGroupList,
                      workGroupIndexSelected, (context, index) {
                      _workGroupController.text = workGroupList[index];
                      workGroupId = workGroups[index].id;
                      Navigator.of(context).pop();
                    }, Container(), false),
              spacer(),
              _evidentOperateValue == 1
                  ? Container()
                  : modalBottomSheet(
                      _departmentController,
                      'กรุณาเลือกหน่วยงานที่ดำเนินการ',
                      'เลือกหน่วยงานที่ดำเนินการ',
                      departmentList,
                      departmentIndexSelected, (context, index) {
                      departmentId = departments[index].id;
                      _departmentController.text = departmentList[index];
                      Navigator.of(context).pop();
                    }, Container(), false),
              saveButton()
            ],
          ),
        ),
      ),
    );
  }

  String personaltLabel(String id) {
    for (int i = 0; i < caseRelatedPerson.length; i++) {
      if (id == '${caseRelatedPerson[i].id}') {
        return caseRelatedPersonLabel[i];
      }
    }
    return '';
  }

  amountView() {
    final node = FocusScope.of(context);
    return Row(
      children: [
        Expanded(
          child: textField(_evidentAmountController, 'กรอกจำนวน', (value) {},
              (_) => node.unfocus()),
        ),
        const SizedBox(
          width: 12,
        ),
        Expanded(
          child: textField(_evidentUnitController, 'กรอกหน่วย', (value) {},
              (_) => node.unfocus()),
        ),
      ],
    );
  }

  detailView(String text) {
    return Container(
      color: whiteOpacity,
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
                    text,
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

  textField(
    TextEditingController controller,
    String hint,
    Function(String) onChanged,
    Function onFieldSubmitted,
  ) {
    return InputField(
      controller: controller,
      hint: hint,
      onChanged: (str) {
        onChanged(str);
      },
      onFieldSubmitted: onFieldSubmitted,
    );
  }

  Widget title(String title) {
    return Row(
      children: [
        Text(
          title,
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

  Widget header(String title) {
    return Row(
      children: [
        Text(
          title,
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

  spacer() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.015,
    );
  }

  Widget subtitle(String title) {
    return Row(
      children: [
        Text(
          title,
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

  Widget modalBottomSheet(
      TextEditingController controller,
      String hint,
      String title,
      List items,
      int indexSelected,
      Function onPressed,
      Widget sufflixIcon,
      bool isCanClear) {
    return TextFieldModalBottomSheet(
      suffixIcon: sufflixIcon,
      controller: controller,
      hint: hint,
      isCanClear: isCanClear,
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
                          Text(title,
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

  isEvidentOperate() {
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
                groupValue: _evidentOperateValue,
                onChanged: (val) {
                  setState(() {
                    _evidentOperateValue = val ?? -1;
                    if (kDebugMode) {
                      print(_evidentOperateValue);
                    }
                  });
                },
              ),
            ),
            Text(
              'ส่งมอบพนักงานสอบสวน',
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
                groupValue: _evidentOperateValue,
                onChanged: (val) {
                  setState(() {
                    _evidentOperateValue = val ?? -1;
                    if (kDebugMode) {
                      print(_evidentOperateValue);
                    }
                    _workGroupController.text = '';
                    _departmentController.text = '';
                    workGroupId = -2;
                    departmentId = -2;
                  });
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
      ],
    );
  }

  Widget saveButton() {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
      child: AppButton(
          color: pinkButton,
          textColor: Colors.white,
          text: 'บันทึกวัตถุพยานที่ตรวจเก็บ',
          onPressed: () async {
            // if (validate()) {
            bool numValidate = true;
            try {
              if (_evidentAmountController.text != '') {
                int.parse(_evidentAmountController.text);
              }
            } catch (ex) {
              numValidate = false;
            }
            if (numValidate) {
              if (kDebugMode) {
                print('result.evidentNo : $evidentNo');
                print(
                    'result.evidentDetail : ${_evidentDetailController.text}');
                print(
                    'result.vehiclePosition : ${_vehiclePositionController.text}');
                print(
                    'result.evidentAmount : ${_evidentAmountController.text}');
                print('result.evidentUnit : ${_evidentUnitController.text}');
                print('result.isEvidentOperate : $_evidentOperateValue');
                print('result.departmentID : $departmentId');
                print('result.workGroupID : $workGroupId');
              }

              if (widget.isEdit) {
                await CaseEvidentDao()
                    .updateCaseEvidentTraffic(
                        evidentNo,
                        _evidentDetailController.text,
                        _vehiclePositionController.text,
                        int.parse(_evidentAmountController.text),
                        _evidentUnitController.text,
                        _evidentOperateValue,
                        departmentId ?? -1,
                        workGroupId ?? -1,
                        widget.caseEvidentForm?.id ?? '')
                    .then((value) => Navigator.of(context).pop(true));
              } else {
                await CaseEvidentDao()
                    .createCaseEvidentTraffic(
                      widget.caseID ?? -1,
                      evidentNo,
                      _evidentDetailController.text,
                      _vehiclePositionController.text,
                      int.parse(_evidentAmountController.text),
                      _evidentUnitController.text,
                      _evidentOperateValue,
                      departmentId ?? -1,
                      workGroupId ?? -1,
                      widget.vehicleId.toString(),
                    )
                    .then((value) => Navigator.of(context).pop(true));
              }
            } else {
              final snackBar = SnackBar(
                content: Text(
                  'กรุณากรอกจำนวนเป็นตัวเลข',
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
            // } else {
            //   final snackBar = SnackBar(
            //     content: Text(
            //       'กรุณากรอกข้อมูลที่มีเครื่องหมายดอกจัน (*) ให้​ครบถ้วน',
            //       textAlign: TextAlign.center,
            //       style: GoogleFonts.prompt(
            //         textStyle: TextStyle(
            //           color: Colors.white,
            //           letterSpacing: .5,
            //           fontSize: MediaQuery.of(context).size.height * 0.02,
            //         ),
            //       ),
            //     ),
            //   );
            //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
            // }
          }),
    );
  }

  String workgroupLabel(String id) {
    for (int i = 0; i < workGroups.length; i++) {
      if (id == '${workGroups[i].id}') {
        return workGroups[i].name ?? '';
      }
    }
    return '';
  }

  String departmentLabel(String id) {
    for (int i = 0; i < departments.length; i++) {
      if (id == '${departments[i].id}') {
        return departments[i].name ?? '';
      }
    }
    return '';
  }
}
