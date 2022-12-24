import 'package:flutter/material.dart';

BoxDecoration getDecoration() {
  const double cornerRadius = 10;
  return BoxDecoration(
    color: Colors.blue.shade200,
    borderRadius: const BorderRadius.only(
      topLeft: Radius.circular(cornerRadius),
      topRight: Radius.circular(cornerRadius),
      bottomLeft: Radius.circular(cornerRadius),
      bottomRight: Radius.circular(cornerRadius),
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        spreadRadius: 5,
        blurRadius: 7,
      ),
    ],
  );
}
