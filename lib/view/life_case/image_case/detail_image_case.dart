import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/color.dart';
import '../../../widget/app_bar_widget.dart';

class DetailImageCase extends StatefulWidget {
  const DetailImageCase({super.key});

  @override
  DetailImageCaseState createState() => DetailImageCaseState();
}

class DetailImageCaseState extends State<DetailImageCase> {
  bool isPhone = Device.get().isPhone;

  @override
  Widget build(BuildContext context) {
    bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    return Scaffold(
        appBar: AppBarWidget(
          leading: IconButton(
            icon: isIOS
                ? const Icon(Icons.arrow_back_ios)
                : const Icon(Icons.arrow_back),
            onPressed: () async {
              Navigator.of(context).pop(true);
            },
          ),
          title: 'รูปภาพ',
          actions: [
            // ignore: deprecated_member_use
            TextButton(
              child: const Icon(
                Icons.edit,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/addimagecase');
              },
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
                      Container(
                        color: fadePurple,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width * 0.4,
                                height: MediaQuery.of(context).size.width * 0.4,
                                child: const Icon(
                                  Icons.image,
                                  size: 100,
                                )),
                          ],
                        ),
                      ),
                      spacer(context),
                      header('รหัสภาพ'),
                      spacer(context),
                      detailView('001'),
                      radioView(),
                      spacer(context),
                      header('คำอธิบาย'),
                      spacer(context),
                      detailView('-'),
                      spacer(context),
                      header('หมายเหตุ'),
                      spacer(context),
                      detailView('-'),
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
                        onChanged: (v) {
                          _handleRadioValueChange(v ?? -1);
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
                        onChanged: (v) {
                          _handleRadioValueChange(v ?? -1);
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
}
