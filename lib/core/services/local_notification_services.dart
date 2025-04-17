import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_storage/get_storage.dart';
import '../app_keys.dart';


class LocalNotificationServices {
  LocalNotificationServices._();
  static final LocalNotificationServices instance = LocalNotificationServices._();

  final _messaging = FirebaseMessaging.instance;
  final storageBox = GetStorage();
  final _localNotifications = FlutterLocalNotificationsPlugin();
  bool _isFlutterLocalNotificationsInitialized = false;

  Future<void> initialize() async {
    // Request permission
    await _requestPermission();

    // Setup flutter notification
    await setupFlutterNotifications();
    // Setup message handlers
    await _setupMessageHandlers();

    // Get and store FCM token if it has changed
    final token = await _messaging.getToken();
    final storedToken = storageBox.read<String>(AppKeys.keyFcmToken);
    if (token != null && token != storedToken) {
      storageBox.write(AppKeys.keyFcmToken, token);
      print('New FCM Token stored: $token');
    }
  }

  Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
    );

    print('Permission status: ${settings.authorizationStatus}');
  }

  Future<void> setupFlutterNotifications() async {
    if (_isFlutterLocalNotificationsInitialized) {
      return;
    }

    // android setup
    const channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    const initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    /*// ios setup
    final initializationSettingsDarwin = DarwinInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) async {
        // Handle iOS foreground notification
      },
    );*/

    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      // iOS: initializationSettingsDarwin,
    );

    // flutter notification setup
    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {},
    );

    _isFlutterLocalNotificationsInitialized = true;
  }

  Future<void> showNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            channelDescription:
            'This channel is used for important notifications.',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: message.data.toString(),
      );
    }
  }

  Future<void> _setupMessageHandlers() async {
    //foreground message
    FirebaseMessaging.onMessage.listen((message) {
      showNotification(message);
    });

    // background message
    FirebaseMessaging.onMessageOpenedApp.listen(handleBackgroundMessage);

    // opened app
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      handleBackgroundMessage(initialMessage);
    }
  }

  void handleBackgroundMessage(RemoteMessage message)async {
    final data = message.data;
    print("Notification tapped with data: $data");

    // TODO: Handle background message (e.g., show a notification)

    // Show notification for background messages
    await showNotification(message);

    // Handle navigation when user taps the notification
    _navigateToScreen(data);
  }

  void _navigateToScreen(Map<String, dynamic> data) {
    if (data.containsKey('type')) {
      if (data['type'] == 'chat') {
        // Navigate to chat screen
        // Get.toNamed('/chat', arguments: data);
      } else if (data['type'] == 'order') {
        // Navigate to order details screen
        print("GO TO ORDER DETAIL SCREEN: $data");
        // Get.toNamed('/orderDetails', arguments: data);
      }
    }
  }
}