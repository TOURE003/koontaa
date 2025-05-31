import 'package:flutter/material.dart';
import 'package:koontaa/functions/firebase_auth.dart';
import 'package:koontaa/pages/home/home.dart';
import 'package:koontaa/pages/home/home_widgets.dart';
import 'package:koontaa/pages/compte/connection/page_connection.dart';

class RedirectionPageCompteConnection extends StatefulWidget {
  const RedirectionPageCompteConnection({super.key, required this.title});

  final String title;
  @override
  State<RedirectionPageCompteConnection> createState() =>
      _RedirectionPageCompteConnectionState();
}

class _RedirectionPageCompteConnectionState
    extends State<RedirectionPageCompteConnection> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthFirebase().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasData) {
          //pageBottomIndex = 3;
          return const Home(
            title: "Home",
          ); // MyHomePage(title: "Page d'Acceuil");
        } else {
          //pageBottomIndex = 0;
          return const PageConnection(
            title: "Connection",
          ); // LoginPage(title: "Page de Connection");
        }
      },
    );
  }
}
