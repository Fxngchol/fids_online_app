import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_painter/image_painter.dart';
import 'package:screenshot/screenshot.dart';

import '../../../Utils/color.dart';
import '../../../models/DiagramLocation.dart';
import '../../../widget/app_bar_widget.dart';
import '../../../widget/blurry_dialog.dart';

class PlanCase extends StatefulWidget {
  final int? caseID;
  final String? caseNo;
  final bool isLocal;
  final bool isUpdate;
  final bool isEdit;
  const PlanCase(
      {super.key,
      this.caseID,
      this.caseNo,
      this.isLocal = false,
      this.isUpdate = false,
      this.isEdit = false});

  @override
  PlanCaseState createState() => PlanCaseState();
}

class PlanCaseState extends State<PlanCase> {
  bool isLoading = false, isClear = false;
  Image? image;
  bool isPhone = Device.get().isPhone;
  ScreenshotController screenshotController = ScreenshotController();
  final TextEditingController _diagramRemarkController =
      TextEditingController();
  DiagramLocation diagramLocation = DiagramLocation();
  final _imageKey = GlobalKey<ImagePainterState>();
  // bool isClearBG = false;
  Uint8List uint8list = Uint8List(0);

  @override
  void initState() {
    super.initState();
    widget.isUpdate ? asyncMethod() : isLoading = false;
  }

  void asyncCall1() async {
    isLoading = true;
    var result =
        await DiagramLocationDao().getDiagramLocation('${widget.caseID}');
    setState(() {
      diagramLocation = result;
      _diagramRemarkController.text = diagramLocation.diagramRemark ?? '';
      diagramLocation.diagram = diagramLocation.diagram;
      isLoading = false;
    });
  }

  asyncMethod() async {
    asyncCall1();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBarWidget(
          title: 'แผนผังสังเขป',
          actions: [
            TextButton(
                onPressed: () {
                  _displayDialog();
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Text(
                    'บันทึก',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.prompt(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: isPhone
                            ? MediaQuery.of(context).size.height * 0.01
                            : MediaQuery.of(context).size.height * 0.02,
                      ),
                    ),
                  ),
                )),
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
                      base64Decode(diagramLocation.diagram
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
                  : ImagePainter.asset("images/diagram.png",
                      key: _imageKey, scalable: false)),
        ));
  }

  Widget spacer(context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.015,
    );
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

  void saveImage(bool isClearAll) async {
    if (isClearAll == false) {
      await _imageKey.currentState?.exportImage().then((image) {
        String base64Image = '';
        if (image != null) {
          base64Image = base64.encode(image);
        }
        diagramLocation.diagram = 'data:image/png;base64,$base64Image';
        diagramLocation.diagramRemark = _diagramRemarkController.text;
        widget.isUpdate
            ? DiagramLocationDao().updateLocationCase(
                diagramLocation.diagram ?? '',
                diagramLocation.diagramRemark ?? '',
                int.parse(diagramLocation.id ?? ''))
            : DiagramLocationDao().createDiagramLocation(
                diagramLocation.diagram ?? '',
                diagramLocation.diagramRemark ?? '',
                widget.caseID ?? -1);
        Navigator.of(context).pop();
        Navigator.of(context).pop(true);
      });
    } else {
      diagramLocation.diagram = '';
      diagramLocation.diagramRemark = _diagramRemarkController.text;
      DiagramLocationDao().updateLocationCase(
          diagramLocation.diagram ?? '',
          diagramLocation.diagramRemark ?? '',
          int.parse(diagramLocation.id ?? ''));
      Navigator.of(context).pop(true);
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
              'หมายเหตุ',
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
                  controller: _diagramRemarkController,
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
                    hintText: 'กรอกหมายเหตุ',
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
