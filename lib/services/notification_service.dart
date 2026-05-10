import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz_util;

/// Handles both local and push notifications
class NotificationService {
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Initialize notifications
  /// Call this in main() after Firebase is initialized
  static Future<void> initialize() async {
    // Initialize timezone for scheduled notifications
    tz.initializeTimeZones();

    // Android settings
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS settings
    const DarwinInitializationSettings iOSSettings =
        DarwinInitializationSettings();

    // Combine settings
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iOSSettings,
    );

    // Initialize plugin
    await _flutterLocalNotificationsPlugin.initialize(initSettings);

    // Request FCM token for push notifications
    String? token = await FirebaseMessaging.instance.getToken();
    print(' FCM Token obtained: $token');

    // Request notification permission (iOS)
    await FirebaseMessaging.instance.requestPermission();

    // Listen for foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(' Message received in foreground: ${message.notification?.title}');
      _showNotification(
        title: message.notification?.title ?? 'Event Notification',
        body: message.notification?.body ?? '',
      );
    });

    print(' Notification service initialized');
  }

  /// Show notification immediately (for testing or urgent notifications)
  static Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    await _showNotification(title: title, body: body);
  }

  /// Internal method to show notification
  static Future<void> _showNotification({
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'eventify_channel', // Channel ID
      'Event Notifications', // Channel name
      channelDescription: 'Notifications for events and reminders',
      importance: Importance.max,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iOSDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecond, // Unique ID
      title,
      body,
      details,
    );

    print(' Notification shown: $title');
  }

  /// Schedule notification for specific date/time
  /// Example: Schedule reminder 1 hour before event
  ///
  /// Usage:
  /// DateTime eventTime = DateTime(2026, 5, 15, 10, 0);
  /// DateTime reminderTime = eventTime.subtract(Duration(hours: 1));
  /// await NotificationService.scheduleNotification(
  ///   title: "Tech Conference starts soon!",
  ///   body: "Get ready for Tech Conference in 1 hour",
  ///   scheduledTime: reminderTime,
  /// );
  static Future<void> scheduleNotification({
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    try {
      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
        'eventify_reminders_channel',
        'Event Reminders',
        channelDescription: 'Scheduled reminders for upcoming events',
        importance: Importance.max,
        priority: Priority.high,
      );

      const DarwinNotificationDetails iOSDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails details = NotificationDetails(
        android: androidDetails,
        iOS: iOSDetails,
      );

      // Convert to timezone-aware datetime
      final tz_util.TZDateTime tzDateTime =
          tz_util.TZDateTime.from(scheduledTime, tz_util.local);

      await _flutterLocalNotificationsPlugin.zonedSchedule(
        DateTime.now().millisecond,
        title,
        body,
        tzDateTime,
        details,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dateAndTime,
      );

      print(
          ' Notification scheduled for: ${scheduledTime.toString()} | Title: $title');
    } catch (e) {
      print(' Schedule notification error: $e');
    }
  }

  /// Schedule a reminder X hours before event
  /// Convenience method
  static Future<void> scheduleEventReminder({
    required String eventTitle,
    required DateTime eventDateTime,
    required int hoursBefore,
  }) async {
    DateTime reminderTime = eventDateTime.subtract(Duration(hours: hoursBefore));

    await scheduleNotification(
      title: '$eventTitle reminder',
      body: '$eventTitle starts in $hoursBefore hour(s)',
      scheduledTime: reminderTime,
    );

    print(' Reminder scheduled: $hoursBefore hours before $eventTitle');
  }

  /// Cancel notification by ID
  static Future<void> cancelNotification(int id) async {
    try {
      await _flutterLocalNotificationsPlugin.cancel(id);
      print(' Notification cancelled: ID $id');
    } catch (e) {
      print(' Cancel notification error: $e');
    }
  }

  /// Cancel all notifications
  static Future<void> cancelAllNotifications() async {
    try {
      await _flutterLocalNotificationsPlugin.cancelAll();
      print(' All notifications cancelled');
    } catch (e) {
      print(' Cancel all error: $e');
    }
  }
}
