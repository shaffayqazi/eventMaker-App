import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Customtextfild {
  static Widget textField({
    TextEditingController? controller,
    String? name1,
    Color? labelclr,
    Color? textcolor,
    Color? imagecolor,
    String? Function(String?)? validator,
    Widget? prefixIcon,
    Function(String)? onChanged,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
  }) {
    return ScreenUtilInit(
      builder: (context, child) => Container(
        color: Colors.transparent,
        height: 45.h,
        child: TextFormField(
          controller: controller,
          onChanged: onChanged,
          validator: validator,
          textInputAction: textInputAction,
          keyboardType: keyboardType,
          style: TextStyle(color: textcolor),
          decoration: InputDecoration(
            disabledBorder:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.sp)),
            labelText: name1,
            labelStyle: TextStyle(color: labelclr),
            prefixIcon: prefixIcon,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.sp)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                borderRadius: BorderRadius.circular(10.sp)),
            focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Color(0xff5669FF), width: 1),
                borderRadius: BorderRadius.circular(10.sp)),
          ),
        ),
      ),
    );
  }
}
