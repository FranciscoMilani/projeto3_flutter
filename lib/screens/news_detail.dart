import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/news.dart';


class NewsDetailScreen extends StatefulWidget {
  const NewsDetailScreen({super.key});

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments as String;
    var newsJson = json.decode(args) as Map<String, dynamic>;
    var news = News.fromNewsJson(newsJson);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notícia"),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Card(
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
                    news.title ?? "Sem título...",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    news.description ?? "Sem descrição disponível...",
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (news.creator != null)
                        Expanded(
                          child: Text(
                            "Por ${news.creator}",
                            style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                          ),
                        ),
                      if (news.publishedAt != null)
                        Expanded(
                          child: Text(
                            news.publishedAt != null
                                ? DateFormat.yMMMd().format(DateTime.parse(news.publishedAt!))
                                : "--/--/----",
                            style: const TextStyle(fontSize: 12, color: Colors.black),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (news.keyword != null && news.keyword!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          Icon(Icons.label, color: Colors.blue),
                          const SizedBox(width: 8),
                          Text(
                            news.keyword!,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}