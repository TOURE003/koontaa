//import 'dart:io';
import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:koontaa/functions/cloud_firebase.dart';
import 'package:koontaa/functions/firebase_auth.dart';
import 'package:koontaa/functions/fonctions.dart';
import 'package:pinput/pinput.dart';

class PageConnection extends StatefulWidget {
  const PageConnection({super.key, required this.title});

  final String title;

  @override
  State<PageConnection> createState() => _PageConnectionState();
}

int _indexPage = 0;

class _PageConnectionState extends State<PageConnection> {
  @override
  Widget build(BuildContext context) {
    List<Widget> pagesConnectionEtCompte = [
      bodyPageConnectionConnection(() {
        setState(() {});
      }, context),
      bodyPageCreationDeCpmte(() {
        try {
          setState(() {});
        } catch (e) {}
      }, context),
      bodyPageConfirmationOTP(() {
        setState(() {});
      }, context),
      bodyPageConfirmationEmail(() {
        setState(() {});
      }, context),

      bodyPageConfirmationOTP(() {
        setState(() {});
      }, context),

      bodyPageMotDePasseOUblie(() {
        setState(() {});
      }, context),
    ];

    return Scaffold(
      backgroundColor: couleurDeApp(),
      appBar: appBarConnection(() {
        setState(() {});
      }, indexPageCible: _indexPage),
      body:
          pagesConnectionEtCompte[_indexPage], //bodyPageConnectionConnection(() {setState(() {});}, context),
    );
  }
}

PreferredSizeWidget appBarConnection(
  Function setSteting, {
  int indexPageCible = 0,
}) {
  return PreferredSize(
    preferredSize: Size.fromHeight(30),
    child: AppBar(
      backgroundColor: couleurDeApp(),
      automaticallyImplyLeading: indexPageCible == 0,
      title: indexPageCible == 0
          ? SizedBox()
          : IconButton(
              onPressed:
                  (compteVar != 60 &&
                      (indexPageCible == 4 ||
                          indexPageCible == 2 ||
                          indexPageCible == 3))
                  ? null
                  : () {
                      _indexPage = 0;
                      setSteting();
                      /*if (indexPageCible == 1 || indexPageCible == 2) {
                        _indexPage = indexPageCible - 1;
                        setSteting();
                      } else if (indexPageCible == 3) {
                        _indexPage = 1;
                        setSteting();
                      } else if (indexPageCible == 4) {
                        _indexPage = 0;
                        setSteting();
                      }*/
                    },
              icon: Icon(Icons.close),
            ),
    ),
  );
}

final GlobalKey<FormState> _formKeyCreationCompte = GlobalKey<FormState>();

Widget bodyPageCreationDeCpmte(Function setStating, BuildContext context) {
  return SingleChildScrollView(
    padding: EdgeInsets.symmetric(horizontal: 35),
    child: Center(
      child: Form(
        key: _formKeyCreationCompte,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/images/band3.PNG", height: 210),
            SizedBox(height: 5),
            SizedBox(
              child: Text("Créer un compte !", style: TextStyle(fontSize: 35)),
            ),
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Créer un compte  ou"),
                  TextButton(
                    onPressed: () {
                      _indexPage = 0;
                      setStating();
                    },
                    child: Text(
                      "Cliquez ici si vous avez déjà un compte !",
                      style: TextStyle(
                        color: Color(0xffBE4A00),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            inputFieldNomEtPrenomCreationCompte(),
            SizedBox(height: 20),
            inputFieldEmailPhone(() {
              setStating;
            }),
            SizedBox(height: 20),
            inputFieldMotDPasse(
              messageErr: "Le mot de passe doit conténir au moin 4 caractères.",
            ),
            SizedBox(height: 20),
            inputFieldMotDPasseConfirmation(),
            SizedBox(height: 10),
            //genreSelect(setStating),
            //ageSelect(setStating),
            SizedBox(height: 35),
            bouttonValidationCreerCompte(
              setStating,
              context,
              _formKeyCreationCompte,
            ),
          ],
        ),
      ),
    ),
  );
}

final TextEditingController _nomEtPrenomCreationCompteController =
    TextEditingController();
Widget inputFieldNomEtPrenomCreationCompte() {
  return TextFormField(
    controller: _nomEtPrenomCreationCompteController,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Ce champ est requis';
      }
      final emailRegex = RegExp(
        r"^[A-Za-zÀ-ÖØ-öø-ÿ]+([ '-][A-Za-zÀ-ÖØ-öø-ÿ]+)+$",
      );
      if (!emailRegex.hasMatch(value)) {
        return "Le nom saisi n'est pas valide";
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
      label: Text("Nom complet", style: TextStyle(fontSize: 20)),
      border: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
      ),
    ),
  );
}

final TextEditingController _motDePasseConfirmationController =
    TextEditingController();
Widget inputFieldMotDPasseConfirmation() {
  return TextFormField(
    controller: _motDePasseConfirmationController,
    validator: (value) {
      if ((value == null || value.isEmpty) &
          _motDePasseConnectionController.text.isNotEmpty) {
        return 'Confirmez le mot de passe';
      }

      if (value != _motDePasseConnectionController.text &&
          _motDePasseConnectionController.text.isNotEmpty) {
        return 'Les mots de passes ne correspondent pas !';
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
      label: Text("Confirmez le mot de passe", style: TextStyle(fontSize: 20)),
      border: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
      ),
    ),
  );
}

String? genreSelectionne = "0";
Widget genreSelect(Function setStating) {
  return Row(
    children: [
      Expanded(
        child: RadioListTile(
          value: "0",
          title: Text("Homme"),
          groupValue: genreSelectionne,
          onChanged: (value) {
            genreSelectionne = value;
            setStating();
          },
        ),
      ),
      Expanded(
        child: RadioListTile(
          value: "1",
          title: Text("Femme"),
          groupValue: genreSelectionne,
          onChanged: (value) {
            genreSelectionne = value;
            setStating();
          },
        ),
      ),
    ],
  );
}

String? ageSelectionne = "3";
Widget ageSelect(Function setStating) {
  return Row(
    children: [
      Expanded(
        child: RadioListTile(
          value: "1",
          title: Text("Moin de 18 ans"),
          groupValue: ageSelectionne,
          onChanged: (value) {
            ageSelectionne = value;
            setStating();
          },
        ),
      ),
      Expanded(
        child: RadioListTile(
          value: "2",
          title: Text("Plus de 18 ans"),
          groupValue: ageSelectionne,
          onChanged: (value) {
            ageSelectionne = value;
            setStating();
          },
        ),
      ),
      Expanded(
        child: RadioListTile(
          value: "3",
          title: Text("Plus de 30 ans"),
          groupValue: ageSelectionne,
          onChanged: (value) {
            ageSelectionne = value;
            setStating();
          },
        ),
      ),
    ],
  );
}

bool loadingBouttonCreation = false;
Widget bouttonValidationCreerCompte(
  Function setStating,
  BuildContext context,
  GlobalKey<FormState> cleForm,
) {
  return SizedBox(
    width: double.infinity, // prend toute la largeur disponible
    child: ElevatedButton(
      onPressed: loadingBouttonCreation
          ? null
          : () async {
              String numeroAjuste = ajouterIndicatifSiManquant(
                _emailPhoneConnectionController.text,
              );
              if (cleForm.currentState!.validate()) {
                loadingBouttonCreation = true;
                setStating();
                final phoneRegex = RegExp(r'^(0[0-9]{9}|\+225[0-9]{10})$');
                final emailRegex = RegExp(
                  r'^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})$',
                );
                if (phoneRegex.hasMatch(_emailPhoneConnectionController.text)) {
                  final bdd = await CloudFirestore().lectureUBdd(
                    "users",
                    filtreCompose: cd(
                      "phone",
                      ajouterIndicatifSiManquant(
                        _emailPhoneConnectionController.text,
                      ),
                    ),
                  );

                  if (bdd!.docs.isNotEmpty) {
                    final docs = bdd.docs;
                    final data = docs[0].data() as Map<String, dynamic>;
                    if (!data["phone_verifie"]) {
                      AuthFirebase().envoyerCodeSMS(
                        numeroAjuste,
                        () async {
                          await CloudFirestore().modif(
                            "users",
                            bdd.docs[0].id,
                            {
                              "nom": _nomEtPrenomCreationCompteController.text,
                              "phone": numeroAjuste,
                              "motDePasse": _motDePasseConnectionController,
                            },
                          );
                          loadingBouttonCreation = false;
                          _indexPage = 2;
                          compterAvecDelai(setStating, 60);
                          setStating();
                        },
                        () {
                          messageErreurBar(context);
                        },
                      );
                      return;
                    }
                    messageErreurBar(
                      context,
                      messageErr: "Numéro déjà utilisé!",
                    );
                    loadingBouttonCreation = false;
                    setStating();
                    return;
                  }

                  await AuthFirebase().envoyerCodeSMS(
                    numeroAjuste,
                    () async {
                      if (await CloudFirestore().checkConnexionFirestore()) {
                        await CloudFirestore().ajoutBdd("users", {
                          "nom": _nomEtPrenomCreationCompteController.text,
                          "phone": numeroAjuste,
                          "phone_verifie": false,
                          "motDePasse": _motDePasseConnectionController.text,
                          "methode": "phone",
                        });
                      } else {
                        messageErreurBar(
                          context,
                          messageErr: "Pas de connection !",
                        );
                      }
                      loadingBouttonCreation = false;
                      _indexPage = 2;
                      compterAvecDelai(setStating, 60);
                      setStating();
                    },
                    (e) {
                      loadingBouttonCreation = false;
                      setStating();
                      messageErreurBar(
                        context,
                        messageErr: e.code == "network-request-failed"
                            ? "Vérifiez votre connection internet."
                            : "Une erreur est survénue.  ${e.code}",
                      );
                    },
                  );
                } else if (emailRegex.hasMatch(
                  _emailPhoneConnectionController.text,
                )) {
                  AuthFirebase().createUserWithPassword(
                    _emailPhoneConnectionController.text,
                    _motDePasseConfirmationController.text,
                    () async {
                      await CloudFirestore().ajoutBdd(
                        "users",
                        uid: AuthFirebase().currentUser!.uid,
                        {
                          "nom": _nomEtPrenomCreationCompteController.text,
                          "mail": _emailPhoneConnectionController.text,
                          "motDePasse": _motDePasseConfirmationController.text,
                          "methode": "mail",
                        },
                      );
                      AuthFirebase().logout(decon: false);
                      _indexPage = 3;
                      loadingBouttonCreation = false;
                      compterAvecDelai(setStating, 60);
                      setStating();
                    },
                    (e) {
                      loadingBouttonCreation = false;
                      setStating();

                      String messageErreur = "Erreur de connection";
                      if (e.code == "email-already-in-use") {
                        messageErreur =
                            "Cette adrèsse mail est déjé utilisé pour un autre compte !";
                      }

                      messageErreurBar(context, messageErr: messageErreur);
                    },
                    decon: false,
                  );
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
      child: loadingBouttonCreation
          ? circular(message: "Création...")
          : Text("Créez le compte"),
    ),
  );
}

// Creation de Widget page de création de compte------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------------------------------
final GlobalKey<FormState> _formKeyConnection = GlobalKey<FormState>();
//final _emailController = TextEditingController();

Widget bodyPageConnectionConnection(Function setStating, BuildContext context) {
  return SingleChildScrollView(
    padding: EdgeInsets.symmetric(horizontal: 35),
    child: Center(
      child: Form(
        key: _formKeyConnection,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/images/band3.PNG", height: 200),
            SizedBox(height: 16),
            SizedBox(
              child: Text("Connexion !", style: TextStyle(fontSize: 35)),
            ),
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Connectez vous  ou"),
                  TextButton(
                    onPressed: () {
                      _indexPage = 1;
                      setStating();
                    },
                    child: Text(
                      "Cliquez ici pour créer un compte",
                      style: TextStyle(
                        color: Color(0xffBE4A00),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5),
            inputFieldEmailPhone(setStating),
            SizedBox(height: 20),
            inputFieldMotDPasse(),
            SizedBox(height: 20),
            bouttonValidationSeConnecter(
              setStating,
              context,
              _formKeyConnection,
            ),
            SizedBox(height: 6),
            TextButton(
              onPressed: () {
                _indexPage = 5;
                setStating();
              },
              child: const Text(
                "Mot de passe oublié ?",
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
            bouttonContinueAvecApple(setStating, context),
            SizedBox(height: 10),
            bouttonContinueAvecGoogle(setStating, context),
            SizedBox(height: 10),
            bouttonContinueAvecFaceBook(setStating, context),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Vous n'avez pas de compte ?"),
                TextButton(
                  onPressed: () {
                    _indexPage = 1;
                    setStating();
                  },
                  child: Text(
                    "Cliquez ici pour créer un compte",
                    style: TextStyle(
                      color: Color(0xffBE4A00),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

final TextEditingController _emailPhoneConnectionController =
    TextEditingController();
bool motDePasseDesactive = false;
Widget inputFieldEmailPhone(
  Function setStating, {
  String hiden = "Téléphone ou Adresse Mail! ",
}) {
  return TextFormField(
    onChanged: (value) {
      final phoneRegex = RegExp(r'^(0[0-9]{9}|\+225[0-9]{10})$');
      if (phoneRegex.hasMatch(value)) {
        motDePasseDesactive = true;

        setStating();
        return;
      }
      motDePasseDesactive = false;

      setStating();
    },
    controller: _emailPhoneConnectionController,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Ce champ est requis';
      }
      final emailRegex = RegExp(
        r'^(([\w-\.]+@([\w-]+\.)+[\w-]{2,4})|(0[0-9]{9}|\+225[0-9]{10}))$',
      );
      if (!emailRegex.hasMatch(value)) {
        return 'Adresse email ou Numéro de téléphone Invalide.';
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
      label: Text(hiden, style: TextStyle(fontSize: 20)),
      border: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
      ),
    ),
  );
}

final TextEditingController _motDePasseConnectionController =
    TextEditingController();
Widget inputFieldMotDPasse({String messageErr = "Mot de passe Incorrect !"}) {
  return TextFormField(
    enabled: !motDePasseDesactive,
    controller: _motDePasseConnectionController,
    validator: (value) {
      if (motDePasseDesactive) {
        return null;
      }

      if (value == null || value.isEmpty) {
        return 'Veuillez entrer un mot de passe';
      }

      final passwordRegex = RegExp(r'^.{4,}$');

      if (!passwordRegex.hasMatch(value)) {
        return messageErr;
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
      label: Text("Mot de passe", style: TextStyle(fontSize: 20)),
      border: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
      ),
    ),
  );
}

bool _lesBouttonsSontActive = true;
bool circularBoutton1 = false;
bool circularBoutton2 = false;
bool circularBoutton3 = false;
bool circularBoutton4 = false;
Widget bouttonValidationSeConnecter(
  Function setStating,
  BuildContext context,
  GlobalKey<FormState> cleForm,
) {
  return SizedBox(
    width: double.infinity, // prend toute la largeur disponible
    child: ElevatedButton(
      onPressed: !_lesBouttonsSontActive
          ? null
          : () async {
              if (_formKeyConnection.currentState!.validate()) {
                _lesBouttonsSontActive = false;
                circularBoutton1 = true;
                setStating();
                final emailRegex = RegExp(
                  r'^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})$',
                );

                final phoneRegex = RegExp(r'^(0[0-9]{9}|\+225[0-9]{10})$');

                if (emailRegex.hasMatch(_emailPhoneConnectionController.text)) {
                  final etatConnection = await _connectionAvecMail(
                    context,
                    _emailPhoneConnectionController.text,
                    _motDePasseConnectionController.text,
                  );

                  if (etatConnection) {
                    if (!AuthFirebase().currentUser!.emailVerified) {
                      _lesBouttonsSontActive = true;
                      circularBoutton1 = false;
                      _indexPage = 3;

                      await AuthFirebase().currentUser!.sendEmailVerification();
                      AuthFirebase().logout();
                      compterAvecDelai(setStating, 60);
                      setStating();
                      return;
                    }

                    _lesBouttonsSontActive = true;
                    circularBoutton1 = false;
                    setStating();
                    Navigator.pop(context);
                    return;
                  }

                  _lesBouttonsSontActive = true;
                  circularBoutton1 = false;
                  setStating();
                } else if (phoneRegex.hasMatch(
                  _emailPhoneConnectionController.text,
                )) {
                  //try {
                  CloudFirestore bdd = CloudFirestore();
                  if (!await bdd.checkConnexionFirestore()) {
                    _lesBouttonsSontActive = true;
                    circularBoutton1 = false;
                    setStating();

                    messageErreurBar(
                      context,
                      messageErr: "Vérifiez votre connection internet !",
                    );
                    return;
                  }

                  final bdd0 = await bdd.lectureUBdd(
                    "users",
                    filtreCompose: cd(
                      "phone",
                      ajouterIndicatifSiManquant(
                        _emailPhoneConnectionController.text,
                      ),
                    ),
                  );

                  if (bdd0!.docs.isEmpty) {
                    _lesBouttonsSontActive = true;
                    circularBoutton1 = false;
                    setStating();
                    messageErreurBar(
                      context,
                      messageErr: "Numéro associé à aucun compte !",
                    );
                    return;
                  }

                  await AuthFirebase().envoyerCodeSMS(
                    ajouterIndicatifSiManquant(
                      _emailPhoneConnectionController.text,
                    ),
                    () {
                      _lesBouttonsSontActive = true;
                      creationCompte = true;
                      circularBoutton1 = false;
                      _indexPage = 4;
                      compterAvecDelai(setStating, 60);
                      setStating();
                      return;
                    },
                    () {
                      _lesBouttonsSontActive = true;
                      circularBoutton1 = false;
                      messageErreurBar(
                        context,
                        messageErr:
                            "Nous n'avons pas peu vérifier votre numéro !",
                      );
                      setStating();
                      return;
                    },
                  );
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
      child: !_lesBouttonsSontActive && circularBoutton1
          ? circular()
          : Text("Se connecter"),
    ),
  );
}

_connectionAvecMail(BuildContext context, adress, motDePasse) async {
  try {
    await AuthFirebase().loginWithEmailAndPassword(adress, motDePasse);
    return true;
  } on FirebaseAuthException catch (e) {
    if (e.code == "invalid-credential") {
      messageErreurBar(
        context,
        messageErr: "Adrèsse Mail ou mot de passe incorrecte !",
      );
    } else {
      messageErreurBar(
        context,
        messageErr: "Veifiez votre connection internet !",
      );
    }
    return false;
  }
}

Widget bouttonContinueAvecGoogle(Function setSeting, BuildContext context) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton.icon(
      onPressed: !_lesBouttonsSontActive
          ? null
          : () async {
              _lesBouttonsSontActive = false;
              circularBoutton2 = true;
              setSeting();
              try {
                await AuthFirebase().signInWithGoogle();
                User? auth = AuthFirebase().currentUser;

                dynamic bdd = await CloudFirestore().lectureUBdd(
                  "users",
                  idDoc: auth!.uid,
                );

                if (bdd != null && bdd is DocumentSnapshot) {
                  final data = bdd.data() as Map<String, dynamic>;
                  final phoneRegex = RegExp(r'^(0[0-9]{9}|\+225[0-9]{10})$');
                  Map<String, dynamic> donne;
                  if (data.containsKey('phone')) {
                    if (phoneRegex.hasMatch(data["phone"])) {
                      donne = {"mail": auth.email, "nom": auth.displayName};
                    } else {
                      donne = {
                        "mail": auth.email,
                        "nom": auth.displayName,
                        "phone": auth.phoneNumber,
                      };
                    }
                  } else {
                    donne = {
                      "mail": auth.email,
                      "nom": auth.displayName,
                      "phone": auth.phoneNumber,
                    };
                  }

                  CloudFirestore().modif("users", auth.uid, donne);
                } else {
                  CloudFirestore().ajoutBdd("users", uid: auth.uid, {
                    "nom": auth.displayName,
                    "mail": auth.email,
                    "phone": auth.phoneNumber ?? "",
                    "methode": "google",
                  });
                }

                //AuthFirebase().currentUser.nam
                _lesBouttonsSontActive = true;
                setSeting();
                Navigator.pop(context);
              } catch (e) {
                _lesBouttonsSontActive = true;
                setSeting();
                messageErreurBar(
                  context,
                  messageErr: "Erreur lors de la connexion avec Google : $e",
                );
              }
              circularBoutton2 = false;
              setSeting();
            },
      style: ElevatedButton.styleFrom(
        elevation: 0, //
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // coins arrondis
        ),
      ),
      label: !_lesBouttonsSontActive && circularBoutton2
          ? circular()
          : Text("    Continuer avec Google", style: TextStyle(fontSize: 18)),
      icon: Image.asset("assets/images/logo_google.jpg", width: 30),
    ),
  );
}

Widget bouttonContinueAvecApple(Function setStating, BuildContext context) {
  return (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS)
      ? SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              elevation: 0, //
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // coins arrondis
              ),
            ),
            label: Text(
              "   Continuer avec Apple    ",
              style: TextStyle(fontSize: 18),
            ),
            icon: Image.asset("assets/images/logo_apple.png", width: 25),
          ),
        )
      : SizedBox();
}

Widget bouttonContinueAvecFaceBook(Function setStating, BuildContext context) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton.icon(
      onPressed: !_lesBouttonsSontActive
          ? null
          : () async {
              try {
                _lesBouttonsSontActive = false;
                circularBoutton4 = true;
                setStating();
                await AuthFirebase().signInWithFacebook();

                User? auth = AuthFirebase().currentUser;

                dynamic bdd = await CloudFirestore().lectureUBdd(
                  "users",
                  idDoc: auth!.uid,
                );

                if (bdd != null && bdd is DocumentSnapshot) {
                  final data = bdd.data() as Map<String, dynamic>;
                  final phoneRegex = RegExp(r'^(0[0-9]{9}|\+225[0-9]{10})$');
                  final emailRegex = RegExp(r"^[\w\.-]+@[\w\.-]+\.\w+$");
                  Map<String, dynamic> donne;
                  if (data.containsKey('phone')) {
                    if (phoneRegex.hasMatch(data["phone"])) {
                      donne = {"nom": auth.displayName};
                    } else {
                      donne = {
                        "nom": auth.displayName,
                        "phone": auth.phoneNumber,
                      };
                    }
                  } else {
                    donne = {
                      "nom": auth.displayName,
                      "phone": auth.phoneNumber,
                    };
                  }

                  if (data.containsKey('mail')) {
                    if (emailRegex.hasMatch(data["mail"])) {
                    } else {
                      donne["mail"] = auth.email;
                    }
                  }

                  CloudFirestore().modif("users", auth.uid, donne);
                } else {
                  CloudFirestore().ajoutBdd("users", uid: auth.uid, {
                    "nom": auth.displayName,
                    "mail": auth.email,
                    "phone": auth.phoneNumber ?? "",
                    "methode": "facebook",
                  });
                }

                _lesBouttonsSontActive = true;
                setStating();
                Navigator.pop(context);
              } catch (e) {
                _lesBouttonsSontActive = true;
                setStating();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Erreur lors de la connexion avec FaceBook : $e",
                    ),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.red,
                    showCloseIcon: true,
                  ),
                );
              }
              circularBoutton4 = false;
            },
      style: ElevatedButton.styleFrom(
        elevation: 0, //
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // coins arrondis
        ),
      ),
      label: !_lesBouttonsSontActive && circularBoutton4
          ? circular()
          : Text("Continuer avec Facebook", style: TextStyle(fontSize: 18)),
      icon: Image.asset("assets/images/logo_facebook.jpg", width: 30),
    ),
  );
}

Widget circular({String message = "Connexion..."}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Color(0xffBE4A00),
        ),
      ),
      const SizedBox(width: 10),
      Text(
        message,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    ],
  );
}

void messageErreurBar(
  BuildContext context, {
  String messageErr = "Une erreur s'est produit",
  Color couleur = Colors.red,
}) {
  try {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(messageErr),
        behavior: SnackBarBehavior.floating,
        backgroundColor: couleur,
        showCloseIcon: true,
      ),
    );
  } catch (e) {}
}
//Widget de confirmation otp-------------------------------------------------------------
//---------------------------------------------------------------------------------------

int compteVar = 60;
Future<void> compterAvecDelai(Function setStating, int max) async {
  for (int i = 0; i <= max; i++) {
    await Future.delayed(Duration(seconds: 1));
    print("Compte : $i");
    compteVar = i;
    try {
      setStating();
    } catch (e) {}
  }
}

final GlobalKey<FormState> _formKeyOTPVerification = GlobalKey<FormState>();
Widget bodyPageConfirmationOTP(Function setStating, BuildContext context) {
  return SingleChildScrollView(
    padding: EdgeInsets.symmetric(horizontal: 35),
    child: Center(
      child: Form(
        key: _formKeyOTPVerification,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/images/band3.PNG", height: 200),
            SizedBox(height: 16),
            SizedBox(
              child: Text("Entrez le code !", style: TextStyle(fontSize: 35)),
            ),
            SizedBox(height: 25),
            SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Entrez le code que nous vous avons envoyer"),
                  Text(" par sms s'il vous plat !"),
                  SizedBox(height: 20),
                  Text(_emailPhoneConnectionController.text),
                ],
              ),
            ),

            SizedBox(height: 20),
            buildOtpField(context, setStating),

            SizedBox(height: 20),
            bouttonValidationOTP(setStating, context, _formKeyConnection),
            SizedBox(height: 6),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Vous n'avez pas reussi le code? "),
                TextButton(
                  onPressed: compteVar != 60
                      ? null
                      : () {
                          AuthFirebase().envoyerCodeSMS(
                            ajouterIndicatifSiManquant(
                              _emailPhoneConnectionController.text,
                            ),
                            () {
                              compterAvecDelai(setStating, 60);
                            },
                            () {
                              messageErreurBar(
                                context,
                                messageErr: "Impossible d'envoyer le méssage",
                              );
                            },
                          );
                        },
                  child: compteVar == 60
                      ? const Text(
                          "Cliquez ici",
                          style: TextStyle(
                            color: Color(0xffBE4A00),
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : Text("Cliquez ici dans ${60 - compteVar} s"),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

final TextEditingController _verificationOTPController =
    TextEditingController();
bool loadingBouttonOTP = false;
Widget buildOtpField(BuildContext context, Function setStating) {
  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: const TextStyle(
      fontSize: 20,
      color: Colors.black,
      fontWeight: FontWeight.w600,
    ),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(12),
    ),
  );

  return Pinput(
    autofocus: true,
    length: 6,
    controller: _verificationOTPController,
    defaultPinTheme: defaultPinTheme,
    focusedPinTheme: defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: Colors.blue, width: 2),
      ),
    ),
    submittedPinTheme: defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: Colors.blue.shade50,
      ),
    ),
    onCompleted: loadingBouttonOTP
        ? null
        : (value) async {
            verificationOTP(context, value, setStating);
          },
    //androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsRetrieverApi,
    autofillHints: const [AutofillHints.oneTimeCode],
    keyboardType: TextInputType.number,
    //animationType: AnimationType.scale,
    showCursor: true,
  );
}

Widget bouttonValidationOTP(
  Function setStating,
  BuildContext context,
  GlobalKey<FormState> cleForm,
) {
  return SizedBox(
    width: double.infinity, // prend toute la largeur disponible
    child: ElevatedButton(
      onPressed: loadingBouttonOTP
          ? null
          : () {
              verificationOTP(
                context,
                _verificationOTPController.text,
                setStating,
              );
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
      child: loadingBouttonOTP
          ? circular(message: "Vérification..")
          : Text("Vérifier le code"),
    ),
  );
}

bool creationCompte = false;
void verificationOTP(BuildContext context, value, Function setStating) async {
  loadingBouttonOTP = true;
  setStating();

  await AuthFirebase().verifierCodeOTP(
    value,
    () async {
      final bdd = await CloudFirestore().lectureUBdd(
        "users",
        filtreCompose: Filter.and(
          cd(
            "phone",
            ajouterIndicatifSiManquant(_emailPhoneConnectionController.text),
          ),
          cd("phone_verifie", false),
        ),
      );

      if (bdd!.docs.isNotEmpty) {
        final doc = bdd.docs[0];
        await CloudFirestore().sup("users", doc.id);
        await CloudFirestore()
            .ajoutBdd("users", uid: AuthFirebase().currentUser!.uid, {
              "nom": _nomEtPrenomCreationCompteController.text,
              "phone": ajouterIndicatifSiManquant(
                _emailPhoneConnectionController.text,
              ),
              "phone_verifie": true,
              "motDePasse": _motDePasseConnectionController.text,
              "methode": "phone",
            });
      }

      loadingBouttonOTP = false;
      creationCompte = false;
      _verificationOTPController.text = "";
      _indexPage = 0;
      setStating();
      Navigator.pop(context);
    },
    (e) {
      loadingBouttonOTP = false;
      setStating();
      String message = "Le code ne correspond pas";
      if (e == "network-request-failed") {
        message = "Vérifiez votre connection internet";
      }

      messageErreurBar(context, messageErr: message);
    },
  );
}
//Widget de confirmation de mail----------------------------------------------------------------
//----------------------------------------------------------------------------------------------

Widget bodyPageConfirmationEmail(Function setStating, BuildContext context) {
  return SingleChildScrollView(
    padding: EdgeInsets.symmetric(horizontal: 35),
    child: Center(
      child: Form(
        key: _formKeyOTPVerification,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/images/band3.PNG", height: 200),
            SizedBox(height: 16),
            SizedBox(
              child: Text(
                "Confirmeation  mail !",
                style: TextStyle(fontSize: 35),
              ),
            ),
            SizedBox(height: 25),
            SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Un lien de vérification a été envoyé à votre adresse e-mail.",
                  ),
                  Text("Veuillez cliquer dessus"),
                  Text("puis revenir ici et appuyer sur le bouton ci-dessous."),
                  SizedBox(height: 20),
                  Text(_emailPhoneConnectionController.text),
                ],
              ),
            ),

            SizedBox(height: 20),

            SizedBox(height: 20),
            bouttonValidationEmail(setStating, context),
            SizedBox(height: 6),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Vous n'avez pas reussi le mail? "),
                TextButton(
                  onPressed: compteVar != 60
                      ? null
                      : () async {
                          try {
                            final etatConnection = await _connectionAvecMail(
                              context,
                              _emailPhoneConnectionController.text,
                              _motDePasseConnectionController.text,
                            );

                            if (etatConnection) {
                              await AuthFirebase().currentUser!
                                  .sendEmailVerification();
                              AuthFirebase().logout();
                              compterAvecDelai(setStating, 60);
                            } else {
                              messageErreurBar(
                                context,
                                messageErr: "Impossible d'envoyer le mail !",
                              );
                            }
                          } on FirebaseAuthException catch (e) {
                            messageErreurBar(context, messageErr: e.code);
                          }
                        },
                  child: compteVar == 60
                      ? const Text("Cliquez ici")
                      : Text(
                          "Cliquez ici dans ${60 - compteVar} s",
                          style: TextStyle(
                            color: Color(0xffBE4A00),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

bool loadingBouttonConfiEmail = false;
Widget bouttonValidationEmail(Function setStating, BuildContext context) {
  return SizedBox(
    width: double.infinity, // prend toute la largeur disponible
    child: ElevatedButton(
      onPressed: loadingBouttonConfiEmail
          ? null
          : () async {
              try {
                loadingBouttonConfiEmail = true;
                setStating();
                await AuthFirebase().loginWithEmailAndPassword(
                  _emailPhoneConnectionController.text,
                  _motDePasseConnectionController.text,
                  decon: false,
                );

                if (!AuthFirebase().currentUser!.emailVerified) {
                  loadingBouttonConfiEmail = false;
                  setStating();
                  await AuthFirebase().logout(decon: false);
                  messageErreurBar(
                    context,
                    messageErr: "Le mail n'a pas été vérifié !",
                  );
                } else {
                  loadingBouttonConfiEmail = false;
                  _indexPage = 0;
                  setStating();
                  //await AuthFirebase().logout(decon: false);

                  envoyerEmail(
                    _emailPhoneConnectionController.text,
                    sujet: "Compte Koontaa",
                    corpsMessage: templateHtmlCompteConfirmation(
                      nom: _nomEtPrenomCreationCompteController.text,
                      mail: _emailPhoneConnectionController.text,
                      motDePasse: _motDePasseConfirmationController.text,
                    ),
                  );
                  //await AuthFirebase().logout(decon: false);
                  Navigator.pop(context);
                }
              } on FirebaseAuthException catch (e) {
                //print(e);
                loadingBouttonConfiEmail = false;
                setStating();
                messageErreurBar(
                  context,
                  messageErr: "Vérifiez votre connection internet !",
                );
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
      child: loadingBouttonConfiEmail
          ? circular(message: "Vérification")
          : Text("J’ai vérifié mon e-mail"),
    ),
  );
}

String ajouterIndicatifSiManquant(String numero) {
  numero = numero.trim(); // Supprimer les espaces inutiles

  // Vérifie si le numéro commence par +225 ou 00225
  if (numero.startsWith("+225") || numero.startsWith("00225")) {
    return numero;
  }

  // Supprimer les zéros initiaux
  /*if (numero.startsWith("0")) {
    numero = numero.substring(1);
  }*/

  // Ajouter l’indicatif
  return "+225$numero";
}

//Widget mot de passe oublier--------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------

final GlobalKey<FormState> _formKeyMotDePasseOublie = GlobalKey<FormState>();
Widget bodyPageMotDePasseOUblie(Function setStating, BuildContext context) {
  return SingleChildScrollView(
    padding: EdgeInsets.symmetric(horizontal: 35),
    child: Center(
      child: Form(
        key: _formKeyMotDePasseOublie,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/images/band3.PNG", height: 200),
            SizedBox(height: 30),
            SizedBox(
              child: Text(
                "Mot de passe oublié !",
                style: TextStyle(fontSize: 35),
              ),
            ),
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Si vous n'avez pas de compte "),
                  TextButton(
                    onPressed: () {
                      _indexPage = 1;
                      setStating();
                    },
                    child: Text(
                      "Cliquez ici pour créer un compte",
                      style: TextStyle(
                        color: Color(0xffBE4A00),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 25),
            inputFieldEmailPhone(setStating, hiden: "Adresse Mail"),
            SizedBox(height: 35),
            //inputFieldMotDPasse(),
            Text(
              "Nous vous enverrons un email avec vos informations d'accès à l'adresse que vous allez saisir.",
              style: TextStyle(fontSize: 16, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 35),
            bouttonMotDePasseOublie(setStating, context, _formKeyConnection),
            SizedBox(height: 20),
            !(mailEnvoye)
                ? SizedBox()
                : Text(
                    "Un email contenant vos informations d'accès vous a été envoyé. "
                    "Si vous ne le trouvez pas dans votre boîte de réception, pensez à vérifier vos courriers indésirables (spam).",
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
          ],
        ),
      ),
    ),
  );
}

bool _isloadingMotDePasseOublie = false;
bool mailEnvoye = false;
Widget bouttonMotDePasseOublie(
  Function setStating,
  BuildContext context,
  GlobalKey<FormState> cleForm,
) {
  return SizedBox(
    width: double.infinity, // prend toute la largeur disponible
    child: ElevatedButton(
      onPressed: (_isloadingMotDePasseOublie || compteVar != 60)
          ? null
          : () async {
              if (_formKeyMotDePasseOublie.currentState!.validate()) {
                _isloadingMotDePasseOublie = true;
                setStating();
                if (!await CloudFirestore().checkConnexionFirestore()) {
                  messageErreurBar(
                    context,
                    messageErr: "Vérifiez votre connection internet!",
                  );
                  _isloadingMotDePasseOublie = false;
                  setStating();
                  return;
                }

                try {
                  final bdd = await CloudFirestore().lectureUBdd(
                    "users",
                    filtreCompose: Filter.and(
                      cd("mail", _emailPhoneConnectionController.text),
                      cd("methode", "mail"),
                    ),
                  );

                  if (bdd != null && bdd.docs.isNotEmpty) {
                    final doc = bdd.docs;
                    final donne = doc[0].data() as Map<String, dynamic>;
                    envoyerEmail(
                      _emailPhoneConnectionController.text,
                      sujet: "Acces Koontaa",
                      corpsMessage: templateHtmlMotDePasseOublie(
                        nom: donne["nom"],
                        mail: _emailPhoneConnectionController.text,
                        motDePasse: donne["motDePasse"],
                      ),
                    );

                    _isloadingMotDePasseOublie = false;
                    mailEnvoye = true;
                    setStating();
                    messageErreurBar(
                      context,
                      messageErr:
                          "Vos acces ont été envoyer! Verifier votre boite mail.",
                      couleur: Colors.green,
                    );

                    compterAvecDelai(setStating, 60);
                  } else {
                    _isloadingMotDePasseOublie = false;
                    setStating();
                    messageErreurBar(
                      context,
                      messageErr: "Aucun compte ne correspond à ce mail !",
                    );
                  }
                } catch (e) {
                  messageErreurBar(
                    context,
                    messageErr: "Une erreur s'est produit!",
                  );
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
      child: compteVar != 60
          ? Text("réessayez dans ${60 - compteVar}")
          : (_isloadingMotDePasseOublie
                ? circular(message: "Envoie...")
                : Text("M'envoyer mon mot de passe !")),
    ),
  );
}
