import 'package:fids_online_app/view/traffic_case/damaged_result/second_tab/second_tab.dart';
import 'package:fids_online_app/view/traffic_case/damaged_result/third_tab/third_tab.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/color.dart';
import 'first_tab/first_tab.dart';

class ResultAllTab extends StatefulWidget {
  final int? caseID, vehicleId;
  final String? caseNo, vehicleDetail;

  const ResultAllTab(
      {super.key,
      required this.vehicleId,
      this.vehicleDetail,
      this.caseID,
      this.caseNo});

  @override
  State<ResultAllTab> createState() => ResultAllTabState();
}

class ResultAllTabState extends State<ResultAllTab>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController _tabController;

  static const List<Tab> _tabs = [
    Tab(child: Text('ผลการตรวจพิสูจน์')),
    Tab(text: 'วัตถุพยานที่ตรวจเก็บ'),
    Tab(text: 'แผนผัง'),
  ];

  bool isPhone = Device.get().isPhone;
  bool isLoading = false;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    if (kDebugMode) {
      print('${widget.vehicleDetail}');
    }
    // CaseDamagedDao().getCaseDamages(fidsID);
    super.initState();
  }

  asyncCall() {}

  @override
  Widget build(BuildContext context) {
    bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    return Scaffold(
        extendBodyBehindAppBar: true,
        key: _scaffoldKey,
        appBar: AppBar(
          actions: [
            Container(
              width: MediaQuery.of(context).size.width * 0.1,
            )
          ],
          leading: IconButton(
              icon: isIOS
                  ? const Icon(Icons.arrow_back_ios)
                  : const Icon(Icons.arrow_back),
              onPressed: () async {
                Navigator.of(context).pop(true);
              }),
          bottom: TabBar(
            onTap: (int index) {
              _tabController.animateTo(index);
            },
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
            labelColor: const Color(0xffffffff),
            unselectedLabelColor: const Color(0x55ffffff),
            controller: _tabController,
            tabs: _tabs,
          ),
          centerTitle: true,
          title: Container(
            alignment: Alignment.center,
            child: Text(
              'ผลตรวจพิสูจน์',
              style: GoogleFonts.prompt(
                textStyle: TextStyle(
                  color: Colors.white,
                  letterSpacing: 0,
                  fontSize: MediaQuery.of(context).size.height * 0.025,
                ),
              ),
              maxLines: 1,
              textAlign: TextAlign.center,
            ),
          ),
          backgroundColor: Colors.transparent,
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
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        FirstTabPage(
                            caseID: widget.caseID ?? -1,
                            caseNo: widget.caseNo ?? '',
                            vehicleId: widget.vehicleId ?? -1,
                            vehicleDetail: widget.vehicleDetail ?? ''),
                        SecondTabPage(
                            caseID: widget.caseID ?? -1,
                            caseNo: widget.caseNo ?? '',
                            vehicleId: widget.vehicleId ?? -1,
                            vehicleDetail: widget.vehicleDetail ?? ''),
                        ThirdTabPage(
                            caseID: widget.caseID ?? -1,
                            caseNo: widget.caseNo ?? '',
                            vehicleId: widget.vehicleId ?? -1,
                            vehicleDetail: widget.vehicleDetail ?? ''),
                      ],
                    ),
                  ))));
  }
}
