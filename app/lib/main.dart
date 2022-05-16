import 'package:app/app.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';

import 'data.dart';

Future<void> main() async {
  
  if (kReleaseMode) {
    await dotenv.load(fileName: '.env.production');
  } else {
    await dotenv.load(fileName: '.env');
  }

  WidgetsFlutterBinding.ensureInitialized();

  await Workmanager().initialize(callbackDispatcher, isInDebugMode: false);

  await Workmanager().registerPeriodicTask("3", "periodicTask",
      frequency: const Duration(hours: 6));

  runApp(const App());
}

void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    FlutterLocalNotificationsPlugin flip = FlutterLocalNotificationsPlugin();

    var android = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = const IOSInitializationSettings();

    var settings = InitializationSettings(android: android, iOS: iOS);

    await flip.initialize(
      settings,
      onSelectNotification: (payload) {
        print('notification');
      },
    );

    await _showNotificationWithDefaultSound(flip);

    return Future.value(true);
  });
}

Future _showNotificationWithDefaultSound(
    FlutterLocalNotificationsPlugin flip) async {

  if (kReleaseMode) {
    await dotenv.load(fileName: '.env.production');
  } else {
    await dotenv.load(fileName: '.env');
  }

  
  var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'inspirationalquotes_notification', 'inspirationalquotes',
      channelDescription: 'Inspirational Quotes App',
      importance: Importance.max,
      priority: Priority.high);
  var iOSPlatformChannelSpecifics = const IOSNotificationDetails();

  // initialise channel platform for both Android and iOS device.
  var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics);

  try {
    final data = Data();
    final quote = await data.fetchQuote();

    await flip.show(0, dotenv.env['APP_NAME'],
        '${quote.quote} - ${quote.author}', platformChannelSpecifics,
        payload: 'Default_Sound');
  } catch (e) {
    print(e);
  }
}
