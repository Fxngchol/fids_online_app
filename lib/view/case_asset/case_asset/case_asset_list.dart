import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/color.dart';
import '../../../models/CaseAsset.dart';
import '../../../models/FidsCrimeScene.dart';
import '../../../widget/app_bar_widget.dart';
import '../../../widget/blurry_dialog.dart';
import 'case_asset_detail.dart';
import 'edit_case_asset.dart';

class CaseAssetList extends StatefulWidget {
  final int? caseID;
  final String? caseNo;
  const CaseAssetList({super.key, required this.caseID, this.caseNo});

  @override
  CaseAssetListState createState() => CaseAssetListState();
}

class CaseAssetListState extends State<CaseAssetList> {
  List<CaseAsset> caseAssets = [];
  bool isPhone = Device.get().isPhone;
  bool isLoading = true;
  FidsCrimeScene? fidsCrimescene;

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
      fidsCrimescene = value;
      var assets = await CaseAssetDao().getCaseAsset(widget.caseID ?? -1);

      setState(() {
        caseAssets = assets;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBarWidget(
          title: 'รายการทรัพย์สินถูกโจรกรรม',
          actions: [
            TextButton(
              onPressed: () async {
                var result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditCaseAsset(
                            caseID: widget.caseID ?? -1,
                            caseNo: widget.caseNo,
                            isEdit: false)));
                if (result) {
                  asyncCall1();
                }
              },
              child: Icon(
                Icons.add,
                size: MediaQuery.of(context).size.height * 0.03,
                color: Colors.white,
              ),
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
                        Expanded(
                          child: caseAssets.isEmpty
                              ? Center(
                                  child: Center(
                                    child: Text(
                                      'ไม่มีข้อมูล',
                                      textAlign: TextAlign.start,
                                      style: GoogleFonts.prompt(
                                        textStyle: TextStyle(
                                          color: Colors.white,
                                          letterSpacing: .5,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.020,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: caseAssets.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Slidable(
                                      endActionPane: ActionPane(
                                        extentRatio: 0.3,
                                        motion: const ScrollMotion(),
                                        children: [
                                          SlidableAction(
                                            flex: 1,
                                            onPressed: (BuildContext context) {
                                              confirmRemoveCaseClue(
                                                  context, index);
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
                                                  builder: (context) =>
                                                      CaseAssetDetail(
                                                          caseID:
                                                              widget.caseID ??
                                                                  -1,
                                                          caseAssetId:
                                                              caseAssets[index]
                                                                  .id)));
                                          if (result != null) {
                                            setState(() {
                                              asyncCall1();
                                            });
                                          }
                                          // print(
                                          //     'object : ${caseAssets[index].id}');
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(10),
                                          margin: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              color:
                                                  Colors.white.withOpacity(0.8),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(width: 10),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 24.0,
                                                            bottom: 12,
                                                            top: 12),
                                                    child: Text(
                                                      '${caseAssets[index].asset}',
                                                      textAlign:
                                                          TextAlign.start,
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
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                        ),
                      ],
                    ),
                  ),
          ),
        ));
  }

  spacer() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.01,
    );
  }

  void confirmRemoveCaseClue(BuildContext context, int index) {
    BlurryDialog alert = BlurryDialog('แจ้งเตือน', 'ยืนยันการลบ', () async {
      CaseAssetDao().deleteCaseAssetById(caseAssets[index].id).then((value) {
        caseAssets.removeAt(index);
        asyncCall1();
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
}
