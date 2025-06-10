//import 'dart:nativewrappers/_internal/vm/lib/math_patch.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:koontaa/functions/cloud_firebase.dart';
import 'package:koontaa/functions/firebase_auth.dart';
import 'package:koontaa/functions/fonctions.dart';
import 'package:koontaa/pages/compte/connection/page_connection.dart';
import 'package:koontaa/pages/home/home.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

//kjijkljlkjhklhj

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Koontaa',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 238, 232, 248),
        ),
      ),
      home: const Home(title: 'Home Page'),
    );
  }
}

class Exemple extends StatefulWidget {
  const Exemple({super.key, required this.title});

  final String title;

  @override
  State<Exemple> createState() => _ExempleState();
}

class _ExempleState extends State<Exemple> {
  CloudFirestore bdd = CloudFirestore();

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () async {
              bool res = await bdd.ajoutBdd(
                "user",
                //AuthFirebase().currentUser!.uid + "10jkljkljjkhjhkl",
                {"nom": "Toure Abdoulaye kkkkk"},
              );

              if (res) {
                messageErreurBar(context, messageErr: "Succes");
              } else {
                messageErreurBar(context, messageErr: "echec");
              }
            },
            child: Text("teste Ajout cloudFirestore"),
          ),
          Container(
            child: StreamBuilder(
              stream: bdd.lectureBdd("user"),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  print('Erreur lors de la lecture ${snapshot.error}');
                  return Text('Erreur lors de la lecture ${snapshot.error}');
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Text('Aucun article trouvé');
                }
                final docs = snapshot.data!.docs;
                final data = docs[0].data() as Map<String, dynamic>;
                return Text(data["nom"] ?? "");
              },
            ),
          ),
          TextField(controller: _controller),

          ElevatedButton(
            onPressed: () async {
              final bdd0 = await bdd.lectureUBdd("user");
              if (bdd0 != null && bdd0.docs.isNotEmpty) {
                final docs = bdd0.docs;
                final data = docs[0].id;
                if (await bdd.modif("user", data, {"nom": _controller.text})) {
                  messageErreurBar(context, messageErr: "ok");
                  return;
                }
                messageErreurBar(context, messageErr: "err");
              }

              //CloudFirestore().modif("user", idDoc, donnees)
            },
            child: Text("modier"),
          ),

          ElevatedButton(
            onPressed: () async {
              final bdd0 = await bdd.lectureUBdd("user");
              if (bdd0 != null && bdd0.docs.isNotEmpty) {
                final docs = bdd0.docs;
                final data = docs[0].id;
                await bdd.sup("user", data);
                messageErreurBar(context, messageErr: "ok");
              }
            },
            child: Text("Supprimer"),
          ),
          ElevatedButton(
            onPressed: () async {
              envoyerEmail(
                "toureabdoulaye003@gmail.com",
                sujet: "Inscription",
                corpsMessage: templateHtmlCompteConfirmation(
                  nom: "TOURE Abdoulaye",
                  mail: "toureabdoulaye003@gmail.com",
                  motDePasse: "3a2zz9T",
                ),
              );
            },
            child: Text("envoyer mail"),
          ),
        ],
      ),
    );
  }
}
