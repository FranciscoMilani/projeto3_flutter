import 'package:flutter/material.dart';
import 'package:projeto_avaliativo_3/notification_manager.dart';
import 'package:projeto_avaliativo_3/screens/home_screen.dart';
import 'package:projeto_avaliativo_3/screens/news_detail.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Projeto Avaliativo 3",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: KeywordsListScreen(),
      navigatorKey: chaveDeNavegacao,
      routes: {
        '/aviso': (context) => /*const*/ NewsDetailScreen(),
      },
    );
  }
}