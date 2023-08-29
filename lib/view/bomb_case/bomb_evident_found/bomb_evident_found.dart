// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/color.dart';
import '../../../models/CaseBomb.dart';
import '../../../widget/app_bar_widget.dart';
import '../../../widget/blurry_dialog.dart';
import 'bomb_evideent_form.dart';

class BombEvidentFound extends StatefulWidget {
  final int? caseID;
  final String? caseNo;

  const BombEvidentFound({super.key, required this.caseID, this.caseNo});

  @override
  // ignore: library_private_types_in_public_api
  _BombEvidentFoundState createState() => _BombEvidentFoundState();
}

class _BombEvidentFoundState extends State<BombEvidentFound> {
  bool isPhone = Device.get().isPhone;
  bool isLoading = true;

  List<CaseBomb>? caseBombs;

  @override
  void initState() {
    super.initState();
    asyncMethod();
  }

  asyncMethod() async {
    asyncCall1();
  }

  void asyncCall1() async {
    var result = await CaseBombDao().getCaseBomb(widget.caseID ?? -1);
    setState(() {
      caseBombs = result;
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
        title: 'วัตถุพยานระเบิดที่ตรวจพบ',
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
            child: ListView.builder(
                itemCount: caseBombs?.length ?? 0 + 1,
                itemBuilder: (BuildContext ctxt, int index) {
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          title('รายการวัตถุพยานระเบิดที่ตรวจพบ'),
                          TextButton(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.add,
                                  size:
                                      MediaQuery.of(context).size.height * 0.03,
                                  color: Colors.white,
                                ),
                                Text(
                                  'เพิ่ม',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.prompt(
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                      letterSpacing: .5,
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.025,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            onPressed: () async {
                              var result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BombEvidentForm(
                                          caseBomb: null,
                                          caseID: widget.caseID ?? -1,
                                          caseNo: widget.caseNo,
                                          isEdit: false)));

                              if (result) {
                                asyncCall1();
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  }
                  return _listEvident(index - 1);
                }),
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
          var result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BombEvidentForm(
                      caseBomb: caseBombs?[index],
                      caseID: widget.caseID ?? -1,
                      caseNo: widget.caseNo,
                      isEdit: true)));

          if (result) {
            asyncCall1();
          }
        },
        child: Container(
          padding:
              const EdgeInsets.only(left: 32, right: 24, bottom: 24, top: 16),
          margin: const EdgeInsets.only(top: 6, bottom: 6),
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'วัตถุระเบิดรายการที่ ${caseBombs?[index].id}',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.prompt(
                          textStyle: TextStyle(
                            color: textColor,
                            letterSpacing: .5,
                            fontSize:
                                MediaQuery.of(context).size.height * 0.025,
                          ),
                        ),
                        maxLines: 1,
                      ),
                    ],
                  ),
                ],
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: textColor,
                size: MediaQuery.of(context).size.height * 0.02,
              )
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

  void _displaySnackbar(int index) async {
    BlurryDialog alert =
        BlurryDialog('แจ้งเตือน', 'ยืนยันการลบวัตถุพยานระเบิด', () async {
      await CaseBombDao().deleteCaseBomb(caseBombs?[index].id);
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

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
