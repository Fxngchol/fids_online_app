import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:signature/signature.dart';

import '../../../Utils/color.dart';
import '../../../widget/app_bar_widget.dart';
import '../../../widget/app_button.dart';

class DrawReferencePosition extends StatefulWidget {
  const DrawReferencePosition({super.key});

  @override
  DrawReferencePositionState createState() => DrawReferencePositionState();
}

class DrawReferencePositionState extends State<DrawReferencePosition> {
  bool isPhone = Device.get().isPhone;

  final SignatureController _controller = SignatureController(
    penStrokeWidth: 5,
    penColor: pinkButton,
    exportBackgroundColor: fadePurple,
  );

  @override
  void initState() {
    super.initState();
    // ignore: avoid_print
    _controller.addListener(() => print("Value changed"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(
          title: 'เพิ่มระยะอ้างอิง',
          actions: [
            // TextButton(
            //   child: Icon(
            //     Icons.edit,
            //     color: Colors.white,
            //   ),
            //   onPressed: () {},
            // )
            Container(
              width: MediaQuery.of(context).size.width * 0.1,
            )
          ],
        ),
        body: Container(
            color: darkBlue,
            child: SafeArea(
                child: Container(
                    margin: isPhone
                        ? const EdgeInsets.all(32)
                        : const EdgeInsets.only(
                            left: 32, right: 32, top: 32, bottom: 32),
                    child: ListView(children: [
                      //         Container(
                      //   height: 300,
                      //   child: Center(
                      //     child: Text('Big container to test scrolling issues'),
                      //   ),
                      // ),
                      //SIGNATURE CANVAS
                      Signature(
                        controller: _controller,
                        height: MediaQuery.of(context).size.height * 0.6,
                        backgroundColor: fadePurple,
                      ),
                      //OK AND CLEAR BUTTONS
                      Container(
                        decoration: const BoxDecoration(color: Colors.black),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            //SHOW EXPORTED IMAGE IN NEW ROUTE
                            // IconButton(
                            //   icon: const Icon(Icons.check),
                            //   color: Colors.blue,
                            //   onPressed: () async {
                            //     if (_controller.isNotEmpty) {
                            //       var data = await _controller.toPngBytes();
                            //       Navigator.of(context).push(
                            //         MaterialPageRoute(
                            //           builder: (BuildContext context) {
                            //             return Scaffold(
                            //               appBar: AppBar(),
                            //               body: Center(
                            //                   child: Container(
                            //                       color: Colors.grey[300], child: Image.memory(data))),
                            //             );
                            //           },
                            //         ),
                            //       );
                            //     }
                            //   },
                            // ),
                            //CLEAR CANVAS
                            IconButton(
                              icon: const Icon(Icons.clear),
                              color: Colors.blue,
                              onPressed: () {
                                setState(() => _controller.clear());
                              },
                            ),
                          ],
                        ),
                      ),
                      // Container(
                      //   height: 300,
                      //   child: Center(
                      //     child: Text('Big container to test scrolling issues'),
                      //   ),
                      // ),

                      spacer(context),
                      spacer(context),
                      saveButton(),
                      spacer(context),
                      spacer(context),
                    ])))));
  }

  Widget spacer(context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.015,
    );
  }

  Widget saveButton() {
    return AppButton(
        color: pinkButton,
        textColor: Colors.white,
        text: 'บันทึก',
        onPressed: () {
          //Navigator.pushReplacementNamed(context, '/drawreferencepostion');
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        });
  }
}
