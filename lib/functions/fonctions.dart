import 'package:flutter/material.dart';

void changePage(BuildContext context, Widget page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}
