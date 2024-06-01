import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Customtextfild2 {
  static Widget textField(
      controller, txt, name1, clr, textcolor, img, suffixIcon,
      {String? Function(String?)? validator}) {
    return ScreenUtilInit(
      builder: (context, child) => Container(
        color: Colors.transparent,
        height: 45.h,
        child: TextFormField(
          controller: controller,
          obscureText: txt,
          validator: validator,
          style: TextStyle(color: textcolor),
          decoration: InputDecoration(
            disabledBorder:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.sp)),
            prefixIcon: Image.asset(img, scale: 3.5),
            labelText: name1,
            labelStyle: TextStyle(color: clr),
            suffixIcon:
                Padding(padding: const EdgeInsets.all(10), child: suffixIcon),
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
