import 'dart:convert';

import 'package:app/quote.dart';
import 'package:http/http.dart' as http;

class Data {
  final String url = "http://10.0.2.2:8080";

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
