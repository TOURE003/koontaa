import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:koontaa/Commentaire/pageDeCommentaire.dart';
import 'package:koontaa/functions/cloud_firebase.dart';
import 'package:koontaa/functions/fonctions.dart';
import 'package:koontaa/pages/compte/connection/page_connection.dart';
import 'package:koontaa/pages/magasin/ajoutDeProduit.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
//import 'package:comment_tree/widgets/comment_tree_widget.dart';
import 'package:comment_tree/comment_tree.dart';

//import 'package:comment_tree/data/comment.dart';

class PageArticleMagasin extends StatefulWidget {
  final String idArticle;
  final String lienImageBoutique;
  final String idBoutique;
  final String nomBoutique;
  final String nomArticle;
  final String prixArticle;

  const PageArticleMagasin({
    super.key,
    required this.title,
    required this.idArticle,
    required this.lienImageBoutique,
    required this.nomBoutique,
    required this.idBoutique,
    required this.nomArticle,
    required this.prixArticle,
  });

  final String title;

  @override
  State<PageArticleMagasin> createState() => _PageArticleMagasinState();
}

class _PageArticleMagasinState extends State<PageArticleMagasin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: couleurDeApp(),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: long(context, ratio: 0.05),
              width: long(context, ratio: 0.05),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(1000),
              ),
              child: imageNetwork(
                context,
                widget.lienImageBoutique,
                pleinW: true,
                borderRadius: 1000,
              ),
            ),
            SizedBox(width: larg(context, ratio: 0.03)),
            h6(context, texte: widget.nomBoutique, gras: true),
          ],
        ),
      ),
      backgroundColor: couleurDeApp(),
      body: StreamBuilder(
        stream: CloudFirestore().lectureBddDocU("produits", widget.idArticle),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            print('Erreur lors de la lecture ${snapshot.error}');
            return Text('Erreur lors de la lecture ${snapshot.error}');
          }

          Map<String, dynamic>? data =
              snapshot.data!.data() as Map<String, dynamic>?;

          if (data == null) {
            return Text('Erreur lors de la lecture ');
          }

          return SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  afficherImageNomArticle(context, data),
                  SizedBox(height: long(context, ratio: 0.03)),

                  barreAviCommentaire(
                    context,
                    data,
                    nomArticle: widget.nomArticle,
                    prixArticle: widget.prixArticle,
                    idArticle: widget.idArticle,
                  ),

                  afficheTailleSivettement(
                    context,
                    listeNomTaille,
                    data["taillesVentementDisponibles"],
                  ),

                  affichePointureSiChaussure(
                    context,
                    listeNomPointure,
                    data["pointuresChaussureDisponible"],
                  ),
                  descriptionPageArticleBoutique(context, data["description"]),
                ],
              ),
            ),
          );
        },
      ),

      bottomNavigationBar: BottomAppBar(
        color: couleurDeApp(),
        child: bouttonModifPageProduit(
          context,
          widget.idArticle,
          widget.idBoutique,
        ),
      ),
    );
  }
}

Widget afficherImageNomArticle(
  BuildContext context,
  Map<String, dynamic> data,
) {
  List res = [];
  final don = data;

  if (don["listeImagesPublique"].isEmpty) {
    res.add(don["listeImagesTemporairesProduit"]);
  } else {
    res.add(don["listeImagesPublique"]);
  }

  if (don["nomPublique"] == "") {
    res.add(don["nomTemporaireProduit"]);
  } else {
    res.add(don["nomPublique"]);
  }

  return Container(
    //color: Color(0xFFBE4A00),
    child: Column(
      children: [
        Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: larg(context, ratio: 0.03)),
          padding: EdgeInsets.all(larg(context, ratio: 0.016)),
          decoration: BoxDecoration(
            color: Color(0xFFBE4A00),
            //borderRadius: BorderRadius.circular(5),
          ),
          //width: larg(context, ratio: 0.95),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                //width: larg(context, ratio: 0.75 - (0.06)),
                child: h5(context, texte: res[1], couleur: Colors.white),
              ),
              SizedBox(
                //width: larg(context, ratio: 0.25 - (0.06)),
                child: h5(
                  context,
                  texte: "${arg(data["prixTemporaireProduit"])} F",
                  couleur: Colors.white,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: long(context, ratio: 0.01)),
        defilementImagesHorizontales(context, res[0]),
      ],
    ),
  );
}

Widget defilementImagesHorizontales00(
  BuildContext context,
  List<dynamic> urlsImages,
) {
  final controller = PageController(
    viewportFraction: 0.8,
  ); // < 1 pour voir les côtés

  return Container(
    padding: EdgeInsets.symmetric(vertical: long(context, ratio: 0.008)),
    color: Color.fromARGB(228, 137, 53, 1),
    height: long(context, ratio: 0.5),
    child: PageView.builder(
      controller: controller,
      itemCount: urlsImages.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Container(
              //color: Colors.red,
              width: long(context, ratio: 0.3),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: imageNetwork(
                  context,
                  urlsImages[index],
                  pleinW: true,
                  borderRadius: 6,
                ),
              ),
            );
          },
        );
      },
    ),
  );
}

Widget barreAviCommentaire(
  BuildContext context,
  Map<String, dynamic> data, {
  String nomArticle = "",
  String idArticle = "",
  String prixArticle = "",
}) {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      color: Colors.white,
      //borderRadius: BorderRadius.circular(5),
    ),
    padding: EdgeInsets.all(larg(context, ratio: 0.02)),
    //margin: EdgeInsets.symmetric(horizontal: larg(context, ratio: 0.05)),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.only(left: larg(context, ratio: 0.02)),
              child: Row(children: [afficheLike(context, idArticle)]),
            ),
            SizedBox(
              child: Row(
                children: [
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          rangCommentaire.value = 0;
                          controlRepondreAvide.clear();
                          changePage(
                            context,
                            PageAvecChampFixe(
                              idProduit: idArticle,
                              urlImgProduit: data["listeImagesPublique"].isEmpty
                                  ? data["listeImagesTemporairesProduit"]
                                  : data["listeImagesPublique"],
                              nomArticle: nomArticle,
                              prixArticle: prixArticle,
                            ),
                          );
                        },
                        child: StreamBuilder(
                          stream: CloudFirestore().lectureBdd(
                            "commentaires",
                            filtreCompose: cd("idProduits", idArticle),
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Text(
                                'Erreur lors de la lecture ${snapshot.error}',
                              );
                            }
                            if (!snapshot.hasData ||
                                snapshot.data!.docs.isEmpty) {
                              return h8(context, texte: "0 Commentaires");
                            }
                            final docs = snapshot.data!.docs;
                            return h8(
                              context,
                              texte: "${docs.length} Commentaires",
                              couleur: Color(0xFFBE4A00),
                              //gras: true,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: larg(context, ratio: 0.01)),
                  noteArticle(
                    context,
                    taille: larg(context, ratio: 0.03),
                    note: 2.5,
                    //modifiable: true,
                  ),
                ],
              ),
            ),
          ],
        ),

        /* Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.thumb_up_alt_outlined),
                ),
                h8(context, texte: "J'aime"),
              ],
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    rangCommentaire.value = 0;
                    controlRepondreAvide.clear();
                    changePage(
                      context,
                      PageAvecChampFixe(
                        idProduit: idArticle,
                        urlImgProduit: data["listeImagesPublique"].isEmpty
                            ? data["listeImagesTemporairesProduit"]
                            : data["listeImagesPublique"],
                        nomArticle: nomArticle,
                        prixArticle: prixArticle,
                      ),
                    );
                  },
                  icon: Icon(FontAwesomeIcons.commentDots),
                ),
                h8(context, texte: "Commenter"),
              ],
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(FontAwesomeIcons.whatsapp),
                ),
                h8(context, texte: "Envoyer"),
              ],
            ),
            Row(
              children: [
                IconButton(onPressed: () {}, icon: Icon(Icons.star_border)),
                h8(context, texte: "Noter"),
              ],
            ),
          ],
        ),*/
      ],
    ),
  );
}

Widget defilementImagesHorizontales(
  BuildContext context,
  List<dynamic> urlsImages, {
  double taillePrCent = 0.45,
}) {
  final PageController controller = PageController(viewportFraction: 1);

  return Column(
    children: [
      SizedBox(
        height: long(context, ratio: taillePrCent),
        child: PageView.builder(
          controller: controller,
          itemCount: urlsImages.length,
          itemBuilder: (context, index) {
            return AnimatedBuilder(
              animation: controller,
              builder: (context, child) {
                double value = 1.0;

                if (controller.position.haveDimensions) {
                  value = controller.page! - index;
                  value = (1 - (value.abs() * 0.2)).clamp(0.8, 1.0);
                }

                return Center(
                  child: Transform.scale(
                    scale: value,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: imageNetwork(
                          context,
                          urlsImages[index],
                          pleinW: true,
                          borderRadius: 6,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),

      const SizedBox(height: 10),

      // ✅ Indicateurs (dots)
      SmoothPageIndicator(
        controller: controller,
        count: urlsImages.length,
        effect: WormEffect(
          dotHeight: 8,
          dotWidth: 8,
          spacing: 8,
          activeDotColor: Colors.orange,
          dotColor: Colors.grey.shade400,
        ),
      ),
    ],
  );
}

Widget bouttonModifPageProduit(
  BuildContext context,
  String idArticle,
  String idBoutique,
) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: larg(context, ratio: 0.02)),
    width: double.infinity, // Prend toute la largeur disponible
    child: TextButton.icon(
      onPressed: () async {
        final doc = await CloudFirestore().lectureUBdd(
          "produits",
          idDoc: idArticle,
        );

        if (doc != null && doc.exists) {
          final data = doc.data() as Map<String, dynamic>;

          tabPhoto = [];
          for (
            var i = 0;
            i < data["listeImagesTemporairesProduit"].length;
            i++
          ) {
            tabPhoto.add({
              "lien": data["listeImagesTemporairesProduit"][i],
              "image": null,
              "message": "modif",
            });
          }

          nomProduitAjoutController.text = data["nomTemporaireProduit"];
          prixProduitAjoutController.text = data["prixTemporaireProduit"];
          listeCocherTailleVetement = data["taillesVentementDisponibles"];
          listeCocherPointureChessure = data["pointuresChaussureDisponible"];

          //setState(() => enChargement = true);

          //messageErreurBar(context, messageErr: "kjkjkj");
          modificationProduit = false;
          modificationProduitPublique = true;
          afficheMessage = false;
          //afficheMessage = true;
          /*messageServerModifProduit =
                                      widget.data["messageRefus"];*/
          //tabPhoto = [];
          tabImgeSup = [];

          idProduitsModifie = idArticle;

          if (!await CloudFirestore().checkConnexionFirestore()) {
            messageErreurBar(context, messageErr: "Vérifiez votreconnection !");
            return;
          }

          //setState(() => enChargement = false);

          changePage(
            context,
            AjoutProduits(title: "Modification", idBoutique: idBoutique),
          );
        }
      },
      icon: Icon(Icons.edit, color: Colors.white),
      label: Text(
        "Modifier",
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

Widget afficheTailleSivettement(
  BuildContext context,
  List taille,
  List tablCoch,
) {
  if (!tablCoch.contains(true)) {
    return SizedBox();
  }

  List<Widget> tabl = [];

  for (var i = 0; i < tablCoch.length; i++) {
    if (tablCoch[i]) {
      tabl.add(
        Container(
          decoration: BoxDecoration(
            //border: Border.all(),
            color: Color.fromARGB(255, 231, 221, 205),
          ),
          //height: long(context, ratio: 0.04),
          padding: EdgeInsets.all(larg(context, ratio: 0.01)),
          margin: EdgeInsets.all(larg(context, ratio: 0.01)),
          child: Center(
            child: taille[i] == "S"
                ? Icon(Icons.child_care)
                : h9(context, texte: taille[i]),
          ),
          //width: larg(context, ratio: 0.05),
        ),
      );
    }
  }

  return Column(
    children: [
      //SizedBox(height: long(context, ratio: 0.03)),
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          //borderRadius: BorderRadius.circular(5),
        ),
        padding: EdgeInsets.all(larg(context, ratio: 0.02)),
        //margin: EdgeInsets.symmetric(horizontal: larg(context, ratio: 0.05)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            h7(context, texte: "Tailles disponibles"),
            SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: tabl),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget affichePointureSiChaussure(
  BuildContext context,
  List taille,
  List tablCoch,
) {
  if (!tablCoch.contains(true)) {
    return SizedBox();
  }

  List<Widget> tabl = [];

  for (var i = 0; i < tablCoch.length; i++) {
    if (tablCoch[i]) {
      tabl.add(
        Container(
          decoration: BoxDecoration(
            //border: Border.all(),
            color: Color.fromARGB(255, 231, 221, 205),
          ),
          //height: long(context, ratio: 0.04),
          padding: EdgeInsets.all(larg(context, ratio: 0.01)),
          margin: EdgeInsets.all(larg(context, ratio: 0.01)),
          child: Center(
            child: taille[i] == "S"
                ? Icon(Icons.child_care)
                : h9(context, texte: taille[i]),
          ),
          //width: larg(context, ratio: 0.05),
        ),
      );
    }
  }

  return Column(
    children: [
      //SizedBox(height: long(context, ratio: 0.02)),
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        padding: EdgeInsets.all(larg(context, ratio: 0.02)),

        //margin: EdgeInsets.symmetric(horizontal: larg(context, ratio: 0.05)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            h7(context, texte: "Pointures disponibles"),
            SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: tabl),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget descriptionPageArticleBoutique(
  BuildContext context,
  String description,
) {
  if (description.trim().isEmpty) {
    return const SizedBox(); // Si vide, on ne montre rien
  }

  return Column(
    children: [
      //SizedBox(height: long(context, ratio: 0.02)),
      Container(
        width: larg(context),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        padding: EdgeInsets.all(larg(context, ratio: 0.02)),
        // margin: EdgeInsets.symmetric(horizontal: larg(context, ratio: 0.05)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            h7(context, texte: "Description"),
            SizedBox(height: long(context, ratio: 0.01)),
            /*h9(
              context,
              texte: description,
              nbrDeLigneMax: 100, // assez grand pour ne pas couper
            ),*/
            html(description),
          ],
        ),
      ),
    ],
  );
}
