import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/color.dart';
import '../../../models/CaseInspector.dart';
import '../../../models/Title.dart';
import '../../../widget/app_bar_widget.dart';
import '../../../widget/text_field_widget_with_icon.dart';

class SelectInspector extends StatefulWidget {
  final int caseId;
  const SelectInspector(this.caseId, {super.key});

  @override
  SelectTitleState createState() => SelectTitleState();
}

class SelectTitleState extends State<SelectInspector> {
  bool isPhone = Device.get().isPhone;
  List<CaseInspector> data = [];
  List<CaseInspector> masterData = [];
  List<MyTitle> title = [];

  @override
  void initState() {
    asyncCall();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBarWidget(
        title: 'เลือกเจ้าหน้าที่',
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
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: _searchBar(),
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 0, right: 16, top: 0, bottom: 16),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: whiteOpacity,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 24, right: 24, bottom: 12, top: 12),
                              child: TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(data[index]);
                                },
                                style: OutlinedButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                ),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: Text(
                                      '${titleLabel(data[index].titleId)} ${data[index].firstname?.trim()} ${data[index].lastname?.trim()}',
                                      textAlign: TextAlign.start,
                                      style: GoogleFonts.prompt(
                                        textStyle: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: textColor,
                                          letterSpacing: 0,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.02,
                                        ),
                                      )),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: InputFieldWithIcon(
        label: 'ค้นหา',
        prefixIcon: Icons.search,
        obscureText: false,
        isLastField: true,
        onChanged: (value) {
          if (value.isEmpty || value == '') {
            setState(() {
              data = List<CaseInspector>.from(masterData);
            });
            return;
          }

          data.clear();
          for (int i = 0; i < masterData.length; i++) {
            if ('${masterData[i].firstname}'.contains('$value'.trim()) ||
                '${masterData[i].lastname}'.contains('$value'.trim())) {
              data.add(masterData[i]);
            }
          }
          setState(() {});
        },
      ),
    );
  }

  void asyncCall() async {
    var result = await CaseInspectorDao().getCaseInspector(widget.caseId);
    var result4 = await TitleDao().getTitle();
    setState(() {
      masterData = result;
      title = result4;
      data = List<CaseInspector>.from(masterData);
    });
  }

  String? titleLabel(String? id) {
    for (int i = 0; i < title.length; i++) {
      if ('$id' == '${title[i].id}') {
        return title[i].name?.trim();
      }
    }
    return '';
  }
}
