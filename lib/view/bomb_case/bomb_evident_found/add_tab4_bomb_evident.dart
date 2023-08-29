import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/color.dart';
import '../../../models/CaseBomb.dart';
import '../../../widget/app_bar_widget.dart';
import '../../../widget/app_button.dart';
import '../../../widget/text_field_widget.dart';

class AddTab4BombEvident extends StatefulWidget {
  final int? caseID;
  final String? caseNo;
  final bool isEdit;
  final CaseBomb? caseBomb;

  const AddTab4BombEvident(
      {super.key,
      required this.caseID,
      this.caseNo,
      this.isEdit = false,
      this.caseBomb});

  @override
  // ignore: library_private_types_in_public_api
  _AddTab4BombEvidentState createState() => _AddTab4BombEvidentState();
}

class _AddTab4BombEvidentState extends State<AddTab4BombEvident> {
  bool isPhone = Device.get().isPhone;

  bool isMaterial1 = false;
  String? textIsMaterial1;
  TextEditingController material1Controller = TextEditingController();

  bool isMaterial2 = false;
  String? textIsMaterial2;
  TextEditingController material2Controller = TextEditingController();

  bool isMaterial3 = false;
  String? textIsMaterial3;
  TextEditingController material3Controller = TextEditingController();

  bool isMaterial4 = false;
  String? textIsMaterial4;
  TextEditingController material4Controller = TextEditingController();

  bool isMaterial5 = false;
  String? textIsMaterial5;
  TextEditingController material5Controller = TextEditingController();

  bool isMaterial6 = false;
  String? textIsMaterial6;
  TextEditingController material6Controller = TextEditingController();
  TextEditingController material6VController = TextEditingController();

  bool isMaterial7 = false;
  String? textIsMaterial7;
  TextEditingController material7Controller = TextEditingController();

  bool isMaterial8 = false;
  String? textIsMaterial8;
  TextEditingController material8Controller = TextEditingController();

  bool isMaterial9 = false;
  String? textIsMaterial9;
  TextEditingController material9Controller = TextEditingController();

  bool isMaterial10 = false;
  String? textIsMaterial10;
  TextEditingController material10Controller = TextEditingController();

  bool isMaterial11 = false;
  String? textIsMaterial11;
  TextEditingController material11Controller = TextEditingController();

  bool isMaterial12 = false;
  String? textIsMaterial12;
  TextEditingController material12Controller = TextEditingController();

  bool isMaterial13 = false;
  String? textIsMaterial13;
  TextEditingController material13Controller = TextEditingController();

  bool isMaterial14 = false;
  String? textIsMaterial14;
  TextEditingController material14Controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    setupData();
  }

  setupData() {
    textIsMaterial1 = widget.caseBomb?.isMaterial1 ?? '';
    if (textIsMaterial1 == '1') {
      isMaterial1 = true;
    }
    material1Controller.text = widget.caseBomb?.material1 ?? '';

    textIsMaterial2 = widget.caseBomb?.isMaterial2 ?? '';
    if (textIsMaterial2 == '1') {
      isMaterial2 = true;
    }
    material2Controller.text = widget.caseBomb?.material2 ?? '';

    textIsMaterial3 = widget.caseBomb?.isMaterial3 ?? '';
    if (textIsMaterial3 == '1') {
      isMaterial3 = true;
    }
    material3Controller.text = widget.caseBomb?.material3 ?? '';

    textIsMaterial4 = widget.caseBomb?.isMaterial4 ?? '';
    if (textIsMaterial4 == '1') {
      isMaterial4 = true;
    }
    material4Controller.text = widget.caseBomb?.material4 ?? '';

    textIsMaterial5 = widget.caseBomb?.isMaterial5 ?? '';
    if (textIsMaterial5 == '1') {
      isMaterial5 = true;
    }
    material5Controller.text = widget.caseBomb?.material5 ?? '';

    textIsMaterial6 = widget.caseBomb?.isMaterial6 ?? '';
    if (textIsMaterial6 == '1') {
      isMaterial6 = true;
    }
    material6Controller.text = widget.caseBomb?.material6 ?? '';
    material6VController.text = widget.caseBomb?.material6V ?? '';

    textIsMaterial7 = widget.caseBomb?.isMaterial7 ?? '';
    if (textIsMaterial7 == '1') {
      isMaterial7 = true;
    }
    material7Controller.text = widget.caseBomb?.material7 ?? '';

    textIsMaterial8 = widget.caseBomb?.isMaterial8 ?? '';
    if (textIsMaterial8 == '1') {
      isMaterial8 = true;
    }
    material8Controller.text = widget.caseBomb?.material8 ?? '';

    textIsMaterial9 = widget.caseBomb?.isMaterial9 ?? '';
    if (textIsMaterial9 == '1') {
      isMaterial9 = true;
    }
    material9Controller.text = widget.caseBomb?.material9 ?? '';

    textIsMaterial10 = widget.caseBomb?.isMaterial10 ?? '';
    if (textIsMaterial10 == '1') {
      isMaterial10 = true;
    }
    material10Controller.text = widget.caseBomb?.material10 ?? '';

    textIsMaterial11 = widget.caseBomb?.isMaterial11 ?? '';
    if (textIsMaterial11 == '1') {
      isMaterial11 = true;
    }
    material11Controller.text = widget.caseBomb?.material11 ?? '';

    textIsMaterial12 = widget.caseBomb?.isMaterial12 ?? '';
    if (textIsMaterial12 == '1') {
      isMaterial12 = true;
    }
    material12Controller.text = widget.caseBomb?.material12 ?? '';

    textIsMaterial13 = widget.caseBomb?.isMaterial13 ?? '';
    if (textIsMaterial13 == '1') {
      isMaterial13 = true;
    }
    material13Controller.text = widget.caseBomb?.material13 ?? '';

    textIsMaterial14 = widget.caseBomb?.isMaterial14 ?? '';
    if (textIsMaterial14 == '1') {
      isMaterial14 = true;
    }
    material14Controller.text = widget.caseBomb?.material14 ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBarWidget(
          title: 'ส่วนประกอบ',
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
                  tabIsMaterial1('หลอดดินขยาย'),
                  const SizedBox(height: 5),
                  isMaterial1
                      ? textField(material1Controller, 'รายละเอียด')
                      : Container(),
                  spacer(context),
                  tabIsMaterial2('เชื้อประทุไฟฟ้า'),
                  const SizedBox(height: 5),
                  isMaterial2
                      ? textField(material2Controller, 'รายละเอียด')
                      : Container(),
                  spacer(context),
                  tabIsMaterial3('เทปพันสายไฟ'),
                  const SizedBox(height: 5),
                  isMaterial3
                      ? textField(material3Controller, 'รายละเอียด')
                      : Container(),
                  spacer(context),
                  tabIsMaterial4('ซิมการ์ด'),
                  const SizedBox(height: 5),
                  isMaterial4
                      ? textField(material4Controller, 'รายละเอียด')
                      : Container(),
                  spacer(context),
                  tabIsMaterial5('วงจรการจุดระเบิด'),
                  const SizedBox(height: 5),
                  isMaterial5
                      ? textField(material5Controller, 'รายละเอียด')
                      : Container(),
                  spacer(context),
                  tabIsMaterial6('แบตเตอรี่'),
                  const SizedBox(height: 5),
                  isMaterial6
                      ? textField(material6Controller, 'รายละเอียด')
                      : Container(),
                  const SizedBox(height: 5),
                  isMaterial6 ? title('V') : Container(),
                  const SizedBox(height: 5),
                  isMaterial6
                      ? textField(material6VController, 'V')
                      : Container(),
                  spacer(context),
                  tabIsMaterial7('แผงวงจร DTMF'),
                  const SizedBox(height: 5),
                  isMaterial7
                      ? textField(material7Controller, 'รายละเอียด')
                      : Container(),
                  spacer(context),
                  tabIsMaterial8('แผงวงจร'),
                  const SizedBox(height: 5),
                  isMaterial8
                      ? textField(material8Controller, 'รายละเอียด')
                      : Container(),
                  spacer(context),
                  tabIsMaterial9('สายไฟวงจร'),
                  const SizedBox(height: 5),
                  isMaterial9
                      ? textField(material9Controller, 'รายละเอียด')
                      : Container(),
                  spacer(context),
                  tabIsMaterial10('กล่องบรรจุวงจร'),
                  const SizedBox(height: 5),
                  isMaterial10
                      ? textField(material10Controller, 'รายละเอียด')
                      : Container(),
                  spacer(context),
                  tabIsMaterial11('นาฬิกา'),
                  const SizedBox(height: 5),
                  isMaterial11
                      ? textField(material11Controller, 'รายละเอียด')
                      : Container(),
                  spacer(context),
                  tabIsMaterial12('กระเดื่อง'),
                  const SizedBox(height: 5),
                  isMaterial12
                      ? textField(material12Controller, 'รายละเอียด')
                      : Container(),
                  spacer(context),
                  tabIsMaterial13('สลักนิรภัย'),
                  const SizedBox(height: 5),
                  isMaterial13
                      ? textField(material13Controller, 'รายละเอียด')
                      : Container(),
                  spacer(context),
                  tabIsMaterial14('อื่นๆ'),
                  const SizedBox(height: 5),
                  isMaterial14
                      ? textField(material14Controller, 'รายละเอียด')
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
              widget.caseBomb?.isMaterial1 = textIsMaterial1;
              widget.caseBomb?.material1 = material1Controller.text;

              widget.caseBomb?.isMaterial2 = textIsMaterial2;
              widget.caseBomb?.material2 = material2Controller.text;

              widget.caseBomb?.isMaterial3 = textIsMaterial3;
              widget.caseBomb?.material3 = material3Controller.text;

              widget.caseBomb?.isMaterial4 = textIsMaterial4;
              widget.caseBomb?.material4 = material4Controller.text;

              widget.caseBomb?.isMaterial5 = textIsMaterial5;
              widget.caseBomb?.material5 = material5Controller.text;

              widget.caseBomb?.isMaterial6 = textIsMaterial6;
              widget.caseBomb?.material6 = material6Controller.text;
              widget.caseBomb?.material6V = material6VController.text;

              widget.caseBomb?.isMaterial7 = textIsMaterial7;
              widget.caseBomb?.material7 = material7Controller.text;

              widget.caseBomb?.isMaterial8 = textIsMaterial8;
              widget.caseBomb?.material8 = material8Controller.text;

              widget.caseBomb?.isMaterial9 = textIsMaterial9;
              widget.caseBomb?.material9 = material9Controller.text;

              widget.caseBomb?.isMaterial10 = textIsMaterial10;
              widget.caseBomb?.material10 = material10Controller.text;

              widget.caseBomb?.isMaterial11 = textIsMaterial11;
              widget.caseBomb?.material11 = material11Controller.text;

              widget.caseBomb?.isMaterial12 = textIsMaterial12;
              widget.caseBomb?.material12 = material12Controller.text;

              widget.caseBomb?.isMaterial13 = textIsMaterial13;
              widget.caseBomb?.material13 = material13Controller.text;

              widget.caseBomb?.isMaterial14 = textIsMaterial14;
              widget.caseBomb?.material14 = material14Controller.text;

              Navigator.of(context).pop(widget.caseBomb);
            }));
  }

  Widget tabIsMaterial14(String? text) {
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
                        value: isMaterial14,
                        onChanged: (value) {
                          setState(() {
                            isMaterial14 = value ?? false;
                            if (value ?? false) {
                              textIsMaterial14 = '1';
                            } else {
                              textIsMaterial14 = '2';
                              material14Controller.text = '';
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

  Widget tabIsMaterial13(String? text) {
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
                        value: isMaterial13,
                        onChanged: (value) {
                          setState(() {
                            isMaterial13 = value ?? false;
                            if (value ?? false) {
                              textIsMaterial13 = '1';
                            } else {
                              textIsMaterial13 = '2';
                              material13Controller.text = '';
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

  Widget tabIsMaterial12(String? text) {
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
                        value: isMaterial12,
                        onChanged: (value) {
                          setState(() {
                            isMaterial12 = value ?? false;
                            if (value ?? false) {
                              textIsMaterial12 = '1';
                            } else {
                              textIsMaterial12 = '2';
                              material12Controller.text = '';
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

  Widget tabIsMaterial11(String? text) {
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
                        value: isMaterial11,
                        onChanged: (value) {
                          setState(() {
                            isMaterial11 = value ?? false;
                            if (value ?? false) {
                              textIsMaterial11 = '1';
                            } else {
                              textIsMaterial11 = '2';
                              material11Controller.text = '';
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

  Widget tabIsMaterial10(String? text) {
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
                        value: isMaterial10,
                        onChanged: (value) {
                          setState(() {
                            isMaterial10 = value ?? false;
                            if (value ?? false) {
                              textIsMaterial10 = '1';
                            } else {
                              textIsMaterial10 = '2';
                              material10Controller.text = '';
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

  Widget tabIsMaterial9(String? text) {
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
                        value: isMaterial9,
                        onChanged: (value) {
                          setState(() {
                            isMaterial9 = value ?? false;
                            if (value ?? false) {
                              textIsMaterial9 = '1';
                            } else {
                              textIsMaterial9 = '2';
                              material9Controller.text = '';
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

  Widget tabIsMaterial8(String? text) {
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
                        value: isMaterial8,
                        onChanged: (value) {
                          setState(() {
                            isMaterial8 = value ?? false;
                            if (value ?? false) {
                              textIsMaterial8 = '1';
                            } else {
                              textIsMaterial8 = '2';
                              material8Controller.text = '';
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

  Widget tabIsMaterial7(String? text) {
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
                        value: isMaterial7,
                        onChanged: (value) {
                          setState(() {
                            isMaterial7 = value ?? false;
                            if (value ?? false) {
                              textIsMaterial7 = '1';
                            } else {
                              textIsMaterial7 = '2';
                              material7Controller.text = '';
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

  Widget tabIsMaterial6(String? text) {
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
                        value: isMaterial6,
                        onChanged: (value) {
                          setState(() {
                            isMaterial6 = value ?? false;
                            if (value ?? false) {
                              textIsMaterial6 = '1';
                            } else {
                              textIsMaterial6 = '2';
                              material6Controller.text = '';
                              material6VController.text = '';
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

  Widget tabIsMaterial5(String? text) {
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
                        value: isMaterial5,
                        onChanged: (value) {
                          setState(() {
                            isMaterial5 = value ?? false;
                            if (value ?? false) {
                              textIsMaterial5 = '1';
                            } else {
                              textIsMaterial5 = '2';
                              material5Controller.text = '';
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

  Widget tabIsMaterial4(String? text) {
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
                        value: isMaterial4,
                        onChanged: (value) {
                          setState(() {
                            isMaterial4 = value ?? false;
                            if (value ?? false) {
                              textIsMaterial4 = '1';
                            } else {
                              textIsMaterial4 = '2';
                              material4Controller.text = '';
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

  Widget tabIsMaterial3(String? text) {
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
                        value: isMaterial3,
                        onChanged: (value) {
                          setState(() {
                            isMaterial3 = value ?? false;
                            if (value ?? false) {
                              textIsMaterial3 = '1';
                            } else {
                              textIsMaterial3 = '2';
                              material3Controller.text = '';
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

  Widget tabIsMaterial2(String? text) {
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
                        value: isMaterial2,
                        onChanged: (value) {
                          setState(() {
                            isMaterial2 = value ?? false;
                            if (value ?? false) {
                              textIsMaterial2 = '1';
                            } else {
                              textIsMaterial2 = '2';
                              material2Controller.text = '';
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

  Widget spacer(context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.025,
    );
  }

  Widget tabIsMaterial1(String? text) {
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
                        value: isMaterial1,
                        onChanged: (value) {
                          setState(() {
                            isMaterial1 = value ?? false;
                            if (value ?? false) {
                              textIsMaterial1 = '1';
                            } else {
                              textIsMaterial1 = '2';
                              material1Controller.text = '';
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
}
