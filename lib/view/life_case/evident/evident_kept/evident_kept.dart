import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../Utils/color.dart';
import '../../../../models/CaseEvident.dart';
import '../../../../models/CaseEvidentDeliver.dart';
import '../../../../models/CaseEvidentLocation.dart';
import '../../../../models/Unit.dart';
import '../../../../widget/app_bar_widget.dart';
import '../../../witness_case_obj/evident kept/eveident_kept_witness_obj.dart';
import '../model/CaseEvidentForm.dart';
import 'evident_kept_form.dart';

class EvidentKept extends StatefulWidget {
  final int? caseID;
  final String? caseNo;
  final bool isLocal;
  final bool isLifeCase;

  const EvidentKept(
      {super.key,
      this.caseID,
      this.caseNo,
      this.isLocal = false,
      this.isLifeCase = true});

  @override
  EvidentKeptState createState() => EvidentKeptState();
}

class EvidentKeptState extends State<EvidentKept> {
  bool isPhone = Device.get().isPhone;

  bool isLoading = true;

  List<CaseEvidentForm> caseEvidentForm = [];
  List<Unit> units = [];

  @override
  void initState() {
    super.initState();
    asyncMethod();
  }

  asyncMethod() async {
    asyncCall1();
  }

  void asyncCall1() async {
    var result = await CaseEvidentDao().getCaseEvident(widget.caseID ?? -1);
    var result2 = await UnitDao().getUnit();
    setState(() {
      caseEvidentForm = result ?? [];
      units = result2;
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
        title: 'วัตถุพยานที่ตรวจเก็บ',
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
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    title('รายการวัตถุพยานที่ตรวจเก็บ'),
                    TextButton(
                      child: Row(
                        children: [
                          Icon(
                            Icons.add,
                            size: MediaQuery.of(context).size.height * 0.03,
                            color: Colors.white,
                          ),
                        ],
                      ),
                      onPressed: () async {
                        if (widget.isLifeCase) {
                          var result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EvidentKeptForm(
                                        count: caseEvidentForm.length,
                                        caseID: widget.caseID ?? -1,
                                        caseNo: widget.caseNo,
                                        isEdit: false,
                                      )));

                          if (result) {
                            asyncCall1();
                          }
                        } else {
                          var result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      EvidentKeptWitnessObjForm(
                                        count: caseEvidentForm.length,
                                        caseID: widget.caseID ?? -1,
                                        caseNo: widget.caseNo,
                                        isEdit: false,
                                        caseEvidentForm: CaseEvidentForm(),
                                      )));

                          if (result) {
                            asyncCall1();
                          }
                        }
                      },
                    ),
                  ],
                ),
                caseEvidentForm.isNotEmpty
                    ? Expanded(
                        child: ListView.builder(
                            itemCount: caseEvidentForm.length,
                            itemBuilder: (BuildContext ctxt, int index) {
                              return _listEvident(index);
                            }),
                      )
                    : Expanded(
                        child: Center(
                          child: Text(
                            'ไม่มีข้อมูล',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.prompt(
                              textStyle: TextStyle(
                                color: Colors.white,
                                letterSpacing: .5,
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.02,
                              ),
                            ),
                            maxLines: 1,
                          ),
                        ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _listEvident(index) {
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
      child: TextButton(
        onPressed: () async {
          if (widget.isLifeCase) {
            var result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EvidentKeptForm(
                        count: caseEvidentForm.length,
                        caseID: widget.caseID ?? -1,
                        caseNo: widget.caseNo,
                        caseEvidentForm: caseEvidentForm[index],
                        isEdit: true)));
            if (result) {
              asyncCall1();
            }
          } else {
            var result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EvidentKeptWitnessObjForm(
                        count: caseEvidentForm.length,
                        caseID: widget.caseID ?? -1,
                        caseNo: widget.caseNo,
                        caseEvidentForm: caseEvidentForm[index],
                        isEdit: true)));
            if (result) {
              asyncCall1();
            }
          }
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(top: 16, bottom: 0),
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
                child: Text(
                  'ลำดับที่ ${caseEvidentForm[index].evidentNo}',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.prompt(
                    textStyle: TextStyle(
                      color: textColor,
                      letterSpacing: .5,
                      fontSize: MediaQuery.of(context).size.height * 0.025,
                    ),
                  ),
                  maxLines: 1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
                child: Text(
                  '${caseEvidentForm[index].evidentDetail}',
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
              Padding(
                padding: const EdgeInsets.only(
                    left: 12, right: 12, top: 12, bottom: 12),
                child: Text(
                  'จำนวน ${caseEvidentForm[index].evidentAmount == '-1' ? '' : caseEvidentForm[index].evidentAmount} ${caseEvidentForm[index].evidentUnit}',
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
            ],
          ),
        ),
      ),
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
              fontSize: MediaQuery.of(context).size.height * 0.025,
            ),
          ),
        ),
      ],
    );
  }

  String? unitLabel(String? id) {
    for (int i = 0; i < units.length; i++) {
      if ('$id' == '${units[i].id}') {
        return units[i].name;
      }
    }
    return '';
  }

  void _displaySnackbar(int index) async {
    for (int i = 0;
        i < caseEvidentForm[index].caseEvidentLocation!.length;
        i++) {
      await CaseEvidentLocationDao()
          .delete(caseEvidentForm[index].caseEvidentLocation?[i].id ?? -1);
    }

    for (int i = 0;
        i < caseEvidentForm[index].caseEvidentDeliver!.length;
        i++) {
      await CaseEvidentDeliverDao()
          .delete(caseEvidentForm[index].caseEvidentDeliver?[i].id ?? -1);
    }

    await CaseEvidentDao()
        .deleteCaseEvidentBy(caseEvidentForm[index].id)
        .then((value) {
      asyncCall1();
      if (kDebugMode) {
        print('removing');
      }
      final snackBar = SnackBar(
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
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }
}
