import 'dart:developer';
import 'package:firebase_notifications_handler/firebase_notifications_handler.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:untitled/firebase_options1.dart';
import 'package:untitled/firebase_options_2.dart';
import 'package:untitled/globals.dart';

const bool isLive = false; // Change this to switch between live and test
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseOptions firebaseOptions = isLive
      ? DefaultFirebaseOptions1.currentPlatform
      : DefaultFirebaseOptions2.currentPlatform;

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(options: firebaseOptions);
    log('Firebase initialized');
  }
  FirebaseNotificationsHandler.createAndroidNotificationChannel(
    const AndroidNotificationChannel(
      'default',
      'Default',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
      showBadge: true,
      sound: RawResourceAndroidNotificationSound('notification'),
    ),
  );
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FirebaseNotificationsHandler(
      localNotificationsConfiguration: LocalNotificationsConfiguration(
          androidConfig: AndroidNotificationsConfig(
            playSoundGetter:(RemoteMessage message) {
              return true;
            },
            enableVibrationGetter: (RemoteMessage message) {
              return true;
            },
            importanceGetter: (RemoteMessage message) {
              return Importance.high;
            },
            priorityGetter: (RemoteMessage message) {
              return Priority.high;
            },
          ),
        ),
        onOpenNotificationArrive: (message) {
          log('Notification arrived with $message');
      },
      onTap: (info) {
          final payload = info.payload;
          final appState = info.appState;
          final firebaseMessage = info.firebaseMessage;
          // If you want to push a screen on notification tap
          //
          // Globals.navigatorKey.currentState?.pushNamed(payload['screenId']);
          //
          // OR
          ///
          // Get current context
          // final context = Globals.navigatorKey.currentContext!;
          final context = Globals.navigatorKey.currentContext!;
          log('Notification tapped with $appState & payload $payload. Firebase message: $firebaseMessage',
          );
        },
      onFcmTokenInitialize: (token) => Globals.fcmTokenNotifier.value = token,
      onFcmTokenUpdate: (token) => Globals.fcmTokenNotifier.value = token,
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home:  const MyHomePage( title: 'Home Page'),
        ),
    );
  }
}



// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   if (Firebase.apps.isEmpty) {
//     await Firebase.initializeApp();
//   }
//   print('Handling a background message: ${message.messageId}');
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return FirebaseNotificationsHandler(
//       child: MaterialApp(
//         title: 'Flutter Demo',
//         theme: ThemeData(
//           colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//           useMaterial3: true,
//         ),
//         home: const MyHomePage(title: 'Flutter Demo Home Page'),
//       ),
//     );
//   }
// }

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    // _requestNotificationPermission();
    // FirebaseMessaging.instance.getToken().then((token) {
    //   print('FCM Token: $token');
    // });
    //
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   print('Received a message while in the foreground: ${message.messageId}');
    //   // Handle the message
    // });
    //
    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //   print('Message clicked!');
    //   // Handle the message
    // });
  }



  void _requestNotificationPermission() async {
    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('You have pushed the button this many times:'),
          ],
        ),
      ),
    );
  }
}