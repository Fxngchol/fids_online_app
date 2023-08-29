import 'dart:convert';

import 'package:fids_online_app/view/life_case/request_case/select_sub_case_catagory.dart';
import 'package:fids_online_app/view/life_case/request_case/select_title.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart'; //for date format

import 'package:http/http.dart' as http;

import '../../../Utils/color.dart';
import '../../../models/CaseCategory.dart';
import '../../../models/FidsCrimeScene.dart';
import '../../../models/PoliceStation.dart';
import '../../../models/Province.dart';
import '../../../models/RequestCase.dart';
import '../../../models/SubCaseCategory.dart';
import '../../../models/Title.dart';
import '../../../widget/app_bar_widget.dart';
import '../../../widget/app_button.dart';
import '../../../widget/text_field_widget.dart';
import '../../../widget/textfield_modal_bottom_sheet.dart';
import '../location_case/select_province.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class IssueMedia {
  String? id;
  String? issueMedia;
  IssueMedia({
    this.id,
    this.issueMedia,
  });
}

// ignore: must_be_immutable
class RequestCasePage extends StatefulWidget {
  final int? caseID;
  final bool? isLocal;
  final bool isEdit;

  const RequestCasePage(
      {super.key, this.caseID, this.isLocal = false, this.isEdit = false});

  @override
  RequestCasePageState createState() => RequestCasePageState();
}

class RequestCasePageState extends State<RequestCasePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  RequestCase requestCase = RequestCase();

  DateTime thisYear = DateTime.now();
  DateTime caseIssueDateTime = DateTime.now();
  DateTime deliverBookDateTime = DateTime.now();
  DateTime policeDailyDateTime = DateTime.now();
  bool isPhone = Device.get().isPhone;

  List caseCategoryNames = [];
  List<CaseCategory> caseCategory = [];
  List subcaseCategoryNames = [];
  List<SubCaseCategory> subCaseCategory = [];
  List<String> issueMediaList = [
    'หนังสือ',
    'โทรศัพท์',
    'วิทยุสื่อสาร',
    'อื่นๆ'
  ];
  List policeStationList = [];
  List<PoliceStation> policeStation = [];
  List investigatorTitleList = [];
  List<MyTitle> investigatorTitle = [];
  MyTitle selectedTitle = MyTitle();
  SubCaseCategory selectedSubCase = SubCaseCategory();
  String? caseIssueTime = '';
  int fireTypeId = -1;

  int caseCategoryId = 0,
      subcaseCategoryId = 0,
      policeStationId = 0,
      investigatorTitleId = 0;

  final TextEditingController _caseCategoryController = TextEditingController();
  final TextEditingController _subcaseCategoryController =
      TextEditingController();
  final TextEditingController _subCaseCategoryOtherController =
      TextEditingController();
  final TextEditingController _caseIssueDateController =
      TextEditingController();
  final TextEditingController _caseIssueTimeController =
      TextEditingController();
  final TextEditingController _isoCaseNoController = TextEditingController();
  final TextEditingController _issueMediaController = TextEditingController();
  final TextEditingController _issueMediaDetailController =
      TextEditingController();
  final TextEditingController _deliverBookNoController =
      TextEditingController();
  final TextEditingController _deliverBookDateController =
      TextEditingController();
  final TextEditingController _policeStationController =
      TextEditingController();
  final TextEditingController _isoOtherDepartmentController =
      TextEditingController();
  final TextEditingController _policeDailyController = TextEditingController();
  final TextEditingController _policeDailyDateController =
      TextEditingController();
  final TextEditingController _investigatorTitleController =
      TextEditingController();
  final TextEditingController _investigatorNameController =
      TextEditingController();
  final TextEditingController _isoInvestigatorTelController =
      TextEditingController();
  final TextEditingController _provinceController = TextEditingController();
  int _caseCategoryIndexSelected = 0;
  int _issueMediaIndexSelected = 0;
  int _policeStationIndexSelected = 0;
  final int _provinceIndexSelected = 0;
  int _provinceId = -1;
  List<String> provinceList = [];
  List<Province> provinces = [];
  FidsCrimeScene data = FidsCrimeScene();

  String? _isoCaseNo = '';
  String? _issueMediaDetail = '';
  String? _deliverBookNo = '';
  String? _isoOtherDepartment = '';
  String? _policeDaily = '';
  String? _investigatorName = '';
  String? _isoInvestigatorTel = '';
  var uid = -1, uGroup = -1;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getUsername();
    asyncMethod();
  }

  getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid = prefs.getString('uid') as int;
    uGroup = prefs.getString('uGroup') as int;
    requestCase.uID = uid as String?;
  }

  asyncMethod() async {
    asyncCall1();
    asyncCall4();
    asyncCall5();
    if (widget.isEdit) {
      setDefaultData();
    }
    setState(() {
      isLoading = false;
    });
  }

  void asyncCall5() async {
    var result = await ProvinceDao().getProvince();
    var result2 = await ProvinceDao().getProvinceLabel();
    setState(() {
      provinces = result;
      provinceList = result2;
    });
  }

  void setDefaultData() async {
    var result =
        await FidsCrimeSceneDao().getFidsCrimeSceneById(widget.caseID ?? -1);
    setState(() {
      data = result ?? FidsCrimeScene();
      caseCategoryId = data.caseCategoryID ?? -1;
      subcaseCategoryId = data.isoSubCaseCategoryID ?? -1;
      _subCaseCategoryOtherController.text = data.subCaseCategoryOther ?? '';
      _caseIssueDateController.text = data.caseIssueDate ?? '';
      _caseIssueTimeController.text = data.caseIssueTime ?? '';
      caseIssueTime = data.caseIssueTime;
      _isoCaseNoController.text = data.reportNo ?? '';
      _isoCaseNo = data.reportNo;
      _issueMediaDetailController.text = data.issueMediaDetail ?? '';
      _provinceId = data.sceneProvinceID ?? -1;
      if (data.issueMedia == 1) {
        _issueMediaController.text = 'หนังสือ';
      } else if (data.issueMedia == 2) {
        _issueMediaController.text = 'โทรศัพท์';
      } else if (data.issueMedia == 3) {
        _issueMediaController.text = 'วิทยุสื่อสาร';
      } else if (data.issueMedia == 4) {
        _issueMediaController.text = 'อื่นๆ';
      } else {
        _issueMediaController.text = '';
      }
      fireTypeId = data.fireTypeID != null && data.fireTypeID != ''
          ? int.parse(data.fireTypeID ?? '')
          : -1;
      _issueMediaDetail = data.issueMediaDetail;
      _deliverBookNoController.text = data.deliverBookNo ?? '';
      _deliverBookNo = data.deliverBookNo;
      _deliverBookDateController.text = data.deliverBookDate ?? '';
      _isoOtherDepartmentController.text = data.isoOtherDepartment ?? '';
      _isoOtherDepartment = data.isoOtherDepartment ?? '';
      _policeDailyController.text = data.policeDaily ?? '';
      _policeDaily = data.policeDaily;
      _policeDailyDateController.text = data.policeDailyDate ?? '';
      _investigatorNameController.text = data.investigatorName ?? '';
      investigatorTitleId = data.investigatorTitleID ?? -1;
      _investigatorName = data.investigatorName ?? '';
      _isoInvestigatorTelController.text = data.isoInvestigatorTel ?? '';
      _isoInvestigatorTel = data.isoInvestigatorTel ?? '';
      policeStationId = data.policeStationID ?? -1;
      getProvinceLabel(data.sceneProvinceID ?? -1);
      if (kDebugMode) {
        print('data.sceneProvinceID ${data.sceneProvinceID}');
      }
      getCaseCategeryLabel(data.caseCategoryID ?? -1);
      getSubCaseCategoryLabel(data.isoSubCaseCategoryID ?? -1);
      getInvestigatorTitleLabel(data.investigatorTitleID ?? -1);
      getPoliceStationLabel(data.policeStationID ?? -1);
      if (data.sceneProvinceID != null) {
        asyncCall6(data.sceneProvinceID.toString());
      }
    });
  }

  bool isIssueMedia() {
    return data.issueMedia == 1 ||
        data.issueMedia == 2 ||
        data.issueMedia == 3 ||
        data.issueMedia == 4;
  }

  void getCaseCategeryLabel(int id) async {
    asyncCall2(id);
    _caseCategoryController.text =
        await CaseCategoryDAO().getCaseCategoryLabelByid(id);
  }

  void getSubCaseCategoryLabel(int id) async {
    _subcaseCategoryController.text =
        await SubCaseCategoryDao().getSubCaseCategoryByid(id);
  }

  void getInvestigatorTitleLabel(int id) async {
    _investigatorTitleController.text = await TitleDao().getTitleLabelById(id);
  }

  void getPoliceStationLabel(int id) async {
    _policeStationController.text =
        await PoliceStationDao().getPoliceStationLabelById(id);
  }

  void asyncCall1() async {
    var result = await CaseCategoryDAO().getCaseCategoryLabel();
    var result2 = await CaseCategoryDAO().getCaseCategory();
    setState(() {
      caseCategoryNames = result;
      caseCategory = result2;
    });
  }

  void asyncCall2(int id) async {
    var result = await SubCaseCategoryDao().getSubCaseCategoryLabelByFK(id);
    var result2 = await SubCaseCategoryDao().getSubCaseCategoryByFK(id);
    setState(() {
      subcaseCategoryNames = result;
      subCaseCategory = result2;
    });
  }

  void asyncCall3() async {
    var result = await PoliceStationDao().getPoliceStationLabel();
    var result2 = await PoliceStationDao().getPoliceStation();
    setState(() {
      policeStationList = result;
      policeStation = result2;
    });
  }

  void asyncCall6(String? id) async {
    if (kDebugMode) {
      print('asyncCall6 : $id');
    }
    var result =
        await PoliceStationDao().getPoliceStationLabelByProvince(id ?? '');
    var result2 = await PoliceStationDao().getPoliceStationByProvince(id ?? '');

    // print('result : ${result.toString()}');
    setState(() {
      policeStationList = result;
      policeStation = result2;
    });
  }

  void asyncCall4() async {
    var result = await TitleDao().getTitleLabel();
    var result2 = await TitleDao().getTitle();
    setState(() {
      investigatorTitleList = result;
      investigatorTitle = result2;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/bgNew.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        key: _scaffoldKey,
        appBar: AppBarWidget(
          title: 'การรับแจ้งเหตุ',
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
            child: Container(
              margin: isPhone
                  ? const EdgeInsets.all(32)
                  : const EdgeInsets.only(
                      left: 32, right: 32, top: 32, bottom: 32),
              child: ListView(
                children: [
                  titleWidget('ประเภทคดี*'),
                  spacer(),
                  casetypeModal(
                      _caseCategoryController,
                      'เลือกประเภทคดี',
                      'เลือกประเภทคดี',
                      caseCategoryNames,
                      _caseCategoryIndexSelected, (index) {
                    setState(() {
                      _caseCategoryIndexSelected = index;
                      caseCategoryId = caseCategory[index].id ?? -1;
                    });
                  }, () {
                    setState(() {
                      Navigator.of(context).pop();
                      _caseCategoryController.text =
                          caseCategoryNames[_caseCategoryIndexSelected];
                      _subcaseCategoryController.text = '';
                      subcaseCategoryId = -1;
                      caseCategoryId =
                          caseCategory[_caseCategoryIndexSelected].id ?? -1;
                      if (kDebugMode) {
                        print(caseCategoryId);
                      }
                    });
                  }),
                  spacer(),
                  titleWidget('เหตุคดี*'),
                  spacer(),
                  textfieldWithBtnSubcaseCategory(
                      caseCategory[_caseCategoryIndexSelected].id ?? -1),
                  spacer(),
                  subcaseCategoryId == 0
                      ? titleWidget('เหตุคดีอื่นๆ')
                      : Container(),
                  subcaseCategoryId == 0 ? spacer() : Container(),
                  subcaseCategoryId == 0
                      ? textield('กรอกเหตุคดีอื่นๆ', (value) {},
                          _subCaseCategoryOtherController)
                      : Container(),
                  spacer(),
                  titleWidget('เลขรายงาน'),
                  spacer(),
                  textield('เลขรายงาน', (value) {
                    _isoCaseNo = value ?? -1;
                  }, _isoCaseNoController),

                  spacer(),
                  titleWidget('วันที่รับแจ้ง*'),
                  spacer(),
                  caseIssueDateField(),
                  spacer(),
                  titleWidget('เวลาที่รับแจ้ง*'),
                  spacer(),
                  caseIssueTimeBottomSheet(),
                  spacer(),
                  titleWidget('ปจว.ข้อที่'),
                  spacer(),
                  textield('กรอกปจว.', (value) {
                    _policeDaily = value ?? -1;
                  }, _policeDailyController),
                  spacer(),
                  caseCategoryId == 2 ? fireTypeView() : Container(),
                  spacer(),
                  titleWidget('การรับแจ้ง'),
                  spacer(),
                  casetypeModal(
                      _issueMediaController,
                      'เลือกการรับแจ้ง',
                      'เลือกการรับแจ้ง',
                      issueMediaList,
                      _issueMediaIndexSelected, (index) {
                    setState(() {
                      _issueMediaIndexSelected = index;
                    });
                  }, () {
                    setState(() {
                      Navigator.of(context).pop();
                      _issueMediaController.text =
                          issueMediaList[_issueMediaIndexSelected];
                    });
                  }),
                  spacer(),
                  _issueMediaController.text == 'อื่นๆ'
                      ? titleWidget('รายละเอียด')
                      : Container(),
                  _issueMediaController.text == 'อื่นๆ'
                      ? spacer()
                      : Container(),
                  _issueMediaController.text == 'อื่นๆ'
                      ? textield('กรอกรายละเอียด', (value) {
                          _issueMediaDetail = value ?? -1;
                        }, _issueMediaDetailController)
                      : Container(),
                  spacer(),
                  titleWidget('เลขที่หนังสือ'),
                  spacer(),
                  textield('กรอกเลขที่หนังสือ', (value) {
                    _deliverBookNo = value ?? -1;
                  }, _deliverBookNoController),
                  spacer(),
                  titleWidget('ลงวันที่'),
                  spacer(),
                  deliverBookDateBottomSheet(),
                  spacer(),
                  titleWidget('จังหวัด*'),
                  spacer(),
                  textfieldProvince(),
                  spacer(),
                  titleWidget('หน่วยแจ้ง*'),
                  spacer(),
                  casetypeModal(
                      _policeStationController,
                      'เลือกหน่วยแจ้ง',
                      'เลือกหน่วยแจ้ง',
                      policeStationList,
                      _policeStationIndexSelected, (index) {
                    setState(() {
                      _policeStationIndexSelected = index;
                    });
                  }, () {
                    setState(() {
                      Navigator.of(context).pop();
                      _policeStationController.text =
                          policeStationList[_policeStationIndexSelected];
                      policeStationId =
                          policeStation[_policeStationIndexSelected].id ?? -1;
                    });
                  }),
                  spacer(),
                  policeStationId == 0
                      ? titleWidget('ชื่อหน่วยงานอื่นๆ')
                      : Container(),
                  policeStationId == 0 ? spacer() : Container(),
                  policeStationId == 0
                      ? textield('กรอกชื่อหน่วยงานอื่นๆ', (value) {
                          _isoOtherDepartment = value ?? -1;
                        }, _isoOtherDepartmentController)
                      : Container(),
                  spacer(),
                  // titleWidget('ลง(วันที่)'),
                  // spacer(),
                  // policeDailyBottomSheet(),
                  spacer(),
                  titleWidget('คำนำหน้า (พนักงานสอบสวน)*'),
                  spacer(),
                  textfieldWithBtnTitle(),
                  spacer(),
                  titleWidget('ชื่อนามสกุล*'),
                  spacer(),
                  textield('กรอกชื่อนามสกุล', (value) {
                    _investigatorName = value ?? -1;
                  }, _investigatorNameController),
                  spacer(),
                  titleWidget('เบอร์โทรศัพท์'),
                  spacer(),
                  textield('กรอกเบอร์โทรศัพท์', (value) {
                    _isoInvestigatorTel = value ?? -1;
                  }, _isoInvestigatorTelController),
                  saveButton()
                ],
              ),
            ),
          ),
        ));
  }

  spacer() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.01,
    );
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
                  groupValue: fireTypeId,
                  onChanged: (value) {
                    setState(() {
                      fireTypeId = value ?? -1;
                      if (kDebugMode) {
                        print('fireTypeId $fireTypeId อาคาร');
                      }
                    });
                  }),
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
                groupValue: fireTypeId,
                onChanged: (value) {
                  setState(() {
                    fireTypeId = value ?? -1;
                    if (kDebugMode) {
                      print('fireTypeId $fireTypeId ยานพาหนะ');
                    }
                  });
                },
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

  Widget titleWidget(String? title) {
    return Row(
      children: [
        Text(
          title ?? '',
          style: GoogleFonts.prompt(
            textStyle: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.white,
              letterSpacing: 0.5,
              fontSize: MediaQuery.of(context).size.height * 0.025,
            ),
          ),
        ),
      ],
    );
  }

  textfieldProvince() {
    return TextButton(
      onPressed: () async {
        var result = await Navigator.push(context,
            MaterialPageRoute(builder: (context) => const SelectProvince()));
        if (kDebugMode) {
          print(' vvvv : ${result.province}');
        }
        if (result != null) {
          setState(() {
            _provinceController.text = result.province;
            _provinceId = result.id;

            asyncCall6('${result.id}');
          });
        }
      },
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.zero,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: whiteOpacity,
        ),
        child: TextFormField(
          controller: _provinceController,
          enabled: false,
          style: GoogleFonts.prompt(
              textStyle: TextStyle(
            color: textColor,
            letterSpacing: 0.5,
            fontSize: MediaQuery.of(context).size.height * 0.02,
          )),
          decoration: InputDecoration(
            suffixIcon: Icon(Icons.arrow_drop_down_sharp,
                size: MediaQuery.of(context).size.height * 0.05,
                color: textColor),
            contentPadding:
                const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 16),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            hintText: 'กรุณาเลือกจังหวัด',
            hintStyle: GoogleFonts.prompt(
              textStyle: TextStyle(
                color: textColor,
                letterSpacing: 0.5,
                fontSize: MediaQuery.of(context).size.height * 0.02,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget casetypeModal(
      TextEditingController controller,
      String? hint,
      String? title,
      List items,
      int indexSelected,
      Function onSelectedItemChanged,
      Function onPressed) {
    return TextFieldModalBottomSheet(
      controller: controller,
      hint: '$hint',
      onPress: () => {
        FocusScope.of(context).unfocus(),
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
                color: Colors.transparent,
                // ignore: sized_box_for_whitespace
                child: Container(
                  height: MediaQuery.of(context).copyWith().size.height / 2.5,
                  child: Scaffold(
                    appBar: AppBar(
                      backgroundColor: Colors.white,
                      bottomOpacity: 0,
                      elevation: 0.5,
                      automaticallyImplyLeading: false,
                      titleSpacing: 0.0,
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          MaterialButton(
                            child: Text('ยกเลิก',
                                style: GoogleFonts.prompt(
                                    textStyle: TextStyle(
                                  color: darkBlue,
                                  letterSpacing: 0.5,
                                  fontSize:
                                      MediaQuery.of(context).size.height * 0.02,
                                ))),
                            onPressed: () {
                              if (controller.text == '') {
                                controller.clear();
                                indexSelected = 0;
                              }
                              Navigator.pop(context);
                            },
                          ),
                          Text('$title',
                              style: GoogleFonts.prompt(
                                  textStyle: TextStyle(
                                color: textColor,
                                letterSpacing: 0.5,
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.025,
                              ))),
                          MaterialButton(
                            onPressed: () {
                              onPressed();
                            },
                            child: Text('เลือก',
                                style: GoogleFonts.prompt(
                                    textStyle: TextStyle(
                                  color: textColor,
                                  letterSpacing: 0.5,
                                  fontSize:
                                      MediaQuery.of(context).size.height * 0.02,
                                ))),
                          )
                        ],
                      ),
                    ),
                    body: CupertinoPicker(
                        squeeze: 1.5,
                        diameterRatio: 1,
                        useMagnifier: true,
                        looping: false,
                        scrollController: FixedExtentScrollController(
                          initialItem: indexSelected,
                        ),
                        itemExtent: isPhone ? 40.0 : 50.0,
                        backgroundColor: whiteOpacity,
                        onSelectedItemChanged: (val) {
                          onSelectedItemChanged(val);
                        },
                        children:
                            List<Widget>.generate(items.length, (int index) {
                          return Center(
                            child: Text(
                              '${items[index]}',
                              style: GoogleFonts.prompt(
                                textStyle: TextStyle(
                                  color: darkBlue,
                                  letterSpacing: 0.5,
                                  fontSize:
                                      MediaQuery.of(context).size.height * 0.02,
                                ),
                              ),
                            ),
                          );
                        })),
                  ),
                ));
          },
        )
      },
    );
  }

  textfieldWithBtnTitle() {
    return TextButton(
      onPressed: () async {
        var result = await Navigator.push(context,
            MaterialPageRoute(builder: (context) => const SelectTitle()));
        if (result != null) {
          if (kDebugMode) {
            print('object');
          }
          setState(() {
            selectedTitle = result;
            _investigatorTitleController.text = selectedTitle.name ?? '';
            investigatorTitleId = selectedTitle.id ?? -1;
          });
        }
      },
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.zero,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: whiteOpacity,
        ),
        child: TextFormField(
          controller: _investigatorTitleController,
          enabled: false,
          style: GoogleFonts.prompt(
              textStyle: TextStyle(
            color: textColor,
            letterSpacing: 0.5,
            fontSize: MediaQuery.of(context).size.height * 0.02,
          )),
          decoration: InputDecoration(
            suffixIcon: Icon(Icons.arrow_drop_down_sharp,
                size: MediaQuery.of(context).size.height * 0.05,
                color: textColorHint),
            contentPadding:
                const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 16),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            hintText: 'กรุณาเลือกคำนำหน้า',
            hintStyle: GoogleFonts.prompt(
              textStyle: TextStyle(
                color: textColorHint,
                letterSpacing: 0.5,
                fontSize: MediaQuery.of(context).size.height * 0.02,
              ),
            ),
          ),
        ),
      ),
    );
  }

  textfieldWithBtnSubcaseCategory(int id) {
    return TextButton(
      onPressed: () async {
        var result = await Navigator.push(context,
            MaterialPageRoute(builder: (context) => SelectSubCaseCatagory(id)));
        if (result != null) {
          setState(() {
            selectedSubCase = result;
            if (kDebugMode) {
              print(selectedSubCase.name);
            }
            _subcaseCategoryController.text = selectedSubCase.name ?? '';
            subcaseCategoryId = selectedSubCase.id ??= -1;
          });
        }
      },
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.zero,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: whiteOpacity,
        ),
        child: TextFormField(
          controller: _subcaseCategoryController,
          enabled: false,
          style: GoogleFonts.prompt(
              textStyle: TextStyle(
            color: textColor,
            letterSpacing: 0.5,
            fontSize: MediaQuery.of(context).size.height * 0.02,
          )),
          decoration: InputDecoration(
            suffixIcon: Icon(Icons.arrow_drop_down_sharp,
                size: MediaQuery.of(context).size.height * 0.05,
                color: textColorHint),
            contentPadding:
                const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 16),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            hintText: 'กรุณาเลือกเหตุคดี',
            hintStyle: GoogleFonts.prompt(
              textStyle: TextStyle(
                color: textColorHint,
                letterSpacing: 0.5,
                fontSize: MediaQuery.of(context).size.height * 0.02,
              ),
            ),
          ),
        ),
      ),
    );
  }

  textield(String? text, Function onChanged,
      TextEditingController textEditingController) {
    return InputField(
      hint: '$text',
      onChanged: (val) {
        onChanged(val);
      },
      onFieldSubmitted: onChanged,
      controller: textEditingController,
    );
  }

  caseIssueDateField() {
    return TextFieldModalBottomSheet(
      controller: _caseIssueDateController,
      hint: 'กรุณาเลือกวันที่',
      onPress: () async {
        DateTime? newDateTime = await showRoundedDatePicker(
            theme: ThemeData(
              primarySwatch: Colors.pink,
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  textStyle: GoogleFonts.prompt(
                      textStyle: TextStyle(
                    color: pinkButton,
                    letterSpacing: .5,
                    fontSize: isPhone
                        ? MediaQuery.of(context).size.height * 0.018
                        : MediaQuery.of(context).size.height * 0.025,
                    fontWeight: FontWeight.bold,
                  )),
                ),
              ),
            ),
            fontFamily: GoogleFonts.prompt().fontFamily,
            context: context,
            initialDate: DateTime.now(),
            borderRadius: 16,
            locale: const Locale("th", "TH"),
            era: EraMode.BUDDHIST_YEAR);

        setState(() {
          final dateFormat = DateFormat('dd/MM/yyyy');
          var result = convertToBudd(dateFormat.format(newDateTime!));
          _caseIssueDateController.text = result ?? '';
          caseIssueDateTime = DateFormat('dd/MM/yyyy').parse(result ?? '');
        });
      },
    );
  }

  String? convertToBudd(String? date) {
    var start = date?.substring(0, 6);
    var process = date?.substring(6, 10);
    var cal = int.parse(process ?? '') + 543;
    var result = '$start$cal';
    return result;
  }

  caseIssueTimeBottomSheet() {
    var timeformat = DateFormat('HH:mm');
    DateTime caseIssueTime = DateTime.now();
    return TextFieldModalBottomSheet(
      controller: _caseIssueTimeController,
      hint: 'กรุณาเลือกเวลา',
      onPress: () => {
        // ignore: avoid_print
        print('object ${timeformat.format(caseIssueTime)}'),
        FocusScope.of(context).unfocus(),
        _caseIssueTimeController.text = timeformat.format(caseIssueTime),
        DatePicker.showTimePicker(context,
            showSecondsColumn: false,
            // theme: DatePickerTheme(
            //   containerHeight: MediaQuery.of(context).size.height / 2.5,
            //   doneStyle: TextStyle(
            //       fontFamily: GoogleFonts.prompt().fontFamily,
            //       fontSize: MediaQuery.of(context).size.height * 0.017,
            //       color: darkBlue),
            //   cancelStyle: TextStyle(
            //       fontFamily: GoogleFonts.prompt().fontFamily,
            //       fontSize: MediaQuery.of(context).size.height * 0.017,
            //       color: Colors.grey),
            //   itemStyle: TextStyle(
            //       fontFamily: GoogleFonts.prompt().fontFamily,
            //       fontSize: MediaQuery.of(context).size.height * 0.018,
            //       color: darkBlue),
            // ),
            showTitleActions: true,
            onChanged: (date) {}, onConfirm: (date) {
          var inputDate = timeformat.format(date);
          this.caseIssueTime = inputDate;
          _caseIssueTimeController.text = inputDate;
          if (kDebugMode) {
            print(this.caseIssueTime);
          }
        }, currentTime: DateTime.now(), locale: LocaleType.th)
      },
    );
  }

  deliverBookDateBottomSheet() {
    return TextFieldModalBottomSheet(
      controller: _deliverBookDateController,
      hint: 'กรุณาเลือกวันที่',
      onPress: () async {
        DateTime? newDateTime = await showRoundedDatePicker(
            theme: ThemeData(
              primarySwatch: Colors.pink,
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  textStyle: GoogleFonts.prompt(
                      textStyle: TextStyle(
                    color: pinkButton,
                    letterSpacing: .5,
                    fontSize: isPhone
                        ? MediaQuery.of(context).size.height * 0.018
                        : MediaQuery.of(context).size.height * 0.025,
                    fontWeight: FontWeight.bold,
                  )),
                ),
              ),
            ),
            fontFamily: GoogleFonts.prompt().fontFamily,
            context: context,
            initialDate: DateTime.now(),
            borderRadius: 16,
            locale: const Locale("th", "TH"),
            era: EraMode.BUDDHIST_YEAR);

        setState(() {
          final dateFormat = DateFormat('dd/MM/yyyy');
          var result = convertToBudd(dateFormat.format(newDateTime!));
          _deliverBookDateController.text = result ?? '';
          deliverBookDateTime = DateFormat('dd/MM/yyyy').parse(result ?? '');
        });
      },
    );
  }

  policeDailyBottomSheet() {
    return TextFieldModalBottomSheet(
      controller: _policeDailyDateController,
      hint: 'กรุณาเลือกวันที่',
      onPress: () async {
        DateTime? newDateTime = await showRoundedDatePicker(
            theme: ThemeData(
              primarySwatch: Colors.pink,
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  textStyle: GoogleFonts.prompt(
                      textStyle: TextStyle(
                    color: pinkButton,
                    letterSpacing: .5,
                    fontSize: isPhone
                        ? MediaQuery.of(context).size.height * 0.018
                        : MediaQuery.of(context).size.height * 0.025,
                    fontWeight: FontWeight.bold,
                  )),
                ),
              ),
            ),
            fontFamily: GoogleFonts.prompt().fontFamily,
            context: context,
            initialDate: DateTime.now(),
            borderRadius: 16,
            locale: const Locale("th", "TH"),
            era: EraMode.BUDDHIST_YEAR);

        setState(() {
          final dateFormat = DateFormat('dd/MM/yyyy');
          var result = convertToBudd(dateFormat.format(newDateTime!));
          _policeDailyDateController.text = result ?? '';
          policeDailyDateTime = DateFormat('dd/MM/yyyy').parse(result ?? '');
        });
      },
    );
  }

  Widget saveButton() {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
      child: AppButton(
          color: pinkButton,
          textColor: Colors.white,
          text: 'บันทึกรายละเอียดการรับแจ้ง',
          onPressed: () async {
            setState(() {
              isLoading = true;
            });
            if (validate()) {
              if (widget.isEdit) {
                // var isRep = '';
                // if (_radioValue == 1) {
                //   isRep = '1';
                // } else if (_radioValue == 2) {
                //   isRep = '2';
                // }
                await FidsCrimeSceneDao()
                    .updateFidsCrimeScene(
                        caseCategoryId,
                        subcaseCategoryId,
                        '',
                        _caseIssueDateController.text,
                        caseIssueTime,
                        _issueMediaIndexSelected + 1,
                        _issueMediaDetail,
                        _deliverBookNo,
                        _deliverBookDateController.text,
                        policeStationId,
                        _isoOtherDepartment,
                        _policeDaily,
                        _deliverBookDateController.text,
                        investigatorTitleId,
                        _investigatorName,
                        _isoInvestigatorTel,
                        _provinceId,
                        widget.caseID ?? -1,
                        _subCaseCategoryOtherController.text,
                        _isoCaseNo,
                        fireTypeId == -1 ? '' : fireTypeId.toString())
                    .then((value) => Navigator.of(context).pop(true));
              } else {
                requestCase.uGroup = uGroup.toString();
                var thaiyear = thisYear.year + 543;
                requestCase.fidsNo = '';
                requestCase.action = 'create';
                requestCase.year = thaiyear.toString();
                requestCase.caseCategoryID = caseCategoryId.toString();
                requestCase.isoCaseNo = '';
                requestCase.iSOSubCaseCategoryID = subcaseCategoryId.toString();
                requestCase.caseIssueDate = _caseIssueDateController.text;
                requestCase.caseIssueTime = _caseIssueTimeController.text;
                _issueMediaController.text == 'หนังสือ'
                    ? requestCase.issueMedia = '1'
                    : _issueMediaController.text == 'โทรศัพท์'
                        ? requestCase.issueMedia = '2'
                        : _issueMediaController.text == 'วิทยุสื่อสาร'
                            ? requestCase.issueMedia = '3'
                            : requestCase.issueMedia = '4';
                requestCase.issueMediaDetail = _issueMediaDetail;
                requestCase.isCaseNotification = '1';
                requestCase.sceneProvinceID = _provinceId.toString();
                requestCase.deliverBookNo = _deliverBookNo;
                requestCase.deliverBookDate = _deliverBookDateController.text;
                requestCase.policeStationID = policeStationId.toString();
                requestCase.isoOtherDepartment =
                    _isoOtherDepartmentController.text;
                requestCase.policeDaily = _policeDaily;
                requestCase.policeDailyDate = _policeDailyDateController.text;
                requestCase.investigatorTitleID =
                    investigatorTitleId.toString();
                requestCase.investigatorName = _investigatorNameController.text;
                requestCase.isoInvestigatorTel =
                    _isoInvestigatorTelController.text;
                requestCase.reportNo = _isoCaseNo;

                crimeSceneRequest(requestCase);
              }
            } else {
              final snackBar = SnackBar(
                content: Text(
                  'กรุณากรอกข้อมูลที่มีเครื่องหมายดอกจัน (*) ให้​ครบถ้วน',
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
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          }),
    );
  }

  Future<void> crimeSceneRequest(RequestCase requestCase) async {
    await http
        .post(
            Uri.parse(
                'https://crimescene.fids.police.go.th/mobile/api/Crimescene/New'),
            headers: <String, String>{
              "Content-Type": "application/json",
            },
            body: requestCase.toJson())
        .then((response) async {
      if (response.statusCode != 200) {
        Map map = json.decode(response.body);
        var error = map['errors'] as List;
        throw Exception(error);
      } else if (response.statusCode == 200) {
        Map map = json.decode(response.body);
        String? messageNo = map['MessageNo'];
        String? messageData = map['Messagedata'];

        if (messageNo == 'เลขคดีมีในระบบ') {
          _displaySnackBar(context, 'เลขคดีมีในระบบ');
        } else if (messageNo == 'Error') {
          _displaySnackBar(context, messageData);
        } else if (messageData != null) {
          await FidsCrimeSceneDao()
              .createFidsCrimeScene(
                  messageData,
                  caseCategoryId,
                  subcaseCategoryId,
                  '',
                  _caseIssueDateController.text,
                  caseIssueTime,
                  _issueMediaIndexSelected + 1,
                  _issueMediaDetail,
                  _deliverBookNo,
                  _deliverBookDateController.text,
                  policeStationId,
                  _isoOtherDepartment,
                  _policeDaily,
                  _deliverBookDateController.text,
                  investigatorTitleId,
                  _investigatorName,
                  _isoInvestigatorTel,
                  _provinceId,
                  _subCaseCategoryOtherController.text,
                  _isoCaseNo,
                  fireTypeId == -1 ? '' : fireTypeId.toString())
              .then((value) => dialogSuccess(context, messageData));
        }
      }
    });
  }

  void dialogSuccess(context, String? fidsId) {
    Widget okButton = TextButton(
      child: const Text("ตกลง"),
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.of(context).pop(true);
      },
    );
    AlertDialog alert = AlertDialog(
      title: const Text('เเจ้งเหตุสำเร็จ'),
      content: Text('FIDS-ID : $fidsId'),
      actions: [
        okButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _displaySnackBar(BuildContext context, String? msg) {
    final snackBar = SnackBar(
        content: Text('$msg',
            textAlign: TextAlign.center,
            style: GoogleFonts.prompt(
                textStyle: TextStyle(
              color: Colors.white,
              letterSpacing: 0.5,
              fontSize: MediaQuery.of(context).size.height * 0.025,
            ))),
        duration: const Duration(seconds: 2, microseconds: 0));
    // ignore: deprecated_member_use
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void getProvinceLabel(int id) async {
    try {
      _provinceController.text = await ProvinceDao().getProvinceLabelById(id);
    } catch (ex) {
      _provinceController.text = '';
    }
  }

  bool validate() {
    return _caseIssueDateController.text != '' &&
        caseIssueTime != '' &&
        provinces[_provinceIndexSelected].id != null &&
        _investigatorName != '';
  }
}
