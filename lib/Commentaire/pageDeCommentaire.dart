import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:koontaa/Commentaire/widget_commentaire.dart';
import 'package:koontaa/functions/cloud_firebase.dart';
import 'package:koontaa/functions/firebase_auth.dart';
import 'package:koontaa/functions/fonctions.dart';
import 'package:koontaa/functions/storage.dart';
import 'package:koontaa/pages/compte/connection/page_connection.dart';
import 'package:koontaa/pages/magasin/ajoutDeProduit.dart';
import 'package:koontaa/pages/magasin/page_article_magasin.dart';

class PageAvecChampFixe extends StatefulWidget {
  final String idProduit;
  final List<dynamic> urlImgProduit;

  const PageAvecChampFixe({
    super.key,
    required this.idProduit,
    required this.urlImgProduit,
  });

  @override
  State<PageAvecChampFixe> createState() => _PageAvecChampFixeState();
}

class _PageAvecChampFixeState extends State<PageAvecChampFixe> {
  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> _commentKeys = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: couleurDeApp(),
      appBar: AppBar(
        title: const Text('Commentaires'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Stack(
        children: [
          ListView(
            controller: _scrollController,
            padding: const EdgeInsets.all(8),
            children: [
              defilementImagesHorizontales(context, widget.urlImgProduit),
              fenetreCommentaire(
                context,
                () {
                  setState(() {});
                },
                widget.idProduit,
                _commentKeys,
                _scrollController,
              ),
              SizedBox(height: long(context, ratio: 0.25)),
            ],
          ),
          clavierDuBas(context, widget.idProduit, () {
            setState(() {});
          }),
        ],
      ),
    );
  }
}

/*Widget fenetreCommentaire00(
  BuildContext context,
  String idProduit,
  Map<String, GlobalKey> commentKeys,
  ScrollController scrollController,
) {
  return StreamBuilder(
    stream: CloudFirestore().lectureBdd(
      "commentaires",
      filtreCompose: cd("idProduits", idProduit),
    ),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Text('Erreur : \${snapshot.error}');
      }

      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return const Text('Aucun commentaire trouvé');
      }

      final docs = CloudFirestore().trierDocs(snapshot.data!.docs, [
        "dateTime",
        true,
      ]);

      final List<Map<String, dynamic>> parents = [];
      final Map<String, List<Map<String, dynamic>>> mapReponses = {};

      for (final doc in docs) {
        final data = doc.data() as Map<String, dynamic>;
        final commentaire = {
          'id': doc.id,
          'avatar': data["avatar"] ?? '',
          'username': data["nomUser"] ?? '',
          'comment': data["commentaire"] ?? '',
          'dateTime': data["dateTime"],
        };

        if (data["principal"] == true) {
          parents.add(commentaire);
        } else {
          final idParent = data["idCommentaireParent"];
          mapReponses.putIfAbsent(idParent, () => []).add(commentaire);
        }
      }

      return ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: parents.map((parent) {
          final List<Map<String, dynamic>> replies =
              mapReponses[parent["id"]] ?? [];

          commentKeys.putIfAbsent(parent["id"], () => GlobalKey());

          return Container(
            key: commentKeys[parent["id"]],
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(5),
            margin: const EdgeInsets.all(6),
            child: buildCommentWithReplies(
              context,
              parentComment: parent,
              replies: replies,
              onReplyTap: () async {
                rangCommentaire.value = 1;
                controlRepondreAvide.text = parent["username"];
                idCommentairePrincipaleRepondu = parent["id"];

                final key = commentKeys[parent["id"]];
                if (key != null && key.currentContext != null) {
                  final box =
                      key.currentContext!.findRenderObject() as RenderBox;
                  final offset = box.localToGlobal(Offset.zero).dy;
                  final topOffset =
                      MediaQuery.of(context).padding.top + kToolbarHeight;
                  await scrollController.animateTo(
                    scrollController.offset + offset - topOffset - 10,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              },
            ),
          );
        }).toList(),
      );
    },
  );
}*/

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

Widget fenetreCommentaire(
  BuildContext context,
  Function setStating,
  String idProduit,
  Map<String, GlobalKey> commentKeys,
  ScrollController scrollController,
) {
  return StreamBuilder(
    stream: CloudFirestore().lectureBdd(
      "commentaires",
      filtreCompose: cd("idProduits", idProduit),
    ),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Text('Erreur : \${snapshot.error}');
      }

      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return const Text('Aucun commentaire trouvé');
      }

      final docs = CloudFirestore().trierDocs(snapshot.data!.docs, [
        "dateTime",
        true,
      ]);

      final List<Map<String, dynamic>> parents = [];
      final Map<String, List<Map<String, dynamic>>> mapReponses = {};

      for (final doc in docs) {
        final data = doc.data() as Map<String, dynamic>;
        final commentaire = {
          'id': doc.id,
          'avatar': data["avatar"] ?? '',
          'username': data["nomUser"] ?? '',
          'comment': data["commentaire"] ?? '',
          'dateTime': data["dateTime"],
          "lienImageCommentaire": data["lienImageCommentaire"] ?? "",
          "idUser": data["idUser"] ?? '',
        };

        if (data["principal"] == true) {
          parents.add(commentaire);
        } else {
          final idParent = data["idCommentaireParent"];
          mapReponses.putIfAbsent(idParent, () => []).add(commentaire);
        }
      }

      return ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: parents.map((parent) {
          final List<Map<String, dynamic>> replies =
              mapReponses[parent["id"]] ?? [];

          commentKeys.putIfAbsent(parent["id"], () => GlobalKey());

          return Container(
            key: commentKeys[parent["id"]],
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(5),
            margin: const EdgeInsets.all(6),
            child: buildCommentWithReplies(
              context,
              setStating,
              parentComment: parent,
              replies: replies,
              onReplyTap: () async {
                rangCommentaire.value = 1;
                controlRepondreAvide.text = parent["username"];
                idCommentairePrincipaleRepondu = parent["id"];
                setStating();
                focusNodeCommentaire.unfocus();
                focusNodeCommentaire.requestFocus();

                final key = commentKeys[parent["id"]];
                if (key != null && key.currentContext != null) {
                  final box =
                      key.currentContext!.findRenderObject() as RenderBox;
                  final offset = box.localToGlobal(Offset.zero).dy;
                  final topOffset =
                      MediaQuery.of(context).padding.top + kToolbarHeight;
                  await scrollController.animateTo(
                    scrollController.offset + offset - topOffset - 30,
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.easeInOut,
                  );
                }

                //FocusScope.of(context).unfocus();

                //focusNodeCommentaire.
              },
            ),
          );
        }).toList(),
      );
    },
  );
}

Widget buildCommentWithReplies(
  BuildContext context,
  Function setStating, {
  required Map<String, dynamic> parentComment,
  required List<Map<String, dynamic>> replies,
  required VoidCallback onReplyTap,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      GestureDetector(
        onLongPress: () {
          if (AuthFirebase().currentUser?.uid == parentComment["idUser"]) {
            afficherOptionsCommentaire(
              context,
              onCopier: () {
                Clipboard.setData(
                  ClipboardData(text: parentComment["comment"]),
                );
              },
              onModifier: () {
                afficherOptionsModifierCommentaire(
                  context,
                  parentComment["id"],
                  setStating,
                  commentaireInitial: parentComment["comment"],
                );
              },
              onSupprimer: () {
                suprimerCommentaire(context, parentComment["id"]);
              },
            );
          }
        },

        child: Row(
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
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    parentComment['comment'] ?? '',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 6),
                  (parentComment['lienImageCommentaire'] ?? '') == ""
                      ? SizedBox()
                      : Container(
                          height: long(context, ratio: 0.2),
                          child: imageNetwork(
                            context,
                            parentComment['lienImageCommentaire'] ?? '',
                          ),
                        ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        formaterDateHeure(
                          parentComment['dateTime'] as Timestamp,
                        ),
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 16),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(40, 20),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                        ),
                        child: const Text(
                          'J’aime',
                          style: TextStyle(fontSize: 13, color: Colors.blue),
                        ),
                      ),
                      SizedBox(width: 7),
                      TextButton(
                        onPressed: onReplyTap,
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(40, 20),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                        ),
                        child: const Text(
                          'Répondre',
                          style: TextStyle(fontSize: 13, color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 8),
      ...replies.map((reply) {
        return Padding(
          padding: const EdgeInsets.only(left: 40, top: 8),
          child: GestureDetector(
            onLongPress: () {
              if (AuthFirebase().currentUser?.uid == reply["idUser"]) {
                afficherOptionsCommentaire(
                  context,
                  onCopier: () {
                    Clipboard.setData(ClipboardData(text: reply["comment"]));
                  },
                  onModifier: () {
                    afficherOptionsModifierCommentaire(
                      context,
                      reply["id"],
                      setStating,
                      commentaireInitial: reply["comment"],
                    );
                  },
                  onSupprimer: () {
                    suprimerCommentaire(context, reply["id"]);
                  },
                );
              }
            },

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
                        style: const TextStyle(fontSize: 12),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        reply['comment'] ?? '',
                        style: const TextStyle(fontSize: 16),
                      ),

                      const SizedBox(height: 6),
                      (reply['lienImageCommentaire'] ?? '') == ""
                          ? SizedBox()
                          : Container(
                              height: long(context, ratio: 0.2),
                              child: imageNetwork(
                                context,
                                reply['lienImageCommentaire'] ?? '',
                              ),
                            ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Text(
                            formaterDateHeure(reply['dateTime'] as Timestamp),
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 6),
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(40, 20),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              visualDensity: VisualDensity.compact,
                            ),
                            child: const Text(
                              'J’aime',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    ],
  );
}

final FocusNode focusNodeCommentaire = FocusNode();
bool isloading = false;
Map<String, dynamic> image = {
  'lien': "",
  "image": null,
  "message": "commentaire",
};
Widget clavierDuBas(
  BuildContext context,
  String idProduit,
  Function setStating,
) {
  return Align(
    alignment: Alignment.bottomCenter,
    child: SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ValueListenableBuilder<int>(
            valueListenable: rangCommentaire,
            builder: (context, value, child) {
              if (value == 0) return const SizedBox();

              return Container(
                decoration: BoxDecoration(color: Colors.grey.shade200),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Répondre à ${controlRepondreAvide.text}",
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        rangCommentaire.value = 0;
                        controlRepondreAvide.clear();
                      },
                      icon: const Icon(Icons.close, color: Colors.grey),
                    ),
                  ],
                ),
              );
            },
          ),
          image["image"] != null
              ? Container(
                  height: larg(context, ratio: 0.17),
                  width: double.infinity,
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.all(5),
                        child: Image.file(File(image["image"].path)),
                      ),
                      Center(
                        child: IconButton(
                          onPressed: () {
                            image = {
                              "lien": "",
                              "image": null,
                              "message": "commentaires",
                            };
                            setStating();
                          },
                          icon: Icon(Icons.close),
                        ),
                      ),
                    ],
                  ),
                )
              : SizedBox(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    focusNode: focusNodeCommentaire,
                    controller: textCommentaire,
                    decoration: InputDecoration(
                      suffixIcon: SizedBox(
                        //color: Colors.red,
                        width: larg(context, ratio: 0.16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () async {
                                image = await imageUser();
                                setStating();
                              },
                              icon: Icon(Icons.photo),
                            ),
                            IconButton(
                              onPressed: () async {
                                image = await imageUser(camera: true);
                                setStating();
                              },
                              icon: Icon(Icons.add_a_photo),
                            ),
                          ],
                        ),
                      ),
                      hintText: "Écrire un commentaire...",
                      filled: true,
                      fillColor: const Color.fromARGB(255, 219, 217, 216),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                isloading
                    ? circular(message: "")
                    : Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFBE4A00),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_upward,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            isloading = true;
                            setStating();

                            if (textCommentaire.text.isNotEmpty ||
                                image["image"] != null) {
                              final success = await ajouterCommentairePrincipal(
                                context,
                                idProduit,
                                textCommentaire.text,
                              );
                              if (!success) {
                                messageErreurBar(
                                  context,
                                  messageErr: "Une erreur est survenue",
                                );
                              } else {
                                image = {
                                  "lien": "",
                                  "image": null,
                                  "message": "commentaire",
                                };
                                textCommentaire.text = "";
                                setStating();
                              }
                            }
                            isloading = false;
                            setStating();
                          },
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

/// Fonction qui construit un widget de commentaire avec ses réponses

TextEditingController controlRepondreAvide = TextEditingController();
TextEditingController textCommentaire = TextEditingController();
ValueNotifier<int> rangCommentaire = ValueNotifier(0);

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
  String lienImageCommentaire = "";

  if (idUser == null || !etatCon) {
    messageErreurBar(context, messageErr: "Vous n'ètes pas connecté");
    return false;
  }

  if (image["image"] != null) {
    lienImageCommentaire = await envoieImage(image["image"]);
  }

  //

  final lecture = await CloudFirestore().lectureUBdd("users", idDoc: idUser);
  if (lecture != null && lecture is DocumentSnapshot) {
    final data = lecture.data() as Map<String, dynamic>;
    avatar = data["avatar"] == "" ? avatar : data["avatar"];
    nomUser = data["nom"];
  }

  Map<String, dynamic> comm = {};
  if (rangCommentaire.value == 0) {
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
      "lienImageCommentaire": lienImageCommentaire,
      "dateTime": await dd(),
    };
  } else if (rangCommentaire.value == 1) {
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
      "lienImageCommentaire": lienImageCommentaire,
      "dateTime": await dd(),
    };
  } else if (rangCommentaire.value == 2) {
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
      "lienImageCommentaire": lienImageCommentaire,
      "dateTime": await dd(),
    };
  }

  rangCommentaire.value = 0;
  controlRepondreAvide.clear();

  //print(comm);
  //FocusScope.of(context).unfocus();
  return await CloudFirestore().ajoutBdd("commentaires", comm);
}

String formaterDateHeure(Timestamp timestamp) {
  final date = timestamp.toDate();
  final now = DateTime.now();
  final diff = now.difference(date);

  if (diff.inMinutes < 1) return "À l’instant";
  if (diff.inMinutes < 60) return "${diff.inMinutes} min";
  if (diff.inHours < 24) return "${diff.inHours} h";
  if (diff.inDays == 1) return "Hier";
  return "${date.day}/${date.month}/${date.year}";
}

void afficherOptionsCommentaire(
  BuildContext context, {
  required VoidCallback onSupprimer,
  required VoidCallback onModifier,
  required VoidCallback onCopier,
}) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    backgroundColor: Colors.white,
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: Text("Supprimer"),
              onTap: () {
                Navigator.pop(context); // Ferme la fenêtre
                onSupprimer();
              },
            ),
            ListTile(
              leading: Icon(Icons.edit, color: Colors.blue),
              title: Text("Modifier"),
              onTap: () {
                Navigator.pop(context);
                onModifier();
              },
            ),
            ListTile(
              leading: Icon(Icons.copy, color: Colors.green),
              title: Text("Copier"),
              onTap: () {
                Navigator.pop(context);
                onCopier();
              },
            ),
          ],
        ),
      );
    },
  );
}

bool isloadinModification = false;
void afficherOptionsModifierCommentaire(
  BuildContext context,
  String idCommentaire,
  Function setStating, {
  String commentaireInitial = "Commentaire",
}) {
  final TextEditingController controller = TextEditingController(
    text: commentaireInitial,
  );
  final FocusNode focusNode = FocusNode();

  controller.text = commentaireInitial;
  focusNode.requestFocus();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    backgroundColor: Colors.white,
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              focusNode: focusNode,
              controller: controller,
              decoration: InputDecoration(
                hintText: "Modifier votre commentaire...",
                filled: true,
                fillColor: Color.fromARGB(255, 240, 240, 240),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              maxLines: null,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context); // Ferme sans action
                    },
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text("Annuler"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: isloadinModification
                        ? null
                        : () async {
                            isloadinModification = true;
                            setStating();
                            if (!await CloudFirestore()
                                .checkConnexionFirestore()) {
                              messageErreurBar(
                                context,
                                messageErr: "Vérifiez votre connection !",
                              );
                              return;
                            } else {
                              CloudFirestore().modif(
                                "commentaires",
                                idCommentaire,
                                {"commentaire": controller.text},
                              );
                              Navigator.pop(context);
                            }

                            isloadinModification = false;
                            setStating();
                            //onValider(controller.text.trim());
                          },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: isloadinModification
                        ? circular(message: "")
                        : Text("Modifier"),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}

void suprimerCommentaire(BuildContext context, String idCommentaire) async {
  final CloudFirestore bdd = CloudFirestore();

  if (!await CloudFirestore().checkConnexionFirestore()) {
    messageErreurBar(context, messageErr: "Vous n'êtes pas connecté");
    return;
  }

  final enfant = await bdd.lectureUBdd(
    "commentaires",
    filtreCompose: cd("idCommentaireParent", idCommentaire),
  );
  if (enfant != null && enfant.docs.isNotEmpty) {
    final docs = enfant.docs;

    for (var i = 0; i < docs.length; i++) {
      final data = docs[i].data() as Map<String, dynamic>;

      supprimerImage(data["lienImageCommentaire"]);

      bdd.sup("commentaires", docs[i].id);
    }
  }

  bdd.sup("commentaires", idCommentaire);
}
