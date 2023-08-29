import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/color.dart';
import '../../../models/CaseCategory.dart';
import '../../../models/FidsCrimeScene.dart';
import '../../../models/case_vehicle/CaseVehicleOpinion.dart';
import '../../../widget/app_bar_widget.dart';
import '../../../widget/app_button.dart';

class AddOpinionPage extends StatefulWidget {
  final int? caseID;
  final int? opinionID;
  final String? caseNo;
  final bool isLocal;
  final bool isEdit;

  const AddOpinionPage(
      {super.key,
      required this.caseID,
      this.caseNo,
      this.isLocal = false,
      this.isEdit = false,
      this.opinionID});
  @override
  State<AddOpinionPage> createState() => AddOpinionPageState();
}

class AddOpinionPageState extends State<AddOpinionPage> {
  bool isPhone = Device.get().isPhone;
  bool isLoading = true;
  String? caseName;
  var caseOpinionCntl = TextEditingController();
  FocusNode focusNode = FocusNode();
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
    if (widget.isEdit) {
      var caseVehicleOpinion = await CaseVehicleOpinionDao()
          .getCaseVehicleOpinionById(widget.opinionID ?? -1);
      setState(() {
        caseOpinionCntl.text = caseVehicleOpinion?.opinion ?? '';
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBarWidget(
          title: 'รายละเอียดความเห็น',
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
    var maxLines = 30;
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
                            Text(
                              'ความเห็น',
                              textAlign: TextAlign.left,
                              style: GoogleFonts.prompt(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  letterSpacing: .5,
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.025,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top:
                                      MediaQuery.of(context).size.height * 0.01,
                                  bottom: MediaQuery.of(context).size.height *
                                      0.025),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: whiteOpacity,
                                ),
                                child: SizedBox(
                                  // height: maxLines * 50.0,
                                  child: TextField(
                                    controller: caseOpinionCntl,
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.only(
                                          left: 20,
                                          right: 20,
                                          top: 16,
                                          bottom: 16),
                                      focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.transparent,
                                        ),
                                      ),
                                      border: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.transparent,
                                        ),
                                      ),
                                      enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.transparent,
                                        ),
                                      ),
                                      hintText: 'กรอกความเห็น',
                                      hintStyle: GoogleFonts.prompt(
                                        textStyle: TextStyle(
                                          color: textColorHint,
                                          letterSpacing: 0.5,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.02,
                                        ),
                                      ),
                                    ),
                                    keyboardType: TextInputType.multiline,
                                    maxLines: maxLines,
                                  ),
                                ),
                              ),
                            ),
                            saveButton()
                          ]),
                    ))));
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
          if (kDebugMode) {
            print('1 ${caseOpinionCntl.text}');
          }
          if (widget.isEdit) {
            await CaseVehicleOpinionDao()
                .updateCaseVehicleOpinions(
                    widget.opinionID ?? -1, caseOpinionCntl.text)
                .then((value) => Navigator.of(context).pop(true));
          } else {
            await CaseVehicleOpinionDao()
                .createCaseVehicleOpinion(
                    widget.caseID.toString(), caseOpinionCntl.text)
                .then((value) => Navigator.of(context).pop(true));
          }
        });
  }
}
