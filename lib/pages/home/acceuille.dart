import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:koontaa/functions/cloud_firebase.dart';
import 'package:koontaa/functions/firebase_auth.dart';
import 'package:koontaa/functions/fonctions.dart';
import 'package:koontaa/pages/home/pubKoontaCreeBoutique.dart';
import 'package:koontaa/pages/magasin/MonMagasin.dart';
import 'package:koontaa/pages/magasin/ajoutDeProduit.dart';
import 'package:koontaa/pages/magasin/creationMagasin.dart';

class Acceuille extends StatefulWidget {
  const Acceuille({super.key, required this.title});

  final String title;

  @override
  State<Acceuille> createState() => _AcceuilleState();
}

class _AcceuilleState extends State<Acceuille> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [racourcieMagasin(context)]);
  }
}

Widget racourcieMagasin(BuildContext context) {
  if (AuthFirebase().currentUser == null) {
    return SizedBox();
  }

  return FutureBuilder(
    future: CloudFirestore().lectureUBdd(
      "boutiques",
      filtreCompose: cd("idUser", AuthFirebase().currentUser!.uid),
    ),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        final querySnapshot = snapshot.data;

        if (querySnapshot.docs.isNotEmpty) {
          final data = querySnapshot.docs[0].data() as Map<String, dynamic>;

          return GestureDetector(
            onTap: () {
              changePage(
                context,
                MonMagasin(
                  title: "Boutique",
                  idBoutique: querySnapshot.docs[0].id,
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.all(larg(context, ratio: 0.01)),
              color: Colors.white,
              width: larg(context),
              height: long(context, ratio: 0.10),
              //color: Colors.amber,
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    height: long(context, ratio: 0.09),
                    width: long(context, ratio: 0.09),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(1000),
                    ),
                    child: imageNetwork(
                      context,
                      data["lienLogo"],
                      pleinW: true,
                      borderRadius: 1000,
                    ),
                  ),
                  SizedBox(
                    width: larg(context, ratio: 0.7),
                    child: h6(context, texte: data["nomBoutique"]),
                  ),
                  IconButton(
                    onPressed: () {
                      cameraAuto = true;
                      afficheMessage = false;
                      modificationProduitPublique = false;
                      if (modificationProduit == null) {
                        modificationProduit = false;
                      } else if (modificationProduit!) {
                        modificationProduit = false;
                        renitialisePageAjoutArticle();
                      } else {
                        modificationProduit = false;
                      }

                      changePage(
                        context,
                        AjoutProduits(
                          title: "add produits",
                          idBoutique: querySnapshot.docs[0].id,
                        ),
                      );
                    },
                    icon: Icon(Icons.add),
                  ),
                ],
              ),
            ),
          );
        } else {
          return BoutonVenteKoontaa(
            onPressed: () async {
              final lecture = await CloudFirestore().lectureUBdd(
                "boutiques",
                filtreCompose: cd(
                  "idUser",
                  await AuthFirebase().currentUser!.uid,
                ),
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
          );
        }
      } else {
        return circular(message: "");
      }
    },
  );
}
