import 'package:fids_online_app/view/life_case/location_case/select_amphur.dart';
import 'package:fids_online_app/view/life_case/location_case/select_province.dart';
import 'package:fids_online_app/view/life_case/location_case/select_tambol.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
import '../../../Utils/color.dart';
import '../../../models/Amphur.dart';
import '../../../models/CaseCategory.dart';
import '../../../models/FidsCrimeScene.dart';
import '../../../models/Province.dart';
import '../../../models/Tambol.dart';
import '../../../widget/app_bar_widget.dart';
import '../../../widget/app_button.dart';
import '../../../widget/text_field_widget.dart';

class EditLocationCase extends StatefulWidget {
  final int? caseID;
  final String? caseNo;

  // final bool isLocal;
  // final bool isEdit;

  const EditLocationCase({super.key, this.caseID, this.caseNo});

  @override
  EditLocationCaseState createState() => EditLocationCaseState();
}

class EditLocationCaseState extends State<EditLocationCase> {
  var apiKey = "AIzaSyBqWtWLdbzVLGT1rw9vOLB51y4_T52vkNQ";
  // LocationResult _pickedLocation;

  bool isPhone = Device.get().isPhone;

  List provinceList = [];
  List<Province> provinces = [];

  List districtList = [];
  List<Amphur> districts = [];

  List subDistrictList = [];
  List<Tambol> subDistricts = [];

  final TextEditingController _addressNameController = TextEditingController();
  final TextEditingController _provinceController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _subDistrictController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();

  int subDistrictId = -1;

  int districtId = -1;

  int provinceId = -1;

  String? _addressName;
  String? _latitude;
  String? _longitude;

  FidsCrimeScene data = FidsCrimeScene();
  String? caseName;

  @override
  void initState() {
    super.initState();
    asyncMethod();
  }

  asyncMethod() {
    asyncCall1();
    setDefaultData();
  }

  void setDefaultData() async {
    await FidsCrimeSceneDao()
        .getFidsCrimeSceneById(widget.caseID ?? -1)
        .then((value) {
      setState(() async {
        data = value ?? FidsCrimeScene();
        await CaseCategoryDAO()
            .getCaseCategoryLabelByid(data.caseCategoryID ?? -1)
            .then((value) => caseName = value);
        _addressNameController.text = data.sceneDescription ?? '';
        _addressName = data.sceneDescription;
        _provinceController.text =
            provinceLabel(data.sceneProvinceID ?? -1) ?? '';
        provinceId = data.sceneProvinceID ?? -1;
        asyncCallAmphur(data.sceneProvinceID ?? -1);
        // _districtController.text = amphurLabel(data.sceneAmphurID);
        districtId = data.sceneAmphurID ?? -1;
        asyncCallTambol(data.sceneProvinceID ?? -1, data.sceneAmphurID ?? -1);
        subDistrictId = data.sceneTambolID ?? -1;
        if (kDebugMode) {
          print('>>>subDistrictIdsubDistrictId $subDistrictId');
        }

        _latitudeController.text = data.isoLatitude ?? '';
        _latitude = data.isoLatitude;

        _longitudeController.text = data.isoLongtitude ?? '';
        _longitude = data.isoLongtitude;
      });
    });
  }

  void asyncCall1() async {
    var result = await ProvinceDao().getProvince();
    var result2 = await ProvinceDao().getProvinceLabel();
    setState(() {
      provinces = result;
      provinceList = result2;
    });
  }

  void asyncCall2(int provinceId) async {
    var result = await AmphurDao().getAmphurByProvinceID(provinceId);
    var result2 = await AmphurDao().getProvinceLabelByProvinceID(provinceId);
    setState(() {
      districts = result;
      districtList = result2;
    });
  }

  void asyncCallAmphur(int provinceId) async {
    var result = await AmphurDao().getAmphurByProvinceID(provinceId);
    var result2 = await AmphurDao().getProvinceLabelByProvinceID(provinceId);
    setState(() {
      districts = result;
      districtList = result2;
      _districtController.text = amphurLabel(data.sceneAmphurID ?? -1) ?? '';
    });
  }

  void asyncCallTambol(int provinceId, int amphurId) async {
    var result = await TambolDao().getTambolByID(provinceId, amphurId);
    var result2 = await TambolDao().getTambolLabelByID(provinceId, amphurId);
    setState(() {
      subDistricts = result;
      subDistrictList = result2;
      _subDistrictController.text = tambolLabel(data.sceneTambolID ?? -1) ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBarWidget(
          title: 'สถานที่เกิดเหตุ',
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
                      headerView(),
                      header('ที่อยู่ (บ้านเลขที่/ซอย/ถนน)*'),
                      spacer(context),
                      InputField(
                          controller: _addressNameController,
                          hint: 'กรอกที่อยู่',
                          onChanged: (value) {
                            // _addressName = value;
                          }),
                      spacer(context),
                      header('จังหวัด*'),
                      spacer(context),
                      textfieldProvince(),
                      spacer(context),
                      spacer(context),
                      header('อำเภอ/เขต*'),
                      spacer(context),
                      textfieldDistrict(),
                      spacer(context),
                      header('ตำบล/แขวง*'),
                      spacer(context),
                      textfieldSubDistrict(),
                      // detailView('คลองสอง'),
                      spacer(context),
                      spacer(context),
                      spacer(context),
                      spacer(context),
                      Row(
                        children: [
                          header('พิกัดตำแหน่ง'),
                          const SizedBox(width: 20),
                          locationClick(),
                        ],
                      ),
                      spacer(context),
                      header('ละติจูด*'),
                      spacer(context),
                      InputField(
                        hint: 'กรอกละติจูด',
                        onChanged: (value) {
                          _latitude = value;
                          // _latitudeController.text = value;
                          // _latitudeController.selection =
                          //     TextSelection.fromPosition(TextPosition(
                          //         offset: _latitudeController.text.length));
                        },
                        controller: _latitudeController,
                      ),
                      spacer(context),
                      header('ลองจิจูด*'),
                      spacer(context),
                      InputField(
                        hint: 'กรอกลองจิจูด',
                        onChanged: (value) {
                          _longitude = value;
                          // _longitudeController.text = value;
                          // _longitudeController.selection =
                          //     TextSelection.fromPosition(TextPosition(
                          //         offset: _latitudeController.text.length));
                        },
                        controller: _longitudeController,
                      ),
                      spacer(context),
                      spacer(context),
                      saveButton(),
                      spacer(context),
                      spacer(context),
                    ])))));
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

  textfieldSubDistrict() {
    return TextButton(
      onPressed: () async {
        var result = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SelectTambol(districtId, provinceId)));

        if (result != null) {
          setState(() {
            _subDistrictController.text = result.tambol;
            subDistrictId = result.id;
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
          controller: _subDistrictController,
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
            hintText: 'กรุณาเลือกตำบล',
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

  // Widget subDistrictModal() {
  //   return TextFieldModalBottomSheet(
  //     controller: _subDistrictController,
  //     hint: 'กรุณาเลือกตำบล/แขวง',
  //     onPress: () => {
  //       FocusScope.of(context).unfocus(),
  //       showModalBottomSheet(
  //         context: context,
  //         builder: (context) {
  //           return Container(
  //               color: Colors.transparent,
  //               child: new Container(
  //                 height: MediaQuery.of(context).copyWith().size.height / 3,
  //                 child: Scaffold(
  //                   appBar: AppBar(
  //                     backgroundColor: Colors.white,
  //                     bottomOpacity: 0.3,
  //                     elevation: 0.5,
  //                     automaticallyImplyLeading: false,
  //                     titleSpacing: 0.0,
  //                     title: Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       crossAxisAlignment: CrossAxisAlignment.center,
  //                       children: <Widget>[
  //                         MaterialButton(
  //                           child: Text('ยกเลิก',
  //                               style: GoogleFonts.prompt(
  //                                   textStyle: TextStyle(
  //                                 color: darkBlue,
  //                                 letterSpacing: 0.5,
  //                                 fontSize:
  //                                     MediaQuery.of(context).size.height * 0.02,
  //                               ))),
  //                           onPressed: () {
  //                             if (_subDistrictController.text == '') {
  //                               _subDistrictController.clear();
  //                               _subDistrictIndexSelected = 0;
  //                             }
  //                             Navigator.pop(context);
  //                           },
  //                         ),
  //                         new Text('เลือกตำบล/แขวง',
  //                             style: GoogleFonts.prompt(
  //                                 textStyle: TextStyle(
  //                               color: darkBlue,
  //                               letterSpacing: 0.5,
  //                               fontSize:
  //                                   MediaQuery.of(context).size.height * 0.025,
  //                             ))),
  //                         MaterialButton(
  //                             child: Text('เลือก',
  //                                 style: GoogleFonts.prompt(
  //                                     textStyle: TextStyle(
  //                                   color: darkBlue,
  //                                   letterSpacing: 0.5,
  //                                   fontSize:
  //                                       MediaQuery.of(context).size.height *
  //                                           0.02,
  //                                 ))),
  //                             onPressed: () {
  //                               Navigator.pop(context);
  //                               setState(() {
  //                                 _subDistrictController.text = subDistrictList[
  //                                     _subDistrictIndexSelected];
  //                                 subDistrictId =
  //                                     subDistricts[_subDistrictIndexSelected]
  //                                         .id;
  //                               });
  //                             }),
  //                       ],
  //                     ),
  //                   ),
  //                   body: Container(
  //                     child: CupertinoPicker(
  //                         squeeze: 1.5,
  //                         diameterRatio: 1,
  //                         useMagnifier: true,
  //                         looping: false,
  //                         scrollController: new FixedExtentScrollController(
  //                           initialItem: _subDistrictIndexSelected,
  //                         ),
  //                         itemExtent: isPhone ? 40.0 : 50.0,
  //                         backgroundColor: Colors.white,
  //                         onSelectedItemChanged: (int index) => setState(() {
  //                               _subDistrictIndexSelected = index;
  //                             }),
  //                         children: new List<Widget>.generate(
  //                             subDistrictList.length, (int index) {
  //                           return new Center(
  //                             child: new Text(
  //                               subDistrictList[index],
  //                               style: GoogleFonts.prompt(
  //                                 textStyle: TextStyle(
  //                                   color: darkBlue,
  //                                   letterSpacing: 0.5,
  //                                   fontSize:
  //                                       MediaQuery.of(context).size.height *
  //                                           0.02,
  //                                 ),
  //                               ),
  //                             ),
  //                           );
  //                         })),
  //                   ),
  //                 ),
  //               ));
  //         },
  //       )
  //     },
  //   );
  // }

  textfieldDistrict() {
    return TextButton(
      onPressed: () async {
        var result = await Navigator.push(context,
            MaterialPageRoute(builder: (context) => SelectAmphur(provinceId)));

        if (result != null) {
          setState(() {
            _districtController.text = result.amphur;
            districtId = result.id;
            asyncCallTambol(provinceId, districtId);
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
          controller: _districtController,
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
            hintText: 'กรุณาเลือกอำเภอ',
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
            provinceId = result.id;
            _districtController.clear();
            asyncCall2(result.id);
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

  // Widget provinceModal() {
  //   return TextFieldModalBottomSheet(
  //     controller: _provinceController,
  //     hint: 'กรุณาเลือกจังหวัด',
  //     onPress: () => {
  //       FocusScope.of(context).unfocus(),
  //       showModalBottomSheet(
  //         context: context,
  //         builder: (context) {
  //           return Container(
  //               color: Colors.transparent,
  //               child: new Container(
  //                 height: MediaQuery.of(context).copyWith().size.height / 3,
  //                 child: Scaffold(
  //                   appBar: AppBar(
  //                     backgroundColor: Colors.white,
  //                     bottomOpacity: 0.3,
  //                     elevation: 0.5,
  //                     automaticallyImplyLeading: false,
  //                     titleSpacing: 0.0,
  //                     title: Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       crossAxisAlignment: CrossAxisAlignment.center,
  //                       children: <Widget>[
  //                         MaterialButton(
  //                           child: Text('ยกเลิก',
  //                               style: GoogleFonts.prompt(
  //                                   textStyle: TextStyle(
  //                                 color: darkBlue,
  //                                 letterSpacing: 0.5,
  //                                 fontSize:
  //                                     MediaQuery.of(context).size.height * 0.02,
  //                               ))),
  //                           onPressed: () {
  //                             if (_provinceController.text == '') {
  //                               _provinceController.clear();
  //                               _provinceIndexSelected = 0;
  //                             }
  //                             Navigator.pop(context);
  //                           },
  //                         ),
  //                         new Text('เลือกจังหวัด',
  //                             style: GoogleFonts.prompt(
  //                                 textStyle: TextStyle(
  //                               color: darkBlue,
  //                               letterSpacing: 0.5,
  //                               fontSize:
  //                                   MediaQuery.of(context).size.height * 0.025,
  //                             ))),
  //                         MaterialButton(
  //                             child: Text('เลือก',
  //                                 style: GoogleFonts.prompt(
  //                                     textStyle: TextStyle(
  //                                   color: darkBlue,
  //                                   letterSpacing: 0.5,
  //                                   fontSize:
  //                                       MediaQuery.of(context).size.height *
  //                                           0.02,
  //                                 ))),
  //                             onPressed: () {
  //                               Navigator.pop(context);
  //                               setState(() {
  //                                 _provinceController.text =
  //                                     provinceList[_provinceIndexSelected];
  //                                 provinceId =
  //                                     provinces[_provinceIndexSelected].id;
  //                                 asyncCall2(
  //                                     provinces[_provinceIndexSelected].id);
  //                               });
  //                             }),
  //                       ],
  //                     ),
  //                   ),
  //                   body: Container(
  //                     child: CupertinoPicker(
  //                         squeeze: 1.5,
  //                         diameterRatio: 1,
  //                         useMagnifier: true,
  //                         looping: false,
  //                         scrollController: new FixedExtentScrollController(
  //                           initialItem: _provinceIndexSelected,
  //                         ),
  //                         itemExtent: isPhone ? 40.0 : 50.0,
  //                         backgroundColor: Colors.white,
  //                         onSelectedItemChanged: (int index) => setState(() {
  //                               _provinceIndexSelected = index;
  //                             }),
  //                         children: new List<Widget>.generate(
  //                             provinceList.length, (int index) {
  //                           return new Center(
  //                             child: new Text(
  //                               '${provinceList[index]}',
  //                               style: GoogleFonts.prompt(
  //                                 textStyle: TextStyle(
  //                                   color: darkBlue,
  //                                   letterSpacing: 0.5,
  //                                   fontSize:
  //                                       MediaQuery.of(context).size.height *
  //                                           0.02,
  //                                 ),
  //                               ),
  //                             ),
  //                           );
  //                         })),
  //                   ),
  //                 ),
  //               ));
  //         },
  //       )
  //     },
  //   );
  // }

  Widget locationClick() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          MaterialButton(
              color: pinkButton,
              highlightColor: pinkButton,
              padding: const EdgeInsets.all(12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),

              // minWidth: MediaQuery.of(context).size.height * 0.05,
              onPressed: () async {
                FocusScope.of(context).unfocus();
//todoFong
                // LocationResult result = await showLocationPicker(
                //     context, apiKey,
                //     automaticallyAnimateToCurrentLocation: true,
                //     initialCenter: const LatLng(13.7248936, 100.493025),
                //     myLocationButtonEnabled: true,
                //     layersButtonEnabled: true,
                //     countries: ['TH'],
                //     hintText: 'ค้นหาสถานที่',
                //     language: 'th');
                // setState(() {
                //   _pickedLocation = result;
                //   _latitudeController.text = result.latLng.latitude.toString();
                //   _latitude = result.latLng.latitude.toString();
                //   _longitudeController.text =
                //       result.latLng.longitude.toString();
                //   _longitude = result.latLng.longitude.toString();
                // });
              },
              child: Icon(
                Icons.map_outlined,
                color: Colors.white,
                size: MediaQuery.of(context).size.height * 0.025,
              ))
        ]);
  }

  Widget saveButton() {
    return AppButton(
        color: pinkButton,
        textColor: Colors.white,
        text: 'บันทึก',
        onPressed: () {
          if (validate()) {
            // Navigator.of(context).pop();
            if (kDebugMode) {
              print('ที่อยู่ ${_addressNameController.text}');
              print('จังหวัด ${_provinceController.text} : $provinceId');
              print('อำเภอ ${_districtController.text}');
              print('ตำบล ${_subDistrictController.text}');
              print('ละติจูด ${_latitudeController.text}');
              print('ลองจิจูด ${_longitudeController.text}');
            }

            _addressName = _addressNameController.text;

            FidsCrimeSceneDao().updateLocationCase(
                _addressName,
                subDistrictId,
                districtId,
                provinceId,
                _latitudeController.text,
                _longitudeController.text,
                '${widget.caseID}');

            Navigator.of(context).pop(true);
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

  String? provinceLabel(int id) {
    try {
      for (int i = 0; i < provinces.length; i++) {
        if ('$id' == '${provinces[i].id}') {
          return provinces[i].province;
        }
      }
      return '';
    } catch (ex) {
      return '';
    }
  }

  String? amphurLabel(int id) {
    if (kDebugMode) {
      print('idididididid $id');
      print('toStringtoString?${districts.toString()}');
    }
    try {
      for (int i = 0; i < districts.length; i++) {
        if ('$id' == '${districts[i].id}') {
          if (kDebugMode) {
            print('amphuramphuramphur ${districts[i].amphur}');
          }

          return districts[i].amphur;
        }
      }
      return '';
    } catch (ex) {
      return '';
    }
  }

  String? tambolLabel(int id) {
    try {
      for (int i = 0; i < subDistricts.length; i++) {
        if ('$id' == '${subDistricts[i].id}') {
          return subDistricts[i].tambol;
        }
      }
      return '';
    } catch (ex) {
      return '';
    }
  }

  bool validate() {
    return _addressNameController.text != '' &&
        subDistrictId != -1 &&
        districtId != -1 &&
        provinceId != -1 &&
        _latitudeController.text != '' &&
        _longitudeController.text != '';
  }
}
