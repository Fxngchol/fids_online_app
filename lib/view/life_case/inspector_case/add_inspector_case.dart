import 'package:fids_online_app/view/life_case/inspector_case/select_department.dart';
import 'package:fids_online_app/view/life_case/inspector_case/select_position.dart';
import 'package:fids_online_app/view/life_case/inspector_case/select_sub_department.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/color.dart';
import '../../../models/CaseInspector.dart';
import '../../../models/Department.dart';
import '../../../models/Personal.dart';
import '../../../models/Position.dart';
import '../../../models/Title.dart';
import '../../../models/WorkGroup.dart';
import '../../../widget/app_bar_widget.dart';
import '../../../widget/app_button.dart';
import '../../../widget/text_field_widget.dart';
import '../request_case/select_title.dart';

class AddInspectorCase extends StatefulWidget {
  final int? caseID;
  final String? caseNo;
  final bool isLocal;
  final String? title;

  final CaseInspector? caseInspector;
  final bool isEdit;

  const AddInspectorCase(
      {super.key,
      this.caseID,
      this.caseNo,
      this.isLocal = false,
      this.title,
      this.isEdit = false,
      this.caseInspector});

  @override
  AddInspectorCaseState createState() => AddInspectorCaseState();
}

class AddInspectorCaseState extends State<AddInspectorCase> {
  bool isLoading = true;
  bool isPhone = Device.get().isPhone;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();
  final TextEditingController _positionOtherController =
      TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _subDepartmentController =
      TextEditingController();

  CaseInspector caseInspector = CaseInspector();
  List<CaseInspector> caseInspectorList = [];

  List inspectorList = [];
  List<Personal> inspectors = [];
  Position positionSelected = Position();
  Department departmentSelected = Department();
  Department subDepartmentSelected = Department();

  List<Position> positionList = [];
  List<MyTitle> title = [];
  List<WorkGroup> workGroups = [];
  List<Department> department = [];
  List<Department> subDepartment = [];

  MyTitle selectedTitle = MyTitle();

  int titleId = -1,
      positionId = -1,
      departmentId = -1,
      subDepartmentId = -1,
      workGroupId = -1;

  @override
  void initState() {
    super.initState();
    asyncMethod();

    if (widget.isEdit) {
      _firstnameController.text = widget.caseInspector?.firstname ?? '';
      _lastnameController.text = widget.caseInspector?.lastname ?? '';
    }
  }

  asyncMethod() async {
    asyncCall1();
  }

  void asyncCall1() async {
    var result = await PersonalDao().getPersonal();
    var result2 = await PersonalDao().getPersonalLabel();
    var result3 = await PositionDao().getPosition();
    var result4 = await TitleDao().getTitle();
    var result6 = await WorkGroupDao().getWorkGroup();

    List<Department> result7 = [];
    List<Department> result8 = [];
    if (widget.isEdit) {
      if (kDebugMode) {
        print('test ${widget.caseInspector?.departmentID ?? ''} ');
      }
      if (widget.caseInspector?.departmentID != 'null') {
        result7 = await DepartmentDao().getDepartmentRootZero();
        result8 = await DepartmentDao().getDepartmentByRootId(
            int.parse(widget.caseInspector?.departmentID ?? ''));
      }
    }

    setState(() {
      inspectors = result;
      inspectorList = result2;
      positionList = result3;
      title = result4;
      workGroups = result6;
      isLoading = false;

      if (widget.isEdit) {
        department = result7;
        subDepartment = result8;
        _firstnameController.text = widget.caseInspector?.firstname ?? '';
        _lastnameController.text = widget.caseInspector?.lastname ?? '';

        for (int i = 0; i < title.length; i++) {
          if ((widget.caseInspector?.titleId ?? '') == '${title[i].id}') {
            _titleController.text = title[i].name ?? '';
            titleId = title[i].id ?? -1;
          }
        }

        for (int i = 0; i < positionList.length; i++) {
          if ('${widget.caseInspector?.positionID}' ==
              '${positionList[i].id}') {
            _positionController.text = positionList[i].name ?? '';
            positionId = positionList[i].id ?? -1;
          }
        }

        _positionOtherController.text =
            widget.caseInspector?.positionOther ?? '';

        for (int i = 0; i < positionList.length; i++) {
          if ('${widget.caseInspector?.positionID}' ==
              '${positionList[i].id}') {
            _positionController.text = positionList[i].name ?? '';
            positionId = positionList[i].id ?? -1;
          }
        }

        if (widget.caseInspector?.departmentID != 'null' &&
            '${widget.caseInspector?.departmentID}' != '') {
          for (int i = 0; i < department.length; i++) {
            if ('${widget.caseInspector?.departmentID}' ==
                '${department[i].id}') {
              _departmentController.text = department[i].name ?? '';
              departmentId = department[i].id ?? -1;
            }
          }
        }

        if (widget.caseInspector?.subDepartmentID != 'null' &&
            '${widget.caseInspector?.subDepartmentID}' != '') {
          for (int i = 0; i < subDepartment.length; i++) {
            if ('${widget.caseInspector?.subDepartmentID}' ==
                '${subDepartment[i].id}') {
              _subDepartmentController.text = subDepartment[i].name ?? '';
              subDepartmentId = subDepartment[i].id ?? -1;
            }
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Container(
        color: darkBlue,
        child: const Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBarWidget(
          title: '${widget.title}',
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
                    header('ยศ*'),
                    spacer(context),
                    selectTitle(),
                    spacer(context),
                    header('ชื่อ*'),
                    spacer(context),
                    InputField(
                        controller: _firstnameController,
                        hint: 'กรอกชื่อ',
                        onChanged: (value) {}),
                    spacer(context),
                    header('นามสกุล*'),
                    spacer(context),
                    InputField(
                        controller: _lastnameController,
                        hint: 'กรอกนามสกุล',
                        onChanged: (value) {}),
                    spacer(context),
                    header('ตำแหน่ง*'),
                    spacer(context),
                    selectPosition(),
                    spacer(context),
                    positionId == 0 ? header('ตำแหน่งอื่นๆ') : Container(),
                    positionId == 0 ? spacer(context) : Container(),
                    positionId == 0
                        ? InputField(
                            controller: _positionOtherController,
                            hint: 'กรอกตำแหน่งอื่นๆ',
                            onChanged: (value) {})
                        : Container(),
                    spacer(context),
                    header('หน่วยงาน'),
                    spacer(context),
                    selectDepartment(),
                    spacer(context),
                    header('กลุ่มงาน'),
                    spacer(context),
                    selectSubDepartment(),
                    spacer(context),
                    spacer(context),
                    saveButton(),
                    spacer(context),
                  ])),
            )));
  }

  Widget header(String? text) {
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

  Widget spacer(context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.015,
    );
  }

  selectTitle() {
    return TextButton(
      onPressed: () async {
        var result = await Navigator.push(context,
            MaterialPageRoute(builder: (context) => const SelectTitle()));
        if (result != null) {
          setState(() {
            selectedTitle = result;
            _titleController.text = selectedTitle.name ?? '';
            titleId = selectedTitle.id ?? -1;
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
          controller: _titleController,
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
            hintText: 'กรุณาเลือกยศ',
            hintStyle: GoogleFonts.prompt(
              textStyle: TextStyle(
                color: textColor,
                letterSpacing: 0.5,
                fontSize: MediaQuery.of(context).size.height * 0.02,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget selectPosition() {
    return TextButton(
      onPressed: () async {
        var result = await Navigator.push(context,
            MaterialPageRoute(builder: (context) => const SelectPosition()));
        if (result != null) {
          setState(() {
            positionSelected = result;
            _positionController.text = '${positionSelected.name}';
            positionId = positionSelected.id ?? -1;
            // print(caseInspector.personalId);
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
          controller: _positionController,
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
            hintText: 'เลือกตำแหน่ง',
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

  Widget selectDepartment() {
    return TextButton(
      onPressed: () async {
        var result = await Navigator.push(context,
            MaterialPageRoute(builder: (context) => const SelectDepartment()));
        if (result != null) {
          setState(() {
            departmentSelected = result;
            _departmentController.text = '${departmentSelected.name}';
            departmentId = departmentSelected.id ?? -1;
            _subDepartmentController.text = '';
            subDepartmentSelected = Department();
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
          controller: _departmentController,
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
            hintText: 'เลือกหน่วยงาน',
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

  bool isInteger(num value) => value is int || value == value.roundToDouble();

  Widget selectSubDepartment() {
    return TextButton(
      onPressed: () async {
        if (isInteger(departmentId)) {
          var result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SelectSubDepartment(departmentId)));
          if (result != null) {
            setState(() {
              subDepartmentSelected = result;
              _subDepartmentController.text = '${subDepartmentSelected.name}';
              subDepartmentId = subDepartmentSelected.id ?? -1;
            });
          }
        } else {
          final snackBar = SnackBar(
            content: Text(
              'กรุณาเลือกหน่วยงานก่อน',
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
          controller: _subDepartmentController,
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
            hintText: 'เลือกหน่วยงาน',
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
    return AppButton(
        color: pinkButton,
        textColor: Colors.white,
        text: 'บันทึก',
        onPressed: () async {
          if (validate()) {
            if (widget.isEdit) {
              await CaseInspectorDao().updateCaseInspector(
                  widget.caseID ?? -1,
                  titleId.toString(),
                  _firstnameController.text,
                  _lastnameController.text,
                  positionId.toString(),
                  _positionOtherController.text,
                  departmentId.toString(),
                  subDepartmentId.toString(),
                  '${widget.caseInspector?.id ?? ''}');
            } else {
              await CaseInspectorDao().createCaseInspector(
                  widget.caseID ?? -1,
                  titleId.toString(),
                  _firstnameController.text,
                  _lastnameController.text,
                  positionId.toString(),
                  _positionOtherController.text,
                  departmentId.toString(),
                  subDepartmentId.toString());
              var result = await CaseInspectorDao()
                  .getCaseInspector(widget.caseID ?? -1);
              caseInspectorList = [];
              caseInspectorList = result;
              CaseInspector lastAdd = caseInspectorList.last;
              if (kDebugMode) {
                print('lastAdd.id : ${lastAdd.id}');
              }
              await CaseInspectorDao()
                  .updateOrderID(lastAdd.id.toString(), lastAdd.id.toString())
                  .then((value) => Navigator.of(context).pop(true));
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
        });
  }

  bool validate() {
    return _titleController.text != '' &&
        _firstnameController.text != '' &&
        _lastnameController.text != '' &&
        _positionController.text != '';
    // &&
    // _departmentController.text != '' &&
    // _subDepartmentController.text != '';
  }

  Future<bool> asyncCheckExist(String? id) async {
    var result = await CaseInspectorDao().getCaseInspector(widget.caseID ?? -1);
    caseInspectorList = result;
    for (var i = 0; i < caseInspectorList.length; i++) {
      if ('${caseInspectorList[i].id}' == '$id') {
        return true;
      }
    }
    return false;
  }

  String? titleLabel(String? id) {
    for (int i = 0; i < title.length; i++) {
      if ('$id' == '${title[i].id}') {
        return title[i].name;
      }
    }
    return '';
  }

  String? workgroupLabel(String? id) {
    // for (int i = 0; i < workGroups.length; i++) {
    //   if ('$id' == '${workGroups[i].id}') {
    //     return workGroups[i].name;
    //   }
    // }
    return '';
  }
}
