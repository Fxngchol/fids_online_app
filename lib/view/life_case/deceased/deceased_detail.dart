import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/color.dart';
import '../../../models/CaseBody.dart';
import '../../../models/CaseBodyReferencePoint.dart';
import '../../../models/CaseBodyWound.dart';
import '../../../models/CaseCategory.dart';
import '../../../models/CaseRelatedPerson.dart';
import '../../../models/FidsCrimeScene.dart';
import '../../../models/Title.dart';
import '../../../widget/app_bar_widget.dart';
import '../../../widget/blurry_dialog.dart';
import 'desceased_all_tab.dart';

class DeceasedDetail extends StatefulWidget {
  final int? caseID;
  final String? caseNo;
  final bool isLocal;

  const DeceasedDetail(
      {super.key, this.caseID, this.caseNo, this.isLocal = false});

  @override
  DeceasedDetailState createState() => DeceasedDetailState();
}

class DeceasedDetailState extends State<DeceasedDetail> {
  bool isPhone = Device.get().isPhone;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isLoading = true;

  List<CaseBody> casebodys = [];
  List<MyTitle> title = [];
  String? caseName;

  List<CaseRelatedPerson> caseRelatedPerson = [];
  List<String> caseRelatedPersonLabel = [];

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

    var result = await CaseBodyDao().getCaseBody(widget.caseID ?? -1);
    var result2 = await TitleDao().getTitle();

    var getCaseRelatedPerson =
        await CaseRelatedPersonDao().getCaseRelatedPerson(widget.caseID ?? -1);
    var getCaseRelatedPersonLabel = await CaseRelatedPersonDao()
        .getCaseRelatedPersonLabel(widget.caseID ?? -1);

    if (kDebugMode) {
      print('widget.caseID ${widget.caseID}');
      print('widget.caseNo ${widget.caseNo}');
    }

    setState(() {
      caseRelatedPerson = getCaseRelatedPerson;
      caseRelatedPersonLabel = getCaseRelatedPersonLabel;
      casebodys = result;
      title = result2;

      isLoading = false;
    });
  }

  String? personaltLabel(String? id) {
    for (int i = 0; i < caseRelatedPerson.length; i++) {
      if ('$id' == '${caseRelatedPerson[i].id}') {
        return caseRelatedPersonLabel[i];
      }
    }
    return '';
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
        title: 'ผู้เสียชีวิต',
        key: _scaffoldKey,
        actions: [
          TextButton(
            child: Icon(Icons.add_sharp,
                color: Colors.white,
                size: MediaQuery.of(context).size.height * 0.025),
            onPressed: () async {
              var result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddDeceased(
                          caseID: widget.caseID ?? -1,
                          caseNo: widget.caseNo,
                          caseBodyId: -1,
                          isEdit: false)));
              if (result) {
                setState(() async {
                  asyncCall1();
                });
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
                  child: ListView.builder(
                      itemCount: casebodys.length + 1,
                      itemBuilder: (BuildContext ctxt, int index) {
                        if (index == 0) {
                          return headerView();
                        }
                        return _listItem(index - 1);
                      })))),
    );
  }

  Widget headerView() {
    return Padding(
      padding: const EdgeInsets.only(left: 24, bottom: 24),
      child: Column(
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
      ),
    );
  }

  Widget _listItem(int index) {
    return Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              flex: 1,
              onPressed: (BuildContext context) {
                _confirmRemove(index);
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
                    builder: (context) => AddDeceased(
                        caseID: widget.caseID ?? -1,
                        caseNo: widget.caseNo,
                        caseBodyId: casebodys[index].id == ''
                            ? -2
                            : int.parse(casebodys[index].id ?? ''),
                        isEdit: true)));
            if (result) {
              asyncCall1();
            }
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 10),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ป้ายหมายเลข ${_cleanText(casebodys[index].labelNo)}',
                          textAlign: TextAlign.start,
                          style: GoogleFonts.prompt(
                            textStyle: TextStyle(
                              color: textColor,
                              letterSpacing: .5,
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.020,
                            ),
                          ),
                        ),
                        Text(
                          '${personaltLabel(casebodys[index].personalID)}',
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
                ),
              ],
            ),
          ),
        ));
  }

  void _confirmRemove(int index) async {
    BlurryDialog alert = BlurryDialog('แจ้งเตือน', 'ยืนยันการลบคดี', () async {
      await CaseBodyDao().deleteCaseBody(
        casebodys[index].id == '' ? -2 : int.parse(casebodys[index].id ?? ''),
      );

      await CaseBodyReferencePointDao()
          .deleteAllCaseBodyReferencePoint(casebodys[index].id ?? '');
      await CaseBodyWoundDao()
          .deleteAllCaseBodyWound(casebodys[index].id ?? '')
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
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  String? titleLabel(String? id) {
    for (int i = 0; i < title.length; i++) {
      if ('$id' == '${title[i].id}') {
        return title[i].name;
      }
    }
    return '';
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
}
