import 'dart:math';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:projeto_avaliativo_3/models/keyword.dart';
import 'package:projeto_avaliativo_3/models/news.dart';
import 'package:projeto_avaliativo_3/services/notification_manager.dart';
import 'package:projeto_avaliativo_3/services/preference_service.dart';

class ApiService {
  Future<void> fetchNews(List<Keyword> keywords, bool useNewsApi) async {
    if (keywords.isEmpty) return;
    // if (!await PreferenceService.isFeatureEnabled('news_notifications')) return;

    Map<String, String> apiKeys = await getApiKeys();

    for (var keyword in keywords) {
      if (keyword.keyword == null || keyword!.keyword.isEmpty) continue;

      String url = useNewsApi
          ? "https://newsapi.org/v2/top-headlines?q=${keyword.keyword}&apiKey=${apiKeys['NEWSAPI_API_KEY']!}"
          : "https://newsdata.io/api/1/latest?apikey=${apiKeys['NEWSDATA_API_KEY']!}&q=${keyword.keyword}";

      try {
        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          final Map<String, dynamic> decodedResponse = jsonDecode(response.body);
          final List<dynamic> articles = useNewsApi
              ? decodedResponse['articles']
              : decodedResponse['results'];

          if (articles.isNotEmpty) {
            List<News> newsList = articles.map((x) {
              return useNewsApi
                  ? News.fromJsonNewsApi(x, keyword)
                  : News.fromJsonNewsData(x, keyword);
            }).toList();

            Map<String, dynamic> notificationPayload = {
              ...newsList[0].toJson(),
              'api': useNewsApi ? 'newsapi' : 'newsdata',
            };

            String newsJson = jsonEncode(notificationPayload);

            NotificationManager().sendNewsNotification(10, newsList[0], newsJson);
          }
        }
      } catch (e) {
        if (await PreferenceService.isFeatureEnabled('issue_notifications')) {
          NotificationManager().sendProcessNotification(3, "Erro", "Exceção para '${keyword.keyword}': $e");
        }
      }
    }
  }

  static Future<Map<String, String>> getApiKeys() async {
    await dotenv.load();

    Map<String, String> apiKeys = {
      'NEWSDATA_API_KEY': dotenv.env['NEWSDATA_API_KEY']!,
      'NEWSAPI_API_KEY': dotenv.env['NEWSAPI_API_KEY']!,
    };

    return apiKeys;
  }
}