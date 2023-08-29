import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/color.dart';
import '../../../models/Amphur.dart';
import '../../../models/CaseCategory.dart';
import '../../../models/FidsCrimeScene.dart';
import '../../../models/Province.dart';
import '../../../models/Tambol.dart';
import '../../../widget/app_bar_widget.dart';
import 'edit_location_case.dart';

class LocationCase extends StatefulWidget {
  final int? caseID;
  final String? caseNo;
  final bool isLocal;

  const LocationCase(
      {super.key, this.caseID, this.caseNo, this.isLocal = false});

  @override
  LocationCaseState createState() => LocationCaseState();
}

class LocationCaseState extends State<LocationCase> {
  bool isLoading = true;

  bool isPhone = Device.get().isPhone;
  // final Completer<GoogleMapController> _controller = Completer();

  FidsCrimeScene data = FidsCrimeScene();

  String? provinceName;
  String? amphurName;
  String? tambolName;
  String? caseName;

  @override
  void initState() {
    super.initState();
    asyncMethod();
  }

  asyncMethod() async {
    asyncCall1();
    asyncCall2();
  }

  void asyncCall1() async {
    var result =
        await FidsCrimeSceneDao().getFidsCrimeSceneById(widget.caseID ?? -1);
    setState(() {
      data = result ?? FidsCrimeScene();
      // isLoading = false;
    });

    await CaseCategoryDAO()
        .getCaseCategoryLabelByid(data.caseCategoryID ?? -1)
        .then((value) => caseName = value);

    asyncCall2();
  }

  void asyncCall2() async {
    try {
      var result1 =
          await ProvinceDao().getProvinceLabelById(data.sceneProvinceID ?? -1);
      setState(() {
        provinceName = result1;
      });
      asyncCall3();
    } catch (ex) {
      provinceName = '';
      amphurName = '';
      tambolName = '';
      isLoading = false;
    }
  }

  void asyncCall3() async {
    try {
      var result1 =
          await AmphurDao().getAmphurLabelByid(data.sceneAmphurID ?? -1);
      setState(() {
        amphurName = result1;
      });
      asyncCall4();
    } catch (ex) {
      amphurName = '';
      tambolName = '';
      isLoading = false;
    }
  }

  void asyncCall4() async {
    if (kDebugMode) {
      print('asyncCall4');
    }
    try {
      var result1 =
          await TambolDao().getTambolLabelByid(data.sceneTambolID ?? -1);
      if (kDebugMode) {
        print('ggggg $result1');
      }
      setState(() {
        tambolName = result1;
        isLoading = false;
      });
    } catch (ex) {
      if (kDebugMode) {
        print('asyncCall4 ex : ${ex.toString()}');
      }
      tambolName = '';
      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBarWidget(
          title: 'สถานที่เกิดเหตุ',
          leading: IconButton(
              icon: isIOS
                  ? const Icon(Icons.arrow_back_ios)
                  : const Icon(Icons.arrow_back),
              onPressed: () async {
                Navigator.of(context).pop(true);
              }),
          actions: [
            TextButton(
              child: Icon(Icons.edit,
                  color: Colors.white,
                  size: MediaQuery.of(context).size.height * 0.025),
              onPressed: () async {
                //Navigator.pushNamed(context, '/editlocationcase');
                var result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditLocationCase(
                              caseID: widget.caseID ?? -1,
                              caseNo: widget.caseNo,
                            )));
                if (result) {
                  asyncCall1();
                  asyncCall2();
                  asyncCall3();
                  asyncCall4();
                }
              },
            )
          ],
        ),
        body: _body());
  }

  Widget _body() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
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
          child: ListView(
            children: [
              headerView(),
              //spacer(context),
              header('ที่อยู่ (บ้านเลขที่/ซอย/ถนน)'),
              spacer(context),
              detailView('${_cleanText(data.sceneDescription)}'),
              spacer(context),
              header('ตำบล/แขวง'),
              spacer(context),
              detailView('${_cleanText(tambolName)}'),
              spacer(context),
              header('อำเภอ/เขต'),
              spacer(context),
              detailView('${_cleanText(amphurName)}'),
              spacer(context),
              header('จังหวัด'),
              spacer(context),
              detailView('${_cleanText(provinceName)}'),
              spacer(context),
              header('พิกัดตำแหน่ง'),
              spacer(context),
              _mapShow(data),
              spacer(context),
              header('ละติจูด'),
              spacer(context),
              detailView(data.isoLatitude != null
                  ? '${_cleanText(data.isoLatitude)}'
                  : ''),
              spacer(context),
              header('ลองจิจูด'),
              spacer(context),
              detailView(data.isoLongtitude != null
                  ? '${_cleanText(data.isoLongtitude)}'
                  : ''),
              spacer(context),
            ],
          ),
        )));
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

  Widget detailView(String? text) {
    return Container(
      decoration: BoxDecoration(
          color: whiteOpacity, borderRadius: BorderRadius.circular(8)),
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: isPhone
            ? const EdgeInsets.only(left: 24, right: 24, top: 10, bottom: 10)
            : const EdgeInsets.only(left: 32, right: 32, top: 20, bottom: 20),
        child: Text('$text',
            textAlign: TextAlign.left,
            style: GoogleFonts.prompt(
              textStyle: TextStyle(
                color: textColor,
                letterSpacing: .5,
                fontSize: MediaQuery.of(context).size.height * 0.025,
              ),
            )),
      ),
    );
  }

  Widget _mapShow(FidsCrimeScene data) {
    double lat;
    double lon;
    double zoom;

    if (data.isoLatitude != null &&
        data.isoLongtitude != null &&
        data.isoLatitude != '' &&
        data.isoLongtitude != '') {
      if (data.isoLatitude == '' && data.isoLongtitude == '') {
        lat = 13.03887;
        lon = 101.490104;
        zoom = 5;
      } else {
        lat = double.parse(data.isoLatitude ?? '');
        lon = double.parse(data.isoLongtitude ?? '');
        zoom = 16;
      }

      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width * 0.8,
            height: 250,
            // child: GoogleMap(
            //   markers: {
            //     Marker(
            //       markerId: const MarkerId('0'),
            //       // position: LatLng(double.parse( mapPosition.latitude),  double.parse( mapPosition.latitude)),
            //       position: LatLng(lat, lon),
            //       //icon: _markerIcon,
            //     )
            //   },
            //   myLocationEnabled: false,
            //   initialCameraPosition: CameraPosition(
            //     target: LatLng(lat, lon),
            //     /* LatLng(double.parse( mapPosition.latitude),  double.parse( mapPosition.latitude)), //กำหนดพิกัดเริ่มต้นบนแผนที่*/
            //     zoom: zoom, //กำหนดระยะการซูม สามารถกำหนดค่าได้ 0-20
            //   ),
            //   onMapCreated: (GoogleMapController controller) {
            //     _controller.complete(controller);
            //   },
          ),
          // ),
          const SizedBox(
            height: 20,
          )
        ],
      );
    } else {
      lat = 13.03887;
      lon = 101.490104;
      zoom = 5;
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width * 0.8,
            height: 250,
            // child: GoogleMap(
            //   myLocationEnabled: false,
            //   initialCameraPosition: CameraPosition(
            //     target: LatLng(lat, lon),
            //     /* LatLng(double.parse( mapPosition.latitude),  double.parse( mapPosition.latitude)), //กำหนดพิกัดเริ่มต้นบนแผนที่*/
            //     zoom: zoom, //กำหนดระยะการซูม สามารถกำหนดค่าได้ 0-20
            //   ),
            //   onMapCreated: (GoogleMapController controller) {
            //     _controller.complete(controller);
            //   },
            // ),
          ),
          const SizedBox(
            height: 20,
          )
        ],
      );
    }
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
}
