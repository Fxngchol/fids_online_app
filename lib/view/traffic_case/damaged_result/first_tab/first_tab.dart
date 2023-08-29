import 'package:fids_online_app/view/traffic_case/damaged_result/first_tab/sides_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../Utils/color.dart';
import '../../../../models/case_vehicle/CaseDamaged.dart';
import '../../../../models/case_vehicle/VehicleSide.dart';
import '../../../../widget/blurry_dialog.dart';

class FirstTabPage extends StatefulWidget {
  final int? caseID, vehicleId;
  final String? caseNo, vehicleDetail;
  const FirstTabPage(
      {super.key,
      this.vehicleId,
      this.vehicleDetail,
      this.caseID,
      this.caseNo});

  @override
  State<FirstTabPage> createState() => FirstTabPageState();
}

class FirstTabPageState extends State<FirstTabPage> {
  List<CaseDamaged> caseDamages = [];
  List<VehicleSide> sides = [];
  List<int> count = [];

  @override
  void initState() {
    asyncCall();
    super.initState();
  }

  asyncCall() async {
    sides = await VehicleSideDao().getVehicleSideList();
    asyncGetCount();
    await CaseDamagedDao()
        .getCaseDamages(widget.caseID ?? -1, widget.vehicleId ?? -1)
        .then((value) {
      setState(() {
        caseDamages = value;
        if (kDebugMode) {
          print('caseDamages: ${caseDamages.toString()}');
        }
      });
    });
  }

  asyncGetCount() {
    count.clear();
    // ignore: avoid_function_literals_in_foreach_calls
    sides.forEach((element) async {
      await CaseDamagedDao()
          .getCountOfCaseDamagesBySide(
              widget.caseID ?? -1, widget.vehicleId ?? -1, element.id ?? -1)
          .then((value) {
        if (kDebugMode) {
          print(value);
        }
        setState(() {
          count.add(value);
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
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        // Text(
        //   'รายการผลตรวจพิสูจน์',
        //   style: GoogleFonts.prompt(
        //     textStyle: TextStyle(
        //       color: Colors.white,
        //       letterSpacing: .5,
        //       fontSize: MediaQuery.of(context).size.height * 0.02,
        //     ),
        //   ),
        // ),
        // TextButton(
        //   onPressed: () async {
        //     var result = await Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //             builder: (context) => AddFisrtTab(
        //                 vehicleId: widget.vehicleId,
        //                 vehicleDetail: widget.vehicleDetail,
        //                 caseID: widget.caseID ?? -1,
        //                 caseNo: widget.caseNo,
        //                 isEdit: false)));
        //     if (result) {
        //       asyncCall();
        //     }
        //   },
        //   child: Row(
        //     children: [
        //       Icon(
        //         Icons.add,
        //         size: MediaQuery.of(context).size.height * 0.03,
        //         color: Colors.white,
        //       ),
        //       Text(
        //         'เพิ่ม',
        //         style: GoogleFonts.prompt(
        //           textStyle: TextStyle(
        //             color: Colors.white,
        //             letterSpacing: .5,
        //             fontSize: MediaQuery.of(context).size.height * 0.02,
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        //   ],
        // ),
        Expanded(
          child: ListView.builder(
              itemCount: sides.length,
              itemBuilder: (BuildContext ctxt, int index) {
                return _listItem(index);
              }),
        )
      ],
    );
  }

  Widget vehicleDetail() {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.03,
              vertical: MediaQuery.of(context).size.width * 0.01),
          child: Text(
            widget.vehicleDetail ?? '',
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
                  builder: (context) => SideListPage(
                      vehicleId: widget.vehicleId,
                      vehicleDetail: widget.vehicleDetail,
                      caseID: widget.caseID ?? -1,
                      caseNo: widget.caseNo,
                      sideId: sides[index].id,
                      sideName: sides[index].vehicleSide)));
          if (result != null) {
            asyncGetCount();
            if (kDebugMode) {
              print(count);
            }
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.12,
                      child: Text(
                        '${sides[index].vehicleSide}',
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
                    ),
                    Text(
                      '(${count[index]})',
                      textAlign: TextAlign.left,
                      style: GoogleFonts.prompt(
                        textStyle: TextStyle(
                          color: textColor,
                          letterSpacing: .5,
                          fontSize: MediaQuery.of(context).size.height * 0.022,
                        ),
                      ),
                    ),
                  ],
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
      await CaseDamagedDao()
          .deleteCaseVehicleDamaged(caseDamages[index].id)
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
}
