import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/color.dart';
import '../../../models/CaseCategory.dart';
import '../../../models/FidsCrimeScene.dart';
import '../../../widget/app_bar_widget.dart';
import 'detail_image_case.dart';

// ignore: must_be_immutable
class Imagecase extends StatefulWidget {
  int caseID;
  Imagecase(this.caseID, {super.key});

  @override
  ImagecaseState createState() => ImagecaseState();
}

class ImagecaseState extends State<Imagecase> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isPhone = Device.get().isPhone;
  String? caseName;

  @override
  void initState() {
    getCaseName();
    super.initState();
  }

  getCaseName() async {
    var result = await FidsCrimeSceneDao().getFidsCrimeSceneById(widget.caseID);

    await CaseCategoryDAO()
        .getCaseCategoryLabelByid(result?.caseCategoryID ?? -1)
        .then((value) => caseName = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBarWidget(
          title: 'รายการรูปภาพ',
          actions: [
            // ignore: deprecated_member_use
            TextButton(
              child: const Icon(
                Icons.add_a_photo,
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
                    child: ListView.builder(
                        itemCount: 2 + 1,
                        itemBuilder: (BuildContext ctxt, int index) {
                          if (index == 0) {
                            return headerView();
                          }
                          return _listItem(index);
                        })))));
  }

  Widget headerView() {
    return Padding(
      padding: const EdgeInsets.only(left: 24, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            'รหัสภาพ :',
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
            'ประเภทคดี : $caseName',
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
        extentRatio: 0.3,
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
        onTap: () async {
          var result = await Navigator.push(context,
              MaterialPageRoute(builder: (context) => const DetailImageCase()));
          if (result) {
            setState(() async {
              // await getCaseName();
            });
          }
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
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            'รหัสภาพ : 00$index',
                            textAlign: TextAlign.left,
                            style: GoogleFonts.prompt(
                              textStyle: TextStyle(
                                color: Colors.white,
                                letterSpacing: .5,
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.025,
                              ),
                            ),
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width * 0.3,
                            height: MediaQuery.of(context).size.width * 0.3,
                            child: const Icon(
                              Icons.image,
                              size: 100,
                            ))
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void get _displaySnackbar {
    if (kDebugMode) {
      print('removing');
    }
    // ignore: deprecated_member_use
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
