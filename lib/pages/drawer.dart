/*
 * @file drawer.dart
 * @author Sciroccogti (scirocco_gti@yeah.net)
 * @brief 
 * @date 2022-08-11 12:15:41
 * @modified: 2022-08-11 12:16:03
 */

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:money_tracker/vars.dart';
import 'package:url_launcher/url_launcher.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Widget> aboutBoxChildren = <Widget>[
      const SizedBox(height: 24),
      RichText(
          text: TextSpan(
        children: <TextSpan>[
          const TextSpan(
              text: "GitHub: ",
              style: TextStyle(color: Colors.black, fontSize: 16)),
          TextSpan(
              text: "https://github.com/Sciroccogti/money_tracker",
              style: const TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
                fontSize: 16,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  Uri url =
                      Uri.parse("https://github.com/Sciroccogti/money_tracker");
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  } else {
                    throw "Could not launch $url";
                  }
                }),
        ],
      )),
    ];

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            // decoration: const BoxDecoration(
            //   color: Colors.white,
            // ),
            child: Text(
              appName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          AboutListTile(
            icon: const Icon(Icons.info),
            applicationIcon: const FlutterLogo(),
            // TODO: substitute
            applicationName: appName,
            applicationVersion: appVersion,
            applicationLegalese: 'By Sciroccogti & AnhaoROMA',
            aboutBoxChildren: aboutBoxChildren,
          ),
        ],
      ),
    );
  }
}
