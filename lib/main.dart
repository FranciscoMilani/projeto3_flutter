import 'package:flutter/material.dart';
import 'package:projeto_avaliativo_3/services/notification_manager.dart';
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent),
        useMaterial3: true,
      ),
      home: KeywordsListScreen(),
      navigatorKey: chaveDeNavegacao,
      routes: {
        '/principal': (context) => KeywordsListScreen(),
        '/detalhes': (context) => NewsDetailScreen(),
      },
    );
  }
}