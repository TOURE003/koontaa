import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:koontaa/pages/home/home.dart';
import 'firebase_options.dart';

import 'package:firebase_auth/firebase_auth.dart';

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
      home: PhoneAuthPage(), //const Home(title: 'Flutter Demo Home Page'),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

class PhoneAuthPage extends StatefulWidget {
  @override
  _PhoneAuthPageState createState() => _PhoneAuthPageState();
}

class _PhoneAuthPageState extends State<PhoneAuthPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _smsCodeController = TextEditingController();
  String? _verificationId;
  bool _codeSent = false;
  bool _loading = false;
  String _message = '';

  // Étape 1 : Envoyer le code
  Future<void> _envoyerCode() async {
    setState(() {
      _loading = true;
      _message = '';
    });

    final phone = _phoneController.text.trim();

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Connexion automatique (Android uniquement)
        await FirebaseAuth.instance.signInWithCredential(credential);
        setState(() {
          _message = "Connexion automatique réussie !";
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        setState(() {
          _message = "Échec : ${e.message}";
        });
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
          _codeSent = true;
          _message = "Code envoyé au numéro $phone";
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );

    setState(() {
      _loading = false;
    });
  }

  // Étape 2 : Vérifier le code
  Future<void> _verifierCode() async {
    final code = _smsCodeController.text.trim();

    if (_verificationId == null || code.isEmpty) {
      setState(() {
        _message = "Code ou identifiant de vérification manquant.";
      });
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: code,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      setState(() {
        _message = "Numéro vérifié et utilisateur connecté avec succès !";
      });
    } catch (e) {
      setState(() {
        _message = "Erreur de vérification : ${e.toString()}";
      });
    }

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Connexion par téléphone")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            if (!_codeSent)
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: "Numéro de téléphone (+22507xxxxxxx)",
                ),
                keyboardType: TextInputType.phone,
              ),
            if (_codeSent)
              TextField(
                controller: _smsCodeController,
                decoration: InputDecoration(labelText: "Code OTP reçu par SMS"),
                keyboardType: TextInputType.number,
              ),
            const SizedBox(height: 20),
            _loading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _codeSent ? _verifierCode : _envoyerCode,
                    child: Text(
                      _codeSent ? "Vérifier le code" : "Envoyer le code",
                    ),
                  ),
            const SizedBox(height: 20),
            Text(
              _message,
              style: TextStyle(color: Colors.blue),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
