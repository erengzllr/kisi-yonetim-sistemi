import 'package:flutter/material.dart';

import 'screens/person_list_screen.dart';

void main() {
  runApp(const PersonApp());
}

class PersonApp extends StatelessWidget {
  const PersonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kişi Rehberi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C63FF),
          brightness: Brightness.light,
        ),
      ),
      home: PersonListScreen(),
    );
  }
}
