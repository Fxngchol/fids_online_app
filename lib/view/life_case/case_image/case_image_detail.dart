import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/color.dart';
import '../../../models/CaseImage.dart';
import '../../../widget/app_bar_widget.dart';
import 'add_case_image.dart';

class CaseImageDetail extends StatefulWidget {
  final int? caseID;
  final int? caseImageId;

  const CaseImageDetail(this.caseID, this.caseImageId, {super.key});

  @override
  CaseImageDetailState createState() => CaseImageDetailState();
}

class CaseImageDetailState extends State<CaseImageDetail> {
  bool isPhone = Device.get().isPhone;
  bool isLoading = false;
  CaseImages? caseImage;
  bool isLandscape = false;

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    Future.delayed(const Duration(milliseconds: 500), () async {
      await CaseImagesDao()
          .getCaseImagesById(widget.caseID ?? -1, widget.caseImageId ?? -1)
          .then((value) async {
        if (kDebugMode) {
          print('fong $value');
        }

        setState(() {
          caseImage = value;
          if (kDebugMode) {
            print(caseImage.toString());
          }
        });
        if (value.imageFile != null && value.imageFile != '') {
          await checkLandscape(
              value.imageFile?.replaceAll("data:image/png;base64,", ""));
        }
      });
      setState(() {
        isLoading = false;
      });
    });
  }

  Future<void> checkLandscape(base64image) async {
    Uint8List bytes = base64.decode(base64image);
    var decodedImage = await decodeImageFromList(bytes);
    if (decodedImage.width > decodedImage.height) {
      isLandscape = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    return Scaffold(
        extendBodyBehindAppBar: true,
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
            TextButton(
              style: TextButton.styleFrom(
                  padding: EdgeInsets.fromLTRB(
                      0, 0, MediaQuery.of(context).size.height * 0.025, 0)),
              child: Icon(Icons.edit,
                  color: Colors.white,
                  size: MediaQuery.of(context).size.height * 0.025),
              onPressed: () async {
                var result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddCaseImage(
                            caseID: widget.caseID ?? -1,
                            isEdit: true,
                            caseImageId: widget.caseImageId)));
                if (result) {
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
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: caseImage?.imageFile != '' && caseImage?.imageFile != null
                  ? SizedBox(
                      height: isLandscape
                          ? MediaQuery.of(context).size.height * 0.45
                          : MediaQuery.of(context).size.height * 0.7,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: Image.memory(
                            base64Decode(
                              caseImage?.imageFile?.replaceAll(
                                      "data:image/png;base64,", "") ??
                                  '',
                            ),
                            fit: BoxFit.fitWidth),
                      ))
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
                                  color: Colors.white,
                                  letterSpacing: .5,
                                  fontSize:
                                      MediaQuery.of(context).size.height * 0.02,
                                ),
                              ),
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
            const Divider(),
            Text('คำอธิบาย',
                style: GoogleFonts.prompt(
                  textStyle: TextStyle(
                    color: Colors.white,
                    letterSpacing: 0.5,
                    fontSize: MediaQuery.of(context).size.height * 0.025,
                  ),
                )),
            const Divider(),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: whiteOpacity, borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 24, right: 24, top: 12, bottom: 12),
                child: Text(
                  caseImage?.imageDetail ?? '',
                  maxLines: null,
                  style: GoogleFonts.prompt(
                    textStyle: TextStyle(
                      color: textColor,
                      letterSpacing: 0.5,
                      fontSize: MediaQuery.of(context).size.height * 0.025,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
