import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../models/CaseCategory.dart';
import '../../../models/FidsCrimeScene.dart';
import '../../../models/case_vehicle/CaseVehicleOpinion.dart';
import '../../../widget/app_bar_widget.dart';
import '../../../widget/text_field_widget.dart';
import 'add_opinion.dart';

class OpinionDetailPage extends StatefulWidget {
  final int? caseID;
  final int? opinionID;
  final String? caseNo;
  final bool isLocal;
  final bool isEdit;

  const OpinionDetailPage(
      {super.key,
      this.caseID,
      this.caseNo,
      this.isLocal = false,
      this.isEdit = false,
      this.opinionID});
  @override
  State<OpinionDetailPage> createState() => OpinionDetailPageState();
}

class OpinionDetailPageState extends State<OpinionDetailPage> {
  bool isPhone = Device.get().isPhone;
  bool isLoading = true;
  String? caseName;
  var caseOpinionCntl = TextEditingController();

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
      await CaseVehicleOpinionDao()
          .getCaseVehicleOpinionById(widget.opinionID ?? -1)
          .then((data) {
        setState(() {
          caseOpinionCntl.text = data?.opinion ?? '';
          isLoading = false;
        });
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
            TextButton(
                child: Icon(
                  Icons.edit,
                  size: MediaQuery.of(context).size.height * 0.03,
                  color: Colors.white,
                ),
                onPressed: () async {
                  var result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddOpinionPage(
                                isEdit: true,
                                caseID: widget.caseID ?? -1,
                                caseNo: widget.caseNo,
                                opinionID: widget.opinionID ?? -1,
                              )));
                  if (result != null) {
                    asyncMethod();
                  }
                }),
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
                              child: InputField(
                                  isEnabled: false,
                                  hint: 'กรอกความเห็น',
                                  controller: caseOpinionCntl,
                                  onChanged: (val) {},
                                  maxLine: 10),
                            ),
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
}
