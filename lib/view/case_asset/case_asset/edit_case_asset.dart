import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/color.dart';
import '../../../models/CaseAsset.dart';
import '../../../models/CaseAssetArea.dart';
import '../../../models/CaseRansacked.dart';
import '../../../models/Unit.dart';
import '../../../widget/app_bar_widget.dart';
import '../../../widget/app_button.dart';
import '../../../widget/text_field_widget.dart';
import '../../../widget/textfield_modal_bottom_sheet.dart';

class EditCaseAsset extends StatefulWidget {
  final int? caseID;
  final String? caseNo;
  final String? caseAssetId;

  final bool isEdit;
  const EditCaseAsset(
      {super.key,
      required this.caseID,
      this.caseNo,
      this.isEdit = false,
      this.caseAssetId});
  @override
  EditCaseAssetState createState() => EditCaseAssetState();
}

class EditCaseAssetState extends State<EditCaseAsset> {
  bool isPhone = Device.get().isPhone;
  bool isLoading = true;
  List<Unit> units = [];
  late Unit unitSelected;
  int areaIndexSelected = 0, ransackedIndexSelected = 0;
  String? areaId, caseRansackedId;

  CaseAsset? caseAsset;
  List<CaseAssetArea> caseAssetsAreaList = [];
  List<CaseRansacked> ransackedList = [];

  TextEditingController assetController = TextEditingController();
  TextEditingController assetAmountController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController caseRansackedController = TextEditingController();
  TextEditingController caseAssetUnitController = TextEditingController();

  @override
  void initState() {
    asyncMethod();
    super.initState();
  }

  asyncMethod() async {
    asyncCall1();
  }

  void asyncCall1() async {
    var unitResult = await UnitDao().getUnit();
    var result = await CaseAssetAreaDao().getCaseAssetArea(widget.caseID ?? -1);
    caseAssetsAreaList = result;
//    print(caseAssetsAreaList.toString());

    units = unitResult;
    if (widget.isEdit) {
      await CaseAssetDao()
          .getCaseAssetById(widget.caseAssetId)
          .then((value) => caseAsset = value);
      assetController.text = caseAsset?.asset ?? '';
      assetAmountController.text = caseAsset?.assetAmount ?? '';
      caseAssetUnitController.text = caseAsset?.assetUnit ?? '';
      areaController.text = caseAsset?.areaDetail ?? '';
      caseRansackedController.text = caseAsset?.ransackedDetail ?? '';
    }
    setState(() {
      isLoading = false;
    });
  }

  String? getLabelArea(String? areaId) {
    var area = '';
    for (int i = 0; i < caseAssetsAreaList.length; i++) {
      if (areaId == caseAssetsAreaList[i].id) {
        area = caseAssetsAreaList[i].area ?? '';
        break;
      } else {
        area = '';
      }
    }

    return area;
  }

  String? getLabelRansacked(String? ransackedId) {
    var str = '';
    for (int i = 0; i < ransackedList.length; i++) {
      if (ransackedId == ransackedList[i].id) {
        str = ransackedList[i].areaDetail ?? '';
        break;
      } else {
        str = '';
      }
    }

    return str;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBarWidget(
          title: 'ทรัพย์สินถูกโจรกรรม',
          actions: [
            Container(
              width: 50,
            )
          ],
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
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
                    child: Column(
                      children: [
                        title('รายการทรัพย์สิน'),
                        spacer(),
                        InputField(
                            hint: 'กรอกรายการทรัพย์สิน',
                            controller: assetController,
                            onChanged: (value) {}),
                        spacer(),
                        title('จำนวน'),
                        spacer(),
                        InputField(
                            hint: 'กรอกจำนวน',
                            controller: assetAmountController,
                            onChanged: (value) {}),
                        spacer(),
                        title('หน่วยนับ'),
                        spacer(),
                        InputField(
                            hint: 'กรอกหน่วยนับ',
                            controller: caseAssetUnitController,
                            onFieldSubmitted: (value) {
                              FocusScope.of(context).unfocus();
                            },
                            onChanged: (value) {}),
                        spacer(),
                        title('บริเวณ'),
                        spacer(),
                        InputField(
                            hint: 'กรอกบริเวณ',
                            controller: areaController,
                            onFieldSubmitted: (value) {
                              FocusScope.of(context).unfocus();
                            },
                            onChanged: (value) {}),
                        // areaModal(),
                        spacer(),
                        title('รายละเอียด'),
                        spacer(),
                        InputField(
                            hint: 'กรอกรายละเอียด',
                            controller: caseRansackedController,
                            onFieldSubmitted: (value) {
                              FocusScope.of(context).unfocus();
                            },
                            onChanged: (value) {}),
                        //ransackedModal(),
                        spacer(),
                        spacer(),
                        saveButton()
                      ],
                    ),
                  ),
          ),
        ));
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
              fontSize: MediaQuery.of(context).size.height * 0.025,
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

  // textfieldWithBtnTitle() {
  //   return TextButton(
  //     onPressed: () async {
  //       var result = await Navigator.push(context,
  //           MaterialPageRoute(builder: (context) => SelectUnitListPage()));
  //       if (result != null) {
  //         print('object');
  //         setState(() {
  //           unitSelected = result;
  //           assetUnitController.text = unitSelected.name;
  //           assetUnitId = unitSelected.id;
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
  //         controller: assetUnitController,
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
  //           hintText: 'กรุณาเลือกหน่วย',
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

  Widget areaModal() {
    return TextFieldModalBottomSheet(
      controller: areaController,
      hint: 'เลือกบริเวณ',
      onPress: () => {
        showModalBottomSheet(
          context: context,
          builder: (context) {
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
                              if (areaController.text == '') {
                                areaController.clear();
                                areaIndexSelected = 0;
                              }
                              Navigator.pop(context);
                            },
                          ),
                          Text('เลือกบริเวณ',
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
                              onPressed: () {
                                Navigator.pop(context);
                                setState(() {
                                  areaController.text =
                                      caseAssetsAreaList[areaIndexSelected]
                                              .area ??
                                          '';
                                  areaId =
                                      caseAssetsAreaList[areaIndexSelected].id;
                                  ransackedList = getRansackedList(areaId);
                                  FocusScope.of(context).unfocus();
                                });
                              }),
                        ],
                      ),
                    ),
                    body: CupertinoPicker(
                        squeeze: 1.5,
                        diameterRatio: 1,
                        useMagnifier: true,
                        looping: false,
                        scrollController: FixedExtentScrollController(
                          initialItem: areaIndexSelected,
                        ),
                        itemExtent: isPhone ? 40.0 : 50.0,
                        backgroundColor: Colors.white,
                        onSelectedItemChanged: (int index) => setState(() {
                              areaIndexSelected = index;
                            }),
                        children: List<Widget>.generate(
                            caseAssetsAreaList.length, (int index) {
                          return Center(
                            child: Text(
                              caseAssetsAreaList[index].area ?? '',
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

  Widget ransackedModal() {
    final snackBar = SnackBar(
      content: Text(
        'กรุณาเลือกบริเวณ',
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
    return TextFieldModalBottomSheet(
      controller: caseRansackedController,
      hint: 'เลือกบริเวณ',
      onPress: () => {
        if (areaController.text == '')
          {ScaffoldMessenger.of(context).showSnackBar(snackBar)}
        else
          {
            showModalBottomSheet(
              context: context,
              builder: (context) {
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
                                  if (caseRansackedController.text == '') {
                                    caseRansackedController.clear();
                                    ransackedIndexSelected = 0;
                                  }
                                  Navigator.pop(context);
                                },
                              ),
                              Text('ร่องรอยรื้อค้น',
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
                                  onPressed: () {
                                    Navigator.pop(context);
                                    setState(() {
                                      caseRansackedController.text =
                                          ransackedList[ransackedIndexSelected]
                                                  .areaDetail ??
                                              '';
                                      caseRansackedId =
                                          ransackedList[ransackedIndexSelected]
                                              .id;
                                      FocusScope.of(context).unfocus();
                                    });
                                  }),
                            ],
                          ),
                        ),
                        body: CupertinoPicker(
                            squeeze: 1.5,
                            diameterRatio: 1,
                            useMagnifier: true,
                            looping: false,
                            scrollController: FixedExtentScrollController(
                              initialItem: ransackedIndexSelected,
                            ),
                            itemExtent: isPhone ? 40.0 : 50.0,
                            backgroundColor: Colors.white,
                            onSelectedItemChanged: (int index) => setState(() {
                                  ransackedIndexSelected = index;
                                }),
                            children: List<Widget>.generate(
                                ransackedList.length, (int index) {
                              return Center(
                                child: Text(
                                  ransackedList[index].areaDetail ?? '',
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
      },
    );
  }

  Widget saveButton() {
    return AppButton(
        color: pinkButton,
        textColor: Colors.white,
        text: 'บันทึก',
        onPressed: () async {
          bool isNumb = true;
          if (assetAmountController.text != '') {
            // try {
            //   double.parse(assetAmountController.text);

            //   double.parse(assetAmountController.text);
            // } catch (ex) {
            //   isNumb = false;
            // }
          }

          if (isNumb) {
            if (widget.isEdit) {
              await CaseAssetDao()
                  .updateCaseAsset(
                      caseAsset?.fidsId ?? '',
                      assetController.text,
                      assetAmountController.text,
                      caseAssetUnitController.text,
                      areaController.text,
                      caseRansackedController.text,
                      int.parse(caseAsset?.id ?? ''))
                  .then((value) => Navigator.of(context).pop(true));
            } else {
              await CaseAssetDao()
                  .createCaseAsset(
                      assetController.text,
                      assetAmountController.text,
                      caseAssetUnitController.text,
                      areaController.text,
                      caseRansackedController.text,
                      widget.caseID ?? -1)
                  .then((value) => Navigator.of(context).pop(true));
            }
          }
          // } else {
          //   final snackBar = SnackBar(
          //     content: Text(
          //       'กรุณากรอกจำนวนด้วยตัวเลข',
          //       textAlign: TextAlign.center,
          //       style: GoogleFonts.prompt(
          //         textStyle: TextStyle(
          //           color: Colors.white,
          //           letterSpacing: .5,
          //           fontSize: MediaQuery.of(context).size.height * 0.02,
          //         ),
          //       ),
          //     ),
          //   );
          //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
          // }
        });
  }

  bool validate() {
    return assetController.text != '' &&
        assetAmountController.text != '' &&
        caseAssetUnitController.text != '' &&
        areaController.text != '' &&
        caseRansackedController.text != '';
  }

  List<CaseRansacked> getRansackedList(String? areaId) {
    List<CaseRansacked> newlist = [];
    for (int i = 0; i < caseAssetsAreaList.length; i++) {
      if (areaId == caseAssetsAreaList[i].id) {
        if (caseAssetsAreaList[i].caseRansackeds != null) {
          for (int j = 0;
              j < caseAssetsAreaList[i].caseRansackeds!.length;
              j++) {
            if (caseAssetsAreaList[i].caseRansackeds?[j].ransackedTypeID ==
                '2') {
              if (kDebugMode) {
                print(caseAssetsAreaList[i].caseRansackeds?[j].detail);
              }
              newlist.add(caseAssetsAreaList[i].caseRansackeds![j]);
            }
          }
        }
      }
    }
    return newlist.isNotEmpty ? newlist : [];
  }
}
