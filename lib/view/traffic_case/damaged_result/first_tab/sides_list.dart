import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../Utils/color.dart';
import '../../../../models/case_vehicle/CaseDamaged.dart';
import '../../../../widget/app_bar_widget.dart';
import '../../../../widget/blurry_dialog.dart';
import 'add_first_tab.dart';

class SideListPage extends StatefulWidget {
  final int? caseID, vehicleId, sideId;
  final String? caseNo, vehicleDetail, sideName;
  const SideListPage(
      {super.key,
      this.vehicleId,
      this.vehicleDetail,
      this.caseID,
      this.caseNo,
      this.sideId,
      this.sideName});

  @override
  State<SideListPage> createState() => SideListPageState();
}

class SideListPageState extends State<SideListPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<CaseDamaged> caseDamages = [];
  bool isLoading = true;
  bool isPhone = Device.get().isPhone;

  @override
  void initState() {
    asyncCall();
    super.initState();
  }

  asyncCall() async {
    await CaseDamagedDao()
        .getCaseDamagesBySide(
            widget.caseID ?? -1, widget.vehicleId ?? -1, widget.sideId ?? -1)
        .then((value) {
      setState(() {
        caseDamages = value;
        if (kDebugMode) {
          print('caseDamages: ${caseDamages.toString()}');
        }
        isLoading = false;
      });
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
        title: 'รายละเอียดผลการตรวจพิสูจน์',
        actions: [
          Container(
            width: MediaQuery.of(context).size.width * 0.1,
          )
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      vehicleDetail(),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'รายละเอียดผลตรวจพิสูจน์',
                            style: GoogleFonts.prompt(
                              textStyle: TextStyle(
                                color: Colors.white,
                                letterSpacing: .5,
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.02,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              var result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddFisrtTab(
                                          vehicleId: widget.vehicleId ?? -1,
                                          vehicleDetail:
                                              widget.vehicleDetail ?? '',
                                          caseID: widget.caseID ?? -1,
                                          caseNo: widget.caseNo ?? '',
                                          isEdit: false,
                                          sideId: widget.sideId ?? -1,
                                          sideName: widget.sideName ?? '')));
                              if (result) {
                                asyncCall();
                              }
                            },
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
                                  style: GoogleFonts.prompt(
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                      letterSpacing: .5,
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.02,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      caseDamages.isNotEmpty
                          ? Expanded(
                              child: ListView.builder(
                                  itemCount: caseDamages.length,
                                  itemBuilder: (BuildContext ctxt, int index) {
                                    return _listItem(index);
                                  }),
                            )
                          : Expanded(
                              child: Center(
                                child: Text(
                                  'ไม่พบรายการผลตรวจพิสูจน์',
                                  style: GoogleFonts.prompt(
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                      letterSpacing: .5,
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.015,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _spacer() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.015,
    );
  }

  Widget vehicleDetail() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.03,
                  vertical: MediaQuery.of(context).size.width * 0.01),
              child: Text(
                '${widget.vehicleDetail}',
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
          ),
          _spacer(),
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.03,
                  vertical: MediaQuery.of(context).size.width * 0.01),
              child: Text(
                '${widget.sideName}',
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
          ),
        ],
      ),
    );
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
              _removeCaseVihicleDemage(index);
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
                  builder: (context) => AddFisrtTab(
                      vehicleId: widget.vehicleId ?? -1,
                      vehicleDetail: widget.vehicleDetail ?? '',
                      caseID: widget.caseID ?? -1,
                      caseNo: widget.caseNo ?? '',
                      vehicleDamagedId: int.parse(caseDamages[index].id ?? ''),
                      sideId: widget.sideId ?? -1,
                      sideName: widget.sideName ?? '',
                      isEdit: true)));
          if (result) {
            asyncCall();
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
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ลำดับที่ ${index + 1}',
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
                        caseDamages[index].isDamaged == '1'
                            ? 'ตรวจพบ${caseDamages[index].damagedDetail}'
                            : 'ตรวจไม่พบสภาพและความเสียหาย',
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
                      caseDamages[index].height != ''
                          ? Text(
                              'ที่ระดับความสูงจากพื้น ${caseDamages[index].height}',
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
                      caseDamages[index].damagedOther != ''
                          ? Text(
                              '${caseDamages[index].damagedOther}',
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

  void _removeCaseVihicleDemage(int index) async {
    BlurryDialog alert = BlurryDialog('แจ้งเตือน', 'ยืนยันการลบ', () async {
      await CaseDamagedDao()
          .deleteCaseVehicleDamaged(caseDamages[index].id)
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
