import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:koontaa/functions/cloud_firebase.dart';

Future<Map<String, dynamic>> imageUser({bool camera = false}) async {
  try {
    final picker = ImagePicker();
    final source = camera ? ImageSource.camera : ImageSource.gallery;
    final XFile? image = await picker.pickImage(source: source);

    if (image == null) {
      // L'utilisateur a annulé manuellement la sélection (pas un refus d'autorisation)
      return {"lien": "0", "image": null, "message": "annule"};
    }

    return {"lien": image.path, "image": image, "message": "ok"};
  } catch (e) {
    // Vérifie si l'erreur est liée à une autorisation refusée
    if (e.toString().contains("access_denied") ||
        e.toString().contains("Permission")) {
      return {"lien": "0", "image": null, "message": "autorisation"};
    } else {
      //print("Erreur lors de la sélection de l'image : $e");
    }

    return {"lien": "erreur", "image": null, "message": "erreur"};
  }
}

Future<String> envoieImage(XFile? pickedFile) async {
  String tentative = "err-file";

  if (pickedFile == null) {
    return "annule-file";
  }

  tentative = await uploadImageToCloudinary(pickedFile);
  if (tentative != "err-file") {
    return tentative;
  }

  /*tentative = await uploadImageToImgur(pickedFile);
  if (tentative != "err-file") {
    return tentative;
  }*/

  return "err-file";
}

Future<bool> supprimerImage(String lienImage) async {
  final idImage = await CloudFirestore().lectureUBdd(
    "infosImages",
    filtreCompose: cd("lien", lienImage),
  );

  if (idImage != null && idImage.docs.isNotEmpty) {
    final docs = idImage.docs;
    final idLienImage = docs[0].data() as Map<String, dynamic>;
    //print("sup");
    final sup = await deleteImageFromCloudinary(idLienImage["idSup"]);
    if (sup) {
      CloudFirestore().modif("infosImages", docs[0].id, {"status": false});
    }
    return true;
  }

  return false;
}

Future<String> uploadImageToCloudinary(XFile? pickedFile) async {
  //final picker = ImagePicker();
  //final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  try {
    if (pickedFile == null) {
      return "annule-file";
    }

    final file = File(pickedFile.path);
    final uri = Uri.parse(
      "https://api.cloudinary.com/v1_1/ddjkeamgh/image/upload",
    );

    final request = http.MultipartRequest('POST', uri)
      ..fields['upload_preset'] =
          'cloudinaryPresete' // voir plus bas
      ..files.add(await http.MultipartFile.fromPath('file', file.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      final resStr = await response.stream.bytesToString();
      final data = jsonDecode(resStr);
      CloudFirestore().ajoutBdd("infosImages", {
        "lien": data['secure_url'],
        "idSup": data['public_id'],
        "serveur": "cloudinary",
        "status": true,
        "cloudName": "ddjkeamgh",
      });
      return data['secure_url'];
    } else {
      return "err-file";
    }
  } catch (e) {
    return "err-file";
  }
}

Future<bool> deleteImageFromCloudinary(String publicId) async {
  const cloudName = 'ddjkeamgh';
  const apiKey = '583363455265159';
  const apiSecret = '6AN6-nqgGFV8EvFOAilGltaFGAk';

  final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;

  final signatureRaw = 'public_id=$publicId&timestamp=$timestamp$apiSecret';
  final signature = sha1.convert(utf8.encode(signatureRaw)).toString();

  final uri = Uri.parse(
    'https://api.cloudinary.com/v1_1/$cloudName/image/destroy',
  );

  try {
    final response = await http.post(
      uri,
      body: {
        'public_id': publicId,
        'api_key': apiKey,
        'timestamp': timestamp.toString(),
        'signature': signature,
        //'invalidate': 'true',
      },
    );
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body['result'] == 'ok';
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}

// Mets ton client ID Imgur

Future<String> uploadImageToImgur(XFile? pickedFile) async {
  String clientId = 'ea8bf1befdc570c';

  //final picker = ImagePicker();
  //final pickedFile = await picker.pickImage(source: ImageSource.camera);
  if (pickedFile == null) {
    return "annule-file";
  }

  File imageFile = File(pickedFile.path);
  List<int> imageBytes = await imageFile.readAsBytes();
  String base64Image = base64Encode(imageBytes);

  var response = await http.post(
    Uri.parse('https://api.imgur.com/3/image'),
    headers: {'Authorization': 'Client-ID $clientId'},
    body: {'image': base64Image, 'type': 'base64'},
  );

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    return data['data']['link'];
  } else {
    return "err-file";
  }
}

Future<String> uploadToImageKit(XFile? pickedFile) async {
  //final picker = ImagePicker();
  //final XFile? image = await picker.pickImage(source: ImageSource.gallery);

  if (pickedFile == null) {
    return "annule-file";
  }

  final file = File(pickedFile.path);
  final bytes = await file.readAsBytes();
  final base64Image = base64Encode(bytes);

  try {
    final response = await http.post(
      Uri.parse('https://upload.imagekit.io/api/v1/files/upload'),
      headers: {
        'Authorization':
            'Basic ' +
            base64Encode(utf8.encode('private_snfyA1Eccs9npa9CS38L/JXhISU=:')),
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "file": base64Image,
        "fileName": "user_uploaded_image.jpg",
      }),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['url'];
    } else {
      print(response.statusCode);
      return "err-file";
    }
  } catch (e) {
    print(e.toString());
    return e.toString(); //"err-file";
  }
}

void messageAutorisation(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    barrierColor: const Color.fromARGB(107, 0, 0, 0),
    context: context,
    // l'utilisateur ne peut pas fermer en cliquant à l'extérieur
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Echec"),
        content: Text(
          "Nous n'avons pas l'autorisation d'accéder à la camera !",
        ),
        actions: [
          TextButton(
            child: Text("Donner l'autorisation"),
            onPressed: () async {
              Navigator.of(context).pop();
              await AppSettings.openAppSettings();
            },
          ),
          TextButton(
            child: Text("Annuler"),
            onPressed: () {
              Navigator.of(context).pop(); // ferme la modale
            },
          ),
        ],
      );
    },
  );
}
