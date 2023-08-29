// ignore_for_file: file_names

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/color.dart';
import '../../../models/CaseCategory.dart';
import '../../../models/CaseImage.dart';
import '../../../models/FidsCrimeScene.dart';
import '../../../widget/app_bar_widget.dart';
import 'add_case_image.dart';
import 'case_image_detail.dart';

class CaseImage extends StatefulWidget {
  final int? caseID;
  final String? caseNo;
  final bool isLocal;

  const CaseImage({super.key, this.caseID, this.caseNo, this.isLocal = false});

  @override
  CaseImageState createState() => CaseImageState();
}

class CaseImageState extends State<CaseImage> {
  bool isPhone = Device.get().isPhone;
  List<CaseImages> caseImageList = [];
  bool isLoading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? caseName;
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    Future.delayed(const Duration(milliseconds: 500), () async {
      await CaseImagesDao().getCaseImages(widget.caseID ?? -1).then((value) {
        setState(() {
          caseImageList = value;
          if (kDebugMode) {
            print(caseImageList.toString());
          }
        });
      });
      setState(() {
        isLoading = false;
      });
    });
    var result =
        await FidsCrimeSceneDao().getFidsCrimeSceneById(widget.caseID ?? -1);
    await CaseCategoryDAO()
        .getCaseCategoryLabelByid(result?.caseCategoryID ?? -1)
        .then((value) => caseName = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        extendBodyBehindAppBar: true,
        appBar: AppBarWidget(
          title: 'รูปภาพ',
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                  padding: EdgeInsets.fromLTRB(
                      0, 0, MediaQuery.of(context).size.height * 0.025, 0)),
              child: Icon(Icons.add_a_photo,
                  color: Colors.white,
                  size: MediaQuery.of(context).size.height * 0.025),
              onPressed: () async {
                var result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddCaseImage(
                              caseID: widget.caseID ?? -1,
                              isEdit: false,
                            )));
                if (result != null) {
                  if (kDebugMode) {
                    print('isBack');
                  }
                  await getData();
                }
              },
            )
          ],
        ),
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/bgNew.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Container(
                        margin: isPhone
                            ? const EdgeInsets.all(32)
                            : const EdgeInsets.only(
                                left: 32, right: 32, top: 32, bottom: 32),
                        child: contentView()))));
  }

  contentView() {
    return SizedBox(
        width: MediaQuery.of(context).size.width, child: listView());
  }

  listView() {
    return caseImageList.isNotEmpty
        ? ListView.builder(
            itemCount: caseImageList.length,
            itemBuilder: (BuildContext context, index) {
              return _listItem(index);
            })
        : Center(
            child: Text(
              'ไม่มีข้อมูล',
              textAlign: TextAlign.center,
              style: GoogleFonts.prompt(
                textStyle: TextStyle(
                  color: Colors.white,
                  letterSpacing: .5,
                  fontSize: MediaQuery.of(context).size.height * 0.02,
                ),
              ),
            ),
          );
  }

  Widget headerView() {
    return Padding(
      padding: const EdgeInsets.only(left: 24, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            'หมายเลขคดี',
            textAlign: TextAlign.center,
            style: GoogleFonts.prompt(
              textStyle: TextStyle(
                color: Colors.white,
                letterSpacing: .5,
                fontSize: MediaQuery.of(context).size.height * 0.02,
              ),
            ),
          ),
          Text(
            '${widget.caseNo}',
            textAlign: TextAlign.center,
            style: GoogleFonts.prompt(
              textStyle: TextStyle(
                color: Colors.white,
                letterSpacing: .5,
                fontSize: MediaQuery.of(context).size.height * 0.02,
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
                fontSize: MediaQuery.of(context).size.height * 0.02,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _listItem(int index) {
    if (kDebugMode) {
      print(caseImageList[index].imageFile);
    }
    return Slidable(
      endActionPane: ActionPane(
        extentRatio: 0.3,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            flex: 1,
            onPressed: (BuildContext context) {
              _displaySnackbar(index);
            },
            backgroundColor: Colors.red,
            icon: Icons.delete,
            label: 'ลบ',
          ),
        ],
      ),
      child: GestureDetector(
          onTap: () async {
            var result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CaseImageDetail(widget.caseID ?? -1,
                        int.parse(caseImageList[index].id ?? ''))));
            if (result) {
              getData();
            }
          },
          child: Container(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, bottom: 12, top: 12),
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(8)),
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                caseImageList[index].imageFile != ''
                    ? Container(
                        margin: const EdgeInsets.only(left: 12),
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: MediaQuery.of(context).size.height * 0.3,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: Image.memory(
                              base64Decode(
                                caseImageList[index].imageFile?.replaceAll(
                                        "data:image/png;base64,", "") ??
                                    '',
                              ),
                              fit: BoxFit.cover),
                        ),
                      )
                    : SizedBox(
                        width: MediaQuery.of(context).size.height * 0.3,
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.photo_library,
                                size: MediaQuery.of(context).size.height * 0.1,
                                color: Colors.grey,
                              ),
                              Text(
                                'ไม่พบรูปภาพ',
                                textAlign: TextAlign.left,
                                style: GoogleFonts.prompt(
                                  textStyle: TextStyle(
                                    color: textColor,
                                    letterSpacing: .5,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.02,
                                  ),
                                ),
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                      ),
                Expanded(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    margin: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'คำอธิบาย',
                          textAlign: TextAlign.left,
                          style: GoogleFonts.prompt(
                            textStyle: TextStyle(
                              color: textColor,
                              letterSpacing: .5,
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.02,
                            ),
                          ),
                          maxLines: 1,
                        ),
                        Text(
                          '${caseImageList[index].imageDetail != '' || caseImageList[index].imageDetail != null ? caseImageList[index].imageDetail : ''}',
                          textAlign: TextAlign.justify,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.prompt(
                            textStyle: TextStyle(
                              color: textColor,
                              letterSpacing: .5,
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.022,
                            ),
                          ),
                          maxLines: 5,
                        ),
                      ],
                    ),
                  ),
                )
              ]))),
    );
  }

  void _displaySnackbar(int index) async {
    setState(() {
      isLoading = true;
    });
    await CaseImagesDao()
        .deleteCaseImages(caseImageList[index].id)
        .then((value) {
      getData();
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
      setState(() {
        isLoading = false;
      });
    });
  }
}
