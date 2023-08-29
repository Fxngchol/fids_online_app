import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Utils/color.dart';

class TextFieldModalBottomSheet extends StatelessWidget {
  final String hint;
  final bool isLastField;
  final Function onPress;
  final TextEditingController? controller;
  final Widget? suffixIcon;
  final bool isCanClear;

  const TextFieldModalBottomSheet(
      {super.key,
      required this.hint,
      this.isLastField = false,
      required this.onPress,
      this.controller,
      this.isCanClear = false,
      this.suffixIcon});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: const EdgeInsets.all(0),
      minWidth: 0,
      onPressed: () {
        onPress();
      },
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: whiteOpacity,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          alignment: Alignment.centerRight,
          children: [
            TextFormField(
              maxLines: null,
              controller: controller,
              enabled: false,
              style: GoogleFonts.prompt(
                  textStyle: TextStyle(
                color: textColor,
                letterSpacing: 0.5,
                fontSize: MediaQuery.of(context).size.height * 0.02,
              )),
              decoration: InputDecoration(
                suffixIcon: isCanClear
                    ? null
                    : Icon(Icons.arrow_drop_down_sharp,
                        size: MediaQuery.of(context).size.height * 0.05,
                        color: textColorHint),
                contentPadding: const EdgeInsets.only(
                    left: 20, right: 20, top: 16, bottom: 16),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: hint,
                hintStyle: GoogleFonts.prompt(
                  textStyle: TextStyle(
                    color: textColorHint,
                    letterSpacing: 0.5,
                    fontSize: MediaQuery.of(context).size.height * 0.02,
                  ),
                ),
              ),
            ),
            isCanClear
                ? suffixIcon ??
                    Icon(Icons.arrow_drop_down_sharp,
                        size: MediaQuery.of(context).size.height * 0.05,
                        color: textColorHint)
                : Container(),
          ],
        ),
      ),
    );
  }
}
