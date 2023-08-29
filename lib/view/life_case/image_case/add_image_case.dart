import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../../Utils/color.dart';
import '../../../widget/app_bar_widget.dart';
import '../../../widget/app_button.dart';
import '../../../widget/text_field_widget.dart';

class AddImageCase extends StatefulWidget {
  const AddImageCase({super.key});

  @override
  AddImageCaseState createState() => AddImageCaseState();
}

class AddImageCaseState extends State<AddImageCase> {
  bool isPhone = Device.get().isPhone;
  File? _image;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(
          title: 'รูปภาพ',
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
                    child: ListView(children: [
                      GestureDetector(
                        onTap: () {
                          final action = CupertinoActionSheet(
                            title: Text('อัพโหลดรูปภาพ',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'SukhumvitSet',
                                  fontSize:
                                      MediaQuery.of(context).size.height * 0.03,
                                )),
                            actions: <Widget>[
                              CupertinoActionSheetAction(
                                isDefaultAction: true,
                                onPressed: () {
                                  getImage(false);
                                },
                                child: Text('รูปถ่าย',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'SukhumvitSet',
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.02,
                                    )),
                              ),
                              CupertinoActionSheetAction(
                                isDefaultAction: true,
                                onPressed: () {
                                  getImage(true);
                                },
                                child: Text('อัลบั้ม',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'SukhumvitSet',
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.02,
                                    )),
                              )
                            ],
                            cancelButton: CupertinoActionSheetAction(
                              isDestructiveAction: true,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Cancel',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'SukhumvitSet',
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.02,
                                  )),
                            ),
                          );
                          showCupertinoModalPopup(
                              context: context, builder: (context) => action);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            _image == null
                                ? Container(
                                    alignment: Alignment.center,
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    height:
                                        MediaQuery.of(context).size.width * 0.4,
                                    child: const Icon(
                                      Icons.add_a_photo,
                                      color: Colors.white70,
                                      size: 100,
                                    ))
                                : Column(
                                    children: [
                                      Image(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.4,
                                          image:
                                              FileImage(_image ?? File('path')),
                                          fit: BoxFit.cover),
                                      TextButton(
                                          onPressed: () {
                                            setState(() {
                                              _image = null;
                                            });
                                          },
                                          child: const Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: 30,
                                          ))
                                    ],
                                  ),
                          ],
                        ),
                      ),
                      spacer(context),
                      header('รหัสภาพ'),
                      spacer(context),
                      InputField(hint: 'กรอกรหัสภาพ', onChanged: (value) {}),
                      radioView(),
                      spacer(context),
                      header('คำอธิบาย'),
                      spacer(context),
                      InputField(
                          hint: 'กรอกคำอธิบาย',
                          maxLine: 4,
                          onChanged: (value) {}),
                      spacer(context),
                      header('หมายเหตุ'),
                      spacer(context),
                      InputField(
                          hint: 'กรอกหมายเหตุ',
                          maxLine: 4,
                          onChanged: (value) {}),
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

  int _radioValue = 0;
  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;

      switch (_radioValue) {
        case 0:
          break;
        case 1:
          break;
        case 2:
          break;
      }
    });
  }

  Widget radioView() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            'การระบุขนาด',
            textAlign: TextAlign.center,
            style: GoogleFonts.prompt(
              textStyle: TextStyle(
                color: Colors.white,
                letterSpacing: .5,
                fontSize: MediaQuery.of(context).size.height * 0.025,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Transform.scale(
                      scale: 1.2,
                      child: Radio(
                        value: 0,
                        activeColor: pinkButton,
                        groupValue: _radioValue,
                        onChanged: (val) {
                          _handleRadioValueChange(val ?? -1);
                        },
                      )),
                  Text(
                    'ไม่มีสเกล',
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
                  Transform.scale(
                      scale: 1.2,
                      child: Radio(
                        value: 1,
                        groupValue: _radioValue,
                        activeColor: pinkButton,
                        onChanged: (val) {
                          _handleRadioValueChange(val ?? -1);
                        },
                      )),
                  Text(
                    'มีสเกล',
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
          // Navigator.pushReplacementNamed(context, '/home');
          Navigator.of(context).pop();
        });
  }

  void getImage(bool isFromGallery) async {
    final pickedFile = await picker.pickImage(
        source: isFromGallery ? ImageSource.gallery : ImageSource.camera,
        imageQuality: 20);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        if (kDebugMode) {
          print('readAsBytes: ${_image!.readAsBytes()}');
        }

        // images.add(_image);
        // List<int> imageBytes = _image.readAsBytesSync();
        // String?base64Image = base64Encode(imageBytes);
        // Layout layout = Layout();
        // layout.file = 'data:image/png;base64,$base64Image';
        // farm.layouts.add(layout);
        // controller.animateTo(controller.position.maxScrollExtent + 1,
        //     curve: Curves.easeInOut, duration: Duration(milliseconds: 100));
        // listKey.currentState.insertItem(images.length - 1,
        //     duration: const Duration(milliseconds: 200));
        // counter++;
        Navigator.pop(context);
      } else {}
    });
  }
}
