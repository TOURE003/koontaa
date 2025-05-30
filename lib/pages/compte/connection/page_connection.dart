import 'package:flutter/material.dart';

class PageConnection extends StatefulWidget {
  const PageConnection({super.key, required this.title});

  final String title;

  @override
  State<PageConnection> createState() => _PageConnectionState();
}

class _PageConnectionState extends State<PageConnection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Text("connection"));
  }
}
