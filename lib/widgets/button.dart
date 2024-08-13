// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';


enum PButtonType { full, border, text }

class PButton extends StatelessWidget {
  final bool isLoading;
  final String title;
  final Function() onTap;
  final double width;
  final double height;
  final Color backgroundColor;
  Color borderColor;
  final Color textColor;
  final double fontSize;
  final PButtonType buttonType;
  final Widget? prefixIcon;
  final double borderRadius;
  final double? elevation;
  PButton(
      {Key? key,
      this.isLoading = false,
      required this.title,
      required this.onTap,
      this.width = double.infinity,
      this.height = 45,
      this.fontSize = 16,
      this.prefixIcon,
      this.backgroundColor = Colors.green,
      this.textColor = Colors.white,
      this.borderRadius = 12,
      this.buttonType = PButtonType.full,
      this.borderColor = Colors.transparent,
      this.elevation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: width,
      elevation: elevation ?? 0,
      color: buttonType == PButtonType.text ? null : backgroundColor,
      shape: RoundedRectangleBorder(
          side: buttonType == PButtonType.full ||
                  buttonType == PButtonType.text
              ? BorderSide.none
              : BorderSide(
                  color: borderColor,
                ),
          borderRadius: BorderRadius.all(Radius.circular(7))),
      height: height,
      onPressed: onTap,
      child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                prefixIcon != null
                    ? Container(
                        padding: EdgeInsets.only(right: 8),
                        child: prefixIcon,
                      )
                    : Container(),
                Text(
                  title,
                  style: TextStyle(
                    // change this to the formatted text style
                    fontSize: fontSize,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
              ],
            ),
    );
  }
}
