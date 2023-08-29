import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../Utils/color.dart';
import '../../../../models/CaseReferencePoint.dart';
import '../../../../widget/app_bar_widget.dart';
import 'add_reference_point.dart';

class ReferencePoint extends StatefulWidget {
  final int? caseID;
  final String? caseNo;
  final bool isEdit;

  const ReferencePoint(
      {super.key, this.caseID, this.caseNo, this.isEdit = false});

  @override
  ReferencePointState createState() => ReferencePointState();
}

class ReferencePointState extends State<ReferencePoint> {
  bool isPhone = Device.get().isPhone;
  List<CaseReferencePoint> referencePointList = [];
  // ReferencePointModel referencePoint = ReferencePointModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    asyncMethod();
  }

  asyncMethod() async {
    asyncCall1();
  }

  void asyncCall1() async {
    var result =
        await CaseReferencePointDao().getCaseReferencePoint('${widget.caseID}');

    setState(() {
      referencePointList = result;

      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      key: _scaffoldKey,
      appBar: AppBarWidget(
        title: 'เพิ่มจุดอ้างอิง',
        actions: [
          TextButton(
            onPressed: onSave,
            child: Text(
              'บันทึก',
              textAlign: TextAlign.center,
              style: GoogleFonts.prompt(
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: MediaQuery.of(context).size.height * 0.02,
                ),
              ),
            ),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'รายการจุดอ้างอิง',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.prompt(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.03,
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.transparent,
                              ),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ))),
                          onPressed: () async {
                            var result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddReferencePoint(
                                        caseID: widget.caseID ?? -1,
                                        caseNo: widget.caseNo,
                                        isEdit: false)));
                            if (result) {
                              asyncCall1();
                            }
                          },
                          child: Row(
                            children: [
                              const Icon(Icons.add, color: Colors.white),
                              Text(
                                'เพิ่ม',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.prompt(
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                    letterSpacing: .5,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.03,
                                  ),
                                ),
                              ),
                            ],
                          ))
                    ],
                  ),
                  referencePointList.isNotEmpty
                      ? Expanded(
                          child: ListView.builder(
                              itemCount: referencePointList.length,
                              itemBuilder: (BuildContext ctxt, int index) {
                                return _listItem(index);
                              }),
                        )
                      : Expanded(
                          child: Center(
                            child: Text(
                              'ไม่มีข้อมูล',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.prompt(
                                textStyle: TextStyle(
                                  color: Colors.white70,
                                  letterSpacing: .5,
                                  fontSize:
                                      MediaQuery.of(context).size.height * 0.02,
                                ),
                              ),
                            ),
                          ),
                        ),
                ],
              )),
        ),
      ),
    );
  }

  Widget _listItem(int index) {
    return Slidable(
      endActionPane: ActionPane(
        extentRatio: 0.3,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            flex: 1,
            onPressed: (BuildContext context) {
              _displaySnackbar(index);
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
                  builder: (context) => AddReferencePoint(
                      caseID: widget.caseID ?? -1,
                      caseNo: widget.caseNo,
                      caseReferencePoint: referencePointList[index],
                      isEdit: true)));
          if (result) {
            asyncCall1();
          }
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'จุดอ้างอิงที่ ${referencePointList[index].referencePointNo}',
                      textAlign: TextAlign.start,
                      style: GoogleFonts.prompt(
                        textStyle: TextStyle(
                          color: textColor,
                          letterSpacing: .5,
                          fontSize: MediaQuery.of(context).size.height * 0.025,
                        ),
                      ),
                    ),
                    Text(
                      '${referencePointList[index].referencePointDetail}',
                      textAlign: TextAlign.start,
                      style: GoogleFonts.prompt(
                        textStyle: TextStyle(
                          color: textColor,
                          letterSpacing: .5,
                          fontSize: MediaQuery.of(context).size.height * 0.03,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _displaySnackbar(int index) async {
    await CaseReferencePointDao()
        .deleteCaseReferencePoint(referencePointList[index].id ?? -1)
        .then((value) {
      asyncCall1();

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
  }

  void onSave() {
    //referencePointList.toString();
    Navigator.of(context).pop(true);
  }
}
