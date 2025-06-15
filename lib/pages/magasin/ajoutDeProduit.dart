import 'dart:io';

import 'package:flutter/material.dart';
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

class _AjoutProduitsState extends State<AjoutProduits> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text("data"))),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 35),
        child: Center(
          child: Form(
            child: Column(
              children: [
                barreDePhoto(context, () {
                  setState(() {});
                }),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Text("data"),
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
      color: const Color.fromARGB(135, 220, 184, 151),
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
              mainAxisAlignment: MainAxisAlignment.center,
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
                  icon: Icon(Icons.camera_alt, size: larg(context, ratio: 0.2)),
                ),
                const Text("Caméra"),
              ],
            ),
          ),
        ),
        SizedBox(height: long(context, ratio: 0.06)),
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
                icon: Icon(Icons.photo),
                label: Text(
                  "Galérie",
                  style: TextStyle(
                    fontSize: larg(context, ratio: 0.03),
                    //color: Colors.white,
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
                icon: Icon(Icons.link),
                label: Text(
                  "Lien",
                  style: TextStyle(
                    fontSize: larg(context, ratio: 0.03),
                    //color: Colors.white,
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

Widget barreDePhoto(BuildContext context, Function setStating) {
  return SizedBox(
    height: long(context, ratio: 0.3),
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
