import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../Utils/color.dart';
import '../../../../models/CaseEvidentFound.dart';
import '../../../../models/EvidentType.dart';
import '../../../../models/FidsCrimeScene.dart';
import '../../../../models/Unit.dart';
import '../../../../widget/app_bar_widget.dart';
import '../../../../widget/blurry_dialog.dart';
import 'add_evident_found.dart';
import 'evident_detail.dart';

class EvidentFound extends StatefulWidget {
  final int? caseID;
  final String? caseNo;
  final bool isLocal;

  const EvidentFound(
      {super.key, this.caseID, this.caseNo, this.isLocal = false});

  @override
  EvidentFoundState createState() => EvidentFoundState();
}

class EvidentFoundState extends State<EvidentFound> {
  bool isPhone = Device.get().isPhone;

  bool isLoading = true;

  List<CaseEvidentFound> caseEvidentFounds = [];
  List<EvidentType> evidentypes = [];
  List<Unit> units = [];

  FidsCrimeScene caseFids = FidsCrimeScene();

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
        await CaseEvidentFoundDao().getCaseEvidentFound(widget.caseID ?? -1);
    var result2 = await EvidentypeDao().getEvidentType();
    var result3 = await UnitDao().getUnit();
    var result4 =
        await FidsCrimeSceneDao().getFidsCrimeSceneById(widget.caseID ?? -1);
    setState(() {
      caseFids = result4 ?? FidsCrimeScene();
      caseEvidentFounds = result;
      evidentypes = result2;
      units = result3;
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
        title: 'วัตถุพยานที่ตรวจพบ',
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
            child: ListView.builder(
                itemCount: caseEvidentFounds.length + 1,
                itemBuilder: (BuildContext ctxt, int index) {
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          title('รายการวัตถุพยานที่ตรวจพบ'),
                          TextButton(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.add,
                                  size:
                                      MediaQuery.of(context).size.height * 0.03,
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
                                          MediaQuery.of(context).size.height *
                                              0.025,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            onPressed: () async {
                              var result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddEvidentFound(
                                          caseID: widget.caseID ?? -1,
                                          caseNo: widget.caseNo,
                                          isEdit: false,
                                          caseFids: caseFids)));
                              if (result) {
                                asyncCall1();
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  }
                  return _listEvident(index - 1);
                }),
          ),
        ),
      ),
    );
  }

  Widget _listEvident(index) {
    return Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              flex: 1,
              onPressed: (BuildContext context) {
                _displaySnackbar(index);
              },
              backgroundColor: Colors.red,
              icon: Icons.delete,
              label: 'ลบ',
            ),
          ],
        ),
        child: TextButton(
            onPressed: () async {
              //Navigator.pushNamed(context, '/evidentfounddetail');
              var result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EvidentFoundDetail(
                          id: caseEvidentFounds[index].id,
                          caseID: widget.caseID ?? -1,
                          caseNo: widget.caseNo,
                          isEdit: false,
                          caseFids: caseFids)));
              if (result) {
                setState(() {
                  asyncCall1();
                });
              }
            },
            child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(
                    left: 32, right: 24, bottom: 24, top: 16),
                margin: const EdgeInsets.only(top: 6, bottom: 6),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        'ป้ายหมายเลข ${caseEvidentFounds[index].isoLabelNo}',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.prompt(
                          textStyle: TextStyle(
                            color: textColor,
                            letterSpacing: .5,
                            fontSize:
                                MediaQuery.of(context).size.height * 0.025,
                          ),
                        ),
                        maxLines: 1,
                      ),

                      Text(
                        '${caseEvidentFounds[index].evidentDetails}',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.prompt(
                          textStyle: TextStyle(
                            color: textColor,
                            letterSpacing: .5,
                            fontSize:
                                MediaQuery.of(context).size.height * 0.022,
                          ),
                        ),
                        maxLines: null,
                      ),
                      caseEvidentFounds[index].evidentAmount != '' ||
                              caseEvidentFounds[index].evidenceUnit != ''
                          ? Text(
                              'จำนวน ${caseEvidentFounds[index].evidentAmount} ${caseEvidentFounds[index].evidenceUnit}',
                              textAlign: TextAlign.left,
                              style: GoogleFonts.prompt(
                                textStyle: TextStyle(
                                  color: textColor,
                                  letterSpacing: .5,
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.022,
                                ),
                              ),
                            )
                          : Container(),
                      // Padding(
                      //   padding: const EdgeInsets.only(left: 32, right: 32),
                      //   child: Container(
                      //     width: 2,
                      //     height: MediaQuery.of(context).size.height * 0.1,
                      //     color: Colors.grey,
                      //   ),
                      // ),
                      //     Column(
                      //       mainAxisAlignment: MainAxisAlignment.start,
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         Text(
                      //           '${caseEvidentFounds[index].evidentDetails}',
                      //           textAlign: TextAlign.left,
                      //           style: GoogleFonts.prompt(
                      //             textStyle: TextStyle(
                      //               color: textColor,
                      //               letterSpacing: .5,
                      //               fontSize:
                      //                   MediaQuery.of(context).size.height * 0.025,
                      //             ),
                      //           ),
                      //           maxLines: 1,
                      //         ),
                      //         Text(
                      //           'จำนวน ${caseEvidentFounds[index].evidentAmount} ${caseEvidentFounds[index].evidenceUnit}',
                      //           textAlign: TextAlign.left,
                      //           style: GoogleFonts.prompt(
                      //             textStyle: TextStyle(
                      //               color: textColor,
                      //               letterSpacing: .5,
                      //               fontSize:
                      //                   MediaQuery.of(context).size.height * 0.025,
                      //             ),
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ],
                      // ),
                      // Icon(
                      //   Icons.arrow_forward_ios,
                      //   color: textColor,
                      //   size: MediaQuery.of(context).size.height * 0.02,
                      // ),
                    ]))));
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

  String? evidentypeLabel(String? id) {
    for (int i = 0; i < evidentypes.length; i++) {
      if ('$id' == '${evidentypes[i].id}') {
        return evidentypes[i].name;
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

  void _displaySnackbar(int index) async {
    BlurryDialog alert = BlurryDialog('แจ้งเตือน', 'ยืนยันการลบคดี', () async {
      await CaseEvidentFoundDao()
          .deleteCaseEvidentFounde(caseEvidentFounds[index].id ?? '')
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
}
