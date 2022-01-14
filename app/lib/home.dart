import 'package:app/quote.dart';
import 'package:flutter/material.dart';

import 'data.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<Quote> quote;

  @override
  void initState() {
    super.initState();

    final data = Data();

    quote = data.fetchQuote();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<Quote>(
          future: quote,
          builder: (context, snapshot) {
            if(snapshot.hasData) {
              final quote = snapshot.data!;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    quote.quote
                  )
                ],
              );
            } else if(snapshot.hasError) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Everyone is wrong, especially me. there is something wrong, sorry"
                  )
                ],
              );
            }

            return const CircularProgressIndicator();
          },
        )
      ),
    );
  }
}