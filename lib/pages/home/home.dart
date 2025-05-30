import 'package:flutter/material.dart';
import 'package:koontaa/pages/home/home_widgets.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.title});

  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9EFE0),
      body: expp(),
      bottomNavigationBar: homeBottomPage(context, 0, 0, () {
        setState(() {});
      }),
    );
  }
}
