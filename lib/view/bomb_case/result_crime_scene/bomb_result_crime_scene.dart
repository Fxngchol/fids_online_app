import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/color.dart';
import '../../../models/CaseCategory.dart';
import '../../../models/FidsCrimeScene.dart';
import '../../../widget/app_bar_widget.dart';
import 'edit_bomb_result_crime_scene.dart';

class ResultCrimesceneBomb extends StatefulWidget {
  final int? caseID;
  final String? caseNo;
  final bool isLocal;
  const ResultCrimesceneBomb(
      {super.key, required this.caseID, this.caseNo, this.isLocal = false});

  @override
  ResultCrimesceneBombState createState() => ResultCrimesceneBombState();
}

class ResultCrimesceneBombState extends State<ResultCrimesceneBomb> {
  bool isLoading = true;
  bool isPhone = Device.get().isPhone;
  FidsCrimeScene data = FidsCrimeScene();
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
    await FidsCrimeSceneDao()
        .getFidsCrimeSceneById(widget.caseID ?? -1)
        .then((value) async {
      await CaseCategoryDAO()
          .getCaseCategoryLabelByid(value?.caseCategoryID ?? -1)
          .then((value) => caseName = value);
      setState(() {
        data = value ?? FidsCrimeScene();
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBarWidget(
          title: 'ผลการตรวจสถานที่เกิดเหตุ',
          actions: [
            TextButton(
              onPressed: () async {
                var result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            EditResultCrimesceneBomb(caseID: widget.caseID)));

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
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Container(
                        height: MediaQuery.of(context).size.height,
                        margin: isPhone
                            ? const EdgeInsets.all(32)
                            : const EdgeInsets.only(
                                left: 32, right: 32, top: 32, bottom: 32),
                        child: SingleChildScrollView(
                          child: Column(children: [
                            headerView(),
                            header('พฤติการณ์คดี'),
                            spacer(),
                            detailView(_cleanText(data.caseBehavior ?? '')),
                            spacer(),
                            header('ความเสียหาย'),
                            spacer(),
                            detailView(_cleanText(data.isoDamage ?? '')),
                            spacer(),
                            header('ตำแหน่งที่เกิดการระเบิด/หลุมระเบิด'),
                            spacer(),
                            detailView(_cleanText(data.isoBombLocation ?? '')),
                            spacer(),
                            header('ขนาด'),
                            spacer(),
                            detailView(_cleanText(data.isoBombSize ?? '')),
                          ]),
                        )))));
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

  Widget header(String? title) {
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

  spacer() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.01,
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

  String? _cleanText(String? text) {
    try {
      if (text == null || text == '' || text == 'null' || text == '-1') {
        return '';
      } else {
        return text;
      }
    } catch (ex) {
      return '';
    }
  }
}
