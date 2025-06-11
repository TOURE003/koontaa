import 'package:flutter/material.dart';
import 'package:koontaa/functions/cloud_firebase.dart';
import 'package:koontaa/functions/firebase_auth.dart';
import 'package:koontaa/pages/compte/connection/page_connection.dart';
import 'package:koontaa/pages/home/home.dart';

Widget pageCompte() {
  return Center(
    child: ElevatedButton(
      onPressed: () async {
        //AuthFirebase().logout();
        AuthFirebase().logout();
        //print(AuthFirebase().currentUser!.phoneNumber);
      },
      child: Text("Déconnection"),
    ),
  );
}
