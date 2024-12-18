import 'package:flutter/material.dart';

extension HeightWidthExtension on BuildContext{
  SizedBox  heightBox(double h) => SizedBox(
    height: MediaQuery.of(this).size.height * h,
  );
  SizedBox  widthBox(double w) => SizedBox(
    width: MediaQuery.of(this).size.height * w,
  );
}