import 'package:flutter/material.dart';

import 'package:sales_management/constant/color.dart';


boxShadow({required BuildContext context,Color color = ColorPalette.black,double blur = 22, double spread =0, double x =0, double y =0, double opacity = 0.1,}){
  return BoxShadow(
    blurRadius: blur,
    spreadRadius: spread,
    offset: Offset(x, y),
    color: color.withOpacity(opacity)
  );
}