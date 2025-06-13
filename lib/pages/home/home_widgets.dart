import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:koontaa/functions/firebase_auth.dart';
import 'package:koontaa/functions/storage.dart';
import 'package:koontaa/pages/compte/connection/page_connection.dart';
import 'package:koontaa/pages/recherche/recherche.dart';
import 'package:koontaa/functions/fonctions.dart';
import 'package:koontaa/pages/compte/connection/page_redirection_compte_connection.dart';
//import 'package:koontaa/pages/compte/connection/page_connection.dart';

PreferredSizeWidget homeAppBarre(context) {
  return PreferredSize(
    preferredSize: Size.fromHeight(40),
    child: AppBar(
      backgroundColor: Color(0xFFF9EFE0),
      title: Text("Marché"),
      centerTitle: true,
    ),
  );
}

int pageBottomIndex = 0;
Widget homeBottomPage(
  BuildContext context,
  int nbrPanier,
  int nbrMagasin,
  Function setStating,
) {
  return NavigationBarTheme(
    data: NavigationBarThemeData(
      indicatorColor:
          Colors.transparent, // Fond transparent (pas de surbrillance)
      shadowColor: Color.fromARGB(
        100,
        0,
        0,
        0,
      ), // Ombre très légère sous la barre
      elevation: 100,
    ),
    child: NavigationBar(
      selectedIndex: pageBottomIndex,
      onDestinationSelected: (int index) {
        if (index == 3) {
          if (AuthFirebase().currentUser != null) {
            pageBottomIndex = index;
          } else {
            changePage(context, PageConnection(title: "Connection"));
          }
        } else {
          pageBottomIndex = index;
        }
        setStating();
      },

      backgroundColor: const Color.fromARGB(255, 230, 221, 207),
      destinations: [
        NavigationDestination(
          icon: Icon(Icons.shopping_basket),
          label: "Marché",
          selectedIcon: Icon(Icons.shopping_basket, color: couleurDeApp()),
        ),
        NavigationDestination(
          icon: iconAvecNum(
            Icons.shopping_cart,
            nbrPanier,
            const Color.fromARGB(255, 0, 0, 0),
          ),
          label: "Panier",
          selectedIcon: Icon(Icons.shopping_cart, color: couleurDeApp()),
        ),
        NavigationDestination(
          icon: Icon(Icons.favorite),
          label: "Favoris",
          selectedIcon: Icon(Icons.favorite, color: couleurDeApp()),
        ),
        NavigationDestination(
          icon: Icon(Icons.account_circle),
          label: "Compte",
          selectedIcon: Icon(Icons.account_circle, color: couleurDeApp()),
        ),
        NavigationDestination(
          icon: iconAvecNum(
            Icons.storefront,
            nbrMagasin,
            Color.fromARGB(255, 17, 155, 50),
          ),
          label: "Mon Magasin",
          selectedIcon: Icon(Icons.storefront, color: couleurDeApp()),
        ),
      ],
    ),
  );
}

Widget iconAvecNum(IconData typeIcone, int numn, Color couleur) {
  if (numn == 0) {
    return Icon(typeIcone, color: couleur);
  } else {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(typeIcone, color: couleur), // Icône de base
        // Le badge
        Positioned(
          right: -6,
          top: -6,
          child: Container(
            padding: EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: Colors.red, // Couleur du badge
              shape: BoxShape.circle,
            ),
            child: Text(
              '$numn', // Le nombre à afficher
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Widget homeBody(BuildContext context) {
  List<Widget> tabl = tablWid(50);
  Widget wd = GestureDetector(
    onTap: () {
      //Se rendre sur la page de récherche
      changePage(context, const Recherche(title: "Page de Récherche"));
    },
    child: Container(
      height: 36,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Row(
        children: const [
          Icon(Icons.search, color: Colors.grey),
          SizedBox(width: 10),
          Text(
            "Rechercher...",
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ],
      ),
    ),
  );
  tabl.insert(0, wd);
  wd = Image.asset("assets/images/band1.PNG");
  tabl.insert(0, wd);
  return ListView(padding: EdgeInsets.symmetric(vertical: 0), children: tabl);
}

List<Widget> tablWid(int nbr) {
  Widget contai = Container(height: 50, width: 50, color: Colors.black);
  List<Widget> tbl = [];
  for (var i = 0; i < nbr; i++) {
    tbl.add(contai);
    tbl.add(SizedBox(height: 25));
  }
  return tbl;
}

String lienImage = "0";
Widget expp(Function setStating) {
  return CustomScrollView(
    slivers: [
      SliverAppBar(
        expandedHeight: 400,
        pinned: true,
        floating: false,
        backgroundColor: Color(0xFFBE4A00),
        flexibleSpace: LayoutBuilder(
          builder: (context, constraints) {
            double top = constraints.biggest.height;

            return FlexibleSpaceBar(
              centerTitle: true,
              title: top < 100
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(child: Container()), // espace vide à gauche
                        // Texte centré
                        Text(
                          'Koontaa',
                          style: TextStyle(
                            color: Color.fromARGB(221, 255, 255, 255),
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),

                        Spacer(), // espace flexible entre texte et icône
                        // Icône à droite
                        IconButton(
                          onPressed: () {
                            changePage(
                              context,
                              const Recherche(title: "Page de Récherche"),
                            );
                          },
                          icon: Icon(Icons.search, color: Colors.white),
                        ),
                      ],
                    )
                  : null,
              background: Container(
                color: Color(0xFFF9EFE0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 0),
                    Image.asset('assets/images/band1.PNG', height: 75),
                    const SizedBox(height: 0),
                    rechercheFactis(context),
                    Image.asset('assets/images/band2.PNG', width: 550),
                    ElevatedButton(
                      onPressed: () async {
                        final image = await imageUser(camera: false);
                        final lien = await uploadToImageKit(image["image"]);
                        lienImage = lien;
                        setStating();
                        messageErreurBar(context, messageErr: lien);
                      },
                      child: Text("data"),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      SliverList(
        delegate: SliverChildBuilderDelegate(childCount: 1, (context, index) {
          return !(lienImage != "annule-file" &&
                  lienImage != "err-file" &&
                  lienImage != "0")
              ? Text("pas d'image")
              : Image.network(lienImage);
        }),
      ),
    ],
  );
}

Widget rechercheFactis(context) {
  return GestureDetector(
    onTap: () {
      changePage(context, const Recherche(title: "Page de Récherche"));
    },
    child: Container(
      height: 36,
      width: 550,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 220, 211, 198),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: const [
          Icon(Icons.search, color: Color.fromARGB(255, 62, 62, 62)),
          SizedBox(width: 10),
          Text(
            "Rechercher...",
            style: TextStyle(
              color: Color.fromARGB(255, 47, 46, 46),
              fontSize: 16,
            ),
          ),
        ],
      ),
    ),
  );
}
