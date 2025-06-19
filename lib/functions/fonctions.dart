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
}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(borderRadius), // ajuste le rayon ici
    child: CachedNetworkImage(
      imageUrl: lienImage,
      fit: BoxFit.cover, // optionnel, pour remplir le conteneur proprement
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
          child: imageNetwork0(context, lienImage, borderRadius: borderRadius),
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

// h1
Widget h1(
  BuildContext context, {
  String texte = "Titre 1",
  Color couleur = Colors.black,
  int nbrDeLigneMax = 1,
}) {
  return AutoSizeText(
    texte,
    maxLines: nbrDeLigneMax,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      fontSize: long(context, ratio: 0.045),
      fontWeight: FontWeight.bold,
      color: couleur,
    ),
  );
}

Widget h2(
  BuildContext context, {
  String texte = "Titre 2",
  Color couleur = Colors.black,
  int nbrDeLigneMax = 1,
}) {
  return AutoSizeText(
    texte,
    maxLines: nbrDeLigneMax,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      fontSize: long(context, ratio: 0.04),
      fontWeight: FontWeight.w700,
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
}) {
  return AutoSizeText(
    texte,
    maxLines: nbrDeLigneMax,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      fontSize: long(context, ratio: 0.035),
      fontWeight: FontWeight.w600,
      color: couleur,
    ),
  );
}

Widget h4(
  BuildContext context, {
  String texte = "Titre 4",
  Color couleur = Colors.black,
  int nbrDeLigneMax = 1,
}) {
  return AutoSizeText(
    texte,
    maxLines: nbrDeLigneMax,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      fontSize: long(context, ratio: 0.03),
      fontWeight: FontWeight.w500,
      color: couleur,
    ),
  );
}

Widget h5(
  BuildContext context, {
  String texte = "Titre 5",
  Color couleur = Colors.black,
  int nbrDeLigneMax = 1,
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
}) {
  return AutoSizeText(
    texte,
    maxLines: nbrDeLigneMax,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      fontSize: long(context, ratio: 0.02),
      fontWeight: FontWeight.w300,
      color: couleur,
    ),
  );
}

Widget h7(
  BuildContext context, {
  String texte = "Titre 7",
  Color couleur = Colors.black,
  int nbrDeLigneMax = 1,
}) {
  return AutoSizeText(
    texte,
    maxLines: nbrDeLigneMax,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      fontSize: long(context, ratio: 0.018),
      fontWeight: FontWeight.w300,
      color: couleur,
    ),
  );
}

Widget h8(
  BuildContext context, {
  String texte = "Titre 8",
  Color couleur = Colors.black,
  int nbrDeLigneMax = 1,
}) {
  return AutoSizeText(
    texte,
    maxLines: nbrDeLigneMax,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      fontSize: long(context, ratio: 0.016),
      fontWeight: FontWeight.w300,
      color: couleur,
    ),
  );
}

Widget h9(
  BuildContext context, {
  String texte = "Titre 9",
  Color couleur = Colors.black,
  int nbrDeLigneMax = 1,
}) {
  return AutoSizeText(
    texte,
    maxLines: nbrDeLigneMax,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      fontSize: long(context, ratio: 0.014),
      fontWeight: FontWeight.w300,
      color: couleur,
    ),
  );
}

Widget h10(
  BuildContext context, {
  String texte = "Titre 10",
  Color couleur = Colors.black,
  int nbrDeLigneMax = 1,
}) {
  return AutoSizeText(
    texte,
    maxLines: nbrDeLigneMax,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      fontSize: long(context, ratio: 0.012),
      fontWeight: FontWeight.w300,
      color: couleur,
    ),
  );
}
