import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/color.dart';
import '../../../models/SubCaseCategory.dart';
import '../../../widget/app_bar_widget.dart';
import '../../../widget/text_field_widget_with_icon.dart';

// ignore: must_be_immutable
class SelectSubCaseCatagory extends StatefulWidget {
  int caseCategoryId;
  SelectSubCaseCatagory(this.caseCategoryId, {super.key});
  @override
  SelectSubCaseCatagoryState createState() => SelectSubCaseCatagoryState();
}

class SelectSubCaseCatagoryState extends State<SelectSubCaseCatagory> {
  bool isPhone = Device.get().isPhone;
  List<SubCaseCategory> data = [];
  List<SubCaseCategory> masterData = [];

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
        title: 'เลือกเหตุคดี',
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
                                  child: Text('${data[index].name}',
                                      textAlign: TextAlign.start,
                                      style: GoogleFonts.prompt(
                                        textStyle: TextStyle(
                                          color: textColor,
                                          letterSpacing: 0,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.025,
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
        label: 'ค้นหาเหตุคดี',
        prefixIcon: Icons.search,
        obscureText: false,
        isLastField: true,
        onChanged: (value) {
          if (value.isEmpty || value == '') {
            setState(() {
              data = List<SubCaseCategory>.from(masterData);
            });
            return;
          }

          data.clear();
          for (int i = 0; i < masterData.length; i++) {
            if ('${masterData[i].name}'.contains('$value'.trim())) {
              data.add(masterData[i]);
            }
          }
          setState(() {});
        },
      ),
    );
  }

  void asyncCall() async {
    var result =
        await SubCaseCategoryDao().getSubCaseCategory(widget.caseCategoryId);
    setState(() {
      masterData = result;
      data = List<SubCaseCategory>.from(masterData);
    });
  }
}
