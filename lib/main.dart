import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
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
      home: const Home(title: 'Flutter Demo Home Page'),
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
