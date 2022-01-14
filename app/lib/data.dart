import 'dart:convert';

import 'package:app/quote.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class Data {
  final String url = dotenv.env['API_ENDPOINT']!;

  Future<Quote> fetchQuote() async {
    try {
      final res = await http.get(Uri.parse("$url/api/quote"),
          headers: {"Accept": "aplication/json"});

      final data = jsonDecode(res.body);

      final quote = Quote.fromJson(data[0]);

      return quote;
    } catch (e) {
      final quote = Quote(
          id: "-1",
          quote:
              "Everyone is wrong, especially me. there is something wrong, sorry",
          author: "Me",
          genre: "Error");

      return quote;
    }
  }
}
