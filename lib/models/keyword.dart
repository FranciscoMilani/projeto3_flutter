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

  static List<String> extractKeywords(Iterable<Keyword> keywords) {
    return keywords.map((e) => e.keyword).toList();
  }
}
