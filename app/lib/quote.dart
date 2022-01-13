class Quote {
  final String id;
  final String quote;
  final String author;
  final String genre;

  Quote({
    required this.id,
    required this.quote,
    required this.author,
    required this.genre
  });

    factory Quote.fromJson(Map<String, dynamic> json) {
      return Quote(
        id: json['id'], 
        quote: json['quote'], 
        author: json['author'],
        genre: json['genre']
      );
    }
}