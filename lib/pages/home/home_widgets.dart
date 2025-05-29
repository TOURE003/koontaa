import 'package:flutter/material.dart';
import 'package:koontaa/pages/recherche/recherche.dart';
import 'package:koontaa/functions/fonctions.dart';

PreferredSizeWidget homeAppBarre(context) {
  return AppBar(
    backgroundColor: Colors.deepOrange,
    title: GestureDetector(
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
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
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
    ),
  );
}

int pageBottomIndex = 0;
Widget homeBottomPage(int nbrPanier, int nbrMagasin, Function setStating) {
  return NavigationBarTheme(
    data: NavigationBarThemeData(
      indicatorColor:
          Colors.transparent, // Fond transparent (pas de surbrillance)
      shadowColor: Color.fromARGB(
        9,
        0,
        0,
        0,
      ), // Ombre très légère sous la barre
      elevation: 10,
    ),
    child: NavigationBar(
      selectedIndex: pageBottomIndex,
      onDestinationSelected: (int index) {
        pageBottomIndex = index;
        setStating();
      },

      backgroundColor: const Color.fromARGB(255, 255, 254, 254),
      destinations: [
        NavigationDestination(
          icon: Icon(Icons.shopping_basket),
          label: "Marché",
          selectedIcon: Icon(Icons.shopping_basket, color: couleurDeApp()),
        ),
        NavigationDestination(
          icon: IconAvecNum(
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
          icon: IconAvecNum(
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

Widget IconAvecNum(IconData typeIcone, int numn, Color couleur) {
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
