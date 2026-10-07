import 'package:flutter/material.dart';

import '../resources/colors.dart';

class TextWidget extends StatefulWidget {
  final String? text;
  final Color? color;
  final Color? decorationColor;
  final double? fontSize;
  final double? letterSpacing;
  final TextAlign? textAlign;
  final GestureTapCallback? onTap;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final TextOverflow? textOverflow;
  final int? maxLines;
  final double? textHeight;
  final double? decorationThikness;
  final TextStyle? textStyle;
  final TextDecoration? decoration;
  final FontStyle? fontStyle;
  final TextDecorationStyle? decorationStyle;
  const TextWidget({
    super.key,
    this.text,
    this.color = colorBlack,
    this.fontSize,
    // this.fontFamily = strFontNamePoppins,
    this.letterSpacing,
    this.textAlign,
    this.onTap,
    this.fontWeight = FontWeight.normal,
    this.textOverflow,
    this.maxLines,
    this.textHeight,
    this.textStyle,
    this.decoration,
    this.fontStyle,
    this.decorationColor,
    this.decorationStyle,
    this.decorationThikness,
    this.fontFamily,
  });
  @override
  TextWidgetState createState() => TextWidgetState();
}

class TextWidgetState extends State<TextWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      child: Text(
        widget.text!,
        textAlign: widget.textAlign,
        maxLines: widget.maxLines,
        softWrap: true,
        textScaler: TextScaler.linear(1),
        overflow: widget.textOverflow,
        style:
            widget.textStyle ??
            TextStyle(
              color: widget.color,
              height: widget.textHeight,
              fontSize: widget.fontSize ?? 14,
              letterSpacing: widget.letterSpacing,
              decoration: widget.decoration,
              fontFamily: widget.fontFamily,
              fontWeight: widget.fontWeight,
              fontStyle: widget.fontStyle,
              decorationColor: widget.decorationColor,
              decorationStyle: widget.decorationStyle,
              decorationThickness: widget.decorationThikness,
            ),
      ),
    );
  }
}
