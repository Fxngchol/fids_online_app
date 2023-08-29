import 'package:fids_online_app/view/life_case/relate_person/relate_person_detail.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/color.dart';
import '../../../models/CaseCategory.dart';
import '../../../models/CaseRelatedPerson.dart';
import '../../../models/FidsCrimeScene.dart';
import '../../../models/RelatedPersonType.dart';
import '../../../models/Title.dart';
import '../../../widget/app_bar_widget.dart';
import '../../../widget/blurry_dialog.dart';
import 'add_relate_person.dart';

class RelatePerson extends StatefulWidget {
  final int? caseID;
  final String? caseNo;
  final bool isLocal, isWitnessCasePerson;

  const RelatePerson(
      {super.key,
      this.caseID,
      this.caseNo,
      this.isLocal = false,
      this.isWitnessCasePerson = false});

  @override
  RelatePersonState createState() => RelatePersonState();
}

class RelatePersonState extends State<RelatePerson> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isPhone = Device.get().isPhone;
  // bool _checkFlag = true;

  bool isLoading = true;

  List<CaseRelatedPerson> data = [];
  List<MyTitle> title = [];
  List<RelatedPersonType> relatedPersonTypes = [];
  String? caseName;

  @override
  void initState() {
    super.initState();
    asyncMethod();
  }

  asyncMethod() async {
    asyncCall1();
    if (kDebugMode) {
      print('caseID: ${widget.caseID}, caseNo: ${widget.caseNo}');
    }
  }

  void asyncCall1() async {
    var fidsCrimescene =
        await FidsCrimeSceneDao().getFidsCrimeSceneById(widget.caseID ?? -1);

    var result =
        await CaseRelatedPersonDao().getCaseRelatedPerson(widget.caseID ?? -1);
    var result2 = await TitleDao().getTitle();
    var result3 = await RelatedPersonTypeDao().getRelatedPersonType();
    if (kDebugMode) {
      print('resultresultresult ${result.toString()}');
    }
    await CaseCategoryDAO()
        .getCaseCategoryLabelByid(fidsCrimescene?.caseCategoryID ?? -1)
        .then((value) => caseName = value);

    setState(() {
      data = result;
      title = result2;
      relatedPersonTypes = result3;
      isLoading = false;
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
          title: widget.isWitnessCasePerson
              ? 'รายการบุคคล'
              : 'รายการผู้เกี่ยวข้อง',
          actions: [
            TextButton(
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: MediaQuery.of(context).size.height * 0.03,
              ),
              onPressed: () async {
                var result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddRelatePerson(
                            isEdit: false,
                            caseID: widget.caseID ?? -1,
                            caseNo: widget.caseNo,
                            isWitnessCasePerson: widget.isWitnessCasePerson)));
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
                    child: ListView.builder(
                        itemCount: data.length + 1,
                        itemBuilder: (BuildContext ctxt, int index) {
                          if (index == 0) {
                            return headerView();
                          }
                          return _listItem(index - 1);
                        })))));
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
              _removeRelatePerson(index);
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
                  builder: (context) => RelatePersonDetail(
                      relatedPersonId: int.parse(data[index].id ?? ''),
                      caseID: int.parse(data[index].fidsId ?? ''),
                      caseNo: widget.caseNo,
                      isWitnessCasePerson: widget.isWitnessCasePerson)));
          if (result) {
            asyncMethod();
          }
        },
        child: Container(
          padding:
              const EdgeInsets.only(left: 20, right: 20, bottom: 12, top: 12),
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              '${data[index].isoTitleName}${data[index].isoFirstName} ${data[index].isoLastName}',
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
                        children: [
                          Text(
                            data[index].relatedPersonTypeId == '0'
                                ? data[index].relatedPersonOther ?? ''
                                : '${relatedPersonTypeLabel(data[index].relatedPersonTypeId)}',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.prompt(
                              textStyle: TextStyle(
                                color: textColor,
                                letterSpacing: .5,
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.020,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: textColor,
                )
              ],
            ),
          ),
        ),
      ),
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

  void _removeRelatePerson(int index) async {
    BlurryDialog alert = BlurryDialog('แจ้งเตือน', 'ยืนยันการลบ', () async {
      await CaseRelatedPersonDao()
          .deleteCaseRelatedPerson(data[index].id ?? '')
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

  String? relatedPersonTypeLabel(String? id) {
    if (kDebugMode) {
      print('$id');
    }

    for (int i = 0; i < relatedPersonTypes.length; i++) {
      if (kDebugMode) {
        print('${relatedPersonTypes[i].id}');
      }

      if ('$id' == '${relatedPersonTypes[i].id}') {
        return relatedPersonTypes[i].name;
      }
    }
    return '';
  }
}
