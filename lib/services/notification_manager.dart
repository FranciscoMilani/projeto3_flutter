import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:projeto_avaliativo_3/models/news.dart';
import 'package:shared_preferences/shared_preferences.dart';

final chaveDeNavegacao = GlobalKey<NavigatorState>();

class NotificationManager {
  var notificacoesLocais = FlutterLocalNotificationsPlugin();

  Future<void> configurarNotificacaoLocal() async {
    const AndroidInitializationSettings cfgAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const cfgiOs = DarwinInitializationSettings();

    var initializationSettings =
    const InitializationSettings(android: cfgAndroid);

    await notificacoesLocais.initialize(initializationSettings,
        onDidReceiveNotificationResponse: funcaoRespostaDaNotificacao);
  }

  void funcaoRespostaDaNotificacao(NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;

    if (payload != null && payload.isNotEmpty) {
      chaveDeNavegacao.currentState?.pushNamed('/detalhes', arguments: payload);
    } else {
      chaveDeNavegacao.currentState?.pushNamed('/principal');
    }
  }

  void sendNewsNotification(int id, News news, dynamic newsJson) async {
    await notificacoesLocais.show(
      id,
      news.title ?? 'Notícia sem título...',
      news.description ?? 'Notícia sem descrição disponível...',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'sync_channel',
          'Sincronizacao',
          channelDescription: 'Canal de notícias',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      payload: newsJson.toString(),
    );
  }

  void sendProcessNotification(int id, String title, String description) async {
    await notificacoesLocais.show(
      id,
      title,
      description,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'process_channel',
          'Notificação de processo',
          channelDescription: 'Canal de processamento',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
  }
}