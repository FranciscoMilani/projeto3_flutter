import 'package:projeto_avaliativo_3/models/keyword.dart';
import 'package:workmanager/workmanager.dart';

const String oneTimeTask = "oneTimeTask";
const String periodicTask = "periodicTask";

class BackgroundTasksService {
  static Future<void> initialize() async {
    await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  }

  static void callbackDispatcher() {
    Workmanager().executeTask((task, inputData) async {
      print("Executing task: $task");
      if (task == oneTimeTask) {
        print("Running one-time task...");
        await fetchDataAndNotify();
      } else if (task == periodicTask) {
        print("Running periodic task...");
        await fetchDataAndNotify();
      }
      return Future.value(true);
    });
  }

  static Future<void> fetchDataAndNotify() async {
    print("Fetching data from API...");
    await Future.delayed(Duration(seconds: 2));
    print("Sending notification...");
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
