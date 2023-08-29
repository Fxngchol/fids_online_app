import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/color.dart';
import '../../../models/CaseCategory.dart';
import '../../../models/FidsCrimeScene.dart';
import '../../../widget/app_bar_widget.dart';
import 'add_inspection_result.dart';

class InspectionResultCase extends StatefulWidget {
  final int? caseID;
  final String? caseNo;
  final bool isLocal;

  const InspectionResultCase(
      {super.key, required this.caseID, this.caseNo, this.isLocal = false});

  @override
  ResultCaseState createState() => ResultCaseState();
}

class ResultCaseState extends State<InspectionResultCase> {
  bool isPhone = Device.get().isPhone;
  bool isLoading = true;
  FidsCrimeScene fidsCrimeScene = FidsCrimeScene();
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
    fidsCrimeScene = result ?? FidsCrimeScene();
    await CaseCategoryDAO()
        .getCaseCategoryLabelByid(fidsCrimeScene.caseCategoryID!)
        .then((value) => caseName = value);
    setState(() {
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
        appBar: AppBarWidget(
          title: 'ผลการตรวจ',
          actions: [
            TextButton(
              onPressed: () async {
                var result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddInspectionResultCase(
                            caseID: widget.caseID ?? -1,
                            isLocal: widget.isLocal)));

                if (result) {
                  asyncCall1();
                }
              },
              child: Icon(Icons.edit,
                  color: Colors.white,
                  size: MediaQuery.of(context).size.height * 0.025),
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
                child: Container(
                    margin: isPhone
                        ? const EdgeInsets.all(32)
                        : const EdgeInsets.only(
                            left: 32, right: 32, top: 32, bottom: 32),
                    child: ListView(children: [
                      headerView(),
                      header('จุดประสงค์ในการตรวจ'),
                      detailView('${_cleanText(fidsCrimeScene.objective)}'),
                      spacer(context),
                      header('ได้ทำการตรวจของกลางที่'),
                      detailView(
                          '${_cleanText(fidsCrimeScene.exhibitLocation)}'),
                      spacer(context),
                      header('วันที่'),
                      detailView('${_cleanText(fidsCrimeScene.exhibitDate)}'),
                      spacer(context),
                      header('เวลา'),
                      detailView('${_cleanText(fidsCrimeScene.exhibitTime)}'),
                      spacer(context),
                    ])))));
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
          textAlign: TextAlign.left,
          style: GoogleFonts.prompt(
            textStyle: TextStyle(
              color: textColor,
              letterSpacing: .5,
              fontSize: MediaQuery.of(context).size.height * 0.025,
            ),
          ),
        ),
      ),
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
}
