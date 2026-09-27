import 'package:flutter/material.dart';
import 'package:mirrors_app/presentation/home_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mirros',
      home: const HomeView(),
    );
  }
}
