import 'package:flutter/material.dart';
import 'package:sales_management/constant/color.dart';

loading(){
  return  const Center(
    child: CircularProgressIndicator(
      color: ColorPalette.green,
    ),
  );
}