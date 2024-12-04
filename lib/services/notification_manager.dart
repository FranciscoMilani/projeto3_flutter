import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';
import 'package:projeto_avaliativo_3/models/news.dart';

final chaveDeNavegacao = GlobalKey<NavigatorState>();

class NotificationManager {
  var notificacoesLocais = FlutterLocalNotificationsPlugin();

  Future<void> configurarNotificacaoLocal() async {
    const AndroidInitializationSettings cfgAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const cfgiOs = DarwinInitializationSettings();

    var initializationSettings =
    const InitializationSettings(android: cfgAndroid, iOS: cfgiOs);

    await notificacoesLocais.initialize(initializationSettings,
        onDidReceiveNotificationResponse: funcaoRespostaDaNotificacao);
  }

  void funcaoRespostaDaNotificacao(
      NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    
    if (payload != null && payload.isNotEmpty) {
      chaveDeNavegacao.currentState?.pushNamed('/detalhes', arguments: payload);
    } else {
      chaveDeNavegacao.currentState?.pushNamed('/principal', arguments: payload);
    }
  }

  void SendNotification(int id, News news, dynamic newsJson) async {
    await notificacoesLocais.show(
      id,
      news.title ?? 'Notícia sem título...',
      news.description ?? 'Notícia sem descrição disponível...',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'sync_channel', 'News Sync',
          channelDescription: 'Canal de notícias',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      payload: newsJson.toString(),
    );
  }
}