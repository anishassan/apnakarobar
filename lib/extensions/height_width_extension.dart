import 'package:flutter/material.dart';

extension HeightWidthExtension on BuildContext{
  SizedBox  heightBox(double h) => SizedBox(
    height: MediaQuery.sizeOf(this).height * h,
  );
  SizedBox  widthBox(double w) => SizedBox(
    width: MediaQuery.sizeOf(this).height * w,
  );
}