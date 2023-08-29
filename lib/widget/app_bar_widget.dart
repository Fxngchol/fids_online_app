import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  const AppBarWidget({super.key, this.title, this.actions, this.leading})
      : preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  final Size preferredSize;

  final String? title;
  final List<Widget>? actions;
  final Widget? leading;

  @override
  AppBarWidgetState createState() => AppBarWidgetState();
}

class AppBarWidgetState extends State<AppBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12),
      child: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Container(
          alignment: Alignment.center,
          child: Text(
            '${widget.title}',
            style: GoogleFonts.prompt(
              textStyle: TextStyle(
                color: Colors.white,
                letterSpacing: 0,
                fontSize: MediaQuery.of(context).size.height * 0.025,
              ),
            ),
            maxLines: 1,
            textAlign: TextAlign.center,
          ),
        ),
        actions: widget.actions,
        leading: widget.leading,
      ),
    );
  }
}
