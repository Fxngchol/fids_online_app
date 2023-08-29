import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../Utils/color.dart';
import '../../../../models/CaseEvident.dart';
import '../../../../models/CaseEvidentDeliver.dart';
import '../../../../models/CaseEvidentFound.dart';
import '../../../../models/CaseEvidentLocation.dart';
import '../../../../models/CaseRelatedPerson.dart';
import '../../../../models/Department.dart';
import '../../../../models/EvidenceCheck.dart';
import '../../../../models/EvidenceGroup.dart';
import '../../../../models/EvidentType.dart';
import '../../../../models/FidsCrimeScene.dart';
import '../../../../models/Package.dart';
import '../../../../models/Unit.dart';
import '../../../../models/WorkGroup.dart';
import '../../../../widget/app_button.dart';
import '../../../../widget/blurry_dialog.dart';
import '../../../../widget/text_field_widget.dart';
import '../../../../widget/textfield_modal_bottom_sheet.dart';
import '../model/CaseEvidentForm.dart';
import 'add_evident_kept.dart';

class EvidentKeptForm extends StatefulWidget {
  final int? caseID;
  final String? caseNo;
  final int? count;
  final bool isEdit;
  final CaseEvidentForm? caseEvidentForm;

  const EvidentKeptForm(
      {super.key,
      this.caseID,
      this.caseNo,
      this.isEdit = false,
      this.count,
      this.caseEvidentForm});

  @override
  EvidentKeptFormState createState() => EvidentKeptFormState();
}

class EvidentKeptFormState extends State<EvidentKeptForm>
    with SingleTickerProviderStateMixin {
  late TabController controller;

  bool isLoading = true;
  bool isPhone = Device.get().isPhone;

  CaseEvidentForm caseEviForm =
      CaseEvidentForm(caseEvidentLocation: [], caseEvidentDeliver: []);

  var evidentGroupLabels = [];
  var evidentTypeLabels = [];
  var evidentCheckLabels = [];
  var unitLabels = [];
  var packageLabels = [];
  var workGroupLabel = [];
  var departmentLabel = [];

  var numbur = '';
  String? amount = '';

  final TextEditingController _evidentFoundController = TextEditingController();

  List evidentLocationList = [];
  List<CaseEvidentFound> evidentLocations = [];
  int evidentTypeIndexSelected = 0;

  int evidentLocationID = -1;
  String? labelNo;

  String? evidentLocationDetail = '';
  String? area = '';
  String? evidentLocationText = '';

  List? unitList = [];
  List<Unit>? units = [];

  List? evidentTypeList = [];
  List<EvidentType>? evidentTypes = [];
  int? evdentTypeSelectId = -1;

  final TextEditingController _workDeliverGroupController =
      TextEditingController();

  List? workGroupList = [];
  List<WorkGroup>? workGroups = [];
  int? devliverWorkGroupIndexSelected = 0;
  int? evidentCheckIndexSelected = 0;

  int? deliverWorkGroupId = -1;

  List? evidenceCheckLabels = [];
  List<EvidenceCheck>? evidenceChecks = [];
  int? evidenceCheckSelectId = -1;

  FidsCrimeScene? caseFids;
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _evidenceLocationDetailController =
      TextEditingController();
  final TextEditingController _labelNoController = TextEditingController();

  List<CaseRelatedPerson>? caseRelatedPerson = [];
  List<String>? caseRelatedPersonLabel = [];

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 3, vsync: this);
    asyncMethod();
  }

  asyncMethod() async {
    asyncCall1();
  }

  void asyncCall1() async {
    var result = await EvidenceGroupDao().getEvidenceGroup();
    var result2 = await EvidentypeDao().getEvidentType();
    var result3 = await EvidenceCheckDao().getEvidenceCheck();
    var result4 = await UnitDao().getUnit();
    var result5 = await PackageDao().getPackage();
    var result6 = await WorkGroupDao().getWorkGroup();
    var result7 = await DepartmentDao().getDepartment();
    var result8 =
        await FidsCrimeSceneDao().getFidsCrimeSceneById(widget.caseID ?? -1);
    var result19 = await CaseRelatedPersonDao()
        .getCaseRelatedPersonLabel(widget.caseID ?? -1);
    // var  result7 = await BodyPositionDao().getBodyPosition();
    // var result3;
    // var result4;
    // var result6;

    if (widget.isEdit) {
      // result3 = await CaseBodyDao().getCaseBodyById(widget.caseBodyId);
      // result4 = await CaseBodyReferencePointDao()
      //     .getCaseBodyReferencePointById(widget.caseBodyId.toString());
      // result6 = await CaseBodyWoundDao()
      //     .getCaseBodyWound(widget.caseBodyId.toString());
    }

    if (!widget.isEdit) {
      if (widget.caseNo != '' && widget.caseNo != null) {
        var mock = widget.caseNo;
        var mock2 = mock?.substring(0, 16);
        numbur = mock2 ?? '';
        amount = '000';
        if (widget.count != null) {
          if (widget.count! < 9) {
            amount = '00${widget.count! + 1}';
          } else if (widget.count! > 99) {
            amount = '${widget.count! + 1}';
          } else {
            amount = '0${widget.count! + 1}';
          }
        }

        if (amount == '000') {
          amount = '001';
        }
        caseEviForm.evidentNo = '$numbur$amount';
      }
    }

    var result51 =
        await CaseEvidentFoundDao().getCaseEvidentFound(widget.caseID ?? -1);
    var result61 = await CaseEvidentFoundDao()
        .getCaseEvidentFoundLabel(widget.caseID ?? -1);

    var result11 = await EvidentypeDao().getEvidentType();
    var result21 = await EvidentypeDao().getEvidentTypeLabel();

    var result31 = await UnitDao().getUnit();
    var result41 = await UnitDao().getUnitLabel();

    var result9 = await WorkGroupDao().getWorkGroup();
    var result10 = await WorkGroupDao().getWorkGroupLabel();

    var result17 = await EvidenceCheckDao().getEvidenceCheck();
    var result18 = await EvidenceCheckDao().getEvidenceCheckLabel();
    var result30 =
        await CaseRelatedPersonDao().getCaseRelatedPerson(widget.caseID ?? -1);

    setState(() {
      evidentGroupLabels = result;
      evidentTypeLabels = result2;
      evidentCheckLabels = result3;
      unitLabels = result4;
      packageLabels = result5;
      workGroupLabel = result6;
      departmentLabel = result7;

      if (widget.isEdit) {
        caseEviForm = widget.caseEvidentForm ?? CaseEvidentForm();
      }
      evidentLocations = result51;
      evidentLocationList = result61;
      evidentTypes = result11;
      evidentTypeList = result21;

      units = result31;
      unitList = result41;

      workGroups = result9;
      workGroupList = result10;

      evidenceChecks = result17;
      evidenceCheckLabels = result18;

      caseFids = result8;
      caseRelatedPerson = result30;
      caseRelatedPersonLabel = result19;

      isLoading = false;
    });
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
            TextButton(
              child: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Text(
                  'บันทึก',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.prompt(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: isPhone
                          ? MediaQuery.of(context).size.height * 0.01
                          : MediaQuery.of(context).size.height * 0.02,
                    ),
                  ),
                ),
              ),
              onPressed: () async {
                if (!widget.isEdit) {
                  await CaseEvidentDao()
                      .createCaseEvident(
                          widget.caseID ?? -1,
                          caseEviForm.evidentNo ?? '',
                          caseEviForm.evidenceTypeID == '' ||
                                  caseEviForm.evidenceTypeID == null ||
                                  caseEviForm.evidenceTypeID == 'null'
                              ? -1
                              : int.parse(caseEviForm.evidenceTypeID ?? ''),
                          caseEviForm.evidentDetail,
                          caseEviForm.evidentAmount == '' ||
                                  caseEviForm.evidentAmount == null ||
                                  caseEviForm.evidentAmount == 'null'
                              ? -1
                              : int.parse(caseEviForm.evidentAmount ?? ''),
                          caseEviForm.evidentUnit,
                          caseEviForm.packageID == '' ||
                                  caseEviForm.packageID == null ||
                                  caseEviForm.packageID == 'null'
                              ? -1
                              : int.parse(caseEviForm.packageID ?? ''),
                          caseEviForm.packageOther,
                          caseEviForm.isEvidentOperate == ''
                              ? -1
                              : caseEviForm.isEvidentOperate == '1'
                                  ? 1
                                  : caseEviForm.isEvidentOperate == '2'
                                      ? 2
                                      : -1,
                          caseEviForm.departmentID == '' ||
                                  caseEviForm.departmentID == null ||
                                  caseEviForm.departmentID == 'null'
                              ? -1
                              : int.parse(caseEviForm.departmentID ?? ''),
                          caseEviForm.workGroupID == '' ||
                                  caseEviForm.workGroupID == null ||
                                  caseEviForm.workGroupID == 'null'
                              ? -1
                              : int.parse(caseEviForm.workGroupID ?? ''),
                          -1,
                          -1,
                          // caseEvidentForm.evidenceGroupId,
                          caseEviForm.evidenceCheckID ?? '',
                          '',
                          '',
                          '',
                          '',
                          1,
                          caseEviForm.personalID ?? '')
                      .then((caseEvidentId) async {
                    for (int i = 0;
                        i < caseEviForm.caseEvidentLocation!.length;
                        i++) {
                      await CaseEvidentLocationDao().createCaseEvidentLocation(
                          widget.caseID ?? -1,
                          caseEvidentId,
                          caseEviForm.caseEvidentLocation?[i].labelNo,
                          caseEviForm
                              .caseEvidentLocation?[i].evidentLocationDetail,
                          '',
                          '',
                          '',
                          '',
                          true,
                          caseEviForm.caseEvidentLocation?[i].area,
                          caseEviForm.caseEvidentLocation?[i].labelNo);
                    }

                    for (int i = 0;
                        i < caseEviForm.caseEvidentDeliver!.length;
                        i++) {
                      await CaseEvidentDeliverDao().createCaseEvidentDeliver(
                          widget.caseID ?? -1,
                          caseEvidentId,
                          caseEviForm.caseEvidentDeliver?[i].workGroupId ?? -1,
                          caseEviForm.caseEvidentDeliver?[i].evidenceCheckId ??
                              '');
                    }
                    Navigator.of(context).pop(true);
                  });
                } else {
                  await CaseEvidentDao()
                      .updateCaseEvident(
                          widget.caseID ?? -1,
                          caseEviForm.evidentNo,
                          caseEviForm.evidenceTypeID == '' ||
                                  caseEviForm.evidenceTypeID == null ||
                                  caseEviForm.evidenceTypeID == 'null'
                              ? -1
                              : int.parse(caseEviForm.evidenceTypeID ?? ''),
                          caseEviForm.evidentDetail,
                          caseEviForm.evidentAmount == '' ||
                                  caseEviForm.evidentAmount == null ||
                                  caseEviForm.evidentAmount == 'null'
                              ? -1
                              : int.parse(caseEviForm.evidentAmount ?? ''),
                          caseEviForm.evidentUnit,
                          caseEviForm.packageID == '' ||
                                  caseEviForm.packageID == null ||
                                  caseEviForm.packageID == 'null'
                              ? -1
                              : int.parse(caseEviForm.packageID ?? ''),
                          caseEviForm.packageOther,
                          caseEviForm.isEvidentOperate == ''
                              ? -1
                              : caseEviForm.isEvidentOperate == '1'
                                  ? 1
                                  : caseEviForm.isEvidentOperate == '2'
                                      ? 2
                                      : -1,
                          caseEviForm.departmentID == '' ||
                                  caseEviForm.departmentID == null ||
                                  caseEviForm.departmentID == 'null'
                              ? -1
                              : int.parse(caseEviForm.departmentID ?? ''),
                          caseEviForm.workGroupID == '' ||
                                  caseEviForm.workGroupID == null ||
                                  caseEviForm.workGroupID == 'null'
                              ? -1
                              : int.parse(caseEviForm.workGroupID ?? ''),
                          -1,
                          -1,
                          caseEviForm.evidenceCheckID,
                          '',
                          '',
                          '',
                          '',
                          1,
                          caseEviForm.id,
                          caseEviForm.personalID)
                      .then((value) async {
                    for (int i = 0;
                        i < caseEviForm.caseEvidentLocation!.length;
                        i++) {
                      await CaseEvidentLocationDao().updateCaseEvidentLocation(
                          widget.caseID ?? -1,
                          caseEviForm.id == '' || caseEviForm.id == null
                              ? -2
                              : int.parse(caseEviForm.id ?? ''),
                          caseEviForm.caseEvidentLocation?[i].labelNo ?? '',
                          caseEviForm
                              .caseEvidentLocation?[i].evidentLocationDetail,
                          caseEviForm.caseEvidentLocation?[i].labelNo,
                          caseEviForm.caseEvidentLocation?[i].area,
                          caseEviForm.caseEvidentLocation?[i].id);
                    }

                    for (int i = 0;
                        i < caseEviForm.caseEvidentDeliver!.length;
                        i++) {
                      await CaseEvidentDeliverDao().updateCaseEvidentDeliver(
                          caseEviForm.caseEvidentDeliver?[i].id ?? -1,
                          widget.caseID ?? -1,
                          caseEviForm.id == '' || caseEviForm.id == null
                              ? -2
                              : int.parse(caseEviForm.id ?? ''),
                          caseEviForm.caseEvidentDeliver?[i].workGroupId ?? -1,
                          caseEviForm.caseEvidentDeliver?[i].evidenceCheckId ??
                              '');
                    }
                    Navigator.of(context).pop(true);
                  });
                }
              },
            )
          ],
          bottom: TabBar(
            indicatorColor: pinkButton,
            indicatorWeight: 10,
            labelColor: const Color(0xffffffff), // สีของข้อความปุ่มที่เลือก
            unselectedLabelColor:
                const Color(0x55ffffff), // สีของข้อความปุ่มที่ไม่ได้เลือก
            tabs: <Tab>[
              Tab(
                // icon: Icon(Icons.domain, color: Colors.white),
                child: Text(
                  'วัตถุพยาน',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.prompt(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: isPhone
                          ? MediaQuery.of(context).size.height * 0.01
                          : MediaQuery.of(context).size.height * 0.02,
                    ),
                  ),
                ),
              ),
              Tab(
                // icon: Icon(Icons.domain_disabled, color: Colors.white),
                child: Text(
                  'บริเวณ',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.prompt(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: isPhone
                          ? MediaQuery.of(context).size.height * 0.01
                          : MediaQuery.of(context).size.height * 0.02,
                    ),
                  ),
                ),
              ),
              Tab(
                // icon: Icon(Icons.pin_drop, color: Colors.white),
                child: Text(
                  'การส่งตรวจ',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.prompt(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: isPhone
                          ? MediaQuery.of(context).size.height * 0.01
                          : MediaQuery.of(context).size.height * 0.02,
                    ),
                  ),
                ),
              ),
            ],
            controller: controller,
          ),
        ),
        body: TabBarView(
          controller: controller,
          children: <Widget>[
            tabOne(),
            tabTwo(),
            tabThree(),
          ],
        ));
  }

  Widget tabThree() {
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
                    : const EdgeInsets.only(
                        left: 32, right: 32, top: 32, bottom: 32),
                child: Column(
                  children: [
                    headerTabThreeView(),
                    Expanded(
                      child: ListView.builder(
                          itemCount: caseEviForm.caseEvidentDeliver == null
                              ? 0
                              : caseEviForm.caseEvidentDeliver!.length + 1,
                          itemBuilder: (BuildContext ctxt, int index) {
                            if (index == 0) {
                              return formThree();
                            }

                            return _listItem(index - 1);
                          }),
                    ),
                  ],
                ))));
  }

  Widget headerTabThreeView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          'รายการการส่งตรวจ',
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
    );
  }

  Widget formThree() {
    return Column(
      children: [
        spacerTitle(),
        // title('ประเภทการจัดเก็บ*'),
        // spacerTitle(),
        title('การส่งตรวจพิสูจน์*'),
        spacer(context),
        modalBottomSheetThree(
            _workDeliverGroupController,
            'กรุณาเลือกกลุ่มงานที่ดำเนินการ',
            'เลือกกลุ่มงานที่ดำเนินการ',
            workGroupList ?? [],
            devliverWorkGroupIndexSelected ?? -1, (context, index) {
          _workDeliverGroupController.text = workGroupList?[index];
          deliverWorkGroupId = workGroups?[index].id;
          Navigator.of(context).pop();
        }),
        spacerTitle(),
        saveButtonThree(),
        spacer(context), spacer(context), spacer(context),
        title('รายการการส่งตรวจ'),
        spacer(context),
      ],
    );
  }

  Widget tabTwo() {
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
                    : const EdgeInsets.only(
                        left: 32, right: 32, top: 32, bottom: 32),
                child: Column(
                  children: [
                    headerTabTwoView(),
                    Expanded(
                      child: ListView.builder(
                          itemCount: caseEviForm.caseEvidentLocation == null
                              ? 0
                              : caseEviForm.caseEvidentLocation!.length + 1,
                          itemBuilder: (BuildContext ctxt, int index) {
                            if (index == 0) {
                              return caseFids?.caseCategoryID == 1
                                  ? formTab2_2()
                                  : formTab2_1();
                            }
                            return _listItem2(index - 1);
                          }),
                    ),
                  ],
                ))));
  }

  Widget formTab2_2() {
    return Column(
      children: [
        spacer(context),
        title('บริเวณ*'),
        spacer(context),
        textField(_areaController, 'กรอกรายละเอียด'),
        spacerTitle(),
        spacer(context),
        title('ที่'),
        spacer(context),
        textField(_evidenceLocationDetailController, 'กรอกรายละเอียด'),
        spacerTitle(),
        spacer(context),
        title('ป้ายหมายเลข'),
        spacer(context),
        textField(_labelNoController, 'กรอกรายละเอียด'),
        spacerTitle(),
        spacerTitle(),
        saveButton(),
        spacer(context),
        spacer(context),
        spacer(context),
        title('รายการบริเวณ*'),
        spacer(context),
      ],
    );
  }

  Widget formTab2_1() {
    return Column(
      children: [
        title('ป้ายหมายเลข*'),
        spacer(context),
        modalBottomSheet(
            _evidentFoundController,
            'กรุณาเลือกป้ายหมายเลข',
            'เลือกป้ายหมายเลข',
            evidentLocations,
            evidentTypeIndexSelected, (context, index) {
          setState(() {
            _evidentFoundController.text =
                '${evidentLocations[index].isoLabelNo}';
            evidentLocationID = int.parse(evidentLocations[index].id ?? '');
            labelNo = evidentLocations[index].isoLabelNo;
            evidentLocationDetail =
                '${evidentLabel(evidentLocations[index].evidentTypeId)} ${evidentLocations[index].evidentAmount} ${evidentLocations[index].evidenceUnit}';
            area = evidentLocations[index].isoEvidentPosition;
            evidentLocationText = evidentLocations[index].evidentDetails;
          });
          Navigator.of(context).pop();
        }),
        spacerTitle(),
        title('รายละเอียด'),
        spacer(context),
        detailView('$evidentLocationDetail'),
        spacerTitle(),
        title('บริเวณ'),
        spacer(context),
        detailView('$area'),
        spacerTitle(),
        title('ลักษณะ'),
        spacer(context),
        detailView('$evidentLocationText'),
        spacerTitle(),
        spacerTitle(),
        saveButton(),
        spacer(context),
        spacer(context),
        spacer(context),
        title('รายการบริเวณ*'),
        spacer(context),
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

  Widget headerTabTwoView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          'บริเวณของวัตถุพยานที่ตรวจเก็บ',
          textAlign: TextAlign.center,
          style: GoogleFonts.prompt(
            textStyle: TextStyle(
              color: Colors.white,
              letterSpacing: .5,
              fontSize: MediaQuery.of(context).size.height * 0.025,
            ),
          ),
        ),
        // TextButton(
        //     onPressed: () async {
        //       var result = await Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //               builder: (context) => AddAreaEvidentKept(
        //                   caseID: widget.caseID ?? -1,
        //                   caseNo: widget.caseNo,
        //                   caseEvidentForm: caseEvidentForm,
        //                   isEdit: false)));

        //       if (result != null) {
        //         setState(() {
        //           caseEvidentForm = result;
        //         });
        //       }
        //     },
        //     child: Row(
        //       children: [
        //         Icon(Icons.add, color: Colors.white),
        //         Text(
        //           'เพิ่ม',
        //           textAlign: TextAlign.center,
        //           style: GoogleFonts.prompt(
        //             textStyle: TextStyle(
        //               color: Colors.white,
        //               letterSpacing: .5,
        //               fontSize: MediaQuery.of(context).size.height * 0.025,
        //             ),
        //           ),
        //         ),
        //       ],
        //     ))
      ],
    );
  }

  Widget _listItem2(int index) {
    return Slidable(
      endActionPane: ActionPane(
        extentRatio: 0.3,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            flex: 1,
            onPressed: (BuildContext context) {
              confirmRemoveCaseEvidentLocation(context, index);
            },
            backgroundColor: Colors.red,
            icon: Icons.delete,
            label: 'ลบ',
          ),
        ],
      ),
      child: TextButton(
          style: TextButton.styleFrom(
              padding: EdgeInsets.zero, alignment: Alignment.centerLeft),
          child: Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        caseFids?.caseCategoryID == 1
                            ? Text(
                                'บริเวณ ${caseEviForm.caseEvidentLocation?[index].area}',
                                textAlign: TextAlign.start,
                                style: GoogleFonts.prompt(
                                  textStyle: TextStyle(
                                    color: textColor,
                                    letterSpacing: .5,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.022,
                                  ),
                                ),
                              )
                            : Container(),
                        caseFids?.caseCategoryID == 1
                            ? Text(
                                'ป้ายหมายเลข ${caseEviForm.caseEvidentLocation?[index].labelNo}',
                                textAlign: TextAlign.start,
                                style: GoogleFonts.prompt(
                                  textStyle: TextStyle(
                                    color: textColor,
                                    letterSpacing: .5,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.022,
                                  ),
                                ),
                              )
                            : Text(
                                'ป้ายหมายเลข ${caseEviForm.caseEvidentLocation?[index].labelNo}',
                                textAlign: TextAlign.start,
                                style: GoogleFonts.prompt(
                                  textStyle: TextStyle(
                                    color: textColor,
                                    letterSpacing: .5,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.022,
                                  ),
                                ),
                              ),
                        Text(
                          '${caseEviForm.caseEvidentLocation?[index].evidentLocationDetail?.trim()}',
                          textAlign: TextAlign.start,
                          style: GoogleFonts.prompt(
                            textStyle: TextStyle(
                              color: textColor,
                              letterSpacing: .5,
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.025,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          onPressed: () async {
            // var result = await Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => AddBodyReferencePosition(
            //             caseBodyId: widget.caseBodyId,
            //             caseBodyReferencePoints: caseBodyReferencePoints[index],
            //             caseID: widget.caseID ?? -1,
            //             caseNo: widget.caseNo,
            //             isEdit: true)));
            // if (result != null) {
            //   print('index: $index');
            //   caseBodyRefPoint = result;
            //   print(caseBodyRefPoint.toString());
            // }
          }),
    );
  }

  void confirmRemoveCaseEvidentDeliver(BuildContext context, int index) {
    BlurryDialog alert = BlurryDialog('แจ้งเตือน', 'ยืนยันการลบ', () async {
      _displaySnackbarCaseEvidentDeliver(index);
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void confirmRemoveCaseEvidentLocation(BuildContext context, int index) {
    BlurryDialog alert = BlurryDialog('แจ้งเตือน', 'ยืนยันการลบ', () async {
      _displaySnackbarCaseEvidentLocation(index);
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _displaySnackbarCaseEvidentDeliver(int index) async {
    if (kDebugMode) {
      print(index);
      print(caseEviForm.caseEvidentDeliver?[index].id);
    }

    await CaseEvidentDeliverDao()
        .delete(caseEviForm.caseEvidentDeliver?[index].id ?? -1)
        .then((value) {
      caseEviForm.caseEvidentDeliver?.removeAt(index);

      asyncCall1();

      final snackBar = SnackBar(
        content: Text(
          'ลบสำเร็จ',
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
    });
  }

  void _displaySnackbarCaseEvidentLocation(int index) async {
    await CaseEvidentLocationDao()
        .delete(caseEviForm.caseEvidentLocation?[index].id ?? -1)
        .then((value) {
      caseEviForm.caseEvidentLocation?.removeAt(index);
      asyncCall1();
      final snackBar = SnackBar(
        content: Text(
          'ลบสำเร็จ',
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
    });
  }

  Widget _listItem(int index) {
    return Slidable(
      endActionPane: ActionPane(
        extentRatio: 0.3,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            flex: 1,
            onPressed: (BuildContext context) {
              confirmRemoveCaseEvidentLocation(context, index);
            },
            backgroundColor: Colors.red,
            icon: Icons.delete,
            label: 'ลบ',
          ),
        ],
      ),
      child: TextButton(
          style: TextButton.styleFrom(
              padding: EdgeInsets.zero, alignment: Alignment.centerLeft),
          child: Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 10),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${workGroupListLabel("${caseEviForm.caseEvidentDeliver?[index].workGroupId}")}',
                        textAlign: TextAlign.start,
                        style: GoogleFonts.prompt(
                          textStyle: TextStyle(
                            color: textColor,
                            letterSpacing: .5,
                            fontSize:
                                MediaQuery.of(context).size.height * 0.025,
                          ),
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                    //   child: Text(
                    //     'ประเภทการจัดเก็บ',
                    //     textAlign: TextAlign.start,
                    //     maxLines: 4,
                    //     style: GoogleFonts.prompt(
                    //       textStyle: TextStyle(
                    //         color: textColor,
                    //         letterSpacing: .5,
                    //         fontSize:
                    //             MediaQuery.of(context).size.height * 0.015,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // Padding(
                    //     padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                    //     child: Row(
                    //       children: [
                    //         Icon(Icons.shopping_bag, color: textColor),
                    //         SizedBox(width: 10),
                    //         Text(
                    //           '${evidentCheckLabel("${caseEvidentForm.caseEvidentDeliver[index].evidenceCheckId}")}',
                    //           textAlign: TextAlign.start,
                    //           maxLines: 4,
                    //           style: GoogleFonts.prompt(
                    //             textStyle: TextStyle(
                    //               color: textColor,
                    //               letterSpacing: .5,
                    //               fontSize: MediaQuery.of(context).size.height *
                    //                   0.015,
                    //             ),
                    //           ),
                    //         ),
                    //       ],
                    //     )),
                  ],
                ),
              ],
            ),
          ),
          onPressed: () async {}),
    );
  }

  Widget tabOne() {
    if (kDebugMode) {
      print(' tersss : ${caseFids?.caseCategoryID}');
    }
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
          child: ListView(shrinkWrap: true, children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: headerView(),
            ),
            subtitle('Evidence No.'),
            spacer(context),
            detailView('${_cleanText(caseEviForm.evidentNo)}'),
            spacer(context),
            subtitle('ประเภทวัตถุพยาน'),
            spacer(context),
            detailView('${evidentTypeLabel(caseEviForm.evidenceTypeID)}'),
            spacer(context),
            subtitle('รายการวัตถุพยาน'),
            spacer(context),
            detailView('${_cleanText(caseEviForm.evidentDetail)}'),
            spacer(context),
            subtitle('จำนวน'),
            spacer(context),
            detailView(
                '${_cleanText(caseEviForm.evidentAmount)} ${_cleanText(caseEviForm.evidentUnit)}'),
            subtitle('รายชื่อที่จัดเก็บ'),
            spacer(context),
            detailView('${_cleanText(personaltLabel(caseEviForm.personalID))}'),
            spacer(context),
            subtitle('การบรรจุหีบห่อ'),
            spacer(context),
            caseEviForm.packageID == '3'
                ? detailView('อื่นๆ : ${caseEviForm.packageOther}')
                : detailView('${packageLabel(caseEviForm.packageID)}'),
            spacer(context),
            subtitle('การดำเนินการเกี่ยวกับวัตถุพยาน'),
            spacer(context),
            detailView('${_radioShow(caseEviForm.isEvidentOperate)}'),
            spacer(context),
          ]),
        ),
      ),
    );
  }

  Widget headerView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          'รายละเอียดวัตถุพยานที่ตรวจเก็บ',
          textAlign: TextAlign.center,
          style: GoogleFonts.prompt(
            textStyle: TextStyle(
              color: Colors.white,
              letterSpacing: .5,
              fontSize: MediaQuery.of(context).size.height * 0.025,
            ),
          ),
        ),
        ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Colors.transparent,
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ))),
            onPressed: () async {
              // Navigator.pushNamed(context, '/editdetail');

              var result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddEvidentKept(
                          caseEvidentForm: caseEviForm,
                          caseID: widget.caseID ?? -1,
                          caseNo: widget.caseNo,
                          count: widget.count ?? 0,
                          isEdit: widget.isEdit)));
              if (result != null) {
                setState(() {
                  caseEviForm = result;
                });
              }
            },
            child: Row(
              children: [
                Icon(
                  Icons.edit,
                  color: Colors.white,
                  size: MediaQuery.of(context).size.height * 0.025,
                ),
                Text(
                  'แก้ไข',
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
            ))
      ],
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
        child: Text(
          '$text',
          maxLines: null,
          textAlign: TextAlign.left,
          style: GoogleFonts.prompt(
            textStyle: TextStyle(
              color: textColor,
              letterSpacing: .5,
              fontSize: MediaQuery.of(context).size.height * 0.018,
            ),
          ),
        ),
      ),
    );
  }

  Widget subtitle(String? text) {
    return Text(
      '$text',
      textAlign: TextAlign.left,
      style: GoogleFonts.prompt(
        textStyle: TextStyle(
          color: Colors.white,
          letterSpacing: .5,
          fontSize: MediaQuery.of(context).size.height * 0.022,
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
      height: MediaQuery.of(context).size.height * 0.01,
    );
  }

  String? _cleanText(String? text) {
    try {
      if (text == null || text == '' || text == 'null' || text == '-1'|| text == '-1') {
        return '';
      }
      return text;
    } catch (ex) {
      return '';
    }
  }

  String? evidentGroupLabel(String? id) {
    for (int i = 0; i < evidentGroupLabels.length; i++) {
      if ('$id' == '${evidentGroupLabels[i].id}') {
        return evidentGroupLabels[i].name;
      }
    }
    return '';
  }

  String? evidentTypeLabel(String? id) {
    for (int i = 0; i < evidentTypeLabels.length; i++) {
      if ('$id' == '${evidentTypeLabels[i].id}') {
        return evidentTypeLabels[i].name;
      }
    }
    return '';
  }

  String? evidentCheckLabel(String? id) {
    for (int i = 0; i < evidentCheckLabels.length; i++) {
      if ('$id' == '${evidentCheckLabels[i].id}') {
        return evidentCheckLabels[i].name;
      }
    }
    return '';
  }

  String? unitLabel(String? id) {
    for (int i = 0; i < unitLabels.length; i++) {
      if ('$id' == '${unitLabels[i].id}') {
        return unitLabels[i].name;
      }
    }
    return '';
  }

  String? packageLabel(String? id) {
    for (int i = 0; i < packageLabels.length; i++) {
      if ('$id' == '${packageLabels[i].id}') {
        return packageLabels[i].name;
      }
    }
    return '';
  }

  String? _radioShow(String? status) {
    if (status == '1') {
      return 'ส่งมอบพนักงานสอบสวน';
    } else if (status == '2') {
      return 'อื่นๆ \n - ${workGroupListLabel(caseEviForm.workGroupID)} \n - ${departmentListLabel(caseEviForm.departmentID)}';
    }
    return '';
  }

  String? workGroupListLabel(String? id) {
    for (int i = 0; i < workGroupLabel.length; i++) {
      if ('$id' == '${workGroupLabel[i].id}') {
        return workGroupLabel[i].name;
      }
    }
    return '';
  }

  String? departmentListLabel(String? id) {
    for (int i = 0; i < departmentLabel.length; i++) {
      if ('$id' == '${departmentLabel[i].id}') {
        return departmentLabel[i].name;
      }
    }
    return '';
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
              fontSize: MediaQuery.of(context).size.height * 0.018,
            ),
          ),
        ),
      ],
    );
  }

  Widget modalBottomSheetThree(TextEditingController controller, String? hint,
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
                  height: MediaQuery.of(context).copyWith().size.height / 2.5,
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
                              '${items[index]}',
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

  Widget modalBottomSheet(
      TextEditingController controller,
      String? hint,
      String? title,
      List<CaseEvidentFound> items,
      int indexSelected,
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
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.018,
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
                                    MediaQuery.of(context).size.height * 0.018,
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
                              '${items[index].isoLabelNo}',
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

  spacerTitle() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.0001,
    );
  }

  String? evidentLabel(String? id) {
    for (int i = 0; i < evidentTypes!.length; i++) {
      if ('$id' == '${evidentTypes?[i].id}') {
        return evidentTypes?[i].name?.trim();
      }
    }
    return '';
  }

  String? personaltLabel(String? id) {
    for (int i = 0; i < caseRelatedPerson!.length; i++) {
      if ('$id' == '${caseRelatedPerson?[i].id}') {
        return caseRelatedPersonLabel?[i];
      }
    }
    return '';
  }

  Widget saveButton() {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
      child: AppButton(
          color: pinkButton,
          textColor: Colors.white,
          text: 'บันทึกวัตถุพยานที่ตรวจเก็บ',
          onPressed: () async {
            var caseEvidentLocation = CaseEvidentLocation();
            if (caseFids?.caseCategoryID == 1) {
              if (_areaController.text != '' && _areaController.text != '') {
                caseEvidentLocation.fidsId = widget.caseID;
                caseEvidentLocation.area = _areaController.text;
                caseEvidentLocation.evidentLocationDetail =
                    _evidenceLocationDetailController.text;
                caseEvidentLocation.labelNo = _labelNoController.text;
                setState(() {
                  if (caseEviForm.caseEvidentLocation != null) {
                    caseEviForm.caseEvidentLocation?.add(caseEvidentLocation);
                  } else {
                    caseEviForm.caseEvidentLocation = [];
                    caseEviForm.caseEvidentLocation?.add(caseEvidentLocation);
                  }
                  _areaController.text = '';
                  _evidenceLocationDetailController.text = '';
                  _labelNoController.text = '';
                });
              } else {
                _snackUp();
              }
            } else {
              if (labelNo != null) {
                caseEvidentLocation.fidsId = widget.caseID;
                caseEvidentLocation.labelNo = labelNo;
                caseEvidentLocation.area = area;

                caseEvidentLocation.evidentLocationDetail =
                    '${evidentLocationText?.trim()} ${evidentLocationDetail?.trim()}';
                setState(() {
                  if (caseEviForm.caseEvidentLocation != null) {
                    caseEviForm.caseEvidentLocation?.add(caseEvidentLocation);
                  } else {
                    caseEviForm.caseEvidentLocation = [];
                    caseEviForm.caseEvidentLocation?.add(caseEvidentLocation);
                  }
                });
              } else {
                _snackUp();
              }
            }
          }),
    );
  }

  _snackUp() {
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

  Widget saveButtonThree() {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
      child: AppButton(
          color: pinkButton,
          textColor: Colors.white,
          text: 'บันทึกวัตถุพยานที่ตรวจเก็บ',
          onPressed: () async {
            //   CaseEvidentLocation caseEvidentLocation = CaseEvidentLocation();
            //   caseEvidentLocation.fidsId = widget.caseID;
            //  // caseEvidentLocation.evidentId = widget.caseEvidentForm.id == '' ? '' : int.parse(widget.caseEvidentForm.id);
            //   caseEvidentLocation.labelNo = labelNo;
            //   caseEvidentLocation.evidentLocationDetail = evidentLocationDetail;

            if (deliverWorkGroupId != null) {
              CaseEvidentDeliver caseEvidentDeliver = CaseEvidentDeliver();
              caseEvidentDeliver.fidsId = widget.caseID;
              caseEvidentDeliver.workGroupId = deliverWorkGroupId;

              caseEviForm.caseEvidentDeliver?.add(caseEvidentDeliver);

              setState(() {
                caseEviForm = caseEviForm;
              });

              // Navigator.of(context).pop(widget.caseEvidentForm);
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
