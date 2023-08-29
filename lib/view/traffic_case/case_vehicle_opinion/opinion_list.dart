import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../models/CaseCategory.dart';
import '../../../models/FidsCrimeScene.dart';
import '../../../models/case_vehicle/CaseVehicleOpinion.dart';
import '../../../utils/color.dart';
import '../../../widget/app_bar_widget.dart';
import '../../../widget/blurry_dialog.dart';
import 'add_opinion.dart';

class CaseVehicleOpinionList extends StatefulWidget {
  final int? caseID;
  final String? caseNo;
  final bool isLocal;

  const CaseVehicleOpinionList(
      {super.key, required this.caseID, this.caseNo, this.isLocal = false});

  @override
  CaseVehicleListState createState() => CaseVehicleListState();
}

class CaseVehicleListState extends State<CaseVehicleOpinionList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isPhone = Device.get().isPhone;
  bool isLoading = true;

  List<CaseVehicleOpinion> opinionList = [];

  String? caseName;

  @override
  void initState() {
    super.initState();
    asyncCall();
  }

  void asyncCall() async {
    isLoading = true;
    var fidsCrimescene =
        await FidsCrimeSceneDao().getFidsCrimeSceneById(widget.caseID ?? -1);
    var caseVehiclesOpinions = await CaseVehicleOpinionDao()
        .getCaseVehicleOpinions(widget.caseID ?? -1);

    await CaseCategoryDAO()
        .getCaseCategoryLabelByid(fidsCrimescene?.caseCategoryID ?? -1)
        .then((value) => caseName = value);
    setState(() {
      opinionList = caseVehiclesOpinions;
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
          title: 'รายการความเห็น',
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
                        builder: (context) => AddOpinionPage(
                              isEdit: false,
                              caseID: widget.caseID ?? -1,
                              caseNo: widget.caseNo,
                            )));
                if (result != null) {
                  asyncCall();
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
                            opinionList.isNotEmpty
                                ? Expanded(
                                    child: ListView.builder(
                                        itemCount: opinionList.length,
                                        itemBuilder:
                                            (BuildContext ctxt, int index) {
                                          return _listItem(index);
                                        }),
                                  )
                                : Expanded(
                                    child: Center(
                                      child: Text(
                                        'ไม่พบรายการความเห็น',
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
                  builder: (context) => AddOpinionPage(
                        isEdit: true,
                        caseID: widget.caseID ?? -1,
                        caseNo: widget.caseNo,
                        opinionID: int.parse(opinionList[index].id ?? ''),
                      )));
          if (result != null) {
            asyncCall();
          }
          // var result = await Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => OpinionDetailPage(
          //               opinionID: int.parse(opinionList[index].id),
          //               caseID: widget.caseID ?? -1,
          //               caseNo: widget.caseNo,
          //               isEdit: true,
          //             )));
          // if (result != null) {
          //   asyncCall();
          // }
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
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'รายการที่ ${index + 1}',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.prompt(
                          textStyle: TextStyle(
                            color: textColor,
                            letterSpacing: .5,
                            fontSize:
                                MediaQuery.of(context).size.height * 0.022,
                          ),
                        ),
                      ),
                      Text(
                        '${opinionList[index].opinion?.trim()}',
                        textAlign: TextAlign.left,
                        maxLines: null,
                        style: GoogleFonts.prompt(
                          textStyle: TextStyle(
                            color: textColor,
                            letterSpacing: .5,
                            fontSize:
                                MediaQuery.of(context).size.height * 0.022,
                          ),
                        ),
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

  void _removeCaseVihicle(int index) async {
    BlurryDialog alert = BlurryDialog('แจ้งเตือน', 'ยืนยันการลบ', () async {
      await CaseVehicleOpinionDao()
          .deleteCaseVehicleOpinion(opinionList[index].id)
          .then((value) {
        asyncCall();
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
