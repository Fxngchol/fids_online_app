import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/color.dart';
import '../../../models/FidsCrimeScene.dart';
import '../../../widget/app_bar_widget.dart';
import '../../../widget/app_button.dart';
import '../../../widget/text_field_widget.dart';

class EditCaseCasualtyDeceased extends StatefulWidget {
  final int? caseID;
  final String? caseNo;

  const EditCaseCasualtyDeceased({super.key, this.caseID, this.caseNo});

  @override
  EditCaseCasualtyDeceasedState createState() =>
      EditCaseCasualtyDeceasedState();
}

class EditCaseCasualtyDeceasedState extends State<EditCaseCasualtyDeceased> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isPhone = Device.get().isPhone;
  bool isoIsCasualty = false;
  bool isoIsDeceased = false;
  final TextEditingController _isoCasualtyDetailController =
      TextEditingController();

  FidsCrimeScene? data;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    asyncMethod();
  }

  asyncMethod() async {
    asyncCall1();
    setState(() {
      isLoading = false;
    });
  }

  void asyncCall1() async {
    var result =
        await FidsCrimeSceneDao().getFidsCrimeSceneById(widget.caseID ?? -1);

    setState(() {
      data = result;
      if (data?.isoIscasualty == '1') {
        isoIsCasualty = true;
      }

      if (data?.isoIsDeceased == '1') {
        isoIsDeceased = true;
      }

      _isoCasualtyDetailController.text = data?.isoCasualtyDetail ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      extendBodyBehindAppBar: true,
      appBar: AppBarWidget(
        title: 'ผู้บาดเจ็บ/ผู้เสียชีวิต',
        actions: [
          Container(
            width: MediaQuery.of(context).size.width * 0.1,
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
              ? const Center(child: CircularProgressIndicator())
              : Container(
                  margin: isPhone
                      ? const EdgeInsets.all(32)
                      : const EdgeInsets.only(
                          left: 32, right: 32, top: 32, bottom: 32),
                  child: ListView(
                    children: [
                      headerView(),
                      tabIsoIsCasualty('ผู้บาดเจ็บ'),
                      spacer(),
                      tabIsoIsDeceased('ผู้เสียชีวิต'),
                      spacer(),
                      spacer(),
                      title('ลักษณะ/ตำแหน่ง/จำนวนของบาดแผล'),
                      spacer(),
                      InputField(
                          maxLine: 5,
                          isEnabled: true,
                          controller: _isoCasualtyDetailController,
                          hint: 'กรอกรายละเอียด',
                          onChanged: (_) {}),
                      spacer(),
                      saveButton()
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget saveButton() {
    return Padding(
        padding:
            EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
        child: AppButton(
            color: pinkButton,
            textColor: Colors.white,
            text: 'บันทึก',
            onPressed: () {
              var variable1 = '2';
              if (isoIsCasualty) {
                variable1 = '1';
              }

              var variable2 = '2';
              if (isoIsDeceased) {
                variable2 = '1';
              }
              FidsCrimeSceneDao().updateCasualtyDeceased(variable1, variable2,
                  _isoCasualtyDetailController.text, '${widget.caseID}');
              setState(() {
                isLoading = false;
              });
              Navigator.of(context).pop(true);
            }));
  }

  Widget title(String? title) {
    return Row(
      children: [
        Text(
          title ?? '',
          style: GoogleFonts.prompt(
            textStyle: TextStyle(
              color: Colors.white,
              letterSpacing: 0.5,
              fontSize: MediaQuery.of(context).size.height * 0.028,
            ),
          ),
        ),
      ],
    );
  }

  Widget tabIsoIsDeceased(String? text) {
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Transform.scale(
                      scale: 2.0,
                      child: Checkbox(
                        checkColor: Colors.greenAccent,
                        activeColor: Colors.red,
                        value: isoIsDeceased,
                        onChanged: (value) {
                          setState(() {
                            isoIsDeceased = value ?? false;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
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
              ],
            ),
          ],
        ),
      ),
    );
  }

  spacer() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.01,
    );
  }

  Widget tabIsoIsCasualty(String? text) {
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Transform.scale(
                      scale: 2.0,
                      child: Checkbox(
                        checkColor: Colors.greenAccent,
                        activeColor: Colors.red,
                        value: isoIsCasualty,
                        onChanged: (value) {
                          setState(() {
                            isoIsCasualty = value ?? false;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
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
              ],
            ),
          ],
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
            'ประเภทคดี : ทรัพย์',
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
}
