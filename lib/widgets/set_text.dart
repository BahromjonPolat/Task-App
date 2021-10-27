import 'package:flutter/material.dart';

Text setSimpleText(
    String text, {
      Color? color,
      double? size,
      FontWeight? weight,
    }) =>
    Text(
      text,
      style: TextStyle(
        color: color ?? colorBlack,
        fontSize: size ?? 14.0,
        fontWeight: weight ?? FontWeight.normal,
      ),
    );