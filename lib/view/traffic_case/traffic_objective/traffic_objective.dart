import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/color.dart';
import '../../../models/FidsCrimeScene.dart';
import '../../../widget/app_bar_widget.dart';
import '../../../widget/app_button.dart';
import '../../../widget/text_field_widget.dart';

class TrafficObjectivePage extends StatefulWidget {
  final int? caseID;
  final String? caseNo;
  final bool isLocal;

  const TrafficObjectivePage(
      {super.key, required this.caseID, this.caseNo, this.isLocal = false});

  @override
  State<TrafficObjectivePage> createState() => TrafficObjectivePageState();
}

class TrafficObjectivePageState extends State<TrafficObjectivePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = true;
  bool isPhone = Device.get().isPhone;
  int trafficObjectiveVal = 1;
  TextEditingController otherCntl = TextEditingController();

  @override
  void initState() {
    asyncCall();
    super.initState();
  }

  void asyncCall() async {
    var fidsCrimeScene =
        await FidsCrimeSceneDao().getFidsCrimeSceneById(widget.caseID ?? -1);
    setState(() {
      trafficObjectiveVal = fidsCrimeScene?.trafficObjective ?? 0;
      if (fidsCrimeScene?.trafficObjective == 5) {
        otherCntl.text = fidsCrimeScene?.trafficObjectiveOther ?? '';
      }
    });
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    return Scaffold(
        extendBodyBehindAppBar: true,
        key: _scaffoldKey,
        appBar: AppBarWidget(
          actions: [
            Container(
              width: MediaQuery.of(context).size.width * 0.1,
            )
          ],
          leading: IconButton(
              icon: isIOS
                  ? const Icon(Icons.arrow_back_ios)
                  : const Icon(Icons.arrow_back),
              onPressed: () async {
                Navigator.of(context).pop(true);
              }),
          title: 'จุดประสงค์ในการตรวจพิสูจน์',
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
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : SafeArea(
                    child: Container(
                        margin: isPhone
                            ? const EdgeInsets.all(32)
                            : const EdgeInsets.only(
                                left: 32, right: 32, top: 32, bottom: 32),
                        child: _checkForm()))));
  }

  _checkForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        checkView(
          title:
              'เพื่อทราบว่ามีร่องรอยการเฉี่ยวชนระหว่างรถของกลาง 2 คันหรือไม่ อย่างไร',
          val: 1,
        ),
        checkView(
          title: 'เพื่อทราบว่ารถของกลาง 2 คัน มีการเฉี่ยวชนกันหรือไม่ อย่างไร',
          val: 2,
        ),
        checkView(
          title:
              'เพื่อทราบว่ามีร่องรอยการเฉี่ยวชนรถของกลางทั้งหมดนี้หรือไม่และมีลักษณะการเฉี่ยวชนอย่างไร',
          val: 3,
        ),
        checkView(
          title:
              'เพื่อทราบว่ามีร่องรอยการเฉี่ยวชนระหว่างรถของกลางหรือไม่อย่างไร',
          val: 4,
        ),
        checkView(
          title: 'อื่นๆ ระบุ',
          val: 5,
        ),
        trafficObjectiveVal == 5
            ? Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.01,
                ),
                child: InputField(
                    controller: otherCntl,
                    hint: 'กรอกจุดประสงค์ในการตรวจพิสูจน์',
                    onChanged: (val) {}),
              )
            : Container(),
        Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.01,
          ),
          child: saveButton(),
        )
      ],
    );
  }

  checkView({String? title, int? val}) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height * 0.01,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Transform.scale(
            scale: 1.2,
            child: Radio(
                value: val,
                activeColor: pinkButton,
                groupValue: trafficObjectiveVal,
                onChanged: (val) {
                  setState(() {
                    trafficObjectiveVal = val ?? 0;
                    if (kDebugMode) {
                      print(trafficObjectiveVal);
                    }
                    if (trafficObjectiveVal != 5) {
                      otherCntl.text = '';
                    }
                  });
                }),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                '$title',
                textAlign: TextAlign.left,
                maxLines: 2,
                style: GoogleFonts.prompt(
                  textStyle: TextStyle(
                    color: Colors.white,
                    letterSpacing: .5,
                    fontSize: MediaQuery.of(context).size.height * 0.023,
                  ),
                ),
              ),
            ),
          ),
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
              .updateTrafficObjective(
                  trafficObjectiveVal, otherCntl.text, widget.caseID ?? -1)
              .then((value) => Navigator.of(context).pop(true));
        });
  }
}
