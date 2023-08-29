import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/color.dart';
import '../../../models/CaseBomb.dart';
import '../../../widget/app_bar_widget.dart';
import '../../../widget/app_button.dart';
import '../../../widget/text_field_widget.dart';

class AddTab2BombEvident extends StatefulWidget {
  final int? caseID;
  final String? caseNo;
  final bool isEdit;
  final CaseBomb? caseBomb;

  const AddTab2BombEvident(
      {super.key,
      required this.caseID,
      this.caseNo,
      this.isEdit = false,
      this.caseBomb});

  @override
  // ignore: library_private_types_in_public_api
  _AddTab2BombEvidentState createState() => _AddTab2BombEvidentState();
}

class _AddTab2BombEvidentState extends State<AddTab2BombEvident> {
  bool isPhone = Device.get().isPhone;

  bool isIgnitionType1 = false;
  String? textIsIgnitionType1;
  String? ignitionType1Detail;
  TextEditingController ignitionType1DetailController = TextEditingController();

  bool isIgnitionType2 = false;
  String? textIsIgnitionType2;
  String? ignitionType1Color;
  TextEditingController ignitionType1ColorController = TextEditingController();
  String? ignitionType1Length;
  TextEditingController ignitionType1LengthController = TextEditingController();

  bool isIgnitionType3 = false;
  String? textIsIgnitionType3;
  String? ignitionType3Brand;
  TextEditingController ignitionType3BrandController = TextEditingController();
  String? ignitionType3Model;
  TextEditingController ignitionType3ModelController = TextEditingController();
  String? ignitionType3Colour;
  TextEditingController ignitionType3ColourController = TextEditingController();
  String? ignitionType3SN;
  TextEditingController ignitionType3SNController = TextEditingController();

  bool isIgnitionType4 = false;
  String? textIsIgnitionType4;
  String? ignitionType4Brand;
  TextEditingController ignitionType4BrandController = TextEditingController();
  String? ignitionType4Model;
  TextEditingController ignitionType4ModelController = TextEditingController();
  String? ignitionType4Colour;
  TextEditingController ignitionType4ColourController = TextEditingController();
  String? ignitionType4SN;
  TextEditingController ignitionType4SNController = TextEditingController();

  bool isIgnitionType5 = false;
  String? textIsIgnitionType5;
  String? ignitionType5Detail;
  TextEditingController ignitionType5DetailController = TextEditingController();

  bool isIgnitionType6 = false;
  String? textIsIgnitionType6;
  String? ignitionType6Detail;
  TextEditingController ignitionType6DetailController = TextEditingController();

  bool isIgnitionType7 = false;
  String? textIsIgnitionType7;
  String? ignitionType7Detail;
  TextEditingController ignitionType7DetailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setUpData();
  }

  setUpData() {
    textIsIgnitionType1 = widget.caseBomb?.isIgnitionType1 ?? '';
    if (textIsIgnitionType1 == '1') {
      isIgnitionType1 = true;
    }
    ignitionType1DetailController.text =
        widget.caseBomb?.ignitionType1Detail ?? '';

    textIsIgnitionType2 = widget.caseBomb?.isIgnitionType2 ?? '';
    if (textIsIgnitionType2 == '1') {
      isIgnitionType2 = true;
    }
    ignitionType1ColorController.text =
        widget.caseBomb?.ignitionType1Color ?? '';
    ignitionType1LengthController.text =
        widget.caseBomb?.ignitionType1Length ?? '';

    textIsIgnitionType3 = widget.caseBomb?.isIgnitionType3 ?? '';
    if (textIsIgnitionType3 == '1') {
      isIgnitionType3 = true;
    }
    ignitionType3BrandController.text =
        widget.caseBomb?.ignitionType3Brand ?? '';
    ignitionType3ModelController.text =
        widget.caseBomb?.ignitionType3Model ?? '';
    ignitionType3ColourController.text =
        widget.caseBomb?.ignitionType3Colour ?? '';
    ignitionType3SNController.text = widget.caseBomb?.ignitionType3SN ?? '';

    textIsIgnitionType4 = widget.caseBomb?.isIgnitionType4 ?? '';
    if (textIsIgnitionType4 == '1') {
      isIgnitionType4 = true;
    }
    ignitionType4BrandController.text =
        widget.caseBomb?.ignitionType4Brand ?? '';
    ignitionType4ModelController.text =
        widget.caseBomb?.ignitionType4Model ?? '';
    ignitionType4ColourController.text =
        widget.caseBomb?.ignitionType4Colour ?? '';
    ignitionType4SNController.text = widget.caseBomb?.ignitionType4SN ?? '';

    textIsIgnitionType5 = widget.caseBomb?.isIgnitionType5 ?? '';
    if (textIsIgnitionType5 == '1') {
      isIgnitionType5 = true;
    }
    ignitionType5DetailController.text =
        widget.caseBomb?.ignitionType5Detail ?? '';

    textIsIgnitionType6 = widget.caseBomb?.isIgnitionType6 ?? '';
    if (textIsIgnitionType6 == '1') {
      isIgnitionType6 = true;
    }
    ignitionType6DetailController.text =
        widget.caseBomb?.ignitionType6Detail ?? '';

    textIsIgnitionType7 = widget.caseBomb?.isIgnitionType7 ?? '';
    if (textIsIgnitionType7 == '1') {
      isIgnitionType7 = true;
    }
    ignitionType7DetailController.text =
        widget.caseBomb?.ignitionType7Detail ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBarWidget(
          title: 'วิธีการจุดระเบิด',
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
                  : const EdgeInsets.only(
                      left: 32, right: 32, top: 32, bottom: 32),
              child: ListView(
                children: [
                  tabIsIgnitionType1('กับดัก/เหยียบ/สะดุด'),
                  const SizedBox(height: 5),
                  isIgnitionType1
                      ? textField(
                          ignitionType1DetailController, 'กรอกรายละเอียด')
                      : Container(),
                  spacer(context),
                  tabIsIgnitionType2('ลากสายไฟ'),
                  const SizedBox(height: 5),
                  isIgnitionType2
                      ? textField(ignitionType1ColorController, 'กรอกสี')
                      : Container(),
                  const SizedBox(height: 5),
                  isIgnitionType2
                      ? textField(ignitionType1LengthController, 'กรอกความยาว')
                      : Container(),
                  spacer(context),
                  tabIsIgnitionType3('วิทยุสื่อสาร'),
                  const SizedBox(height: 5),
                  isIgnitionType3
                      ? textField(ignitionType3BrandController, 'กรอกยี่ห้อ')
                      : Container(),
                  const SizedBox(height: 5),
                  isIgnitionType3
                      ? textField(ignitionType3ModelController, 'กรอกรุ่น')
                      : Container(),
                  const SizedBox(height: 5),
                  isIgnitionType3
                      ? textField(ignitionType3ColourController, 'กรอกสี')
                      : Container(),
                  const SizedBox(height: 5),
                  isIgnitionType3
                      ? textField(ignitionType3SNController, 'S/N')
                      : Container(),
                  spacer(context),
                  tabIsIgnitionType4('โทรศัพท์มือถือ'),
                  const SizedBox(height: 5),
                  isIgnitionType4
                      ? textField(ignitionType4BrandController, 'กรอกยี่ห้อ')
                      : Container(),
                  const SizedBox(height: 5),
                  isIgnitionType4
                      ? textField(ignitionType4ModelController, 'กรอกรุ่น')
                      : Container(),
                  const SizedBox(height: 5),
                  isIgnitionType4
                      ? textField(ignitionType4ColourController, 'กรอกสี')
                      : Container(),
                  const SizedBox(height: 5),
                  isIgnitionType4
                      ? textField(ignitionType4SNController, 'S/N')
                      : Container(),
                  spacer(context),
                  tabIsIgnitionType5('รีโมทคอนโทรล'),
                  const SizedBox(height: 5),
                  isIgnitionType5
                      ? textField(
                          ignitionType5DetailController, 'กรอกรายละเอียด')
                      : Container(),
                  spacer(context),
                  tabIsIgnitionType6('ตั้งเวลา'),
                  const SizedBox(height: 5),
                  isIgnitionType6
                      ? textField(
                          ignitionType6DetailController, 'กรอกรายละเอียด')
                      : Container(),
                  spacer(context),
                  tabIsIgnitionType7('อื่นๆ'),
                  const SizedBox(height: 5),
                  isIgnitionType7
                      ? textField(
                          ignitionType7DetailController, 'กรอกรายละเอียด')
                      : Container(),
                  spacer(context),
                  spacer(context),
                  saveButton(),
                ],
              ),
            ),
          ),
        ));
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
              widget.caseBomb?.isIgnitionType1 = textIsIgnitionType1;
              widget.caseBomb?.ignitionType1Detail =
                  ignitionType1DetailController.text;

              widget.caseBomb?.isIgnitionType2 = textIsIgnitionType2;
              widget.caseBomb?.ignitionType1Color =
                  ignitionType1ColorController.text;
              widget.caseBomb?.ignitionType1Length =
                  ignitionType1LengthController.text;

              widget.caseBomb?.isIgnitionType3 = textIsIgnitionType3;
              widget.caseBomb?.ignitionType3Brand =
                  ignitionType3BrandController.text;
              widget.caseBomb?.ignitionType3Model =
                  ignitionType3ModelController.text;
              widget.caseBomb?.ignitionType3Colour =
                  ignitionType3ColourController.text;
              widget.caseBomb?.ignitionType3SN = ignitionType3SNController.text;

              widget.caseBomb?.isIgnitionType4 = textIsIgnitionType4;
              widget.caseBomb?.ignitionType4Brand =
                  ignitionType4BrandController.text;
              widget.caseBomb?.ignitionType4Model =
                  ignitionType4ModelController.text;
              widget.caseBomb?.ignitionType4Colour =
                  ignitionType4ColourController.text;
              widget.caseBomb?.ignitionType4SN = ignitionType4SNController.text;

              widget.caseBomb?.isIgnitionType5 = textIsIgnitionType5;
              widget.caseBomb?.ignitionType5Detail =
                  ignitionType5DetailController.text;

              widget.caseBomb?.isIgnitionType6 = textIsIgnitionType6;
              widget.caseBomb?.ignitionType6Detail =
                  ignitionType6DetailController.text;

              widget.caseBomb?.isIgnitionType7 = textIsIgnitionType7;
              widget.caseBomb?.ignitionType7Detail =
                  ignitionType7DetailController.text;

              Navigator.of(context).pop(widget.caseBomb);
            }));
  }

  textField(
    TextEditingController controller,
    String? hint,
  ) {
    return InputField(
      controller: controller,
      hint: '$hint',
      onChanged: (_) {},
    );
  }

  Widget spacer(context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.015,
    );
  }

  Widget tabIsIgnitionType7(String? text) {
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
                        value: isIgnitionType7,
                        onChanged: (value) {
                          setState(() {
                            isIgnitionType7 = value ?? false;
                            if (value ?? false) {
                              textIsIgnitionType7 = '1';
                            } else {
                              textIsIgnitionType7 = '2';
                              ignitionType7DetailController.text = '';
                            }
                          });
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

  Widget tabIsIgnitionType6(String? text) {
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
                        value: isIgnitionType6,
                        onChanged: (value) {
                          setState(() {
                            isIgnitionType6 = value ?? false;
                            if (value ?? false) {
                              textIsIgnitionType6 = '1';
                            } else {
                              textIsIgnitionType6 = '2';
                              ignitionType6DetailController.text = '';
                            }
                          });
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

  Widget tabIsIgnitionType5(String? text) {
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
                        value: isIgnitionType5,
                        onChanged: (value) {
                          setState(() {
                            isIgnitionType5 = value ?? false;
                            if (value ?? false) {
                              textIsIgnitionType5 = '1';
                            } else {
                              textIsIgnitionType5 = '2';
                              ignitionType5DetailController.text = '';
                            }
                          });
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

  Widget tabIsIgnitionType4(String? text) {
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
                        value: isIgnitionType4,
                        onChanged: (value) {
                          setState(() {
                            isIgnitionType4 = value ?? false;
                            if (value ?? false) {
                              textIsIgnitionType4 = '1';
                            } else {
                              textIsIgnitionType4 = '2';
                              ignitionType4BrandController.text = '';
                              ignitionType4ModelController.text = '';
                              ignitionType4ColourController.text = '';
                              ignitionType4SNController.text = '';
                            }
                          });
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

  Widget tabIsIgnitionType3(String? text) {
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
                        value: isIgnitionType3,
                        onChanged: (value) {
                          setState(() {
                            isIgnitionType3 = value ?? false;
                            if (value ?? false) {
                              textIsIgnitionType3 = '1';
                            } else {
                              textIsIgnitionType3 = '2';
                              ignitionType3BrandController.text = '';
                              ignitionType3ModelController.text = '';
                              ignitionType3ColourController.text = '';
                              ignitionType3SNController.text = '';
                            }
                          });
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

  Widget tabIsIgnitionType1(String? text) {
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
                        value: isIgnitionType1,
                        onChanged: (value) {
                          setState(() {
                            isIgnitionType1 = value ?? false;
                            if (value ?? false) {
                              textIsIgnitionType1 = '1';
                            } else {
                              textIsIgnitionType1 = '2';
                              ignitionType1DetailController.text = '';
                            }
                          });
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

  Widget tabIsIgnitionType2(String? text) {
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
                        value: isIgnitionType2,
                        onChanged: (value) {
                          setState(() {
                            isIgnitionType2 = value ?? false;
                            if (value ?? false) {
                              textIsIgnitionType2 = '1';
                            } else {
                              textIsIgnitionType2 = '2';
                              ignitionType1ColorController.text = '';
                              ignitionType1LengthController.text = '';
                            }
                          });
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
}
