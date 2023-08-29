import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../Utils/color.dart';
import '../../../../widget/app_bar_widget.dart';
import '../../../../widget/app_button.dart';
import '../../../../widget/text_field_widget.dart';

class AddStructure extends StatefulWidget {
  const AddStructure({super.key});

  @override
  AddStructureState createState() => AddStructureState();
}

class AddStructureState extends State<AddStructure> {
  bool isPhone = Device.get().isPhone;

  final TextEditingController _structureController = TextEditingController();
  final TextEditingController _wallController = TextEditingController();
  final TextEditingController _frontWallController = TextEditingController();
  final TextEditingController _leftWallController = TextEditingController();
  final TextEditingController _rightWallController = TextEditingController();
  final TextEditingController _backWallController = TextEditingController();
  final TextEditingController _roomFloorController = TextEditingController();
  final TextEditingController _roofController = TextEditingController();
  final TextEditingController _placementController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'แก้ไขโครงสร้าง',
        actions: [
          Container(
            width: MediaQuery.of(context).size.width * 0.1,
          )
        ],
      ),
      body: Container(
        color: darkBlue,
        child: SafeArea(
          child: Container(
            margin: isPhone
                ? const EdgeInsets.all(32)
                : const EdgeInsets.only(
                    left: 32, right: 32, top: 32, bottom: 32),
            child: ListView(
              children: [
                spacerTitle(),
                subtitle('ลักษณะ'),
                spacer(),
                textField(
                    _structureController, 'บ้านคอนกรีต', (value) {}, (_) {}),
                spacerTitle(),
                subtitle('ผนัง'),
                spacer(),
                textField(
                    _wallController, 'กรอกข้อมูลผนัง', (value) {}, (_) {}),
                spacerTitle(),
                subtitle('ด้านหน้า'),
                spacer(),
                textField(_frontWallController, 'กรอกข้อมูบด้านหน้า',
                    (value) {}, (_) {}),
                spacerTitle(),
                subtitle('ด้านซ้าย'),
                spacer(),
                textField(_leftWallController, 'กรอกข้อมูลด้านซ้าย', (value) {},
                    (_) {}),
                spacerTitle(),
                subtitle('ด้านขวา'),
                spacer(),
                textField(_rightWallController, 'กรอกข้อมูลด้านขวา', (value) {},
                    (_) {}),
                spacerTitle(),
                subtitle('ด้านหลัง'),
                spacer(),
                textField(_backWallController, 'กรอกข้อมูลด้านหลัง', (value) {},
                    (_) {}),
                spacerTitle(),
                subtitle('พื้นห้อง'),
                spacer(),
                textField(_roomFloorController, 'กรอกข้อมูลพื้นห้อง',
                    (value) {}, (_) {}),
                spacerTitle(),
                subtitle('หลังคา'),
                spacer(),
                textField(
                    _roofController, 'กรอกข้อมูลหลังคา', (value) {}, (_) {}),
                spacerTitle(),
                subtitle('ลักษณะการจัดวางสิ่งของ'),
                spacer(),
                textField(_placementController,
                    'กรอกข้อมูลลักษณะการจัดวางสิ่งของ', (value) {}, (_) {}),
                spacerTitle(),
                saveButton()
              ],
            ),
          ),
        ),
      ),
    );
  }

  spacer() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.01,
    );
  }

  spacerTitle() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.015,
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
              fontSize: MediaQuery.of(context).size.height * 0.03,
            ),
          ),
        ),
      ],
    );
  }

  Widget subtitle(String? title) {
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

  textField(
    TextEditingController controller,
    String? hint,
    Function onChanged,
    Function onFieldSubmitted,
  ) {
    return InputField(
      controller: controller,
      hint: '$hint',
      onChanged: (str) {
        onChanged(str);
      },
      onFieldSubmitted: onFieldSubmitted,
    );
  }

  Widget saveButton() {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
      child: AppButton(
          color: pinkButton,
          textColor: Colors.white,
          text: 'บันทึกข้อมูลบริเวณที่เกิดเหตุ',
          onPressed: () {
            Navigator.pop(context);
          }),
    );
  }
}
