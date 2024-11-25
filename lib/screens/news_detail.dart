import 'package:flutter/material.dart';
import 'package:projeto_avaliativo_3/models/keyword.dart';
import 'package:projeto_avaliativo_3/models/news_argument.dart';

import '../models/news.dart';

class NewsDetailScreen extends StatefulWidget {
  NewsDetailScreen({super.key});

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  final List<News> defaultNewsList = [
    News(
      title: "Breaking News: Flutter 3 Released",
      description: "The Flutter team has announced the release of Flutter 3 with exciting features.",
      url: "https://flutter.dev",
      imageUrl: null,
      publishedAt: "2024-11-23",
      content: "Flutter 3 brings significant performance improvements and new widgets.",
      creator: "Flutter Team",
      keyword: new Keyword(keyword: "a"),
    ),
    News(
      title: "New Features in Dart 3",
      description: "Dart 3 introduces records, patterns, and more.",
      url: "https://dart.dev",
      imageUrl: null,
      publishedAt: "2024-11-20",
      content: "Learn all about the exciting new features in Dart 3.",
      creator: "Dart Team",
      keyword: new Keyword(keyword: "a"),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments;
    var teste = args;
    // as NewsScreenArguments;

    return Scaffold(
      appBar: AppBar(
        title: const Text("News"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: defaultNewsList.length,
        itemBuilder: (context, index) {
          final news = defaultNewsList[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: news.imageUrl != null
                      ? Image.network(news.imageUrl!, fit: BoxFit.cover, height: 200, width: double.infinity)
                      : Container(
                    height: 200,
                    width: double.infinity,
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.image, size: 80, color: Colors.grey),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        news.title ?? "No Title",
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        news.description ?? "No Description",
                        style: const TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (news.creator != null)
                            Text(
                              "By ${news.creator}",
                              style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                            ),
                          if (news.publishedAt != null)
                            Text(
                              news.publishedAt!,
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () {
                            if (news.url != null) {
                              _openUrl(context, news.url!);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text("Read More"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _openUrl(BuildContext context, String url) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Opening URL: $url")),
    );
  }
}