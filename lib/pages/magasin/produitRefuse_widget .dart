import 'package:flutter/material.dart';
import 'package:koontaa/functions/cloud_firebase.dart';
import 'package:koontaa/functions/fonctions.dart';
import 'package:koontaa/functions/storage.dart';
import 'package:koontaa/pages/compte/connection/page_connection.dart';
import 'package:koontaa/pages/magasin/ajoutDeProduit.dart';

class ContProduitBoutiqueRefuse extends StatefulWidget {
  final Map<String, dynamic> data;
  final String id;

  const ContProduitBoutiqueRefuse({
    super.key,
    required this.data,
    required this.id,
  });

  @override
  State<ContProduitBoutiqueRefuse> createState() =>
      _ContProduitBoutiqueRefuseState();
}

class _ContProduitBoutiqueRefuseState extends State<ContProduitBoutiqueRefuse> {
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
          affimessageProduitTRefuse(context, widget.data["messageRefus"]);
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
                  widget.data["listeImagesTemporairesProduit"][0],
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
                        Icon(Icons.dangerous),
                        SizedBox(width: larg(context, ratio: 0.025)),
                        h7(
                          context,
                          texte: "Réfusé",
                          couleur: Colors.red,
                          gras: true,
                        ),
                      ],
                    ),
                    h8(
                      context,
                      texte: widget.data["messageRefus"],
                      nbrDeLigneMax: 3,
                      gras: true,
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
                        : IconButton(
                            onPressed: supprimerProduit,
                            icon: Icon(Icons.close, color: Colors.red),
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

void affimessageProduitTRefuse(BuildContext context, String message) {
  showDialog(
    context: context,
    barrierDismissible: true, // Peut être fermé en appuyant hors du dialog
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.red),
            SizedBox(width: 8),
            Text("Réfusé", style: TextStyle(color: Colors.red)),
          ],
        ),
        content: SizedBox(
          width: larg(context, ratio: 0.8),
          //height: long(context, ratio: 0.25),
          child: SingleChildScrollView(child: Text(message)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Fermer"),
          ),
        ],
      );
    },
  );
}

//https://www.shutterstock.com/image-vector/fashion-logo-design-template-suitable-260nw-2461938725.jpg
//https://img.freepik.com/psd-gratuit/logo-du-smartphone-isole_23-2151232010.jpg
