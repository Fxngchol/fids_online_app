import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/color.dart';
import '../../../models/Career.dart';
import '../../../models/CaseRelatedPerson.dart';
import '../../../models/RelatedPersonType.dart';
import '../../../models/Title.dart';
import '../../../widget/app_bar_widget.dart';
import 'add_relate_person.dart';

// ignore: must_be_immutable
class RelatePersonDetail extends StatefulWidget {
  final int? caseID, relatedPersonId;
  final String? caseNo;
  bool isWitnessCasePerson;

  RelatePersonDetail(
      {super.key,
      this.relatedPersonId,
      this.caseID,
      this.caseNo,
      this.isWitnessCasePerson = false});

  @override
  RelatePersonDetailState createState() => RelatePersonDetailState();
}

class RelatePersonDetailState extends State<RelatePersonDetail> {
  bool isPhone = Device.get().isPhone;

  List<MyTitle> title = [];
  List<RelatedPersonType> relatedPersonTypes = [];
  List<Career> career = [];

  CaseRelatedPerson caseRelatedPerson = CaseRelatedPerson();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    asyncMethod();
    if (kDebugMode) {
      print(
          'caseID: ${widget.caseID} , caseNo: ${widget.caseNo}, relatedPersonId ${widget.relatedPersonId}');
    }
  }

  asyncMethod() async {
    asyncCall1();
  }

  void asyncCall1() async {
    var result = await CaseRelatedPersonDao().getCaseRelatedPersonById(
        widget.caseID ?? -1, widget.relatedPersonId ?? -1);
    setState(() {
      caseRelatedPerson = result;
    });
    if (kDebugMode) {
      print('asyncCall1asyncCall1 ${caseRelatedPerson.toString()}');
    }

    asyncCall2();
  }

  void asyncCall2() async {
    var result2 = await TitleDao().getTitle();
    var result3 = await RelatedPersonTypeDao().getRelatedPersonType();
    var result = await CareerDao().getCareer();
    setState(() {
      career = result;
      title = result2;
      relatedPersonTypes = result3;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Container(
        color: darkBlue,
        child: const Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBarWidget(
          title: widget.isWitnessCasePerson
              ? 'รายการบุคคล'
              : 'รายการผู้เกี่ยวข้อง',
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
                          builder: (context) => AddRelatePerson(
                              relatedPersonId: widget.relatedPersonId ?? -1,
                              isEdit: true,
                              caseNo: widget.caseNo,
                              caseID: widget.caseID ?? -1,
                              isWitnessCasePerson:
                                  widget.isWitnessCasePerson)));
                  if (result != null) {
                    if (kDebugMode) {
                      print('objectobresultresultresultjectobjectobject');
                    }
                    asyncMethod();
                  }
                }),
          ],
        ),
        body: _body());
  }

  Widget _body() {
    return Container(
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
              : const EdgeInsets.only(left: 32, right: 32, top: 32, bottom: 32),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                header('ประเภทผู้ที่เกี่ยวข้อง'),
                spacer(context),
                detailView(
                    '${relatedPersonTypeLabel(caseRelatedPerson.relatedPersonTypeId)}'),
                spacer(context),
                caseRelatedPerson.relatedPersonTypeId == '0'
                    ? header('ประเภทผู้ที่เกี่ยวข้องอื่นๆ')
                    : Container(),
                caseRelatedPerson.relatedPersonTypeId == '0'
                    ? spacer(context)
                    : Container(),
                caseRelatedPerson.relatedPersonTypeId == '0'
                    ? detailView('${caseRelatedPerson.relatedPersonOther}')
                    : Container(),
                spacer(context),
                header('คำนำหน้า'),
                spacer(context),
                detailView('${caseRelatedPerson.isoTitleName}'),
                spacer(context),
                header('ชื่อ'),
                spacer(context),
                detailView('${_cleanText(caseRelatedPerson.isoFirstName)}'),
                spacer(context),
                header('นามสกุล'),
                spacer(context),
                detailView('${_cleanText(caseRelatedPerson.isoLastName)}'),
                spacer(context),
                header('ประเภทบัตร'),
                spacer(context),
                detailView(
                    '${_cleanText(caseRelatedPerson.typeCardID == '1' ? 'บัตรประชาชน' : caseRelatedPerson.typeCardID == '2' ? 'บัตรต่างด้าว' : 'หนังสือเดินทาง')}'),
                spacer(context),
                header('เลขบัตร'),
                spacer(context),
                detailView('${_cleanText(caseRelatedPerson.isoIdCard)}'),
                spacer(context),
                header('รูปบัตร'),
                spacer(context),
                caseRelatedPerson.relatedPersonImage != null
                    ? caseRelatedPerson.relatedPersonImage != '' &&
                            caseRelatedPerson.relatedPersonImage!
                                .contains('data:image/png;base64')
                        ? imageView()
                        : blankImage()
                    : blankImage(),
                spacer(context),
                header('อายุ'),
                spacer(context),
                detailView('${_cleanText(caseRelatedPerson.age)}'),
                spacer(context),
                header('อาชีพ'),
                spacer(context),
                detailView(
                    '${careerLabel(caseRelatedPerson.isoConcernpeoplecareerId)}'),
                spacer(context),
                caseRelatedPerson.isoConcernPeopleCareeerOther == ''
                    ? Container()
                    : header('อาชีพอื่นๆ'),
                caseRelatedPerson.isoConcernPeopleCareeerOther == ''
                    ? Container()
                    : spacer(context),
                caseRelatedPerson.isoConcernPeopleCareeerOther == ''
                    ? Container()
                    : detailView(
                        '${_cleanText(caseRelatedPerson.isoConcernPeopleCareeerOther)}'),
                caseRelatedPerson.isoConcernPeopleCareeerOther == ''
                    ? Container()
                    : spacer(context),
                widget.isWitnessCasePerson
                    ? header('รายละเอียด')
                    : header('หมายเหตุ'),
                spacer(context),
                detailView(
                    '${_cleanText(caseRelatedPerson.isoConcernPeopleDetails)}'),
                spacer(context),
              ],
            ),
          ),
        )));
  }

  Widget header(String? text) {
    return Text(
      '$text',
      textAlign: TextAlign.left,
      style: GoogleFonts.prompt(
        textStyle: TextStyle(
          color: Colors.white,
          letterSpacing: .5,
          fontSize: MediaQuery.of(context).size.height * 0.025,
        ),
      ),
    );
  }

  Widget spacer(context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.015,
    );
  }

  // data:image/jpeg;base64,
  // data:image/png;base64,
  imageView() {
    var img = caseRelatedPerson.relatedPersonImage
        ?.replaceAll("data:image/png;base64,", "");
    if (kDebugMode) {
      print('object $img');
    }

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.4,
      child: Image.memory(base64Decode(img ?? '')),
    );
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
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  blankImage() {
    return Container(
        width: MediaQuery.of(context).size.width * 0.4,
        height: MediaQuery.of(context).size.height * 0.2,
        decoration: BoxDecoration(
          color: whiteOpacity,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.photo_rounded,
              size: MediaQuery.of(context).size.height * 0.06,
              color: Colors.black.withOpacity(0.7),
            ),
            Text(
              'No image available',
              textAlign: TextAlign.center,
              style: GoogleFonts.prompt(
                textStyle: TextStyle(
                  color: textColor,
                  letterSpacing: 0.5,
                  fontSize: MediaQuery.of(context).size.height * 0.025,
                ),
              ),
            ),
          ],
        ));
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

  String? titleLabel(String? id) {
    for (int i = 0; i < title.length; i++) {
      if ('$id' == '${title[i].id}') {
        return title[i].name;
      }
    }
    return '';
  }

  String? careerLabel(String? id) {
    for (int i = 0; i < career.length; i++) {
      if ('$id' == '${career[i].id}') {
        return career[i].name;
      }
    }
    return '';
  }

  String? relatedPersonTypeLabel(String? id) {
    if (kDebugMode) {
      print('$id');
    }

    for (int i = 0; i < relatedPersonTypes.length; i++) {
      if (kDebugMode) {
        print('${relatedPersonTypes[i].id}');
      }

      if ('$id' == '${relatedPersonTypes[i].id}') {
        return relatedPersonTypes[i].name;
      }
    }
    return '';
  }
}
