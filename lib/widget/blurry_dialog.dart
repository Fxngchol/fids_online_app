import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Utils/color.dart';

class BlurryDialog extends StatelessWidget {
  final String? title;
  final String? content;
  final VoidCallback continueCallBack;

  const BlurryDialog(this.title, this.content, this.continueCallBack,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: AlertDialog(
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: Text(
            title ?? '',
            style: GoogleFonts.prompt(
                textStyle: TextStyle(
              fontWeight: FontWeight.w500,
              color: textColor,
              letterSpacing: 0.5,
              fontSize: MediaQuery.of(context).size.height * 0.025,
            )),
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width / 2,
            child: Text(
              content ?? '',
              style: GoogleFonts.prompt(
                  textStyle: TextStyle(
                color: textColor,
                letterSpacing: 0.5,
                fontSize: MediaQuery.of(context).size.height * 0.02,
              )),
            ),
          ),
          actions: <Widget>[
            MaterialButton(
              child: Text(
                'ยกเลิก',
                style: GoogleFonts.prompt(
                  textStyle: TextStyle(
                    color: textColor,
                    letterSpacing: 0.5,
                    fontSize: MediaQuery.of(context).size.height * 0.018,
                  ),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            MaterialButton(
              child: Text(
                'ยืนยัน',
                style: GoogleFonts.prompt(
                  textStyle: TextStyle(
                    color: textColor,
                    letterSpacing: 0.5,
                    fontSize: MediaQuery.of(context).size.height * 0.018,
                  ),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                continueCallBack();
              },
            ),
          ],
        ));
  }
}
