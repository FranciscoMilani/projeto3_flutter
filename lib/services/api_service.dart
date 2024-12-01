import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:projeto_avaliativo_3/models/keyword.dart';
import 'package:projeto_avaliativo_3/models/news.dart';

class ApiService {
  Future<List<News>> fetchNewsApi(List<String?> keywords) async {
    if (keywords.isEmpty) {
      return List.empty();
    }

    String queryString = keywords.join("+OR+");
    Map<String, String> apiKeys = await ApiService.getApiKeys();

    String urlNewsApi = "https://newsapi.org/v2/top-headlines?q=${queryString}&apiKey=${apiKeys['NEWSAPI_API_KEY']!}";

    try {
      final response = await http.get(Uri.parse(urlNewsApi));
      if (response.statusCode == 200) {
        // notificar que está sincronizando
        final Map<String, dynamic> decodedResponse = jsonDecode(response.body);
        final List<dynamic> newsFromApi = decodedResponse['articles'];

        if (newsFromApi.isNotEmpty) {
          return newsFromApi.map((x) {
           return News.fromJsonNewsApi(x, new Keyword(keyword: "teste"));      // TODO: Passar keyword usada na consulta
         }).toList();
        }
      }
    } catch (e) {
      // jogar erro de consulta na notificacao
      return List.empty();
    }

    return List.empty();
  }

  Future<List<News>> fetchNewsData(List<String?> keywords) async {
    if (keywords.isEmpty) {
      return List.empty();
    }

    String queryString = keywords.join("+OR+");
    Map<String, String> apiKeys = await ApiService.getApiKeys();
    String urlNewsApi = "https://newsdata.io/api/1/latest?apikey=${apiKeys['NEWSDATA_API_KEY']!}&q=${queryString}";

    try {
      final response = await http.get(Uri.parse(urlNewsApi));
      if (response.statusCode == 200) {
        // notificar que está sincronizando
        final Map<String, dynamic> decodedResponse = jsonDecode(response.body);
        final List<dynamic> newsFromApi = decodedResponse['results'];

        if (newsFromApi.isNotEmpty) {
          return newsFromApi.map((x) {
            return News.fromJsonNewsData(x, new Keyword(keyword: "teste"));      // TODO: Passar keyword usada na consulta
          }).toList();
        }
      }
    } catch (e) {
      // jogar erro de consulta na notificacao
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