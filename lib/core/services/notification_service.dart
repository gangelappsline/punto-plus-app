import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> _initialize() async {
    if (_initialized) {
      return;
    }
    await _plugin.initialize(const InitializationSettings(
      android: AndroidInitializationSettings('@drawable/ic_notification'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
    ));
    _initialized = true;
  }

  Future<bool> requestPermission() async {
    await _initialize();
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      return await android.requestNotificationsPermission() ?? false;
    }
    final ios = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    return await ios?.requestPermissions(
            alert: true, badge: true, sound: true) ??
        false;
  }

  Future<void> showReward() async {
    await _initialize();
    await _plugin.show(
      1,
      '¡Tu constancia tiene recompensa!',
      'Canjeaste una recompensa en la demo de Punto Plus.',
      const NotificationDetails(
        android: AndroidNotificationDetails('rewards', 'Recompensas',
            channelDescription: 'Confirmaciones locales de recompensas',
            importance: Importance.defaultImportance),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }
}
