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
}