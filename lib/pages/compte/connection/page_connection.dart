import 'package:flutter/material.dart';
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
      body: bodyPageConnectionConnection(),
    );
  }
}

PreferredSizeWidget appBarConnection() {
  return PreferredSize(
    preferredSize: Size.fromHeight(30),
    child: AppBar(backgroundColor: couleurDeApp()),
  );
}

final _formKeyConnection = GlobalKey<FormState>();
//final _emailController = TextEditingController();

Widget bodyPageConnectionConnection() {
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
              child: Text("Connection !", style: TextStyle(fontSize: 35)),
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
            TextFormField(
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
                label: Text(
                  "Adresse Mail ou Téléphone",
                  style: TextStyle(fontSize: 20),
                ),
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
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
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity, // prend toute la largeur disponible
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  elevation: 0, // pas d’ombre
                  backgroundColor: Color(
                    0xffBE4A00,
                  ), // ou toute autre couleur sauf rouge
                  foregroundColor: Colors.white, // couleur du texte/icône
                  padding: EdgeInsets.symmetric(
                    vertical: 16,
                  ), // hauteur du bouton
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      10,
                    ), // coins arrondis optionnels
                  ),
                ),
                child: Text("Se connecter"),
              ),
            ),
            SizedBox(height: 6),
            TextButton(
              onPressed: () {},
              child: const Text(
                "Mot de passe oublié ?",
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
            SizedBox(
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
                  "    Continuer avec Google",
                  style: TextStyle(fontSize: 18),
                ),
                icon: Image.asset("assets/images/logo_google.jpg", width: 30),
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
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
            ),
            SizedBox(height: 10),
            SizedBox(
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
                  "Continuer avec Facebook",
                  style: TextStyle(fontSize: 18),
                ),
                icon: Image.asset("assets/images/logo_facebook.jpg", width: 30),
              ),
            ),
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
