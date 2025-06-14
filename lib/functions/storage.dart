import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';

Future<Map<String, dynamic>> imageUser({bool camera = false}) async {
  final pick = ImagePicker();
  final source = camera ? ImageSource.camera : ImageSource.gallery;
  XFile? image = await pick.pickImage(source: source);

  return {"lien": image?.path ?? "0", "image": image};
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

  tentative = await uploadImageToImgur(pickedFile);
  if (tentative != "err-file") {
    return tentative;
  }

  return "err-file";
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
      return data['secure_url'];
    } else {
      return "err-file";
    }
  } catch (e) {
    return "err-file";
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
