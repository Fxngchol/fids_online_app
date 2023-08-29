import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/color.dart';
import '../../../models/CaseAreaClue.dart';
import '../../../models/CaseAssetArea.dart';
import '../../../models/CaseRansacked.dart';
import '../../../widget/blurry_dialog.dart';
import 'add_case_ranracked.dart';
import 'add_tab1_case_asset_area.dart';
import 'edit_area.dart';

class CaseAssetAreaForm extends StatefulWidget {
  final int? caseID;
  final String? caseNo;
  final bool isEdit;
  final CaseAssetArea? caseAssetArea;
  final String? area;

  const CaseAssetAreaForm(
      {super.key,
      this.caseID,
      this.caseNo,
      this.isEdit = false,
      this.caseAssetArea,
      this.area});

  @override
  CaseAssetAreaFormState createState() => CaseAssetAreaFormState();
}

class CaseAssetAreaFormState extends State<CaseAssetAreaForm>
    with SingleTickerProviderStateMixin {
  late TabController controller;

  bool isLoading = true;
  bool isPhone = Device.get().isPhone;

  bool isLock = false;

  CaseAssetArea caseAssetArea =
      CaseAssetArea(caseAreaClues: CaseAreaClue(), caseRansackeds: []);
  List<CaseRansacked> caseRansackedsTab1 = [];

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 4, vsync: this);
    caseAssetArea = widget.caseAssetArea ?? CaseAssetArea();
    if (kDebugMode) {
      print(caseAssetArea);
    }

    asyncMethod();
  }

  asyncMethod() async {
    asyncCall1();
  }

  void asyncCall1() async {
    await CaseAssetAreaDao()
        .getCaseAssetAreaById(widget.caseAssetArea?.id ?? '')
        .then((value) {
      if (kDebugMode) {
        print(value.toString());
      }
      setState(() {
        caseAssetArea = value;
      });
    });

    setState(() {
      // if  (widget.isEdit) {
      //   caseAssetArea = widget.caseAssetArea;
      //   if (caseAssetArea.isClue == '1') {
      //     _radioValueTab1 = 1;
      //   } else if (caseAssetArea.isClue == '2') {
      //     _radioValueTab1 = 2;
      //   }

      //   if (caseAssetArea.isLock == '1') {
      //     isLock = true;
      //   }
      // }
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Container(
            alignment: Alignment.center,
            child: Text(
              'สภาพร่องรอยและตำแหน่งที่ตรวจพบ',
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
          leading: IconButton(
            icon: isIOS
                ? const Icon(Icons.arrow_back_ios)
                : const Icon(Icons.arrow_back),
            onPressed: () async {
              if (widget.isEdit == false) {
                if (kDebugMode) {
                  await CaseAssetAreaDao().createCaseAssetArea(
                      '${widget.caseID}', caseAssetArea.area);
                  print(
                      'createCaseAssetAreacreateCaseAssetAreacreateCaseAssetAreacreateCaseAssetArea');
                  print('caseAssetAreaId : ${widget.caseAssetArea?.id}');
                  print(
                      'caseAssetArea.caseAreaClues : ${caseAssetArea.caseAreaClues?.toString()}');
                }

                CaseAreaClueDao().insertCheck(
                    caseAssetArea.caseAreaClues ?? CaseAreaClue(),
                    '${widget.caseAssetArea?.id ?? -1}');
                if (caseAssetArea.caseRansackeds != null) {
                  for (int i = 0;
                      i < caseAssetArea.caseRansackeds!.length;
                      i++) {
                    await CaseRansackedDao()
                        .insertCheck(caseAssetArea.caseRansackeds![i],
                            widget.caseAssetArea?.id ?? '')
                        .then((value) => Navigator.of(context).pop(true));
                  }
                }
              } else {
                await CaseAssetAreaDao().updateCaseAssetArea(
                    '${widget.caseID}', caseAssetArea.area, caseAssetArea.id);
                if (kDebugMode) {
                  print(
                      'updateCaseAssetAreaupdateCaseAssetAreaupdateCaseAssetArea ${widget.caseAssetArea?.id}');
                }
                await CaseAreaClueDao().insertCheck(
                    caseAssetArea.caseAreaClues ?? CaseAreaClue(),
                    '${widget.caseAssetArea?.id}');
                if (caseAssetArea.caseRansackeds != null) {
                  for (int i = 0;
                      i < caseAssetArea.caseRansackeds!.length;
                      i++) {
                    await CaseRansackedDao()
                        .insertCheck(caseAssetArea.caseRansackeds![i],
                            '${widget.caseAssetArea?.id}')
                        .then((value) => Navigator.of(context).pop(true));
                  }
                }
              }
            },
          ),
          actions: [
            Container(
              width: MediaQuery.of(context).size.width * 0.1,
            )
          ],
          bottom: TabBar(
            labelStyle: GoogleFonts.prompt(
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: isPhone
                    ? MediaQuery.of(context).size.height * 0.01
                    : MediaQuery.of(context).size.height * 0.02,
              ),
            ),
            indicatorColor: pinkButton,
            indicatorWeight: 10,
            labelColor: const Color(0xffffffff), // สีของข้อความปุ่มที่เลือก
            unselectedLabelColor:
                const Color(0x55ffffff), // สีของข้อความปุ่มที่ไม่ได้เลือก
            tabs: const <Tab>[
              Tab(
                // icon: Icon(Icons.domain, color: Colors.white),
                child: Text(
                  'ทางเข้า',
                  textAlign: TextAlign.center,
                ),
              ),
              Tab(
                // icon: Icon(Icons.domain_disabled, color: Colors.white),
                child: Text(
                  'รอยงัด',
                  textAlign: TextAlign.center,
                ),
              ),
              Tab(
                // icon: Icon(Icons.pin_drop, color: Colors.white),
                child: Text(
                  'ร่องรอยรื้อค้น',
                  textAlign: TextAlign.center,
                ),
              ),
              Tab(
                // icon: Icon(Icons.pin_drop, color: Colors.white),
                child: Text(
                  'วัตถุพยาน',
                  textAlign: TextAlign.center,
                ),
              ),
            ],
            controller: controller,
          ),
        ),
        body: TabBarView(
          controller: controller,
          children: <Widget>[
            tabOne(),
            tabTwo(),
            tabThree(),
            tabFour(),
          ],
        ));
  }

  Widget tabFour() {
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    title('บริเวณ'),
                    spacer(context),
                    detailView('${caseAssetArea.area}'),
                    spacer(context),
                    headerTabFourView(),
                    Expanded(
                      child: ListView.builder(
                          itemCount: caseAssetArea.caseRansackeds
                              ?.where(
                                  (element) => element.ransackedTypeID == '3')
                              .length,
                          itemBuilder: (BuildContext ctxt, int index) {
                            return _listItemTabFour(index);
                          }),
                    ),
                  ],
                ))));
  }

  Widget tabThree() {
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    title('บริเวณ'),
                    spacer(context),
                    detailView('${caseAssetArea.area}'),
                    spacer(context),
                    headerTabThreeView(),
                    Expanded(
                      child: ListView.builder(
                          itemCount: caseAssetArea.caseRansackeds
                              ?.where(
                                  (element) => element.ransackedTypeID == '2')
                              .length,
                          itemBuilder: (BuildContext ctxt, int index) {
                            return _listItemTabThree(index);
                          }),
                    ),
                  ],
                ))));
  }

  Widget headerTabFourView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          'รายละเอียด',
          textAlign: TextAlign.center,
          style: GoogleFonts.prompt(
            textStyle: TextStyle(
              color: Colors.white,
              letterSpacing: .5,
              fontSize: MediaQuery.of(context).size.height * 0.025,
            ),
          ),
        ),
        TextButton(
            onPressed: () async {
              var result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddCaseRansacked(
                            caseAssetArea: caseAssetArea,
                            caseID: widget.caseID ?? -1,
                            caseNo: widget.caseNo,
                            isEdit: false,
                            ransackedTypeID: '3',
                          )));
              if (result != null) {
                setState(() {
                  caseAssetArea = result;
                  if (kDebugMode) {
                    print(caseAssetArea.caseRansackeds);
                  }
                });
              }
            },
            child: Row(
              children: [
                const Icon(Icons.add, color: Colors.white),
                Text(
                  'เพิ่ม',
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
            ))
      ],
    );
  }

  Widget _listItemTabFour(int index) {
    return Slidable(
      endActionPane: ActionPane(
        extentRatio: 0.3,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            flex: 1,
            onPressed: (BuildContext context) {
              confirmRemove(
                  context,
                  caseAssetArea.caseRansackeds
                      ?.where((element) => element.ransackedTypeID == '3')
                      .toList()[index]
                      .id,
                  caseAssetArea.caseRansackeds
                          ?.where((element) => element.ransackedTypeID == '3')
                          .toList()[index]
                          .preId ??
                      -1);
            },
            backgroundColor: Colors.red,
            icon: Icons.delete,
            label: 'ลบ',
          ),
        ],
      ),
      child: TextButton(
          style: TextButton.styleFrom(
              padding: EdgeInsets.zero, alignment: Alignment.centerLeft),
          child: Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 10),
                caseAssetArea.caseRansackeds
                            ?.where((element) => element.ransackedTypeID == '3')
                            .toList()[index]
                            .isClue ==
                        '2'
                    ? Text(
                        'ไม่พบวัตถุพยาน',
                        textAlign: TextAlign.start,
                        style: GoogleFonts.prompt(
                          textStyle: TextStyle(
                            color: textColor,
                            letterSpacing: .5,
                            fontSize:
                                MediaQuery.of(context).size.height * 0.025,
                          ),
                        ),
                      )
                    : Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ป้ายหมายเลข ${caseAssetArea.caseRansackeds?.where((element) => element.ransackedTypeID == '3').toList()[index].labelNo}',
                              textAlign: TextAlign.start,
                              style: GoogleFonts.prompt(
                                textStyle: TextStyle(
                                  color: textColor,
                                  letterSpacing: .5,
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.025,
                                ),
                              ),
                            ),
                            Text(
                              'ตรวจพบที่${caseAssetArea.caseRansackeds?.where((element) => element.ransackedTypeID == '3').toList()[index].areaDetail}',
                              style: GoogleFonts.prompt(
                                textStyle: TextStyle(
                                  color: textColor,
                                  letterSpacing: .5,
                                  fontSize:
                                      MediaQuery.of(context).size.height * 0.02,
                                ),
                              ),
                            ),
                            Text(
                              '${caseAssetArea.caseRansackeds?.where((element) => element.ransackedTypeID == '3').toList()[index].detail}',
                              style: GoogleFonts.prompt(
                                textStyle: TextStyle(
                                  color: textColor,
                                  letterSpacing: .5,
                                  fontSize:
                                      MediaQuery.of(context).size.height * 0.02,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ),
          onPressed: () async {
            var indexEdit = 0;
            for (var i = 0; i < caseAssetArea.caseRansackeds!.length; i++) {
              if (caseAssetArea.caseRansackeds?[i].id == null ||
                  caseAssetArea.caseRansackeds?[i].id == '' ||
                  caseAssetArea.caseRansackeds?[i].id == 'null') {
                if ('${caseAssetArea.caseRansackeds?.where((element) => element.ransackedTypeID == '3').toList()[index].detail}' ==
                    '${caseAssetArea.caseRansackeds![i].detail}') {
                  indexEdit = i;
                }
              } else {
                if (caseAssetArea.caseRansackeds
                        ?.where((element) => element.ransackedTypeID == '3')
                        .toList()[index]
                        .id ==
                    caseAssetArea.caseRansackeds?[i].id) {
                  indexEdit = i;
                }
              }
            }
            var result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddCaseRansacked(
                          caseAssetArea: caseAssetArea,
                          caseID: widget.caseID ?? -1,
                          caseNo: widget.caseNo,
                          indexEdit: indexEdit,
                          isEdit: true,
                          ransackedTypeID: '3',
                        )));
            if (result != null) {
              setState(() {
                caseAssetArea = result;
                if (kDebugMode) {
                  print(caseAssetArea.caseRansackeds);
                }
              });
            }
          }),
    );
  }

  Widget headerTabThreeView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          'รายละเอียด',
          textAlign: TextAlign.center,
          style: GoogleFonts.prompt(
            textStyle: TextStyle(
              color: Colors.white,
              letterSpacing: .5,
              fontSize: MediaQuery.of(context).size.height * 0.025,
            ),
          ),
        ),
        TextButton(
            onPressed: () async {
              var result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddCaseRansacked(
                            caseAssetArea: caseAssetArea,
                            caseID: widget.caseID ?? -1,
                            caseNo: widget.caseNo,
                            isEdit: false,
                            ransackedTypeID: '2',
                          )));
              if (result != null) {
                setState(() {
                  caseAssetArea = result;
                  if (kDebugMode) {
                    print(caseAssetArea.caseRansackeds);
                  }
                });
              }
            },
            child: Row(
              children: [
                const Icon(Icons.add, color: Colors.white),
                Text(
                  'เพิ่ม',
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
            ))
      ],
    );
  }

  void confirmRemove(BuildContext context, String? id, int preId) {
    BlurryDialog alert = BlurryDialog('แจ้งเตือน', 'ยืนยันการลบ', () async {
      _displaySnackbar(id, preId);
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _displaySnackbar(String? id, int preId) async {
    if (id == null) {
      if (kDebugMode) {
        print('preId $preId');
      }
      setState(() {
        caseAssetArea.caseRansackeds
            ?.removeWhere((element) => element.preId == preId);
      });
    } else {
      if (kDebugMode) {
        print('id $id');
      }
      await CaseRansackedDao().deleteCaseRansacked(id).then((value) {
        setState(() {
          caseAssetArea.caseRansackeds
              ?.removeWhere((element) => element.id == id);
        });
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

  Widget _listItemTabThree(int index) {
    return Slidable(
      endActionPane: ActionPane(
        extentRatio: 0.3,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            flex: 1,
            onPressed: (BuildContext context) {
              if (kDebugMode) {
                print(caseAssetArea.caseRansackeds?[index].preId);
                print(caseAssetArea.caseRansackeds.toString());
              }

              confirmRemove(
                  context,
                  caseAssetArea.caseRansackeds
                      ?.where((element) => element.ransackedTypeID == '2')
                      .toList()[index]
                      .id,
                  caseAssetArea.caseRansackeds
                          ?.where((element) => element.ransackedTypeID == '2')
                          .toList()[index]
                          .preId ??
                      -1);
            },
            backgroundColor: Colors.red,
            icon: Icons.delete,
            label: 'ลบ',
          ),
        ],
      ),
      child: TextButton(
          style: TextButton.styleFrom(
              padding: EdgeInsets.zero, alignment: Alignment.centerLeft),
          child: Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 10),
                caseAssetArea.caseRansackeds
                            ?.where((element) => element.ransackedTypeID == '2')
                            .toList()[index]
                            .isClue ==
                        '2'
                    ? Text(
                        'ไม่พบร่องรอย',
                        textAlign: TextAlign.start,
                        style: GoogleFonts.prompt(
                          textStyle: TextStyle(
                            color: textColor,
                            letterSpacing: .5,
                            fontSize:
                                MediaQuery.of(context).size.height * 0.025,
                          ),
                        ),
                      )
                    : Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ป้ายหมายเลข ${caseAssetArea.caseRansackeds?.where((element) => element.ransackedTypeID == '2').toList()[index].labelNo}',
                              textAlign: TextAlign.start,
                              style: GoogleFonts.prompt(
                                textStyle: TextStyle(
                                  color: textColor,
                                  letterSpacing: .5,
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.025,
                                ),
                              ),
                            ),
                            Text(
                              'บริเวณ${caseAssetArea.caseRansackeds?.where((element) => element.ransackedTypeID == '2').toList()[index].areaDetail}',
                              textAlign: TextAlign.start,
                              style: GoogleFonts.prompt(
                                textStyle: TextStyle(
                                  color: textColor,
                                  letterSpacing: .5,
                                  fontSize:
                                      MediaQuery.of(context).size.height * 0.02,
                                ),
                              ),
                            ),
                            Text(
                              '${caseAssetArea.caseRansackeds?.where((element) => element.ransackedTypeID == '2').toList()[index].detail}',
                              textAlign: TextAlign.start,
                              style: GoogleFonts.prompt(
                                textStyle: TextStyle(
                                  color: textColor,
                                  letterSpacing: .5,
                                  fontSize:
                                      MediaQuery.of(context).size.height * 0.02,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ),
          onPressed: () async {
            var indexEdit = 0;
            for (var i = 0; i < caseAssetArea.caseRansackeds!.length; i++) {
              if (caseAssetArea.caseRansackeds?[i].id == null ||
                  caseAssetArea.caseRansackeds?[i].id == '' ||
                  caseAssetArea.caseRansackeds?[i].id == 'null') {
                if ('${caseAssetArea.caseRansackeds?.where((element) => element.ransackedTypeID == '2').toList()[index].detail}' ==
                    '${caseAssetArea.caseRansackeds?[i].detail}') {
                  indexEdit = i;
                }
              } else {
                if (caseAssetArea.caseRansackeds
                        ?.where((element) => element.ransackedTypeID == '2')
                        .toList()[index]
                        .id ==
                    caseAssetArea.caseRansackeds?[i].id) {
                  indexEdit = i;
                }
              }
            }
            var result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddCaseRansacked(
                          caseAssetArea: caseAssetArea,
                          caseID: widget.caseID ?? -1,
                          caseNo: widget.caseNo,
                          indexEdit: indexEdit,
                          isEdit: true,
                          ransackedTypeID: '2',
                        )));
            if (result != null) {
              setState(() {
                caseAssetArea = result;
                if (kDebugMode) {
                  print(caseAssetArea.caseRansackeds);
                }
              });
            }
          }),
    );
  }

  Widget tabTwo() {
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    title('บริเวณ'),
                    spacer(context),
                    detailView('${caseAssetArea.area}'),
                    spacer(context),
                    headerTabTwoView(),
                    Expanded(
                      child: ListView.builder(
                          itemCount: caseAssetArea.caseRansackeds
                              ?.where(
                                  (element) => element.ransackedTypeID == '1')
                              .length,
                          itemBuilder: (BuildContext ctxt, int index) {
                            return _listItemTab2(index);
                          }),
                    ),
                  ],
                ))));
  }

  Widget headerTabTwoView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          'รายละเอียด',
          textAlign: TextAlign.center,
          style: GoogleFonts.prompt(
            textStyle: TextStyle(
              color: Colors.white,
              letterSpacing: .5,
              fontSize: MediaQuery.of(context).size.height * 0.025,
            ),
          ),
        ),
        TextButton(
            onPressed: () async {
              var result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddCaseRansacked(
                            caseAssetArea: caseAssetArea,
                            caseID: widget.caseID ?? -1,
                            caseNo: widget.caseNo,
                            isEdit: false,
                            ransackedTypeID: '1',
                          )));
              if (result != null) {
                setState(() {
                  caseAssetArea = result;
                  if (kDebugMode) {
                    print(caseAssetArea.caseRansackeds);
                  }
                });
              }
            },
            child: Row(
              children: [
                const Icon(Icons.add, color: Colors.white),
                Text(
                  'เพิ่ม',
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
            ))
      ],
    );
  }

  Widget _listItemTab2(int index) {
    return Slidable(
      endActionPane: ActionPane(
        extentRatio: 0.3,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            flex: 1,
            onPressed: (BuildContext context) {
              if (kDebugMode) {
                print(caseAssetArea.caseRansackeds?[index].preId);
              }
              confirmRemove(
                  context,
                  caseAssetArea.caseRansackeds
                      ?.where((element) => element.ransackedTypeID == '1')
                      .toList()[index]
                      .id,
                  caseAssetArea.caseRansackeds
                          ?.where((element) => element.ransackedTypeID == '1')
                          .toList()[index]
                          .preId ??
                      -1);
            },
            backgroundColor: Colors.red,
            icon: Icons.delete,
            label: 'ลบ',
          ),
        ],
      ),
      child: TextButton(
          style: TextButton.styleFrom(
              padding: EdgeInsets.zero, alignment: Alignment.centerLeft),
          child: Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 10),
                caseAssetArea.caseRansackeds
                            ?.where((element) => element.ransackedTypeID == '1')
                            .toList()[index]
                            .isClue ==
                        '2'
                    ? Text(
                        'ไม่พบร่องรอย',
                        textAlign: TextAlign.start,
                        style: GoogleFonts.prompt(
                          textStyle: TextStyle(
                            color: textColor,
                            letterSpacing: .5,
                            fontSize:
                                MediaQuery.of(context).size.height * 0.025,
                          ),
                        ),
                      )
                    : Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ป้ายหมายเลข ${caseAssetArea.caseRansackeds?.where((element) => element.ransackedTypeID == '1').toList()[index].labelNo}',
                              textAlign: TextAlign.start,
                              style: GoogleFonts.prompt(
                                textStyle: TextStyle(
                                  color: textColor,
                                  letterSpacing: .5,
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.025,
                                ),
                              ),
                            ),
                            Text(
                              'บริเวณ${caseAssetArea.caseRansackeds?.where((element) => element.ransackedTypeID == '1').toList()[index].areaDetail}',
                              textAlign: TextAlign.start,
                              style: GoogleFonts.prompt(
                                textStyle: TextStyle(
                                  color: textColor,
                                  letterSpacing: .5,
                                  fontSize:
                                      MediaQuery.of(context).size.height * 0.02,
                                ),
                              ),
                            ),
                            Text(
                              '${caseAssetArea.caseRansackeds?.where((element) => element.ransackedTypeID == '1').toList()[index].detail}',
                              textAlign: TextAlign.start,
                              style: GoogleFonts.prompt(
                                textStyle: TextStyle(
                                  color: textColor,
                                  letterSpacing: .5,
                                  fontSize:
                                      MediaQuery.of(context).size.height * 0.02,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ),
          onPressed: () async {
            int indexEdit = 0;
            for (var i = 0; i < caseAssetArea.caseRansackeds!.length; i++) {
              if (caseAssetArea.caseRansackeds?[i].id == null ||
                  caseAssetArea.caseRansackeds?[i].id == '' ||
                  caseAssetArea.caseRansackeds?[i].id == 'null') {
                if ('${caseAssetArea.caseRansackeds?.where((element) => element.ransackedTypeID == '1').toList()[index].detail}' ==
                    '${caseAssetArea.caseRansackeds?[i].detail}') {
                  indexEdit = i;
                }
              } else {
                if (caseAssetArea.caseRansackeds
                        ?.where((element) => element.ransackedTypeID == '1')
                        .toList()[index]
                        .id ==
                    caseAssetArea.caseRansackeds?[i].id) {
                  indexEdit = i;
                }
              }
            }
            var result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddCaseRansacked(
                          caseAssetArea: caseAssetArea,
                          caseID: widget.caseID ?? -1,
                          caseNo: widget.caseNo,
                          indexEdit: indexEdit,
                          isEdit: true,
                          ransackedTypeID: '1',
                        )));
            if (result != null) {
              setState(() {
                caseAssetArea = result;
                if (kDebugMode) {
                  print(caseAssetArea.caseRansackeds);
                }
              });
            }
          }),
    );
  }

  Widget tabOne() {
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
              : const EdgeInsets.only(left: 32, right: 32, top: 32, bottom: 32),
          child: ListView(shrinkWrap: true, children: [
            tab1headerName(),
            spacer(context),
            detailView('${caseAssetArea.area}'),
            spacer(context),
            tab1headerView(),
            spacer(context),
            detailView(caseAssetArea.caseAreaClues?.isClue == '1'
                ? 'พบร่องรอย'
                : caseAssetArea.caseAreaClues?.isClue == '2'
                    ? 'ไม่พบร่องรอยใดๆ บริเวณสถานที่เกิดเหตุ'
                    : caseAssetArea.caseAreaClues?.isClue == '3'
                        ? 'ผู้เสียหายไม่ได้ทำการปิดล็อคประตู/หน้าต่าง'
                        : ''),
            (caseAssetArea.caseAreaClues?.isClue == '3' ||
                        caseAssetArea.caseAreaClues?.isClue == '2') &&
                    caseAssetArea.caseAreaClues?.villainEntrance != ''
                ? spacer(context)
                : Container(),
            (caseAssetArea.caseAreaClues?.isClue == '3' ||
                        caseAssetArea.caseAreaClues?.isClue == '2') &&
                    caseAssetArea.caseAreaClues?.villainEntrance != ''
                ? detailView('${caseAssetArea.caseAreaClues?.villainEntrance}')
                : Container(),
            spacer(context),
            caseAssetArea.caseAreaClues?.isClue != '1'
                ? Container()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        clueTypeView(),
                        spacer(context),
                        caseAssetArea.caseAreaClues?.clueTypeID == '4'
                            ? detailView(
                                caseAssetArea.caseAreaClues?.clueTypeDetail)
                            : Container(),
                        spacer(context),
                        checkbox(
                            'ประตู',
                            caseAssetArea.caseAreaClues?.isDoor == '1'
                                ? true
                                : false,
                            (value) {}),
                        spacer(context),
                        detailView(
                            '${_cleanText(caseAssetArea.caseAreaClues?.doorDetail)}'),
                        spacer(context),
                        checkbox(
                            'หน้าต่าง',
                            caseAssetArea.caseAreaClues?.isWindows == '1'
                                ? true
                                : false,
                            (value) {}),
                        caseAssetArea.caseAreaClues?.isWindows == '1'
                            ? spacer(context)
                            : Container(),
                        caseAssetArea.caseAreaClues?.isWindows == '1'
                            ? detailView(
                                '${_cleanText(caseAssetArea.caseAreaClues?.windowsDetail)}')
                            : Container(),
                        spacer(context),
                        checkbox(
                            'ฝ้าเพดาน',
                            caseAssetArea.caseAreaClues?.isCelling == '1'
                                ? true
                                : false,
                            (value) {}),
                        caseAssetArea.caseAreaClues?.isCelling == '1'
                            ? spacer(context)
                            : Container(),
                        caseAssetArea.caseAreaClues?.isCelling == '1'
                            ? detailView(
                                '${_cleanText(caseAssetArea.caseAreaClues?.cellingDetail)}')
                            : Container(),
                        spacer(context),
                        checkbox(
                            'หลังคา',
                            caseAssetArea.caseAreaClues?.isRoof == '1'
                                ? true
                                : false,
                            (value) {}),
                        caseAssetArea.caseAreaClues?.isRoof == '1'
                            ? spacer(context)
                            : Container(),
                        caseAssetArea.caseAreaClues?.isRoof == '1'
                            ? detailView(
                                '${_cleanText(caseAssetArea.caseAreaClues?.roofDetail)}')
                            : Container(),
                        spacer(context),
                        checkbox(
                            'อื่นๆ',
                            caseAssetArea.caseAreaClues?.isClueOther == '1'
                                ? true
                                : false,
                            (value) {}),
                        caseAssetArea.caseAreaClues?.isClueOther == '1'
                            ? spacer(context)
                            : Container(),
                        caseAssetArea.caseAreaClues?.isClueOther == '1'
                            ? detailView(
                                '${_cleanText(caseAssetArea.caseAreaClues?.clueOtherDetail)}')
                            : Container(),
                        spacer(context),
                        title('ป้ายหมายเลข'),
                        detailView(
                            '${_cleanText(caseAssetArea.caseAreaClues?.labelNo)}'),
                        spacer(context),
                        title('เครื่องมือที่ใช้ในการโจรกรรม'),
                        spacer(context),
                        checkbox(
                            'ไขควง',
                            caseAssetArea.caseAreaClues?.isTools1 == '1'
                                ? true
                                : false,
                            (value) {}),
                        caseAssetArea.caseAreaClues?.isTools1 == '1'
                            ? spacer(context)
                            : Container(),
                        caseAssetArea.caseAreaClues?.isTools1 == '1'
                            ? detailView(
                                '${_cleanText(caseAssetArea.caseAreaClues?.tools1Detail)}')
                            : Container(),
                        spacer(context),
                        checkbox(
                            'ชะแลง',
                            caseAssetArea.caseAreaClues?.isTools2 == '1'
                                ? true
                                : false,
                            (value) {}),
                        caseAssetArea.caseAreaClues?.isTools2 == '1'
                            ? spacer(context)
                            : Container(),
                        caseAssetArea.caseAreaClues?.isTools2 == '1'
                            ? detailView(
                                '${caseAssetArea.caseAreaClues?.tools2Detail}')
                            : Container(),
                        spacer(context),
                        checkbox(
                            'คีมตัดโลหะ',
                            caseAssetArea.caseAreaClues?.isTools3 == '1'
                                ? true
                                : false,
                            (value) {}),
                        caseAssetArea.caseAreaClues?.isTools3 == '1'
                            ? spacer(context)
                            : Container(),
                        caseAssetArea.caseAreaClues?.isTools3 == '1'
                            ? detailView(
                                '${caseAssetArea.caseAreaClues?.tools3Detail}')
                            : Container(),
                        spacer(context),
                        checkbox(
                            'อื่นๆ',
                            caseAssetArea.caseAreaClues?.isTools4 == '1'
                                ? true
                                : false,
                            (value) {}),
                        caseAssetArea.caseAreaClues?.isTools4 == '1'
                            ? spacer(context)
                            : Container(),
                        caseAssetArea.caseAreaClues?.isTools4 == '1'
                            ? detailView(
                                '${caseAssetArea.caseAreaClues?.tools4Detail}')
                            : Container(),
                        spacer(context),
                        title('ขนาดความกว้างของรอยประมาณ'),
                        spacer(context),
                        detailView(
                            '${_cleanText(caseAssetArea.caseAreaClues?.width)} ${caseAssetArea.caseAreaClues?.widthUnitID}'),
                        spacer(context),
                      ]),
            spacer(context),
          ]),
        ),
      ),
    );
  }

  checkbox(String? text, bool isChecked, Function onChanged) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
    ]);
  }

  clueTypeView() {
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
                  value: 1,
                  activeColor: pinkButton,
                  groupValue:
                      int.parse(caseAssetArea.caseAreaClues?.clueTypeID ?? ''),
                  onChanged: (value) {}),
            ),
            Text(
              'การงัด',
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
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Transform.scale(
              scale: 1.2,
              child: Radio(
                value: 2,
                activeColor: pinkButton,
                groupValue:
                    int.parse(caseAssetArea.caseAreaClues?.clueTypeID ?? ''),
                onChanged: (value) {},
              ),
            ),
            Text(
              'การตัด',
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
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Transform.scale(
              scale: 1.2,
              child: Radio(
                value: 3,
                activeColor: pinkButton,
                groupValue:
                    int.parse(caseAssetArea.caseAreaClues?.clueTypeID ?? ''),
                onChanged: (value) {},
              ),
            ),
            Text(
              'การเจาะ',
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
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Transform.scale(
              scale: 1.2,
              child: Radio(
                  value: 4,
                  activeColor: pinkButton,
                  groupValue:
                      int.parse(caseAssetArea.caseAreaClues?.clueTypeID ?? ''),
                  onChanged: (value) {}),
            ),
            Text(
              'ร่องรอยอื่นๆ',
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

  title(String? title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        '$title',
        textAlign: TextAlign.left,
        style: GoogleFonts.prompt(
          textStyle: TextStyle(
            color: Colors.white,
            letterSpacing: .5,
            fontSize: MediaQuery.of(context).size.height * 0.025,
          ),
        ),
      ),
    );
  }

  detailView(String? text) {
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
          maxLines: null,
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

  Widget radioView(String? text, int value) {
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
                value: value,
                activeColor: pinkButton,
                groupValue: _radioValueTab1,
                onChanged: (val) {
                  _handleRadioValueChange(val!);
                },
              ),
            ),
            Text(
              text ?? '',
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

  final int _radioValueTab1 = 0;
  void _handleRadioValueChange(int value) {
    // setState(() {
    //   _radioValueTab1 = value;

    //   switch (_radioValueTab1) {
    //     case 0:
    //       break;
    //     case 1:
    //       break;
    //     case 2:
    //       break;
    //   }
    // });
  }

  Widget spacer(context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.015,
    );
  }

  Widget tab1headerName() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          'บริเวณ',
          textAlign: TextAlign.center,
          style: GoogleFonts.prompt(
            textStyle: TextStyle(
              color: Colors.white,
              letterSpacing: .5,
              fontSize: MediaQuery.of(context).size.height * 0.025,
            ),
          ),
        ),
        ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Colors.transparent,
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ))),
            onPressed: () async {
              var result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditArea(
                            caseAssetArea: caseAssetArea,
                            caseID: widget.caseID ?? -1,
                            caseNo: widget.caseNo,
                            isEdit: widget.isEdit,
                          )));
              if (result != null) {
                setState(() {
                  caseAssetArea.area = result;
                });
              }
            },
            child: Row(
              children: [
                const Icon(Icons.edit, color: Colors.white),
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
            ))
      ],
    );
  }

  Widget tab1headerView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          'รายละเอียด',
          textAlign: TextAlign.center,
          style: GoogleFonts.prompt(
            textStyle: TextStyle(
              color: Colors.white,
              letterSpacing: .5,
              fontSize: MediaQuery.of(context).size.height * 0.025,
            ),
          ),
        ),
        ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Colors.transparent,
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ))),
            onPressed: () async {
              var result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddTab1CaseAssetArea(
                            caseAssetArea: widget.caseAssetArea,
                            caseID: widget.caseID ?? -1,
                            caseNo: widget.caseNo,
                            isEdit: widget.isEdit,
                          )));
              if (result != null) {
                setState(() {
                  caseAssetArea = result;
                  if (kDebugMode) {
                    print(caseAssetArea.toString());
                    print(caseAssetArea.caseAreaClues?.toString());
                  }
                });
              }
            },
            child: Row(
              children: [
                const Icon(Icons.edit, color: Colors.white),
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
            ))
      ],
    );
  }

  Widget tab1detailView(String? text, bool value) {
    return Padding(
      padding: const EdgeInsets.only(left: 36),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Transform.scale(
                      scale: 2.0,
                      child: Checkbox(
                        checkColor: Colors.greenAccent,
                        activeColor: Colors.red,
                        value: value,
                        onChanged: (value) {
                          // setState(() {
                          //   this.valuefirst = value;
                          // });
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                    Text(
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
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String? _cleanText(String? text) {
    var str = '';
    try {
      if (text == null ||
          text == '' ||
          text == 'null' ||
          text == 'Null' ||
          text == '-1') {
        str = '';
      }
      str = text ?? '';
    } catch (ex) {
      str = '';
    }
    return str;
  }
}
