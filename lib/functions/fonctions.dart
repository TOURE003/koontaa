import 'package:flutter/material.dart';

void changePage(BuildContext context, Widget page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

Color couleurDeApp() {
  return Color(0xFFF9EFE0);
  // BE4A00
}
