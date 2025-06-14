import 'package:flutter/material.dart';
import 'package:koontaa/functions/fonctions.dart';

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
          child: Form(child: Column(children: [barreDePhoto(context)])),
        ),
      ),
      bottomNavigationBar: Text("data"),
    );
  }
}

Widget boutonPhoto(BuildContext context) {
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
                  onPressed: () {},
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
                onPressed: () {},
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
                onPressed: () {},
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

Widget barreDePhoto(BuildContext context) {
  return SizedBox(
    height: long(context, ratio: 0.3),
    child: ListView(
      scrollDirection: Axis.horizontal,
      children: [
        SizedBox(width: larg(context, ratio: 0.1)),
        boutonPhoto(context),
        SizedBox(width: larg(context, ratio: 0.04)),
        Image.network(
          "https://img.freepik.com/psd-gratuit/logo-du-smartphone-isole_23-2151232010.jpg",
        ),
        //boutonPhoto(context),
      ],
    ),
  );
}
