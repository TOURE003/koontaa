import 'package:flutter/material.dart';
import 'package:koontaa/functions/cloud_firebase.dart';
import 'package:koontaa/functions/fonctions.dart';
import 'package:koontaa/functions/storage.dart';
import 'package:koontaa/pages/compte/connection/page_connection.dart';
import 'package:koontaa/pages/magasin/ajoutDeProduit.dart';

class ContProduitBoutiqueTraitement extends StatefulWidget {
  final Map<String, dynamic> data;
  final String id;
  final String idBoutique;

  const ContProduitBoutiqueTraitement({
    super.key,
    required this.data,
    required this.id,
    required this.idBoutique,
  });

  @override
  State<ContProduitBoutiqueTraitement> createState() =>
      _ContProduitBoutiqueTraitementState();
}

class _ContProduitBoutiqueTraitementState
    extends State<ContProduitBoutiqueTraitement> {
  bool enChargement = false;

  Future<void> supprimerProduit() async {
    setState(() => enChargement = true);

    if (!await CloudFirestore().checkConnexionFirestore()) {
      messageErreurBar(context, messageErr: "Vérifiez votre connection");
      setState(() => enChargement = false);
      return;
    }

    bool toutesSupprimees = true;
    for (String url in widget.data["listeImagesTemporairesProduit"]) {
      final result = await supprimerImage(url);
      if (!result) {
        toutesSupprimees = false;
        break;
      }
    }

    if (toutesSupprimees) {
      await CloudFirestore().sup("produits", widget.id);
    }

    try {
      setState(() => enChargement = false);
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          setState(() => enChargement = true);
          tabPhoto = [];
          for (
            var i = 0;
            i < widget.data["listeImagesTemporairesProduit"].length;
            i++
          ) {
            tabPhoto.add({
              "lien": widget.data["listeImagesTemporairesProduit"][i],
              "image": null,
              "message": "modif",
            });
          }

          nomProduitAjoutController.text = widget.data["nomTemporaireProduit"];
          prixProduitAjoutController.text =
              widget.data["prixTemporaireProduit"];
          listeCocherTailleVetement =
              widget.data["taillesVentementDisponibles"];
          listeCocherPointureChessure =
              widget.data["pointuresChaussureDisponible"];
          //messageErreurBar(context, messageErr: "kjkjkj");
          modificationProduit = true;
          afficheMessage = false;
          modificationProduitPublique = false;
          controleMessageBoutiqueModif.text =
              widget.data["messageBoutiquePourModif"] ?? "";
          //tabPhoto = [];
          tabImgeSup = [];

          idProduitsModifie = widget.id;

          if (!await CloudFirestore().checkConnexionFirestore()) {
            setState(() => enChargement = false);
            messageErreurBar(context, messageErr: "Vérifiez votreconnection !");
            return;
          }

          setState(() => enChargement = false);

          changePage(
            context,
            AjoutProduits(title: "Modification", idBoutique: widget.idBoutique),
          );
        },

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
                  widget.data["listeImagesTemporairesProduit"].isEmpty
                      ? ""
                      : widget.data["listeImagesTemporairesProduit"][0],
                  borderRadius: larg(context, ratio: 0.02),
                ),
              ),

              // Texte
              Container(
                margin: EdgeInsets.only(left: larg(context, ratio: 0.03)),
                padding: EdgeInsets.all(larg(context, ratio: 0.02)),
                height: long(context, ratio: 1 / 6),
                width: larg(context, ratio: 2 / 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    h5(context, texte: widget.data["nomTemporaireProduit"]),
                    SizedBox(height: long(context, ratio: 0.01)),
                    Row(
                      children: [
                        Icon(Icons.cached, color: Color(0x55BE4A00)),
                        SizedBox(width: larg(context, ratio: 0.025)),
                        h7(
                          context,
                          texte: "En traitement...",
                          couleur: Color(0xFFBE4A00),
                        ),
                      ],
                    ),
                    h8(
                      context,
                      texte: "Votre article est analysé par notre équipe...",
                      nbrDeLigneMax: 3,
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
                      couleur: Color(0xFFBE4A00),
                      nbrDeLigneMax: 2,
                    ),
                    enChargement
                        ? circular(message: "")
                        : MenuContextuelAnime(
                            actions: [
                              MenuAction(
                                texte: "Modifier",
                                icon: Icons.edit,
                                couleur: Colors.blueAccent,
                                onTap: () async {
                                  setState(() => enChargement = true);
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
                                  modificationProduit = true;
                                  afficheMessage = false;
                                  modificationProduitPublique = false;
                                  controleMessageBoutiqueModif.text =
                                      widget.data["messageBoutiquePourModif"] ??
                                      "";
                                  //tabPhoto = [];
                                  tabImgeSup = [];

                                  idProduitsModifie = widget.id;

                                  if (!await CloudFirestore()
                                      .checkConnexionFirestore()) {
                                    setState(() => enChargement = false);
                                    messageErreurBar(
                                      context,
                                      messageErr: "Vérifiez votreconnection !",
                                    );
                                    return;
                                  }

                                  setState(() => enChargement = false);

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
                                texte: "Supprimer",
                                icon: Icons.delete,
                                couleur: Colors.red,
                                onTap: supprimerProduit,
                              ),
                            ],
                          ),
                    /*IconButton(
                            onPressed: supprimerProduit,
                            icon: Icon(
                              Icons.close,
                              color: Color.fromARGB(84, 190, 0, 0),
                            ),
                          ),*/
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
