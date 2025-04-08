import 'package:agriconnect/Components/customSize.dart';
import 'package:agriconnect/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class CustomButton extends StatelessWidget {
  String title;
  final VoidCallback? onTap;
  bool loading = false;
  double height;
  double width;
  Color? color;
  double radius;
  CustomButton(
      {super.key,
      required this.radius,
      this.color,
      required this.height,
      required this.width,
      required this.title,
      this.onTap,
      required this.loading});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(radius)),
        ),
        child: Center(
          child: loading
              ? CircularProgressIndicator(
                  strokeWidth: CustomSize().customWidth(context) / 200,
                  color: Colors.white,
                )
              : FittedBox(
                  fit: BoxFit.scaleDown,
                  child:
                   Text(
                        title,
                         textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: MyColors.backgroundScaffoldColor
                        ),
                   )
                  ),
        ),
      ),
    );
  }
}
