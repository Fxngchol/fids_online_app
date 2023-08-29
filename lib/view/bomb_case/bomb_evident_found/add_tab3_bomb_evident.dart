import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/color.dart';
import '../../../models/CaseBomb.dart';
import '../../../widget/app_bar_widget.dart';
import '../../../widget/app_button.dart';
import '../../../widget/text_field_widget.dart';

class AddTab3BombEvident extends StatefulWidget {
  final int? caseID;
  final String? caseNo;
  final bool isEdit;
  final CaseBomb? caseBomb;

  const AddTab3BombEvident(
      {super.key,
      required this.caseID,
      this.caseNo,
      this.isEdit = false,
      this.caseBomb});

  @override
  AddTab3BombEvidentState createState() => AddTab3BombEvidentState();
}

class AddTab3BombEvidentState extends State<AddTab3BombEvident> {
  bool isPhone = Device.get().isPhone;

  bool isFlakType1 = false;
  String? textIsFlakType1;
  String? flakType1Size;
  TextEditingController flakType1SizeController = TextEditingController();
  String? flakType1Length;
  TextEditingController flakType1LengthController = TextEditingController();

  bool isFlakType2 = false;
  String? textIsFlakType2;
  String? flakType2Size;
  TextEditingController flakType2SizeController = TextEditingController();

  bool isFlakType3 = false;
  String? textIsFlakType3;
  String? flakType3Detail;
  TextEditingController flakType3DetailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setupData();
  }

  setupData() {
    textIsFlakType1 = widget.caseBomb?.isFlakType1;
    if (textIsFlakType1 == '1') {
      isFlakType1 = true;
    }
    flakType1SizeController.text = widget.caseBomb?.flakType1Size ?? '';
    flakType1LengthController.text = widget.caseBomb?.flakType1Length ?? '';

    textIsFlakType2 = widget.caseBomb?.isFlakType2;
    if (textIsFlakType2 == '1') {
      isFlakType2 = true;
    }
    flakType2SizeController.text = widget.caseBomb?.flakType2Size ?? '';

    textIsFlakType3 = widget.caseBomb?.isFlakType3;
    if (textIsFlakType3 == '1') {
      isFlakType3 = true;
    }
    flakType3DetailController.text = widget.caseBomb?.flakType3Detail ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBarWidget(
          title: 'สะเก็ดระเบิด',
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
                  tabIsFlakType1('เหล็กเส้นตัดท่อน'),
                  const SizedBox(height: 5),
                  isFlakType1 ? title('เหล็กเส้นตัดท่อน (หุน)') : Container(),
                  const SizedBox(height: 5),
                  isFlakType1
                      ? textField(
                          flakType1SizeController, 'เหล็กเส้นตัดท่อน / หุน')
                      : Container(),
                  const SizedBox(height: 5),
                  isFlakType1
                      ? title('ความยาวเหล็กเส้นตัดท่อน (ซม.)')
                      : Container(),
                  const SizedBox(height: 5),
                  isFlakType1
                      ? textField(flakType1LengthController, 'ยาว / ซม.')
                      : Container(),
                  spacer(context),
                  tabIsFlakType2('ตะปู'),
                  const SizedBox(height: 5),
                  isFlakType2 ? title('ขนาด (นิ้ว)') : Container(),
                  const SizedBox(height: 5),
                  isFlakType2
                      ? textField(flakType2SizeController, 'ขนาด / นิ้ว')
                      : Container(),
                  spacer(context),
                  tabIsFlakType3('อื่นๆ'),
                  const SizedBox(height: 5),
                  isFlakType3 ? title('รายละเอียด') : Container(),
                  const SizedBox(height: 5),
                  isFlakType3
                      ? textField(flakType3DetailController, 'รายละเอียด')
                      : Container(),
                  spacer(context),
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
              widget.caseBomb?.isFlakType1 = textIsFlakType1;
              widget.caseBomb?.flakType1Size = flakType1SizeController.text;
              widget.caseBomb?.flakType1Length = flakType1LengthController.text;

              widget.caseBomb?.isFlakType2 = textIsFlakType2;
              widget.caseBomb?.flakType2Size = flakType2SizeController.text;

              widget.caseBomb?.isFlakType3 = textIsFlakType3;
              widget.caseBomb?.flakType3Detail = flakType3DetailController.text;

              Navigator.of(context).pop(widget.caseBomb);
            }));
  }

  Widget spacer(context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.025,
    );
  }

  Widget tabIsFlakType3(String? text) {
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
                        value: isFlakType3,
                        onChanged: (value) {
                          setState(() {
                            isFlakType3 = value ?? false;
                            if (value ?? false) {
                              textIsFlakType3 = '1';
                            } else {
                              textIsFlakType3 = '2';
                              flakType3DetailController.text = '';
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

  Widget tabIsFlakType2(String? text) {
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
                        value: isFlakType2,
                        onChanged: (value) {
                          setState(() {
                            isFlakType2 = value ?? false;
                            if (value ?? false) {
                              textIsFlakType2 = '1';
                            } else {
                              textIsFlakType2 = '2';
                              flakType2SizeController.text = '';
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

  Widget tabIsFlakType1(String? text) {
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
                        value: isFlakType1,
                        onChanged: (value) {
                          setState(() {
                            isFlakType1 = value ?? false;
                            if (value ?? false) {
                              textIsFlakType1 = '1';
                            } else {
                              textIsFlakType1 = '2';
                              flakType1SizeController.text = '';
                              flakType1LengthController.text = '';
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
