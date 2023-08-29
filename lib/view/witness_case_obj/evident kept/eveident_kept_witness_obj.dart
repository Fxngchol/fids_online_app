// ignore_for_file: use_build_context_synchronously, avoid_unnecessary_containers

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/color.dart';
import '../../../models/CaseEvident.dart';
import '../../../models/CaseEvidentDeliver.dart';
import '../../../models/CaseEvidentFound.dart';
import '../../../models/CaseEvidentLocation.dart';
import '../../../models/CaseRelatedPerson.dart';
import '../../../models/Department.dart';
import '../../../models/EvidenceCheck.dart';
import '../../../models/EvidenceGroup.dart';
import '../../../models/EvidentType.dart';
import '../../../models/FidsCrimeScene.dart';
import '../../../models/Package.dart';
import '../../../models/Unit.dart';
import '../../../models/WorkGroup.dart';
import '../../../widget/app_button.dart';
import '../../../widget/blurry_dialog.dart';
import '../../../widget/text_field_widget.dart';
import '../../../widget/textfield_modal_bottom_sheet.dart';
import '../../life_case/evident/evident_kept/add_evident_kept.dart';
import '../../life_case/evident/model/CaseEvidentForm.dart';

class EvidentKeptWitnessObjForm extends StatefulWidget {
  final int? caseID;
  final String? caseNo;
  final int count;
  final bool isEdit;
  final CaseEvidentForm caseEvidentForm;

  const EvidentKeptWitnessObjForm(
      {super.key,
      required this.caseID,
      this.caseNo,
      this.isEdit = false,
      required this.count,
      required this.caseEvidentForm});

  @override
  EvidentKeptWitnessObjFormState createState() =>
      EvidentKeptWitnessObjFormState();
}

class EvidentKeptWitnessObjFormState extends State<EvidentKeptWitnessObjForm>
    with SingleTickerProviderStateMixin {
  late TabController controller;

  bool isLoading = true;
  bool isPhone = Device.get().isPhone;

  CaseEvidentForm? caseEvidentForm =
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

  int evidentTypeIndexSelected = -1;

  int evidentLocationID = -1;
  String? labelNo;

  String? evidentLocationDetail = '';
  String? area = '';
  String? evidentLocationText = '';

  List unitList = [];
  List<Unit> units = [];

  List evidentTypeList = [];
  List<EvidentType> evidentTypes = [];
  int evdentTypeSelectId = -1;

  final TextEditingController _workDeliverGroupController =
      TextEditingController();

  List workGroupList = [];
  List<WorkGroup> workGroups = [];
  int devliverWorkGroupIndexSelected = -1;
  int evidentCheckIndexSelected = -1;

  int deliverWorkGroupId = -1;

  List evidenceCheckLabels = [];
  List<EvidenceCheck> evidenceChecks = [];
  int evidenceCheckSelectId = -1;

  FidsCrimeScene caseFids = FidsCrimeScene();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _evidenceLocationDetailController =
      TextEditingController();
  final TextEditingController _labelNoController = TextEditingController();

  List<CaseRelatedPerson> caseRelatedPerson = [];
  List<String> caseRelatedPersonLabel = [];

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
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
    var result30 =
        await CaseRelatedPersonDao().getCaseRelatedPerson(widget.caseID ?? -1);

    if (!widget.isEdit) {
      if (widget.caseNo != '' && widget.caseNo != null) {
        var mock = widget.caseNo;
        var mock2 = mock?.substring(0, 16);
        // numbur = widget.caseNo;
        numbur = mock2 ?? '';
        amount = '000';
        if (widget.count < 9) {
          amount = '00${widget.count + 1}';
        } else if (widget.count > 99) {
          amount = '${widget.count + 1}';
        } else {
          amount = '0${widget.count + 1}';
        }

        if (amount == '000') {
          amount = '001';
        }
        caseEvidentForm?.evidentNo = '$numbur$amount';
      }
    }
    // var result61 =
    //     await CaseEvidentFoundDao().getCaseEvidentFoundLabel(widget.caseID ?? -1);

    var result11 = await EvidentypeDao().getEvidentType();
    var result21 = await EvidentypeDao().getEvidentTypeLabel();

    var result31 = await UnitDao().getUnit();
    var result41 = await UnitDao().getUnitLabel();

    var result9 = await WorkGroupDao().getWorkGroup();
    var result10 = await WorkGroupDao().getWorkGroupLabel();

    var result17 = await EvidenceCheckDao().getEvidenceCheck();
    var result18 = await EvidenceCheckDao().getEvidenceCheckLabel();

    setState(() {
      evidentGroupLabels = result;
      evidentTypeLabels = result2;
      evidentCheckLabels = result3;
      unitLabels = result4;
      packageLabels = result5;
      workGroupLabel = result6;
      departmentLabel = result7;

      if (widget.isEdit) {
        caseEvidentForm = widget.caseEvidentForm;
      }

      evidentTypes = result11;
      evidentTypeList = result21;

      units = result31;
      unitList = result41;

      workGroups = result9;
      workGroupList = result10;

      evidenceChecks = result17;
      evidenceCheckLabels = result18;

      caseFids = result8 ?? FidsCrimeScene();
      caseRelatedPerson = result30;
      caseRelatedPersonLabel = result19;

      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Container(
        child: const Center(child: CircularProgressIndicator()),
      );
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
                  var caseEvidentId = await CaseEvidentDao().createCaseEvident(
                      widget.caseID ?? -1,
                      caseEvidentForm?.evidentNo ?? '',
                      caseEvidentForm?.evidenceTypeID == null ||
                              caseEvidentForm?.evidenceTypeID == 'null'
                          ? -1
                          : int.parse(caseEvidentForm?.evidenceTypeID ?? '-1'),
                      caseEvidentForm?.evidentDetail,
                      caseEvidentForm?.evidentAmount == '' ||
                              caseEvidentForm?.evidentAmount == null ||
                              caseEvidentForm?.evidentAmount == 'null'
                          ? -1
                          : int.parse(caseEvidentForm?.evidentAmount ?? '-1'),
                      caseEvidentForm?.evidentUnit,
                      caseEvidentForm?.packageID == '' ||
                              caseEvidentForm?.packageID == null ||
                              caseEvidentForm?.packageID == 'null'
                          ? -1
                          : int.parse(caseEvidentForm?.packageID ?? '-1'),
                      caseEvidentForm?.packageOther,
                      caseEvidentForm?.isEvidentOperate == ''
                          ? -1
                          : caseEvidentForm?.isEvidentOperate == '1'
                              ? 1
                              : caseEvidentForm?.isEvidentOperate == '2'
                                  ? 2
                                  : -1,
                      caseEvidentForm?.departmentID == '' ||
                              caseEvidentForm?.departmentID == null ||
                              caseEvidentForm?.departmentID == 'null'
                          ? -1
                          : int.parse(caseEvidentForm?.departmentID ?? '-1'),
                      caseEvidentForm?.workGroupID == '' ||
                              caseEvidentForm?.workGroupID == null ||
                              caseEvidentForm?.workGroupID == 'null'
                          ? -1
                          : int.parse(caseEvidentForm?.workGroupID ?? '-1'),
                      -1,
                      -1,
                      caseEvidentForm?.evidenceCheckID ?? '-1',
                      '',
                      '',
                      '',
                      '',
                      1,
                      caseEvidentForm?.personalID ?? '-1');

                  if (caseEvidentForm != null) {
                    for (int i = 0;
                        i < caseEvidentForm!.caseEvidentDeliver!.length;
                        i++) {
                      await CaseEvidentDeliverDao().createCaseEvidentDeliver(
                          widget.caseID ?? -1,
                          caseEvidentId,
                          caseEvidentForm?.caseEvidentDeliver?[i].workGroupId ??
                              -1,
                          caseEvidentForm
                                  ?.caseEvidentDeliver?[i].evidenceCheckId ??
                              '');
                    }
                  }

                  Navigator.of(context).pop(true);
                } else {
                  await CaseEvidentDao().updateCaseEvident(
                      widget.caseID ?? -1,
                      caseEvidentForm?.evidentNo,
                      caseEvidentForm?.evidenceTypeID == '' ||
                              caseEvidentForm?.evidenceTypeID == null ||
                              caseEvidentForm?.evidenceTypeID == 'null'
                          ? -1
                          : int.parse(caseEvidentForm?.evidenceTypeID ?? '-1'),
                      caseEvidentForm?.evidentDetail,
                      caseEvidentForm?.evidentAmount == '' ||
                              caseEvidentForm?.evidentAmount == null ||
                              caseEvidentForm?.evidentAmount == 'null'
                          ? -1
                          : int.parse(caseEvidentForm?.evidentAmount ?? '-1'),
                      caseEvidentForm?.evidentUnit,
                      caseEvidentForm?.packageID == '' ||
                              caseEvidentForm?.packageID == null ||
                              caseEvidentForm?.packageID == 'null'
                          ? -1
                          : int.parse(caseEvidentForm?.packageID ?? '-1'),
                      caseEvidentForm?.packageOther,
                      caseEvidentForm?.isEvidentOperate == ''
                          ? -1
                          : caseEvidentForm?.isEvidentOperate == '1'
                              ? 1
                              : caseEvidentForm?.isEvidentOperate == '2'
                                  ? 2
                                  : -1,
                      caseEvidentForm?.departmentID == '' ||
                              caseEvidentForm?.departmentID == null ||
                              caseEvidentForm?.departmentID == 'null'
                          ? -1
                          : int.parse(caseEvidentForm?.departmentID ?? '-1'),
                      caseEvidentForm?.workGroupID == '' ||
                              caseEvidentForm?.workGroupID == null ||
                              caseEvidentForm?.workGroupID == 'null'
                          ? -1
                          : int.parse(caseEvidentForm?.workGroupID ?? '-1'),
                      -1,
                      -1,
                      caseEvidentForm?.evidenceCheckID,
                      '',
                      '',
                      '',
                      '',
                      1,
                      caseEvidentForm?.id,
                      caseEvidentForm?.personalID);

                  if (caseEvidentForm != null) {
                    for (int i = 0;
                        i < caseEvidentForm!.caseEvidentDeliver!.length;
                        i++) {
                      await CaseEvidentDeliverDao().updateCaseEvidentDeliver(
                          caseEvidentForm?.caseEvidentDeliver?[i].id ?? -1,
                          widget.caseID ?? -1,
                          caseEvidentForm?.id == '' ||
                                  caseEvidentForm?.id == null
                              ? -2
                              : int.parse(caseEvidentForm?.id ?? ''),
                          caseEvidentForm?.caseEvidentDeliver?[i].workGroupId ??
                              -1,
                          caseEvidentForm
                                  ?.caseEvidentDeliver?[i].evidenceCheckId ??
                              '');
                    }
                  }

                  Navigator.of(context).pop(true);
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
                          itemCount: caseEvidentForm
                                      ?.caseEvidentDeliver?.length ==
                                  null
                              ? 0
                              : caseEvidentForm?.caseEvidentDeliver?.length ??
                                  0 + 1,
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
        // TextButton(
        //     onPressed: () async {
        //       var result = await Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //               builder: (context) => AddWorkGroup(
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
            workGroupList,
            devliverWorkGroupIndexSelected, (context, index) {
          _workDeliverGroupController.text = workGroupList[index];

          deliverWorkGroupId = workGroups[index].id ?? -1;
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
      ],
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
      print(caseEvidentForm?.caseEvidentDeliver?[index].id);
    }

    await CaseEvidentDeliverDao()
        .delete(caseEvidentForm?.caseEvidentDeliver?[index].id ?? -1);
    caseEvidentForm?.caseEvidentDeliver?.removeAt(index);

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
  }

  void _displaySnackbarCaseEvidentLocation(int index) async {
    await CaseEvidentLocationDao()
        .delete(caseEvidentForm?.caseEvidentLocation?[index].id ?? -1);
    caseEvidentForm?.caseEvidentLocation?.removeAt(index);

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
              confirmRemoveCaseEvidentDeliver(context, index);
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
                        '${workGroupListLabel("${caseEvidentForm?.caseEvidentDeliver?[index].workGroupId}")}',
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
                    //           '${evidentCheckLabel("${caseEvidentForm?.caseEvidentDeliver[index].evidenceCheckId}")}',
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
            detailView('${_cleanText(caseEvidentForm?.evidentNo)}'),
            caseFids.caseCategoryID == 8 ? spacer(context) : Container(),
            caseFids.caseCategoryID == 8 ? subtitle('รายชื่อ') : Container(),
            caseFids.caseCategoryID == 8 ? spacer(context) : Container(),
            caseFids.caseCategoryID == 8
                ? detailView('${personaltLabel(caseEvidentForm?.personalID)}')
                : Container(),
            // spacer(context),
            // subtitle('กลุ่มวัตถุพยาน'),
            // spacer(context),
            // detailView('${evidentGroupLabel(caseEvidentForm?.evidenceGroupId)}'),
            //detailView('${caseEvidentForm?.evidenceGroupId}'),
            spacer(context),
            subtitle('ประเภทวัตถุพยาน'),
            spacer(context),
            detailView('${evidentTypeLabel(caseEvidentForm?.evidenceTypeID)}'),
            // spacer(context),
            // subtitle('ประเภทการจัดเก็บ'),
            // spacer(context),
            // detailView('${evidentCheckLabel(caseEvidentForm?.evidenceCheckID)}'),
            spacer(context),
            subtitle('รายการวัตถุพยาน'),
            spacer(context),
            detailView('${_cleanText(caseEvidentForm?.evidentDetail)}'),
            spacer(context),
            subtitle('จำนวน'),
            spacer(context),
            detailView(
                '${_cleanText(caseEvidentForm?.evidentAmount)} ${_cleanText(caseEvidentForm?.evidentUnit)}'),
            spacer(context),
            subtitle('การบรรจุหีบห่อ'),
            spacer(context),
            caseEvidentForm?.packageID == '3'
                ? detailView('อื่นๆ : ${caseEvidentForm?.packageOther}')
                : detailView('${packageLabel(caseEvidentForm?.packageID)}'),
            spacer(context),
            subtitle('การดำเนินการเกี่ยวกับวัตถุพยาน'),
            spacer(context),
            detailView('${_radioShow(caseEvidentForm?.isEvidentOperate)}'),
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
        TextButton(
            onPressed: () async {
              // Navigator.pushNamed(context, '/editdetail');

              var result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddEvidentKept(
                          caseEvidentForm: caseEvidentForm ?? CaseEvidentForm(),
                          caseID: widget.caseID ?? -1,
                          caseNo: widget.caseNo,
                          count: widget.count,
                          isEdit: widget.isEdit)));
              if (result != null) {
                setState(() {
                  caseEvidentForm = result;
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

  String? personaltLabel(String? id) {
    for (int i = 0; i < caseRelatedPerson.length; i++) {
      if ('$id' == '${caseRelatedPerson[i].id}') {
        return caseRelatedPersonLabel[i];
      }
    }
    return '';
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
      if (text == null || text == '' || text == 'null' || text == '-1') {
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
      return 'อื่นๆ \n - ${workGroupListLabel(caseEvidentForm?.workGroupID)} \n - ${departmentListLabel(caseEvidentForm?.departmentID)}';
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
    return Container(
      child: Row(
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
      ),
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
                    body: Container(
                      child: CupertinoPicker(
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
                                        MediaQuery.of(context).size.height *
                                            0.02,
                                  ),
                                ),
                              ),
                            );
                          })),
                    ),
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
    for (int i = 0; i < evidentTypes.length; i++) {
      if ('$id' == '${evidentTypes[i].id}') {
        return evidentTypes[i].name?.trim();
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
            if (caseFids.caseCategoryID == 1) {
              if (_areaController.text != '') {
                caseEvidentLocation.fidsId = widget.caseID;
                caseEvidentLocation.area = _areaController.text;
                caseEvidentLocation.evidentLocationDetail =
                    _evidenceLocationDetailController.text;
                caseEvidentLocation.labelNo = _labelNoController.text;
                setState(() {
                  if (caseEvidentForm?.caseEvidentLocation?.length != null) {
                    caseEvidentForm?.caseEvidentLocation
                        ?.add(caseEvidentLocation);
                  } else {
                    caseEvidentForm?.caseEvidentLocation = [];
                    caseEvidentForm?.caseEvidentLocation
                        ?.add(caseEvidentLocation);
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
                  if (caseEvidentForm?.caseEvidentLocation?.length != null) {
                    caseEvidentForm?.caseEvidentLocation
                        ?.add(caseEvidentLocation);
                  } else {
                    caseEvidentForm?.caseEvidentLocation = [];
                    caseEvidentForm?.caseEvidentLocation
                        ?.add(caseEvidentLocation);
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
            if (deliverWorkGroupId != -1) {
              CaseEvidentDeliver caseEvidentDeliver = CaseEvidentDeliver();
              caseEvidentDeliver.fidsId = widget.caseID;
              caseEvidentDeliver.workGroupId = deliverWorkGroupId;

              caseEvidentForm?.caseEvidentDeliver?.add(caseEvidentDeliver);

              setState(() {
                caseEvidentForm = caseEvidentForm;
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
