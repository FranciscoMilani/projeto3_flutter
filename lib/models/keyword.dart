import 'package:projeto_avaliativo_3/util/globals.dart';

class Keyword {
  final int id = 0;
  final String keyword;
  final DateTime createdDate;
  bool fetchActive;

  Keyword({
    required this.keyword,
    this.fetchActive = true,
    DateTime? createdDate,
  }) : createdDate = createdDate ?? DateTime.now();

  Map<String, dynamic> toJsonSimple() {
    return {
      'keyword': keyword,
    };
  }

  static List<String> extractKeywords(Iterable<Keyword> keywords) {
    return keywords.map((e) => e.keyword).toList();
  }

  static List<Keyword> getSelected() {
    return keywords.where((element) => element.fetchActive == true).toList();
  }
}
