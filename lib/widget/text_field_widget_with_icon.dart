import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Utils/color.dart';

class InputFieldWithIcon extends StatelessWidget {
  final String? label;
  final IconData prefixIcon;
  final bool obscureText;
  final bool isLastField;
  final Function onChanged;
  final Function? onSubmitted;

  const InputFieldWithIcon({
    super.key,
    required this.label,
    required this.prefixIcon,
    this.obscureText = false,
    this.isLastField = false,
    required this.onChanged,
    this.onSubmitted,
  }) : assert(label != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white.withOpacity(0.6),
      ),
      child: TextFormField(
        textInputAction:
            isLastField ? TextInputAction.done : TextInputAction.next,
        style: TextStyle(
            color: Colors.black87,
            fontSize: MediaQuery.of(context).size.height * 0.025),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(15),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            // borderSide: BorderSide(
            //   color: fadePurple,
            // ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: fadePurple,
            ),
          ),
          hintText: label,
          hintStyle: GoogleFonts.prompt(
            textStyle: TextStyle(
              color: Colors.black54,
              letterSpacing: .5,
              fontSize: MediaQuery.of(context).size.height * 0.025,
            ),
          ),
          prefixIcon: Padding(
            padding:
                const EdgeInsets.only(top: 0, left: 20, right: 20, bottom: 0),
            child: Icon(prefixIcon,
                size: MediaQuery.of(context).size.height * 0.03,
                color: Colors.black54),
          ),
        ),
        obscureText: obscureText,
        onChanged: (val) {
          onChanged(val);
        },
        onFieldSubmitted: (val) {
          onSubmitted ?? onSubmitted!(val);
        },
      ),
    );
  }
}
