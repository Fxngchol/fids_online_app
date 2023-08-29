import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../Utils/color.dart';
import '../../../../models/CaseEvidentFound.dart';
import '../../../../models/CaseEvidentLocation.dart';
import '../../../../models/EvidentType.dart';
import '../../../../models/Unit.dart';
import '../../../../widget/app_bar_widget.dart';
import '../../../../widget/app_button.dart';
import '../../../../widget/text_field_widget.dart';
import '../../../../widget/textfield_modal_bottom_sheet.dart';
import '../model/CaseEvidentForm.dart';

class AddAreaEvidentKept extends StatefulWidget {
  final int? caseID;
  final String? caseNo;
  final int? count;
  final bool isEdit;
  final CaseEvidentForm? caseEvidentForm;

  const AddAreaEvidentKept(
      {super.key,
      this.caseID,
      this.caseNo,
      this.isEdit = false,
      this.count,
      this.caseEvidentForm});
  @override
  AddAreaEvidentKeptState createState() => AddAreaEvidentKeptState();
}

class AddAreaEvidentKeptState extends State<AddAreaEvidentKept> {
  bool isPhone = Device.get().isPhone;

  final TextEditingController _evidentFoundController = TextEditingController();

  List evidentLocationList = [];
  List<CaseEvidentFound>? evidentLocations = [];

  bool isLoading = true;

  int evidentTypeIndexSelected = 0;

  int evidentLocationID = 0;
  String? evidentFoundID;

  String? evidentLocationDetail = '';
  String? evidentLocationPosition = '';
  String? evidentLocationText = '';

  List unitList = [];
  List<Unit> units = [];

  List evidentTypeList = [];
  List<EvidentType> evidentTypes = [];
  int evdentTypeSelectId = -1;

  @override
  void initState() {
    super.initState();

    asyncMethod();
  }

  asyncMethod() async {
    asyncCall1();
  }

  void asyncCall1() async {
    var result5 =
        await CaseEvidentFoundDao().getCaseEvidentFound(widget.caseID ?? -1);
    var result6 = await CaseEvidentFoundDao()
        .getCaseEvidentFoundLabel(widget.caseID ?? -1);

    var result = await EvidentypeDao().getEvidentType();
    var result2 = await EvidentypeDao().getEvidentTypeLabel();

    var result3 = await UnitDao().getUnit();
    var result4 = await UnitDao().getUnitLabel();

    setState(() {
      evidentLocations = result5;
      evidentLocationList = result6;
      evidentTypes = result;
      evidentTypeList = result2;

      units = result3;
      unitList = result4;

      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print('HHHHHH : ${evidentLocationList.length}');
    }
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBarWidget(
          title: 'บริเวณ',
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
                  title('ป้ายหมายเลข*'),
                  spacer(),
                  modalBottomSheet(
                      _evidentFoundController,
                      'กรุณาเลือกป้ายหมายเลข',
                      'เลือกป้ายหมายเลข',
                      evidentLocations = [],
                      evidentTypeIndexSelected, (context, index) {
                    setState(() {
                      _evidentFoundController.text =
                          '${evidentLocations?[index].isoLabelNo}';
                      evidentLocationID =
                          int.parse(evidentLocations?[index].id ?? '');
                      evidentFoundID = evidentLocations?[index].isoLabelNo;

                      evidentLocationDetail =
                          '${evidentLabel(evidentLocations?[index].evidentTypeId)} ${evidentLocations?[index].evidentAmount} ${evidentLocations?[index].evidenceUnit}';
                      evidentLocationPosition =
                          evidentLocations?[index].isoEvidentPosition;
                      evidentLocationText =
                          evidentLocations?[index].evidentDetails;
                    });
                    Navigator.of(context).pop();
                  }),
                  spacerTitle(),
                  title('รายละเอียด'),
                  spacer(),
                  detailView('$evidentLocationDetail'),
                  spacerTitle(),
                  title('บริเวณ'),
                  spacer(),
                  detailView('$evidentLocationPosition'),
                  spacerTitle(),
                  title('ลักษณะ'),
                  spacer(),
                  detailView('$evidentLocationText'),
                  spacerTitle(),
                  spacerTitle(),
                  saveButton()
                ],
              ),
            ),
          ),
        ));
  }

  textField(
    TextEditingController controller,
    String? hint,
    Function onChanged,
    Function onFieldSubmitted,
  ) {
    return InputField(
      controller: controller,
      hint: '$hint',
      onChanged: (v) {
        onChanged(v);
      },
      onFieldSubmitted: onFieldSubmitted,
    );
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
              fontSize: MediaQuery.of(context).size.height * 0.03,
            ),
          ),
        ),
      ],
    );
  }

  Widget header(String? title) {
    return Row(
      children: [
        Text(
          title ?? '',
          style: GoogleFonts.prompt(
            textStyle: TextStyle(
              color: Colors.white,
              letterSpacing: 0.5,
              fontSize: MediaQuery.of(context).size.height * 0.03,
            ),
          ),
        ),
      ],
    );
  }

  spacer() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.01,
    );
  }

  spacerTitle() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.015,
    );
  }

  Widget subtitle(String? title) {
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

  Widget modalBottomSheet(
      TextEditingController controller,
      String? hint,
      String? title,
      List<CaseEvidentFound> items,
      int indexSelected,
      Function onPressed) {
    return TextFieldModalBottomSheet(
      controller: controller,
      hint: '$hint',
      onPress: () => {
        FocusScope.of(context).unfocus(),
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
                                color: darkBlue,
                                letterSpacing: 0.5,
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.025,
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
                        children:
                            List<Widget>.generate(items.length, (int index) {
                          return Center(
                            child: Text(
                              '${items[index].isoLabelNo}',
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

  detailView(String? text) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: whiteOpacity,
      ),
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
                    text?.trim() ?? '',
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
            ),
          ],
        ),
      ),
    );
  }

  Widget saveButton() {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
      child: AppButton(
          color: pinkButton,
          textColor: Colors.white,
          text: 'บันทึกวัตถุพยานที่ตรวจเก็บ',
          onPressed: () async {
            if (evidentFoundID != null) {
              var caseEvidentLocation = CaseEvidentLocation();
              caseEvidentLocation.fidsId = widget.caseID;
              caseEvidentLocation.evidentFoundId = evidentFoundID;
              caseEvidentLocation.evidentLocationDetail =
                  '${evidentLocationText?.trim()} ${evidentLocationDetail?.trim()}';

              if (widget.caseEvidentForm?.caseEvidentLocation != null) {
                widget.caseEvidentForm?.caseEvidentLocation
                    ?.add(caseEvidentLocation);
              } else {
                widget.caseEvidentForm?.caseEvidentLocation = [];
                widget.caseEvidentForm?.caseEvidentLocation
                    ?.add(caseEvidentLocation);
              }

              Navigator.of(context).pop(widget.caseEvidentForm);
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

  String? evidentLabel(String? id) {
    for (int i = 0; i < evidentTypes.length; i++) {
      if ('$id' == '${evidentTypes[i].id}') {
        return evidentTypes[i].name;
      }
    }
    return '';
  }

  String? unitLabel(String? id) {
    for (int i = 0; i < units.length; i++) {
      if ('$id' == '${units[i].id}') {
        return units[i].name;
      }
    }
    return '';
  }
}
