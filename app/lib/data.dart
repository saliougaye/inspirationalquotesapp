import 'dart:convert';

import 'package:app/Quote.dart';
import 'package:http/http.dart' as http;

class Data {
  final String url = "http://localhost:8080";

  Future<List<Quote>> fetchQuote() async {
    List<Quote> quotes = [];

    final res = await http.get(Uri.parse("$url/api/quote"),
        headers: {"Accept": "aplication/json"});

    final data = jsonDecode(res.body);

    for (var q in data) {
      // final quote = Quote(
      //     id: q['id'],
      //     quote: q['quote'],
      //     author: q['author'],
      //     genre: q['genre']);

      final quote = Quote.fromJson(q);
      quotes.add(quote);
    }

    return quotes;
  }
}
