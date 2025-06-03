import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
              onPressed: () {
                if (indexPageCible == 1 || indexPageCible == 2) {
                  _indexPage = indexPageCible - 1;
                  setSteting();
                } else if (indexPageCible == 3) {
                  _indexPage = 1;
                  setSteting();
                }
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
            Image.asset("assets/images/band3.PNG", height: 200),
            SizedBox(height: 16),
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
            SizedBox(height: 30),
            inputFieldNomEtPrenomCreationCompte(),
            SizedBox(height: 15),
            inputFieldEmailPhone(),
            SizedBox(height: 15),
            inputFieldMotDPasse(
              messageErr: "Le mot de passe doit conténir au moin 4 caractères.",
            ),
            SizedBox(height: 15),
            inputFieldMotDPasseConfirmation(),
            SizedBox(height: 35),
            bouttonValidationCreerCompte(
              setStating,
              context,
              _formKeyCreationCompte,
            ),
            SizedBox(height: 35),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Vous avez déjà un compte ?"),
                TextButton(
                  onPressed: () {
                    _indexPage = 0;
                    setStating();
                  },
                  child: Text(
                    "Cliquez ici pour vous connecter",
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

Widget bouttonValidationCreerCompte(
  Function setStating,
  BuildContext context,
  GlobalKey<FormState> cleForm,
) {
  return SizedBox(
    width: double.infinity, // prend toute la largeur disponible
    child: ElevatedButton(
      onPressed: () async {
        if (cleForm.currentState!.validate()) {
          final phoneRegex = RegExp(r'^(0[0-9]{9}|\+225[0-9]{10})$');
          final emailRegex = RegExp(r'^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})$');
          if (phoneRegex.hasMatch(_emailPhoneConnectionController.text)) {
            await AuthFirebase().envoyerCodeSMS(
              _emailPhoneConnectionController.text,
              () {
                _indexPage = 2;
                setStating();
              },
              (e) {
                messageErreurBar(
                  context,
                  messageErr: e.code == "network-request-failed"
                      ? "Vérifiez votre connection internet."
                      : "Une erreur est survénue. Réessayez plus tard.",
                );
              },
            );
          } else if (emailRegex.hasMatch(
            _emailPhoneConnectionController.text,
          )) {
            AuthFirebase().createUserWithPassword(
              _emailPhoneConnectionController.text,
              _motDePasseConfirmationController.text,
              () {
                AuthFirebase().logout();
                _indexPage = 3;
                setStating();
              },
              () {
                messageErreurBar(context, messageErr: "Erreur de connection");
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
      child: Text("Créez le compte"),
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
Widget inputFieldMotDPasse({String messageErr = "Mot de passe Incorrect !"}) {
  return TextFormField(
    controller: _motDePasseConnectionController,
    validator: (value) {
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

void messageErreurBar(
  BuildContext context, {
  String messageErr = "Une erreur s'est produit",
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(messageErr),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.red,
      showCloseIcon: true,
    ),
  );
}
//Widget de confirmation otp-------------------------------------------------------------
//---------------------------------------------------------------------------------------

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
            buildOtpField(
              onCompleted: (value) async {
                await AuthFirebase().verifierCodeOTP(value);
              },
            ),
            SizedBox(height: 20),
            bouttonValidationOTP(setStating, context, _formKeyConnection),
            SizedBox(height: 6),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Vous n'avez pas reussi le code? "),
                TextButton(
                  onPressed: () {
                    _indexPage = 1;
                    setStating();
                  },
                  child: Text(
                    "Cliquez ici dans 60 s",
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

final TextEditingController _verificationOTPController =
    TextEditingController();
Widget buildOtpField({required void Function(String) onCompleted}) {
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
    onCompleted: onCompleted,
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
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        elevation: 0, // pas d’ombre
        backgroundColor: Color(0xffBE4A00), // ou toute autre couleur sauf rouge
        foregroundColor: Colors.white, // couleur du texte/icône
        padding: EdgeInsets.symmetric(vertical: 16), // hauteur du bouton
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // coins arrondis optionnels
        ),
      ),
      child: Text("Vérifier le code"),
    ),
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
                  onPressed: () {},
                  child: Text(
                    "Cliquez ici dans 60 s",
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

Widget bouttonValidationEmail(Function setStating, BuildContext context) {
  return SizedBox(
    width: double.infinity, // prend toute la largeur disponible
    child: ElevatedButton(
      onPressed: () async {
        try {
          await AuthFirebase().loginWithEmailAndPassword(
            _emailPhoneConnectionController.text,
            _motDePasseConfirmationController.text,
          );

          if (!AuthFirebase().currentUser!.emailVerified) {
            AuthFirebase().logout();
            messageErreurBar(
              context,
              messageErr: "Le mail n'a pas été vérifié !",
            );
          } else {
            _indexPage = 0;
          }
        } on FirebaseAuthException catch (e) {
          print(e);
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
      child: Text("J’ai vérifié mon e-mail"),
    ),
  );
}
