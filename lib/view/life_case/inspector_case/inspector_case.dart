import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/color.dart';
import '../../../models/CaseCategory.dart';
import '../../../models/CaseInspector.dart';
import '../../../models/Department.dart';
import '../../../models/FidsCrimeScene.dart';
import '../../../models/Personal.dart';
import '../../../models/Position.dart';
import '../../../models/Title.dart';
import '../../../models/WorkGroup.dart';
import '../../../widget/app_bar_widget.dart';
import '../../../widget/blurry_dialog.dart';
import 'add_inspector_case.dart';

class InspectorCase extends StatefulWidget {
  final int? caseID;
  final String? caseNo;
  final bool isLocal;

  const InspectorCase(
      {super.key, this.caseID, this.caseNo, this.isLocal = false});

  @override
  InspectorCaseState createState() => InspectorCaseState();
}

class InspectorCaseState extends State<InspectorCase>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController workgroupTextController = TextEditingController();
  bool isLoading = true;

  bool isPhone = Device.get().isPhone;

  List<CaseInspector> caseInspectorList = [];
  List<MyTitle> title = [];
  List<Personal> personals = [];
  String? caseName;
  List<Department> departments = [];
  List<WorkGroup> workgroups = [];
  List<Position> positions = [];

  String? titleApp;

  @override
  void initState() {
    super.initState();
    asyncMethod();
  }

  asyncMethod() async {
    asyncCall1();
  }

  void asyncCall1() async {
    var fidsCrimeScene =
        await FidsCrimeSceneDao().getFidsCrimeSceneById(widget.caseID ?? -1);

    await CaseCategoryDAO()
        .getCaseCategoryLabelByid(fidsCrimeScene?.caseCategoryID ?? -1)
        .then((value) => caseName = value);

    switch (fidsCrimeScene?.caseCategoryID ?? -1) {
      case 6:
        titleApp = 'ผู้ตรวจเก็บวัตถุพยาน';
        break;
      case 5:
        titleApp = 'ผู้ตรวจพิสูจน์';
        break;
      default:
        titleApp = 'ผู้ตรวจสถานที่เกิดเหตุ';
    }

    var result = await CaseInspectorDao().getCaseInspector(widget.caseID ?? -1);
    var result2 = await PersonalDao().getPersonal();
    positions = await PositionDao().getPosition();

    var result4 = await TitleDao().getTitle();

    departments = await DepartmentDao().getDepartment();
    workgroups = await WorkGroupDao().getWorkGroup();

    setState(() {
      caseInspectorList = result;
      caseInspectorList.sort((a, b) => a.orderID!.compareTo(b.orderID!));
      personals = result2;
      title = result4;
      isLoading = false;
      if (kDebugMode) {
        print('caseInspectorList ${caseInspectorList.toString()}');
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
        key: _scaffoldKey,
        appBar: AppBarWidget(
          title: '$titleApp',
          actions: [
            TextButton(
              child: const Icon(
                Icons.person_add_alt_1_rounded,
                color: Colors.white,
              ),
              onPressed: () async {
                var result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddInspectorCase(
                            caseID: widget.caseID ?? -1,
                            caseNo: widget.caseNo,
                            isLocal: widget.isLocal,
                            isEdit: false,
                            title: titleApp)));

                if (result) {
                  asyncCall1();
                }
              },
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
                    child: Column(
                      children: [
                        Flexible(flex: 1, child: headerView()),
                        Flexible(
                            flex: 4,
                            child: ListView.builder(
                                itemCount: caseInspectorList.length,
                                itemBuilder: (BuildContext ctxt, int index) {
                                  return _listItem(index);
                                })),
                      ],
                    )))));
  }

  Widget _listItem(index) {
    final caseInspector = caseInspectorList[index];
    Draggable draggable = LongPressDraggable<CaseInspector>(
      data: caseInspector,
      axis: Axis.vertical,
      maxSimultaneousDrags: 1,
      childWhenDragging: Opacity(
        opacity: 0.5,
        child: list(index),
      ),
      feedback: Material(
        elevation: 4.0,
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
          child: list(index),
        ),
      ),
      child: list(index),
    );
    return DragTarget<CaseInspector>(
      onWillAccept: (caseInspector) {
        return caseInspectorList.indexOf(caseInspector ?? CaseInspector()) !=
            index;
      },
      onAccept: (caseInspector) async {
        setState(() {
          int currentIndex = caseInspectorList.indexOf(caseInspector);
          caseInspectorList.remove(caseInspector);
          caseInspectorList.insert(
              currentIndex > index ? index : index - 1, caseInspector);
        });
        if (kDebugMode) {
          print('onAccept');
          print(caseInspectorList[0].firstname);
        }

        for (int i = 0; i < caseInspectorList.length; i++) {
          await CaseInspectorDao()
              .updateOrderID('${i + 1}', caseInspectorList[i].id.toString());
        }
      },
      builder: (context, candidateData, rejectedData) {
        return Column(
          children: <Widget>[
            AnimatedSize(
              duration: const Duration(milliseconds: 100),
              child: candidateData.isEmpty
                  ? Container()
                  : Opacity(
                      opacity: 0.0,
                      child: list(index),
                    ),
            ),
            Container(
              child: candidateData.isEmpty ? draggable : list(index),
            )
          ],
        );
      },
    );
  }

  Widget list(index) {
    return Slidable(
      endActionPane: ActionPane(
        extentRatio: 0.3,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            flex: 1,
            onPressed: (BuildContext context) {
              confirmRemove(context, index);
            },
            backgroundColor: Colors.red,
            icon: Icons.delete,
            label: 'ลบ',
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () async {
          var result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddInspectorCase(
                        caseID: widget.caseID ?? -1,
                        caseNo: widget.caseNo,
                        isLocal: widget.isLocal,
                        title: titleApp,
                        caseInspector: caseInspectorList[index],
                        isEdit: true,
                      )));

          if (result) {
            asyncCall1();
          }
        },
        child: Container(
          padding: EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: isPhone ? 12 : 12,
              top: isPhone ? 12 : 12),
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Text(
                              '${titleLabel(caseInspectorList[index].titleId)}${caseInspectorList[index].firstname} ${caseInspectorList[index].lastname}',
                              textAlign: TextAlign.left,
                              style: GoogleFonts.prompt(
                                textStyle: TextStyle(
                                  color: textColor,
                                  letterSpacing: .5,
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.025,
                                ),
                              ),
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Text(
                              'ตำแหน่ง${caseInspectorList[index].positionID == '0' ? caseInspectorList[index].positionOther : positionLabel(caseInspectorList[index].positionID.toString())}',
                              textAlign: TextAlign.left,
                              style: GoogleFonts.prompt(
                                textStyle: TextStyle(
                                  color: textColor,
                                  letterSpacing: .5,
                                  fontSize:
                                      MediaQuery.of(context).size.height * 0.02,
                                ),
                              ),
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          '${departmentLabel(caseInspectorList[index].departmentID)}',
                          textAlign: TextAlign.left,
                          style: GoogleFonts.prompt(
                            textStyle: TextStyle(
                              color: textColor,
                              letterSpacing: .5,
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.02,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          '(${departmentLabel(caseInspectorList[index].subDepartmentID)})',
                          textAlign: TextAlign.left,
                          style: GoogleFonts.prompt(
                            textStyle: TextStyle(
                              color: textColor,
                              letterSpacing: .5,
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.02,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  confirmRemove(BuildContext context, int index) {
    BlurryDialog alert = BlurryDialog('แจ้งเตือน', 'ยืนยันการลบ', () {
      _displaySnackbar(index);
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget headerView() {
    return Column(
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
    );
  }

  void _displaySnackbar(int index) async {
    await CaseInspectorDao()
        .deleteCaseInspector(
            caseInspectorList[index].id.toString(), widget.caseID ?? -1)
        .then((value) {
      asyncCall1();
      if (kDebugMode) {
        print('removing');
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: const Duration(milliseconds: 300),
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
          )));
    });
  }

  String? departmentLabel(String? id) {
    for (int i = 0; i < departments.length; i++) {
      if ('$id' == '${departments[i].id}') {
        //  workgroupTextController.text =
        //      workgroupLabel(departments[i].departTypeId.toString());
        return departments[i].name;
      }
    }
    return '-';
  }

  String? workgroupLabel(String? id) {
    for (int i = 0; i < workgroups.length; i++) {
      if ('$id' == '${workgroups[i].id}') {
        return workgroups[i].name;
      }
    }
    return '';
  }

  String? positionLabel(String? id) {
    for (int i = 0; i < positions.length; i++) {
      if ('$id' == '${positions[i].id}') {
        return positions[i].name;
      }
    }
    return '';
  }

  String? titleLabel(String? id) {
    for (int i = 0; i < title.length; i++) {
      if ('$id' == '${title[i].id}') {
        return title[i].name;
      }
    }
    return '';
  }
}
