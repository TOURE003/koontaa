import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:koontaa/functions/cloud_firebase.dart';
import 'package:koontaa/functions/firebase_auth.dart';
import 'package:koontaa/functions/fonctions.dart';
import 'package:koontaa/pages/compte/connection/page_connection.dart';
import 'package:koontaa/pages/home/home.dart';
import 'package:koontaa/pages/magasin/MonMagasin.dart';
import 'package:koontaa/pages/magasin/creationMagasin.dart';
import 'package:app_settings/app_settings.dart';

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
        onPressed: () async {
          final lecture = await CloudFirestore().lectureUBdd(
            "boutiques",
            filtreCompose: cd("idUser", await AuthFirebase().currentUser!.uid),
          );
          if (lecture != null && lecture.docs.isNotEmpty) {
            final docs = lecture.docs;
            final data = docs[0].id;
            changePage(
              context,
              MonMagasin(title: "Boutique", idBoutique: data),
            );
            return;
          } else {
            final permission = await Geolocator.requestPermission();
            if (permission == LocationPermission.denied) {
              afficherBoiteDeuxBoutons(
                context: context,
                titre: "Localisation",
                message:
                    "Nous avons bésoin de votre localisation pour continuer",
                texteBouton1: "Annuler",
                actionBouton1: () {},
                actionBouton2: () async {
                  await Geolocator.requestPermission();
                  print("object");
                },
              );
            } else if (permission == LocationPermission.deniedForever) {
              afficherBoiteDeuxBoutons(
                context: context,
                titre: "Localisation",
                message:
                    "Nous avons bésoin de votre localisation pour continuer",
                texteBouton1: "Annuler",
                actionBouton1: () {},
                actionBouton2: () async {
                  await AppSettings.openAppSettings(
                    type: AppSettingsType.location,
                  );
                  //print("object");
                },
              );
            }

            if (permission == LocationPermission.whileInUse) {
              changePage(context, CreationMagasin(title: "Creation"));
            }
          }
        },
        child: Text("Mon magasin"),
      ),
    ],
  );
}
