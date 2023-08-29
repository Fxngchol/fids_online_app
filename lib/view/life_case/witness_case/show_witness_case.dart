import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/color.dart';
import '../../../widget/app_bar_widget.dart';

class ShowWitnessCase extends StatefulWidget {
  const ShowWitnessCase({super.key});

  @override
  ShowWitnessCaseState createState() => ShowWitnessCaseState();
}

class ShowWitnessCaseState extends State<ShowWitnessCase> {
  bool isPhone = Device.get().isPhone;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(
          title: 'วัตถุพยาน',
          actions: [
            TextButton(
              child: const Icon(
                Icons.edit,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/addwitness');
              },
            )
            // Container(
            //   width: MediaQuery.of(context).size.width * 0.1,
            // )
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
                      header('วัตถุพยาน'),
                      spacer(context),
                      detailView('มีด'),
                      spacer(context),
                      header('ป้ายหมายเลข'),
                      spacer(context),
                      detailView('1'),
                      spacer(context),
                      header('จำนวน'),
                      spacer(context),
                      detailView('2'),
                      spacer(context),
                      header('บริเวณที่ตรวจพบ'),
                      spacer(context),
                      detailView('หน้าอาคาร'),
                      spacer(context),
                      header('วันเวลาที่ตรวจเก็บวัตถุพยาน'),
                      spacer(context),
                      detailView('12/12/2020'),
                      spacer(context),
                      detailView('12:12'),
                      spacer(context),
                      header('บรรจุหีบห่อ'),
                      spacer(context),
                      detailView('item2'),
                      spacer(context),
                      header('การดำเนินการ'),
                      detailView('item2'),
                      spacer(context),
                      header('หมายเหตุ'),
                      spacer(context),
                      detailView('-'),
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

  Widget detailView(String? text) {
    return Container(
      color: appbarBlue,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
