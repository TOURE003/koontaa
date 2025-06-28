import 'dart:io';
import 'dart:math';

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
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:url_launcher/url_launcher.dart';

class PageAvecChampFixe extends StatefulWidget {
  final String idProduit;
  final List<dynamic> urlImgProduit;
  final String nomArticle;
  final String prixArticle;

  const PageAvecChampFixe({
    super.key,
    required this.idProduit,
    required this.urlImgProduit,
    required this.nomArticle,
    required this.prixArticle,
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            h5(context, texte: widget.nomArticle, couleur: Colors.white),
            h5(
              context,
              texte: "${arg(widget.prixArticle)} F",
              couleur: Colors.white,
            ),
          ],
        ),
        backgroundColor: Color(0xffBE4A00),
      ),
      body: Stack(
        children: [
          ListView(
            controller: _scrollController,
            padding: const EdgeInsets.all(8),
            children: [
              defilementImagesHorizontales(context, widget.urlImgProduit),

              SizedBox(height: 20),

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

Widget barreinfo(BuildContext context, String idProduit, int nbrCommentaire) {
  return Container(
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(5),
    ),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              child: Row(
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Row(children: [boutonLike(context, idProduit)]),
                  ),
                ],
              ),
            ),
            Container(
              child: Row(
                children: [
                  TextButton(
                    onPressed: () {
                      focusNodeCommentaire.requestFocus();
                    },
                    child: Row(
                      children: [
                        Icon(Icons.comment, size: 15),
                        SizedBox(width: 5),
                        h9(context, texte: "Commenter"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Row(
                children: [
                  TextButton(
                    onPressed: () async {
                      final Uri uri = Uri(
                        scheme: 'sms',
                        path: '+2250749797051',
                      );
                      if (!await launchUrl(uri)) {
                        messageErreurBar(
                          context,
                          messageErr: "Nous n'avons pas l'autorisation",
                        );
                      }
                    },
                    child: Row(
                      children: [
                        Icon(Icons.phone, size: 15),
                        SizedBox(width: 5),
                        h9(context, texte: "Contacter"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            /*Container(
              child: Row(
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Row(
                      children: [
                        Icon(Icons.share, size: 15),
                        SizedBox(width: 5),
                        h9(context, texte: "Partager"),
                      ],
                    ),
                  ),
                ],
              ),
            ),*/
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              //margin: EdgeInsets.only(left: 30),
              child: Row(children: [afficheLike(context, idProduit)]),
            ),
            Container(
              margin: EdgeInsets.only(left: 30),
              child: noteArticle(context, note: 2.5),
            ),
            Container(
              margin: EdgeInsets.only(left: 30),
              child: Row(
                children: [
                  h8(context, texte: "$nbrCommentaire "),
                  h8(
                    context,
                    texte: nbrCommentaire > 1 ? "Commentaires" : "Commentaire",
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

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
        return commentaireParDefaut(context);
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
          "jaimes": data["jaimes"] ?? [],
        };

        if (data["principal"] == true) {
          parents.add(commentaire);
        } else {
          final idParent = data["idCommentaireParent"];
          mapReponses.putIfAbsent(idParent, () => []).add(commentaire);
        }
      }

      return Column(
        children: [
          barreinfo(context, idProduit, docs.length),
          Column(
            //shrinkWrap: true,
            // physics: const NeverScrollableScrollPhysics(),
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
          ),
        ],
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
                        onPressed: () async {
                          if (AuthFirebase().currentUser == null) {
                            messageErreurBar(
                              context,
                              messageErr: "Vous n'êtes pas connecté",
                            );
                            return;
                          }
                          List tabJaime = parentComment["jaimes"] ?? [];
                          print(tabJaime);

                          //kkk.contains(element)
                          if (!tabJaime.contains(
                            AuthFirebase().currentUser!.uid,
                          )) {
                            tabJaime.add(AuthFirebase().currentUser!.uid);
                            CloudFirestore().modif(
                              "commentaires",
                              parentComment["id"],
                              {"jaimes": tabJaime},
                            );
                          } else {
                            print("object");
                            tabJaime.remove(AuthFirebase().currentUser!.uid);
                            CloudFirestore().modif(
                              "commentaires",
                              parentComment["id"],
                              {"jaimes": tabJaime},
                            );
                          }
                        },
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
                      SizedBox(width: larg(context, ratio: 0.25)),
                      parentComment["jaimes"].length == 0
                          ? SizedBox()
                          : Row(
                              children: [
                                Icon(Icons.thumb_up_alt_outlined, size: 15),
                                SizedBox(width: 5),
                                h9(
                                  context,
                                  texte: "${parentComment["jaimes"].length}",
                                ),
                              ],
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
                            onPressed: () async {
                              if (AuthFirebase().currentUser == null) {
                                messageErreurBar(
                                  context,
                                  messageErr: "Vous n'êtes pas connecté",
                                );
                                return;
                              }
                              List tabJaime = reply["jaimes"] ?? [];

                              //kkk.contains(element)
                              if (!tabJaime.contains(
                                AuthFirebase().currentUser!.uid,
                              )) {
                                tabJaime.add(AuthFirebase().currentUser!.uid);
                                CloudFirestore().modif(
                                  "commentaires",
                                  reply["id"],
                                  {"jaimes": tabJaime},
                                );
                              } else {
                                tabJaime.remove(
                                  AuthFirebase().currentUser!.uid,
                                );
                                CloudFirestore().modif(
                                  "commentaires",
                                  reply["id"],
                                  {"jaimes": tabJaime},
                                );
                              }
                            },
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

                          SizedBox(width: larg(context, ratio: 0.25)),
                          reply["jaimes"].length == 0
                              ? SizedBox()
                              : Row(
                                  children: [
                                    Icon(Icons.thumb_up_alt_outlined, size: 15),
                                    SizedBox(width: 5),
                                    h9(
                                      context,
                                      texte: "${reply["jaimes"].length}",
                                    ),
                                  ],
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

Widget commentaireParDefaut(BuildContext context) {
  return Container(
    margin: EdgeInsets.only(top: long(context, ratio: 0.06)),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Avatar circulaire
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage("assets/images/pakooTete01.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 12),

        // Texte et bouton
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Pakoo", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(
                "Soyez le premier à donner votre avis ! Partagez votre expérience ou posez une question sur ce produit.",
                style: TextStyle(color: Colors.black87),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  focusNodeCommentaire.requestFocus();
                },
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                child: Text("Répondre", style: TextStyle(color: Colors.blue)),
              ),
            ],
          ),
        ),
      ],
    ),
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
                padding: EdgeInsets.only(left: 20),
                decoration: BoxDecoration(color: Colors.white),
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
      "jaimes": [],
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
      "jaimes": [],
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
      "jaimes": [],
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

//import 'package:flutter_reaction_button/flutter_reaction_button.dart';
//import 'package:flutter_reaction_button/flutter_reaction_button.dart';

Widget boutonLike(BuildContext context, String idProduits) {
  return ReactionButton<String>(
    itemSize: Size(40, 40),
    onReactionChanged: (reaction) {
      //debugPrint('Valeur sélectionnée : ${reaction?.value}');
    },
    reactions: <Reaction<String>>[
      Reaction<String>(
        value: '1',
        icon: GestureDetector(
          onTap: () {
            ajouterReaction(context, idProduits, 1);
          },
          child: Image.asset("assets/images/likeGifPousse.gif"),
        ), //Icon(Icons.thumb_up_alt_outlined, color: Colors.grey)
      ),
      Reaction<String>(
        value: '2',
        icon: GestureDetector(
          onTap: () {
            ajouterReaction(context, idProduits, 2);
          },
          child: Image.asset("assets/images/likeGifCoeur.gif"),
        ),
      ),
      Reaction<String>(
        value: '3',
        icon: GestureDetector(
          onTap: () {
            ajouterReaction(context, idProduits, 3);
          },
          child: Image.asset("assets/images/likeGifSolidaireCoeur.gif"),
        ),
      ),
      Reaction<String>(
        value: '4',
        icon: GestureDetector(
          onTap: () {
            ajouterReaction(context, idProduits, 4);
          },
          child: Image.asset("assets/images/likeGifRire.gif"),
        ),
      ),
      Reaction<String>(
        value: '5',
        icon: GestureDetector(
          onTap: () {
            ajouterReaction(context, idProduits, 5);
          },
          child: Image.asset("assets/images/likeGIfEtone.gif"),
        ),
      ),
      Reaction<String>(
        value: '6',
        icon: GestureDetector(
          onTap: () {
            ajouterReaction(context, idProduits, 6);
          },
          child: Image.asset("assets/images/likeGifTriste.gif"),
        ),
      ),
      Reaction<String>(
        value: '7',
        icon: GestureDetector(
          onTap: () {
            ajouterReaction(context, idProduits, 7);
          },
          child: Image.asset("assets/images/likeGifColere.gif"),
        ),
      ),
    ],
    selectedReaction: Reaction<String>(
      value: '0',
      icon: Icon(Icons.thumb_up, color: Colors.blue),
    ),
    child: TextButton(
      onPressed: () {
        ajouterReaction(context, idProduits, 0);
      },
      child: StreamBuilder(
        stream: CloudFirestore().lectureBdd(
          "likes",
          filtreCompose: Filter.and(
            cd("idProduits", idProduits),
            cd("idUser", AuthFirebase().currentUser!.uid),
          ),
        ),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return SizedBox();
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Row(
              children: [Icon(Icons.thumb_up_alt_outlined), Text(" J'aime")],
            );
          }
          final docs = snapshot.data!.docs;
          final data = docs[0].data() as Map<String, dynamic>;
          return Row(
            children: [
              iconAff[data["type"] - 1],
              Text(
                " ${texteAff[data["type"] - 1]}",
                style: TextStyle(
                  color: data["type"] == 2 ? Colors.red : Colors.black,
                ),
              ),
            ],
          );
        },
      ),
    ),
  );
}

Widget afficheLike(BuildContext context, String idArticle) {
  //double taille = 15;
  List<int> tabTypLik = [];

  return StreamBuilder(
    stream: CloudFirestore().lectureBdd(
      "likes",
      filtreCompose: cd("idProduits", idArticle),
    ),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return SizedBox();
      }
      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return const SizedBox();
      }
      final docs = snapshot.data!.docs;
      tabTypLik = [];

      for (var i = 0; i < docs.length; i++) {
        final data = docs[i].data() as Map<String, dynamic>;
        tabTypLik.add(data["type"]);
      }

      //return Text(data["nom"] ?? "");

      List<bool> aff = [
        tabTypLik.contains(1),
        tabTypLik.contains(2),
        tabTypLik.contains(3),
        tabTypLik.contains(4),
        tabTypLik.contains(5),
        tabTypLik.contains(6),
        tabTypLik.contains(7),
      ];

      return Row(
        children: [
          iconLike(aff, iconAff, taille: 35),
          h8(context, texte: "${docs.length}"),
        ],
      );
    },
  );

  /*return Stack(
    children: [
      // Container du bas
      Container(
        width: taille,
        height: taille,
        //color: Colors.grey,
        child: Icon(Icons.favorite, size: taille, color: Colors.red),
      ),

      // Container du dessus avec décalage
      Positioned(
        top: 0,
        left: taille - 5,
        child: Container(
          width: taille,
          height: taille,
          child: Icon(
            Icons.abc_outlined,
            size: taille,
            color: const Color.fromARGB(255, 244, 219, 54),
          ),
        ),
      ),
    ],
  );*/
}

Widget iconLike(List<bool> aff, List<Widget> iconAff, {double taille = 15}) {
  List<Widget> tabStack = [];
  double decalage = 0;
  int compteur = 0;
  for (int i = 0; i < aff.length; i++) {
    if (compteur == 4) {
      break;
    }
    if (aff[i]) {
      tabStack.add(
        Positioned(
          left: decalage,
          child: Container(width: taille, height: taille, child: iconAff[i]),
        ),
      );
      decalage += taille * 0.6;
      compteur++; // superposition partielle (40% d’overlap)
    }
  }

  return SizedBox(
    height: taille,
    width: decalage + taille * 0.4,
    child: Stack(clipBehavior: Clip.none, children: tabStack),
  );
}

Future<bool> ajouterReaction(
  BuildContext context,
  String idProduits,
  int type,
) async {
  String? idUser = AuthFirebase().currentUser?.uid;
  //final bool etatCon = await CloudFirestore().checkConnexionFirestore();
  String avatar =
      "https://www.shutterstock.com/image-vector/user-profile-icon-vector-avatar-600nw-2558760599.jpg";

  String nomUser = "Indéfini";
  //String lienImageCommentaire = "";

  if (idUser == null) {
    messageErreurBar(context, messageErr: "Vous n'ètes pas connecté");
    return false;
  }

  final lectureLike = await CloudFirestore().lectureUBdd(
    "likes",
    filtreCompose: Filter.and(
      cd("idProduits", idProduits),
      cd("idUser", idUser),
    ),
  );

  if (lectureLike != null && lectureLike.docs.isNotEmpty) {
    final docs = lectureLike.docs;
    final data = docs[0].data() as Map<String, dynamic>;

    if (type == 0) {
      return await CloudFirestore().sup("likes", docs[0].id);
    } else {
      return await CloudFirestore().modif("likes", docs[0].id, {"type": type});
    }

    /*for (var i = 0; i < docs.length; i++) {
      final data = docs[i].data() as Map<String, dynamic>;

      supprimerImage(data["lienImageCommentaire"]);

      lectureLike.sup("commentaires", docs[i].id);
    }*/
  }

  /*if (image["image"] != null) {
    lienImageCommentaire = await envoieImage(image["image"]);
  }*/

  //

  final lecture = await CloudFirestore().lectureUBdd("users", idDoc: idUser);
  if (lecture != null && lecture is DocumentSnapshot) {
    final data = lecture.data() as Map<String, dynamic>;
    avatar = data["avatar"] == "" ? avatar : data["avatar"];
    nomUser = data["nom"];
  }

  Map<String, dynamic> comm = {};

  comm = {
    "idProduits": idProduits,
    "idUser": AuthFirebase().currentUser?.uid,
    //"idCommentaireParent": "",
    "nomUser": nomUser,
    "avatar": avatar,
    "type": type == 0 ? 1 : type,
    //"principal": true,
    //"rang": 0,
    //"reponseAidCommentaire": "",
    //"commentaire": commentaire,
    //"lienImageCommentaire": lienImageCommentaire,
    "dateTime": await dd(),
    //"jaimes": [],
  };

  return await CloudFirestore().ajoutBdd("likes", comm);
}

final List<Widget> iconAff = [
  Icon(Icons.thumb_up, color: Colors.blue, size: 20), // 👍 Like
  Icon(Icons.favorite, color: Colors.red, size: 20), // ❤️ Love
  Text("🤗", style: TextStyle(fontSize: 20)),
  Icon(Icons.emoji_emotions, color: Colors.orange, size: 20), // 😂 Haha
  Icon(
    Icons.emoji_objects,
    color: Colors.amber,
    size: 20,
  ), // 😮 Wow (icône symbolique)
  Icon(Icons.sentiment_dissatisfied, color: Colors.blue, size: 20), // 😢 Sad
  Icon(Icons.mood_bad, color: Colors.redAccent, size: 20), // 😡 Angry
];

final List<String> texteAff = [
  "J’aime", // 👍 Like
  "J’adore", // ❤️ Love
  "Magnifique", // 🤗 Care
  "Haha", // 😂 Haha
  "Wouah", // 😮 Wow
  "Triste", // 😢 Sad
  "Grrr", // 😡 Angry
];
