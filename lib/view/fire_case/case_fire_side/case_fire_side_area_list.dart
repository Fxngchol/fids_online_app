import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../Utils/color.dart';
import '../../../models/case_fire/CaseFireSideArea.dart';
import '../../../models/case_fire/CaseFireSideAreaDao.dart';
import '../../../widget/app_bar_widget.dart';
import '../../../widget/blurry_dialog.dart';
import '../../traffic_case/case_behavior.dart/case_behavior.dart';

class CaseFireSideAreaList extends StatefulWidget {
  final int? caseID;
  final String? caseNo, caseFireAreaID;
  final bool? isVehicleType, isSideAreaDetail;

  const CaseFireSideAreaList(
      {super.key,
      this.caseID,
      this.caseNo,
      this.isVehicleType,
      this.isSideAreaDetail,
      this.caseFireAreaID});

  @override
  CaseFireSideAreaListState createState() => CaseFireSideAreaListState();
}

class CaseFireSideAreaListState extends State<CaseFireSideAreaList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isPhone = Device.get().isPhone;
  bool isLoading = true;
  List<CaseFireSideArea> caseFireSideAreas = [];

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
    caseFireSideAreas =
        await CaseFireSideAreaDao().getAllCaseFireSideArea(widget.caseID ?? -1);
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
          title: 'รายการความเสียหายบริเวณข้างเคียง',
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
                        builder: (context) => CaseBehaviorPage(
                            caseFireAreaID: widget.caseFireAreaID,
                            caseID: widget.caseID ?? -1,
                            isEdit: false,
                            fieldName: 'FireSideArea')));
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
                            caseFireSideAreas.isNotEmpty
                                ? Expanded(
                                    child: ListView.builder(
                                        itemCount: caseFireSideAreas.length,
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
                  builder: (context) => CaseBehaviorPage(
                      fireSideAreaDetail:
                          caseFireSideAreas[index].sideAreaDetail,
                      caseFireSideAreaID: caseFireSideAreas[index].id,
                      caseFireAreaID: widget.caseFireAreaID,
                      caseID: widget.caseID ?? -1,
                      isEdit: true,
                      fieldName: 'FireSideArea')));
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
                  child: Text(
                    '${caseFireSideAreas[index].sideAreaDetail}',
                    textAlign: TextAlign.left,
                    style: GoogleFonts.prompt(
                      textStyle: TextStyle(
                        color: textColor,
                        letterSpacing: .5,
                        fontSize: MediaQuery.of(context).size.height * 0.022,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
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

  void _removeCaseVihicle(int index) async {
    BlurryDialog alert = BlurryDialog('แจ้งเตือน', 'ยืนยันการลบ', () async {
      await CaseFireSideAreaDao()
          .deleteCaseFireSideArea(caseFireSideAreas[index].id)
          .then((value) {
        asyncCall1();
        if (kDebugMode) {
          print('removing');
        }
        // ignore: deprecated_member_use
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
