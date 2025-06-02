import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:koontaa/functions/firebase_auth.dart';
import 'package:koontaa/functions/fonctions.dart';

class PageConnection extends StatefulWidget {
  const PageConnection({super.key, required this.title});

  final String title;

  @override
  State<PageConnection> createState() => _PageConnectionState();
}

class _PageConnectionState extends State<PageConnection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: couleurDeApp(),
      appBar: appBarConnection(),
      body: bodyPageConnectionConnection(() {
        setState(() {});
      }, context),
    );
  }
}

PreferredSizeWidget appBarConnection() {
  return PreferredSize(
    preferredSize: Size.fromHeight(30),
    child: AppBar(backgroundColor: couleurDeApp()),
  );
}

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
                    onPressed: () {},
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
            inputFieldEmailPhone(),
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
              onPressed: () {},
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
                  onPressed: () {},
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
Widget inputFieldEmailPhone() {
  return TextFormField(
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
      label: Text("Adresse Mail ou Téléphone", style: TextStyle(fontSize: 20)),
      border: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
      ),
    ),
  );
}

final TextEditingController _motDePasseConnectionController =
    TextEditingController();
Widget inputFieldMotDPasse() {
  return TextFormField(
    controller: _motDePasseConnectionController,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Veuillez entrer un mot de passe';
      }

      final passwordRegex = RegExp(r'^.{4,}$');

      if (!passwordRegex.hasMatch(value)) {
        return 'Mot de passe Incorrect !';
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
              if (cleForm.currentState!.validate()) {
                _lesBouttonsSontActive = false;
                circularBoutton1 = true;
                setStating();

                final phoneRegex = RegExp(r'^(0[0-9]{9}|\+225[0-9]{10})$');
                String identifiant = _emailPhoneConnectionController.text
                    .trim();
                if (phoneRegex.hasMatch(_emailPhoneConnectionController.text)) {
                  identifiant += "@koontaa.com";
                  identifiant = identifiant.replaceAll('+225', '');
                }

                try {
                  await AuthFirebase().loginWithEmailAndPassword(
                    identifiant,
                    _motDePasseConnectionController.text,
                  );
                  _emailPhoneConnectionController.text = "";
                  _motDePasseConnectionController.text = "";
                  _lesBouttonsSontActive = true;
                } on FirebaseAuthException catch (e) {
                  _lesBouttonsSontActive = true;
                  setStating();
                  String messageErr = "";
                  if (e.code == "invalid-email") {
                    final phoneRegex = RegExp(r'^(0[0-9]{9}|\+225[0-9]{10})$');
                    if (phoneRegex.hasMatch(
                      _emailPhoneConnectionController.text,
                    )) {
                      messageErr = "Numéro de téléphone incorrecte";
                    } else {
                      messageErr = "Adresse mail  incorrecte";
                    }
                  } else if (e.code == "invalid-credential") {
                    final phoneRegex = RegExp(r'^(0[0-9]{9}|\+225[0-9]{10})$');
                    if (phoneRegex.hasMatch(
                      _emailPhoneConnectionController.text,
                    )) {
                      messageErr =
                          "Numéro de téléphone ou mot de passe incorrecte !";
                    } else {
                      messageErr = "Adrèsse Mail ou mot de passe incorrecte !";
                    }
                  } else if (e.code == "network-request-failed") {
                    messageErr = "Vérifiez votre connection internet";
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(messageErr),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.red,
                      showCloseIcon: true,
                    ),
                  );
                }
              }
              circularBoutton1 = false;
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
                _lesBouttonsSontActive = true;
                try {
                  setSeting();
                } catch (e) {}
              } catch (e) {
                _lesBouttonsSontActive = true;
                setSeting();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Erreur lors de la connexion avec Google : $e",
                    ),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.red,
                    showCloseIcon: true,
                  ),
                );
              }
              circularBoutton2 = false;
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
  return Platform.isIOS
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
                _lesBouttonsSontActive = true;
                try {
                  setStating();
                } catch (e) {}
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

Widget circular() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: const [
      SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Color(0xffBE4A00),
        ),
      ),
      SizedBox(width: 10),
      Text(
        "Connexion...",
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
      ),
    ],
  );
}
