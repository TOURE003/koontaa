import 'package:flutter/material.dart';
import 'package:koontaa/functions/cloud_firebase.dart';
import 'package:koontaa/functions/firebase_auth.dart';
import 'package:koontaa/functions/fonctions.dart';
import 'package:koontaa/pages/compte/connection/page_connection.dart';
import 'package:koontaa/pages/home/home.dart';
import 'package:koontaa/pages/magasin/creationMagasin.dart';

Widget pageCompte(BuildContext context, Function setStating) {
  return Column(
    children: [
      Center(
        child: ElevatedButton(
          onPressed: () async {
            //AuthFirebase().logout();
            AuthFirebase().logout();
            nbrPageActif = 0;
            setStating();
            //print(AuthFirebase().currentUser!.phoneNumber);
          },
          child: Text("Déconnection"),
        ),
      ),

      ElevatedButton(
        onPressed: () {
          changePage(context, CreationMagasin(title: "Creer Boutique"));
        },
        child: Text("Mon magasin"),
      ),
    ],
  );
}
