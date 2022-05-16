import 'dart:convert';

import 'package:app/quote.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class Data {
  late String url;

  Data() {
    url = dotenv.env['API_ENDPOINT']!;
  }

  Future<Quote> fetchQuote() async {
    final res = await http.get(
      Uri.parse("$url/api/quote"),
      headers: {"Accept": "aplication/json"},
    ).timeout(const Duration(seconds: 20));

    final data = jsonDecode(res.body);

    final quote = Quote.fromJson(data[0]);

    return quote;
  }
}
