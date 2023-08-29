import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/color.dart';
import '../../../models/CaseCategory.dart';
import '../../../models/FidsCrimeScene.dart';
import '../../../models/case_fire/CaseFireSideAreaDao.dart';
import '../../../widget/app_bar_widget.dart';
import '../../../widget/app_button.dart';
import '../../../widget/text_field_widget.dart';

class CaseBehaviorPage extends StatefulWidget {
  final int? caseID;
  final String? caseNo;
  final bool isLocal;
  final bool isEdit;
  final String? fieldName,
      fireTypeID,
      caseFireAreaID,
      caseFireSideAreaID,
      fireSideAreaDetail;

  const CaseBehaviorPage(
      {super.key,
      this.caseID,
      this.caseNo,
      this.isLocal = false,
      this.isEdit = false,
      this.fieldName,
      this.fireTypeID,
      this.caseFireAreaID,
      this.caseFireSideAreaID,
      this.fireSideAreaDetail});
  @override
  State<CaseBehaviorPage> createState() => _CaseBehaviorPageState();
}

class _CaseBehaviorPageState extends State<CaseBehaviorPage> {
  bool isPhone = Device.get().isPhone;
  bool isLoading = true;
  String? caseName;
  var caseBehaviorCntl = TextEditingController();
  String? titleApp = '';
  String? title = '';
  String? hint = '';

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      print('caseFireAreaID ${widget.caseFireAreaID}');
    }
    asyncMethod();
    switch (widget.fieldName) {
      case 'CaseBehavior':
        titleApp = 'พฤติการณ์คดี';
        title = 'พฤติการณ์คดี';
        hint = 'กรอกรายละเอียดพฤติการณ์คดี';
        break;
      case 'FireDamagedDetail':
        titleApp = widget.fireTypeID == '2'
            ? 'สภาพความเสียหายของยานพาหนะ'
            : 'สภาพความเสียหายของโครงสร้าง';
        title = 'สภาพความเสียหายของ (บ้าน/ตึกแถว/อาคาร/อื่นๆ)';
        hint = 'กรอกรายละเอียดสภาพความเสียหายของ (บ้าน/ตึกแถว/อาคาร/อื่นๆ)';
        break;
      case 'FireAreaDetail':
        titleApp = 'บริเวณที่เกิดเพลิงไหม้ขึ้นก่อน';
        title = 'บริเวณที่เกิดเพลิงไหม้ขึ้นก่อน';
        hint = 'กรอกรายละเอียดบริเวณที่เกิดเพลิงไหม้ขึ้นก่อน';
        break;
      case 'FireMainSwitch':
        titleApp = 'สภาพของเมนสวิทช์ควบคุมไฟฟ้า';
        title = 'สภาพของเมนสวิทช์ควบคุมไฟฟ้า';
        hint = 'กรอกรายละเอียดสภาพของเมนสวิทช์ควบคุมไฟฟ้า';
        break;
      case 'FireOpinion':
        titleApp = 'ความเห็น';
        title = 'ความเห็น';
        hint = 'กรอกความเห็น';
        break;
      case 'FireSideArea':
        titleApp = 'สภาพความเสียหายบริเวณข้างเคียง';
        title = 'สภาพความเสียหายบริเวณข้างเคียง';
        hint = 'กรอกสภาพความเสียหายบริเวณข้างเคียง';
        break;
      default:
    }
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
      switch (widget.fieldName) {
        case 'CaseBehavior':
          caseBehaviorCntl.text = fidsCrimescene?.caseBehavior ?? '';
          break;
        case 'FireDamagedDetail':
          caseBehaviorCntl.text = fidsCrimescene?.fireDamagedDetail ?? '';
          break;
        case 'FireAreaDetail':
          caseBehaviorCntl.text = fidsCrimescene?.fireAreaDetail ?? '';
          break;
        case 'FireMainSwitch':
          caseBehaviorCntl.text = fidsCrimescene?.fireMainSwitch ?? '';
          break;
        case 'FireOpinion':
          caseBehaviorCntl.text = fidsCrimescene?.fireOpinion ?? '';
          break;
        case 'FireSideArea':
          caseBehaviorCntl.text = widget.fireSideAreaDetail ?? '';
          break;
        default:
      }
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBarWidget(
          title: '$titleApp',
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
                            Text(
                              '$title',
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
                              child: InputField(
                                  keyboardType: TextInputType.multiline,
                                  textInputAction: TextInputAction.newline,
                                  hint: '$hint',
                                  controller: caseBehaviorCntl,
                                  onChanged: (val) {},
                                  maxLine: null),
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
            print('1 ${caseBehaviorCntl.text}');
          }
          switch (widget.fieldName) {
            case 'CaseBehavior':
              await FidsCrimeSceneDao()
                  .updateCaseBehivior(
                      caseBehaviorCntl.text, widget.caseID.toString())
                  .then((value) => Navigator.of(context).pop(true));
              break;
            case 'FireDamagedDetail':
              await FidsCrimeSceneDao()
                  .updateFireDamagedDetail(
                      caseBehaviorCntl.text, widget.caseID.toString())
                  .then((value) => Navigator.of(context).pop(true));
              break;
            case 'FireAreaDetail':
              await FidsCrimeSceneDao()
                  .updateFireAreaDetail(
                      caseBehaviorCntl.text, widget.caseID.toString())
                  .then((value) => Navigator.of(context).pop(true));
              break;
            case 'FireMainSwitch':
              await FidsCrimeSceneDao()
                  .updateFireMainSwitch(
                      caseBehaviorCntl.text, widget.caseID.toString())
                  .then((value) => Navigator.of(context).pop(true));
              break;
            case 'FireOpinion':
              await FidsCrimeSceneDao()
                  .updateFireOpinion(
                      caseBehaviorCntl.text, widget.caseID.toString())
                  .then((value) => Navigator.of(context).pop(true));
              break;
            case 'FireSideArea':
              if (widget.isEdit) {
                await CaseFireSideAreaDao()
                    .updateCaseFireSideArea(
                        int.parse(widget.caseFireSideAreaID ?? ''),
                        caseBehaviorCntl.text)
                    .then((value) => Navigator.of(context).pop(true));
              } else {
                await CaseFireSideAreaDao()
                    .createCaseFireSideArea(widget.caseID.toString(),
                        caseBehaviorCntl.text, widget.caseFireAreaID)
                    .then((value) => Navigator.of(context).pop(true));
              }
              break;
            default:
          }
        });
  }
}
