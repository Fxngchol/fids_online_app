// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/color.dart';
import '../../../models/CaseBomb.dart';
import 'add_tab1_bomb_evident.dart';
import 'add_tab2_bomb_evident.dart';
import 'add_tab3_bomb_evident.dart';
import 'add_tab4_bomb_evident.dart';

class BombEvidentForm extends StatefulWidget {
  final int? caseID;
  final String? caseNo;
  final bool isEdit;
  final CaseBomb? caseBomb;

  const BombEvidentForm(
      {super.key,
      required this.caseID,
      this.caseNo,
      this.isEdit = false,
      this.caseBomb});

  @override
  BombEvidentFormState createState() => BombEvidentFormState();
}

class BombEvidentFormState extends State<BombEvidentForm>
    with SingleTickerProviderStateMixin {
  TabController? controller;

  bool isLoading = true;
  bool isPhone = Device.get().isPhone;

  CaseBomb caseBomb = CaseBomb();

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 4, vsync: this);
    asyncMethod();
  }

  asyncMethod() async {
    asyncCall1();
  }

  void asyncCall1() async {
    setState(() {
      if (widget.isEdit) {
        caseBomb = widget.caseBomb!;
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
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Container(
            alignment: Alignment.center,
            child: Text(
              'วัตถุพยานระเบิดที่ตรวจพบ',
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
          actions: [
            TextButton(
              child: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Text(
                  'บันทึก',
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
              onPressed: () async {
                if (!widget.isEdit) {
                  await CaseBombDao().createCaseBomb(
                      '${widget.caseID}',
                      caseBomb.isBombPackage1,
                      caseBomb.isBombPackage2,
                      caseBomb.isBombPackage3,
                      caseBomb.isBombPackage4,
                      caseBomb.isBombPackage5,
                      caseBomb.isBombPackage6,
                      caseBomb.isBombPackage7,
                      caseBomb.isBombPackage8,
                      caseBomb.bombPackage8Detail,
                      caseBomb.isIgnitionType1,
                      caseBomb.ignitionType1Detail,
                      caseBomb.isIgnitionType2,
                      caseBomb.ignitionType1Color,
                      caseBomb.ignitionType1Length,
                      caseBomb.isIgnitionType3,
                      caseBomb.ignitionType3Brand,
                      caseBomb.ignitionType3Model,
                      caseBomb.ignitionType3Colour,
                      caseBomb.ignitionType3SN,
                      caseBomb.isIgnitionType4,
                      caseBomb.ignitionType4Brand,
                      caseBomb.ignitionType4Model,
                      caseBomb.ignitionType4Colour,
                      caseBomb.ignitionType4SN,
                      caseBomb.isIgnitionType5,
                      caseBomb.ignitionType5Detail,
                      caseBomb.isIgnitionType6,
                      caseBomb.ignitionType6Detail,
                      caseBomb.isIgnitionType7,
                      caseBomb.ignitionType7Detail,
                      caseBomb.isFlakType1,
                      caseBomb.flakType1Size,
                      caseBomb.flakType1Length,
                      caseBomb.isFlakType2,
                      caseBomb.flakType2Size,
                      caseBomb.isFlakType3,
                      caseBomb.flakType3Detail,
                      caseBomb.isMaterial1,
                      caseBomb.material1,
                      caseBomb.isMaterial2,
                      caseBomb.material2,
                      caseBomb.isMaterial3,
                      caseBomb.material3,
                      caseBomb.isMaterial4,
                      caseBomb.material4,
                      caseBomb.isMaterial5,
                      caseBomb.material5,
                      caseBomb.isMaterial6,
                      caseBomb.material6,
                      caseBomb.material6V,
                      caseBomb.isMaterial7,
                      caseBomb.material7,
                      caseBomb.isMaterial8,
                      caseBomb.material8,
                      caseBomb.isMaterial9,
                      caseBomb.material9,
                      caseBomb.isMaterial10,
                      caseBomb.material10,
                      caseBomb.isMaterial11,
                      caseBomb.material11,
                      caseBomb.isMaterial12,
                      caseBomb.material12,
                      caseBomb.isMaterial13,
                      caseBomb.material13,
                      caseBomb.isMaterial14,
                      caseBomb.material14);

                  Navigator.of(context).pop(true);
                } else {
                  await CaseBombDao().updateCaseBomb(
                      widget.caseBomb?.id,
                      '${widget.caseID}',
                      caseBomb.isBombPackage1,
                      caseBomb.isBombPackage2,
                      caseBomb.isBombPackage3,
                      caseBomb.isBombPackage4,
                      caseBomb.isBombPackage5,
                      caseBomb.isBombPackage6,
                      caseBomb.isBombPackage7,
                      caseBomb.isBombPackage8,
                      caseBomb.bombPackage8Detail,
                      caseBomb.isIgnitionType1,
                      caseBomb.ignitionType1Detail,
                      caseBomb.isIgnitionType2,
                      caseBomb.ignitionType1Color,
                      caseBomb.ignitionType1Length,
                      caseBomb.isIgnitionType3,
                      caseBomb.ignitionType3Brand,
                      caseBomb.ignitionType3Model,
                      caseBomb.ignitionType3Colour,
                      caseBomb.ignitionType3SN,
                      caseBomb.isIgnitionType4,
                      caseBomb.ignitionType4Brand,
                      caseBomb.ignitionType4Model,
                      caseBomb.ignitionType4Colour,
                      caseBomb.ignitionType4SN,
                      caseBomb.isIgnitionType5,
                      caseBomb.ignitionType5Detail,
                      caseBomb.isIgnitionType6,
                      caseBomb.ignitionType6Detail,
                      caseBomb.isIgnitionType7,
                      caseBomb.ignitionType7Detail,
                      caseBomb.isFlakType1,
                      caseBomb.flakType1Size,
                      caseBomb.flakType1Length,
                      caseBomb.isFlakType2,
                      caseBomb.flakType2Size,
                      caseBomb.isFlakType3,
                      caseBomb.flakType3Detail,
                      caseBomb.isMaterial1,
                      caseBomb.material1,
                      caseBomb.isMaterial2,
                      caseBomb.material2,
                      caseBomb.isMaterial3,
                      caseBomb.material3,
                      caseBomb.isMaterial4,
                      caseBomb.material4,
                      caseBomb.isMaterial5,
                      caseBomb.material5,
                      caseBomb.isMaterial6,
                      caseBomb.material6,
                      caseBomb.material6V,
                      caseBomb.isMaterial7,
                      caseBomb.material7,
                      caseBomb.isMaterial8,
                      caseBomb.material8,
                      caseBomb.isMaterial9,
                      caseBomb.material9,
                      caseBomb.isMaterial10,
                      caseBomb.material10,
                      caseBomb.isMaterial11,
                      caseBomb.material11,
                      caseBomb.isMaterial12,
                      caseBomb.material12,
                      caseBomb.isMaterial13,
                      caseBomb.material13,
                      caseBomb.isMaterial14,
                      caseBomb.material14);

                  Navigator.of(context).pop(true);
                }
              },
            )
          ],
          bottom: TabBar(
            indicatorColor: pinkButton,
            indicatorWeight: 10,
            labelColor: const Color(0xffffffff), // สีของข้อความปุ่มที่เลือก
            unselectedLabelColor:
                const Color(0x55ffffff), // สีของข้อความปุ่มที่ไม่ได้เลือก
            tabs: <Tab>[
              Tab(
                // icon: Icon(Icons.domain, color: Colors.white),
                child: Text(
                  'บรรจุ',
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
                // icon: Icon(Icons.domain_disabled, color: Colors.white),
                child: Text(
                  'วิธีการจุดระเบิด',
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
                // icon: Icon(Icons.pin_drop, color: Colors.white),
                child: Text(
                  'สะเก็ดระเบิด',
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
                // icon: Icon(Icons.pin_drop, color: Colors.white),
                child: Text(
                  'ส่วนประกอบ',
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
              : const EdgeInsets.only(left: 32, right: 32, top: 32, bottom: 32),
          child: ListView(shrinkWrap: true, children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: tab4headerView(),
            ),
            spacer(context),
            tab1detailView('หลอดดินขยาย', convertBool(caseBomb.isMaterial1)),
            const SizedBox(height: 5),
            convertBool(caseBomb.isMaterial1)
                ? detailView('${_cleanText(caseBomb.material1)}')
                : Container(),
            spacer(context),
            tab1detailView(
                'เชื้อประทุไฟฟ้า', convertBool(caseBomb.isMaterial2)),
            const SizedBox(height: 5),
            convertBool(caseBomb.isMaterial2)
                ? detailView('${_cleanText(caseBomb.material2)}')
                : Container(),
            spacer(context),
            tab1detailView('เทปพันสายไฟ', convertBool(caseBomb.isMaterial3)),
            const SizedBox(height: 5),
            convertBool(caseBomb.isMaterial3)
                ? detailView('${_cleanText(caseBomb.material3)}')
                : Container(),
            spacer(context),
            tab1detailView('ซิมการ์ด', convertBool(caseBomb.isMaterial4)),
            const SizedBox(height: 5),
            convertBool(caseBomb.isMaterial4)
                ? detailView('${_cleanText(caseBomb.material4)}')
                : Container(),
            spacer(context),
            tab1detailView(
                'วงจรการจุดระเบิด', convertBool(caseBomb.isMaterial5)),
            const SizedBox(height: 5),
            convertBool(caseBomb.isMaterial5)
                ? detailView('${_cleanText(caseBomb.material5)}')
                : Container(),
            spacer(context),
            tab1detailView('แบตเตอรี่', convertBool(caseBomb.isMaterial6)),
            const SizedBox(height: 5),
            convertBool(caseBomb.isMaterial5)
                ? detailView(
                    '${_cleanText(caseBomb.material6)} V ${_cleanText(caseBomb.material6V)}')
                : Container(),
            spacer(context),
            tab1detailView('แผงวงจร DTMF', convertBool(caseBomb.isMaterial7)),
            const SizedBox(height: 5),
            convertBool(caseBomb.isMaterial7)
                ? detailView('${_cleanText(caseBomb.material7)}')
                : Container(),
            spacer(context),
            tab1detailView('แผงวงจร', convertBool(caseBomb.isMaterial8)),
            const SizedBox(height: 5),
            convertBool(caseBomb.isMaterial8)
                ? detailView('${_cleanText(caseBomb.material8)}')
                : Container(),
            spacer(context),
            tab1detailView('สายไฟวงจร', convertBool(caseBomb.isMaterial9)),
            const SizedBox(height: 5),
            convertBool(caseBomb.isMaterial9)
                ? detailView('${_cleanText(caseBomb.material9)}')
                : Container(),
            spacer(context),
            tab1detailView(
                'กล่องบรรจุวงจร', convertBool(caseBomb.isMaterial10)),
            const SizedBox(height: 5),
            convertBool(caseBomb.isMaterial10)
                ? detailView('${_cleanText(caseBomb.material10)}')
                : Container(),
            spacer(context),
            tab1detailView('นาฬิกา', convertBool(caseBomb.isMaterial11)),
            const SizedBox(height: 5),
            convertBool(caseBomb.isMaterial11)
                ? detailView('${_cleanText(caseBomb.material11)}')
                : Container(),
            spacer(context),
            tab1detailView('กระเดื่อง', convertBool(caseBomb.isMaterial12)),
            const SizedBox(height: 5),
            convertBool(caseBomb.isMaterial12)
                ? detailView('${_cleanText(caseBomb.material12)}')
                : Container(),
            spacer(context),
            tab1detailView('สลักนิรภัย', convertBool(caseBomb.isMaterial13)),
            const SizedBox(height: 5),
            convertBool(caseBomb.isMaterial13)
                ? detailView('${_cleanText(caseBomb.material13)}')
                : Container(),
            spacer(context),
            tab1detailView('อื่นๆ', convertBool(caseBomb.isMaterial14)),
            const SizedBox(height: 5),
            convertBool(caseBomb.isMaterial14)
                ? detailView('${_cleanText(caseBomb.material14)}')
                : Container(),
          ]),
        ),
      ),
    );
  }

  Widget tab4headerView() {
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
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.transparent),
            ),
            onPressed: () async {
              // Navigator.pushNamed(context, '/editdetail');

              var result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddTab4BombEvident(
                          caseBomb: caseBomb,
                          caseID: widget.caseID ?? -1,
                          caseNo: widget.caseNo,
                          isEdit: widget.isEdit)));
              if (result != null) {
                setState(() {
                  caseBomb = result;
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

/////////////////////////////////////////////
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
              : const EdgeInsets.only(left: 32, right: 32, top: 32, bottom: 32),
          child: ListView(shrinkWrap: true, children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: tab3headerView(),
            ),
            spacer(context),
            tab1detailView(
                'เหล็กเส้นตัดท่อน', convertBool(caseBomb.isFlakType1)),
            const SizedBox(height: 5),
            convertBool(caseBomb.isFlakType1)
                ? detailView('${_cleanText(caseBomb.flakType1Size)} หุน')
                : Container(),
            const SizedBox(height: 5),
            convertBool(caseBomb.isFlakType1)
                ? detailView('ยาว ${_cleanText(caseBomb.flakType1Size)} ซม.')
                : Container(),
            spacer(context),
            tab1detailView('ตะปู', convertBool(caseBomb.isFlakType2)),
            const SizedBox(height: 5),
            convertBool(caseBomb.isFlakType2)
                ? detailView('${_cleanText(caseBomb.flakType2Size)} นิ้ว')
                : Container(),
            spacer(context),
            tab1detailView('อื่นๆ', convertBool(caseBomb.isFlakType3)),
            const SizedBox(height: 5),
            convertBool(caseBomb.isFlakType3)
                ? detailView('${_cleanText(caseBomb.flakType3Detail)}')
                : Container(),
          ]),
        ),
      ),
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
            fontSize: MediaQuery.of(context).size.height * 0.03,
          ),
        ),
      ),
    );
  }

  Widget tab3headerView() {
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
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.transparent),
            ),
            onPressed: () async {
              // Navigator.pushNamed(context, '/editdetail');

              var result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddTab3BombEvident(
                          caseBomb: caseBomb,
                          caseID: widget.caseID ?? -1,
                          caseNo: widget.caseNo,
                          isEdit: widget.isEdit)));
              if (result != null) {
                setState(() {
                  caseBomb = result;
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

  ///////////////////////////////////////////////////////////

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
              : const EdgeInsets.only(left: 32, right: 32, top: 32, bottom: 32),
          child: ListView(shrinkWrap: true, children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: tab2headerView(),
            ),
            spacer(context),
            tab1detailView(
                'กับดัก/เหยียบ/สะดุด', convertBool(caseBomb.isIgnitionType1)),
            const SizedBox(height: 5),
            convertBool(caseBomb.isIgnitionType1)
                ? detailView('${_cleanText(caseBomb.ignitionType1Detail)}')
                : Container(),
            spacer(context),
            tab1detailView('ลากสายไฟ', convertBool(caseBomb.isIgnitionType2)),
            const SizedBox(height: 5),
            convertBool(caseBomb.isIgnitionType2)
                ? detailView('สี : ${_cleanText(caseBomb.ignitionType1Color)}')
                : Container(),
            const SizedBox(height: 5),
            convertBool(caseBomb.isIgnitionType2)
                ? detailView(
                    'ยาว : ${_cleanText(caseBomb.ignitionType1Length)}')
                : Container(),
            spacer(context),
            tab1detailView(
                'วิทยุสื่อสาร', convertBool(caseBomb.isIgnitionType3)),
            const SizedBox(height: 5),
            convertBool(caseBomb.isIgnitionType3)
                ? detailView(
                    'ยี่ห้อ : ${_cleanText(caseBomb.ignitionType3Brand)}')
                : Container(),
            const SizedBox(height: 5),
            convertBool(caseBomb.isIgnitionType3)
                ? detailView(
                    'รุ่น : ${_cleanText(caseBomb.ignitionType3Model)}')
                : Container(),
            const SizedBox(height: 5),
            convertBool(caseBomb.isIgnitionType3)
                ? detailView('สี : ${_cleanText(caseBomb.ignitionType3Colour)}')
                : Container(),
            const SizedBox(height: 5),
            convertBool(caseBomb.isIgnitionType3)
                ? detailView('S/N : ${_cleanText(caseBomb.ignitionType3SN)}')
                : Container(),
            spacer(context),
            tab1detailView(
                'โทรศัพท์มือถือ', convertBool(caseBomb.isIgnitionType4)),
            const SizedBox(height: 5),
            convertBool(caseBomb.isIgnitionType4)
                ? detailView(
                    'ยี่ห้อ : ${_cleanText(caseBomb.ignitionType4Brand)}')
                : Container(),
            const SizedBox(height: 5),
            convertBool(caseBomb.isIgnitionType4)
                ? detailView(
                    'รุ่น : ${_cleanText(caseBomb.ignitionType4Model)}')
                : Container(),
            const SizedBox(height: 5),
            convertBool(caseBomb.isIgnitionType4)
                ? detailView('สี : ${_cleanText(caseBomb.ignitionType4Colour)}')
                : Container(),
            const SizedBox(height: 5),
            convertBool(caseBomb.isIgnitionType4)
                ? detailView('S/N : ${_cleanText(caseBomb.ignitionType4SN)}')
                : Container(),
            spacer(context),
            tab1detailView(
                'รีโมทคอนโทรล', convertBool(caseBomb.isIgnitionType5)),
            const SizedBox(height: 5),
            convertBool(caseBomb.isIgnitionType5)
                ? detailView('${_cleanText(caseBomb.ignitionType5Detail)}')
                : Container(),
            spacer(context),
            tab1detailView('ตั้งเวลา', convertBool(caseBomb.isIgnitionType6)),
            const SizedBox(height: 5),
            convertBool(caseBomb.isIgnitionType6)
                ? detailView('${_cleanText(caseBomb.ignitionType6Detail)}')
                : Container(),
            spacer(context),
            tab1detailView('อื่นๆ', convertBool(caseBomb.isIgnitionType7)),
            const SizedBox(height: 5),
            convertBool(caseBomb.isIgnitionType7)
                ? detailView('${_cleanText(caseBomb.ignitionType7Detail)}')
                : Container(),
            spacer(context),
          ]),
        ),
      ),
    );
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

  Widget tab2headerView() {
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
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.transparent),
            ),
            onPressed: () async {
              // Navigator.pushNamed(context, '/editdetail');

              var result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddTab2BombEvident(
                          caseBomb: caseBomb,
                          caseID: widget.caseID ?? -1,
                          caseNo: widget.caseNo,
                          isEdit: widget.isEdit)));
              if (result != null) {
                setState(() {
                  caseBomb = result;
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

  /////////////////////////////////////////

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
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: tab1headerView(),
            ),
            spacer(context),
            tab1detailView('กล่องเหล็ก', convertBool(caseBomb.isBombPackage1)),
            spacer(context),
            tab1detailView('ถังแก๊ส', convertBool(caseBomb.isBombPackage2)),
            spacer(context),
            tab1detailView('ถังดับเพลิง', convertBool(caseBomb.isBombPackage3)),
            spacer(context),
            tab1detailView('ท่อเหล็ก', convertBool(caseBomb.isBombPackage4)),
            spacer(context),
            tab1detailView('ท่อ PVC', convertBool(caseBomb.isBombPackage5)),
            spacer(context),
            tab1detailView(
                'ถังน้ำยาแอร์', convertBool(caseBomb.isBombPackage6)),
            spacer(context),
            tab1detailView(
                'ระเบิดมาตรฐาน', convertBool(caseBomb.isBombPackage7)),
            spacer(context),
            tab1detailView('อื่นๆ', convertBool(caseBomb.isBombPackage8)),
            const SizedBox(height: 5),
            convertBool(caseBomb.isBombPackage8)
                ? detailView('${caseBomb.bombPackage8Detail}')
                : Container(),
          ]),
        ),
      ),
    );
  }

  bool convertBool(String? text) {
    try {
      if (text == '1') {
        return true;
      }
      return false;
    } catch (ex) {
      return false;
    }
  }

  Widget spacer(context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.015,
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
        TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.transparent),
            ),
            onPressed: () async {
              // Navigator.pushNamed(context, '/editdetail');

              var result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddTab1BombEvident(
                          caseBomb: caseBomb,
                          caseID: widget.caseID ?? -1,
                          caseNo: widget.caseNo,
                          isEdit: widget.isEdit)));
              if (result != null) {
                setState(() {
                  caseBomb = result;
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
    return Container(
      decoration: BoxDecoration(
          color: whiteOpacity, borderRadius: BorderRadius.circular(8)),
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: isPhone
            ? const EdgeInsets.only(left: 24, right: 24, top: 10, bottom: 10)
            : const EdgeInsets.only(left: 32, right: 32, top: 20, bottom: 20),
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
                          color: textColor,
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

  Widget detailView(String? text) {
    return Container(
      decoration: BoxDecoration(
          color: whiteOpacity, borderRadius: BorderRadius.circular(8)),
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: isPhone
            ? const EdgeInsets.only(left: 24, right: 24, top: 10, bottom: 10)
            : const EdgeInsets.only(left: 32, right: 32, top: 20, bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
