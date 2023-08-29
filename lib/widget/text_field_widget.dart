import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Utils/color.dart';

class InputField extends StatelessWidget {
  final String hint;
  final bool obscureText;
  final bool isLastField;
  final Function(String)? onChanged;
  final TextEditingController? controller;
  final int? maxLine;
  final bool? isEnabled;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final Function? onFieldSubmitted;

  const InputField({
    super.key,
    required this.hint,
    this.focusNode,
    this.obscureText = false,
    this.isLastField = false,
    this.controller,
    this.maxLine,
    this.isEnabled,
    this.keyboardType,
    this.textInputAction,
    required this.onChanged,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: whiteOpacity,
      ),
      child: TextFormField(
        enabled: isEnabled,
        keyboardType: keyboardType,
        maxLines: maxLine,
        textInputAction: textInputAction ??
            (isLastField ? TextInputAction.done : TextInputAction.next),
        style: GoogleFonts.prompt(
            textStyle: TextStyle(
          color: textColor,
          letterSpacing: 0.5,
          fontSize: MediaQuery.of(context).size.height * 0.02,
        )),
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 16),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: whiteOpacity,
            ),
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
        obscureText: obscureText,
        onChanged: (str) {
          onChanged ?? onChanged!(str);
        },
        controller: controller,
        onFieldSubmitted: (str) {
          onFieldSubmitted ?? onFieldSubmitted!(str);
        },
      ),
    );
  }
}

class TextEditingControllerHelper {
  static insertText(TextEditingController controller, String textToInsert) {
    final selection = controller.selection;
    final cursorPosition = selection.base.offset;
    if (cursorPosition < 0) {
      controller.text += textToInsert;
      return;
    }

    final text = controller.text;
    final newText =
        text.replaceRange(selection.start, selection.end, textToInsert);
    controller.value = controller.value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(
        offset: selection.baseOffset + textToInsert.length,
      ),
    );
  }
}
