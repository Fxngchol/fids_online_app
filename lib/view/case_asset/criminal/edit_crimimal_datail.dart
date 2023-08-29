import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/color.dart';
import '../../../models/FidsCrimeScene.dart';
import '../../../widget/app_bar_widget.dart';
import '../../../widget/app_button.dart';
import '../../../widget/text_field_widget.dart';

class EditCriminalDetail extends StatefulWidget {
  final int? caseID;
  const EditCriminalDetail({super.key, this.caseID});
  @override
  EditCriminalDetailState createState() => EditCriminalDetailState();
}

class EditCriminalDetailState extends State<EditCriminalDetail> {
  bool isLoading = true;
  bool isPhone = Device.get().isPhone;
  int isWeaponValue = -1;
  bool isWeaponType1 = false,
      isWeaponType2 = false,
      isWeaponType3 = false,
      isWeaponType4 = false,
      isImpressionInRoom = false,
      isImpression = false;
  FidsCrimeScene? fidsCrimescene;
  TextEditingController criminalAmountController = TextEditingController();
  TextEditingController isoWeaponType4DetailController =
      TextEditingController();
  TextEditingController isoImprisonController = TextEditingController();
  TextEditingController isoImprisonDetailController = TextEditingController();

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
    setState(() {
      criminalAmountController.text = fidsCrimescene?.criminalAmount ?? '';
      isoWeaponType4DetailController.text =
          fidsCrimescene?.isoWeaponType4Detail ?? '';
      isoImprisonController.text = fidsCrimescene?.isoImprison ?? '';
      isoImprisonDetailController.text =
          fidsCrimescene?.isoImprisonDetail ?? '';

      // print(fidsCrimescene.isoIsImprisonInRoom);
      // print(fidsCrimescene.isoIsImprison);

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBarWidget(
        title: 'ข้อมูลคนร้าย',
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
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              margin: isPhone
                  ? const EdgeInsets.all(32)
                  : const EdgeInsets.only(
                      left: 32, right: 32, top: 32, bottom: 32),
              child: SingleChildScrollView(
                child: Column(children: [
                  title('จำนวนคนร้าย/คน'),
                  spacer(),
                  InputField(
                    controller: criminalAmountController,
                    hint: 'กรอกจำนวนคนร้าย',
                    onChanged: (value) {},
                  ),
                  spacer(),
                  spacer(),
                  weaponView(),
                  spacer(),
                  weaponCheckboxView(),
                  spacer(),
                  Padding(
                    padding: const EdgeInsets.only(left: 36),
                    child: InputField(
                      controller: isoWeaponType4DetailController,
                      hint: 'กรอกข้อมูลอาวุธอื่นๆ',
                      isEnabled: isWeaponType4,
                      onChanged: (value) {},
                    ),
                  ),
                  spacer(),
                  spacer(),
                  title('คนร้ายได้พันธนาการผู้เสียหายอย่างไร'),
                  spacer(),
                  imprisonCheckboxView(),
                  spacer(),
                  Padding(
                    padding: const EdgeInsets.only(left: 36),
                    child: InputField(
                      controller: isoImprisonController,
                      hint: 'กรอกข้อมูล',
                      isEnabled: isImpression,
                      onChanged: (value) {},
                    ),
                  ),
                  spacer(),
                  Padding(
                    padding: const EdgeInsets.only(left: 36),
                    child: title('ในการพันธนาการ'),
                  ),
                  spacer(),
                  Padding(
                    padding: const EdgeInsets.only(left: 36),
                    child: InputField(
                      controller: isoImprisonDetailController,
                      isEnabled: isImpression,
                      hint: 'กรอกข้อมูล',
                      onChanged: (value) {},
                    ),
                  ),
                  spacer(),
                  spacer(),
                  saveButton()
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
          checkbox('กักขังภายในห้อง', isImpressionInRoom, (value) {
            setState(() {
              isImpressionInRoom = value;
            });
          }),
          spacer(),
          checkbox('คนร้ายใช้', isImpression, (value) {
            setState(() {
              isImpression = value;
              if (value == false) {
                isoImprisonDetailController.text = '';
                isoImprisonController.text = '';
              }
            });
          }),
        ],
      ),
    );
  }

  weaponCheckboxView() {
    return Padding(
      padding: const EdgeInsets.only(left: 36),
      child: Column(
        children: [
          checkbox('อาวุธมีด', isWeaponValue == 1 ? isWeaponType1 : false,
              (value) {
            setState(() {
              isWeaponType1 = value;
            });
          }),
          spacer(),
          checkbox('อาวุธปืน', isWeaponValue == 1 ? isWeaponType2 : false,
              (value) {
            setState(() {
              isWeaponType2 = value;
            });
          }),
          spacer(),
          checkbox('เชือก', isWeaponValue == 1 ? isWeaponType3 : false,
              (value) {
            setState(() {
              isWeaponType3 = value;
            });
          }),
          spacer(),
          checkbox('อื่นๆ', isWeaponValue == 1 ? isWeaponType4 : false,
              (value) {
            setState(() {
              isWeaponType4 = value;
              if (value == false) {
                isoWeaponType4DetailController.text = '';
              }
            });
          })
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
                onChanged: (vlaue) {
                  setState(() {
                    isWeaponValue = vlaue ?? -1;
                    isWeaponType1 = false;
                    isWeaponType2 = false;
                    isWeaponType3 = false;
                    isWeaponType4 = false;
                    isoWeaponType4DetailController.text = '';
                  });
                },
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
                onChanged: (value) {
                  setState(() {
                    isWeaponValue = value ?? -1;
                  });
                },
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

  checkbox(String? text, bool isChecked, Function onChanged) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Transform.scale(
        scale: 1.7,
        child: Checkbox(
            value: isChecked,
            checkColor: Colors.white,
            activeColor: pinkButton,
            onChanged: (boo) {
              onChanged(boo);
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

  Widget saveButton() {
    return AppButton(
        color: pinkButton,
        textColor: Colors.white,
        text: 'บันทึก',
        onPressed: () {
          bool isNumb = true;
          // try {
          //   if (criminalAmountController.text != '') {
          //     double.parse(criminalAmountController.text);
          //   }
          // } catch (ex) {
          //   isNumb = false;
          // }

          if (isNumb) {
            FidsCrimeSceneDao().updateAssetCriminal(
                criminalAmountController.text,
                isWeaponValue.toString(),
                isWeaponType1 == true ? '1' : '2',
                isWeaponType2 == true ? '1' : '2',
                isWeaponType3 == true ? '1' : '2',
                isWeaponType4 == true ? '1' : '2',
                isoWeaponType4DetailController.text,
                isImpressionInRoom == true ? '1' : '2',
                isImpression == true ? '1' : '2',
                isoImprisonController.text,
                isoImprisonDetailController.text,
                widget.caseID.toString());
            Navigator.of(context).pop(true);
          }
          // } else {
          // final snackBar = SnackBar(
          //   content: Text(
          //     'กรุณากรอกจำนวนคนร้ายด้วยตัวเลข',
          //     textAlign: TextAlign.center,
          //     style: GoogleFonts.prompt(
          //       textStyle: TextStyle(
          //         color: Colors.white,
          //         letterSpacing: .5,
          //         fontSize: MediaQuery.of(context).size.height * 0.02,
          //       ),
          //     ),
          //   ),
          // );
          // ScaffoldMessenger.of(context).showSnackBar(snackBar);
          // }
        });
  }
}
