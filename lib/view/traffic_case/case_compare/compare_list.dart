import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/color.dart';
import '../../../models/CaseCategory.dart';
import '../../../models/FidsCrimeScene.dart';
import '../../../models/Province.dart';
import '../../../models/case_vehicle/CaseVehicle.dart';
import '../../../models/case_vehicle/CaseVehicleCompare.dart';
import '../../../models/case_vehicle/CaseVehicleDao.dart';
import '../../../models/case_vehicle/VehicleBrand.dart';
import '../../../models/case_vehicle/VehicleType.dart';
import '../../../widget/app_bar_widget.dart';
import '../../../widget/blurry_dialog.dart';
import 'add_compare.dart';

class CompareListPage extends StatefulWidget {
  final int? caseID;
  final String? caseNo;
  final bool isLocal;

  const CompareListPage(
      {super.key, this.caseID, this.caseNo, this.isLocal = false});

  @override
  State<CompareListPage> createState() => CompareListPageState();
}

class CompareListPageState extends State<CompareListPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isPhone = Device.get().isPhone;
  bool isLoading = true;
  List<CaseVehicleCompare> compareList = [];
  String caseName = '';
  List<VehicleType> vehicleTypes = [];
  List<VehicleBrand> vehicleBrands = [];
  List<CaseVehicle> caseVehicles = [];
  List<Province> provinces = [];
  CaseVehicle caseVehicle1 = CaseVehicle();
  CaseVehicle caseVehicle2 = CaseVehicle();

  @override
  void initState() {
    asyncCall();
    super.initState();
  }

  asyncCall() async {
    var fidsCrimescene =
        await FidsCrimeSceneDao().getFidsCrimeSceneById(widget.caseID ?? -1);

    await CaseCategoryDAO()
        .getCaseCategoryLabelByid(fidsCrimescene?.caseCategoryID ?? -1)
        .then((value) => caseName = value);
    caseVehicles = await CaseVehicleDao().getCaseVehicle(widget.caseID ?? -1);
    vehicleTypes = await VehicleTypeDao().getVehicleTypeList();
    vehicleBrands = await VehicleBrandDao().getVehicleBrand();
    compareList = await CaseVehicleCompareDao()
        .getCaseVehicleCompare(widget.caseID ?? -1);
    provinces = await ProvinceDao().getProvince();

    if (kDebugMode) {
      print(compareList);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    return Scaffold(
        key: _scaffoldKey,
        extendBodyBehindAppBar: true,
        appBar: AppBarWidget(
          leading: IconButton(
              icon: isIOS
                  ? const Icon(Icons.arrow_back_ios)
                  : const Icon(Icons.arrow_back),
              onPressed: () async {
                Navigator.of(context).pop(true);
              }),
          title: 'รายการผลการตรวจเปรียบเทียบ',
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
                        builder: (context) => AddComparePage(
                              isEdit: false,
                              caseID: widget.caseID ?? -1,
                              caseNo: widget.caseNo ?? '',
                            )));
                if (result != null) {
                  asyncCall();
                }
              },
            )
          ],
        ),
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
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
                            compareList.isNotEmpty
                                ? Expanded(
                                    child: ListView.builder(
                                        itemCount: compareList.length,
                                        itemBuilder:
                                            (BuildContext ctxt, int index) {
                                          return _listItem(index);
                                        }),
                                  )
                                : Expanded(
                                    child: Center(
                                      child: Text(
                                        'ไม่พบรายการผลการตรวจเปรียบเทียบ',
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
    caseVehicle1 = getVehicle(compareList[index].caseVehicleId1 ?? '');
    caseVehicle2 = getVehicle(compareList[index].caseVehicleId2 ?? '');

    String plate1 = caseVehicle1.isVehicleRegistrationPlate == '1'
        ? 'แผ่นป้ายทะเบียนหมายเลข ${caseVehicle1.vehicleRegistrationPlateNo1} ${getProvinceLabal(caseVehicle1.provinceId ?? '')}'
        : 'ไม่ติดแผ่นป้ายทะเบียน';
    String otherPlate1 = caseVehicle1.vehicleRegistrationPlateNo2 != '' &&
            caseVehicle1.vehicleRegistrationPlateNo2 != null
        ? 'แผ่นป้ายทะเบียนหมายเลขส่วนพ่วง ${caseVehicle1.vehicleRegistrationPlateNo2} ${getProvinceLabal(caseVehicle1.provinceOtherId ?? '')}'
        : '';

    String plate2 = caseVehicle2.isVehicleRegistrationPlate == '1'
        ? 'แผ่นป้ายทะเบียนหมายเลข ${caseVehicle2.vehicleRegistrationPlateNo1} ${getProvinceLabal(caseVehicle2.provinceId ?? '')}'
        : 'ไม่ติดแผ่นป้ายทะเบียน';
    String otherPlate2 = caseVehicle2.vehicleRegistrationPlateNo2 != '' &&
            caseVehicle2.vehicleRegistrationPlateNo2 != null
        ? 'แผ่นป้ายทะเบียนหมายเลขส่วนพ่วง ${caseVehicle2.vehicleRegistrationPlateNo2} ${getProvinceLabal(caseVehicle2.provinceOtherId ?? '')}'
        : '';

    if (kDebugMode) {
      print(compareList);
    }
    return Slidable(
      endActionPane: ActionPane(
        extentRatio: 0.3,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            flex: 1,
            onPressed: (BuildContext context) {
              _remove(index);
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
                  builder: (context) => AddComparePage(
                        caseVehicleCompare: compareList[index],
                        caseID: widget.caseID ?? -1,
                        caseNo: widget.caseNo ?? '',
                        vehicleCompareId: compareList[index].id ?? '',
                        isEdit: true,
                      )));
          if (result != null) {
            asyncCall();
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
                        'รายการ 5.${index + 1}',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.prompt(
                          textStyle: TextStyle(
                            color: textColor,
                            letterSpacing: .5,
                            fontSize:
                                MediaQuery.of(context).size.height * 0.020,
                          ),
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                            style: GoogleFonts.prompt(
                              textStyle: TextStyle(
                                color: textColor,
                                letterSpacing: .5,
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.020,
                              ),
                            ),
                            children: [
                              TextSpan(
                                text:
                                    '${getVehicleTypeLabel(getVehicleTypeId(compareList[index].caseVehicleId1 ?? ''))} ${getVehicleBrandLabel(getVehicleBrandId(compareList[index].caseVehicleId1 ?? ''))} $plate1 $otherPlate1',
                              ),
                              const TextSpan(
                                  text: ' และ ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  )),
                              TextSpan(
                                text:
                                    '${getVehicleTypeLabel(getVehicleTypeId(compareList[index].caseVehicleId2 ?? ''))} ${getVehicleBrandLabel(getVehicleBrandId(compareList[index].caseVehicleId2 ?? ''))} $plate2 $otherPlate2',
                              )
                            ]),
                      ),
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

  void _remove(int index) async {
    BlurryDialog alert = BlurryDialog('แจ้งเตือน', 'ยืนยันการลบ', () async {
      await CaseVehicleCompareDao()
          .deleteCaseVehicleCompared(compareList[index].id)
          .then((value) {
        asyncCall();
        if (kDebugMode) {
          print('removing');
        }
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
            widget.caseNo ?? '',
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

  dynamic getVehicleTypeLabel(dynamic id) {
    if (id is int) {
      for (int i = 0; i < vehicleTypes.length; i++) {
        if ('$id' == '${vehicleTypes[i].id}') {
          return vehicleTypes[i].vehicleType;
        }
      }
    } else {
      return id;
    }
  }

  dynamic getVehicleBrandLabel(dynamic id) {
    if (id is int) {
      for (int i = 0; i < vehicleBrands.length; i++) {
        if ('$id' == '${vehicleBrands[i].id}') {
          return '${vehicleBrands[i].brandTH?.trim()} (${vehicleBrands[i].brandEN?.trim()})';
        }
      }
    } else {
      return id;
    }
  }

  dynamic getVehicleTypeId(String id) {
    for (int i = 0; i < caseVehicles.length; i++) {
      if (id == '${caseVehicles[i].id}') {
        return caseVehicles[i].vehicleTypeId == '0'
            ? '${caseVehicles[i].vehicleTypeOther}'
            : int.parse(caseVehicles[i].vehicleTypeId ?? '');
      }
    }
  }

  dynamic getVehicleBrandId(String id) {
    for (int i = 0; i < caseVehicles.length; i++) {
      if (id == '${caseVehicles[i].id}') {
        return caseVehicles[i].vehicleBrandId == '0'
            ? '${caseVehicles[i].vehicleBrandOther}'
            : int.parse(caseVehicles[i].vehicleBrandId ?? '');
      }
    }
  }

  CaseVehicle getVehicle(String id) {
    for (int i = 0; i < caseVehicles.length; i++) {
      if (id == '${caseVehicles[i].id}') {
        return caseVehicles[i];
      }
    }
    return CaseVehicle();
  }

  String getProvinceLabal(String id) {
    for (int i = 0; i < provinces.length; i++) {
      if (id == '${provinces[i].id}') {
        return '${provinces[i].province}';
      }
    }
    return '';
  }
}
