
import 'package:flutter/material.dart';
import 'src/screens/home_screen.dart';

void main() => runApp(const TabachkiApp());

class TabachkiApp extends StatelessWidget {
  const TabachkiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Табачки 2.0',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5A45FF)),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
