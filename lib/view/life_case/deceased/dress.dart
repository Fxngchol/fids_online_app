import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/color.dart';
import '../../../models/CaseBody.dart';
import '../../../widget/app_bar_widget.dart';
import '../../../widget/app_button.dart';
import '../../../widget/text_field_widget.dart';

class Dress extends StatefulWidget {
  final int? caseID;
  final String? caseNo;
  final CaseBody? caseBody;
  final bool isEdit;

  const Dress(
      {super.key,
      this.caseID,
      this.caseNo,
      this.caseBody,
      this.isEdit = false});

  @override
  DressState createState() => DressState();
}

class DressState extends State<Dress> {
  bool isPhone = Device.get().isPhone;

  int _isClothingValue = -1,
      _isPantsValue = -1,
      _isShoesValue = -1,
      _isBeltValue = -1,
      _isTattooValue = -1;

  TextEditingController clothingDetail = TextEditingController();
  TextEditingController pantsDetail = TextEditingController();
  TextEditingController shoesDetail = TextEditingController();
  TextEditingController beltDetail = TextEditingController();
  TextEditingController tattooDetail = TextEditingController();
  TextEditingController dressOtherDetail = TextEditingController();

  @override
  void initState() {
    super.initState();
    setupData();
  }

  setupData() {
    if (widget.caseBody?.clothingDetail == null) {
      clothingDetail.text = '';
    } else {
      clothingDetail.text = widget.caseBody?.clothingDetail ?? '';
    }

    if (widget.caseBody?.pantsDetail == null) {
      pantsDetail.text = '';
    } else {
      pantsDetail.text = widget.caseBody?.pantsDetail ?? '';
    }

    if (widget.caseBody?.shoesDetail == null) {
      shoesDetail.text = '';
    } else {
      shoesDetail.text = widget.caseBody?.shoesDetail ?? '';
    }

    if (widget.caseBody?.beltDetail == null) {
      beltDetail.text = '';
    } else {
      beltDetail.text = widget.caseBody?.beltDetail ?? '';
    }

    if (widget.caseBody?.tattooDetail == null) {
      tattooDetail.text = '';
    } else {
      tattooDetail.text = widget.caseBody?.tattooDetail ?? '';
    }

    if (widget.caseBody?.dressOther == null) {
      dressOtherDetail.text = '';
    } else {
      dressOtherDetail.text = widget.caseBody?.dressOther ?? '';
    }

    setState(() {
      if (widget.caseBody?.isClothing == null ||
          widget.caseBody?.isClothing == '') {
        _isClothingValue = -1;
      } else {
        if (widget.caseBody?.isClothing == '1') {
          _isClothingValue = 1;
        } else if (widget.caseBody?.isClothing == '2') {
          _isClothingValue = 2;
        } else {
          _isClothingValue = -1;
        }
      }

      if (widget.caseBody?.isPants == null || widget.caseBody?.isPants == '') {
        _isPantsValue = -1;
      } else {
        if (widget.caseBody?.isPants == '1') {
          _isPantsValue = 1;
        } else if (widget.caseBody?.isPants == '2') {
          _isPantsValue = 2;
        } else {
          _isPantsValue = -1;
        }
      }

      if (widget.caseBody?.isShoes == null || widget.caseBody?.isShoes == '') {
        _isShoesValue = -1;
      } else {
        if (widget.caseBody?.isShoes == '1') {
          _isShoesValue = 1;
        } else if (widget.caseBody?.isShoes == '2') {
          _isShoesValue = 2;
        } else {
          _isShoesValue = -1;
        }
      }

      if (widget.caseBody?.isBelt == null || widget.caseBody?.isBelt == '') {
        _isBeltValue = -1;
      } else {
        if (widget.caseBody?.isBelt == '1') {
          _isBeltValue = 1;
        } else if (widget.caseBody?.isBelt == '2') {
          _isBeltValue = 2;
        } else {
          _isBeltValue = -1;
        }
      }

      if (widget.caseBody?.isTattoo == null ||
          widget.caseBody?.isTattoo == '') {
        _isTattooValue = -1;
      } else {
        if (widget.caseBody?.isTattoo == '1') {
          _isTattooValue = 1;
        } else if (widget.caseBody?.isTattoo == '2') {
          _isTattooValue = 2;
        } else {
          _isTattooValue = -1;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBarWidget(
          title: 'การเเต่งกายเเละทรัพย์สิน',
          actions: [
            Container(
              width: MediaQuery.of(context).size.width * 0.1,
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
            child: SafeArea(
                child: Container(
                    margin: isPhone
                        ? const EdgeInsets.all(32)
                        : const EdgeInsets.all(48),
                    child: ListView(children: [
                      spacer(context),
                      radioView('เสื้อ', _isClothingValue, (value) {
                        setState(() {
                          _isClothingValue = value;
                        });
                      }),
                      InputField(
                          controller: clothingDetail,
                          hint: 'รายละเอียด',
                          maxLine: null,
                          onChanged: (_) {}),
                      spacer(context),
                      radioView('กางเกง', _isPantsValue, (value) {
                        setState(() {
                          _isPantsValue = value;
                        });
                      }),
                      InputField(
                          controller: pantsDetail,
                          hint: 'รายละเอียด',
                          maxLine: null,
                          onChanged: (_) {}),
                      spacer(context),
                      radioView('รองเท้า / ถุงเท้า', _isShoesValue, (value) {
                        setState(() {
                          _isShoesValue = value;
                        });
                      }),
                      InputField(
                          controller: shoesDetail,
                          hint: 'รายละเอียด',
                          maxLine: null,
                          onChanged: (_) {}),
                      spacer(context),
                      radioView('เข็มขัด', _isBeltValue, (value) {
                        setState(() {
                          _isBeltValue = value;
                          if (kDebugMode) {
                            print(value);
                          }
                        });
                      }),
                      InputField(
                          controller: beltDetail,
                          hint: 'รายละเอียด',
                          maxLine: null,
                          onChanged: (_) {}),
                      spacer(context),
                      radioView('รอยสักหรือรอยแผลเป็น', _isTattooValue,
                          (value) {
                        setState(() {
                          _isTattooValue = value;
                        });
                      }),
                      InputField(
                          controller: tattooDetail,
                          hint: 'รายละเอียด',
                          maxLine: null,
                          onChanged: (_) {}),
                      spacer(context),
                      spacer(context),
                      header('อื่นๆ'),
                      spacer(context),
                      InputField(
                          controller: dressOtherDetail,
                          hint: 'รายละเอียด',
                          maxLine: null,
                          onChanged: (_) {}),
                      spacer(context),
                      spacer(context),
                      saveButton(),
                      spacer(context),
                      spacer(context),
                    ])))));
  }

  Widget header(String? text) {
    return Text(
      '$text',
      textAlign: TextAlign.left,
      style: GoogleFonts.prompt(
        textStyle: TextStyle(
          color: Colors.white,
          letterSpacing: .5,
          fontSize: MediaQuery.of(context).size.height * 0.025,
        ),
      ),
    );
  }

  Widget spacer(context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.015,
    );
  }

  Widget radioView(String? title, int groupValue, Function(int i) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            title ?? '',
            textAlign: TextAlign.center,
            style: GoogleFonts.prompt(
              textStyle: TextStyle(
                color: Colors.white,
                letterSpacing: .5,
                fontSize: MediaQuery.of(context).size.height * 0.03,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Radio(
                      activeColor: pinkButton,
                      value: 1,
                      groupValue: groupValue,
                      onChanged: (val) {
                        onChanged(val ?? -1);
                      }),
                  Text(
                    'พบ',
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
              Row(
                children: [
                  Radio(
                      activeColor: pinkButton,
                      value: 2,
                      groupValue: groupValue,
                      onChanged: (val) {
                        onChanged(val ?? -1);
                      }),
                  Text(
                    'ไม่พบ',
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
          ),
        ],
      ),
    );
  }

  Widget saveButton() {
    return AppButton(
        color: pinkButton,
        textColor: Colors.white,
        text: 'บันทึก',
        onPressed: () {
          // Navigator.of(context).pop();
          if (kDebugMode) {
            print('เสื้อ $_isClothingValue');
            print('รายละเอียด ${clothingDetail.text}');
            print('กางเกง $_isPantsValue');
            print('รายละเอียด ${pantsDetail.text}');
            print('ถุงเท้า $_isShoesValue');
            print('รายละเอียด ${beltDetail.text}');
            print('รอยสัก $_isTattooValue');
            print('รายละเอียด ${tattooDetail.text}');
            print('อื่นๆ ${dressOtherDetail.text}');
          }

          widget.caseBody?.isClothing = '$_isClothingValue';
          widget.caseBody?.clothingDetail = clothingDetail.text;
          widget.caseBody?.isPants = '$_isPantsValue';
          widget.caseBody?.pantsDetail = pantsDetail.text;
          widget.caseBody?.isShoes = '$_isShoesValue';
          widget.caseBody?.shoesDetail = shoesDetail.text;
          widget.caseBody?.isBelt = '$_isBeltValue';
          widget.caseBody?.beltDetail = beltDetail.text;
          widget.caseBody?.isTattoo = '$_isTattooValue';
          widget.caseBody?.tattooDetail = tattooDetail.text;
          widget.caseBody?.dressOther = dressOtherDetail.text;

          if (kDebugMode) {
            print(widget.caseBody?.toString());
          }
          Navigator.of(context).pop(widget.caseBody ?? '');
        });
  }
}
