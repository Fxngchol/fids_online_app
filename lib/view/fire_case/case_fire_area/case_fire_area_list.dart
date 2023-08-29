// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/color.dart';
import '../../../models/CaseCategory.dart';
import '../../../models/FidsCrimeScene.dart';
import '../../../models/case_fire/CaseFireArea.dart';
import '../../../models/case_fire/CaseFireAreaDoa.dart';
import '../../../models/case_fire/CaseFireSideArea.dart';
import '../../../widget/app_bar_widget.dart';
import '../../../widget/blurry_dialog.dart';
import 'add_case_fire_area.dart';

class CaseFireAreaList extends StatefulWidget {
  final int? caseID;
  final String? caseNo;
  final bool? isVehicleType;

  const CaseFireAreaList(
      {super.key, this.caseID, this.caseNo, this.isVehicleType});

  @override
  CaseFireAreaListState createState() => CaseFireAreaListState();
}

class CaseFireAreaListState extends State<CaseFireAreaList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isPhone = Device.get().isPhone;
  bool isLoading = true;
  List<CaseFireArea> caseFireAreas = [];
  List<CaseFireSideArea> caseFireSideAreas = [];
  List<int> sizeOfSide = [];

  String? caseName;

  @override
  void initState() {
    super.initState();
    asyncMethod();
  }

  asyncMethod() async {
    isLoading = true;
    asyncCall1();
    if (kDebugMode) {
      print('caseID: ${widget.caseID}, caseNo: ${widget.caseNo}');
    }
  }

  void asyncCall1() async {
    var fidsCrimescene =
        await FidsCrimeSceneDao().getFidsCrimeSceneById(widget.caseID ?? -1);
    caseFireAreas =
        await CaseFireAreaDao().getCaseFireArea(widget.caseID ?? -1);
    sizeOfSide = [];
    await CaseCategoryDAO()
        .getCaseCategoryLabelByid(fidsCrimescene?.caseCategoryID ?? -1)
        .then((value) => caseName = value);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    return Scaffold(
        extendBodyBehindAppBar: true,
        key: _scaffoldKey,
        appBar: AppBarWidget(
          leading: IconButton(
              icon: isIOS
                  ? const Icon(Icons.arrow_back_ios)
                  : const Icon(Icons.arrow_back),
              onPressed: () async {
                Navigator.of(context).pop(true);
              }),
          title: widget.isVehicleType ?? false
              ? 'สภาพความเสียหายของโครงสร้างยานพาหนะ'
              : 'สภาพความเสียหายของโครงสร้างอาคาร',
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
                        builder: (context) => AddCaseFireArea(
                              isEdit: false,
                              caseID: widget.caseID ?? -1,
                              caseNo: widget.caseNo,
                              isVehicleType: widget.isVehicleType ?? false,
                            )));
                if (result != null) {
                  asyncMethod();
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
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : SafeArea(
                    child: Container(
                        margin: isPhone
                            ? const EdgeInsets.all(32)
                            : const EdgeInsets.only(
                                left: 32, right: 32, top: 32, bottom: 32),
                        child: Column(
                          children: [
                            headerView(),
                            caseFireAreas.isNotEmpty
                                ? Expanded(
                                    child: ListView.builder(
                                        itemCount: caseFireAreas.length,
                                        itemBuilder:
                                            (BuildContext ctxt, int index) {
                                          return _listItem(index);
                                        }),
                                  )
                                : Expanded(
                                    child: Center(
                                      child: Text(
                                        'ไม่พบรายการ',
                                        style: GoogleFonts.prompt(
                                          textStyle: TextStyle(
                                            color: Colors.white,
                                            letterSpacing: .5,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.015,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                          ],
                        )))));
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
              _removeCaseVihicle(index);
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
                  builder: (context) => AddCaseFireArea(
                      isEdit: true,
                      caseID: widget.caseID ?? -1,
                      caseNo: widget.caseNo,
                      isVehicleType: widget.isVehicleType ?? false,
                      caseFireAreaID: caseFireAreas[index].id)));
          if (result != null) {
            asyncMethod();
          }
        },
        child: Container(
          padding:
              const EdgeInsets.only(left: 12, right: 12, bottom: 6, top: 6),
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      textDetail(
                          title: 'รายการที่ ${index + 1}',
                          text: caseFireAreas[index].areaDetail),
                      // caseFireAreas[index].front1 == null &&
                      //     caseFireAreas[index].front1 == ''
                      // ? Container()
                      // : textDetail(
                      //     title: 'ด้านหน้า:',
                      //     text: caseFireAreas[index].front1),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: textColor,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  textDetail({String? title, String? text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title',
          textAlign: TextAlign.left,
          maxLines: null,
          style: GoogleFonts.prompt(
            textStyle: TextStyle(
              fontWeight: FontWeight.w500,
              color: textColor,
              letterSpacing: .5,
              fontSize: MediaQuery.of(context).size.height * 0.022,
            ),
          ),
        ),
        Text(
          '$text',
          textAlign: TextAlign.left,
          maxLines: null,
          style: GoogleFonts.prompt(
            textStyle: TextStyle(
              color: textColor,
              letterSpacing: .5,
              fontSize: MediaQuery.of(context).size.height * 0.02,
            ),
          ),
        ),
        // Padding(
        //   padding: EdgeInsets.symmetric(vertical: 4.0),
        //   child: Divider(
        //     color: Colors.grey,
        //   ),
        // ),
      ],
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

  void _removeCaseVihicle(int index) async {
    BlurryDialog alert = BlurryDialog('แจ้งเตือน', 'ยืนยันการลบ', () async {
      await CaseFireAreaDao()
          .deleteCaseFireArea(caseFireAreas[index].id)
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
