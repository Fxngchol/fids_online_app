import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/color.dart';
import '../../../models/CaseAsset.dart';
import '../../../models/CaseAssetArea.dart';
import '../../../models/CaseRansacked.dart';
import '../../../models/Unit.dart';
import '../../../widget/app_bar_widget.dart';
import 'edit_case_asset.dart';

class CaseAssetDetail extends StatefulWidget {
  final int? caseID;
  final String? caseNo;
  final String? caseAssetId;

  const CaseAssetDetail(
      {super.key, required this.caseID, this.caseNo, this.caseAssetId});

  @override
  CaseAssetDetailState createState() => CaseAssetDetailState();
}

class CaseAssetDetailState extends State<CaseAssetDetail> {
  bool isPhone = Device.get().isPhone;
  bool isLoading = false;
  List<Unit>? units;
  List<CaseAssetArea>? caseAssetsAreaList = [];
  List<CaseRansacked>? ransackedList = [];
  CaseAsset? caseAssets = CaseAsset();
  @override
  void initState() {
    super.initState();
    asyncMethod();
  }

  asyncMethod() async {
    asyncCall1();
    if (kDebugMode) {
      print('widget.caseID.toString() ${widget.caseID.toString()}');
    }
  }

  void asyncCall1() async {
    var unitResult = await UnitDao().getUnit();
    var caseAssetAreaResult =
        await CaseAssetAreaDao().getCaseAssetArea(widget.caseID ?? -1);
    caseAssetsAreaList = caseAssetAreaResult;
    units = unitResult;
    var result =
        await CaseAssetDao().getCaseAssetById(widget.caseAssetId.toString());
    setState(() {
      caseAssets = result;
      isLoading = false;
    });
  }

  String? getLabelArea(String? areaId) {
    var area = '';
    if (caseAssetsAreaList != null) {}
    for (int i = 0; i < caseAssetsAreaList!.length; i++) {
      if (areaId == caseAssetsAreaList?[i].id) {
        area = caseAssetsAreaList?[i].area ?? '';
      }
    }
    if (area == '') {
      return '';
    } else {
      return area;
    }
  }

  List<CaseRansacked>? getRansackedList(String? areaId) {
    if (caseAssetsAreaList != null) {
      for (int i = 0; i < caseAssetsAreaList!.length; i++) {
        if (areaId == caseAssetsAreaList?[i].id) {
          return caseAssetsAreaList?[i].caseRansackeds;
        }
      }
    }
    return [];
  }

  String? getLabelRansacked(String? ransackedId) {
    if (caseAssetsAreaList != null) {
      for (int i = 0; i < ransackedList!.length; i++) {
        if (ransackedId == ransackedList![i].id) {
          return ransackedList![i].areaDetail;
        }
      }
    }
    return '';
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
                            isEdit: true,
                            caseAssetId: widget.caseAssetId)));
                if (result) {
                  asyncCall1();
                }
              },
              child: Icon(
                Icons.edit,
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
                    child: ListView(
                      children: [
                        title('รายการทรัพย์สิน'),
                        spacer(),
                        detailView('${_cleanText(caseAssets?.asset)}'),
                        spacer(),
                        title('จำนวน'),
                        spacer(),
                        detailView(
                            '${_cleanText(caseAssets?.assetAmount)} ${_cleanText(caseAssets?.assetUnit)}'),
                        spacer(),
                        title('บริเวณ'),
                        spacer(),
                        detailView('${caseAssets?.areaDetail}'),
                        spacer(),
                        title('รายละเอียด'),
                        spacer(),
                        detailView('${caseAssets?.ransackedDetail}'),
                        spacer(),
                      ],
                    ),
                  ),
          ),
        ));
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

  spacer() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.01,
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

  String? unitLabel(String? id) {
    if (units != null) {
      for (int i = 0; i < units!.length; i++) {
        if ('$id' == '${units![i].id}') {
          return units![i].name;
        }
      }
    }
    return '';
  }
}
