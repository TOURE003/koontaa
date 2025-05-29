import 'package:flutter/material.dart';

class Recherche extends StatefulWidget {
  const Recherche({super.key, required this.title});

  final String title;

  @override
  State<Recherche> createState() => _RechercheeState();
}

class _RechercheeState extends State<Recherche> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("data")));
  }
}
