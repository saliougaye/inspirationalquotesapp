import 'package:app/app.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';

import 'data.dart';


void main() async {

  if (kReleaseMode) {
    await dotenv.load(fileName: '.env.production');
  } else {
    await dotenv.load(fileName: '.env');
  }
  
  WidgetsFlutterBinding.ensureInitialized();

  Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true
  );

  Workmanager().registerPeriodicTask(
    "3", 
    "periodicTask",
    frequency: const Duration(
      hours: 24
    )
  );

  runApp(const App());
  
}


void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) {
    FlutterLocalNotificationsPlugin flip = FlutterLocalNotificationsPlugin();

    var android = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = const  IOSInitializationSettings();
    
    
    var settings = InitializationSettings(
      android: android,
      iOS: iOS
    );


    flip.initialize(settings);

    _showNotificationWithDefaultSound(flip);

    return Future.value(true);
  });
}

Future _showNotificationWithDefaultSound(FlutterLocalNotificationsPlugin flip) async {
   
  // Show a notification after every 15 minute with the first
  // appearance happening a minute after invoking the method
  var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
    'channelId',
    'channelName',
    channelDescription: 'channelDescription',
    importance: Importance.max,
    priority: Priority.high
  );
  var iOSPlatformChannelSpecifics = const IOSNotificationDetails();
   
  // initialise channel platform for both Android and iOS device.
  var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics
  );

  final data = Data();
  final quote = await data.fetchQuote();

  await flip.show(0, dotenv.env['APP_NAME'],
    '${quote.quote} - ${quote.author}',
    platformChannelSpecifics, payload: 'Default_Sound'
  );
}
 