import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';

import '../Utils/color.dart';
import '../widget/app_bar_widget.dart';

class RefUI extends StatefulWidget {
  const RefUI({super.key});

  @override
  RefUIState createState() => RefUIState();
}

class RefUIState extends State<RefUI> {
  bool isPhone = Device.get().isPhone;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'ทดสอบ',
        actions: [
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
            child: ListView(
              children: const [],
            ),
          ),
        ),
      ),
    );
  }
}
