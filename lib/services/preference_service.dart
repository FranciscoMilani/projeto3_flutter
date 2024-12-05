import 'package:shared_preferences/shared_preferences.dart';

class PreferenceService {
  static Future<bool> isFeatureEnabled(String featureKey) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(featureKey) ?? true;
  }
}
