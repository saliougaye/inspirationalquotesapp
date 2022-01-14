import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class Footer extends StatelessWidget {
  const Footer({Key? key}) : super(key: key);

  void _launchUrl() async {
    const url = "http://github.com/saliougaye";

    if (await canLaunch(url)) {
      await launch(url);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: _launchUrl,
            icon: const FaIcon(
              FontAwesomeIcons.github,
              color: Colors.white,
            )
          )
        ],
      ),
    );
  }
}