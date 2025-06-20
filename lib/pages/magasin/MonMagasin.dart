//import 'dart:nativewrappers/_internal/vm/lib/math_patch.dart';

//import 'dart:ffi';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:koontaa/functions/cloud_firebase.dart';
import 'package:koontaa/functions/fonctions.dart';
import 'package:koontaa/functions/gps.dart';
import 'package:koontaa/functions/storage.dart';
import 'package:koontaa/pages/compte/connection/page_connection.dart';
import 'package:koontaa/pages/home/home_widgets.dart';
import 'package:koontaa/pages/magasin/ajoutDeProduit.dart';
import 'package:koontaa/pages/magasin/produitAttenteModificationBoutique_widget.dart';
import 'package:koontaa/pages/magasin/produitPublie_widget.dart';
import 'package:koontaa/pages/magasin/produitRefuse_widget%20.dart';
import 'package:koontaa/pages/magasin/produitTraitement_Widget.dart';
import 'package:koontaa/pages/recherche/recherche.dart';
import 'package:google_fonts/google_fonts.dart';

class MonMagasin extends StatefulWidget {
  const MonMagasin({super.key, required this.title});

  final String title;

  @override
  State<MonMagasin> createState() => _MonMagasinState();
}

class _MonMagasinState extends State<MonMagasin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pageMagasin(context, () {
        setState(() {});
      }),
    );
  }
}

Widget pageMagasin(BuildContext context, Function setStating) {
  return Container(
    color: Color(0xFFF9EFE0),
    child: CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: long(context, ratio: 0.5),
          pinned: true,
          floating: false,
          backgroundColor: Color(0xFFBE4A00),
          flexibleSpace: LayoutBuilder(
            builder: (context, constraints) {
              double top = constraints.biggest.height;

              return FlexibleSpaceBar(
                centerTitle: true,
                title: top < 100
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(child: Container()), // espace vide à gauche
                          // Texte centré
                          Text(
                            'Koontaa',
                            style: TextStyle(
                              color: Color.fromARGB(221, 255, 255, 255),
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),

                          Spacer(), // espace flexible entre texte et icône
                          // Icône à droite
                          IconButton(
                            onPressed: () {
                              changePage(
                                context,
                                const Recherche(title: "Page de Récherche"),
                              );
                            },
                            icon: Icon(Icons.search, color: Colors.white),
                          ),
                        ],
                      )
                    : null,
                background: Container(
                  color: Color(0xFFF9EFE0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: long(context, ratio: 0.05)),
                      enteteMagasinInfo(context, setStating),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        listeProduitBoutique0(context, setStating),
      ],
    ),
  );
}

Widget enteteMagasinInfo(BuildContext context, Function setStating) {
  final espaceOption = 1 / 43;
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Row(
        children: [
          Container(
            width: larg(context, ratio: 1 / 2.5),
            height: long(context, ratio: 1 / 5),
            margin: EdgeInsets.symmetric(
              horizontal: larg(context, ratio: 1 / 60),
            ),
            decoration: BoxDecoration(
              //color: Colors.black,
              borderRadius: BorderRadius.circular(larg(context, ratio: 1 / 50)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(larg(context, ratio: 1 / 50)),
              child: imageNetwork(
                context,
                'https://static.vecteezy.com/system/resources/thumbnails/015/131/911/small_2x/flat-cartoon-style-shop-facade-front-view-modern-flat-storefront-or-supermarket-design-png.png',
              ),
            ),
          ),
          SizedBox(
            //color: Colors.green,
            width: larg(context, ratio: 0.55),
            height: long(context, ratio: 1 / 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: long(context, ratio: 0.04)),
                h3(context, texte: "Ma boutique Koontaa"),
                Row(
                  children: [
                    SizedBox(
                      //color: Colors.blue,
                      width: larg(context, ratio: 0.42),
                      child: AutoSizeText(
                        maxLines: 1, // 1 seule ligne
                        overflow: TextOverflow.ellipsis, // Coupe
                        "San pédro, Côte d'Ivoire",
                        style: TextStyle(
                          fontSize: larg(context, ratio: 1 / 25),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(larg(context, ratio: 0.006)),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(87, 48, 194, 48),

                        borderRadius: BorderRadius.circular(
                          larg(context, ratio: 0.02),
                        ),
                      ),
                      child: AutoSizeText("Active"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      SizedBox(height: long(context, ratio: 1 / 60)),
      Row(
        children: [
          Container(
            margin: EdgeInsets.only(left: larg(context, ratio: 1 / 60)),
            width: larg(context, ratio: 0.22),
            height: long(context, ratio: 1 / 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(larg(context, ratio: 1 / 60)),
              border: BoxBorder.all(
                color: const Color.fromARGB(255, 206, 198, 174),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AutoSizeText(
                  "12",
                  maxLines: 1, // 1 seule ligne
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: larg(context, ratio: 0.08)),
                ),
                AutoSizeText(
                  "Produits",
                  maxLines: 1, // 1 seule ligne
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: larg(context, ratio: 0.03)),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: larg(context, ratio: espaceOption)),
            width: larg(context, ratio: 0.22),
            height: long(context, ratio: 1 / 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(larg(context, ratio: 1 / 60)),
              border: BoxBorder.all(
                color: const Color.fromARGB(255, 206, 198, 174),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AutoSizeText(
                  "25",
                  maxLines: 1, // 1 seule ligne
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: larg(context, ratio: 0.08)),
                ),
                AutoSizeText(
                  "Ventes",
                  maxLines: 1, // 1 seule ligne
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: larg(context, ratio: 0.03)),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: larg(context, ratio: espaceOption)),
            width: larg(context, ratio: 0.22),
            height: long(context, ratio: 1 / 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(larg(context, ratio: 1 / 60)),
              border: BoxBorder.all(
                color: const Color.fromARGB(255, 206, 198, 174),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AutoSizeText(
                  "0",
                  maxLines: 1, // 1 seule ligne
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: larg(context, ratio: 0.08)),
                ),
                AutoSizeText(
                  "Commendes",
                  maxLines: 1, // 1 seule ligne
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: larg(context, ratio: 0.03)),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: larg(context, ratio: espaceOption)),
            width: larg(context, ratio: 0.22),
            height: long(context, ratio: 1 / 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(larg(context, ratio: 1 / 60)),
              border: BoxBorder.all(
                color: const Color.fromARGB(255, 206, 198, 174),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AutoSizeText(
                  "0",
                  maxLines: 1, // 1 seule ligne
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: larg(context, ratio: 0.08)),
                ),
                AutoSizeText(
                  "Rétours",
                  maxLines: 1, // 1 seule ligne
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: larg(context, ratio: 0.03)),
                ),
              ],
            ),
          ),
        ],
      ),
      SizedBox(height: long(context, ratio: 0.03)),
      bouttonAjouterProduits(context),
    ],
  );
}

Widget bouttonAjouterProduits(BuildContext context) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: larg(context, ratio: 0.02)),
    width: double.infinity, // Prend toute la largeur disponible
    child: TextButton.icon(
      onPressed: () {
        cameraAuto = true;
        afficheMessage = false;
        if (modificationProduit == null) {
          modificationProduit = false;
        } else if (modificationProduit!) {
          modificationProduit = false;
          renitialisePageAjoutArticle();
        } else {
          modificationProduit = false;
        }

        changePage(context, AjoutProduits(title: "add produits"));
      },
      icon: Icon(Icons.add_box, color: Colors.white),
      label: Text(
        "Ajouter des produits",
        style: TextStyle(
          fontSize: larg(context, ratio: 0.03),
          color: Colors.white,
        ),
      ),
      style: TextButton.styleFrom(
        backgroundColor: Color(0xFFBE4A00), // Couleur de fond
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Bords arrondis
          // Bordure
        ),
        padding: EdgeInsets.symmetric(vertical: 16), // Hauteur du bouton
      ),
    ),
  );
}

final CloudFirestore listeProduitMagasin0 = CloudFirestore();
Widget listeProduitBoutique0(BuildContext context, Function setStating) {
  return StreamBuilder(
    stream: listeProduitMagasin0.lectureBdd(
      "produits",
      filtreCompose: cd("uidBoutique", "Indéfinit pour le moment"),
      //orderBy: ["dateTime", true],
    ),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return SliverToBoxAdapter(child: circular());
      }
      if (snapshot.hasError) {
        print('Erreur lors de la lecture ${snapshot.error}');
        return SliverToBoxAdapter(
          child: Text('Erreur lors de la lecture ${snapshot.error}'),
        );
      }
      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return SliverToBoxAdapter(child: Text('Aucun article trouvé'));
      }

      final docs = snapshot.data!.docs.reversed.toList();

      //return Text(data["nom"] ?? "");

      return SliverList(
        delegate: SliverChildBuilderDelegate(childCount: docs.length, (
          context,
          index,
        ) {
          try {
            final data = docs[index].data() as Map<String, dynamic>;
            if (data["status"] == 0) {
              return ContProduitBoutiqueTraitement(
                data: data,
                id: docs[index].id,
              );
            } else if (data["status"] == 1) {
              return ContProduitBoutiqueRefuse(data: data, id: docs[index].id);
            } else if (data["status"] == 2) {
              return ContProduitBoutiqueAttenteModificationBoutique(
                data: data,
                id: docs[index].id,
              );
            } else if (data["status"] == 3) {
              return ContProduitBoutiquePublie(data: data, id: docs[index].id);
            }
            return Text("data");
          } catch (e) {
            return SizedBox();
          }
        }),
      );
    },
  );
}
