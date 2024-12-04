import 'package:projeto_avaliativo_3/models/keyword.dart';

class News {
  int id = 0;
  final String? title;
  final String? description;
  final String? url;
  final String? imageUrl;
  final String? publishedAt;
  final String? content;
  final String? creator;
  final String? keyword;

  News({
    this.title,
    this.description,
    this.url,
    this.imageUrl,
    this.publishedAt,
    this.content,
    this.creator,
    required this.keyword
  });

  factory News.fromJsonNewsApi(Map<String, dynamic> json, Keyword? keyword) {
    return News(
      title: json['title'],
      description: json['description'],
      url: json['url'],
      imageUrl: json['urlToImage'],
      publishedAt: json['publishedAt'],
      content: json['content'],
      creator: json['author'],
      keyword: keyword?.keyword
    );
  }

  factory News.fromJsonNewsData(Map<String, dynamic> json, Keyword? keyword) {
    return News(
      title: json['title'],
      description: json['description'],
      url: json['link'],
      imageUrl: json['image_url'],
      publishedAt: json['pubDate'],
      content: json['content'],
      creator: json['creator'],
      keyword: keyword?.keyword
    );
  }

  factory News.fromNewsJson(Map<String, dynamic> json) {
    return News(
        title: json['title'],
        description: json['description'],
        url: json['url'],
        imageUrl: json['imageUrl'],
        publishedAt: json['publishedAt'],
        content: json['content'],
        creator: json['creator'],
        keyword: json['keyword']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'url': url,
      'imageUrl': imageUrl,
      'publishedAt': publishedAt,
      'content': content,
      'creator': creator,
      'keyword': keyword
    };
  }
}
