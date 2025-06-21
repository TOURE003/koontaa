import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:koontaa/pages/compte/connection/page_connection.dart';
import 'dart:math';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:flutter_html/flutter_html.dart';

Widget html(String htmlCode, {Map<String, Style>? styleCss}) {
  return SingleChildScrollView(
    child: Html(data: htmlCode, style: styleCss ?? {}),
  );
}

void changePage(BuildContext context, Widget page) {
  try {
    //Navigator.push(context, MaterialPageRoute(builder: (context) => page));
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  } catch (e) {}
}

Color couleurDeApp() {
  return Color(0xFFF9EFE0);
  // BE4A00
}

String genererCodeAleatoire({int longueur = 50}) {
  const String caracteres = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  Random random = Random();
  return List.generate(
    longueur,
    (index) => caracteres[random.nextInt(caracteres.length)],
  ).join();
}

void envoyerEmail(
  String mailDestinataire, {
  String sujet = "Info Koontaa",
  String corpsMessage = "Message",
}) async {
  final smtpServer = gmail(
    'toureabdoulaye003@gmail.com',
    'efdv numh rmoq xmes',
  );

  final message = Message()
    ..from = Address('toureabdoulaye003@gmail.com', 'Koontaa')
    ..recipients.add(mailDestinataire)
    ..subject = 'Sujet du message'
    ..html = corpsMessage;

  try {
    final sendReport = await send(message, smtpServer);
  } catch (e) {
    print('Erreur : $e');
  }
}

String templateHtmlCompteConfirmation({
  String nom = "name",
  String mail = "koontaa@",
  String motDePasse = "pass",
}) {
  return '''<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bienvenue sur Koontaa !</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f4;
            color: #333;
        }
        .email-container {
            max-width: 600px;
            margin: 20px auto;
            background-color: #F9EFE0;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            text-align: center;
        }
        .header {
            background: #BE4A00;
            color: white;
            padding: 20px;
        }
        .header h1 {
            margin: 0;
            font-size: 24px;
        }
        .content {
            padding: 20px;
        }
        .content p {
            font-size: 16px;
            line-height: 1.6;
        }
        .details {
            background: white;
            padding: 15px;
            border-radius: 5px;
            margin: 15px 0;
            font-size: 16px;
            
            color: black;
        }
        .button {
            display: inline-block;
            background-color: #BE4A00;
            color: white;
            padding: 12px 20px;
            font-size: 16px;
            text-decoration: none;
            border-radius: 5px;
            margin-top: 15px;
        }
        .button:hover {
            background-color: #BE4A00;
        }
        .footer {
            background: #f9f9f9;
            color: #666;
            font-size: 12px;
            padding: 10px 20px;
            text-align: center;
        }
    </style>
</head>
<body >
    <div class="email-container">
        <div class="header">
            <h1>Bienvenue sur Koontaa ! 🚀</h1>
        </div>
        <div class="content">
            <p>Bonjour <strong>Mr $nom</strong>,</p>
            <p>Nous sommes ravis de vous accueillir sur **Koontaa**, la plateforme qui connecte acheteurs et vendeurs en toute simplicité !</p>
            <p>Voici vos informations de connexion :</p>
            <div class="details">
                📧 <strong>E-mail :</strong> $mail<br>
                🔑 <strong>Mot de passe :</strong> $motDePasse
            </div>
            <p>Vous pouvez modifier ces information des connection. Dans l'application, dans votre compte cliquer sur l'option sécurité !</p>
            <a class="button" href="{{confirmation_link}}">Continuer sur Koontaa</a>
            <p>Si vous n'avez pas initié cette inscription, vous pouvez simplement ignorer ce message.</p>
        </div>
        <div class="footer">
            <p>&copy; 2025 Koontaa | Tous droits réservés.</p>
            <p>Merci de faire confiance à **Koontaa** ! 🚀</p>
        </div>
    </div>
</body>
</html>''';
}

String templateHtmlMotDePasseOublie({
  String nom = "name",
  String mail = "koontaa@",
  String motDePasse = "pass",
}) {
  return '''<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bienvenue sur Koontaa !</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f4;
            color: #333;
        }
        .email-container {
            max-width: 600px;
            margin: 20px auto;
            background-color: #F9EFE0;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            text-align: center;
        }
        .header {
            background: #BE4A00;
            color: white;
            padding: 20px;
        }
        .header h1 {
            margin: 0;
            font-size: 24px;
        }
        .content {
            padding: 20px;
        }
        .content p {
            font-size: 16px;
            line-height: 1.6;
        }
        .details {
            background: white;
            padding: 15px;
            border-radius: 5px;
            margin: 15px 0;
            font-size: 16px;
            
            color: black;
        }
        .button {
            display: inline-block;
            background-color: #BE4A00;
            color: white;
            padding: 12px 20px;
            font-size: 16px;
            text-decoration: none;
            border-radius: 5px;
            margin-top: 15px;
        }
        .button:hover {
            background-color: #BE4A00;
        }
        .footer {
            background: #f9f9f9;
            color: #666;
            font-size: 12px;
            padding: 10px 20px;
            text-align: center;
        }
    </style>
</head>
<body >
    <div class="email-container">
        <div class="header">
            <h1>Vos acces à Koontaa</h1>
        </div>
        <div class="content">
            <p>Bonjour <strong>Mr $nom</strong>,</p>
            <p>Voici vos informations de connexion :</p>
            <div class="details">
                📧 <strong>E-mail :</strong> $mail<br>
                🔑 <strong>Mot de passe :</strong> $motDePasse
            </div>
            <p>Vous pouvez modifier ces information de connection. Dans l'application, dans votre compte cliquer sur l'option sécurité !</p>
            <a class="button" href="{{confirmation_link}}">Continuer sur Koontaa</a>
            <p>Si vous n'avez pas initié cette inscription, vous pouvez simplement ignorer ce message.</p>
        </div>
        <div class="footer">
            <p>&copy; 2025 Koontaa | Tous droits réservés.</p>
            <p>Merci de faire confiance à **Koontaa** ! 🚀</p>
        </div>
    </div>
</body>
</html>''';
}

double larg(BuildContext context, {double ratio = 1}) {
  return MediaQuery.of(context).size.width * ratio;
}

double long(BuildContext context, {double ratio = 1}) {
  return MediaQuery.of(context).size.height * ratio;
}

Widget imageNetwork0(
  BuildContext context,
  String lienImage, {
  double borderRadius = 5,
  bool pleinW = true,
}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(borderRadius), // ajuste le rayon ici
    child: CachedNetworkImage(
      imageUrl: lienImage,
      fit: pleinW
          ? BoxFit.cover
          : BoxFit.contain, // optionnel, pour remplir le conteneur proprement
      progressIndicatorBuilder: (context, url, downloadProgress) =>
          Center(child: circular(message: "")),
      errorWidget: (context, url, error) => Icon(Icons.error),
    ),
  );
}

final connectionChecker = InternetConnectionChecker.instance;
Stream<bool> get etaConection => connectionChecker.onStatusChange.map(
  (status) => status == InternetConnectionStatus.connected,
);

//List<String> listeLienImagesChargee = [];

Widget imageNetwork(
  BuildContext context,
  String lienImage, {
  double borderRadius = 5,
  bool pleinW = true,
}) {
  return StreamBuilder<bool>(
    stream: etaConection,
    builder: (context, snapshot) {
      try {
        final estConnecte = snapshot.data!;
        //print(estConnecte);
        if (estConnecte) {
          return imageNetwork0(
            context,
            lienImage,
            borderRadius: borderRadius,
          ); // pour mettre l'image en cache
        } else {
          return SizedBox(
            child: imageNetwork0(
              context,
              lienImage,
              borderRadius: borderRadius,
            ),
          );
        }
      } catch (e) {
        return SizedBox(
          child: imageNetwork0(
            context,
            lienImage,
            borderRadius: borderRadius,
            pleinW: pleinW,
          ),
        );
      }
    },
  );
}

String arg(montant) {
  final nombre = montant.toString();
  final buffer = StringBuffer();
  int compteur = 0;

  for (int i = nombre.length - 1; i >= 0; i--) {
    buffer.write(nombre[i]);
    compteur++;

    if (compteur % 3 == 0 && i != 0) {
      buffer.write(' ');
    }
  }

  return buffer.toString().split('').reversed.join();
}

double valeurDeLaNOte = 5;
Widget noteArticle(
  BuildContext context, {
  double note = 5,
  bool modifiable = false,
  double taille = 20,
}) {
  if (modifiable) {
    return RatingBar.builder(
      initialRating: note,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemSize: taille,
      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
      onRatingUpdate: (rating) {
        valeurDeLaNOte = rating;
        //print("Nouvelle note : $rating");
        // Sauvegarde dans ta base ici si nécessaire
      },
    );
  }

  return RatingBarIndicator(
    rating: note,
    itemBuilder: (context, index) => Icon(Icons.star, color: Colors.amber),
    itemCount: 5,
    itemSize: taille,
    direction: Axis.horizontal,
  );
}

// h1
Widget h1(
  BuildContext context, {
  String texte = "Titre 1",
  Color couleur = Colors.black,
  int nbrDeLigneMax = 1,
  bool gras = true,
}) {
  return AutoSizeText(
    texte,
    maxLines: nbrDeLigneMax,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      fontSize: long(context, ratio: 0.045),
      fontWeight: gras ? FontWeight.bold : FontWeight.normal,
      color: couleur,
    ),
  );
}

Widget h2(
  BuildContext context, {
  String texte = "Titre 2",
  Color couleur = Colors.black,
  int nbrDeLigneMax = 1,
  bool gras = false,
}) {
  return AutoSizeText(
    texte,
    maxLines: nbrDeLigneMax,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      fontSize: long(context, ratio: 0.04),
      fontWeight: gras ? FontWeight.bold : FontWeight.w700,
      fontStyle: FontStyle.italic,
      color: couleur,
    ),
  );
}

Widget h3(
  BuildContext context, {
  String texte = "Titre 3",
  Color couleur = Colors.black,
  int nbrDeLigneMax = 1,
  bool gras = true,
}) {
  return AutoSizeText(
    texte,
    maxLines: nbrDeLigneMax,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      fontSize: long(context, ratio: 0.035),
      fontWeight: gras ? FontWeight.w600 : FontWeight.normal,
      color: couleur,
    ),
  );
}

Widget h4(
  BuildContext context, {
  String texte = "Titre 4",
  Color couleur = Colors.black,
  int nbrDeLigneMax = 1,
  bool gras = false,
}) {
  return AutoSizeText(
    texte,
    maxLines: nbrDeLigneMax,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      fontSize: long(context, ratio: 0.03),
      fontWeight: gras ? FontWeight.bold : FontWeight.w500,
      color: couleur,
    ),
  );
}

Widget h5(
  BuildContext context, {
  String texte = "Titre 5",
  Color couleur = Colors.black,
  int nbrDeLigneMax = 1,
  bool gras = false,
}) {
  return AutoSizeText(
    texte,
    maxLines: nbrDeLigneMax,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      fontSize: long(context, ratio: 0.025),
      fontWeight: FontWeight.w400,
      color: couleur,
    ),
  );
}

Widget h6(
  BuildContext context, {
  String texte = "Titre 6",
  Color couleur = Colors.black,
  int nbrDeLigneMax = 1,
  bool gras = false,
}) {
  return AutoSizeText(
    texte,
    maxLines: nbrDeLigneMax,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      fontSize: long(context, ratio: 0.02),
      fontWeight: gras ? FontWeight.bold : FontWeight.w300,
      color: couleur,
    ),
  );
}

Widget h7(
  BuildContext context, {
  String texte = "Titre 7",
  Color couleur = Colors.black,
  int nbrDeLigneMax = 1,
  bool gras = false,
}) {
  return AutoSizeText(
    texte,
    maxLines: nbrDeLigneMax,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      fontSize: long(context, ratio: 0.018),
      fontWeight: gras ? FontWeight.bold : FontWeight.w300,
      color: couleur,
    ),
  );
}

Widget h8(
  BuildContext context, {
  String texte = "Titre 8",
  Color couleur = Colors.black,
  int nbrDeLigneMax = 1,
  bool gras = false,
}) {
  return AutoSizeText(
    texte,
    maxLines: nbrDeLigneMax,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      fontSize: long(context, ratio: 0.016),
      fontWeight: gras ? FontWeight.bold : FontWeight.w300,
      color: couleur,
    ),
  );
}

Widget h9(
  BuildContext context, {
  String texte = "Titre 9",
  Color couleur = Colors.black,
  int nbrDeLigneMax = 1,
  bool gras = false,
}) {
  return AutoSizeText(
    texte,
    maxLines: nbrDeLigneMax,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      fontSize: long(context, ratio: 0.014),
      fontWeight: gras ? FontWeight.bold : FontWeight.w300,
      color: couleur,
    ),
  );
}

Widget h10(
  BuildContext context, {
  String texte = "Titre 10",
  Color couleur = Colors.black,
  int nbrDeLigneMax = 1,
  bool gras = false,
}) {
  return AutoSizeText(
    texte,
    maxLines: nbrDeLigneMax,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      fontSize: long(context, ratio: 0.012),
      fontWeight: gras ? FontWeight.bold : FontWeight.w300,
      color: couleur,
    ),
  );
}

class TexteClignotant extends StatefulWidget {
  final String texte;
  final TextStyle? style;
  final Duration duree;

  const TexteClignotant({
    Key? key,
    required this.texte,
    this.style,
    this.duree = const Duration(milliseconds: 500),
  }) : super(key: key);

  @override
  _TexteClignotantState createState() => _TexteClignotantState();
}

class _TexteClignotantState extends State<TexteClignotant>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duree)
      ..repeat(reverse: true); // fait clignoter indéfiniment

    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.3,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: Text(
        widget.texte,
        style: widget.style ?? const TextStyle(fontSize: 16, color: Colors.red),
      ),
    );
  }
}

class MenuContextuelAnime extends StatefulWidget {
  final List<MenuAction> actions;

  const MenuContextuelAnime({Key? key, required this.actions})
    : super(key: key);

  @override
  State<MenuContextuelAnime> createState() => _MenuContextuelAnimeState();
}

class _MenuContextuelAnimeState extends State<MenuContextuelAnime>
    with SingleTickerProviderStateMixin {
  final GlobalKey _key = GlobalKey();
  OverlayEntry? _overlayEntry;
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _overlayEntry?.remove();
    super.dispose();
  }

  void _toggleMenu() {
    if (_overlayEntry != null) {
      _closeMenu();
    } else {
      _showMenu();
    }
  }

  void _showMenu() {
    RenderBox renderBox = _key.currentContext!.findRenderObject() as RenderBox;
    Offset offset = renderBox.localToGlobal(Offset.zero);
    Size size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // ➤ Touche extérieure = fermeture du menu
          GestureDetector(
            onTap: _closeMenu,
            behavior: HitTestBehavior.translucent,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.transparent,
            ),
          ),

          // ➤ Menu animé
          Positioned(
            top: offset.dy + size.height,
            left: offset.dx - 100,
            child: Material(
              color: Colors.transparent,
              child: ScaleTransition(
                scale: CurvedAnimation(
                  parent: _controller,
                  curve: Curves.easeOutBack,
                ),
                child: FadeTransition(
                  opacity: _controller,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    width: 160,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 12,
                          color: Colors.black26,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: widget.actions.map((action) {
                        return InkWell(
                          onTap: () {
                            action.onTap();
                            _closeMenu();
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  action.icon,
                                  color: action.couleur,
                                  size: 20,
                                ),
                                const SizedBox(width: 10),
                                Text(action.texte),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    _controller.forward();
  }

  void _closeMenu() {
    _controller.reverse().then((_) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: _key,
      onTap: _toggleMenu,
      child: const Icon(Icons.more_vert, color: Colors.black),
    );
  }
}

// ➤ Classe pour chaque action du menu
class MenuAction {
  final String texte;
  final IconData icon;
  final Color couleur;
  final VoidCallback onTap;

  MenuAction({
    required this.texte,
    required this.icon,
    required this.couleur,
    required this.onTap,
  });
}
