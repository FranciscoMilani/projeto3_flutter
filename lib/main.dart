import 'package:flutter/material.dart';
import 'package:projeto_avaliativo_3/services/background_tasks_service.dart';
import 'package:projeto_avaliativo_3/services/notification_manager.dart';
import 'package:projeto_avaliativo_3/screens/home_screen.dart';
import 'package:projeto_avaliativo_3/screens/news_detail.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final NotificationManager _notificationManager = NotificationManager();
  final BackgroundTasksService _bgTaskService = BackgroundTasksService();

  await _bgTaskService.initialize();
  await _notificationManager.configurarNotificacaoLocal();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

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