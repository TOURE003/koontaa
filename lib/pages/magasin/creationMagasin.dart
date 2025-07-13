import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:koontaa/Commentaire/pageDeCommentaire.dart';
import 'package:koontaa/functions/cloud_firebase.dart';
import 'package:koontaa/functions/firebase_auth.dart';
import 'package:koontaa/functions/fonctions.dart';
import 'package:koontaa/functions/gps.dart';
import 'package:koontaa/functions/storage.dart';
import 'package:koontaa/pages/compte/connection/page_connection.dart';
import 'package:koontaa/pages/magasin/MonMagasin.dart';
import 'package:koontaa/pages/magasin/ajoutDeProduit.dart';

class CreationMagasin extends StatefulWidget {
  const CreationMagasin({super.key, required this.title});

  final String title;

  @override
  State<CreationMagasin> createState() => _CreationMagasinState();
}

final GlobalKey<FormState> _formKeyCreationNomBoutique = GlobalKey<FormState>();
final GlobalKey<FormState> _formKeyCreationQuartierPhoneMailBoutique =
    GlobalKey<FormState>();

class _CreationMagasinState extends State<CreationMagasin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(backgroundColor: couleurDeApp(nbr: 1)),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              containerPhotoBoutique(context, () {
                setState(() {});
              }),

              SizedBox(height: 30),

              Form(
                key: _formKeyCreationNomBoutique,
                child: inputFieldNomBoutique(context, () {}),
              ),
              SizedBox(height: 15),
              listeDeroulanteCategorie(context, () {}),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  h7(
                    context,
                    texte: "Localisation",
                    couleur: couleurDeApp(nbr: 1),
                    gras: true,
                  ),
                  Icon(Icons.location_on),
                ],
              ),
              inputFieldVilleLocalisation(context, () {
                setState(() {});
              }),
              SizedBox(height: 10),
              Form(
                key: _formKeyCreationQuartierPhoneMailBoutique,
                child: Column(
                  children: [
                    inputFieldNomQuartierBoutique(context, () {}),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        h7(
                          context,
                          texte: "Contact",
                          couleur: couleurDeApp(nbr: 1),
                          gras: true,
                        ),
                        Icon(Icons.phone),
                      ],
                    ),
                    inputFieldcontactBoutique(context, () {}),
                    SizedBox(height: 15),
                    inputFieldEmailBoutique(context, () {}),
                    SizedBox(height: 15),
                    bouttonValidationCreerBoutique(context, () {}),
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

Map<String, dynamic> photoBoutique = {
  "lien": "",
  "image": null,
  "message": "Création Boutique",
};
Widget containerPhotoBoutique(BuildContext context, Function setStating) {
  return Column(
    children: [
      h7(context, texte: "Logo de Ma Boutique", gras: true),
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: photoBoutique["image"] == null
              ? Color.fromARGB(255, 178, 158, 137)
              : Colors.transparent,
        ),

        //color: Colors.amber,
        width: larg(context, ratio: 0.40),
        height: long(context, ratio: 0.20),
        child: photoBoutique["image"] == null
            ? Column(
                children: [
                  Container(
                    //color: const Color.fromARGB(255, 179, 174, 158),
                    width: larg(context, ratio: 0.40),
                    height: long(context, ratio: 0.15),
                    child: IconButton(
                      onPressed: () async {
                        photoBoutique = await imageUser(camera: true);
                        setStating();
                      },
                      icon: Icon(
                        Icons.camera_alt,
                        size: long(context, ratio: 0.10),
                      ),
                    ),
                  ),
                  Container(
                    width: larg(context, ratio: 0.40),
                    height: long(context, ratio: 0.05),
                    child: IconButton(
                      onPressed: () async {
                        photoBoutique = await imageUser(camera: false);
                        setStating();
                      },
                      icon: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(Icons.photo, size: long(context, ratio: 0.035)),
                          h8(context, texte: "Galérie"),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : Center(child: imageTemporaireBoutique(context, setStating)),
      ),
    ],
  );
}

Widget imageTemporaireBoutique(BuildContext context, Function setStating) {
  return Stack(
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          child: Image.file(
            File(photoBoutique["image"].path),
            fit: BoxFit.cover,
            //width: double.infinity,
            //height: 200,
          ),
        ),
      ),
      Positioned(
        bottom: 12,
        right: 12,
        child: CircleAvatar(
          backgroundColor: Colors.red.withOpacity(0.9),
          radius: 20,
          child: IconButton(
            icon: Icon(Icons.delete, color: Colors.white, size: 20),
            onPressed: () {
              photoBoutique = {
                "lien": "",
                "image": null,
                "message": "Création Boutique",
              };
              setStating();
            },
            tooltip: "Supprimer l'image",
          ),
        ),
      ),
    ],
  );
}

TextEditingController nomBoutiqueController = TextEditingController();
Widget inputFieldNomBoutique(BuildContext context, Function setStating) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      /*Text(
        "Nom du Magasin",
        style: TextStyle(fontSize: larg(context, ratio: 0.035)),
      ),*/
      TextFormField(
        //keyboardType: TextInputType.number,
        onChanged: (value) {},
        controller: nomBoutiqueController,
        validator: (value) {
          if (value == null || value == "") {
            return "Nom de votre boutique";
          }
          if (value.length < 3) {
            return "Nom trop court";
          }
          return null;
        },

        decoration: InputDecoration(
          hint: h6(context, texte: "Nom du Magasin"),
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

List<String> categorie = [
  "Mode et Accessoires",
  "Téléphones et Tablettes",
  "Électroménager",
  "Informatique & Accessoires",
  "Beauté & Soins",
  "Alimentation",
  "Meubles & Déco",
  "Jeux & Jouets",
  "Bébés & Enfants",
  "Outils & Bricolage",
  "Véhicules & Pièces détachées",
  "Immobilier",
  "Services",
  "Livres & Éducation",
  "Sport & Loisirs",
  "Animaux",
  "Autres",
];

List iconCategorie = [
  Icon(Icons.shopping_bag, color: Colors.pinkAccent), // Mode et Accessoires
  Icon(Icons.smartphone, color: Colors.blue), // Téléphones et Tablettes
  Icon(Icons.kitchen, color: Colors.orange), // Électroménager
  Icon(Icons.computer, color: Colors.indigo), // Informatique & Accessoires
  Icon(Icons.brush, color: Colors.purple), // Beauté & Soins
  Icon(Icons.fastfood, color: Colors.green), // Alimentation
  Icon(Icons.chair, color: Colors.brown), // Meubles & Déco
  Icon(Icons.videogame_asset, color: Colors.deepPurple), // Jeux & Jouets
  Icon(Icons.child_friendly, color: Colors.amber), // Bébés & Enfants
  Icon(Icons.handyman, color: Colors.teal), // Outils & Bricolage
  Icon(Icons.directions_car, color: Colors.red), // Véhicules & Pièces détachées
  Icon(Icons.home_work, color: Colors.blueGrey), // Immobilier
  Icon(Icons.build_circle, color: Colors.cyan), // Services
  Icon(Icons.menu_book, color: Colors.deepOrange), // Livres & Éducation
  Icon(Icons.sports_soccer, color: Colors.lightGreen), // Sport & Loisirs
  Icon(Icons.pets, color: Colors.deepPurpleAccent), // Animaux
  Icon(Icons.more_horiz, color: Colors.grey), // Autres
];

String? selectedCategorie;
Widget listeDeroulanteCategorie(BuildContext context, Function setStating) {
  selectedCategorie = categorie[0];
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("Je vend:", style: TextStyle(fontSize: larg(context, ratio: 0.035))),
      DropdownButtonFormField<String>(
        value: selectedCategorie,
        isExpanded: true, // prend toute la largeur
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 16,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1.0),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFBE4A00), width: 1.5),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        icon: const Icon(Icons.arrow_drop_down),
        items: categorie.asMap().entries.map((entry) {
          int index = entry.key;
          String value = entry.value;
          return DropdownMenuItem<String>(
            value: value,
            child: Row(
              children: [
                iconCategorie[index],
                SizedBox(width: 25),
                Text(value),
              ],
            ),
          );
        }).toList(),
        onChanged: (value) {
          selectedCategorie = value;
          setStating();
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Veuillez choisir une catégorie";
          }
          return null;
        },
      ),
    ],
  );
}

//Champs de villes automatique
Widget inputFieldVilleLocalisation(BuildContext context, Function setStating) {
  return FutureBuilder<List<dynamic>>(
    future: villesBoutiqueGPS(setStating),
    builder: (context, snapshot) {
      /*if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }*/

      if (snapshot.hasError) {
        return champVilleAutocomplete(
          context: context,
          villes: villesLocales,
          onSelection: (value) {
            villeSelectionnee = value;
            setStating();
          },
          controllerInitial: TextEditingController(text: villeSelectionnee),
        );
      }

      if (!snapshot.hasData ||
          snapshot.data == null ||
          snapshot.data!.isEmpty) {
        return champVilleAutocomplete(
          context: context,
          villes: villesLocales,
          onSelection: (value) {
            villeSelectionnee = value;

            setStating();
          },
          controllerInitial: TextEditingController(text: villeSelectionnee),
        );
      }

      final listeVilleTrie = snapshot.data!;
      villeSelectionnee = listeVilleTrie[0]["ville"];

      return champVilleAutocomplete(
        context: context,
        villes: listeVilleTrie,
        onSelection: (value) {
          villeSelectionnee = value;

          setStating();
        },
        controllerInitial: TextEditingController(text: villeSelectionnee),
      );
    },
  );
}

String villeSelectionnee = "";
TextEditingController villeBoutiqueController = TextEditingController();
Widget champVilleAutocomplete({
  required BuildContext context,
  required List<dynamic> villes,
  required Function(String) onSelection,
  TextEditingController? controllerInitial,
}) {
  return Autocomplete<String>(
    optionsBuilder: (TextEditingValue textEditingValue) {
      if (textEditingValue.text.isEmpty) {
        return const Iterable<String>.empty();
      }
      return villes
          .map((v) => v['ville'].toString())
          .where(
            (nomVille) => nomVille.toLowerCase().contains(
              textEditingValue.text.toLowerCase(),
            ),
          );
    },
    onSelected: onSelection,
    fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
      // Appliquer la valeur initiale si fournie
      villeBoutiqueController = controller;
      if (controllerInitial != null && controller.text.isEmpty) {
        controller.text = controllerInitial.text;
      }

      return TextFormField(
        controller: controller,
        focusNode: focusNode,
        onEditingComplete: onEditingComplete,
        validator: (value) {
          if (value == null || value == "") {
            return "Nom de votre boutique";
          }
          if (value.length < 3) {
            return "Nom trop court";
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: "Ville",
          prefixIcon: const Icon(Icons.location_on, color: Colors.red),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.white,
        ),
      );
    },
  );
}

bool infosCompteAffiche = false;
Position? positionGps;
Future<List<dynamic>> villesBoutiqueGPS(Function setStating) async {
  /*_chargement = true;
  setStating();*/
  final Position localisation = await getCurrentPosition();
  positionGps = localisation;
  List<dynamic> listeVilleTrie = villesLocales;

  if (await CloudFirestore().checkConnexionFirestore()) {
    final lecture = await CloudFirestore().lectureUBdd(
      "localisations",
      filtreCompose: cd("idFic", "koontaaLoacalisation"),
    );
    if (lecture != null && lecture.docs.isNotEmpty) {
      final docs = lecture.docs;
      final data = docs[0].data() as Map<String, dynamic>;
      print(localisation);
      listeVilleTrie = data["villes"];
      //print(data["villes"]);
    }

    final lecture0 = await CloudFirestore().lectureUBdd(
      "users",
      idDoc: AuthFirebase().currentUser!.uid,
    );

    if (lecture0 != null && lecture0.exists) {
      final data = lecture0.data() as Map<String, dynamic>;

      if (!infosCompteAffiche) {
        nomBoutiqueController.text =
            " Boutique ${data["nom"].split(" ")[0]} Et Frères";
        contactBoutiqueController.text = data["phone"] ?? "";
        emailBoutiqueController.text = data["mail"] ?? "";
        infosCompteAffiche = true;
      }
    }
  }

  listeVilleTrie = trierVillesParProximite(
    villes: listeVilleTrie,
    villeReference: {
      "lng": localisation.longitude,
      "lat": localisation.latitude,
    },
  );

  // print(listeVilleTrie);
  /*_chargement = false;
  setStating();*/
  return listeVilleTrie;
}

final List<Map<String, dynamic>> villesLocales = [
  {'ville': 'Abidjan', 'lat': '5,3364', 'lng': '-4,0267'},
  {'ville': 'Yopougon', 'lat': '5,3748', 'lng': '-4,0867'},
  {'ville': 'Bouaké', 'lat': '7,6833', 'lng': '-5,0331'},
  {'ville': 'Cocody', 'lat': '5,3351', 'lng': '-4,0039'},
  {'ville': 'Port-Bouët', 'lat': '5,2568', 'lng': '-3,963'},
  {'ville': 'Korhogo', 'lat': '9,4578', 'lng': '-5,6294'},
  {'ville': 'Daloa', 'lat': '6,89', 'lng': '-6,45'},
  {'ville': 'Koumassi', 'lat': '5,2972', 'lng': '-3,9675'},
  {'ville': 'San-Pédro', 'lat': '4,7704', 'lng': '-6,64'},
  {'ville': 'Yamoussoukro', 'lat': '6,8161', 'lng': '-5,2742'},
  {'ville': 'Attiecoubé', 'lat': '5,3453', 'lng': '-4,035'},
  {'ville': 'Divo', 'lat': '5,8372', 'lng': '-5,3572'},
  {'ville': 'Gagnoa', 'lat': '6,1333', 'lng': '-5,9333'},
  {'ville': 'Soubré', 'lat': '5,7836', 'lng': '-6,5939'},
  {'ville': 'Man', 'lat': '7,4004', 'lng': '-7,55'},
  {'ville': 'Duekoué', 'lat': '6,7419', 'lng': '-7,3492'},
  {'ville': 'Marcory', 'lat': '5,312', 'lng': '-3,9936'},
  {'ville': 'Bouaflé', 'lat': '6,9903', 'lng': '-5,7442'},
  {'ville': 'Bingerville', 'lat': '5,35', 'lng': '-3,9'},
  {'ville': 'Guiglo', 'lat': '6,5436', 'lng': '-7,4933'},
  {'ville': 'Abengourou', 'lat': '6,7297', 'lng': '-3,4964'},
  {'ville': 'Ferkessédougou', 'lat': '9,5928', 'lng': '-5,1944'},
  {'ville': 'Adzopé', 'lat': '6,1035', 'lng': '-3,8648'},
  {'ville': 'Bondoukou', 'lat': '8,0304', 'lng': '-2,8'},
  {'ville': 'Dabou', 'lat': '5,3256', 'lng': '-4,3767'},
  {'ville': 'Sinfra', 'lat': '6,621', 'lng': '-5,9114'},
  {'ville': 'Agboville', 'lat': '5,9333', 'lng': '-4,2167'},
  {'ville': 'Oumé', 'lat': '6,3833', 'lng': '-5,4167'},
  {'ville': 'Grand-Bassam', 'lat': '5,2', 'lng': '-3,7333'},
  {'ville': 'Séguéla', 'lat': '7,9611', 'lng': '-6,6731'},
  {'ville': 'Daoukro', 'lat': '7,0586', 'lng': '-3,9646'},
  {'ville': 'Aboisso', 'lat': '5,4667', 'lng': '-3,2'},
  {'ville': 'Bouna', 'lat': '9,2667', 'lng': '-3'},
  {'ville': 'Boundiali', 'lat': '9,5167', 'lng': '-6,4833'},
  {'ville': 'Katiola', 'lat': '8,1333', 'lng': '-5,1'},
  {'ville': 'Sassandra', 'lat': '4,9504', 'lng': '-6,0833'},
  {'ville': 'Odienné', 'lat': '9,5', 'lng': '-7,5667'},
  {'ville': 'Dabakala', 'lat': '8,3667', 'lng': '-4,4333'},
  {'ville': 'Bongouanou', 'lat': '6,6517', 'lng': '-4,2041'},
  {'ville': 'Mankono', 'lat': '8,0586', 'lng': '-6,1897'},
  {'ville': 'Biankouma', 'lat': '7,7333', 'lng': '-7,6167'},
  {'ville': 'Dimbokro', 'lat': '6,6505', 'lng': '-4,71'},
  {'ville': 'Touba', 'lat': '8,2833', 'lng': '-7,6833'},
  {'ville': 'Jacqueville', 'lat': '5,2', 'lng': '-4,4167'},
  {'ville': 'Toumodi', 'lat': '6,552', 'lng': '-5,019'},
  {'ville': 'Toumoukro', 'lat': '10,3833', 'lng': '-5,75'},
  {'ville': 'Kong', 'lat': '9,1506', 'lng': '-4,6103'},
  {'ville': 'Rubino', 'lat': '6,0692', 'lng': '-4,3086'},
  {'ville': 'Bin-Houyé', 'lat': '6,7825', 'lng': '-8,3163'},
  {'ville': 'Grand-Lahou', 'lat': '5,1333', 'lng': '-5,0167'},
  {'ville': 'Noé', 'lat': '5,2833', 'lng': '-2,8'},
  {'ville': 'Bonoufla', 'lat': '7,1291', 'lng': '-6,4742'},
  {'ville': 'Sipilou', 'lat': '7,8667', 'lng': '-8,1'},
  {'ville': 'Zaliohouan', 'lat': '6,7952', 'lng': '-6,2355'},
  {'ville': 'Yabayo', 'lat': '5,9388', 'lng': '-6,5983'},
  {'ville': 'Luénoufla', 'lat': '7,0724', 'lng': '-6,2413'},
  {'ville': 'Mabéhiri', 'lat': '5,6667', 'lng': '-6,4167'},
  {'ville': 'Para', 'lat': '5,5196', 'lng': '-7,3275'},
  {'ville': 'Bédigoazon', 'lat': '6,5663', 'lng': '-7,7204'},
  {'ville': 'Brofodoumé', 'lat': '5,5136', 'lng': '-3,9307'},
  {'ville': 'Ahigbé Koffikro', 'lat': '5,4075', 'lng': '-3,3802'},
  {'ville': 'Doukouya', 'lat': '6,4262', 'lng': '-5,5592'},
  {'ville': 'Minignan', 'lat': '9,9974', 'lng': '-7,8359'},
  {'ville': 'Pélézi', 'lat': '7,2817', 'lng': '-6,8145'},
  {'ville': 'Mignouré', 'lat': '7,4875', 'lng': '-6,7882'},
  {'ville': 'Papara', 'lat': '10,6167', 'lng': '-6,25'},
  {'ville': 'Bonon', 'lat': "7.546855 ", 'lng': "-5.5471"},
];
//----------------------------------------------------------------------------------------------

TextEditingController nomQuartierBoutiqueController = TextEditingController();
Widget inputFieldNomQuartierBoutique(
  BuildContext context,
  Function setStating,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      /*Text(
        "Nom du Magasin",
        style: TextStyle(fontSize: larg(context, ratio: 0.035)),
      ),*/
      TextFormField(
        //keyboardType: TextInputType.number,
        onChanged: (value) {},
        controller: nomQuartierBoutiqueController,
        validator: (value) {
          if (value == null || value == "") {
            return "Ajoutez votre quartier";
          }
          if (value.length < 3) {
            return "Nom trop court";
          }
          return null;
        },

        decoration: InputDecoration(
          hint: h6(context, texte: "Quartier ou adrèsse"),
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

TextEditingController contactBoutiqueController = TextEditingController();
Widget inputFieldcontactBoutique(BuildContext context, Function setStating) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      /*Text(
        "Nom du Magasin",
        style: TextStyle(fontSize: larg(context, ratio: 0.035)),
      ),*/
      TextFormField(
        keyboardType: TextInputType.number,
        onChanged: (value) {},
        controller: contactBoutiqueController,
        validator: (value) {
          final phoneRegex = RegExp(r'^(0[0-9]{9}|\+225[0-9]{10})$');
          if (value == null || value == "") {
            return "Contact de la boutique obligatoir";
          }
          if (!phoneRegex.hasMatch(value)) {
            return "Vérifiez le numéro";
          }
          return null;
        },

        decoration: InputDecoration(
          //hint: h6(context, texte: "Quartier"),
          label: h6(context, texte: "Téléphone"),
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

TextEditingController emailBoutiqueController = TextEditingController();
Widget inputFieldEmailBoutique(BuildContext context, Function setStating) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      /*Text(
        "Nom du Magasin",
        style: TextStyle(fontSize: larg(context, ratio: 0.035)),
      ),*/
      TextFormField(
        keyboardType: TextInputType.emailAddress,
        onChanged: (value) {},
        controller: emailBoutiqueController,
        validator: (value) {
          final emailRegex = RegExp(r"^[\w\.-]+@[\w\.-]+\.\w+$");
          if (value == null || value == "") {
            return null;
          }
          if (!emailRegex.hasMatch(value)) {
            return "Vérifiez votre mail";
          }
          return null;
        },

        decoration: InputDecoration(
          //hint: h6(context, texte: "Quartier"),
          label: h6(context, texte: "Adrèsse Mail"),
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

bool _chargement = false;
Widget bouttonValidationCreerBoutique(
  BuildContext context,
  Function setStating,
) {
  return SizedBox(
    width: double.infinity, // prend toute la largeur disponible
    child: ElevatedButton(
      onPressed: _chargement
          ? null
          : () async {
              _chargement = true;
              setStating();
              if (_formKeyCreationNomBoutique.currentState!.validate() &&
                  _formKeyCreationQuartierPhoneMailBoutique.currentState!
                      .validate()) {
                if (photoBoutique["image"] == null) {
                  messageErreurBar(
                    context,
                    messageErr: "Ajoutez une Photo de votre boutique!",
                    couleur: Colors.green,
                  );
                  _chargement = false;
                  setStating();
                } else {
                  final String lienImage = await envoieImage(
                    photoBoutique["image"],
                  );
                  if (lienImage != "err-file" && lienImage != "annule-file") {
                    final Map<String, dynamic> donnees = {
                      "idUser": AuthFirebase().currentUser != null
                          ? AuthFirebase().currentUser!.uid
                          : "inconnu",
                      "status": 0,
                      "lienLogo": lienImage,
                      "nomBoutique": nomBoutiqueController.text,
                      "categoriePrincipal": selectedCategorie ?? "Iconnu",
                      "nomVille": villeBoutiqueController.text,
                      "nomQuartier": nomQuartierBoutiqueController.text,
                      "gpsLat": positionGps != null
                          ? positionGps!.latitude
                          : 0.0,
                      "gpsLng": positionGps != null
                          ? positionGps!.longitude
                          : 0.0,

                      "phone": contactBoutiqueController.text,
                      "mail": emailBoutiqueController.text,
                      "dateTime": await dd(),
                    };
                    final idBoutique = genererCodeAleatoire();
                    final res = await CloudFirestore().ajoutBdd(
                      "boutiques",
                      donnees,
                      uid: idBoutique,
                    );
                    _chargement = false;
                    setStating();
                    if (res) {
                      changePage(
                        context,
                        MonMagasin(
                          title: "Aficher Magasin",
                          idBoutique: idBoutique,
                        ),
                      );
                    }
                  } else {
                    messageErreurBar(
                      context,
                      messageErr: "Erreur-Vérifiez votre connection",
                    );
                    _chargement = false;
                    setStating();
                  }
                }
              }
            },
      style: ElevatedButton.styleFrom(
        elevation: 0, // pas d’ombre
        backgroundColor: Color(0xffBE4A00), // ou toute autre couleur sauf rouge
        foregroundColor: Colors.white, // couleur du texte/icône
        padding: EdgeInsets.symmetric(vertical: 16), // hauteur du bouton
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // coins arrondis optionnels
        ),
      ),
      child: !_chargement ? Text("Créez ma Boutique") : circular(message: ""),
    ),
  );
}
