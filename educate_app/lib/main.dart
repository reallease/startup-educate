import 'package:educate_app/features/home/pages/main_screen.dart';
// import 'package:educate_app/features/auth/view/pages/login_page.dart';'
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Educate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins', // opcional, pra deixar bonito
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF00B97E)),
        useMaterial3: true,
      ),
      home: MainScreen(), // tela inicial do app
    );
  }
}