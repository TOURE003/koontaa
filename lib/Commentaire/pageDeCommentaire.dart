import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:koontaa/Commentaire/widget_commentaire.dart';
import 'package:koontaa/functions/cloud_firebase.dart';
import 'package:koontaa/functions/firebase_auth.dart';
import 'package:koontaa/pages/compte/connection/page_connection.dart';
import 'package:koontaa/pages/magasin/ajoutDeProduit.dart';

class PageAvecChampFixe extends StatelessWidget {
  final String idProduit;
  const PageAvecChampFixe({super.key, required this.idProduit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Cette ligne permet de redimensionner le corps de la page quand le clavier s'affiche
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text('Commentaires')),
      body: Stack(
        children: [
          // Le contenu principal de la page
          ListView(
            padding: const EdgeInsets.all(8),
            children: [fenetreCommentaire(context, idProduit)],
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
                        controller: textCommentaire,
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
                      onPressed: () async {
                        if (textCommentaire.text != "") {
                          if (!await ajouterCommentairePrincipal(
                            context,
                            idProduit,
                            textCommentaire.text,
                          )) {
                            messageErreurBar(
                              context,
                              messageErr: "Une erreur est survénu",
                            );
                          }
                        }

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

final parent = {
  'avatar': 'https://example.com/avatar_parent.png',
  'username': 'ParentUser',
  'comment': 'Ceci est le commentaire principal.',
};

final responses = [
  {
    'avatar': 'https://example.com/avatar1.png',
    'username': 'Répondeur1',
    'comment': 'Voici une réponse.',
  },
  {
    'avatar': 'https://example.com/avatar2.png',
    'username': 'Répondeur2',
    'comment': 'Une autre réponse.',
  },
];

/// Fonction qui construit un widget de commentaire avec ses réponses
Widget buildCommentWithReplies({
  required Map<String, String> parentComment,
  required List<Map<String, dynamic>> replies,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      /// Commentaire parent
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(parentComment['avatar'] ?? ''),
            radius: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  parentComment['username'] ?? 'Utilisateur',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Column(
                  children: [
                    Text(
                      parentComment['comment'] ?? '',
                      style: const TextStyle(fontSize: 14),
                    ),
                    TextButton(onPressed: () {}, child: Text("Répondre")),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),

      const SizedBox(height: 8),

      /// Réponses (avec indentation)
      ...replies.map((reply) {
        return Padding(
          padding: const EdgeInsets.only(left: 40, top: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(reply['avatar'] ?? ''),
                radius: 16,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reply['username'] ?? 'Utilisateur',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      reply['comment'] ?? '',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    ],
  );
}

Widget fenetreCommentaire(BuildContext context, String idProduit) {
  return StreamBuilder(
    stream: CloudFirestore().lectureBdd(
      "commentaires",
      filtreCompose: Filter.and(
        cd("idProduits", idProduit),
        cd("principal", true),
      ),
    ),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }
      if (snapshot.hasError) {
        return Text('Erreur lors de la lecture ${snapshot.error}');
      }
      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return const Text('Aucun commentaire trouvé');
      }

      final docs = snapshot.data!.docs;

      final widgets = docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final Map<String, String> parent = {
          'avatar': data["avatar"] ?? '',
          'username': data["nomUser"] ?? '',
          'comment': data["commentaire"] ?? '',
        };

        return StreamBuilder(
          stream: CloudFirestore().lectureBdd(
            "commentaires",
            filtreCompose: Filter.and(
              cd("idCommentaireParent", doc.id),
              cd("principal", false),
            ),
          ),
          builder: (context, snapshot0) {
            if (snapshot0.connectionState == ConnectionState.waiting) {
              return const SizedBox(); // ou une animation légère
            }
            if (snapshot0.hasError) {
              return Text('Erreur réponse : ${snapshot0.error}');
            }

            final docs0 = snapshot0.data?.docs ?? [];

            List<Map<String, dynamic>> reponse = docs0.map((doc0) {
              final data0 = doc0.data() as Map<String, dynamic>;
              return {
                'avatar': data0["avatar"] ?? '',
                'username': data0["nomUser"] ?? '',
                'comment': data0["commentaire"] ?? '',
              };
            }).toList();

            return buildCommentWithReplies(
              parentComment: parent,
              replies: reponse,
            );
          },
        );
      }).toList();

      return ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: widgets,
      );
    },
  );
}

TextEditingController controlRepondreAvide = TextEditingController();
TextEditingController textCommentaire = TextEditingController();
int rangCommentaire = 0;

String idCommentairePrincipaleRepondu = "";
String nomRepondu = "";
Future<bool> ajouterCommentairePrincipal(
  BuildContext context,
  String idProduits,
  String commentaire,
) async {
  String? idUser = AuthFirebase().currentUser?.uid;
  final bool etatCon = await CloudFirestore().checkConnexionFirestore();
  String avatar =
      "https://www.shutterstock.com/image-vector/user-profile-icon-vector-avatar-600nw-2558760599.jpg";

  String nomUser = "Indéfini";

  if (idUser == null || !etatCon) {
    messageErreurBar(context, messageErr: "Vous n'ètes pas connecté");
    return false;
  }
  //

  final lecture = await CloudFirestore().lectureUBdd("users", idDoc: idUser);
  if (lecture != null && lecture is DocumentSnapshot) {
    final data = lecture.data() as Map<String, dynamic>;
    avatar = data["avatar"] == "" ? avatar : data["avatar"];
    nomUser = data["nom"];
  }

  Map<String, dynamic> comm = {};
  if (rangCommentaire == 0) {
    comm = {
      "idProduits": idProduits,
      "idUser": AuthFirebase().currentUser?.uid,
      "idCommentaireParent": "",
      "nomUser": nomUser,
      "avatar": avatar,
      "principal": true,
      "rang": 0,
      "reponseAidCommentaire": "",
      "commentaire": commentaire,
      "dateTime": await dd(),
    };
  } else if (rangCommentaire == 1) {
    comm = {
      "idProduits": idProduits,
      "idUser": AuthFirebase().currentUser?.uid,
      "idCommentaireParent": idCommentairePrincipaleRepondu,
      "nomUser": nomUser,
      "nomRepondu": nomRepondu,
      "avatar": avatar,
      "principal": false,
      "rang": 1,
      "reponseAidCommentaire": "",
      "commentaire": commentaire,

      "dateTime": await dd(),
    };
  } else if (rangCommentaire == 2) {
    comm = {
      "idProduits": idProduits,
      "idUser": AuthFirebase().currentUser?.uid,
      "idCommentaireParent": idCommentairePrincipaleRepondu,
      "nomUser": nomUser,
      "nomRepondu": nomRepondu,
      "avatar": avatar,
      "principal": false,
      "rang": 2,
      "reponseAidCommentaire": "",
      "commentaire": commentaire,

      "dateTime": await dd(),
    };
  }

  rangCommentaire = 0;
  controlRepondreAvide.clear();

  print(comm);

  return await CloudFirestore().ajoutBdd("commentaires", comm);
}
