import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/color.dart';
import '../../../models/CaseExhibit.dart';
import '../../../widget/app_bar_widget.dart';
import '../../../widget/blurry_dialog.dart';
import 'add_case_exhibit.dart';

class CaseExhibitList extends StatefulWidget {
  final int? caseID;
  final String? caseNo;
  final bool isLocal;

  const CaseExhibitList(
      {super.key, required this.caseID, this.caseNo, this.isLocal = false});

  @override
  CaseExhibitListState createState() => CaseExhibitListState();
}

class CaseExhibitListState extends State<CaseExhibitList> {
  bool isPhone = Device.get().isPhone;
  bool isLoading = true;
  List<CaseExhibit> caseExhibitList = [];

  @override
  void initState() {
    super.initState();
    asyncMethod();
  }

  asyncMethod() async {
    asyncCall1();
  }

  void asyncCall1() async {
    List<CaseExhibit> result =
        await CaseExhibitDao().getCaseExhibit(widget.caseID ?? -1);
    caseExhibitList = result;
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBarWidget(
        title: 'รายการของกลาง',
        actions: [
          TextButton(
            child: Row(
              children: [
                Icon(
                  Icons.add,
                  size: MediaQuery.of(context).size.height * 0.03,
                  color: Colors.white,
                ),
              ],
            ),
            onPressed: () async {
              var result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddCaseExhibit(
                            caseID: widget.caseID ?? -1,
                            caseNo: widget.caseNo,
                            isEdit: false,
                            caseExhibitById: -1,
                          )));

              if (result) {
                asyncCall1();
              }
            },
          ),
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
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : Container(
                  margin: isPhone
                      ? const EdgeInsets.all(32)
                      : const EdgeInsets.only(
                          left: 32, right: 32, top: 32, bottom: 32),
                  child: Column(
                    children: [
                      caseExhibitList.isNotEmpty
                          ? Expanded(
                              child: ListView.builder(
                                  itemCount: caseExhibitList.length,
                                  itemBuilder: (BuildContext ctxt, int index) {
                                    return _listExhibitList(index);
                                  }),
                            )
                          : Expanded(
                              child: Center(
                                child: Text(
                                  'ไม่มีข้อมูล',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.prompt(
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                      letterSpacing: .5,
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.02,
                                    ),
                                  ),
                                  maxLines: 1,
                                ),
                              ),
                            )
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _listExhibitList(index) {
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
      child: TextButton(
        onPressed: () async {
          var result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddCaseExhibit(
                        caseID: widget.caseID ?? -1,
                        caseNo: widget.caseNo,
                        caseExhibitById: caseExhibitList[index].id ?? -1,
                        isEdit: true,
                      )));

          if (result) {
            asyncCall1();
          }
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
            child: Text(
              '${caseExhibitList[index].exhibitName} ${caseExhibitList[index].exhibitAmount} ${caseExhibitList[index].exhibitUnit}',
              textAlign: TextAlign.left,
              style: GoogleFonts.prompt(
                textStyle: TextStyle(
                  color: textColor,
                  letterSpacing: .5,
                  fontSize: MediaQuery.of(context).size.height * 0.025,
                ),
              ),
              maxLines: 1,
            ),
          ),
        ),
      ),
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
              fontSize: MediaQuery.of(context).size.height * 0.025,
            ),
          ),
        ),
      ],
    );
  }

  void confirmRemove(BuildContext context, index) {
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
    await CaseExhibitDao()
        .deleteCaseExhibit(caseExhibitList[index].id.toString())
        .then((value) {
      asyncCall1();
      if (kDebugMode) {
        print('removing');
      }
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
}
