//import 'dart:ffi';
import 'dart:io';
import 'package:koontaa/functions/cloud_firebase.dart';
import 'package:ntp/ntp.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl_phone_field/helpers.dart';
import 'package:koontaa/functions/fonctions.dart';
import 'package:koontaa/functions/storage.dart';
import 'package:koontaa/pages/compte/connection/page_connection.dart';
import 'package:flutter/services.dart';

class AjoutProduits extends StatefulWidget {
  const AjoutProduits({super.key, required this.title});

  final String title;

  @override
  State<AjoutProduits> createState() => _AjoutProduitsState();
}

final GlobalKey<FormState> _formKeyAjoutProduit = GlobalKey<FormState>();

class _AjoutProduitsState extends State<AjoutProduits> {
  @override
  Widget build(BuildContext context) {
    prendreUneNouvellePhotoArticle(context, () {
      setState(() {});
    });
    return Scaffold(
      backgroundColor: Color(0xFFF9EFE0),
      appBar: AppBar(
        backgroundColor: Color(0xFFF9EFE0),
        title: Center(child: Text("data")),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 35),
        child: Form(
          key: _formKeyAjoutProduit,
          child: Column(
            children: [
              barreDePhoto(context, () {
                setState(() {});
              }),
              SizedBox(height: long(context, ratio: 0.025)),
              inputFieldnomProduitAjoutProduit(context, () {
                setState(() {});
              }),
              SizedBox(height: long(context, ratio: 0.02)),
              inputFieldPrixProduitAjoutProduit(context, () {
                setState(() {});
              }),
              SizedBox(height: long(context, ratio: 0.02)),
              listeTaillesVetements(context, () {
                setState(() {});
              }),
              SizedBox(height: long(context, ratio: 0.025)),
              listeTaillesChessure(context, () {
                setState(() {});
              }),
              SizedBox(height: long(context, ratio: 0.025)),
              boutonAjouterArticle(context, () {
                setState(() {});
              }),
            ],
          ),
        ),
      ),
    );
  }
}

List<Map<String, dynamic>> tabPhoto = [];
Widget boutonPhoto(BuildContext context, Function setStating) {
  return Container(
    //padding: EdgeInsetsGeometry.all(larg(context, ratio: 0.05)),
    //height: long(context, ratio: 1 / 3),
    width: larg(context, ratio: 0.65),
    decoration: BoxDecoration(
      color: const Color.fromARGB(66, 220, 184, 151),
      borderRadius: BorderRadius.circular(larg(context, ratio: 0.03)),
    ),
    child: Column(
      children: [
        Container(
          width: larg(context, ratio: 0.6),
          //height: long(context, ratio: 0.16),
          decoration: BoxDecoration(
            //color: Colors.orange,
            //borderRadius: BorderRadius.circular(larg(context, ratio: 1 / 60)),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //SizedBox(height: long(context, ratio: 1 / 50)),
                IconButton(
                  onPressed: () async {
                    final photo = await imageUser(camera: true);
                    if (photo["message"] == "autorisation") {
                      messageAutorisation(context);
                      return;
                    } else if (photo["message"] == "erreur") {
                      messageErreurBar(context);
                    } else if (photo["message"] == "ok") {
                      tabPhoto.insert(0, photo);
                      setStating();
                    }
                    //messageAutorisation(context);
                  },
                  icon: Icon(
                    Icons.camera_alt,
                    size: larg(context, ratio: 0.2),
                    color: Color(0xFFBE4A00),
                  ),
                ),
                Text(
                  "Caméra",
                  style: TextStyle(
                    fontSize: larg(context, ratio: 0.03),
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
        //SizedBox(height: long(context, ratio: 0.03)),
        Row(
          //crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: larg(context, ratio: 0.3),
              child: TextButton.icon(
                onPressed: () async {
                  final photo = await imageUser(camera: false);
                  if (photo["message"] == "autorisation") {
                    messageAutorisation(context);
                    return;
                  } else if (photo["message"] == "erreur") {
                    messageErreurBar(context);
                  } else if (photo["message"] == "ok") {
                    tabPhoto.insert(0, photo);
                    setStating();
                  }
                },
                icon: Icon(Icons.photo, color: Color(0xFFBE4A00)),
                label: Text(
                  "Galérie",
                  style: TextStyle(
                    fontSize: larg(context, ratio: 0.03),
                    color: Colors.black,
                  ),
                ),
                style: TextButton.styleFrom(
                  //backgroundColor: Color(0xFFBE4A00), // Couleur de fond
                  shape: RoundedRectangleBorder(
                    //borderRadius: BorderRadius.circular(10), // Bords arrondis
                    // Bordure
                    //side: BorderSide(color: Colors.blueAccent, width: 1.5),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 16,
                  ), // Hauteur du bouton
                ),
              ),
            ),
            Container(
              width: larg(context, ratio: 0.3),
              child: TextButton.icon(
                onPressed: () {
                  boiteAjoutLien(context, setStating);
                },
                icon: Icon(Icons.link, color: Color(0xFFBE4A00)),
                label: Text(
                  "Lien",
                  style: TextStyle(
                    fontSize: larg(context, ratio: 0.03),
                    color: Colors.black,
                  ),
                ),
                style: TextButton.styleFrom(
                  //backgroundColor: Color(0xFFBE4A00), // Couleur de fond
                  shape: RoundedRectangleBorder(
                    //borderRadius: BorderRadius.circular(10), // Bords arrondis
                    // Bordure
                    //side: BorderSide(color: Colors.blueAccent, width: 1.5),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 16,
                  ), // Hauteur du bouton
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

bool cameraAuto = false;
Future<void> prendreUneNouvellePhotoArticle(
  BuildContext context,
  Function setStating,
) async {
  if (cameraAuto && tabPhoto.isEmpty) {
    try {
      final photo = await imageUser(camera: true);
      if (photo["message"] == "autorisation") {
        messageAutorisation(context);
      } else if (photo["message"] == "erreur") {
        messageErreurBar(context);
      } else if (photo["message"] == "ok") {
        tabPhoto.insert(0, photo);
        setStating();
      } else {
        messageErreurBar(
          context,
          messageErr: "Ajoutez une photo !",
          couleur: Colors.green,
        );
      }
    } catch (e) {}
  }
  cameraAuto = false;
  return;
}

Widget barreDePhoto(BuildContext context, Function setStating) {
  return SizedBox(
    height: long(context, ratio: 0.25),
    child: ListView(
      scrollDirection: Axis.horizontal,
      children: [
        SizedBox(width: larg(context, ratio: 0.1)),
        boutonPhoto(context, setStating),
        //SizedBox(width: larg(context, ratio: 0.04)),

        //Image.network("https://img.freepik.com/psd-gratuit/logo-du-smartphone-isole_23-2151232010.jpg",),
        ...tabPhoto.map((value) {
          return Row(
            children: [
              SizedBox(width: larg(context, ratio: 0.04)),
              imageTemporaire(context, setStating, value),
            ],
          );
        }),
        //boutonPhoto(context),
      ],
    ),
  );
}

final TextEditingController _nomProduitAjoutController =
    TextEditingController();
Widget inputFieldnomProduitAjoutProduit(
  BuildContext context,
  Function setStating,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Text(
            "Nom du produit",
            style: TextStyle(fontSize: larg(context, ratio: 0.035)),
          ),
          Text(
            "  (et autres informations utiles)",
            style: TextStyle(fontSize: larg(context, ratio: 0.022)),
          ),
        ],
      ),
      TextFormField(
        onChanged: (value) {},
        controller: _nomProduitAjoutController,
        validator: (value) {
          if (value == null || value.length <= 2) {
            return "Ajoutez le nom d'u produit";
          }
          return null;
        },

        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey, // Couleur de la bordure
              width: 1.0, // Épaisseur fine
            ),
            borderRadius: BorderRadius.circular(8), // Coins arrondis
          ),

          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xFFBE4A00), // Orange Koontaa par exemple
              width: 1.5, // Légèrement plus épaisse
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: Colors.white,
          //label: Text("hiden", style: TextStyle(fontSize: 20)),
          border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(15)),
          ),
        ),
      ),
    ],
  );
}

final TextEditingController _prixProduitAjoutController =
    TextEditingController();
Widget inputFieldPrixProduitAjoutProduit(
  BuildContext context,
  Function setStating,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Prix de vente",
        style: TextStyle(fontSize: larg(context, ratio: 0.035)),
      ),
      TextFormField(
        keyboardType: TextInputType.number,
        onChanged: (value) {},
        controller: _prixProduitAjoutController,
        validator: (value) {
          if (value == null || value == "") {
            return "Ajoutez le prix de vente";
          }
          if (int.parse(value) <= 100) {
            return "Somme suppérieur à 100FCFA";
          }
          return null;
        },

        decoration: InputDecoration(
          prefix: Container(
            margin: EdgeInsetsGeometry.only(right: larg(context, ratio: 0.03)),

            child: Text(
              "FCFA",
              style: TextStyle(
                color: Color(0xFFBE4A00),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey, // Couleur de la bordure
              width: 1.0, // Épaisseur fine
            ),
            borderRadius: BorderRadius.circular(8), // Coins arrondis
          ),

          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xFFBE4A00), // Orange Koontaa par exemple
              width: 1.5, // Légèrement plus épaisse
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: Colors.white,
          //label: Text("hiden", style: TextStyle(fontSize: 20)),
          border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(15)),
          ),
        ),
      ),
    ],
  );
}

Widget imageTemporaire(
  BuildContext context,
  Function setStating,
  Map<String, dynamic> image,
) {
  final Image img;
  final regex = RegExp(
    r'^https?:\/\/.*\.(?:png|jpg|jpeg|gif|bmp|webp)$',
    caseSensitive: false,
  );

  if (regex.hasMatch(image["lien"])) {
    img = Image.network(image["lien"], fit: BoxFit.cover);
  } else {
    img = Image.file(File(image["image"].path), fit: BoxFit.cover);
  }

  return Container(
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
    child: Stack(
      children: [
        ClipRRect(borderRadius: BorderRadius.circular(6), child: img),
        Positioned(
          top: 4,
          left: 4,
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(127, 255, 255, 255),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(Icons.close, size: 16),
              //padding: EdgeInsets.zero,
              //constraints: BoxConstraints(),
              onPressed: () {
                tabPhoto.removeWhere((element) => element == image);
                setStating(); // Tu pourras définir une action ici
              },
            ),
          ),
        ),
      ],
    ),
  );
}

void boiteAjoutLien(BuildContext context, Function setStating) {
  final TextEditingController lienController = TextEditingController();
  final GlobalKey<FormState> _formKeyLien = GlobalKey<FormState>();

  showDialog(
    barrierDismissible: true,
    barrierColor: const Color.fromARGB(107, 0, 0, 0),
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Lien image"),
        content: Container(
          width: larg(context, ratio: 0.75),
          child: Form(
            key: _formKeyLien,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Collez le lien ici"),
                const SizedBox(height: 12),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.paste),
                      tooltip: "Coller depuis le presse-papiers",
                      onPressed: () async {
                        final data = await Clipboard.getData(
                          Clipboard.kTextPlain,
                        );
                        final lienColle = data?.text ?? "";
                        lienController.text = lienColle;
                      },
                    ),
                    Expanded(
                      child: TextFormField(
                        validator: (value) {
                          final regex = RegExp(
                            r'^https?:\/\/.*\.(?:png|jpg|jpeg|gif|bmp|webp)$',
                            caseSensitive: false,
                          );
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer un lien.';
                          }
                          if (!regex.hasMatch(value)) {
                            return "Lien non valide (doit finir par .jpg, .png, etc.).";
                          }
                          return null;
                        },
                        controller: lienController,
                        decoration: const InputDecoration(
                          hintText: "https://...",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            child: const Text("Valider"),
            onPressed: () {
              if (_formKeyLien.currentState!.validate()) {
                tabPhoto.insert(0, {
                  "lien": lienController.text,
                  "image": null,
                  "message": "ok",
                });
                setStating();
                Navigator.of(context).pop();
              }
            },
          ),
          TextButton(
            child: const Text("Annuler"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

//List listeCocherTailleVetement = [false, false, false, false, false];
List<String> listeNomTaille = [
  'S', // Small
  'M', // Medium
  'L', // Large
  'XL', // Extra Large
  'XXL', // 2X Large
  'XS', // Extra Small
  'XXXL', // 3X Large
  'XXXS', // 3X Small (rare)
  'XXXXL', // 4X Large
  'XXXXXL', // 5X Large (très rare)
];

List<bool> listeCocherTailleVetement = [
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
];

Widget listeTaillesVetements(BuildContext context, Function setStating) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          titreTexbox(context, text: "Tailles disponibles si vêtement"),
          SizedBox(width: larg(context, ratio: 0.01)),
          Icon(
            FontAwesomeIcons.shirt,
            size: larg(context, ratio: 0.03),
            color: Color(0x55BE4A00),
          ),
          SizedBox(width: larg(context, ratio: 0.01)),
        ],
      ),
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(larg(context, ratio: 0.02)),
          border: Border.all(
            color: Colors.grey,
            width: 1.0,
            style: BorderStyle.solid,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
        child: SizedBox(
          height: long(context, ratio: 0.08),

          child: Scrollbar(
            child: ListView(
              padding: EdgeInsetsGeometry.all(0),
              scrollDirection: Axis.horizontal,
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                !listeCocherTailleVetement.contains(true)
                    ? Column(
                        children: [
                          IconButton(
                            onPressed: () {
                              listeCocherTailleVetement = [
                                true,
                                true,
                                true,
                                true,
                                true,
                                true,
                                true,
                                true,
                                true,
                                true,
                              ];
                              setStating();
                            },
                            icon: Icon(Icons.select_all),
                          ),
                          Text(
                            "Tous",
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          IconButton(
                            onPressed: () {
                              listeCocherTailleVetement = [
                                false,
                                false,
                                false,
                                false,
                                false,
                                false,
                                false,
                                false,
                                false,
                                false,
                              ];
                              setStating();
                            },
                            icon: Icon(Icons.close),
                          ),
                          Text(
                            "Aucun",
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                ...listeCocherTailleVetement.asMap().entries.map((entry) {
                  int key = entry.key;
                  bool valeur = entry.value;

                  return Row(
                    children: [
                      SizedBox(width: larg(context, ratio: 0.07)),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                            value: valeur,
                            onChanged: (value) {
                              listeCocherTailleVetement[key] = value!;
                              setStating();
                            },
                            shape: const CircleBorder(), // 👈 rond
                            side: const BorderSide(
                              width: 1.5,
                              color: Colors.grey,
                            ), // bord visible
                            checkColor: Colors.white, // couleur du "✔"
                            activeColor: Color(0xFFBE4A00), // fond quand coché
                          ),
                          listeNomTaille[key] == "S"
                              ? Icon(Icons.child_care)
                              : Text(
                                  listeNomTaille[key],
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ],
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}

List listeCocherPointureChessure = [
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
];
List<String> listeNomPointure = [
  'S', // Pour bébé
  '28', '29', '30', '31', '32', '33', // Enfants
  '34', '35', '36', '37', // Ados / femmes
  '38', '39', '40', '41', '42', // Adultes (standard)
  '43', '44', '45', '46', '47', '48', // Grands pieds
];
Widget listeTaillesChessure(BuildContext context, Function setStating) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          titreTexbox(context, text: "Pointures disponibles si chaussure"),
          SizedBox(width: larg(context, ratio: 0.01)),
          Icon(
            FontAwesomeIcons.shoePrints,
            size: larg(context, ratio: 0.03),
            color: Color(0x88BE4A00),
          ),
        ],
      ),
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(larg(context, ratio: 0.02)),
          border: Border.all(
            color: Colors.grey,
            width: 1.0,
            style: BorderStyle.solid,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
        child: SizedBox(
          height: long(context, ratio: 0.08),
          child: Scrollbar(
            child: ListView(
              scrollDirection: Axis.horizontal,
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                !listeCocherPointureChessure.contains(true)
                    ? Column(
                        children: [
                          IconButton(
                            onPressed: () {
                              listeCocherPointureChessure = [
                                true,
                                true,
                                true,
                                true,
                                true,
                                true,
                                true,
                                true,
                                true,
                                true,
                                true,
                                true,
                                true,
                                true,
                                true,
                                true,
                                true,
                                true,
                                true,
                                true,
                                true,
                                true,
                              ];
                              setStating();
                            },
                            icon: Icon(Icons.select_all),
                          ),
                          Text(
                            "Tous",
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          IconButton(
                            onPressed: () {
                              listeCocherPointureChessure = [
                                false,
                                false,
                                false,
                                false,
                                false,
                                false,
                                false,
                                false,
                                false,
                                false,
                                false,
                                false,
                                false,
                                false,
                                false,
                                false,
                                false,
                                false,
                                false,
                                false,
                                false,
                                false,
                              ];
                              setStating();
                            },
                            icon: Icon(Icons.close),
                          ),
                          Text(
                            "Aucun",
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                ...listeCocherPointureChessure.asMap().entries.map((entry) {
                  int key = entry.key;
                  bool valeur = entry.value;

                  return Row(
                    children: [
                      SizedBox(width: larg(context, ratio: 0.06)),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                            value: valeur,
                            onChanged: (value) {
                              listeCocherPointureChessure[key] = value!;
                              setStating();
                            },
                            shape: const CircleBorder(), // 👈 rond
                            side: const BorderSide(
                              width: 1.5,
                              color: Colors.grey,
                            ), // bord visible
                            checkColor: Colors.white, // couleur du "✔"
                            activeColor: Color(0xFFBE4A00),
                          ),
                          listeNomPointure[key] == "S"
                              ? Icon(Icons.child_care)
                              : Text(
                                  listeNomPointure[key],
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ],
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}

Widget boutonAjouterArticle(BuildContext context, Function setStating) {
  return Container(
    //margin: EdgeInsets.symmetric(horizontal: larg(context, ratio: 0.02)),
    width: double.infinity, // Prend toute la largeur disponible
    child: TextButton.icon(
      onPressed: loadingEnvoieProduit
          ? null
          : () {
              if (_formKeyAjoutProduit.currentState!.validate()) {
                if (tabPhoto.isEmpty) {
                  cameraAuto = true;
                  prendreUneNouvellePhotoArticle(context, setStating);
                  return;
                }

                ajoutProduit(context, setStating);
              }
            },
      icon: Icon(Icons.add_box, color: Colors.white),
      label: loadingEnvoieProduit
          ? circular(message: "")
          : Text(
              "Ajouter",
              style: TextStyle(
                fontSize: larg(context, ratio: 0.03),
                color: Colors.white,
              ),
            ),
      style: TextButton.styleFrom(
        backgroundColor: loadingEnvoieProduit
            ? Colors.white
            : Color(0xFFBE4A00), // Couleur de fond
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Bords arrondis
          // Bordure
        ),
        padding: EdgeInsets.symmetric(vertical: 16), // Hauteur du bouton
      ),
    ),
  );
}

Widget titreTexbox(BuildContext context, {String text = "Text"}) {
  return Text(text, style: TextStyle(fontSize: larg(context, ratio: 0.035)));
}

List imageEnvoyer = [];
List<String> tabLien = [];
bool loadingEnvoieProduit = false;
void ajoutProduit(BuildContext context, Function setStating) async {
  loadingEnvoieProduit = true;
  setStating();
  if (!await CloudFirestore().checkConnexionFirestore()) {
    messageErreurBar(context, messageErr: "Vérifiez votre connection !");
    return;
  }

  final regex = RegExp(
    r'^https?:\/\/.*\.(?:png|jpg|jpeg|gif|bmp|webp)$',
    caseSensitive: false,
  );
  //envoie et reccuperation liens Image
  try {
    for (var i = 0; i < tabPhoto.length; i++) {
      if (regex.hasMatch(tabPhoto[i]["lien"])) {
        tabLien.add(tabPhoto[i]["lien"]);
      } else {
        if (!imageEnvoyer.contains(tabPhoto[i])) {
          final lien = await envoieImage(tabPhoto[i]["image"]);

          tabLien.add(lien);
          imageEnvoyer.add(tabPhoto[i]);
        }
      }
    }
  } catch (e) {
    loadingEnvoieProduit = false;
    setStating();
    messageErreurBar(context, messageErr: e.toString());
    return;
  }

  final Map<String, dynamic> mapProduit = {
    "uidBoutique": "Indéfinit pour le moment",
    "nomLocalite": "daloa",
    "positionLocalite": [6.55, 7.55],
    "nomTemporaireProduit": _nomProduitAjoutController.text,
    "prixTemporaireProduit": _prixProduitAjoutController.text,
    "taillesVentementDisponibles": listeCocherTailleVetement,
    "pointuresChaussureDisponible": listeCocherPointureChessure,
    "listeImagesTemporairesProduit": tabLien,
    "status": 0,
    "messageRefus": "",
    "dateTime": await dd(),
  };

  if (await CloudFirestore().checkConnexionFirestore()) {
    await CloudFirestore().ajoutBdd("produits", mapProduit);
    renitialisePage();
    messageErreurBar(
      context,
      messageErr: "Article ajouté",
      couleur: Colors.green,
    );
    loadingEnvoieProduit = false;

    setStating();
    return;
  } else {
    loadingEnvoieProduit = false;
    setStating();
    messageErreurBar(context, messageErr: "Vérifiez votre connection !");
    return;
  }
}

Future<DateTime> dd() async {
  try {
    DateTime heureUtc = await NTP.now();
    return heureUtc.add(DateTime.now().timeZoneOffset);
  } catch (e) {
    return DateTime.now();
  }
}

void renitialisePage() {
  _nomProduitAjoutController.text = "";
  _prixProduitAjoutController.text = "";
  imageEnvoyer = [];
  tabLien = [];
  tabPhoto = [];
  listeCocherPointureChessure = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];
  listeCocherTailleVetement = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];
}
