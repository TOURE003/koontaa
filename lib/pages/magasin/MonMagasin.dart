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
//import 'package:koontaa/pages/home/home_widgets.dart';
import 'package:koontaa/pages/magasin/ajoutDeProduit.dart';
import 'package:koontaa/pages/magasin/produitAttenteModificationBoutique_widget.dart';
import 'package:koontaa/pages/magasin/produitPublieBloque_widget.dart';
import 'package:koontaa/pages/magasin/produitPublie_widget.dart';
import 'package:koontaa/pages/magasin/produitRefuse_widget%20.dart';
import 'package:koontaa/pages/magasin/produitTraitement_widget.dart';
//import 'package:koontaa/pages/magasin/produitTraitement_Widget.dart';
import 'package:koontaa/pages/recherche/recherche.dart';
import 'package:google_fonts/google_fonts.dart';

class MonMagasin extends StatefulWidget {
  final String idBoutique;
  const MonMagasin({super.key, required this.title, required this.idBoutique});

  final String title;

  @override
  State<MonMagasin> createState() => _MonMagasinState();
}

class _MonMagasinState extends State<MonMagasin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pageMagasin(context, widget.idBoutique, () {
        setState(() {});
      }),
    );
  }
}

Widget pageMagasin(
  BuildContext context,
  String idBoutique,
  Function setStating,
) {
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
                      enteteMagasinInfo(context, idBoutique, setStating),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        SliverToBoxAdapter(
          child: enteteFiltre(
            context,
            //filtreActif: "Tous",
            onFiltreChange: (filtre) {
              filtreActif = filtre;
              setStating();
            },
          ),
        ),
        listeProduitBoutique0(context, idBoutique, setStating),
      ],
    ),
  );
}

Widget enteteMagasinInfo(
  BuildContext context,
  String idBoutique,
  Function setStating,
) {
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
      bouttonAjouterProduits(context, idBoutique),
    ],
  );
}

Widget bouttonAjouterProduits(BuildContext context, String idBoutique) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: larg(context, ratio: 0.02)),
    width: double.infinity, // Prend toute la largeur disponible
    child: TextButton.icon(
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
          AjoutProduits(title: "add produits", idBoutique: idBoutique),
        );
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
Widget listeProduitBoutique0(
  BuildContext context,
  String idBoutique,
  Function setStating,
) {
  return StreamBuilder(
    stream: listeProduitMagasin0.lectureBdd(
      "produits",
      filtreCompose: cd("uidBoutique", idBoutique),
      //orderBy: ["dateTime", true],
    ),
    builder: (context, snapshot) {
      /*if (snapshot.connectionState == ConnectionState.waiting) {
        return SliverToBoxAdapter(child: circular());
      }*/
      if (snapshot.hasError) {
        print('Erreur lors de la lecture ${snapshot.error}');
        return SliverToBoxAdapter(
          child: Text('Erreur lors de la lecture ${snapshot.error}'),
        );
      }
      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return SliverToBoxAdapter(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.white,
            ),
            margin: EdgeInsets.all(25),

            width: double.infinity,
            padding: EdgeInsets.all(10),
            child: Center(child: const Text('Aucun article trouvé')),
          ),
        );
      }

      var docs = CloudFirestore().trierDocs(snapshot.data!.docs, [
        "dateTime",
        true,
      ]);

      docs = CloudFirestore().trierDocs(snapshot.data!.docs, [
        "dateTimeModif",
        true,
      ]);
      //final docs = snapshot.data!.docs.reversed.toList();

      //return Text(data["nom"] ?? "");

      return SliverList(
        delegate: SliverChildBuilderDelegate(childCount: docs.length, (
          context,
          index,
        ) {
          try {
            final data = docs[index].data() as Map<String, dynamic>;
            if (data["status"] == 0 &&
                (filtreActif == "Tous" || filtreActif == "En traitément")) {
              return ContProduitBoutiqueTraitement(
                data: data,
                id: docs[index].id,
                idBoutique: idBoutique,
              );
            } else if (data["status"] == 1 &&
                (filtreActif == "Tous" || filtreActif == "Réfusé")) {
              return ContProduitBoutiqueRefuse(data: data, id: docs[index].id);
            } else if (data["status"] == 2 &&
                (filtreActif == "Tous" || filtreActif == "En Attente")) {
              return ContProduitBoutiqueAttenteModificationBoutique(
                data: data,
                id: docs[index].id,
                idBoutique: idBoutique,
              );
            } else if (data["status"] == 3 &&
                (filtreActif == "Tous" || filtreActif == "Publiés")) {
              return ContProduitBoutiquePublie(
                data: data,
                id: docs[index].id,
                idBoutique: idBoutique,
              );
            } else if (data["status"] == 4 &&
                (filtreActif == "Tous" || filtreActif == "Bloqués")) {
              return ContProduitBoutiquePublieBloque(
                data: data,
                id: docs[index].id,
                idBoutique: idBoutique,
              );
            }
            // return Text("data");
            return SizedBox();
          } catch (e) {
            return SizedBox();
          }
        }),
      );
    },
  );
}

String filtreActif = "Tous";
Widget enteteFiltre(
  BuildContext context, {
  //required String filtreActif,
  required Function(String) onFiltreChange,
}) {
  final List<Map<String, dynamic>> filtres = [
    {'label': 'Tous', 'icone': Icons.all_inclusive},
    {'label': 'Publiés', 'icone': Icons.check_circle_outline},
    {'label': 'En traitément', 'icone': Icons.hourglass_top},
    {'label': 'En Attente', 'icone': Icons.hourglass_top},
    {'label': 'Bloqués', 'icone': Icons.block},
    {'label': 'Réfusé', 'icone': Icons.cancel},
  ];

  return Container(
    margin: EdgeInsets.all(20),
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(5),
    ),
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filtres.map((filtre) {
          final bool estActif = filtre['label'] == filtreActif;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: ChoiceChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    filtre['icone'],
                    size: 18,
                    color: estActif ? Colors.white : Colors.grey[600],
                  ),
                  const SizedBox(width: 4),

                  Text(
                    filtre['label'],
                    style: TextStyle(
                      color: estActif ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
              selected: estActif,
              onSelected: (_) => onFiltreChange(filtre['label']),
              selectedColor: const Color.fromARGB(255, 217, 166, 119),
              backgroundColor: Colors.grey[200],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          );
        }).toList(),
      ),
    ),
  );
}
