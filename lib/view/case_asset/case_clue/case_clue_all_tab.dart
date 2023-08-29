import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/color.dart';
import '../../../models/Building.dart';
import '../../../models/CaseClue.dart';
import '../../../models/FidsCrimeScene.dart';
import '../../../widget/blurry_dialog.dart';
import 'add_case_clue.dart';
import 'case_clue_detail.dart';
import 'edit_case_clue.dart';

class CaseClueAlltab extends StatefulWidget {
  final int? caseID;
  final String? caseNo;
  final bool isLocal;

  const CaseClueAlltab(
      {super.key, this.caseID, this.caseNo, this.isLocal = false});
  @override
  CaseClueAlltabState createState() => CaseClueAlltabState();
}

class CaseClueAlltabState extends State<CaseClueAlltab>
    with SingleTickerProviderStateMixin {
  bool isLoading = true;
  bool isPhone = Device.get().isPhone;
  String? caseName;
  FidsCrimeScene? fidsCrimeScene;
  List<Building> buildingTypes = [];
  List<CaseClue> caseClues = [];
  late TabController controller;

  int isoIsClueValue = -1;
  bool isoIsLock = false;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
    asyncMethod();
  }

  asyncMethod() async {
    asyncCall1();
    asyncCall2();
  }

  void asyncCall1() async {
    await FidsCrimeSceneDao()
        .getFidsCrimeSceneById(widget.caseID ?? -1)
        .then((value) async {
      setState(() {
        fidsCrimeScene = value;
        if (fidsCrimeScene?.isoIsClue != null &&
            fidsCrimeScene?.isoIsClue != '') {
          fidsCrimeScene?.isoIsClue == '1'
              ? isoIsClueValue = 1
              : isoIsClueValue = 2;
        }
        if (fidsCrimeScene?.isoIsLock != null &&
            fidsCrimeScene?.isoIsLock != '') {
          fidsCrimeScene?.isoIsLock == '1'
              ? isoIsLock = true
              : isoIsLock = false;
        }
        isLoading = false;
      });
    });
  }

  void asyncCall2() async {
    var result = await CaseClueDao().getCaseClue(widget.caseID ?? -1);
    setState(() {
      caseClues = result;
    });
    if (kDebugMode) {
      print(caseClues);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Container(
          alignment: Alignment.center,
          child: Text(
            'ทางเข้าของคนร้าย',
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
            width: 50,
          )
        ],
        // bottom: TabBar(
        //   indicatorColor: pinkButton,
        //   indicatorWeight: 10,
        //   labelColor: Color(0xffffffff), // สีของข้อความปุ่มที่เลือก
        //   unselectedLabelColor:
        //       Color(0x55ffffff), // สีของข้อความปุ่มที่ไม่ได้เลือก
        //   tabs: <Tab>[
        //     Tab(
        //       // icon: Icon(Icons.domain, color: Colors.white),
        //       child: Text(
        //         'ร่องรอย',
        //         textAlign: TextAlign.center,
        //         style: GoogleFonts.prompt(
        //           textStyle: TextStyle(
        //             color: Colors.white,
        //             fontSize: isPhone
        //                 ? MediaQuery.of(context).size.height * 0.01
        //                 : MediaQuery.of(context).size.height * 0.022,
        //           ),
        //         ),
        //       ),
        //     ),
        //     Tab(
        //       // icon: Icon(Icons.pin_drop, color: Colors.white),
        //       child: Text(
        //         'ทางเข้าของคนร้าย',
        //         textAlign: TextAlign.center,
        //         style: GoogleFonts.prompt(
        //           textStyle: TextStyle(
        //             color: Colors.white,
        //             fontSize: isPhone
        //                 ? MediaQuery.of(context).size.height * 0.01
        //                 : MediaQuery.of(context).size.height * 0.022,
        //           ),
        //         ),
        //       ),
        //     ),
        //   ],
        //   controller: controller,
        // ),
      ),
      body: _secondTab(),

      // TabBarView(
      //   children: <Widget>[
      //     _firstTab(),
      //     _secondTab(),
      //   ],
      //   controller: controller,
      // )
    );
  }

  // ignore: unused_element
  Widget _firstTab() {
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
            child: SingleChildScrollView(
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [header('รายละเอียดร่องรอย'), firstTabEdit()],
                ),
                spacer(),
                clueDetailView(),
                spacer(),
                spacer()
              ]),
            )),
      ),
    );
  }

  clueDetailView() {
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
                  value: 2,
                  activeColor: pinkButton,
                  groupValue: isoIsClueValue,
                  onChanged: (value) {}),
            ),
            Text(
              'ไม่พบร่องรอยใดๆ บริเวณสถานที่เกิดเหตุ',
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
        spacer(),
        checkbox(
            'ผู้เสียหายไม่ได้ทำการปิดล็อคประตู/หน้าต่าง', isoIsLock, (_) {}),
        spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Transform.scale(
              scale: 1.2,
              child: Radio(
                value: 1,
                activeColor: pinkButton,
                groupValue: isoIsClueValue,
                onChanged: (value) {},
              ),
            ),
            Text(
              'พบร่องรอย',
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

  checkbox(String? text, bool isChecked, Function onChanged) {
    return Padding(
      padding: const EdgeInsets.only(left: 32),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Transform.scale(
          scale: 1.7,
          child: Checkbox(
              value: isChecked,
              checkColor: Colors.white,
              activeColor: pinkButton,
              onChanged: (str) {
                onChanged(str);
              }),
        ),
        SizedBox(width: MediaQuery.of(context).size.width * 0.02),
        Flexible(
          child: Text(
            '$text',
            textAlign: TextAlign.left,
            style: GoogleFonts.prompt(
              textStyle: TextStyle(
                color: Colors.white,
                letterSpacing: .5,
                fontSize: MediaQuery.of(context).size.height * 0.025,
              ),
            ),
          ),
        ),
      ]),
    );
  }

  firstTabEdit() {
    return TextButton(
        onPressed: () async {
          var result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditCaseClue(
                        caseID: widget.caseID ?? -1,
                      )));
          if (result != null) {
            setState(() {
              asyncCall1();
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
        ));
  }

  void confirmRemoveCaseClue(BuildContext context, int index) {
    BlurryDialog alert = BlurryDialog('แจ้งเตือน', 'ยืนยันการลบ', () async {
      CaseClueDao().deleteCaseClueById(caseClues[index].id ?? '').then((value) {
        caseClues.removeAt(index);
        asyncCall2();
        if (kDebugMode) {
          print('removing');
        }
      });
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  spacer() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.01,
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
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _secondTab() {
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
            child: Column(children: [
              spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  header('รายการทางเข้าของคนร้าย'),
                  TextButton(
                    onPressed: () async {
                      var result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddCaseClue(
                                  caseID: widget.caseID ?? -1, isEdit: false)));
                      if (result != null) {
                        setState(() {
                          asyncCall2();
                        });
                      }
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.add,
                          size: MediaQuery.of(context).size.height * 0.03,
                          color: Colors.white,
                        ),
                        Text(
                          'เพิ่ม',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.prompt(
                            textStyle: TextStyle(
                              color: Colors.white,
                              letterSpacing: .5,
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.03,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(
                child: caseClues.isEmpty
                    ? Center(
                        child: Center(
                          child: Text(
                            'ไม่มีข้อมูล',
                            textAlign: TextAlign.start,
                            style: GoogleFonts.prompt(
                              textStyle: TextStyle(
                                color: Colors.white,
                                letterSpacing: .5,
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.020,
                              ),
                            ),
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: caseClues.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Slidable(
                            endActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  flex: 1,
                                  onPressed: (BuildContext context) {
                                    confirmRemoveCaseClue(context, index);
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
                                        builder: (context) => CaseClueDetail(
                                            caseID: widget.caseID ?? -1,
                                            caseClueID: caseClues[index].id)));
                                if (result != null) {
                                  asyncCall2();
                                }
                                if (kDebugMode) {
                                  print('object');
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 24.0, top: 12, bottom: 4),
                                            child: Text(
                                              caseClues[index].isoIsClue == '1'
                                                  ? 'ป้ายหมายเลข: ${(caseClues[index].labelNo == null || caseClues[index].labelNo == '') ? '-' : caseClues[index].labelNo}\n${isoIsclueLabel(caseClues[index].isoIsClue)}'
                                                  : '${isoIsclueLabel(caseClues[index].isoIsClue)}',
                                              textAlign: TextAlign.start,
                                              style: GoogleFonts.prompt(
                                                textStyle: TextStyle(
                                                  color: textColor,
                                                  letterSpacing: .5,
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.025,
                                                ),
                                              ),
                                            ),
                                          ),
                                          // caseClues[index].isoIsClue == '3'
                                          //     ?
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 24.0,
                                            ),
                                            child: Text(
                                              'รายละเอียด : ${caseClues[index].villainEntrance}',
                                              textAlign: TextAlign.start,
                                              style: GoogleFonts.prompt(
                                                textStyle: TextStyle(
                                                  color: textColor,
                                                  letterSpacing: .5,
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.025,
                                                ),
                                              ),
                                            ),
                                          ),
                                          // : Container(),
                                          caseClues[index].isoIsClue != '1'
                                              ? Container()
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    left: 24.0,
                                                  ),
                                                  child: Text(
                                                    (caseClues[index]
                                                                    .caseClueId ==
                                                                '4'
                                                            ? caseClues[index]
                                                                .clueTypeDetail
                                                            : '${caseClueLabel(caseClues[index].caseClueId)}') ??
                                                        '',
                                                    textAlign: TextAlign.start,
                                                    style: GoogleFonts.prompt(
                                                      textStyle: TextStyle(
                                                        color: textColor,
                                                        letterSpacing: .5,
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.025,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                          caseClues[index].isoIsClue != '1'
                                              ? Container()
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    left: 24.0,
                                                    bottom: 12,
                                                  ),
                                                  child: Text(
                                                    'บริเวณ : ${areaLabel(caseClues[index])}',
                                                    maxLines: null,
                                                    textAlign: TextAlign.start,
                                                    style: GoogleFonts.prompt(
                                                      textStyle: TextStyle(
                                                        color: textColor,
                                                        letterSpacing: .5,
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.02,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
              ),
            ])),
      ),
    );
  }

  // ignore: unused_element
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

  String? buildingTypeLabel(int id) {
    if (id == 0) {
      return '';
    } else {
      for (int i = 0; i < buildingTypes.length; i++) {
        if ('$id' == '${buildingTypes[i].id}') {
          return buildingTypes[i].name;
        }
      }
    }
    return '';
  }

  String? caseClueLabel(String? id) {
    String? caseClueLabel = '';
    if (id == '1') {
      caseClueLabel = 'การงัด';
    } else if (id == '2') {
      caseClueLabel = 'การตัด';
    } else if (id == '3') {
      caseClueLabel = 'การเจาะ';
    } else if (id == '4') {
      caseClueLabel = 'ร่องรอยอื่นๆ';
    } else {
      caseClueLabel = '-';
    }
    return caseClueLabel;
  }

  String? isoIsclueLabel(String? id) {
    String? caseClueLabel = '';
    if (id == '1') {
      caseClueLabel = 'พบร่องรอย';
    } else if (id == '2') {
      caseClueLabel = 'ไม่พบร่องรอยใดๆ บริเวณสถานที่เกิดเหตุ';
    } else if (id == '3') {
      caseClueLabel = 'ผู้เสียหายไม่ได้ทำการปิดล็อคประตู/หน้าต่าง';
    } else {
      caseClueLabel = '-';
    }
    return caseClueLabel;
  }

  String? areaLabel(CaseClue caseClue) {
    String? caseClueLabel = '';
    if (caseClue.isDoor == '1') {
      caseClueLabel = '$caseClueLabel ประตู';
    }
    if (caseClue.isWindows == '1') {
      caseClueLabel = '$caseClueLabel หน้าต่าง';
    }
    if (caseClue.isCelling == '1') {
      caseClueLabel = '$caseClueLabel ฝ้าเพดาน';
    }
    if (caseClue.isRoof == '1') {
      caseClueLabel = '$caseClueLabel หลังคา';
    }
    if (caseClue.isClueOther == '1') {
      caseClueLabel = '$caseClueLabel ${caseClue.clueOtherDetail}';
    }
    return caseClueLabel;
  }
}
