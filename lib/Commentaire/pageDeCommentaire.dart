import 'package:flutter/material.dart';

class PageAvecChampFixe extends StatelessWidget {
  const PageAvecChampFixe({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Cette ligne permet de redimensionner le corps de la page quand le clavier s'affiche
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text('Commentaires')),
      body: Stack(
        children: [
          // Le contenu principal de la page
          ListView.builder(
            padding: const EdgeInsets.only(
              bottom: 80,
            ), // espace pour le champ en bas
            itemCount: 20,
            itemBuilder: (context, index) =>
                ListTile(title: Text('Commentaire n°$index')),
          ),

          // Le champ de saisie fixé en bas
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                color: Colors.grey.shade100,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Écrire un commentaire...",
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {
                        // Envoyer le message ici
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
