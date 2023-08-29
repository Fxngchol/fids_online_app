import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/color.dart';
import '../../../models/CaseBomb.dart';
import '../../../widget/app_bar_widget.dart';
import '../../../widget/app_button.dart';
import '../../../widget/text_field_widget.dart';

class AddTab1BombEvident extends StatefulWidget {
  final int? caseID;
  final String? caseNo;
  final bool isEdit;
  final CaseBomb? caseBomb;

  const AddTab1BombEvident(
      {super.key,
      this.caseID,
      this.caseNo,
      this.isEdit = false,
      this.caseBomb});

  @override
  // ignore: library_private_types_in_public_api
  _AddTab1BombEvidentState createState() => _AddTab1BombEvidentState();
}

class _AddTab1BombEvidentState extends State<AddTab1BombEvident> {
  bool isPhone = Device.get().isPhone;

  TextEditingController bombPackage8DetailController = TextEditingController();

  bool isBombPackage1 = false;
  String? textIsBombPackage1 = '';
  bool isBombPackage2 = false;
  String? textIsBombPackage2 = '';
  bool isBombPackage3 = false;
  String? textIsBombPackage3 = '';
  bool isBombPackage4 = false;
  String? textIsBombPackage4 = '';
  bool isBombPackage5 = false;
  String? textIsBombPackage5 = '';
  bool isBombPackage6 = false;
  String? textIsBombPackage6 = '';
  bool isBombPackage7 = false;
  String? textIsBombPackage7 = '';
  bool isBombPackage8 = false;
  String? textIsBombPackage8 = '';

  @override
  void initState() {
    super.initState();
    setupData();
  }

  setupData() {
    textIsBombPackage1 = widget.caseBomb?.isBombPackage1 ?? '';
    if (textIsBombPackage1 == '1') {
      isBombPackage1 = true;
    }

    textIsBombPackage2 = widget.caseBomb?.isBombPackage2 ?? '';
    if (textIsBombPackage2 == '1') {
      isBombPackage2 = true;
    }

    textIsBombPackage3 = widget.caseBomb?.isBombPackage3 ?? '';
    if (textIsBombPackage3 == '1') {
      isBombPackage3 = true;
    }

    textIsBombPackage4 = widget.caseBomb?.isBombPackage4 ?? '';
    if (textIsBombPackage4 == '1') {
      isBombPackage4 = true;
    }

    textIsBombPackage5 = widget.caseBomb?.isBombPackage5 ?? '';
    if (textIsBombPackage5 == '1') {
      isBombPackage5 = true;
    }

    textIsBombPackage6 = widget.caseBomb?.isBombPackage6 ?? '';
    if (textIsBombPackage6 == '1') {
      isBombPackage6 = true;
    }

    textIsBombPackage7 = widget.caseBomb?.isBombPackage7 ?? '';
    if (textIsBombPackage7 == '1') {
      isBombPackage7 = true;
    }

    textIsBombPackage8 = widget.caseBomb?.isBombPackage8 ?? '';
    if (textIsBombPackage8 == '1') {
      isBombPackage8 = true;
    }

    bombPackage8DetailController.text =
        widget.caseBomb?.bombPackage8Detail ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBarWidget(
          title: 'บรรจุ',
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
                  tabIsBombPackage1('กล่องเหล็ก'),
                  spacer(context),
                  tabIsBombPackage2('ถังแก๊ส'),
                  spacer(context),
                  tabIsBombPackage3('ถังดับเพลิง'),
                  spacer(context),
                  tabIsBombPackage4('ท่อเหล็ก'),
                  spacer(context),
                  tabIsBombPackage5('ท่อ PVC'),
                  spacer(context),
                  tabIsBombPackage6('ถังน้ำยาแอร์'),
                  spacer(context),
                  tabIsBombPackage7('ระเบิดมาตรฐาน'),
                  spacer(context),
                  tabIsBombPackage8('อื่นๆ'),
                  const SizedBox(height: 5),
                  isBombPackage8
                      ? textField(
                          bombPackage8DetailController, 'กรอกรายละเอียดอื่นๆ')
                      : Container(),
                  spacerTitle(),
                  spacerTitle(),
                  saveButton()
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
              widget.caseBomb?.isBombPackage1 = textIsBombPackage1;
              widget.caseBomb?.isBombPackage2 = textIsBombPackage2;
              widget.caseBomb?.isBombPackage3 = textIsBombPackage3;
              widget.caseBomb?.isBombPackage4 = textIsBombPackage4;
              widget.caseBomb?.isBombPackage5 = textIsBombPackage5;
              widget.caseBomb?.isBombPackage6 = textIsBombPackage6;
              widget.caseBomb?.isBombPackage7 = textIsBombPackage7;
              widget.caseBomb?.isBombPackage8 = textIsBombPackage8;
              widget.caseBomb?.bombPackage8Detail =
                  bombPackage8DetailController.text;

              Navigator.of(context).pop(widget.caseBomb);
            }));
  }

  spacerTitle() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.015,
    );
  }

  textField(
    TextEditingController controller,
    String? hint,
  ) {
    return InputField(
      controller: controller,
      hint: hint ?? '',
      onChanged: (_) {},
    );
  }

  Widget spacer(context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.015,
    );
  }

  Widget tabIsBombPackage1(String? text) {
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
                        value: isBombPackage1,
                        onChanged: (value) {
                          setState(() {
                            isBombPackage1 = value ?? false;
                            if (value ?? false) {
                              textIsBombPackage1 = '1';
                            } else {
                              textIsBombPackage1 = '2';
                            }
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                    Text(
                      text ?? '',
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

  Widget tabIsBombPackage2(String? text) {
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
                        value: isBombPackage2,
                        onChanged: (value) {
                          setState(() {
                            isBombPackage2 = value ?? false;
                            if (value ?? false) {
                              textIsBombPackage2 = '1';
                            } else {
                              textIsBombPackage2 = '2';
                            }
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                    Text(
                      text ?? '',
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

  Widget tabIsBombPackage3(String? text) {
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
                        value: isBombPackage3,
                        onChanged: (value) {
                          setState(() {
                            isBombPackage3 = value ?? false;
                            if (value ?? false) {
                              textIsBombPackage3 = '1';
                            } else {
                              textIsBombPackage3 = '2';
                            }
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                    Text(
                      text ?? '',
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

  Widget tabIsBombPackage4(String? text) {
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
                        value: isBombPackage4,
                        onChanged: (value) {
                          setState(() {
                            isBombPackage4 = value ?? false;
                            if (value ?? false) {
                              textIsBombPackage4 = '1';
                            } else {
                              textIsBombPackage4 = '2';
                            }
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                    Text(
                      text ?? '',
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

  Widget tabIsBombPackage5(String? text) {
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
                        value: isBombPackage5,
                        onChanged: (value) {
                          setState(() {
                            isBombPackage5 = value ?? false;
                            if (value ?? false) {
                              textIsBombPackage5 = '1';
                            } else {
                              textIsBombPackage5 = '2';
                            }
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                    Text(
                      text ?? '',
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

  Widget tabIsBombPackage6(String? text) {
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
                        value: isBombPackage6,
                        onChanged: (value) {
                          setState(() {
                            isBombPackage6 = value ?? false;
                            if (value ?? false) {
                              textIsBombPackage6 = '1';
                            } else {
                              textIsBombPackage6 = '2';
                            }
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                    Text(
                      text ?? '',
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

  Widget tabIsBombPackage7(String? text) {
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
                        value: isBombPackage7,
                        onChanged: (value) {
                          setState(() {
                            isBombPackage7 = value ?? false;
                            if (value ?? false) {
                              textIsBombPackage7 = '1';
                            } else {
                              textIsBombPackage7 = '2';
                            }
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                    Text(
                      text ?? '',
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

  Widget tabIsBombPackage8(String? text) {
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
                        value: isBombPackage8,
                        onChanged: (value) {
                          setState(() {
                            isBombPackage8 = value ?? false;
                            if (value ?? false) {
                              textIsBombPackage8 = '1';
                            } else {
                              textIsBombPackage8 = '2';
                              bombPackage8DetailController.text = '';
                            }
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                    Text(
                      text ?? '',
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
