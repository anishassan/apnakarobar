import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:sales_management/constant/color.dart';
import 'package:sales_management/extensions/font_size_extension.dart';
import 'package:sales_management/extensions/locale_extension.dart';
import 'package:sales_management/extensions/size_extension.dart';
import 'package:sales_management/utils/box_shadow.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

textField(
    {required BuildContext context,
    TextEditingController? controller,
    required String hintText,
    bool isObscure = false,
    Color hintColor = Colors.black,
    bool isPasswordField = false,
    GestureDetector? suffixIcon,
    GestureDetector? prefixIcon,
    Function(String?)? onChange,
    Function(String?)? onSubmit,
    Color bgColor = ColorPalette.white,
    double opacity = 1,
    TextInputType textInputType = TextInputType.text,
    bool readOnly = false,
    double width = 1,
    VoidCallback? onTap}) {
  final border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide.none,
  );
  return Container(
    width: context.getSize.width * width,
    decoration: BoxDecoration(
        color: bgColor.withOpacity(opacity),
        boxShadow: [
          boxShadow(
              context: context,
              color: Colors.black,
              opacity: 0.2,
              y: 5,
              blur: 5),
        ],
        borderRadius: BorderRadius.circular(20)),
    child: TextFormField(
      keyboardType: textInputType,
      onTap: onTap,
      onChanged: (String? val) {
        if (onChange != null) {
          onChange(val);
        }
      },
      onFieldSubmitted: (String? v) {
        if (onSubmit != null) {
          onSubmit(v);
        }
      },
      obscureText: isObscure,
      controller: controller,
      style: TextStyle(
        fontSize: context.fontSize(13),
        fontWeight: FontWeight.w400,
        color: Colors.black,
        fontFamily: 'Poppins',
      ),
      readOnly: readOnly,
      decoration: InputDecoration(
          hintText: context.getLocal(hintText),
          hintStyle: TextStyle(
            fontSize: context.fontSize(13),
            fontWeight: FontWeight.w400,
            color: hintColor,
            fontFamily: 'Poppins',
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          border: border,
          errorBorder: border,
          enabledBorder: border,
          focusedBorder: border,
          disabledBorder: border,
          focusedErrorBorder: border,
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon),
    ),
  );
}

numberTextField(
    {required BuildContext context,
    required TextEditingController controller,
    required String hintText,
    bool isObscure = false,
    Color hintColor = Colors.black,
    bool isPasswordField = false,
    GestureDetector? suffixIcon,
    GestureDetector? prefixIcon,
    Function(String?)? onChange,
    Color bgColor = ColorPalette.white,
    double opacity = 1,
    TextInputType textInputType = TextInputType.text,
    bool readOnly = false,
    bool isFormatter = true,
    VoidCallback? onTap}) {
  final border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide.none,
  );
  return Container(
    decoration: BoxDecoration(
        color: bgColor.withOpacity(opacity),
        boxShadow: [
          boxShadow(
              context: context,
              color: Colors.black,
              opacity: 0.2,
              y: 5,
              blur: 5),
        ],
        borderRadius: BorderRadius.circular(20)),
    child: TextFormField(
      inputFormatters: isFormatter? [
        FilteringTextInputFormatter.digitsOnly, // Allows only numbers
      ]:[],
      keyboardType: textInputType,
      onTap: onTap,
      onChanged: (String? val) {
        if (onChange != null) {
          onChange(val);
        }
      },
      obscureText: isObscure,
      controller: controller,
      style: TextStyle(
        fontSize: context.fontSize(13),
        fontWeight: FontWeight.w400,
        color: Colors.black,
        fontFamily: 'Poppins',
      ),
      readOnly: readOnly,
      decoration: InputDecoration(
          hintText: context.getLocal(hintText),
          hintStyle: TextStyle(
            fontSize: context.fontSize(13),
            fontWeight: FontWeight.w400,
            color: hintColor,
            fontFamily: 'Poppins',
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          border: border,
          errorBorder: border,
          enabledBorder: border,
          focusedBorder: border,
          disabledBorder: border,
          focusedErrorBorder: border,
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon),
    ),
  );
}

catTextField(
    {required BuildContext context,
    required TextEditingController controller,
    required String hintText,
    bool isObscure = false,
    Color hintColor = Colors.black,
    bool isPasswordField = false,
    GestureDetector? suffixIcon,
    Function(String?)? onChange,
    bool isCatAdded = true,
    TextInputType textInputType = TextInputType.text,
    bool readOnly = false,
    VoidCallback? onTap}) {
  final border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: isCatAdded
        ? BorderSide.none
        : BorderSide(
            color: Colors.red,
          ),
  );
  return Container(
    decoration: BoxDecoration(
        color: ColorPalette.white,
        boxShadow: [
          boxShadow(
              context: context,
              color: Colors.black,
              opacity: 0.2,
              y: 5,
              blur: 5),
        ],
        borderRadius: BorderRadius.circular(20)),
    child: TextFormField(
      keyboardType: textInputType,
      onTap: onTap,
      onChanged: (String? val) {
        if (onChange != null) {
          onChange(val);
        }
      },
      obscureText: isObscure,
      controller: controller,
      style: TextStyle(
        fontSize: context.fontSize(13),
        fontWeight: FontWeight.w400,
        color: Colors.black,
        fontFamily: 'Poppins',
      ),
      readOnly: readOnly,
      decoration: InputDecoration(
        hintText: context.getLocal(hintText),
        hintStyle: TextStyle(
          fontSize: context.fontSize(13),
          fontWeight: FontWeight.w400,
          color: hintColor,
          fontFamily: 'Poppins',
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        border: border,
        errorBorder: border,
        enabledBorder: border,
        focusedBorder: border,
        disabledBorder: border,
        focusedErrorBorder: border,
        suffixIcon: suffixIcon,
      ),
    ),
  );
}

centerTextField(
    {required BuildContext context,
    TextEditingController? controller,
    required String hintText,
    bool isObscure = false,
    Color hintColor = Colors.grey,
    bool isPasswordField = false,
    GestureDetector? suffixIcon,
    Function(String?)? onChange,
    Function(String?)? onChange2,
    bool isCatAdded = true,
    TextInputType textInputType = TextInputType.text,
    bool readOnly = false,
    VoidCallback? onTap}) {
  final border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(4),
    borderSide: const BorderSide(
      color: Colors.green,
    ),
  );
  return Container(
    decoration: BoxDecoration(
        color: ColorPalette.white,
        boxShadow: [
          boxShadow(
              context: context,
              color: Colors.green.withOpacity(0.2),
              opacity: 0.07,
              blur: 15),
        ],
        borderRadius: BorderRadius.circular(4)),
    child: TextFormField(
      onChanged: (String? val) {
        if (onChange2 != null) {
          onChange2(val);
        }
      },
      keyboardType: textInputType,
      onTap: onTap,
      onFieldSubmitted: (String? val) {
        if (onChange != null) {
          onChange(val);
        }
      },
      obscureText: isObscure,
      controller: controller,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: context.fontSize(13),
        fontWeight: FontWeight.w400,
        color: Colors.black,
        fontFamily: 'Poppins',
      ),
      readOnly: readOnly,
      decoration: InputDecoration(
        hintText: context.getLocal(hintText),
        hintStyle: TextStyle(
          fontSize: context.fontSize(13),
          fontWeight: FontWeight.w400,
          color: hintColor,
          fontFamily: 'Poppins',
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        border: border,
        errorBorder: border,
        enabledBorder: border,
        focusedBorder: border,
        disabledBorder: border,
        focusedErrorBorder: border,
        suffixIcon: suffixIcon,
      ),
    ),
  );
}

phoneField(
    {required BuildContext context,
    required TextEditingController controller,
    required String hintText,
    bool isObscure = false,
    Color hintColor = ColorPalette.black,
    bool isPasswordField = false,
    required PhoneNumber initialValue,
    GestureDetector? suffixIcon,
    Function(PhoneNumber?)? onChangePhone,
    TextInputType textInputType = TextInputType.text,
    bool readOnly = false,
    VoidCallback? onTap}) {
  final border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(20),
    borderSide: BorderSide.none,
  );
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(
        color: ColorPalette.white,
        boxShadow: [
          boxShadow(
              context: context,
              color: Colors.black,
              opacity: 0.2,
              y: 5,
              blur: 5),
        ],
        borderRadius: BorderRadius.circular(20)),
    child: InternationalPhoneNumberInput(
      hintText: context.getLocal(hintText),
      hintStyle: TextStyle(
        fontSize: context.fontSize(13),
        fontWeight: FontWeight.w400,
        color: hintColor,
        fontFamily: 'Poppins',
      ),
      textStyle: TextStyle(
        fontSize: context.fontSize(13),
        fontWeight: FontWeight.w400,
        color: ColorPalette.black,
        fontFamily: 'Poppins',
      ),
      onInputChanged: (PhoneNumber number) {
        onChangePhone!(number);
      },
      onInputValidated: (bool value) {
        print(value);
      },
      selectorConfig: const SelectorConfig(
        selectorType: PhoneInputSelectorType.DIALOG,
        useBottomSheetSafeArea: true,
      ),
      countries: const ['PK'],
      maxLength: 11,
      ignoreBlank: false,
      autoValidateMode: AutovalidateMode.disabled,
      selectorTextStyle: TextStyle(
        fontSize: context.fontSize(13),
        fontWeight: FontWeight.w400,
        color: ColorPalette.black,
        fontFamily: 'Poppins',
      ),
      initialValue: initialValue,
      textFieldController: controller,
      formatInput: true,
      keyboardType:
          TextInputType.numberWithOptions(signed: true, decimal: true),
      inputBorder: border,
      onSaved: (PhoneNumber number) {
        print('On Saved: $number');
      },
    ),
  );
}
