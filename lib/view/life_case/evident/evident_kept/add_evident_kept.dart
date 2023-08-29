import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../Utils/color.dart';
import '../../../../models/CaseEvidentFound.dart';
import '../../../../models/CaseEvidentLocation.dart';
import '../../../../models/CaseRelatedPerson.dart';
import '../../../../models/Department.dart';
import '../../../../models/EvidenceGroup.dart';
import '../../../../models/EvidentType.dart';
import '../../../../models/FidsCrimeScene.dart';
import '../../../../models/Package.dart';
import '../../../../models/Unit.dart';
import '../../../../models/WorkGroup.dart';
import '../../../../widget/app_button.dart';
import '../../../../widget/text_field_widget.dart';
import '../../../../widget/textfield_modal_bottom_sheet.dart';
import '../model/CaseEvidentForm.dart';

class AddEvidentKept extends StatefulWidget {
  final int? caseID;
  final String? caseNo;
  final int? count;
  final bool isEdit;
  final CaseEvidentForm? caseEvidentForm;

  const AddEvidentKept(
      {super.key,
      this.caseID,
      this.caseNo,
      this.isEdit = false,
      this.count,
      this.caseEvidentForm});

  @override
  AddEvidentKeptState createState() => AddEvidentKeptState();
}

class AddEvidentKeptState extends State<AddEvidentKept>
    with SingleTickerProviderStateMixin {
  bool isPhone = Device.get().isPhone;

  final TextEditingController _evidentTypeController = TextEditingController();

  final TextEditingController _evidentDetailController =
      TextEditingController();
  final TextEditingController _evidentAmountDateController =
      TextEditingController();
  final TextEditingController _evidentUnitController = TextEditingController();
  final TextEditingController _packageController = TextEditingController();
  final TextEditingController _packageOtherController = TextEditingController();

  final TextEditingController _workGroupController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();

  final TextEditingController _personal = TextEditingController();

  int personalSelected = 0;
  int unitTypesIndexSelected = 0;
  int evidentTypeIndexSelected = 0;
  int evidentGroupIndexSelected = 0;
  int evidentCheckIndexSelected = 0;
  int packageTypeIndexSelected = 0;
  int workGroupIndexSelected = 0;
  int devliverWorkGroupIndexSelected = 0;
  int departmentIndexSelected = 0;

  int evidentFoundID = -1,
      evidentLocationID = -1,
      unitId = -1,
      packageId = -1,
      workGroupId = -1,
      departmentId = -1,
      deliverWorkGroupId = -1;

  String? evidentNo = '';

  String? personalSelectId;

  List evidentTypeList = [];
  List<EvidentType> evidentTypes = [];
  int evdentTypeSelectId = -1;

  List caseEvidenteFoundList = [];
  List<EvidentType> caseEvidenteFounds = [];
  int caseEvidentSelectId = -1;

  List unitList = [];
  List<Unit> units = [];

  List evidentLocationList = [];
  List<CaseEvidentFound> evidentLocations = [];

  List evidenceGroupLabels = [];
  List<EvidenceGroup> evidenceGroups = [];
  int evidenceGroupSelectId = -1;

  // List evidenceCheckLabels = [];
  // List<EvidenceCheck> evidenceChecks;
  // int evidenceCheckSelectId;

  String? evidentLocationDetail = '';
  String? evidentLocationPosition = '';
  String? evidentLocationText = '';

  //List evidentTypeList = ['ดีเอ็นเอ', 'ลายนิ้วมือแฝง', 'อาวุธปืน'];

  List packageList = [];
  List<Package> packages = [];

  List workGroupList = [];
  List<WorkGroup> workGroups = [];

  List departmentList = [];
  List<Department> departments = [];

  List<CaseEvidentLocation> caseEvidentLocations = [];

  int _handleIsEvidentOperateValue = -1;
  bool _isEvidentOperate = true;

  var uGroup = '';
  var numbur = '';
  String? amount = '';

  CaseEvidentLocation? caseEvidentLocation;

  List<CaseRelatedPerson> caseRelatedPerson = [];
  late List<String> caseRelatedPersonLabel = [];
  FidsCrimeScene? fidsCrimeScene;

  void _handleIsEvidentOperateValueChange(int value) {
    setState(() {
      _handleIsEvidentOperateValue = value;
      switch (_handleIsEvidentOperateValue) {
        case 0:
          departmentId = -1;
          _isEvidentOperate = true;
          break;
        case 1:
          _isEvidentOperate = false;
          break;
      }
    });
  }

  bool isLoading = true;

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

    // var result2 =
    //     await CaseEvidentFoundDao().getCaseEvidentFoundLabel(widget.caseID ?? -1);
    var result3 = await UnitDao().getUnit();
    var result4 = await UnitDao().getUnitLabel();
    var result5 =
        await CaseEvidentFoundDao().getCaseEvidentFound(widget.caseID ?? -1);
    var result6 = await CaseEvidentFoundDao()
        .getCaseEvidentFoundLabel(widget.caseID ?? -1);

    var result7 = await PackageDao().getPackage();
    var result8 = await PackageDao().getPackageLabel();

    var result9 = await WorkGroupDao().getWorkGroup();
    var result10 = await WorkGroupDao().getWorkGroupLabel();

    var result11 = await DepartmentDao().getDepartment();
    var result12 = await DepartmentDao().getDepartmentLabel();

    var result13 = await EvidentypeDao().getEvidentType();
    // var result14 = await EvidentypeDao().getEvidentTypeLabel();

    var result15 = await EvidenceGroupDao().getEvidenceGroup();
    var result16 = await EvidenceGroupDao().getEvidenceGroupLabel();

    var result17 =
        await CaseRelatedPersonDao().getCaseRelatedPerson(widget.caseID ?? -1);
    var result19 = await CaseRelatedPersonDao()
        .getCaseRelatedPersonLabel(widget.caseID ?? -1);
    var result18 =
        await FidsCrimeSceneDao().getFidsCrimeSceneById(widget.caseID ?? -1);

    setState(() {
      evidentTypes = result;
      evidentTypeList = result2;

      evidentNo = '$numbur$amount';

      units = result3;
      unitList = result4;
      evidentLocations = result5;
      evidentLocationList = result6;
      packages = result7;
      packageList = result8;
      workGroups = result9;
      workGroupList = result10;
      departments = result11;
      departmentList = result12;
      evidentTypes = result13;

      evidenceGroups = result15;
      evidenceGroupLabels = result16;

      caseRelatedPerson = result17;
      fidsCrimeScene = result18;
      caseRelatedPersonLabel = result19;

      isLoading = false;
    });

    setupData();

    if (widget.isEdit) {
      await getCaseEvidentLocation();
      //setupData();
    }
  }

  setupData() {
    setState(() {
      evidentNo = widget.caseEvidentForm?.evidentNo;
      _evidentUnitController.text = widget.caseEvidentForm?.evidentUnit ?? '';

      for (int i = 0; i < evidentTypes.length; i++) {
        if ('${evidentTypes[i].id}' ==
            '${widget.caseEvidentForm?.evidenceTypeID}') {
          evdentTypeSelectId =
              int.parse(widget.caseEvidentForm?.evidenceTypeID ?? '');
          evidentTypeIndexSelected = i;
          _evidentTypeController.text = evidentTypes[i].name ?? '';
        }
      }

      _evidentDetailController.text =
          widget.caseEvidentForm?.evidentDetail ?? '';
      _evidentAmountDateController.text =
          widget.caseEvidentForm?.evidentAmount == '-1'
              ? ''
              : widget.caseEvidentForm?.evidentAmount ?? '';
      for (int i = 0; i < packages.length; i++) {
        if ('${packages[i].id}' == '${widget.caseEvidentForm?.packageID}') {
          packageId = int.parse(widget.caseEvidentForm?.packageID ?? '');
          packageTypeIndexSelected = i;
          _packageController.text = packages[i].name ?? '';
        }
      }

      _packageOtherController.text = widget.caseEvidentForm?.packageOther ?? '';

      if (widget.caseEvidentForm?.isEvidentOperate == '1') {
        _handleIsEvidentOperateValue = 0;
        _isEvidentOperate = true;
      } else if (widget.caseEvidentForm?.isEvidentOperate == '2') {
        _handleIsEvidentOperateValue = 1;
        _isEvidentOperate = false;
      }

      for (int i = 0; i < workGroups.length; i++) {
        if ('${workGroups[i].id}' == '${widget.caseEvidentForm?.workGroupID}') {
          workGroupId = int.parse(widget.caseEvidentForm?.workGroupID ?? '');
          workGroupIndexSelected = i;
          _workGroupController.text = workGroups[i].name ?? '';
        }
      }

      for (int i = 0; i < departments.length; i++) {
        if ('${departments[i].id}' ==
            '${widget.caseEvidentForm?.departmentID}') {
          departmentId = int.parse(widget.caseEvidentForm?.departmentID ?? '');
          departmentIndexSelected = i;
          _departmentController.text = departments[i].name ?? '';
        }
      }

      for (int i = 0; i < caseRelatedPerson.length; i++) {
        if ('${caseRelatedPerson[i].id}' ==
            '${widget.caseEvidentForm?.personalID}') {
          personalSelectId = widget.caseEvidentForm?.personalID;
          personalSelected = i;
          _personal.text = personaltLabel(personalSelectId ?? '') ?? '';
        }
      }
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
            Container(
              width: MediaQuery.of(context).size.width * 0.1,
            )
          ],
        ),
        body: tabOne());
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
          child: ListView(
            children: [
              title('Evidence No.'),
              spacer(),
              detailView('$evidentNo'),
              spacerTitle(),
              spacer(),
              title('ประเภทวัตถุพยาน*'),
              spacer(),
              modalBottomSheet(
                  _evidentTypeController,
                  'กรุณาเลือกประเภทวัตถุพยาน',
                  'เลือกประเภทวัตถุพยาน',
                  evidentTypeList,
                  evidentTypeIndexSelected, (context, index) {
                _evidentTypeController.text = evidentTypes[index].name ?? '';
                evdentTypeSelectId = evidentTypes[index].id ?? -1;
                Navigator.of(context).pop();
              }, const SizedBox(), false),
              spacerTitle(),
              title('รายการวัตถุพยาน*'),
              spacer(),
              textField(_evidentDetailController, 'กรอกข้อมูลวัตถุพยาน',
                  (value) {}, (_) {}),
              spacerTitle(),
              title('จำนวน*'),
              spacer(),
              amountView(),
              spacerTitle(),
              title('รายชื่อที่จัดเก็บ'),
              spacer(),
              modalBottomSheet(_personal, 'กรุณาเลือกรายชื่อ', 'เลือกรายชื่อ',
                  caseRelatedPersonLabel, personalSelected, (context, index) {
                setState(() {
                  _personal.text =
                      '${caseRelatedPerson[index].isoTitleName}${caseRelatedPerson[index].isoFirstName}  ${caseRelatedPerson[index].isoLastName}';
                  personalSelectId = caseRelatedPerson[index].id;
                });
                Navigator.of(context).pop();
              },
                  _personal.text != ''
                      ? GestureDetector(
                          child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: Icon(Icons.cancel,
                                  size:
                                      MediaQuery.of(context).size.height * 0.03,
                                  color: textColorHint),
                              color: textColorHint,
                              onPressed: () {
                                setState(() {
                                  _personal.text = '';
                                  personalSelectId = '';
                                });
                              }),
                        )
                      : Icon(Icons.arrow_drop_down_sharp,
                          size: MediaQuery.of(context).size.height * 0.05,
                          color: textColorHint),
                  true),
              spacerTitle(),
              title('การบรรจุหีบห่อ*'),
              spacer(),
              modalBottomSheet(
                  _packageController,
                  'กรุณาเลือกประเภทการบรรจุหีบห่อ',
                  'เลือกประเภทการบรรจุหีบห่อ',
                  packageList,
                  packageTypeIndexSelected, (context, index) {
                setState(() {
                  _packageController.text = packageList[index];
                  packageId = packages[index].id ?? -1;
                  _packageOtherController.text = '';
                });

                Navigator.of(context).pop();
              }, const SizedBox(), false),
              spacerTitle(),
              packageId == 3
                  ? textField(_packageOtherController,
                      'กรอกรายละเอียดการบรรจุหีบห่อ', (value) {}, (_) {})
                  : Container(),
              spacerTitle(),
              title('การดำเนินการเกี่ยวกับวัตถุพยาน'),
              spacer(),
              isEvidentOperate(),
              spacer(),
              _isEvidentOperate
                  ? Container()
                  : modalBottomSheet(
                      _workGroupController,
                      'กรุณาเลือกกลุ่มงานที่ดำเนินการ',
                      'เลือกกลุ่มงานที่ดำเนินการ',
                      workGroupList,
                      workGroupIndexSelected, (context, index) {
                      _workGroupController.text = workGroupList[index];

                      workGroupId = workGroups[index].id ?? -1;
                      Navigator.of(context).pop();
                    }, const SizedBox(), false),
              spacer(),
              _isEvidentOperate
                  ? Container()
                  : modalBottomSheet(
                      _departmentController,
                      'กรุณาเลือกหน่วยงานที่ดำเนินการ',
                      'เลือกหน่วยงานที่ดำเนินการ',
                      departmentList,
                      departmentIndexSelected, (context, index) {
                      departmentId = departments[index].id ?? -1;
                      _departmentController.text = departmentList[index];
                      Navigator.of(context).pop();
                    }, const SizedBox(), false),
              spacerTitle(),
              spacerTitle(),
              saveButton()
            ],
          ),
        ),
      ),
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

  // textfieldWithBtnTitle() {
  //   return Expanded(
  //     child: TextButton(
  //       onPressed: () async {
  //         var result = await Navigator.push(context,
  //             MaterialPageRoute(builder: (context) => SelectUnitListPage()));
  //         if (result != null) {
  //           print('object');
  //           setState(() {
  //             Unit unitSelected = result;
  //             _evidentUnitController.text = unitSelected.name;
  //             unitId = unitSelected.id;
  //           });
  //         }
  //       },
  //       style: OutlinedButton.styleFrom(
  //         padding: EdgeInsets.zero,
  //       ),
  //       child: Container(
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(10),
  //           color: whiteOpacity,
  //         ),
  //         child: TextFormField(
  //           controller: _evidentUnitController,
  //           enabled: false,
  //           style: GoogleFonts.prompt(
  //               textStyle: TextStyle(
  //             color: textColor,
  //             letterSpacing: 0.5,
  //             fontSize: MediaQuery.of(context).size.height * 0.02,
  //           )),
  //           decoration: InputDecoration(
  //             suffixIcon: Icon(Icons.arrow_drop_down_sharp,
  //                 size: MediaQuery.of(context).size.height * 0.05,
  //                 color: textColorHint),
  //             contentPadding: const EdgeInsets.only(
  //                 left: 20, right: 20, top: 16, bottom: 16),
  //             focusedBorder: OutlineInputBorder(
  //               borderRadius: BorderRadius.circular(10),
  //             ),
  //             hintText: 'กรุณาเลือกหน่วย',
  //             hintStyle: GoogleFonts.prompt(
  //               textStyle: TextStyle(
  //                 color: textColorHint,
  //                 letterSpacing: 0.5,
  //                 fontSize: MediaQuery.of(context).size.height * 0.02,
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  amountView() {
    final node = FocusScope.of(context);
    return Row(
      children: [
        Expanded(
          child: textField(_evidentAmountDateController, 'กรอกจำนวน',
              (value) {}, (_) => node.unfocus()),
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

  detailView(String? text) {
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

  textField(
    TextEditingController controller,
    String? hint,
    Function onChanged,
    Function onFieldSubmitted,
  ) {
    return InputField(
      controller: controller,
      hint: '$hint',
      onChanged: (str) {
        onChanged(str);
      },
      onFieldSubmitted: onFieldSubmitted,
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
              fontSize: MediaQuery.of(context).size.height * 0.03,
            ),
          ),
        ),
      ],
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

  Widget modalBottomSheet(
      TextEditingController controller,
      String? hint,
      String? title,
      List items,
      int indexSelected,
      Function onPressed,
      Widget sufflixIcon,
      bool isCanClear) {
    return TextFieldModalBottomSheet(
      suffixIcon: sufflixIcon,
      controller: controller,
      hint: '$hint',
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

  Widget modalEvidentFoundBottomSheet(
      TextEditingController controller,
      String? hint,
      String? title,
      List items,
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
                value: 0,
                activeColor: pinkButton,
                groupValue: _handleIsEvidentOperateValue,
                onChanged: (v) {
                  _handleIsEvidentOperateValueChange(v ?? -1);
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
                value: 1,
                activeColor: pinkButton,
                groupValue: _handleIsEvidentOperateValue,
                onChanged: (v) {
                  _handleIsEvidentOperateValueChange(v ?? -1);
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

  bool validate() {
    return evdentTypeSelectId != -1 &&
        // evidenceCheckSelectId != null &&
        _evidentDetailController.text != '' &&
        _evidentAmountDateController.text != '' &&
        _evidentUnitController.text != '' &&
        packageId != -1;
  }

  Widget saveButton() {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
      child: AppButton(
          color: pinkButton,
          textColor: Colors.white,
          text: 'บันทึกวัตถุพยานที่ตรวจเก็บ',
          onPressed: () async {
            if (validate()) {
              bool numValidate = true;
              try {
                if (_evidentAmountDateController.text != '') {
                  int.parse(_evidentAmountDateController.text);
                }
              } catch (ex) {
                numValidate = false;
              }
              if (numValidate) {
                var variable1 = 2;
                if (_isEvidentOperate) {
                  variable1 = 1;
                }

                widget.caseEvidentForm?.fidsId = '${widget.caseID}';
                widget.caseEvidentForm?.evidentNo = evidentNo;
                widget.caseEvidentForm?.evidenceTypeID = '$evdentTypeSelectId';
                widget.caseEvidentForm?.evidentDetail =
                    _evidentDetailController.text;
                widget.caseEvidentForm?.evidentAmount =
                    _evidentAmountDateController.text;
                widget.caseEvidentForm?.evidentUnit =
                    _evidentUnitController.text;
                widget.caseEvidentForm?.packageID = '$packageId';
                widget.caseEvidentForm?.packageOther =
                    _packageOtherController.text;
                widget.caseEvidentForm?.isEvidentOperate = '$variable1';
                widget.caseEvidentForm?.departmentID = '$departmentId';
                widget.caseEvidentForm?.workGroupID = '$workGroupId';
                widget.caseEvidentForm?.personalID = '$personalSelectId';

                if (kDebugMode) {
                  print(
                      'result.evidentNo : ${widget.caseEvidentForm?.evidentNo}');
                  print(
                      'result.evidenceTypeID : ${widget.caseEvidentForm?.evidenceTypeID}');
                  print(
                      'result.evidenceCheckID : ${widget.caseEvidentForm?.evidenceCheckID}');
                  print(
                      'result.evidentAmount : ${widget.caseEvidentForm?.evidentAmount}');
                  print(
                      'result.evidentUnitID : ${widget.caseEvidentForm?.evidentUnit}');
                  print('result.packageID : $packageId');
                  print('result.isEvidentOperate : $_isEvidentOperate');
                  print('result.departmentID : $departmentId');
                  print('result.workGroupID : $workGroupId');
                }

                Navigator.of(context).pop(widget.caseEvidentForm);
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

  String? evidentLabel(String? id) {
    for (int i = 0; i < evidentTypes.length; i++) {
      if ('$id' == '${evidentTypes[i].id}') {
        return evidentTypes[i].name;
      }
    }
    return '';
  }

  String? unitLabel(String? id) {
    for (int i = 0; i < units.length; i++) {
      if ('$id' == '${units[i].id}') {
        return units[i].name;
      }
    }
    return '';
  }

  String? packageLabel(String? id) {
    for (int i = 0; i < packages.length; i++) {
      if ('$id' == '${packages[i].id}') {
        return packages[i].name;
      }
    }
    return '';
  }

  String? workgroupLabel(String? id) {
    for (int i = 0; i < workGroups.length; i++) {
      if ('$id' == '${workGroups[i].id}') {
        return workGroups[i].name;
      }
    }
    return '';
  }

  String? departmentLabel(String? id) {
    for (int i = 0; i < departments.length; i++) {
      if ('$id' == '${departments[i].id}') {
        return departments[i].name;
      }
    }
    return '';
  }

  CaseEvidentFound getCaseEvidentFound(String? id) {
    for (int i = 0; i < evidentLocations.length; i++) {
      if ('$id' == '${evidentLocations[i].id}') {
        return evidentLocations[i];
      }
    }
    return CaseEvidentFound();
  }

  getCaseEvidentLocation() async {
    // var list = await CaseEvidentLocationDao()
    //     .getCaseEvidentLocationByEvidentId(widget.caseEvident.id);
    // caseEvidentLocation = list[0];
  }
}
