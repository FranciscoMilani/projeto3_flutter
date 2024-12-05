import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:projeto_avaliativo_3/database/banco_helper.dart';
import 'package:projeto_avaliativo_3/models/keyword.dart';
import 'package:projeto_avaliativo_3/services/api_service.dart';
import 'package:projeto_avaliativo_3/services/notification_manager.dart';
import 'package:projeto_avaliativo_3/services/preference_service.dart';
import 'package:projeto_avaliativo_3/util/globals.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  static final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<void> initialize() async {
    await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
    await _notificationManager.configurarNotificacaoLocal();

    var prefsInstance = await SharedPreferences.getInstance();
    var interval = prefsInstance.getInt('sync_interval') ?? 15;

    registerOneTimeTask(Keyword.extractKeywords(keywords));
    registerPeriodicTask(frequency: Duration(minutes: interval));

    await fetchDataAndNotify();
  }

  static Future<void> fetchDataAndNotify() async {
    if (await PreferenceService.isFeatureEnabled('sync_warnings')) {
      NotificationManager().sendProcessNotification(3, "Aviso", "Sincronizando com APIs");
    }

    // await _notificationManager.notificacoesLocais.show(
    //   0,
    //   'Sincronizando',
    //   'Buscando dados das APIs NewsApi e NewsData...',
    //   const NotificationDetails(
    //     android: AndroidNotificationDetails(
    //       'sync_channel', 'News Sync',
    //       channelDescription: 'Canal de sincronização',
    //       importance: Importance.high,
    //       priority: Priority.high,
    //     ),
    //   ),
    // );

    try {
      var activeKeywords =  keywords.where((k) => k.fetchActive).toList();
      // List<String?> activeKeywords = Keyword.extractKeywords(activeKeywordsEntities);

      await _apiService.fetchNews(activeKeywords, true);
      await _apiService.fetchNews(activeKeywords, false);

    } catch (e) {
      NotificationManager().sendProcessNotification(123, "Erro na Sincronização", "Falha ao buscar dados: $e");
      // await _notificationManager.notificacoesLocais.show(
      //   1,
      //   'Erro na Sincronização',
      //   'Falha ao buscar dados: $e',
      //   const NotificationDetails(
      //     android: AndroidNotificationDetails(
      //       'error_channel', 'News Sync Error',
      //       channelDescription: 'Canal de sincronização',
      //       importance: Importance.high,
      //       priority: Priority.high,
      //     ),
      //   ),
      // );
    }
  }

  static void registerOneTimeTask(List<String> keywords) {
    Workmanager().registerOneOffTask(
      oneTimeTask,
      oneTimeTask,
    );
  }

  static void registerPeriodicTask({Duration frequency = const Duration(minutes: 15)}) {
    // var selected = Keyword.getSelected();
    //
    // Map<String, dynamic> inputData = {
    //   'keywords': selected.map((x) => x.toJsonSimple()).toList(),
    // };

    Workmanager().registerPeriodicTask(
      periodicTask,
      periodicTask,
      frequency: frequency,
      // inputData: inputData.toString()
    );
  }

  static void cancelTasks() {
    Workmanager().cancelAll();
  }
}