import 'package:fids_online_app/view/life_case/plan_case/plan_case.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import '../../../Utils/color.dart';
import '../../../models/DiagramLocation.dart';
import '../../../widget/app_bar_widget.dart';

class ShowPlancase extends StatefulWidget {
  final int? caseID;
  final String? caseNo;
  final bool isLocal;

  const ShowPlancase(
      {super.key, this.caseID, this.caseNo, this.isLocal = false});

  @override
  ShowPlancaseState createState() => ShowPlancaseState();
}

class ShowPlancaseState extends State<ShowPlancase> {
  bool isLoading = false;
  bool isPhone = Device.get().isPhone;
  Image? image;
  DiagramLocation diagramLocation = DiagramLocation();
  bool isEdit = false;

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
        await DiagramLocationDao().getDiagramLocation('${widget.caseID}');
    setState(() {
      diagramLocation = result;
      diagramLocation.diagram =
          diagramLocation.diagram?.replaceAll("data:image/png;base64,", "");
      isLoading = false;
      if (diagramLocation.diagram != null && diagramLocation.diagram != '') {
        isEdit = true;
      } else {
        isEdit = false;
      }
      if (kDebugMode) {
        print('isEDIT ${diagramLocation.diagram != null}');
        print('isEDIT ${diagramLocation.diagram != ''}');

        print('isEDIT $isEdit');
      }
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
          title: 'แผนผังสังเขป',
          actions: [
            TextButton(
              child: Icon(Icons.edit,
                  color: Colors.white,
                  size: MediaQuery.of(context).size.height * 0.025),
              onPressed: () async {
                dynamic result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PlanCase(
                              caseID: widget.caseID ?? -1,
                              caseNo: widget.caseNo,
                              isLocal: widget.isLocal,
                              isUpdate: diagramLocation.diagram != null
                                  ? true
                                  : false,
                              isEdit: isEdit,
                            )));
                if (result) {
                  if (kDebugMode) {
                    print('isBack');
                  }
                  await asyncMethod();
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
            child: SafeArea(
                child: Container(
                    margin: isPhone
                        ? const EdgeInsets.all(32)
                        : const EdgeInsets.only(
                            left: 32, right: 32, top: 32, bottom: 32),
                    child: ListView(children: [
                      spacer(context),
                      Container(
                        color: Colors.white,
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: diagramLocation.diagram == null ||
                                diagramLocation.diagram == ''
                            ? Container()
                            : Image.memory(
                                base64Decode(diagramLocation.diagram ?? '')),
                      ),
                      spacer(context),
                      spacer(context),
                      header('หมายเหตุ'),
                      spacer(context),
                      detailView(_cleanText(diagramLocation.diagramRemark)),
                      spacer(context),
                      spacer(context),
                    ])))));
  }

  Widget spacer(context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.015,
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

  Widget detailView(String? text) {
    return Container(
      decoration: BoxDecoration(
          color: whiteOpacity, borderRadius: BorderRadius.circular(8)),
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: isPhone
            ? const EdgeInsets.only(left: 24, right: 24, top: 10, bottom: 10)
            : const EdgeInsets.only(left: 32, right: 32, top: 20, bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$text',
                    textAlign: TextAlign.left,
                    style: GoogleFonts.prompt(
                      textStyle: TextStyle(
                        color: textColor,
                        letterSpacing: .5,
                        fontSize: MediaQuery.of(context).size.height * 0.025,
                      ),
                    ),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
