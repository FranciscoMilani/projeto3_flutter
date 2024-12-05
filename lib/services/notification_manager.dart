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
          'News Sync',
          channelDescription: 'Canal de notícias',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      payload: newsJson.toString(),
    );

    // await trackUnclickedNotification(id, newsJson);
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

  // Future<void> trackUnclickedNotification(int id, dynamic payload) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   Map<String, String> unclickedNotifications = {};
  //
  //   if (prefs.containsKey('unclicked_notifications')) {
  //     unclickedNotifications = Map<String, String>.from(jsonDecode(prefs.getString('unclicked_notifications')!));
  //   }
  //
  //   unclickedNotifications[id.toString()] = payload;
  //   await prefs.setString('unclicked_notifications', jsonEncode(unclickedNotifications));
  // }
  //
  // Future<void> removeUnclickedNotification(int id) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   if (prefs.containsKey('unclicked_notifications')) {
  //     Map<String, String> unclickedNotifications = Map<String, String>.from(jsonDecode(prefs.getString('unclicked_notifications')!));
  //     unclickedNotifications.remove(id.toString());
  //     await prefs.setString('unclicked_notifications', jsonEncode(unclickedNotifications));
  //   }
  // }
}