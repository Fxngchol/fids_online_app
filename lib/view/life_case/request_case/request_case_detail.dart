import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/color.dart';
import '../../../models/CaseCategory.dart';
import '../../../models/FidsCrimeScene.dart';
import '../../../models/PoliceStation.dart';
import '../../../models/Province.dart';
import '../../../models/SubCaseCategory.dart';
import '../../../models/Title.dart';
import '../../../widget/app_bar_widget.dart';
import 'edit_request_case.dart';

class RequestCaseDetail extends StatefulWidget {
  final int? caseID;
  final String? caseNo;

  final bool isLocal;

  const RequestCaseDetail(
      {super.key, this.caseID, this.isLocal = false, this.caseNo});

  @override
  RequestCaseDetailState createState() => RequestCaseDetailState();
}

class RequestCaseDetailState extends State<RequestCaseDetail> {
  bool isLoading = true;

  final TextEditingController _provinceController = TextEditingController();
  DateTime caseIssueDateTime = DateTime.now();
  DateTime deliverBookDate = DateTime.now();
  DateTime policeDailyDateTime = DateTime.now();
  List<String> issueMediaList = [
    'หนังสือ',
    'โทรศัพท์',
    'วิทยุสื่อสาร',
    'อื่นๆ'
  ];

  String? caseIssueTime = '';

  bool isPhone = Device.get().isPhone;

  FidsCrimeScene data = FidsCrimeScene();

  List<CaseCategory> categories = [];
  List<PoliceStation> policeStations = [];
  List<MyTitle> title = [];
  List<SubCaseCategory> subCategories = [];
  String? caseName;

  @override
  void initState() {
    super.initState();
    asyncMethod();
  }

  asyncMethod() async {
    asyncCall1();
  }

  void asyncCall1() async {
    var result =
        await FidsCrimeSceneDao().getFidsCrimeSceneById(widget.caseID ?? -1);
    var result2 = await CaseCategoryDAO().getCaseCategory();
    var result3 = await PoliceStationDao().getPoliceStation();
    var result4 = await TitleDao().getTitle();
    var result5 = await SubCaseCategoryDao()
        .getSubCaseCategoryByFK(result?.caseCategoryID ?? -1);

    setState(() {
      data = result ?? FidsCrimeScene();
      if (kDebugMode) {
        print('${data.isoSubCaseCategoryID}');
      }

      categories = result2;
      policeStations = result3;
      title = result4;
      subCategories = result5;
      getProvinceLabel(data.sceneProvinceID ?? -1);

      isLoading = false;
    });

    await CaseCategoryDAO()
        .getCaseCategoryLabelByid(data.caseCategoryID ?? -1)
        .then((value) => caseName = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBarWidget(
          title: 'การรับแจ้งเหตุ',
          actions: [
            TextButton(
              onPressed: () async {
                //Navigator.pushNamed(context, '/requestcase');
                var result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RequestCasePage(
                            caseID: widget.caseID ?? -1,
                            isLocal: widget.isLocal,
                            isEdit: true)));
                if (result) {
                  asyncCall1();
                }
              },
              child: Icon(
                Icons.edit,
                size: MediaQuery.of(context).size.height * 0.03,
                color: Colors.white,
              ),
            ),
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
                        spacer(),
                        titleWidget('ประเภทคดี'),
                        spacer(),
                        detailView(
                            '${caseCategoryLabel(data.caseCategoryID ?? -1)}'),
                        spacer(),
                        titleWidget('เหตุคดี'),
                        spacer(),
                        detailView(
                            '${subCategoryLabel(data.isoSubCaseCategoryID ?? -1)}'),
                        spacer(),
                        data.isoSubCaseCategoryID == 0
                            ? detailView('${data.subCaseCategoryOther}')
                            : Container(),
                        spacer(),
                        titleWidget('เลขรายงาน'),
                        spacer(),
                        detailView('${data.reportNo}'),
                        spacer(),
                        titleWidget('วันที่รับแจ้ง'),
                        spacer(),
                        detailView('${data.caseIssueDate}'),
                        spacer(),
                        titleWidget('เวลาที่รับแจ้ง'),
                        spacer(),
                        detailView('${data.caseIssueTime}'),
                        spacer(),
                        titleWidget('การรับแจ้ง'),
                        spacer(),
                        isIssueMedia()
                            ? detailView(data.issueMedia == 1
                                ? 'หนังสือ'
                                : data.issueMedia == 2
                                    ? 'โทรศัพท์'
                                    : data.issueMedia == 3
                                        ? 'วิทยุสื่อสาร'
                                        : 'อื่นๆ')
                            : detailView(''),
                        spacer(),
                        data.issueMedia == 4
                            ? titleWidget('รายละเอียด')
                            : Container(),
                        data.issueMedia == 4 ? spacer() : Container(),
                        data.issueMedia == 4
                            ? detailView('${_cleanText(data.issueMediaDetail)}')
                            : Container(),
                        spacer(),
                        titleWidget('เลขที่หนังสือ'),
                        spacer(),
                        detailView('${_cleanText(data.deliverBookNo)}'),
                        spacer(),
                        titleWidget('วันที่'),
                        spacer(),
                        detailView('${data.deliverBookDate}'),
                        spacer(),
                        titleWidget('จังหวัด'),
                        spacer(),
                        detailView(_provinceController.text),
                        spacer(),
                        titleWidget('หน่วยแจ้ง'),
                        spacer(),
                        detailView(
                            '${policeStationLabel(data.policeStationID ?? -1)}'),
                        data.isoOtherDepartment != ''
                            ? isoOtherDepartmentView()
                            : Container(),
                        spacer(),
                        titleWidget('ปจว. ข้อที่'),
                        spacer(),
                        detailView('${_cleanText(data.policeDaily)}'),
                        spacer(),
                        data.caseCategoryID == 2 ? fireTypeView() : Container(),
                        spacer(),
                        titleWidget('คำนำหน้า'),
                        spacer(),
                        detailView(
                            '${titleLabel(data.investigatorTitleID ?? -1)}'),
                        spacer(),
                        titleWidget('ชื่อนามสกุล'),
                        spacer(),
                        detailView('${_cleanText(data.investigatorName)}'),
                        spacer(),
                        titleWidget('เบอร์โทรศัพท์'),
                        spacer(),
                        detailView('${_cleanText(data.isoInvestigatorTel)}'),
                      ],
                    ),
                  ),
          ),
        ));
  }

  fireTypeView() {
    return Row(
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
                  groupValue: data.fireTypeID != null && data.fireTypeID != ''
                      ? int.parse(data.fireTypeID ?? '')
                      : -1,
                  onChanged: (value) {}),
            ),
            Text(
              'อาคาร',
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
                groupValue: data.fireTypeID != null && data.fireTypeID != ''
                    ? int.parse(data.fireTypeID ?? '')
                    : -1,
                onChanged: (value) {},
              ),
            ),
            Text(
              'ยานพาหนะ',
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

  isoOtherDepartmentView() {
    return Column(
      children: [
        spacer(),
        titleWidget('ชื่อหน่วยงานอื่นๆ'),
        spacer(),
        detailView('${_cleanText(data.isoOtherDepartment)}')
      ],
    );
  }

  bool isIssueMedia() {
    return data.issueMedia == 1 ||
        data.issueMedia == 2 ||
        data.issueMedia == 3 ||
        data.issueMedia == 4;
  }

  void getProvinceLabel(int id) async {
    try {
      _provinceController.text = await ProvinceDao().getProvinceLabelById(id);
    } catch (ex) {
      _provinceController.text = '';
    }
  }

  spacer() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.01,
    );
  }

  Widget titleWidget(String? title) {
    return Row(
      children: [
        Text(
          title ?? '',
          style: GoogleFonts.prompt(
            textStyle: TextStyle(
              color: Colors.white,
              letterSpacing: 0.5,
              fontSize: MediaQuery.of(context).size.height * 0.025,
            ),
          ),
        ),
      ],
    );
  }

  detailView(
    String? text,
  ) {
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
                Text(
                  '${text == '' ? '' : text}',
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
      ),
    );
  }

  String? caseCategoryLabel(int id) {
    if (id == -1) {
      return '';
    } else {
      for (int i = 0; i < categories.length; i++) {
        if ('$id' == '${categories[i].id}') {
          return categories[i].name;
        }
      }
      return '';
    }
  }

  String? policeStationLabel(int id) {
    if (id == -1) {
      return '';
    } else {
      for (int i = 0; i < policeStations.length; i++) {
        if ('$id' == '${policeStations[i].id}') {
          return policeStations[i].name;
        }
      }
      return '';
    }
  }

  String? titleLabel(int id) {
    if (id == -1 || id == 0) {
      return '';
    } else {
      if (kDebugMode) {
        print('object object object ${title.length}');
      }
      for (int i = 0; i < title.length; i++) {
        if (kDebugMode) {
          print('title : $id  == ${title[i].id} ');
        }

        if ('$id' == '${title[i].id}') {
          return title[i].name?.trim();
        }
      }
    }

    return '';
  }

  String? subCategoryLabel(int id) {
    if (kDebugMode) {
      print('object object: $id');
    }
    if (id == -1) {
      return '';
    } else {
      for (int i = 0; i < subCategories.length; i++) {
        if ('$id' == '${subCategories[i].id}') {
          return subCategories[i].name;
        }
      }
    }
    return '';
  }

  String? _cleanText(String? text) {
    try {
      if (text == null || text == '' || text == 'null' || text == '-1') {
        return '';
      }
      return text;
    } catch (ex) {
      return '';
    }
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
