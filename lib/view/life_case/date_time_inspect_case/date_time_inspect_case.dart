import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/color.dart';
import '../../../models/CaseCategory.dart';
import '../../../models/CaseInspection.dart';
import '../../../models/FidsCrimeScene.dart';
import '../../../widget/app_bar_widget.dart';
import '../../../widget/blurry_dialog.dart';
import 'add_date_time_inspect_case.dart';

// class CaseInspection {
//   int? id;
//   String?date;
//   String?time;
//   CaseInspection({this.id, this.date, this.time});
//   @override
//   String toString() {
//     print('id: $id, date: $date, time: $time');
//     return super.toString();
//   }
// }

class DateTimeInspectCase extends StatefulWidget {
  final int? caseID;
  final String? caseNo;
  final bool isLocal;

  const DateTimeInspectCase(
      {super.key, this.caseID, this.caseNo, this.isLocal = false});

  @override
  DateTimeInspectCaseState createState() => DateTimeInspectCaseState();
}

class DateTimeInspectCaseState extends State<DateTimeInspectCase> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isPhone = Device.get().isPhone;
  List<CaseInspection> caseInspectionList = [];
  CaseInspection dateTimeInspection = CaseInspection();
  String? caseName;

  @override
  void initState() {
    super.initState();
    asyncMethod();
  }

  asyncMethod() async {
    asyncCall1();
  }

  void asyncCall1() async {
    var result =
        await FidsCrimeSceneDao().getFidsCrimeSceneById(widget.caseID ?? -1);
    await CaseCategoryDAO()
        .getCaseCategoryLabelByid(result?.caseCategoryID ?? -1)
        .then((value) => caseName = value);

    var result1 =
        await CaseInspectionDao().getCaseInspection(widget.caseID ?? -1);
    setState(() {
      caseInspectionList = result1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      key: _scaffoldKey,
      appBar: AppBarWidget(
        title: 'วันเวลาที่ตรวจเหตุ',
        actions: [
          TextButton(
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: MediaQuery.of(context).size.width * 0.035,
            ),
            onPressed: () async {
              var result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddDateTimeInspectCase(
                            caseID: widget.caseID ?? -1,
                            caseNo: widget.caseNo,
                            isLocal: widget.isLocal,
                          )));

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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(flex: 1, child: headerView()),
                      Flexible(
                        flex: 4,
                        child: ListView.builder(
                            itemCount: caseInspectionList.length,
                            itemBuilder: (BuildContext ctxt, int index) {
                              return _listItem(index);
                            }),
                      ),
                    ],
                  )))),
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

  Widget _listItem(int index) {
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
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'วันที่ตรวจทำการ',
                    textAlign: TextAlign.start,
                    style: GoogleFonts.prompt(
                      textStyle: TextStyle(
                        color: textColor,
                        letterSpacing: .5,
                        fontSize: MediaQuery.of(context).size.height * 0.020,
                      ),
                    ),
                  ),
                  Text(
                    '${caseInspectionList[index].inspectDate}',
                    textAlign: TextAlign.start,
                    style: GoogleFonts.prompt(
                      textStyle: TextStyle(
                        color: textColor,
                        letterSpacing: .5,
                        fontSize: MediaQuery.of(context).size.height * 0.025,
                      ),
                    ),
                  ),
                  Text(
                    'เวลาตรวจทำการ',
                    textAlign: TextAlign.start,
                    style: GoogleFonts.prompt(
                      textStyle: TextStyle(
                        color: textColor,
                        letterSpacing: .5,
                        fontSize: MediaQuery.of(context).size.height * 0.020,
                      ),
                    ),
                  ),
                  Text(
                    '${caseInspectionList[index].inspectTime}',
                    textAlign: TextAlign.start,
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

  confirmRemove(BuildContext context, int index) {
    BlurryDialog alert = BlurryDialog('แจ้งเตือน', 'ยืนยันการลบ', () async {
      _displaySnackbar(index);
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _displaySnackbar(int index) async {
    await CaseInspectionDao()
        .deleteCaseInspection(caseInspectionList[index].id ?? '')
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
}
