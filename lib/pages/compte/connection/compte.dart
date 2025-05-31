import 'package:flutter/material.dart';
import 'package:koontaa/functions/firebase_auth.dart';

Widget pageCompte() {
  return Center(
    child: ElevatedButton(
      onPressed: () {
        AuthFirebase().logout();
      },
      child: Text("Déconnection"),
    ),
  );
}
