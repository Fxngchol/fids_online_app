import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_painter/image_painter.dart';
import 'package:screenshot/screenshot.dart';

import '../../../../models/case_vehicle/CaseVehicle.dart';
import '../../../../models/case_vehicle/CaseVehicleDao.dart';
import '../../../../widget/app_bar_widget.dart';
import '../../../../widget/blurry_dialog.dart';

class AddThirdTab extends StatefulWidget {
  final int? caseID, vehicleId;
  final String? caseNo, vehicleDetail;
  final bool isEdit;
  const AddThirdTab({
    super.key,
    this.vehicleId,
    this.vehicleDetail,
    this.caseID,
    this.caseNo,
    this.isEdit = false,
  });

  @override
  State<AddThirdTab> createState() => _AddThirdTabState();
}

class _AddThirdTabState extends State<AddThirdTab> {
  bool isLoading = false, isClear = false;
  bool isPhone = Device.get().isPhone;
  ScreenshotController screenshotController = ScreenshotController();
  CaseVehicle caseVehicle = CaseVehicle();
  final _imageKey = GlobalKey<ImagePainterState>();
  Uint8List uint8list = Uint8List(0);

  @override
  void initState() {
    if (kDebugMode) {
      print(widget.vehicleId);
    }
    widget.isEdit ? asyncMethod() : isLoading = false;
    super.initState();
  }

  void asyncCall1() async {
    isLoading = true;
    var result =
        await CaseVehicleDao().getCaseVehicleById('${widget.vehicleId}');
    setState(() {
      caseVehicle = result ?? CaseVehicle();
      caseVehicle.vehicleMap = result?.vehicleMap ?? '';
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
          title: 'แผนผังรถของกลาง',
          actions: [
            TextButton(
                onPressed: () {
                  saveImage(false);
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
                      base64Decode(caseVehicle.vehicleMap!
                          .replaceAll("data:image/png;base64,", "")),
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

  Widget header(String text) {
    return Text(
      text,
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
      await _imageKey.currentState?.exportImage().then((image) async {
        final base64Image = base64.encode(image as List<int>);
        caseVehicle.vehicleMap = 'data:image/png;base64,$base64Image';
        await CaseVehicleDao()
            .updateCaseVehicleMap(
                int.parse(widget.vehicleId.toString()), caseVehicle.vehicleMap)
            .then((value) => Navigator.of(context).pop(true));
      });
    } else {
      caseVehicle.vehicleMap = '';
      CaseVehicleDao()
          .updateCaseVehicleMap(
              int.parse(widget.vehicleId.toString()), caseVehicle.vehicleMap)
          .then((value) => Navigator.of(context).pop(true));
    }
  }
}
