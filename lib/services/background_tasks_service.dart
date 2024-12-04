import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:projeto_avaliativo_3/models/keyword.dart';
import 'package:projeto_avaliativo_3/services/api_service.dart';
import 'package:projeto_avaliativo_3/services/notification_manager.dart';
import 'package:projeto_avaliativo_3/util/globals.dart';
import 'package:workmanager/workmanager.dart';

const String oneTimeTask = "oneTimeTask";
const String periodicTask = "periodicTask";

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == oneTimeTask || task == periodicTask) {
      await BackgroundTasksService.fetchDataAndNotify();
    }
    return Future.value(true);
  });
}

class BackgroundTasksService {
  static final NotificationManager _notificationManager = NotificationManager();
  static final ApiService _apiService = ApiService();

  Future<void> initialize() async {
    await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
    await _notificationManager.configurarNotificacaoLocal();
    registerOneTimeTask(Keyword.extractKeywords(keywords));
    await fetchDataAndNotify(); // busca inicial
  }

  static Future<void> fetchDataAndNotify() async {
    await _notificationManager.notificacoesLocais.show(
      0,
      'Sincronizando',
      'Buscando dados das APIs NewsApi e NewsData...',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'sync_channel', 'News Sync',
          channelDescription: 'Canal de sincronização',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );

    try {
      var activeKeywordsEntities =  keywords.where((k) => k.fetchActive);
      List<String?> activeKeywords = Keyword.extractKeywords(activeKeywordsEntities);

      await _apiService.fetchNews(activeKeywords, true);
      await _apiService.fetchNews(activeKeywords, false);

      // _notificationManager.SendNotification(Random().nextInt(100000), resultNewsApi.firstOrNull);

    } catch (e) {
      await _notificationManager.notificacoesLocais.show(
        1,
        'Erro na Sincronização',
        'Falha ao buscar dados: $e',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'error_channel', 'News Sync Error',
            channelDescription: 'Canal de sincronização',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
      );
    }
  }

  static void registerOneTimeTask(List<String> keywords) {
    Workmanager().registerOneOffTask(
      oneTimeTask,
      oneTimeTask,
      inputData: {"key": "value"},
    );
  }

  static void registerPeriodicTask({Duration frequency = const Duration(minutes: 15)}) {
    Workmanager().registerPeriodicTask(
      periodicTask,
      periodicTask,
      frequency: frequency,
      inputData: {"key": "value"},
    );
  }
}