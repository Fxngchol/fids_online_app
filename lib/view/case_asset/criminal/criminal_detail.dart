import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/color.dart';
import '../../../models/CaseCategory.dart';
import '../../../models/FidsCrimeScene.dart';
import '../../../widget/app_bar_widget.dart';
import 'edit_crimimal_datail.dart';

class CriminalDetail extends StatefulWidget {
  final int? caseID;
  final String? caseNo;
  final bool isLocal;

  const CriminalDetail(
      {super.key, this.caseID, this.caseNo, this.isLocal = false});
  @override
  CriminalDetailState createState() => CriminalDetailState();
}

class CriminalDetailState extends State<CriminalDetail> {
  bool isLoading = true;
  bool isPhone = Device.get().isPhone;
  int isWeaponValue = 0;
  bool isWeaponType1 = false,
      isWeaponType2 = false,
      isWeaponType3 = false,
      isWeaponType4 = false,
      isImpressionInRoom = false,
      isImpression = false;
  String? caseName;
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
    var result =
        await FidsCrimeSceneDao().getFidsCrimeSceneById(widget.caseID ?? -1);
    fidsCrimescene = result;
    await CaseCategoryDAO()
        .getCaseCategoryLabelByid(fidsCrimescene?.caseCategoryID ?? -1)
        .then((value) => caseName = value);
    setState(() {
      isWeaponValue = fidsCrimescene?.isoIsWeapon == '1'
          ? 1
          : fidsCrimescene?.isoIsWeapon == '2'
              ? 2
              : 0;
      isWeaponType1 = fidsCrimescene?.isoIsWeaponType1 == '1' ? true : false;
      isWeaponType2 = fidsCrimescene?.isoIsWeaponType2 == '1' ? true : false;
      isWeaponType3 = fidsCrimescene?.isoIsWeaponType3 == '1' ? true : false;
      isWeaponType4 = fidsCrimescene?.isoIsWeaponType4 == '1' ? true : false;
      isImpressionInRoom =
          fidsCrimescene?.isoIsImprisonInRoom == '1' ? true : false;
      isImpression = fidsCrimescene?.isoIsImprison == '1' ? true : false;
      isLoading = false;
    });
    if (kDebugMode) {
      print('isoIsWeapon :${fidsCrimescene?.isoIsWeapon} ');
      print('isoIsWeaponType1 :${fidsCrimescene?.isoIsWeaponType1} ');
      print('isoIsWeaponType2 :${fidsCrimescene?.isoIsWeaponType2} ');
      print('isoIsWeaponType3 :${fidsCrimescene?.isoIsWeaponType3} ');
      print('isoIsWeaponType4 :${fidsCrimescene?.isoIsWeaponType4} ');
      print('isoIsImprison :${fidsCrimescene?.isoIsImprison} ');
      print('isoImprison :${fidsCrimescene?.isoImprison} ');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBarWidget(
        title: 'ข้อมูลคนร้าย',
        actions: [
          TextButton(
            onPressed: () async {
              var result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          EditCriminalDetail(caseID: widget.caseID ?? -1)));
              if (result) {
                asyncCall1();
                if (kDebugMode) {
                  print(result);
                }
              }
            },
            child: Icon(Icons.edit,
                color: Colors.white,
                size: MediaQuery.of(context).size.height * 0.025),
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
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              margin: isPhone
                  ? const EdgeInsets.all(32)
                  : const EdgeInsets.only(
                      left: 32, right: 32, top: 32, bottom: 32),
              child: SingleChildScrollView(
                child: Column(children: [
                  headerView(),
                  spacer(),
                  title('จำนวนคนร้าย/คน'),
                  spacer(),
                  detailView(_cleanText(fidsCrimescene?.criminalAmount ?? '')),
                  spacer(),
                  weaponView(),
                  spacer(),
                  weaponCheckboxView(),
                  spacer(),
                  Padding(
                    padding: const EdgeInsets.only(left: 36),
                    child: detailView(
                        _cleanText(fidsCrimescene?.isoWeaponType4Detail ?? '')),
                  ),
                  spacer(),
                  title('คนร้ายได้พันธนาการผู้เสียหายอย่างไร'),
                  spacer(),
                  imprisonCheckboxView(),
                  spacer(),
                  Padding(
                    padding: const EdgeInsets.only(left: 36),
                    child: detailView(_cleanText(fidsCrimescene?.isoImprison)),
                  ),
                  spacer(),
                  Padding(
                    padding: const EdgeInsets.only(left: 36),
                    child: title('ในการพันธนาการ'),
                  ),
                  spacer(),
                  Padding(
                    padding: const EdgeInsets.only(left: 36),
                    child: detailView(
                        _cleanText(fidsCrimescene?.isoImprisonDetail)),
                  ),
                  spacer(),
                ]),
              )),
        ),
      ),
    );
  }

  imprisonCheckboxView() {
    return Padding(
      padding: const EdgeInsets.only(left: 36),
      child: Column(
        children: [
          checkbox('กักขังภายในห้อง', isImpressionInRoom, (_) {}),
          spacer(),
          checkbox('คนร้ายใช้', isImpression, (_) {}),
        ],
      ),
    );
  }

  weaponCheckboxView() {
    return Padding(
      padding: const EdgeInsets.only(left: 36),
      child: Column(
        children: [
          checkbox('อาวุธมีด', isWeaponType1, (_) {}),
          spacer(),
          checkbox('อาวุธปืน', isWeaponType2, (_) {}),
          spacer(),
          checkbox('เชือก', isWeaponType3, (_) {}),
          spacer(),
          checkbox('อื่นๆ', isWeaponType4, (_) {}),
        ],
      ),
    );
  }

  weaponView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Transform.scale(
              scale: 1.2,
              child: Radio(
                value: 2,
                activeColor: pinkButton,
                groupValue: isWeaponValue,
                onChanged: (_) {},
              ),
            ),
            Text(
              'คนร้ายไม่ใช้อาวุธในการก่อเหตุ',
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
        ),
        spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Transform.scale(
              scale: 1.2,
              child: Radio(
                value: 1,
                activeColor: pinkButton,
                groupValue: isWeaponValue,
                onChanged: (_) {},
              ),
            ),
            Text(
              'อาวุธที่คนร้ายใช้ในการก่อเหตุ',
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
        ),
      ],
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

  checkbox(String? text, bool isChecked, Function onChanged) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Transform.scale(
        scale: 1.7,
        child: Checkbox(
            value: isChecked,
            checkColor: Colors.white,
            activeColor: pinkButton,
            onChanged: (str) {
              onChanged(str);
            }),
      ),
      SizedBox(width: MediaQuery.of(context).size.width * 0.02),
      Flexible(
        child: Text(
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
      ),
    ]);
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
            Expanded(
              child: Column(
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
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ],
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
}
