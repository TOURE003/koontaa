import 'package:flutter/material.dart';
import 'package:koontaa/pages/recherche/recherche_widgets.dart';

class Recherche extends StatefulWidget {
  const Recherche({super.key, required this.title});

  final String title;

  @override
  State<Recherche> createState() => _RechercheeState();
}

class _RechercheeState extends State<Recherche> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: rechercheAppBarre(context),
      body: ValueListenableBuilder(
        valueListenable: searchController,
        builder: (context, TextEditingValue value, _) {
          return Center(child: Text("Texte saisi : ${value.text}"));
        },
      ),
    );
  }
}
