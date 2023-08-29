import 'dart:convert';
import 'dart:io';

import 'package:fids_online_app/view/life_case/relate_person/select_relate_person_type.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import 'package:path_provider/path_provider.dart';

import '../../../Utils/color.dart';
import '../../../models/Career.dart';
import '../../../models/CaseRelatedPerson.dart';
import '../../../models/RelatedPersonType.dart';
import '../../../models/Title.dart';
import '../../../models/TypeCard.dart';
import '../../../widget/app_bar_widget.dart';
import '../../../widget/app_button.dart';
import '../../../widget/compress_util.dart';
import '../../../widget/text_field_widget.dart';
import '../../../widget/textfield_modal_bottom_sheet.dart';

class AddRelatePerson extends StatefulWidget {
  final int? caseID, relatedPersonId;
  final String? caseNo;
  final bool isEdit;
  final bool? isWitnessCasePerson;
  const AddRelatePerson(
      {super.key,
      this.relatedPersonId,
      this.caseID,
      this.caseNo,
      this.isEdit = false,
      this.isWitnessCasePerson});

  @override
  AddRelatePersonState createState() => AddRelatePersonState();
}

class AddRelatePersonState extends State<AddRelatePerson> {
  bool isPhone = Device.get().isPhone;

  List relatePersonTitleList = [];
  List relatePersonTypeList = [];
  List careerList = [];
  List typeCardList = [];

  File _image = File('');
  final picker = ImagePicker();

  RelatedPersonType personTypeSelected = RelatedPersonType();
  List<RelatedPersonType> relatedPersonType = [];
  List<MyTitle> titles = [];
  List<Career> careers = [];
  CaseRelatedPerson caseRelatedPerson = CaseRelatedPerson();
  MyTitle selectedTitle = MyTitle();

  final TextEditingController _relatePersonTypeController =
      TextEditingController();
  final TextEditingController _relatedPersonOtherController =
      TextEditingController();

  final TextEditingController _relatedPersonTitleController =
      TextEditingController();
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _idCardController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _concernPeopleCareerController =
      TextEditingController();
  final TextEditingController _concernPeopleCareerOtherController =
      TextEditingController();
  final TextEditingController _concernPeopleDetailsController =
      TextEditingController();
  final TextEditingController _base64ImageController = TextEditingController();

  final TextEditingController _typeCardController = TextEditingController();

  int relatePersonTypeIndexSelected = 0,
      typeCardIndexSelected = 0,
      relatePersonTitleIndexSelected = 0,
      concernPeopleCareerIndexSelected = 0,
      relatedPersonTypeId = -1,
      typeCardId = -1,
      careerId = -1,
      relatedPersonTitleId = -1,
      isoConcernpeopleCareerId = -1;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _relatedPersonOtherController.text = '';
    asyncMethod();
    if (kDebugMode) {
      print('isEdit: ${widget.isEdit}');
      print(
          'caseID: ${widget.caseID}, caseNo: ${widget.caseNo}, relatedPersonId: ${widget.relatedPersonId}');
    }
  }

  asyncMethod() async {
    asyncCallList();
  }

  setDefaultData() async {
    if (caseRelatedPerson.relatedPersonTypeId != null ||
        caseRelatedPerson.relatedPersonTypeId != '') {
      relatedPersonTypeId =
          int.parse(caseRelatedPerson.relatedPersonTypeId ?? '');
    }

    if (caseRelatedPerson.isoConcernpeoplecareerId != null ||
        caseRelatedPerson.isoConcernpeoplecareerId != '') {
      isoConcernpeopleCareerId =
          int.parse(caseRelatedPerson.isoConcernpeoplecareerId ?? '');
      careerId = int.parse(caseRelatedPerson.isoConcernpeoplecareerId ?? '');
    }

    _base64ImageController.text = caseRelatedPerson.relatedPersonImage ?? '';
    _relatedPersonOtherController.text =
        caseRelatedPerson.relatedPersonOther ?? '';
    caseRelatedPerson.typeCardID != '' && caseRelatedPerson.typeCardID != null
        ? typeCardId = int.parse(caseRelatedPerson.typeCardID ?? '')
        : typeCardId = -1;
    caseRelatedPerson.typeCardID == '1'
        ? _typeCardController.text = 'บัตรประชาชน'
        : caseRelatedPerson.typeCardID == '2'
            ? _typeCardController.text = 'บัตรต่างด้าว'
            : _typeCardController.text = 'หนังสือเดินทาง';

    _relatePersonTypeController.text =
        relatedPersonTypeLabel(caseRelatedPerson.relatedPersonTypeId) ?? '';
    _relatedPersonTitleController.text = caseRelatedPerson.isoTitleName ?? '';
    _firstnameController.text = caseRelatedPerson.isoFirstName ?? '';
    _lastnameController.text = caseRelatedPerson.isoLastName ?? '';
    _idCardController.text = caseRelatedPerson.isoIdCard ?? '';
    _ageController.text = caseRelatedPerson.age ?? '';
    _concernPeopleCareerController.text =
        careerLabel(caseRelatedPerson.isoConcernpeoplecareerId) ?? '';
    _concernPeopleCareerOtherController.text =
        caseRelatedPerson.isoConcernPeopleCareeerOther ?? '';
    _concernPeopleDetailsController.text =
        caseRelatedPerson.isoConcernPeopleDetails ?? '';
    if (caseRelatedPerson.relatedPersonImage != null) {
      if (caseRelatedPerson.relatedPersonImage != '' &&
          caseRelatedPerson.relatedPersonImage!
              .contains('data:image/png;base64')) {
        await _createFileFromString(caseRelatedPerson.relatedPersonImage
                ?.replaceAll("data:image/png;base64,", ""))
            .then((value) {
          setState(() {
            if (kDebugMode) {
              print('value ${value.toString()}');
            }
            _image = File(value);
          });
        });
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<String> _createFileFromString(base64image) async {
    Uint8List bytes = base64.decode(base64image);
    String? dir = (await getApplicationDocumentsDirectory()).path;
    File file = File("$dir/${DateTime.now().millisecondsSinceEpoch}.pdf");
    await file.writeAsBytes(bytes);
    return file.path;
  }

  void asyncCallList() async {
    var result = await RelatedPersonTypeDao().getRelatedPersonType();
    var result2 = await RelatedPersonTypeDao().getRelatedPersonTypeLabel();
    var result3 = await TitleDao().getTitle();
    var result4 = await TitleDao().getTitleLabel();
    var result5 = await CareerDao().getCareer();
    var result6 = await CareerDao().getCareerLabel();

    var typeCard = await TypeCardDao().getTypeCard();

    setState(() {
      typeCardList = typeCard;
      if (kDebugMode) {
        print(typeCardList.toString());
      }
      relatedPersonType = result;
      relatePersonTypeList = result2;
      titles = result3;
      relatePersonTitleList = result4;
      careers = result5;
      careerList = result6;
    });
    //โหลดจากฐานมาแก้ไข
    if (widget.isEdit) {
      asyncCallForEdit();
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  void asyncCallForEdit() async {
    var result = await CaseRelatedPersonDao().getCaseRelatedPersonById(
        widget.caseID ?? -1, widget.relatedPersonId ?? -1);
    if (widget.isEdit) {
      caseRelatedPerson = result;
      setDefaultData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBarWidget(
        title: widget.isWitnessCasePerson != null ? 'บุคคล' : 'ผู้เกี่ยวข้อง',
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
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        titleWidget('ประเภทผู้เกี่ยวข้อง*'),
                        spacer(),
                        textfieldWithBtnPersonType(),
                        relatedPersonTypeId == 0 ? spacer() : Container(),
                        relatedPersonTypeId == 0
                            ? titleWidget('ประเภทผู้เกี่ยวข้องอื่นๆ')
                            : Container(),
                        relatedPersonTypeId == 0 ? spacer() : Container(),
                        relatedPersonTypeId == 0
                            ? textield(_relatedPersonOtherController,
                                'กรอกประเภทผู้เกี่ยวข้องอื่นๆ', (value) {})
                            : Container(),
                        spacer(),
                        titleWidget('คำนำหน้า*'),
                        spacer(),
                        textield(_relatedPersonTitleController, 'กรอกคำนำหน้า',
                            (value) {}),
                        spacer(),
                        titleWidget('ชื่อ*'),
                        spacer(),
                        textield(_firstnameController, 'กรอกชื่อ', (value) {}),
                        spacer(),
                        titleWidget('นามสกุล*'),
                        spacer(),
                        textield(
                            _lastnameController, 'กรอกนามสกุล', (value) {}),
                        spacer(),
                        titleWidget('ประเภทบัตร'),
                        spacer(),
                        casetypeModal(
                            _typeCardController,
                            'กรุณาเลือกประเภทบัตร',
                            'เลือกประเภทบัตร',
                            typeCardList,
                            typeCardIndexSelected, (index) {
                          setState(() {
                            typeCardIndexSelected = index;
                          });
                        }, () {
                          setState(() {
                            Navigator.of(context).pop();
                            _typeCardController.text =
                                typeCardList[typeCardIndexSelected].name;
                            typeCardId = typeCardList[typeCardIndexSelected].id;
                          });
                        }),
                        spacer(),
                        titleWidget('เลขบัตร'),
                        spacer(),
                        textield(_idCardController, 'กรอกเลขบัตร', (value) {}),
                        spacer(),
                        titleWidget('รูปบัตร'),
                        spacer(),
                        widget.isEdit == true
                            ? _base64ImageController.text != ''
                                ? imageView()
                                : blankImage()
                            : _base64ImageController.text != ''
                                ? imageView()
                                : blankImage(),
                        spacer(),
                        addImageButton(),
                        spacer(),
                        titleWidget('อายุ (ปี)'),
                        spacer(),
                        textield(_ageController, 'กรอกอายุ', (value) {}),
                        spacer(),
                        titleWidget('อาชีพ'),
                        spacer(),
                        careersModal(
                            _concernPeopleCareerController,
                            'กรุณาเลือกอาชีพ',
                            'เลือกอาชีพ',
                            careerList,
                            concernPeopleCareerIndexSelected, (index) {
                          setState(() {
                            concernPeopleCareerIndexSelected = index;
                          });
                        }, () {
                          setState(() {
                            Navigator.of(context).pop();
                            _concernPeopleCareerController.text =
                                careerList[concernPeopleCareerIndexSelected];
                            isoConcernpeopleCareerId =
                                careers[concernPeopleCareerIndexSelected].id ??
                                    -1;
                            careerId =
                                careers[concernPeopleCareerIndexSelected].id ??
                                    -1;

                            if (careerId != 0) {
                              _concernPeopleCareerOtherController.text = '';
                            }
                          });
                        }),
                        spacer(),
                        careerId == 0 ? titleWidget('อาชีพอื่นๆ') : Container(),
                        careerId == 0 ? spacer() : Container(),
                        careerId == 0
                            ? textield(_concernPeopleCareerOtherController,
                                'กรอกอาชีพอื่นๆ', (value) {})
                            : Container(),
                        spacer(),
                        titleWidget(widget.isWitnessCasePerson ?? false
                            ? 'รายละเอียด'
                            : 'หมายเหตุ'),
                        spacer(),
                        textield(
                            _concernPeopleDetailsController,
                            widget.isWitnessCasePerson ?? false
                                ? 'กรอกรายละเอียด'
                                : 'กรอกหมายเหตุ',
                            (value) {}),
                        spacer(),
                        saveButton()
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
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

  textield(
    TextEditingController controller,
    String? text,
    Function onChanged,
  ) {
    return InputField(
        controller: controller,
        hint: '$text',
        onChanged: (str) {
          onChanged(str);
        },
        onFieldSubmitted: onChanged);
  }

  // textfieldWithBtn() {
  //   return TextButton(
  //     onPressed: () async {
  //       var result = await Navigator.push(
  //           context, MaterialPageRoute(builder: (context) => SelectTitle()));
  //       if (result != null) {
  //         setState(() {
  //           selectedTitle = result;
  //           _relatedPersonTitleController.text = selectedTitle.name;
  //           relatedPersonTitleId = selectedTitle.id;
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
  //         controller: _relatedPersonTitleController,
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
  //               color: textColor),
  //           contentPadding:
  //               const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 16),
  //           focusedBorder: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(10),
  //           ),
  //           hintText: 'กรุณาเลือกคำนำหน้า',
  //           hintStyle: GoogleFonts.prompt(
  //             textStyle: TextStyle(
  //               color: textColor,
  //               letterSpacing: 0.5,
  //               fontSize: MediaQuery.of(context).size.height * 0.02,
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  textfieldWithBtnPersonType() {
    return TextButton(
      onPressed: () async {
        var result = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const SelectRelatedPersonType()));
        if (result != null) {
          print('object ${personTypeSelected.id}');
          setState(() {
            personTypeSelected = result;
            _relatePersonTypeController.text = personTypeSelected.name ?? '';
            relatedPersonTypeId = personTypeSelected.id ?? -1;
            if (relatedPersonTypeId == 0) {
              _relatedPersonOtherController.text = '';
            }
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
          controller: _relatePersonTypeController,
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
            hintText: 'กรุณาเลือกประเภทผู้เกี่ยวข้อง',
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

  imageView() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.4,
      child: Stack(
        children: [
          Image(image: FileImage(_image), fit: BoxFit.cover),
          Positioned(
              top: -MediaQuery.of(context).size.height * 0.032,
              right: -MediaQuery.of(context).size.height * 0.032,
              child: TextButton(
                style: TextButton.styleFrom(
                    padding: EdgeInsets.zero, alignment: Alignment.topRight),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  width: MediaQuery.of(context).size.height * 0.06,
                  height: MediaQuery.of(context).size.height * 0.06,
                  child: Padding(
                    padding: EdgeInsets.only(
                        right: MediaQuery.of(context).size.height * 0.026,
                        top: MediaQuery.of(context).size.height * 0.026),
                    child: const Icon(Icons.close, color: Colors.white),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    _image = File('');
                    _base64ImageController.text = '';
                  });
                },
              )),
        ],
      ),
    );
  }

  addImageButton() {
    return Container(
        decoration: BoxDecoration(
            color: pinkButton, borderRadius: BorderRadius.circular(12)),
        child: TextButton(
          onPressed: () {
            addImage();
          },
          child: Padding(
            padding:
                const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 8),
            child: Text(
              'เพิ่มรูปบัตร',
              style: GoogleFonts.prompt(
                textStyle: TextStyle(
                  color: Colors.white,
                  letterSpacing: 0.5,
                  fontSize: MediaQuery.of(context).size.height * 0.02,
                ),
              ),
            ),
          ),
        ));
  }

  void getImage(bool isFromGallery) async {
    Navigator.pop(context);
    if (kDebugMode) {
      print('valuevaluevaluevaluevalue');
    }

    final pickedFile = await picker.pickImage(
        source: isFromGallery ? ImageSource.gallery : ImageSource.camera,
        imageQuality: 20);
    // print('pickedFile ${pickedFile.path}');
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      await compressFile(File(pickedFile.path)).then((value) {
        if (kDebugMode) {
          print('value ${value.toString()}');
        }
        List<int> imageBytes = _image.readAsBytesSync();
        String? base64Image = base64Encode(imageBytes);
        setState(() {
          _base64ImageController.text = base64Image;
        });
      }).catchError((e) {
        if (kDebugMode) {
          print(e.toString());
        }
      });
    } else {
      if (kDebugMode) {
        print('else else else else else');
      }
    }
  }

  addImage() {
    final action = CupertinoActionSheet(
      title: Text(
        'อัพโหลดรูปภาพ',
        textAlign: TextAlign.center,
        style: GoogleFonts.prompt(
          textStyle: TextStyle(
            color: textColor,
            letterSpacing: 0.5,
            fontSize: MediaQuery.of(context).size.height * 0.022,
          ),
        ),
      ),
      actions: <Widget>[
        CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () {
            getImage(false);
          },
          child: Text(
            'รูปถ่าย',
            textAlign: TextAlign.center,
            style: GoogleFonts.prompt(
              textStyle: TextStyle(
                color: textColor,
                letterSpacing: 0.5,
                fontSize: MediaQuery.of(context).size.height * 0.02,
              ),
            ),
          ),
        ),
        CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () {
            getImage(true);
          },
          child: Text(
            'อัลบั้ม',
            textAlign: TextAlign.center,
            style: GoogleFonts.prompt(
              textStyle: TextStyle(
                color: textColor,
                letterSpacing: 0.5,
                fontSize: MediaQuery.of(context).size.height * 0.02,
              ),
            ),
          ),
        )
      ],
      cancelButton: CupertinoActionSheetAction(
        isDestructiveAction: true,
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text(
          'Cancel',
          textAlign: TextAlign.center,
          style: GoogleFonts.prompt(
            textStyle: TextStyle(
              color: Colors.red,
              letterSpacing: 0.5,
              fontSize: MediaQuery.of(context).size.height * 0.02,
            ),
          ),
        ),
      ),
    );
    showCupertinoModalPopup(context: context, builder: (context) => action);
  }

  Widget careersModal(
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
                child: SizedBox(
                  height: MediaQuery.of(context).copyWith().size.height / 2.5,
                  child: Scaffold(
                    appBar: AppBar(
                      backgroundColor: Colors.white,
                      bottomOpacity: 0.3,
                      elevation: 0.5,
                      automaticallyImplyLeading: false,
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
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.025,
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
                                    MediaQuery.of(context).size.height * 0.025,
                              ))),
                          MaterialButton(
                            onPressed: () {
                              onPressed();
                            },
                            child: Text('เลือก',
                                style: GoogleFonts.prompt(
                                    textStyle: TextStyle(
                                  color: darkBlue,
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
                        backgroundColor: Colors.white,
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
                child: SizedBox(
                  height: MediaQuery.of(context).copyWith().size.height / 2.5,
                  child: Scaffold(
                    appBar: AppBar(
                      backgroundColor: Colors.white,
                      bottomOpacity: 0.3,
                      elevation: 0.5,
                      automaticallyImplyLeading: false,
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
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.025,
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
                                    MediaQuery.of(context).size.height * 0.025,
                              ))),
                          MaterialButton(
                            onPressed: () {
                              onPressed();
                            },
                            child: Text('เลือก',
                                style: GoogleFonts.prompt(
                                    textStyle: TextStyle(
                                  color: darkBlue,
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
                        backgroundColor: Colors.white,
                        onSelectedItemChanged: (val) {
                          onSelectedItemChanged(val);
                        },
                        children:
                            List<Widget>.generate(items.length, (int index) {
                          return Center(
                            child: Text(
                              '${items[index].name}',
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

  Widget saveButton() {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
      child: AppButton(
          color: pinkButton,
          textColor: Colors.white,
          text: 'บันทึก',
          onPressed: () {
            if (validate()) {
              var numValidate = true;
              if (_ageController.text != '') {
                try {
                  int.parse(_ageController.text);
                } catch (ex) {
                  numValidate = false;
                }
              }
              if (numValidate) {
                if (kDebugMode) {
                  print('ไอดีประเภทผู้เกี่ยวข้อง $relatedPersonTypeId');
                  print('ไอดีคำนำหน้า $relatedPersonTitleId');
                  print('ชื่อ ${_firstnameController.text}');
                  print('นามสกุล ${_lastnameController.text}');
                  print('เลขบัตรปชช ${_idCardController.text}');
                  print('อายุ ${_ageController.text}');
                  print(
                      'อาชีพ ${_concernPeopleCareerController.text} $isoConcernpeopleCareerId');
                  print(
                      'อาชีพอื่นๆ ${_concernPeopleCareerOtherController.text}');
                  print('หมายเหตุ ${_concernPeopleDetailsController.text}');
                  print('รุปบัตร ${_base64ImageController.text}');
                  print('รุปบัตร $base64');
                  print('typeCardId $typeCardId');
                }

                if (widget.isEdit) {
                  CaseRelatedPersonDao().updateCaseRelatedPerson(
                      relatedPersonTypeId,
                      _relatedPersonTitleController.text,
                      _relatedPersonOtherController.text,
                      _firstnameController.text,
                      _lastnameController.text,
                      _idCardController.text,
                      typeCardId.toString(),
                      _ageController.text,
                      isoConcernpeopleCareerId != -1
                          ? isoConcernpeopleCareerId
                          : -2,
                      _concernPeopleCareerOtherController.text,
                      _concernPeopleDetailsController.text,
                      // 'data:image/png;base64,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',
                      _base64ImageController.text == ''
                          ? ''
                          : 'data:image/png;base64,${_base64ImageController.text}',
                      '',
                      '',
                      '',
                      '',
                      1,
                      widget.relatedPersonId ?? -1);
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(true);
                } else {
                  CaseRelatedPersonDao().createCaseRelatedPerson(
                      widget.caseID ?? -1,
                      relatedPersonTypeId,
                      _relatedPersonOtherController.text,
                      _relatedPersonTitleController.text,
                      _firstnameController.text,
                      _lastnameController.text,
                      _idCardController.text,
                      typeCardId.toString(),
                      _ageController.text,
                      isoConcernpeopleCareerId,
                      _concernPeopleCareerOtherController.text,
                      _concernPeopleDetailsController.text,
                      _base64ImageController.text == ''
                          ? ''
                          : 'data:image/png;base64,${_base64ImageController.text}',
                      '',
                      '',
                      '',
                      '',
                      1);
                  Navigator.of(context).pop(true);
                }
              } else {
                final snackBar = SnackBar(
                  content: Text(
                    'กรุณากรอกข้อมูลอายุเป็นตัวเลข',
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

  bool validate() {
    return relatedPersonTypeId != -1 &&
        _firstnameController.text != '' &&
        _lastnameController.text != '';
  }

  String? titleLabel(String? id) {
    for (int i = 0; i < titles.length; i++) {
      if ('$id' == '${titles[i].id}') {
        return titles[i].name;
      }
    }
    return '';
  }

  String? careerLabel(String? id) {
    for (int i = 0; i < careers.length; i++) {
      if ('$id' == '${careers[i].id}') {
        return careers[i].name;
      }
    }
    return '';
  }

  String? relatedPersonTypeLabel(String? id) {
    for (int i = 0; i < relatedPersonType.length; i++) {
      if ('$id' == '${relatedPersonType[i].id}') {
        return relatedPersonType[i].name;
      }
    }
    return '';
  }

  _imgFromCamera() async {
    // ignore: invalid_use_of_visible_for_testing_member
    var image = await ImagePicker.platform
        // ignore: deprecated_member_use
        .pickImage(source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = image as File;
    });
  }

  _imgFromGallery() async {
    // ignore: invalid_use_of_visible_for_testing_member
    var image = await ImagePicker.platform
        // ignore: deprecated_member_use
        .pickImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = image as File;
    });
  }

  // ignore: unused_element
  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('อัลบั้มรูปภาพ'),
                    onTap: () {
                      _imgFromGallery();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('กล้องถ่ายรูป'),
                  onTap: () {
                    _imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }
}
