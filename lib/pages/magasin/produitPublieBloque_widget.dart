import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:koontaa/Commentaire/pageDeCommentaire.dart';
import 'package:koontaa/functions/cloud_firebase.dart';
import 'package:koontaa/functions/fonctions.dart';
import 'package:koontaa/functions/storage.dart';
import 'package:koontaa/pages/compte/connection/page_connection.dart';
import 'package:koontaa/pages/magasin/ajoutDeProduit.dart';
import 'package:koontaa/pages/magasin/page_article_magasin.dart';

class ContProduitBoutiquePublieBloque extends StatefulWidget {
  final Map<String, dynamic> data;
  final String id;
  final String idBoutique;

  const ContProduitBoutiquePublieBloque({
    super.key,
    required this.data,
    required this.id,
    required this.idBoutique,
  });

  @override
  State<ContProduitBoutiquePublieBloque> createState() =>
      _ContProduitBoutiquePublieBloqueState();
}

class _ContProduitBoutiquePublieBloqueState
    extends State<ContProduitBoutiquePublieBloque> {
  bool enChargement = false;

  List infoDef() {
    List res = [];
    final don = widget.data;

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

    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          changePage(
            context,
            PageArticleMagasin(
              title: "Article",
              idArticle: widget.id,
              nomBoutique: "Koontaa",
              lienImageBoutique:
                  "https://thumbs.dreamstime.com/b/boutique-34493816.jpg",
              nomArticle: infoDef()[1],
              prixArticle: widget.data["prixTemporaireProduit"],
              idBoutique: widget.idBoutique,
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.all(larg(context, ratio: 0.01)),
          margin: EdgeInsets.symmetric(
            horizontal: larg(context, ratio: 0.03),
            vertical: long(context, ratio: 0.003),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(larg(context, ratio: 0.02)),
            color: Colors.white,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🖼️ Image produit
              Container(
                width: larg(context, ratio: 1 / 4),
                height: long(context, ratio: 1 / 7),
                child: imageNetwork(
                  context,
                  infoDef()[0][0],
                  borderRadius: larg(context, ratio: 0.02),
                  pleinW: false,
                ),
              ),

              SizedBox(width: larg(context, ratio: 0.02)),

              // 📝 Texte & réactions
              Expanded(
                flex: 2,
                child: Container(
                  height: long(context, ratio: 1 / 6),
                  padding: EdgeInsets.all(larg(context, ratio: 0.01)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      h5(context, texte: infoDef()[1]),
                      SizedBox(height: long(context, ratio: 0.005)),
                      Row(
                        children: [
                          Icon(Icons.dangerous, color: Colors.red),
                          SizedBox(width: 5),
                          h7(context, texte: "Bloqué", couleur: Colors.red),
                        ],
                      ),
                      SizedBox(height: long(context, ratio: 0.005)),
                      noteArticle(context, note: widget.data["note"]),
                      Spacer(),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () async {
                              final doc = await CloudFirestore().lectureUBdd(
                                "produits",
                                idDoc: widget.id,
                              );

                              if (doc != null && doc.exists) {
                                final data = doc.data() as Map<String, dynamic>;
                                changePage(
                                  context,
                                  PageAvecChampFixe(
                                    idProduit: widget.id,
                                    urlImgProduit: infoDef()[0],
                                    nomArticle: infoDef()[1],
                                    prixArticle: data["prixTemporaireProduit"],
                                  ),
                                );
                              } else {
                                messageErreurBar(
                                  context,
                                  messageErr: "Erreur de connection !",
                                );
                              }
                            },
                            child: Row(
                              children: [
                                nbrComments(context, widget.id),
                                SizedBox(width: 3),
                                Icon(Icons.comment, size: 16),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              final doc = await CloudFirestore().lectureUBdd(
                                "produits",
                                idDoc: widget.id,
                              );

                              if (doc != null && doc.exists) {
                                final data = doc.data() as Map<String, dynamic>;
                                changePage(
                                  context,
                                  PageAvecChampFixe(
                                    idProduit: widget.id,
                                    urlImgProduit: infoDef()[0],
                                    nomArticle: infoDef()[1],
                                    prixArticle: data["prixTemporaireProduit"],
                                  ),
                                );
                              } else {
                                messageErreurBar(
                                  context,
                                  messageErr: "Erreur de connection !",
                                );
                              }
                            },
                            child: afficheLike(context, widget.id),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // 💰 Prix & menu contextuel
              Container(
                width: larg(context, ratio: 1 / 6),
                height: long(context, ratio: 1 / 6),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    h8(
                      context,
                      texte: "${arg(widget.data["prixTemporaireProduit"])} F",
                      couleur: const Color.fromARGB(255, 45, 25, 13),
                      gras: true,
                    ),
                    enChargement
                        ? circular(message: "")
                        : MenuContextuelAnime(
                            actions: [
                              MenuAction(
                                texte: "Afficher",
                                icon: Icons.print_sharp,
                                couleur: Colors.blue,
                                onTap: () {
                                  changePage(
                                    context,
                                    PageArticleMagasin(
                                      title: "Article",
                                      idArticle: widget.id,
                                      nomBoutique: "Koontaa",
                                      lienImageBoutique:
                                          "https://thumbs.dreamstime.com/b/boutique-34493816.jpg",
                                      nomArticle: infoDef()[1],
                                      prixArticle:
                                          widget.data["prixTemporaireProduit"],
                                      idBoutique: widget.idBoutique,
                                    ),
                                  );
                                },
                              ),
                              MenuAction(
                                texte: "Modifier",
                                icon: Icons.edit,
                                couleur: Colors.amber,
                                onTap: () async {
                                  //setState(() => enChargement = true);
                                  tabPhoto = [];
                                  for (
                                    var i = 0;
                                    i <
                                        widget
                                            .data["listeImagesTemporairesProduit"]
                                            .length;
                                    i++
                                  ) {
                                    tabPhoto.add({
                                      "lien": widget
                                          .data["listeImagesTemporairesProduit"][i],
                                      "image": null,
                                      "message": "modif",
                                    });
                                  }

                                  nomProduitAjoutController.text =
                                      widget.data["nomTemporaireProduit"];
                                  prixProduitAjoutController.text =
                                      widget.data["prixTemporaireProduit"];
                                  listeCocherTailleVetement = widget
                                      .data["taillesVentementDisponibles"];
                                  listeCocherPointureChessure = widget
                                      .data["pointuresChaussureDisponible"];
                                  //messageErreurBar(context, messageErr: "kjkjkj");
                                  modificationProduit = false;
                                  modificationProduitPublique = true;
                                  afficheMessage = false;
                                  //afficheMessage = true;
                                  /*messageServerModifProduit =
                                      widget.data["messageRefus"];*/
                                  //tabPhoto = [];
                                  tabImgeSup = [];

                                  idProduitsModifie = widget.id;

                                  if (!await CloudFirestore()
                                      .checkConnexionFirestore()) {
                                    messageErreurBar(
                                      context,
                                      messageErr: "Vérifiez votreconnection !",
                                    );
                                    return;
                                  }

                                  //setState(() => enChargement = false);

                                  changePage(
                                    context,
                                    AjoutProduits(
                                      title: "Modification",
                                      idBoutique: widget.idBoutique,
                                    ),
                                  );
                                },
                              ),
                              MenuAction(
                                texte: "Débloquer",
                                icon: Icons.verified,
                                couleur: Colors.green,
                                onTap: () async {
                                  if (!await CloudFirestore()
                                      .checkConnexionFirestore()) {
                                    messageErreurBar(
                                      context,
                                      messageErr: "Problème de connection !",
                                    );
                                    return;
                                  }

                                  CloudFirestore().modif(
                                    "produits",
                                    widget.id,
                                    {"status": 3},
                                  );
                                },
                              ),
                            ],
                          ),
                    Row(
                      children: [
                        h9(context, texte: "Vendu :", couleur: Colors.black45),
                        h8(
                          context,
                          texte: "12",
                          couleur: Colors.green.shade400,
                          gras: true,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget nbrComments(BuildContext context, String idProduit) {
  return StreamBuilder(
    stream: CloudFirestore().lectureBdd(
      "commentaires",
      filtreCompose: cd("idProduits", idProduit),
    ),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return h8(context, texte: "!");
      }
      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return h8(context, texte: "0");
      }
      final docs = snapshot.data!.docs;
      return h8(context, texte: " ${docs.length}");
    },
  );
}

//https://www.shutterstock.com/image-vector/fashion-logo-design-template-suitable-260nw-2461938725.jpg
//https://img.freepik.com/psd-gratuit/logo-du-smartphone-isole_23-2151232010.jpg
