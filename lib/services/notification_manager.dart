import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';

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
    if (notificationResponse.payload != null) {
      Logger().i('notification payload: $payload');
    } else {
      Logger().i('funcaoRespostaDaNotificacao');
    }

    chaveDeNavegacao.currentState?.pushNamed('/aviso', arguments: payload);
  }
}
