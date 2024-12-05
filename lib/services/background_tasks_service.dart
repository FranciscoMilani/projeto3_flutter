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

  Future<void> initialize() async {
    await Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
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

    try {
      var activeKeywords =  keywords.where((k) => k.fetchActive).toList();

      await _apiService.fetchNews(activeKeywords, true);
      await _apiService.fetchNews(activeKeywords, false);

    } catch (e) {
      NotificationManager().sendProcessNotification(123, "Erro na Sincronização", "Falha ao buscar dados: $e");
    }
  }

  static void registerOneTimeTask(List<String> keywords) {
    Workmanager().registerOneOffTask(
      oneTimeTask,
      oneTimeTask,
    );
  }

  static void registerPeriodicTask({Duration frequency = const Duration(minutes: 15)}) {
    Workmanager().registerPeriodicTask(
      periodicTask,
      periodicTask,
      frequency: frequency,
    );
  }

  static void cancelTasks() {
    Workmanager().cancelAll();
  }
}