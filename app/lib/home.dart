import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:app/footer.dart';
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
      backgroundColor: Colors.black,
      bottomSheet: const Footer(),
      body: Center(
          child: FutureBuilder<Quote>(
        future: quote,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final quote = snapshot.data!;
            return Container(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedTextKit(
                    totalRepeatCount: 1,
                    animatedTexts: [
                      TypewriterAnimatedText(
                        quote.quote,
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'CustomFont',
                          fontSize: 48,
                        ),
                        textAlign: TextAlign.center,
                        speed: const Duration(milliseconds: 35) 
                      )
                    ]
                  ),
                  const Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 30)),
                  AnimatedTextKit(
                    totalRepeatCount: 1,
                    animatedTexts: [
                      TypewriterAnimatedText(
                        quote.author,
                        textStyle: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'CustomFont',
                            fontSize: 38),
                        textAlign: TextAlign.center,
                        speed: const Duration(milliseconds: 55) 
                      ), 
                    ]
                  )
                ],
              ),
            );
          }

          return const CircularProgressIndicator(
            color: Colors.white,
            backgroundColor: Colors.transparent,
          );
        },
      )),
    );
  }
}
