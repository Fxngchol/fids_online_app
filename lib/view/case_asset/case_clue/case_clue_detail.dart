import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../Utils/color.dart';
import '../../../models/CaseClue.dart';
import '../../../widget/app_bar_widget.dart';
import 'add_case_clue.dart';

class CaseClueDetail extends StatefulWidget {
  final int? caseID;
  final String? caseClueID;
  const CaseClueDetail({super.key, this.caseID, this.caseClueID});

  @override
  CaseClueDetailState createState() => CaseClueDetailState();
}

class CaseClueDetailState extends State<CaseClueDetail> {
  bool isPhone = Device.get().isPhone;
  bool isLoading = false;
  bool isLandscape = false;
  CaseClue? caseClue;
  int caseClueValue = -1;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    await CaseClueDao().getCaseClueById(widget.caseClueID ?? '').then((value) {
      setState(() {
        caseClue = value;
      });
      try {
        caseClueValue = int.parse(value?.caseClueId ?? '');
      } catch (e) {
        caseClueValue = 0;
      }
    });

    if (kDebugMode) {
      print(caseClue);
    }
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
          title: 'ทางเข้าของคนร้าย',
          leading: IconButton(
            icon: isIOS
                ? const Icon(Icons.arrow_back_ios)
                : const Icon(Icons.arrow_back),
            onPressed: () async {
              Navigator.of(context).pop(true);
            },
          ),
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
                        builder: (context) => AddCaseClue(
                            caseID: widget.caseID ?? -1,
                            isEdit: true,
                            caseClueID: widget.caseClueID)));
                if (result) {
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
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            detailView(caseClue?.isoIsClue == '1'
                ? 'พบร่องรอย'
                : caseClue?.isoIsClue == '2'
                    ? 'ไม่พบร่องรอยใดๆ บริเวณสถานที่เกิดเหตุ'
                    : 'ผู้เสียหายไม่ได้ทำการปิดล็อคประตู/หน้าต่าง'),
            spacer(),
            caseClue?.isoIsClue == '3' ? header('รายละเอียด') : Container(),
            caseClue?.isoIsClue == '3'
                ? detailView(caseClue?.villainEntrance)
                : Container(),
            caseClue?.isoIsClue == '3' ? spacer() : Container(),
            caseClue?.isoIsClue == '1' ? isClueView() : Container()
          ],
        ),
      ),
    );
  }

  isClueView() {
    return Column(
      children: [
        clueTypeView(),
        spacer(),
        detailView(caseClue?.clueTypeDetail),
        spacer(),
        header('ที่'),
        spacer(),
        checkbox('ประตู', caseClue?.isDoor == '1' ? true : false, (_) {}),
        spacer(),
        detailView(caseClue?.doorDetail),
        spacer(),
        spacer(),
        checkbox('หน้าต่าง', caseClue?.isWindows == '1' ? true : false, (_) {}),
        spacer(),
        detailView(caseClue?.windowsDetail),
        spacer(),
        checkbox('ฝ้าเพดาน', caseClue?.isCelling == '1' ? true : false, (_) {}),
        spacer(),
        detailView(caseClue?.cellingDetail),
        spacer(),
        checkbox('หลังคา', caseClue?.isRoof == '1' ? true : false, (_) {}),
        spacer(),
        detailView(caseClue?.roofDetail),
        spacer(),
        checkbox('อื่นๆ', caseClue?.isClueOther == '1' ? true : false, (_) {}),
        spacer(),
        detailView(caseClue?.clueOtherDetail),
        spacer(),
        header('เครื่องมือที่คนร้ายใช้ในการโจรกรรม'),
        spacer(),
        checkbox('ไขควง', caseClue?.isTools1 == '1' ? true : false, (_) {}),
        spacer(),
        checkbox('ชะแลง', caseClue?.isTools2 == '1' ? true : false, (_) {}),
        spacer(),
        checkbox(
            'คีมตัดโลหะ', caseClue?.isTools3 == '1' ? true : false, (_) {}),
        spacer(),
        checkbox('อื่นๆ', caseClue?.isTools4 == '1' ? true : false, (_) {}),
        spacer(),
        detailView(caseClue?.tools4Detail),
        spacer(),
        header('ขนาดความกว้างของรอยประมาณ'),
        spacer(),
        detailView('${_cleanText(caseClue?.width)} ${caseClue?.widthUnitID}'),
      ],
    );
  }

  spacer() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.01,
    );
  }

  checkbox(String? text, bool isChecked, Function onChanged) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Transform.scale(
        scale: 1.7,
        child: Checkbox(
            value: isChecked,
            checkColor: Colors.white,
            activeColor: pinkButton,
            onChanged: (str) {
              onChanged(str);
            }),
      ),
      SizedBox(width: MediaQuery.of(context).size.width * 0.02),
      Flexible(
        child: Text(
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
      ),
    ]);
  }

  Widget detailView(String? text) {
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
                    '$text',
                    textAlign: TextAlign.left,
                    style: GoogleFonts.prompt(
                      textStyle: TextStyle(
                        color: textColor,
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

  Widget header(String? title) {
    return Row(
      children: [
        Text(
          title ?? '',
          style: GoogleFonts.prompt(
            textStyle: TextStyle(
              color: Colors.white,
              letterSpacing: 0.5,
              fontSize: MediaQuery.of(context).size.height * 0.03,
            ),
          ),
        ),
      ],
    );
  }

  String? _cleanText(String? text) {
    try {
      if (text == null ||
          text == '' ||
          text == 'null' ||
          text == 'Null' ||
          text == '-1') {
        return '';
      } else {
        return text;
      }
    } catch (ex) {
      return '';
    }
  }

  clueTypeView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Transform.scale(
              scale: 1.2,
              child: Radio(
                  value: 1,
                  activeColor: pinkButton,
                  groupValue: caseClueValue,
                  onChanged: (_) {}),
            ),
            Text(
              'การงัด',
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Transform.scale(
              scale: 1.2,
              child: Radio(
                  value: 2,
                  activeColor: pinkButton,
                  groupValue: caseClueValue,
                  onChanged: (_) {}),
            ),
            Text(
              'การตัด',
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Transform.scale(
              scale: 1.2,
              child: Radio(
                value: 3,
                activeColor: pinkButton,
                groupValue: caseClueValue,
                onChanged: (_) {},
              ),
            ),
            Text(
              'การเจาะ',
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Transform.scale(
              scale: 1.2,
              child: Radio(
                value: 4,
                activeColor: pinkButton,
                groupValue: caseClueValue,
                onChanged: (_) {},
              ),
            ),
            Text(
              'ร่องรอยอื่นๆ',
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
    );
  }
}
