import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/color.dart';
import '../../../models/CaseBody.dart';
import '../../../models/CaseRelatedPerson.dart';
import '../../../models/Title.dart';
import '../../../widget/app_bar_widget.dart';
import '../../../widget/app_button.dart';
import '../../../widget/blurry_dialog.dart';
import '../../../widget/text_field_widget.dart';
import '../../../widget/textfield_modal_bottom_sheet.dart';

class EditDecease extends StatefulWidget {
  final int? caseID;
  final String? caseNo;
  final CaseBody? caseBody;
  final bool isEdit;

  const EditDecease(
      {super.key,
      this.caseID,
      this.caseNo,
      this.caseBody,
      this.isEdit = false});
  @override
  EditDeceaseState createState() => EditDeceaseState();
}

class EditDeceaseState extends State<EditDecease> {
  bool isPhone = Device.get().isPhone;

  bool isLoading = true;

  final TextEditingController _personalController = TextEditingController();
  final TextEditingController _labelNoController = TextEditingController();
  final TextEditingController _bodyTitleNameController =
      TextEditingController();
  final TextEditingController _bodyFirstNameController =
      TextEditingController();
  final TextEditingController _bodyLastNameController = TextEditingController();
  final TextEditingController _bodyFoundLocationController =
      TextEditingController();
  final TextEditingController _bodyFoundConditionController =
      TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  int personalSelected = 0;
  String? personalSelectId;

  MyTitle selectedTitle = MyTitle();

  List<CaseRelatedPerson> caseRelatedPerson = [];
  List<String> caseRelatedPersonLabel = [];

  List<String> titleList = [];
  List<MyTitle> titles = [];

  @override
  void initState() {
    super.initState();
    asyncMethod();
  }

  asyncMethod() async {
    asyncCall1();
  }

  void asyncCall1() async {
    // var result = await FidsCrimeSceneDao().getFidsCrimeSceneById(widget.caseID ?? -1);
    var result = await TitleDao().getTitleLabel();
    var result2 = await TitleDao().getTitle();

    var getCaseRelatedPerson =
        await CaseRelatedPersonDao().getCaseRelatedPerson(widget.caseID ?? -1);
    var getCaseRelatedPersonLabel = await CaseRelatedPersonDao()
        .getCaseRelatedPersonLabel(widget.caseID ?? -1);

    setState(() {
      titleList = result;
      titles = result2;
      _labelNoController.text = widget.caseBody?.labelNo ?? '';
      _bodyTitleNameController.text = widget.caseBody?.bodyTitleName ?? '';
      _bodyFirstNameController.text = widget.caseBody?.bodyFirstName ?? '';
      _bodyLastNameController.text = widget.caseBody?.bodyLastName ?? '';
      _bodyFoundLocationController.text =
          widget.caseBody?.bodyFoundLocation ?? '';
      _bodyFoundConditionController.text =
          widget.caseBody?.bodyFoundCondition ?? '';

      caseRelatedPerson = getCaseRelatedPerson;
      caseRelatedPersonLabel = getCaseRelatedPersonLabel;
      if (kDebugMode) {
        print(caseRelatedPersonLabel);
      }

      for (int i = 0; i < caseRelatedPerson.length; i++) {
        if ('${caseRelatedPerson[i].id}' ==
            (widget.caseBody?.personalID ?? '')) {
          personalSelectId = widget.caseBody?.personalID ?? '';
          personalSelected = i;
          _personalController.text = personaltLabel(personalSelectId) ?? '';
        }
      }

      _ageController.text = ageLabel(personalSelectId) ?? '';

      isLoading = false;
    });
  }

  String? ageLabel(String? id) {
    for (int i = 0; i < caseRelatedPerson.length; i++) {
      if ('$id' == '${caseRelatedPerson[i].id}') {
        return caseRelatedPerson[i].age;
      }
    }
    return '';
  }

  String? personaltLabel(String? id) {
    for (int i = 0; i < caseRelatedPerson.length; i++) {
      if ('$id' == '${caseRelatedPerson[i].id}') {
        return caseRelatedPersonLabel[i];
      }
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBarWidget(
          title: 'ผู้เสียชีวิต',
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
                    child: ListView(children: [
                      header('ป้ายหมายเลข*'),
                      spacer(context),
                      InputField(
                          controller: _labelNoController,
                          hint: 'กรอกป้ายหมายเลข',
                          onChanged: (_) {}),
                      spacer(context),
                      // header('คำนำหน้า'),
                      // spacer(context),
                      // InputField(
                      //     controller: _bodyTitleNameController,
                      //     hint: 'กรอกคำนำหน้า',
                      //     onChanged: (_) {}),
                      // spacer(context),
                      // header('ชื่อ*'),
                      // spacer(context),
                      // InputField(
                      //     controller: _bodyFirstNameController,
                      //     hint: 'ชื่อ',
                      //     onChanged: (_) {}),
                      // spacer(context),
                      // spacer(context),
                      // header('นามสกุล*'),
                      // spacer(context),
                      // InputField(
                      //     controller: _bodyLastNameController,
                      //     hint: 'นามสกุล',
                      //     onChanged: (_) {}),
                      // spacer(context),
                      header('รายชื่อที่จัดเก็บ*'),
                      spacer(context),
                      modalBottomSheet(
                          _personalController,
                          'กรุณาเลือกรายชื่อ',
                          'เลือกรายชื่อ',
                          caseRelatedPersonLabel,
                          personalSelected, (context, index) {
                        _personalController.text =
                            '${caseRelatedPerson[index].isoTitleName} ${caseRelatedPerson[index].isoFirstName}  ${caseRelatedPerson[index].isoLastName}';
                        personalSelectId = caseRelatedPerson[index].id;
                        _ageController.text =
                            caseRelatedPerson[index].age ?? '';
                        Navigator.of(context).pop();
                      }),
                      spacer(context),
                      header('อายุ'),
                      spacer(context),
                      InputField(
                          controller: _ageController,
                          hint: 'อายุ',
                          isEnabled: false,
                          onChanged: (_) {}),
                      spacer(context),
                      header('ตำแหน่งที่พบศพ'),
                      spacer(context),
                      InputField(
                          controller: _bodyFoundLocationController,
                          hint: 'ตำแหน่งที่พบศพ',
                          onChanged: (_) {}),
                      spacer(context),
                      header('สภาพศพ'),
                      spacer(context),
                      InputField(
                          controller: _bodyFoundConditionController,
                          hint: 'สภาพศพ',
                          onChanged: (_) {}),
                      spacer(context),
                      spacer(context),
                      spacer(context),
                      saveTabOneButton(),
                      spacer(context),
                    ])))));
  }

  // textfieldWithBtnTitle() {
  //   return TextButton(
  //     onPressed: () async {
  //       var result = await Navigator.push(
  //           context, MaterialPageRoute(builder: (context) => SelectTitle()));
  //       if (result != null) {
  //         print('object');
  //         setState(() {
  //           selectedTitle = result;
  //           _bodyTitleIdController.text = selectedTitle.name;
  //           // _bodyTitleId = selectedTitle.id;
  //         });
  //       }
  //     },
  //     style: OutlinedButton.styleFrom(
  //       padding: EdgeInsets.zero,
  //     ),
  //     child: Container(
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(10),
  //         color: whiteOpacity,
  //       ),
  //       child: TextFormField(
  //         controller: _bodyTitleIdController,
  //         enabled: false,
  //         style: GoogleFonts.prompt(
  //             textStyle: TextStyle(
  //           color: textColor,
  //           letterSpacing: 0.5,
  //           fontSize: MediaQuery.of(context).size.height * 0.02,
  //         )),
  //         decoration: InputDecoration(
  //           suffixIcon: Icon(Icons.arrow_drop_down_sharp,
  //               size: MediaQuery.of(context).size.height * 0.05,
  //               color: textColorHint),
  //           contentPadding:
  //               const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 16),
  //           focusedBorder: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(10),
  //           ),
  //           hintText: 'กรุณาเลือกคำนำหน้า',
  //           hintStyle: GoogleFonts.prompt(
  //             textStyle: TextStyle(
  //               color: textColorHint,
  //               letterSpacing: 0.5,
  //               fontSize: MediaQuery.of(context).size.height * 0.02,
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

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

  Widget saveTabOneButton() {
    return AppButton(
        color: pinkButton,
        textColor: Colors.white,
        text: 'บันทึก',
        onPressed: () {
          if (validate()) {
            // Navigator.of(context).pop();
            if (kDebugMode) {
              print('ป้ายหมายเลข ${_labelNoController.text}');
              print('คำนำหน้า ${_bodyTitleNameController.text}');
              print('ชื่อ ${_bodyFirstNameController.text}');
              print('นามสกุล ${_bodyLastNameController.text}');
              print('ตำแหน่งที่พบ ${_bodyFoundLocationController.text}');
              print('สภาพศพ ${_bodyFoundConditionController.text}');
            }

            widget.caseBody?.labelNo = _labelNoController.text;
            // widget.caseBody?.bodyTitleName= _bodyTitleNameController.text;
            // widget.caseBody?.bodyFirstName= _bodyFirstNameController.text;
            // widget.caseBody?.bodyLastName= _bodyLastNameController.text;
            widget.caseBody?.bodyFoundLocation =
                _bodyFoundLocationController.text;
            widget.caseBody?.bodyFoundCondition =
                _bodyFoundConditionController.text;
            widget.caseBody?.personalID = personalSelectId;
            Navigator.of(context).pop(widget.caseBody);
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
        });
  }

  String? titleLabel(String? id) {
    for (int i = 0; i < titles.length; i++) {
      if ('$id' == '${titles[i].id}') {
        return titles[i].name;
      }
    }
    return '';
  }

  bool validate() {
    return _labelNoController.text != '' && personalSelectId != '';
  }

  Widget modalBottomSheet(TextEditingController controller, String? hint,
      String? title, List items, int indexSelected, Function onPressed) {
    return TextFieldModalBottomSheet(
      controller: controller,
      hint: '$hint',
      onPress: () => {
        FocusScope.of(context).unfocus(),
        if (items.isNotEmpty)
          {
            showModalBottomSheet(
              context: context,
              builder: (mycontext) {
                return Container(
                    color: Colors.transparent,
                    child: SizedBox(
                      height: MediaQuery.of(context).copyWith().size.height / 3,
                      child: Scaffold(
                        appBar: AppBar(
                          backgroundColor: Colors.white,
                          bottomOpacity: 0.3,
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
                                          MediaQuery.of(context).size.height *
                                              0.02,
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
                                    color: darkBlue,
                                    letterSpacing: 0.5,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.025,
                                  ))),
                              MaterialButton(
                                  child: Text('เลือก',
                                      style: GoogleFonts.prompt(
                                          textStyle: TextStyle(
                                        color: darkBlue,
                                        letterSpacing: 0.5,
                                        fontSize:
                                            MediaQuery.of(context).size.height *
                                                0.02,
                                      ))),
                                  onPressed: () =>
                                      onPressed(mycontext, indexSelected))
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
                            backgroundColor: Colors.white,
                            onSelectedItemChanged: (int index) => setState(() {
                                  indexSelected = index;
                                }),
                            children: List<Widget>.generate(items.length,
                                (int index) {
                              return Center(
                                child: Text(
                                  items[index],
                                  style: GoogleFonts.prompt(
                                    textStyle: TextStyle(
                                      color: darkBlue,
                                      letterSpacing: 0.5,
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.02,
                                    ),
                                  ),
                                ),
                              );
                            })),
                      ),
                    ));
              },
            )
          }
        else
          {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return BlurryDialog(
                    'ไม่พบผู้เกี่ยวข้อง', 'กรุณาเพิ่มผู้เกี่ยวข้อง', () {});
              },
            )
          }
      },
    );
  }
}
