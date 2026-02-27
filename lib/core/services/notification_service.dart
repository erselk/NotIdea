import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Handles FCM push notification setup, foreground display,
/// and tap-routing for the Noti app.
class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final _fcm = FirebaseMessaging.instance;
  final _local = FlutterLocalNotificationsPlugin();

  static const _androidChannel = AndroidNotificationChannel(
    'noti_default',
    'Noti Bildirimleri',
    description: 'Arkadaş istekleri ve not paylaşımları',
    importance: Importance.high,
  );

  Future<void> init() async {
    // Request permission (Android 13+)
    await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Create high-importance channel on Android
    await _local
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_androidChannel);

    // Init local notifications (foreground display)
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    await _local.initialize(
      settings: const InitializationSettings(android: androidSettings),
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    // Foreground messages → show as local notification
    FirebaseMessaging.onMessage.listen(_showLocalNotification);

    // Background/terminated tap → handle routing
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageData);

    // Terminated state tap
    final initial = await _fcm.getInitialMessage();
    if (initial != null) _handleMessageData(initial);

    if (kDebugMode) {
      final token = await _fcm.getToken();
      debugPrint('[FCM] token: $token');
    }
  }

  Future<String?> getToken() => _fcm.getToken();

  void _showLocalNotification(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;

    _local.show(
      id: notification.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _androidChannel.id,
          _androidChannel.name,
          channelDescription: _androidChannel.description,
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      payload: jsonEncode(message.data),
    );
  }

  void _handleMessageData(RemoteMessage message) {
    // Routing based on notification type can be added here.
    // e.g.: if (message.data['type'] == 'friend_request') { ... }
    if (kDebugMode) {
      debugPrint('[FCM] message opened: ${message.data}');
    }
  }

  void _onNotificationTap(NotificationResponse response) {
    if (kDebugMode) {
      debugPrint('[FCM] notification tapped: ${response.payload}');
    }
  }
}
