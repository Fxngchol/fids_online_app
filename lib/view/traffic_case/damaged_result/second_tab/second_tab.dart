// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../Utils/color.dart';
import '../../../../models/CaseEvident.dart';
import '../../../../widget/blurry_dialog.dart';
import '../../../life_case/evident/model/CaseEvidentForm.dart';
import 'add_second_tab.dart';

class SecondTabPage extends StatefulWidget {
  final int? caseID, vehicleId;
  final String? caseNo, vehicleDetail;
  const SecondTabPage(
      {super.key,
      required this.vehicleId,
      this.vehicleDetail,
      this.caseID,
      this.caseNo});

  @override
  State<SecondTabPage> createState() => SecondTabPageState();
}

class SecondTabPageState extends State<SecondTabPage> {
  List<CaseEvidentForm> evidents = [];
  List<CaseEvidentForm> allEvidents = [];

  @override
  void initState() {
    asyncCall();
    super.initState();
  }

  asyncCall() async {
    await CaseEvidentDao()
        .getCaseEvident(widget.caseID ?? -1)
        .then((allEvidents) async {
      if (kDebugMode) {
        print('allEvidents ${allEvidents.toString()}');
      }
      await CaseEvidentDao()
          .getCaseEvidentTraffic(widget.caseID ?? -1, widget.vehicleId ?? -1)
          .then((value) {
        setState(() {
          this.allEvidents = allEvidents ?? [];
          evidents = value;
          if (kDebugMode) {
            print('evidents: ${evidents.toString()}');
            for (var element in evidents) {
              print('evidents: ${element.evidentNo}');
            }
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        vehicleDetail(),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'รายการวัตถุพยานที่ตรวจเก็บ',
              style: GoogleFonts.prompt(
                textStyle: TextStyle(
                  color: Colors.white,
                  letterSpacing: .5,
                  fontSize: MediaQuery.of(context).size.height * 0.02,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                var result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddSecondTab(
                            vehicleDetail: widget.vehicleDetail,
                            vehicleId: widget.vehicleId,
                            count: evidents.length,
                            caseID: widget.caseID ?? -1,
                            caseNo: widget.caseNo,
                            lastEvidentNo: allEvidents.isNotEmpty
                                ? allEvidents.last.evidentNo?.substring(17, 19)
                                : '0',
                            isEdit: false)));
                if (result != null) {
                  asyncCall();
                }
              },
              child: Row(
                children: [
                  Icon(
                    Icons.add,
                    size: MediaQuery.of(context).size.height * 0.03,
                    color: Colors.white,
                  ),
                  Text(
                    'เพิ่ม',
                    style: GoogleFonts.prompt(
                      textStyle: TextStyle(
                        color: Colors.white,
                        letterSpacing: .5,
                        fontSize: MediaQuery.of(context).size.height * 0.02,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        evidents.isNotEmpty
            ? Expanded(
                child: ListView.builder(
                    itemCount: evidents.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return _listItem(index);
                    }),
              )
            : Expanded(
                child: Center(
                  child: Text(
                    'ไม่พบรายการวัตถุพยาน',
                    style: GoogleFonts.prompt(
                      textStyle: TextStyle(
                        color: Colors.white,
                        letterSpacing: .5,
                        fontSize: MediaQuery.of(context).size.height * 0.015,
                      ),
                    ),
                  ),
                ),
              ),
      ],
    );
  }

  Widget vehicleDetail() {
    return Center(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.03,
              vertical: MediaQuery.of(context).size.width * 0.01),
          child: Text(
            '${widget.vehicleDetail}',
            textAlign: TextAlign.left,
            style: GoogleFonts.prompt(
              textStyle: TextStyle(
                color: textColor,
                letterSpacing: .5,
                fontSize: MediaQuery.of(context).size.height * 0.022,
              ),
            ),
          ),
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
              _removeCaseVihicleDemage(index);
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
                  builder: (context) => AddSecondTab(
                      caseEvidentForm: evidents[index],
                      vehicleDetail: widget.vehicleDetail,
                      vehicleId: widget.vehicleId,
                      count: evidents.length,
                      caseID: widget.caseID ?? -1,
                      caseNo: widget.caseNo,
                      isEdit: true)));
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
                        'EvidentNo: ${evidents[index].evidentNo}',
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
                        '${evidents[index].evidentDetail}',
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

  void _removeCaseVihicleDemage(int index) async {
    BlurryDialog alert = BlurryDialog('แจ้งเตือน', 'ยืนยันการลบ', () async {
      await CaseEvidentDao().deleteCaseEvidentBy(evidents[index].id);
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
