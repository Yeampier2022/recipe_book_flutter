import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "App module World",
      home: helloWorld(),
    );
  }
}

class helloWorld extends StatelessWidget {
  const helloWorld({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text("Create Hello World Module", style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
