import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:projeto_avaliativo_3/models/keyword.dart';
import 'package:projeto_avaliativo_3/models/news.dart';
import 'package:projeto_avaliativo_3/services/notification_manager.dart';
import 'package:projeto_avaliativo_3/services/preference_service.dart';

class ApiService {
  Future<List<dynamic>> fetchNews(List<String?> keywords, bool useNewsApi) async {
    if (keywords.isEmpty) {
      return List.empty();
    }

    bool newsNotificationsEnabled =
    await PreferenceService.isFeatureEnabled('news_notifications');
    if (!newsNotificationsEnabled) {
      return List.empty();
    }

    Map<String, String> apiKeys = await getApiKeys();
    String queryString = keywords.join("+OR+");
    String url = useNewsApi
        ? "https://newsapi.org/v2/top-headlines?q=${queryString}&apiKey=${apiKeys['NEWSAPI_API_KEY']!}"
        : "https://newsdata.io/api/1/latest?apikey=${apiKeys['NEWSDATA_API_KEY']!}&q=${queryString}";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        await PreferenceService.notifyIfEnabled('sync_warnings', 'Synchronization in progress...');

        final Map<String, dynamic> decodedResponse = jsonDecode(response.body);
        final List<dynamic> articles = useNewsApi
            ? decodedResponse['articles']
            : decodedResponse['results'];

        if (articles.isNotEmpty) {
          List<News> newsList = articles.map((x) {
            return useNewsApi
                ? News.fromJsonNewsApi(x, Keyword(keyword: "teste"))
                : News.fromJsonNewsData(x, Keyword(keyword: "teste"));
          }).toList();

          String newsJson = jsonEncode({
            ...newsList[0].toJson(),
            'api': useNewsApi ? 'newsapi' : 'newsdata',
          });

          NotificationManager().SendNotification(2, newsList[0], newsJson);

          return articles;
        }
      }
    } catch (e) {
      await PreferenceService.notifyIfEnabled(
          'issue_notifications', 'Error during API call: $e');
      return List.empty();
    }

    return List.empty();
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