import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Utils/color.dart';
import '../../models/CaseCategory.dart';
import '../../models/FidsCrimeScene.dart';
import '../../widget/app_bar_widget.dart';
import '../../widget/app_button.dart';
import '../../widget/text_field_widget.dart';

class FireResultPage extends StatefulWidget {
  final int? caseID;
  final String? caseNo;
  final bool isLocal;
  final bool isEdit;

  const FireResultPage(
      {super.key,
      this.caseID,
      this.caseNo,
      this.isLocal = false,
      this.isEdit = false});
  @override
  State<FireResultPage> createState() => _FireResultPageState();
}

class _FireResultPageState extends State<FireResultPage> {
  bool isPhone = Device.get().isPhone;
  bool isLoading = true;
  String? caseName;
  var fireSourceAreaCntl = TextEditingController();
  var fireFuelCntl = TextEditingController();
  var fireHeatSourceCntl = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      print(widget.isEdit);
    }
    asyncMethod();
  }

  asyncMethod() async {
    isLoading = true;
    if (kDebugMode) {
      print('caseID: ${widget.caseID}, caseNo: ${widget.caseNo}');
    }
    var fidsCrimescene =
        await FidsCrimeSceneDao().getFidsCrimeSceneById(widget.caseID ?? -1);
    await CaseCategoryDAO()
        .getCaseCategoryLabelByid(fidsCrimescene?.caseCategoryID ?? -1)
        .then((value) => caseName = value);
    setState(() {
      fireSourceAreaCntl.text = fidsCrimescene?.fireSourceArea ?? '';
      fireFuelCntl.text = fidsCrimescene?.fireFuel ?? '';
      fireHeatSourceCntl.text = fidsCrimescene?.fireHeatSource ?? '';
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBarWidget(
          title: 'สรุปผลการตรวจ',
          leading: IconButton(
              icon: isIOS
                  ? const Icon(Icons.arrow_back_ios)
                  : const Icon(Icons.arrow_back),
              onPressed: () async {
                Navigator.of(context).pop(true);
              }),
          actions: [
            Container(
              width: MediaQuery.of(context).size.width * 0.1,
            )
          ],
        ),
        body: _body());
  }

  Widget _body() {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/bgNew.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SafeArea(
                child: Container(
                    margin: isPhone
                        ? const EdgeInsets.all(32)
                        : const EdgeInsets.only(
                            left: 32, right: 32, top: 32, bottom: 32),
                    child: SingleChildScrollView(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        title(
                          title: 'บริเวณต้นเพลิง',
                        ),
                        InputField(
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.newline,
                            controller: fireSourceAreaCntl,
                            hint: 'กรอกบริเวณต้นเพลิง',
                            maxLine: null,
                            onChanged: (value) {}),
                        spacer(),
                        title(
                          title:
                              'เชื้อเพลิงที่ทำให้เกิดการลุกไหม้บริเวณต้นเพลิง',
                        ),
                        InputField(
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.newline,
                            controller: fireFuelCntl,
                            hint:
                                'กรอกเชื้อเพลิงที่ทำให้เกิดการลุกไหม้บริเวณต้นเพลิง',
                            maxLine: null,
                            onChanged: (value) {}),
                        spacer(),
                        title(
                          title: 'แหล่งความร้อนที่ทำให้เกิดเพลิงไหม้',
                        ),
                        InputField(
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.newline,
                            controller: fireHeatSourceCntl,
                            hint:
                                'กรอกเชื้อเพลิงที่ทำให้เกิดการลุกไหม้บริเวณต้นเพลิง',
                            maxLine: null,
                            onChanged: (value) {}),
                        spacer(),
                        saveButton()
                      ],
                    )))));
  }

  spacer() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.01,
    );
  }

  Widget title({title}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        '$title',
        textAlign: TextAlign.left,
        style: GoogleFonts.prompt(
          textStyle: TextStyle(
            color: Colors.white,
            letterSpacing: .5,
            fontSize: MediaQuery.of(context).size.height * 0.025,
          ),
        ),
      ),
    ]);
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
                fontSize: MediaQuery.of(context).size.height * 0.025,
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

  Widget saveButton() {
    return AppButton(
        color: pinkButton,
        textColor: Colors.white,
        text: 'บันทึก',
        onPressed: () async {
          await FidsCrimeSceneDao()
              .updateFireResult(fireSourceAreaCntl.text, fireFuelCntl.text,
                  fireHeatSourceCntl.text, widget.caseID.toString())
              .then((value) => Navigator.of(context).pop(true));
        });
  }
}
