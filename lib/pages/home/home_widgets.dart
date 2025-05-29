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
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
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
