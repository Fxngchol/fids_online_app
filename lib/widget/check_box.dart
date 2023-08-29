import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Utils/color.dart';

class CustomCheckBox extends StatelessWidget {
  final String? text;
  final bool isChecked;
  final Function(bool?) onChanged;

  const CustomCheckBox({
    super.key,
    required this.text,
    this.isChecked = false,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 32),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Transform.scale(
          scale: 1.7,
          child: Checkbox(
            value: isChecked,
            checkColor: Colors.white,
            activeColor: pinkButton,
            onChanged: (c) {
              onChanged(c);
            },
          ),
        ),
        SizedBox(width: MediaQuery.of(context).size.width * 0.02),
        Flexible(
          child: Text(
            '$text',
            textAlign: TextAlign.left,
            style: GoogleFonts.prompt(
              textStyle: TextStyle(
                color: Colors.white,
                letterSpacing: .5,
                fontSize: MediaQuery.of(context).size.height * 0.025,
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
