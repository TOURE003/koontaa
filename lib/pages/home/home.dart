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

int indexPageAcceuil = 0;

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    List<Widget> diffPageHomes = [
      expp(() {
        setState(() {});
      }),
      Text("data"),
      Text("data"),
      pageCompte(),
      Text("data"),
    ];
    return Scaffold(
      backgroundColor: Color(0xFFF9EFE0),
      body: diffPageHomes[indexPageAcceuil],
      bottomNavigationBar: homeBottomPage(context, 1, 0, () {
        setState(() {
          if (pageBottomIndex == 3 && AuthFirebase().currentUser != null) {
            indexPageAcceuil = pageBottomIndex;
          } else {
            indexPageAcceuil = 0;
          }
        });
      }),
    );
  }
}
