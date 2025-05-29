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

Widget homeBottomPage(Function setStating) {
  return NavigationBar(
    selectedIndex: pageBottomIndex,
    onDestinationSelected: (int index) {
      pageBottomIndex = index;
      setStating();
    },

    backgroundColor: const Color.fromARGB(255, 243, 241, 241),
    destinations: [
      NavigationDestination(
        icon: Icon(Icons.shopping_basket),
        label: "Le maché",
      ),
      NavigationDestination(
        icon: Icon(Icons.filter_tilt_shift),
        label: "Mon magasin",
        tooltip: "12",
        enabled: true,
        selectedIcon: Icon(Icons.add),
      ),
      NavigationDestination(icon: Icon(Icons.group), label: "Communauté"),
      NavigationDestination(icon: Icon(Icons.phone), label: "Appel"),
    ],
  );
}
