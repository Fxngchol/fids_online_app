import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';

import '../../../../Utils/color.dart';
import '../../../../models/case_vehicle/CaseVehicle.dart';
import '../../../../models/case_vehicle/CaseVehicleDao.dart';
import 'add_third_tab.dart';

class ThirdTabPage extends StatefulWidget {
  final int? caseID, vehicleId;
  final String? caseNo, vehicleDetail;
  const ThirdTabPage(
      {super.key,
      required this.vehicleId,
      this.vehicleDetail,
      this.caseID,
      this.caseNo});
  @override
  ThirdTabPageState createState() => ThirdTabPageState();
}

class ThirdTabPageState extends State<ThirdTabPage> {
  bool isLoading = false;
  bool isPhone = Device.get().isPhone;
  Image? image;
  CaseVehicle caseVehicle = CaseVehicle();
  bool isEdit = false;

  @override
  void initState() {
    asyncCall();
    super.initState();
  }

  void asyncCall() async {
    var result =
        await CaseVehicleDao().getCaseVehicleById(widget.vehicleId.toString());
    setState(() {
      caseVehicle = result ?? CaseVehicle();
      caseVehicle.vehicleMap =
          caseVehicle.vehicleMap?.replaceAll("data:image/png;base64,", "");
      isLoading = false;
      if (caseVehicle.vehicleMap != null && caseVehicle.vehicleMap != '') {
        isEdit = true;
      } else {
        isEdit = false;
      }
      if (kDebugMode) {
        print('isEDIT ${caseVehicle.vehicleMap != null}');
        print('isEDIT ${caseVehicle.vehicleMap != ''}');
        print('isEDIT $isEdit');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SafeArea(
                child: Column(children: [
                vehicleDetail(),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'แผนผังรถของกลาง',
                      style: GoogleFonts.prompt(
                        textStyle: TextStyle(
                          color: Colors.white,
                          letterSpacing: .5,
                          fontSize: MediaQuery.of(context).size.height * 0.02,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        if (kDebugMode) {
                          print('widget.vehicleId ${widget.vehicleId}');
                        }
                        var result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddThirdTab(
                                    vehicleDetail: widget.vehicleDetail ?? '',
                                    vehicleId: widget.vehicleId ?? -1,
                                    caseID: widget.caseID ?? -1,
                                    caseNo: widget.caseNo ?? '',
                                    isEdit: caseVehicle.vehicleMap != '' &&
                                        caseVehicle.vehicleMap != null)));
                        if (result != null) {
                          asyncCall();
                        }
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.edit,
                            size: MediaQuery.of(context).size.height * 0.03,
                            color: Colors.white,
                          ),
                          Text(
                            'แก้ไข',
                            style: GoogleFonts.prompt(
                              textStyle: TextStyle(
                                color: Colors.white,
                                letterSpacing: .5,
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.02,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                spacer(context),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: caseVehicle.vehicleMap == null ||
                            caseVehicle.vehicleMap == ''
                        ? Container()
                        : Image.memory(
                            base64Decode(caseVehicle.vehicleMap ?? '')),
                  ),
                ),
              ])));
  }

  Widget spacer(context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.015,
    );
  }

  Widget vehicleDetail() {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.03,
              vertical: MediaQuery.of(context).size.width * 0.01),
          child: Text(
            '${widget.vehicleDetail}',
            textAlign: TextAlign.left,
            style: GoogleFonts.prompt(
              textStyle: TextStyle(
                color: textColor,
                letterSpacing: .5,
                fontSize: MediaQuery.of(context).size.height * 0.022,
              ),
            ),
          ),
        ),
      ),
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

  Widget detailView(String text) {
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    textAlign: TextAlign.left,
                    style: GoogleFonts.prompt(
                      textStyle: TextStyle(
                        color: textColor,
                        letterSpacing: .5,
                        fontSize: MediaQuery.of(context).size.height * 0.025,
                      ),
                    ),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
