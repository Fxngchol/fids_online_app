import 'package:fids_online_app/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppButton extends StatelessWidget {
  final Color color;
  final Color textColor;
  final String text;
  final Widget? image;
  final VoidCallback onPressed;

  const AppButton({
    super.key,
    required this.color,
    required this.textColor,
    required this.text,
    required this.onPressed,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.07,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: double.infinity,
        ),
        child: image != null
            ? OutlinedButton(
                onPressed: onPressed,
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: image,
                    ),
                    Text(
                      text,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: textColor, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )
            : ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(pinkButton),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(pinkButton),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ))),
                onPressed: onPressed,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      text,
                      style: GoogleFonts.prompt(
                        textStyle: TextStyle(
                          color: Colors.white,
                          letterSpacing: .5,
                          fontSize: MediaQuery.of(context).size.height * 0.025,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
