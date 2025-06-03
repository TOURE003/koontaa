import 'package:flutter/material.dart';
import 'package:koontaa/functions/firebase_auth.dart';
import 'package:koontaa/pages/compte/connection/compte.dart';
import 'package:koontaa/pages/home/home_widgets.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.title});

  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Widget> diffPageHomes = [expp(), expp(), expp(), pageCompte(), expp()];
  int indexPage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9EFE0),
      body: diffPageHomes[indexPage],
      bottomNavigationBar: homeBottomPage(context, 1, 0, () {
        setState(() {
          if (pageBottomIndex == 3 && AuthFirebase().currentUser != null) {
            indexPage = pageBottomIndex;
          } else {
            indexPage = 0;
          }
        });
      }),
    );
  }
}
