import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/color.dart';
import '../../../models/CaseAreaClue.dart';
import '../../../models/CaseAssetArea.dart';
import '../../../models/CaseCategory.dart';
import '../../../models/CaseRansacked.dart';
import '../../../models/FidsCrimeScene.dart';
import '../../../widget/app_bar_widget.dart';
import '../../../widget/blurry_dialog.dart';
import 'add_area.dart';
import 'case_asset_area_form.dart';

class CaseAssetAreaPage extends StatefulWidget {
  final int? caseID;
  final String? caseNo;

  const CaseAssetAreaPage({super.key, this.caseID, this.caseNo});

  @override
  CaseAssetAreaPageState createState() => CaseAssetAreaPageState();
}

class CaseAssetAreaPageState extends State<CaseAssetAreaPage> {
  bool isPhone = Device.get().isPhone;
  bool isLoading = true;
  List<CaseAssetArea> caseAssets = [];
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
    var fidsCrimeScene =
        await FidsCrimeSceneDao().getFidsCrimeSceneById(widget.caseID ?? -1);

    await CaseCategoryDAO()
        .getCaseCategoryLabelByid(fidsCrimeScene?.caseCategoryID ?? -1)
        .then((value) => caseName = value);

    var result = await CaseAssetAreaDao().getCaseAssetArea(widget.caseID ?? -1);
    setState(() {
      caseAssets = result;
      if (kDebugMode) {
        print(caseAssets.toString());
      }
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
        title: 'สภาพร่องรอย/ตำแหน่งที่ตรวจพบ',
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
                itemCount: caseAssets.length + 1,
                itemBuilder: (BuildContext ctxt, int index) {
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        children: [
                          headerView(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              title('รายการ'),
                              TextButton(
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.add,
                                      size: MediaQuery.of(context).size.height *
                                          0.03,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      'เพิ่ม',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.prompt(
                                        textStyle: TextStyle(
                                          color: Colors.white,
                                          letterSpacing: .5,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height *
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
                                          builder: (context) => AddAreaPage(
                                              caseAssetArea: null,
                                              caseID: widget.caseID ?? -1,
                                              caseNo: widget.caseNo,
                                              isEdit: false)));

                                  if (result) {
                                    asyncCall1();
                                  }
                                },
                              ),
                            ],
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
        extentRatio: 0.3,
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
          var result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CaseAssetAreaForm(
                      area: caseAssets[index].area,
                      caseAssetArea: caseAssets[index],
                      caseID: widget.caseID ?? -1,
                      caseNo: widget.caseNo,
                      isEdit: true)));

          if (result) {
            asyncCall1();
          }
        },
        child: Container(
          padding:
              const EdgeInsets.only(left: 32, right: 24, bottom: 24, top: 16),
          margin: const EdgeInsets.only(top: 6, bottom: 6),
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'บริเวณ ${caseAssets[index].area}',
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
                    ],
                  ),
                ],
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: textColor,
                size: MediaQuery.of(context).size.height * 0.02,
              )
            ],
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

  void _displaySnackbar(int index) async {
    BlurryDialog alert =
        BlurryDialog('แจ้งเตือน', 'ยืนยันการลบสภาพร่องร่อง/ตำแหน่ง', () async {
      await CaseAreaClueDao().deleteCaseAreaClueAll(caseAssets[index].id);
      await CaseRansackedDao()
          .deleteCaseRansackedAll(caseAssets[index].id ?? '');
      await CaseAssetAreaDao()
          .deleteCaseAssetArea(caseAssets[index].id)
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
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
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
}
