import 'package:fids_online_app/view/traffic_case/case_vehicle/vehicle_detail.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/color.dart';
import '../../../models/CaseCategory.dart';
import '../../../models/CaseEvident.dart';
import '../../../models/FidsCrimeScene.dart';
import '../../../models/Province.dart';
import '../../../models/case_vehicle/CaseDamaged.dart';
import '../../../models/case_vehicle/CaseVehicle.dart';
import '../../../models/case_vehicle/CaseVehicleDao.dart';
import '../../../models/case_vehicle/VehicleBrand.dart';
import '../../../models/case_vehicle/VehicleColor.dart';
import '../../../models/case_vehicle/VehicleType.dart';
import '../../../widget/app_bar_widget.dart';
import '../../../widget/blurry_dialog.dart';
import 'add_vehicle.dart';

class CaseVehicleList extends StatefulWidget {
  final int? caseID;
  final String? caseNo;
  final bool isLocal;

  const CaseVehicleList(
      {super.key, this.caseID, this.caseNo, this.isLocal = false});

  @override
  CaseVehicleListState createState() => CaseVehicleListState();
}

class CaseVehicleListState extends State<CaseVehicleList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isPhone = Device.get().isPhone;
  bool isLoading = true;

  List<CaseVehicle> caseVehicles = [];
  List<VehicleBrand> vehicleBrands = [];
  List<VehicleType> vehicleTypes = [];
  List<VehicleColor> vehicleColors = [];
  List<Province> provinces = [];

  String? caseName;

  @override
  void initState() {
    super.initState();
    asyncMethod();
  }

  asyncMethod() async {
    isLoading = true;
    asyncCall1();
    if (kDebugMode) {
      print('caseID: ${widget.caseID}, caseNo: ${widget.caseNo}');
    }
  }

  void asyncCall1() async {
    var fidsCrimescene =
        await FidsCrimeSceneDao().getFidsCrimeSceneById(widget.caseID ?? -1);
    var caseVehicles =
        await CaseVehicleDao().getCaseVehicle(widget.caseID ?? -1);
    var vehicleBrands = await VehicleBrandDao().getVehicleBrand();
    var vehicleTypeList = await VehicleTypeDao().getVehicleTypeList();
    var vehicleColorList = await VehicleColorDao().getVehicleColor();
    var provinceList = await ProvinceDao().getProvince();

    await CaseCategoryDAO()
        .getCaseCategoryLabelByid(fidsCrimescene?.caseCategoryID ?? -1)
        .then((value) => caseName = value);
    setState(() {
      this.caseVehicles = caseVehicles;
      this.vehicleBrands = vehicleBrands;
      vehicleTypes = vehicleTypeList;
      vehicleColors = vehicleColorList;
      provinces = provinceList;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    return Scaffold(
        extendBodyBehindAppBar: true,
        key: _scaffoldKey,
        appBar: AppBarWidget(
          leading: IconButton(
              icon: isIOS
                  ? const Icon(Icons.arrow_back_ios)
                  : const Icon(Icons.arrow_back),
              onPressed: () async {
                Navigator.of(context).pop(true);
              }),
          title: 'รายการรถของกลาง',
          actions: [
            TextButton(
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: MediaQuery.of(context).size.height * 0.03,
              ),
              onPressed: () async {
                var result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddVehiclePage(
                              isEdit: false,
                              caseID: widget.caseID ?? -1,
                              caseNo: widget.caseNo,
                            )));
                if (result != null) {
                  asyncMethod();
                }
              },
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
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : SafeArea(
                    child: Container(
                        margin: isPhone
                            ? const EdgeInsets.all(32)
                            : const EdgeInsets.only(
                                left: 32, right: 32, top: 32, bottom: 32),
                        child: Column(
                          children: [
                            headerView(),
                            caseVehicles.isNotEmpty
                                ? Expanded(
                                    child: ListView.builder(
                                        itemCount: caseVehicles.length,
                                        itemBuilder:
                                            (BuildContext ctxt, int index) {
                                          return _listItem(index);
                                        }),
                                  )
                                : Expanded(
                                    child: Center(
                                      child: Text(
                                        'ไม่พบรายการรถของกลาง',
                                        style: GoogleFonts.prompt(
                                          textStyle: TextStyle(
                                            color: Colors.white,
                                            letterSpacing: .5,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.015,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                          ],
                        )))));
  }

  Widget _listItem(int index) {
    String? plate = caseVehicles[index].isVehicleRegistrationPlate == '1'
        ? 'แผ่นป้ายทะเบียนหมายเลข ${caseVehicles[index].vehicleRegistrationPlateNo1} ${getProvinceLabal(caseVehicles[index].provinceId)}'
        : 'ไม่ติดแผ่นป้ายทะเบียน';

    String? otherPlate =
        'แผ่นป้ายทะเบียนหมายเลขส่วนพ่วง ${caseVehicles[index].vehicleRegistrationPlateNo2} ${getProvinceLabal(caseVehicles[index].provinceOtherId)}';

    return Slidable(
      endActionPane: ActionPane(
        extentRatio: 0.3,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            flex: 1,
            onPressed: (BuildContext context) {
              _removeCaseVihicle(index);
            },
            backgroundColor: Colors.red,
            icon: Icons.delete,
            label: 'ลบ',
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () async {
          var result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => VehicleDetail(
                        vehicleId: int.parse(caseVehicles[index].id ?? ''),
                        caseID: widget.caseID ?? -1,
                        caseNo: widget.caseNo,
                      )));
          if (result != null) {
            asyncMethod();
          }
        },
        child: Container(
          padding:
              const EdgeInsets.only(left: 12, right: 12, bottom: 6, top: 6),
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${caseVehicles[index].vehicleTypeId == '0' ? caseVehicles[index].vehicleTypeOther : getVehicleTypeLabal(caseVehicles[index].vehicleTypeId)}',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.prompt(
                          textStyle: TextStyle(
                            color: textColor,
                            letterSpacing: .5,
                            fontSize:
                                MediaQuery.of(context).size.height * 0.022,
                          ),
                        ),
                      ),
                      Text(
                        '${caseVehicles[index].vehicleBrandId == '0' ? '${caseVehicles[index].vehicleBrandOther}' : getVehicleBrandLabal(caseVehicles[index].vehicleBrandId)} สี${caseVehicles[index].colorId1 == '0' ? caseVehicles[index].colorOther : getVehicleColorLabal(caseVehicles[index].colorId1)! + (caseVehicles[index].colorId2 != '-1' ? ', สี' : '') + getVehicleColorLabal(caseVehicles[index].colorId2)!}',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.prompt(
                          textStyle: TextStyle(
                            color: textColor,
                            letterSpacing: .5,
                            fontSize:
                                MediaQuery.of(context).size.height * 0.022,
                          ),
                        ),
                      ),
                      Text(
                        plate,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.prompt(
                          textStyle: TextStyle(
                            color: textColor,
                            letterSpacing: .5,
                            fontSize:
                                MediaQuery.of(context).size.height * 0.022,
                          ),
                        ),
                      ),
                      caseVehicles[index].vehicleRegistrationPlateNo2 == '' ||
                              caseVehicles[index].vehicleRegistrationPlateNo2 ==
                                  null
                          ? Container()
                          : Text(
                              otherPlate,
                              textAlign: TextAlign.left,
                              style: GoogleFonts.prompt(
                                textStyle: TextStyle(
                                  color: textColor,
                                  letterSpacing: .5,
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.022,
                                ),
                              ),
                            )
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: textColor,
                )
              ],
            ),
          ),
        ),
      ),
    );
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

  void _removeCaseVihicle(int index) async {
    BlurryDialog alert = BlurryDialog('แจ้งเตือน', 'ยืนยันการลบ', () async {
      await CaseVehicleDao().deleteCaseVehicle(caseVehicles[index].id);
      await CaseDamagedDao()
          .getCaseDamages(
              widget.caseID ?? -1, int.parse(caseVehicles[index].id ?? ''))
          .then((value) {
        // ignore: avoid_function_literals_in_foreach_calls
        value.forEach((element) async {
          await CaseDamagedDao()
              .deleteCaseVehicleDamaged(element.id)
              .then((value) {});
        });
      });
      await CaseEvidentDao()
          .getCaseEvidentTraffic(
              widget.caseID ?? -1, int.parse(caseVehicles[index].id ?? ''))
          .then((value) {
        // ignore: avoid_function_literals_in_foreach_calls
        value.forEach((element) async {
          await CaseEvidentDao().deleteCaseEvidentBy(element.id);
        });
      });
      await CaseVehicleDao()
          .updateCaseVehicleMap(int.parse(caseVehicles[index].id ?? ''), '')
          .then((value) {
        asyncCall1();
        if (kDebugMode) {
          print('removing');
        }
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: const Duration(milliseconds: 300),
            content: Text(
              'ลบสำเร็จ',
              textAlign: TextAlign.center,
              style: GoogleFonts.prompt(
                textStyle: TextStyle(
                  color: Colors.white,
                  letterSpacing: .5,
                  fontSize: MediaQuery.of(context).size.height * 0.02,
                ),
              ),
            )));
      });
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  String? getVehicleTypeLabal(String? id) {
    for (int i = 0; i < vehicleTypes.length; i++) {
      if ('$id' == '${vehicleTypes[i].id}') {
        return vehicleTypes[i].vehicleType;
      }
    }
    return '';
  }

  String? getVehicleBrandLabal(String? id) {
    for (int i = 0; i < vehicleBrands.length; i++) {
      if ('$id' == '${vehicleBrands[i].id}') {
        return '${vehicleBrands[i].brandTH} (${vehicleBrands[i].brandEN})';
      }
    }
    return '';
  }

  String? getVehicleColorLabal(String? id) {
    for (int i = 0; i < vehicleColors.length; i++) {
      if ('$id' == '${vehicleColors[i].id}') {
        return '${vehicleColors[i].vehicleColor}';
      }
    }
    return '';
  }

  String? getProvinceLabal(String? id) {
    for (int i = 0; i < provinces.length; i++) {
      if ('$id' == '${provinces[i].id}') {
        return '${provinces[i].province}';
      }
    }
    return '';
  }
}
