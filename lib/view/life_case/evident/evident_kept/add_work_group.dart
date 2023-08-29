import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../Utils/color.dart';
import '../../../../models/CaseEvidentDeliver.dart';
import '../../../../models/EvidenceCheck.dart';
import '../../../../models/WorkGroup.dart';
import '../../../../widget/app_bar_widget.dart';
import '../../../../widget/app_button.dart';
import '../../../../widget/text_field_widget.dart';
import '../../../../widget/textfield_modal_bottom_sheet.dart';
import '../model/CaseEvidentForm.dart';

class AddWorkGroup extends StatefulWidget {
  final int? caseID;
  final String? caseNo;
  final int? count;
  final bool isEdit;
  final CaseEvidentForm? caseEvidentForm;

  const AddWorkGroup(
      {super.key,
      this.caseID,
      this.caseNo,
      this.isEdit = false,
      this.count,
      this.caseEvidentForm});

  @override
  AddWorkGroupState createState() => AddWorkGroupState();
}

class AddWorkGroupState extends State<AddWorkGroup> {
  bool isPhone = Device.get().isPhone;

  final TextEditingController _workDeliverGroupController =
      TextEditingController();
  final TextEditingController _evidenceCheckController =
      TextEditingController();

  List workGroupList = [];
  List<WorkGroup> workGroups = [];
  int devliverWorkGroupIndexSelected = 0;
  int evidentCheckIndexSelected = 0;

  bool isLoading = true;

  int deliverWorkGroupId = -1;

  List evidenceCheckLabels = [];
  List<EvidenceCheck> evidenceChecks = [];
  int evidenceCheckSelectId = -1;

  @override
  void initState() {
    super.initState();

    asyncMethod();
  }

  asyncMethod() async {
    asyncCall1();
  }

  void asyncCall1() async {
    var result9 = await WorkGroupDao().getWorkGroup();
    var result10 = await WorkGroupDao().getWorkGroupLabel();

    var result17 = await EvidenceCheckDao().getEvidenceCheck();
    var result18 = await EvidenceCheckDao().getEvidenceCheckLabel();

    setState(() {
      workGroups = result9;
      workGroupList = result10;

      evidenceChecks = result17;
      evidenceCheckLabels = result18;

      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBarWidget(
          title: 'การส่งตรวจพิสูจน์',
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
                  spacerTitle(),
                  title('ประเภทการจัดเก็บ*'),
                  spacer(),
                  modalBottomSheet(
                      _evidenceCheckController,
                      'กรุณาเลือกประเภทการจัดเก็บ',
                      'เลือกประเภทการจัดเก็บ',
                      evidenceCheckLabels,
                      evidentCheckIndexSelected, (context, index) {
                    _evidenceCheckController.text =
                        evidenceChecks[index].name ?? '';
                    evidenceCheckSelectId = evidenceChecks[index].id ?? -1;
                    Navigator.of(context).pop();
                  }),
                  spacerTitle(),
                  title('การส่งตรวจพิสูจน์*'),
                  spacer(),
                  modalBottomSheet(
                      _workDeliverGroupController,
                      'กรุณาเลือกกลุ่มงานที่ดำเนินการ',
                      'เลือกกลุ่มงานที่ดำเนินการ',
                      workGroupList,
                      devliverWorkGroupIndexSelected, (context, index) {
                    _workDeliverGroupController.text = workGroupList[index];

                    deliverWorkGroupId = workGroups[index].id ?? -1;
                    Navigator.of(context).pop();
                  }),
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

  Widget modalBottomSheet(TextEditingController controller, String? hint,
      String? title, List items, int indexSelected, Function onPressed) {
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
                  height: MediaQuery.of(context).copyWith().size.height / 2.5,
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

  detailView(String? text) {
    return Container(
      color: whiteOpacity,
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
            //   CaseEvidentLocation caseEvidentLocation = CaseEvidentLocation();
            //   caseEvidentLocation.fidsId = widget.caseID;
            //  // caseEvidentLocation.evidentId = widget.caseEvidentForm.id == '' ? '' : int.parse(widget.caseEvidentForm.id);
            //   caseEvidentLocation.evidentFoundId = evidentFoundID;
            //   caseEvidentLocation.evidentLocationDetail = evidentLocationDetail;

            if (deliverWorkGroupId != -1 && evidenceCheckSelectId != -1) {
              CaseEvidentDeliver caseEvidentDeliver = CaseEvidentDeliver();
              caseEvidentDeliver.fidsId = widget.caseID;
              caseEvidentDeliver.workGroupId = deliverWorkGroupId;
              caseEvidentDeliver.evidenceCheckId = '$evidenceCheckSelectId';

              widget.caseEvidentForm?.caseEvidentDeliver
                  ?.add(caseEvidentDeliver);

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
}
