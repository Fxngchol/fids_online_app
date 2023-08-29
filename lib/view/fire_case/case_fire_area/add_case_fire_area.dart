import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/color.dart';
import '../../../models/case_fire/CaseFireArea.dart';
import '../../../models/case_fire/CaseFireAreaDoa.dart';
import '../../../widget/app_bar_widget.dart';
import '../../../widget/app_button.dart';
import '../../../widget/text_field_widget.dart';

class AddCaseFireArea extends StatefulWidget {
  final int? caseID;
  final String? caseNo;
  final String? caseFireAreaID;
  final bool isEdit, isVehicleType;

  const AddCaseFireArea(
      {super.key,
      this.caseID,
      this.caseNo,
      this.isEdit = false,
      this.caseFireAreaID,
      this.isVehicleType = false});

  @override
  AddCaseFireAreaState createState() => AddCaseFireAreaState();
}

class AddCaseFireAreaState extends State<AddCaseFireArea>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isPhone = Device.get().isPhone;
  bool isLoading = true;
  CaseFireArea? caseFireAreas;
  final _areaDetailCntl = TextEditingController();
  final _front1Cntl = TextEditingController();
  final _left1lCntl = TextEditingController();
  final _right1Cntl = TextEditingController();
  final _back1Cntl = TextEditingController();
  final _floor1lCntl = TextEditingController();
  final _roof1Cntl = TextEditingController();
  final _other1lCntl = TextEditingController();
  final _front2Cntl = TextEditingController();
  final _left2lCntl = TextEditingController();
  final _right2Cntl = TextEditingController();
  final _back2Cntl = TextEditingController();
  final _center2lCntl = TextEditingController();
  final _roof2Cntl = TextEditingController();
  final _other2Cntl = TextEditingController();

  late TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);

    asyncMethod();
  }

  asyncMethod() async {
    isLoading = true;
    if (widget.isEdit) {
      asyncCall1().then((value) => setState(() {
            _areaDetailCntl.text = value?.areaDetail ?? '';
            _front1Cntl.text = value?.front1 ?? '';
            _left1lCntl.text = value?.left1 ?? '';
            _right1Cntl.text = value?.right1 ?? '';
            _back1Cntl.text = value?.back1 ?? '';
            _floor1lCntl.text = _roof1Cntl.text = value?.roof1 ?? '';
            _other1lCntl.text = value?.other1 ?? '';
            _front2Cntl.text = value?.front2 ?? '';
            _left2lCntl.text = value?.left2 ?? '';
            _right2Cntl.text = _back2Cntl.text = value?.back2 ?? '';
            _center2lCntl.text = value?.center2 ?? '';
            _roof2Cntl.text = value?.roof2 ?? '';
            _other2Cntl.text = value?.other2 ?? '';
            isLoading = false;
          }));
    } else {
      setState(() {
        isLoading = false;
      });
    }
    if (kDebugMode) {
      print('caseID: ${widget.caseID}, caseNo: ${widget.caseNo}');
    }
  }

  Future<CaseFireArea?> asyncCall1() async {
    return await CaseFireAreaDao().getCaseFireAreaById(widget.caseFireAreaID);
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
          title: widget.isVehicleType
              ? 'สภาพความเสียหายของโครงสร้างยานพาหนะ'
              : 'สภาพความเสียหายของโครงสร้างอาคาร',
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
                        child: widget.isVehicleType
                            ? SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _header('บริเวณสภาพความเสียหาย'),
                                    InputField(
                                        controller: _areaDetailCntl,
                                        keyboardType: TextInputType.multiline,
                                        textInputAction:
                                            TextInputAction.newline,
                                        hint: 'กรอกบริเวณที่เกิดเหตุ',
                                        maxLine: 2,
                                        onChanged: (value) {}),
                                    _spacer(context),
                                    vehicleView(context),
                                  ],
                                ),
                              )
                            : SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _header('บริเวณที่เกิดเหตุ'),
                                    InputField(
                                        keyboardType: TextInputType.multiline,
                                        textInputAction:
                                            TextInputAction.newline,
                                        controller: _areaDetailCntl,
                                        hint: 'กรอกบริเวณที่เกิดเหตุ',
                                        maxLine: null,
                                        onChanged: (value) {}),
                                    _spacer(context),
                                    tabbarView(context),
                                  ],
                                ),
                              )))));
  }

  // Widget tabbarView(BuildContext context) {
  //   return SingleChildScrollView(
  //     child: Column(
  //       children: <Widget>[
  //         Container(
  //           height: MediaQuery.of(context).size.height,
  //           width: MediaQuery.of(context).size.width,
  //           child: TabBar(
  //             controller: controller,
  //             indicatorSize: TabBarIndicatorSize.tab,
  //             labelColor: Colors.blue,
  //             tabs: [
  //               Tab(
  //                 child: Text(
  //                   'โครงสร้าง',
  //                   textAlign: TextAlign.center,
  //                   style: GoogleFonts.prompt(
  //                     textStyle: TextStyle(
  //                       color: Colors.white,
  //                       fontSize: isPhone
  //                           ? MediaQuery.of(context).size.height * 0.01
  //                           : MediaQuery.of(context).size.height * 0.02,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //               Tab(
  //                 child: Text(
  //                   'สิ่งของ',
  //                   textAlign: TextAlign.center,
  //                   style: GoogleFonts.prompt(
  //                     textStyle: TextStyle(
  //                       color: Colors.white,
  //                       fontSize: isPhone
  //                           ? MediaQuery.of(context).size.height * 0.01
  //                           : MediaQuery.of(context).size.height * 0.02,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         TabBarView(
  //           controller: controller,
  //           children: <Widget>[tabView1(), tabView2()],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget tabbarView(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.transparent, // Tab Bar color change
          child: DefaultTabController(
            length: 2,
            child: TabBar(
              controller: controller,
              indicatorColor: pinkButton,
              indicatorWeight: 10,
              labelColor: const Color(0xffffffff), // สีของข้อความปุ่มที่เลือก
              unselectedLabelColor: const Color(0x55ffffff),
              tabs: <Widget>[
                Tab(
                  child: Text(
                    'โครงสร้าง',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.prompt(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: isPhone
                            ? MediaQuery.of(context).size.height * 0.01
                            : MediaQuery.of(context).size.height * 0.02,
                      ),
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    'สิ่งของ',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.prompt(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: isPhone
                            ? MediaQuery.of(context).size.height * 0.01
                            : MediaQuery.of(context).size.height * 0.02,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.60,
          child: TabBarView(
            controller: controller,
            children: [tabView1(), tabView2()],
          ),
        ),
      ],
    );
  }

  Widget vehicleView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _spacer(context),
        _headerTitle('บริเวณภายนอก'),
        _spacer(context),
        _header('ด้านหน้า'),
        InputField(
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            controller: _front1Cntl,
            hint: 'กรอกรายละเอียดด้านหน้า',
            onChanged: (value) {}),
        _spacer(context),
        _header('ด้านซ้าย'),
        InputField(
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            controller: _left1lCntl,
            hint: 'กรอกรายละเอียดด้านซ้าย',
            onChanged: (value) {}),
        _spacer(context),
        _header('ด้านขวา'),
        InputField(
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            controller: _right1Cntl,
            hint: 'กรอกรายละเอียดด้านขวา',
            onChanged: (value) {}),
        _spacer(context),
        _header('ด้านหลัง'),
        InputField(
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            controller: _back1Cntl,
            hint: 'กรอกรายละเอียดด้านหลัง',
            onChanged: (value) {}),
        _spacer(context),
        _spacer(context),
        _headerTitle('บริเวณภายใน'),
        _header('ด้านหน้า'),
        InputField(
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            controller: _front2Cntl,
            hint: 'กรอกรายละเอียดด้านหน้า',
            onChanged: (value) {}),
        _spacer(context),
        _header('ด้านซ้าย'),
        InputField(
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            controller: _left2lCntl,
            hint: 'กรอกรายละเอียดด้านซ้าย',
            onChanged: (value) {}),
        _spacer(context),
        _header('ด้านขวา'),
        InputField(
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            controller: _right2Cntl,
            hint: 'กรอกรายละเอียดด้านขวา',
            onChanged: (value) {}),
        _spacer(context),
        _header('ด้านหลัง'),
        InputField(
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            controller: _back2Cntl,
            hint: 'กรอกรายละเอียดด้านหลัง',
            onChanged: (value) {}),
        _spacer(context),
        _header('ด้านอื่นๆ'),
        InputField(
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            controller: _other1lCntl,
            hint: 'กรอกรายละเอียดด้านอื่นๆ',
            onChanged: (value) {}),
        saveButton()
      ],
    );
  }

  Widget tabView1() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _spacer(context),
          _header('ชิดฝาผนังด้านหน้า'),
          InputField(
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              controller: _front1Cntl,
              hint: 'กรอกรายละเอียดชิดฝาผนังด้านหน้า',
              onChanged: (value) {}),
          _spacer(context),
          _header('ชิดฝาผนังด้านซ้าย'),
          InputField(
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              controller: _left1lCntl,
              hint: 'กรอกรายละเอียดชิดฝาผนังด้านซ้าย',
              onChanged: (value) {}),
          _spacer(context),
          _header('ชิดฝาผนังด้านขวา'),
          InputField(
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              controller: _right1Cntl,
              hint: 'กรอกรายละเอียดชิดฝาผนังด้านขวา',
              onChanged: (value) {}),
          _spacer(context),
          _header('ชิดฝาผนังด้านหลัง'),
          InputField(
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              controller: _back1Cntl,
              hint: 'กรอกรายละเอียดชิดฝาผนังด้านหลัง',
              onChanged: (value) {}),
          _spacer(context),
          _header('พื้นห้อง'),
          InputField(
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              controller: _floor1lCntl,
              hint: 'กรอกรายละเอียดพื้นห้อง',
              onChanged: (value) {}),
          _spacer(context),
          _header('หลังคา'),
          InputField(
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              controller: _roof1Cntl,
              hint: 'กรอกรายละเอียดหลังคา',
              onChanged: (value) {}),
          _spacer(context),
          _header('บริเวณอื่นๆ'),
          InputField(
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              controller: _other1lCntl,
              hint: 'กรอกรายละเอียดบริเวณอื่นๆ',
              onChanged: (value) {}),
          saveButton()
        ],
      ),
    );
  }

  Widget tabView2() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _spacer(context),
          _header('ชิดฝาผนังด้านหน้า'),
          InputField(
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              controller: _front2Cntl,
              hint: 'กรอกรายละเอียดชิดฝาผนังด้านหน้า',
              onChanged: (value) {}),
          _spacer(context),
          _header('ชิดฝาผนังด้านซ้าย'),
          InputField(
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              controller: _left2lCntl,
              hint: 'กรอกรายละเอียดชิดฝาผนังด้านซ้าย',
              onChanged: (value) {}),
          _spacer(context),
          _header('ชิดฝาผนังด้านขวา'),
          InputField(
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              controller: _right2Cntl,
              hint: 'กรอกรายละเอียดชิดฝาผนังด้านขวา',
              onChanged: (value) {}),
          _spacer(context),
          _header('ชิดฝาผนังด้านหลัง'),
          InputField(
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              controller: _back2Cntl,
              hint: 'กรอกรายละเอียดชิดฝาผนังด้านหลัง',
              onChanged: (value) {}),
          _spacer(context),
          _header('ตอนกลาง'),
          InputField(
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              controller: _center2lCntl,
              hint: 'กรอกรายละเอียดตอนกลาง',
              onChanged: (value) {}),
          _header('หลังคา'),
          InputField(
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              controller: _roof2Cntl,
              hint: 'กรอกรายละเอียดหลังคา',
              onChanged: (value) {}),
          _spacer(context),
          _header('บริเวณอื่นๆ'),
          InputField(
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              controller: _other2Cntl,
              hint: 'กรอกรายละเอียดบริเวณอื่นๆ',
              onChanged: (value) {}),
          saveButton()
        ],
      ),
    );
  }

  Widget _header(String? text) {
    return Column(
      children: [
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
    );
  }

  Widget _headerTitle(String? text) {
    return Column(
      children: [
        Text(
          '$text',
          textAlign: TextAlign.left,
          style: GoogleFonts.prompt(
            textStyle: TextStyle(
              color: Colors.white,
              letterSpacing: .5,
              fontSize: MediaQuery.of(context).size.height * 0.03,
            ),
          ),
        ),
      ],
    );
  }

  Widget _spacer(context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.015,
    );
  }

  Widget saveButton() {
    return Padding(
        padding:
            EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
        child: AppButton(
            color: pinkButton,
            textColor: Colors.white,
            text: 'บันทึก',
            onPressed: () async {
              if (widget.isEdit) {
                CaseFireAreaDao().updateCaseFireArea(
                    int.parse(widget.caseFireAreaID ?? ''),
                    _areaDetailCntl.text,
                    _front1Cntl.text,
                    _left1lCntl.text,
                    _right1Cntl.text,
                    _back1Cntl.text,
                    _floor1lCntl.text,
                    _roof1Cntl.text,
                    _other1lCntl.text,
                    _front2Cntl.text,
                    _left2lCntl.text,
                    _right2Cntl.text,
                    _back2Cntl.text,
                    _center2lCntl.text,
                    _roof2Cntl.text,
                    _other2Cntl.text);
                Navigator.of(context).pop(true);
              } else {
                CaseFireAreaDao().createCaseFireArea(
                    widget.caseID.toString(),
                    _areaDetailCntl.text,
                    _front1Cntl.text,
                    _left1lCntl.text,
                    _right1Cntl.text,
                    _back1Cntl.text,
                    _floor1lCntl.text,
                    _roof1Cntl.text,
                    _other1lCntl.text,
                    _front2Cntl.text,
                    _left2lCntl.text,
                    _right2Cntl.text,
                    _back2Cntl.text,
                    _center2lCntl.text,
                    _roof2Cntl.text,
                    _other2Cntl.text);
                Navigator.of(context).pop(true);
              }
            }));
  }
}
