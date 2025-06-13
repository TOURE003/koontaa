//import 'dart:nativewrappers/_internal/vm/lib/math_patch.dart';

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

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
      //ImageUploadPage(), //ImgurUploader(), //const Home(title: 'Home Page'),
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

class ImgurUploader extends StatefulWidget {
  @override
  _ImgurUploaderState createState() => _ImgurUploaderState();
}

class _ImgurUploaderState extends State<ImgurUploader> {
  String? imageUrl;
  bool uploading = false;

  final String clientId = 'ea8bf1befdc570c'; // Mets ton client ID Imgur

  Future<void> pickAndUploadImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.camera);

      if (pickedFile == null) return;

      setState(() {
        uploading = true;
      });

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
        setState(() {
          imageUrl = data['data']['link'];
          uploading = false;
        });
      } else {
        setState(() {
          uploading = false;
        });
        print("errreuuu");
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: uploading ? null : pickAndUploadImage,
          child: uploading
              ? CircularProgressIndicator()
              : Text('Choisir et uploader une image'),
        ),
        SizedBox(height: 20),
        if (imageUrl != null) Image.network(imageUrl!),
      ],
    );
  }
}

class ImageUploadPage extends StatefulWidget {
  @override
  _ImageUploadPageState createState() => _ImageUploadPageState();
}

class _ImageUploadPageState extends State<ImageUploadPage> {
  File? _image;
  String? _uploadedImageUrl;

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    setState(() {
      _image = File(pickedFile.path);
    });

    final uploadUrl = Uri.parse(
      "https://api.cloudinary.com/v1_1/ddjkeamgh/image/upload",
    );

    final request = http.MultipartRequest('POST', uploadUrl)
      ..fields['upload_preset'] = 'cloudinaryPresete'
      ..files.add(await http.MultipartFile.fromPath('file', _image!.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      final resStr = await response.stream.bytesToString();
      final data = jsonDecode(resStr);
      setState(() {
        _uploadedImageUrl = data['secure_url'];
      });
    } else {
      print("Erreur Cloudinary : ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Uploader une image')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image != null
                ? Image.file(_image!, height: 200)
                : Text('Aucune image sélectionnée.'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickAndUploadImage,
              child: Text('Sélectionner et envoyer une image'),
            ),
            SizedBox(height: 20),
            _uploadedImageUrl != null
                ? Column(
                    children: [
                      Text('Image envoyée avec succès !'),
                      Image.network(_uploadedImageUrl!, height: 200),
                      SelectableText(_uploadedImageUrl!),
                    ],
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
