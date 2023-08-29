// ignore_for_file: unused_import

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_painter/image_painter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:signature/signature.dart';

import '../../../Utils/color.dart';
import '../../../models/CaseBody.dart';
import '../../../widget/app_bar_widget.dart';
import '../../../widget/blurry_dialog.dart';

class DrawTemplate extends StatefulWidget {
  final int? caseID;
  final String? caseNo;
  final CaseBody? caseBody;
  final bool isEdit;

  const DrawTemplate(
      {super.key,
      this.caseID,
      this.caseNo,
      this.caseBody,
      this.isEdit = false});

  @override
  DrawTemplateState createState() => DrawTemplateState();
}

class DrawTemplateState extends State<DrawTemplate> {
  bool isPhone = Device.get().isPhone;
  ScreenshotController screenshotController = ScreenshotController();
  Image imgBody = Image.asset('images/body.png');
  TextEditingController investigatorDoctorController = TextEditingController();

  final _imageKey = GlobalKey<ImagePainterState>();
  final _key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    investigatorDoctorController.text =
        widget.caseBody?.investigatorDoctor ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        key: _key,
        appBar: AppBarWidget(
          title: 'แผนผังแสดงตำแหน่งบาดแผล',
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _displayDialog,
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
          child: Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.065),
              child: widget.isEdit
                  ? ImagePainter.memory(
                      base64Decode(widget.caseBody?.bodyDiagram
                              ?.replaceAll("data:image/png;base64,", "") ??
                          ''),
                      key: _imageKey,
                      clearAllIcon: IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.black54,
                        ),
                        onPressed: () {
                          BlurryDialog alert = BlurryDialog(
                              'แจ้งเตือน', 'ยืนยันการเคลียร์', () async {
                            if (kDebugMode) {
                              print('removing');
                            }
                            saveImage(true);
                          });
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return alert;
                            },
                          );
                        },
                      ),
                    )
                  : ImagePainter.asset("images/body.png",
                      key: _imageKey, scalable: false)),
        ));
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

  void saveImage(bool isClearAll) async {
    if (isClearAll == false) {
      await _imageKey.currentState?.exportImage().then((image) {
        final base64Image = base64.encode(image!);
        if (kDebugMode) {
          print('bodyDiagram: $base64Image');
          print('investigatorDoctor: ${investigatorDoctorController.text}');
        }
        widget.caseBody?.bodyDiagram = base64Image;
        widget.caseBody?.investigatorDoctor = investigatorDoctorController.text;
        Navigator.pop(context);
        Navigator.of(context).pop(widget.caseBody);
      });
    } else {
      widget.caseBody?.bodyDiagram = '';
      widget.caseBody?.investigatorDoctor = investigatorDoctorController.text;
      Navigator.of(context).pop(widget.caseBody);
    }
  }

  _displayDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            elevation: 6,
            backgroundColor: Colors.transparent,
            child: _dialogWithTextField(context),
          );
        });
  }

  Widget _dialogWithTextField(BuildContext context) => Container(
        height: 280,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 24),
            Text(
              'แพทย์ชันสูตร',
              textAlign: TextAlign.center,
              style: GoogleFonts.prompt(
                  textStyle: TextStyle(
                color: appbarBlue,
                letterSpacing: .5,
                fontSize: MediaQuery.of(context).size.height * 0.025,
              )),
            ),
            const SizedBox(height: 10),
            Padding(
                padding: EdgeInsets.only(
                    top: 10,
                    bottom: 10,
                    right: MediaQuery.of(context).size.height * 0.025,
                    left: MediaQuery.of(context).size.height * 0.025),
                child: TextFormField(
                  controller: investigatorDoctorController,
                  maxLines: null,
                  autofocus: true,
                  keyboardType: TextInputType.text,
                  style: GoogleFonts.prompt(
                      textStyle: TextStyle(
                    color: darkBlue,
                    letterSpacing: .5,
                    fontSize: MediaQuery.of(context).size.height * 0.02,
                  )),
                  decoration: InputDecoration(
                    labelText: '',
                    hintText: 'กรอกข้อมูลแพทย์ชันสูตร',
                    hintStyle: GoogleFonts.prompt(
                        textStyle: TextStyle(
                      color: Colors.grey,
                      letterSpacing: .5,
                      fontSize: MediaQuery.of(context).size.height * 0.02,
                    )),
                    labelStyle: GoogleFonts.prompt(
                        textStyle: TextStyle(
                      color: appbarBlue,
                      letterSpacing: .5,
                      fontSize: MediaQuery.of(context).size.height * 0.02,
                    )),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                )),
            const SizedBox(height: 20),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'ยกเลิก',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.prompt(
                        textStyle: TextStyle(
                      color: Colors.red,
                      letterSpacing: .5,
                      fontSize: MediaQuery.of(context).size.height * 0.02,
                    )),
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.height * 0.025),
                TextButton(
                  child: Text(
                    'บันทึก',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.prompt(
                        textStyle: TextStyle(
                      color: appbarBlue,
                      letterSpacing: .5,
                      fontSize: MediaQuery.of(context).size.height * 0.02,
                    )),
                  ),
                  onPressed: () {
                    saveImage(false);
                  },
                ),
              ],
            ),
          ],
        ),
      );
}

class SystemPadding extends StatelessWidget {
  final Widget child;

  const SystemPadding({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return AnimatedContainer(
        padding: mediaQuery.viewInsets / 4,
        duration: const Duration(milliseconds: 300),
        child: child);
  }
}
