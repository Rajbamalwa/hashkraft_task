import 'package:flutter/material.dart';

Padding textFIeld(
    TextEditingController controller,
    String? Function(String?)? validator,
    String text,
    int line,
    TextInputType type,
    Icon icon) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
    child: TextFormField(
      controller: controller,
      maxLines: line,
      keyboardType: type,
      decoration: InputDecoration(
        icon: icon,
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide:
                const BorderSide(color: Colors.grey, style: BorderStyle.solid)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide:
                const BorderSide(color: Colors.grey, style: BorderStyle.solid)),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide:
                const BorderSide(color: Colors.grey, style: BorderStyle.none)),
        labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 21),
        label: Text(
          text,
          style: TextStyle(color: Color(0xff294151)),
        ),
      ),
      validator: validator,
    ),
  );
}
