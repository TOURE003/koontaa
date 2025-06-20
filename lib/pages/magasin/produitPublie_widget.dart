import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:koontaa/functions/cloud_firebase.dart';
import 'package:koontaa/functions/fonctions.dart';
import 'package:koontaa/functions/storage.dart';
import 'package:koontaa/pages/compte/connection/page_connection.dart';
import 'package:koontaa/pages/magasin/ajoutDeProduit.dart';

class ContProduitBoutiquePublie extends StatefulWidget {
  final Map<String, dynamic> data;
  final String id;

  const ContProduitBoutiquePublie({
    super.key,
    required this.data,
    required this.id,
  });

  @override
  State<ContProduitBoutiquePublie> createState() =>
      _ContProduitBoutiquePublieState();
}

class _ContProduitBoutiquePublieState extends State<ContProduitBoutiquePublie> {
  bool enChargement = false;

  List infoDef() {
    List res = [];
    final don = widget.data;

    if (don["listeImagesPublique"].isEmpty) {
      res.add(don["listeImagesTemporairesProduit"][0]);
    } else {
      res.add(don["listeImagesPublique"][0]);
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
        onTap: () async {},

        child: Container(
          height: long(context, ratio: 1 / 6),
          padding: EdgeInsets.only(left: larg(context, ratio: 0.01)),
          margin: EdgeInsets.symmetric(
            horizontal: larg(context, ratio: 0.03),
            vertical: long(context, ratio: 0.003),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(larg(context, ratio: 0.02)),
            color: Colors.white,
          ),
          child: Row(
            children: [
              // Image produit
              Container(
                width: larg(context, ratio: 1 / 4),
                height: long(context, ratio: 1 / 7),
                child: imageNetwork(
                  context,
                  infoDef()[0],
                  borderRadius: larg(context, ratio: 0.02),
                  pleinW: false,
                ),
              ),

              // Texte
              Container(
                margin: EdgeInsets.only(left: larg(context, ratio: 0.03)),
                padding: EdgeInsets.all(larg(context, ratio: 0.01)),
                height: long(context, ratio: 1 / 6),
                width: larg(context, ratio: 2 / 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    h5(context, texte: infoDef()[1]),
                    SizedBox(height: long(context, ratio: 0.01)),
                    Row(
                      children: [
                        Icon(
                          Icons.fiber_manual_record,
                          color: const Color.fromARGB(255, 50, 155, 54),
                        ),
                        SizedBox(width: larg(context, ratio: 0.025)),
                        h7(
                          context,
                          texte: "Publié",
                          couleur: Color.fromARGB(255, 9, 73, 27),
                        ),
                      ],
                    ),
                    SizedBox(height: long(context, ratio: 0.005)),
                    noteArticle(context, note: widget.data["note"]),
                    //SizedBox(height: long(context, ratio: 0.010)),
                    SizedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              h8(
                                context,
                                texte:
                                    "${widget.data["listeCommentaire"].length}",
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  FontAwesomeIcons.commentDots,
                                  color: const Color.fromARGB(89, 0, 0, 0),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: larg(context, ratio: 0.045)),
                          Row(
                            children: [
                              h8(
                                context,
                                texte:
                                    "${widget.data["listeLikeIdUser"].length}",
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.favorite_border,
                                  color: const Color.fromARGB(106, 177, 34, 34),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Prix et bouton
              Container(
                width: larg(context, ratio: 1 / 7),
                padding: EdgeInsets.only(top: larg(context, ratio: 0.03)),
                height: long(context, ratio: 1 / 6),
                child: Column(
                  children: [
                    h8(
                      context,
                      texte: "${arg(widget.data["prixTemporaireProduit"])} F",
                      couleur: Color.fromARGB(255, 45, 25, 13),
                      nbrDeLigneMax: 2,
                      gras: true,
                    ),
                    enChargement
                        ? circular(message: "")
                        : MenuContextuelAnime(
                            actions: [
                              MenuAction(
                                texte: "Modifier",
                                icon: Icons.edit,
                                couleur: Colors.blue,
                                onTap: () {
                                  print("Modifier l'article");
                                },
                              ),
                              MenuAction(
                                texte: "Bloquer",
                                icon: Icons.fiber_manual_record,
                                couleur: const Color.fromARGB(255, 243, 175, 3),
                                onTap: () {
                                  print("Modifier l'article");
                                },
                              ),
                              MenuAction(
                                texte: "Supprimer",
                                icon: Icons.delete,
                                couleur: Colors.red,
                                onTap: () {
                                  print("Supprimer l'article");
                                },
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

//https://www.shutterstock.com/image-vector/fashion-logo-design-template-suitable-260nw-2461938725.jpg
//https://img.freepik.com/psd-gratuit/logo-du-smartphone-isole_23-2151232010.jpg
