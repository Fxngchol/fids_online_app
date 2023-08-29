import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/color.dart';
import '../../../widget/app_bar_widget.dart';

class Witness extends StatefulWidget {
  const Witness({super.key});

  @override
  WitnessState createState() => WitnessState();
}

class WitnessState extends State<Witness> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isPhone = Device.get().isPhone;
  String? caseName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(
          title: 'วัตถุพยาน',
          key: _scaffoldKey,
        ),
        body: Container(
            color: darkBlue,
            child: SafeArea(
                child: Container(
                    margin: isPhone
                        ? const EdgeInsets.all(32)
                        : const EdgeInsets.only(
                            left: 32, right: 32, top: 32, bottom: 32),
                    child: Column(
                      children: [
                        Flexible(child: headerView()),
                        Flexible(
                            child: Padding(
                          padding: const EdgeInsets.only(left: 12, right: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'รายการวัตถุพยาน',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.prompt(
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                    letterSpacing: .5,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.03,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  TextButton(
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.03,
                                        ),
                                        Text(
                                          'เพิ่ม',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.prompt(
                                            textStyle: TextStyle(
                                              color: Colors.white,
                                              letterSpacing: .5,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.03,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, '/addwitness');
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        )),
                        Expanded(
                          child: ListView.builder(
                              itemCount: 5,
                              itemBuilder: (BuildContext ctxt, int index) {
                                return _listItem(index);
                              }),
                        ),
                      ],
                    )))));
  }

  Widget headerView() {
    return Padding(
      padding: const EdgeInsets.only(left: 24, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'หมายเลขคดี',
            textAlign: TextAlign.center,
            style: GoogleFonts.prompt(
              textStyle: TextStyle(
                color: Colors.white,
                letterSpacing: .5,
                fontSize: MediaQuery.of(context).size.height * 0.025,
              ),
            ),
          ),
          Text(
            '01-63-00004-00',
            textAlign: TextAlign.center,
            style: GoogleFonts.prompt(
              textStyle: TextStyle(
                color: Colors.white,
                letterSpacing: .5,
                fontSize: MediaQuery.of(context).size.height * 0.03,
              ),
            ),
          ),
          Text(
            'ประเภทคดี $caseName',
            textAlign: TextAlign.center,
            style: GoogleFonts.prompt(
              textStyle: TextStyle(
                color: Colors.white,
                letterSpacing: .5,
                fontSize: MediaQuery.of(context).size.height * 0.025,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _listItem(index) {
    return Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              flex: 1,
              onPressed: (BuildContext context) {
                _displaySnackbar;
              },
              backgroundColor: Colors.red,
              icon: Icons.delete,
              label: 'ลบ',
            ),
          ],
        ),
        child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/showwitness');
            },
            child: Container(
              padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: isPhone ? 12 : 12,
                  top: isPhone ? 12 : 12),
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: fadePurple, borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'ป้ายหมายเลข',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.prompt(
                              textStyle: TextStyle(
                                color: Colors.white,
                                letterSpacing: .5,
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.02,
                              ),
                            ),
                            maxLines: 1,
                          ),
                          Container(
                            width: 50,
                            height: 50,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '$index',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.prompt(
                                textStyle: TextStyle(
                                  color: darkBlue,
                                  letterSpacing: .5,
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.035,
                                ),
                              ),
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.04),
                      Container(
                        width: 1,
                        height: MediaQuery.of(context).size.height * 0.1,
                        color: Colors.white60,
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.04),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'อาวุธมีด',
                                textAlign: TextAlign.left,
                                style: GoogleFonts.prompt(
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                    letterSpacing: .5,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.03,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'จำนวน 2',
                                textAlign: TextAlign.left,
                                style: GoogleFonts.prompt(
                                  textStyle: TextStyle(
                                    color: Colors.white60,
                                    letterSpacing: .5,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.025,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white60,
                    size: MediaQuery.of(context).size.height * 0.02,
                  )
                ],
              ),
            )));
  }

  void get _displaySnackbar {
    if (kDebugMode) {
      print('removing');
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(milliseconds: 300),
        content: Text(
          'ลบสำเร็จ',
          textAlign: TextAlign.center,
          style: GoogleFonts.prompt(
            textStyle: TextStyle(
              color: Colors.white,
              letterSpacing: .5,
              fontSize: MediaQuery.of(context).size.height * 0.02,
            ),
          ),
        )));
  }
}
