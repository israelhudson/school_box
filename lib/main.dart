import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'School Box App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green.shade900,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: Colors.green.shade800,
        textTheme: const TextTheme(
          displayLarge: TextStyle(
              fontSize: 48.0,
              fontWeight: FontWeight.bold,
              color: Colors.white70),
        ),
        useMaterial3: true,
      ),
      home: const HelloWorldScreen(),
    );
  }
}

class HelloWorldScreen extends StatelessWidget {
  const HelloWorldScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Bem vindo ao School Box',
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ),
    );
  }
}