// lib/services/notification_service.dart

import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import '../data/story_notification_tips.dart';
import 'timezone_helper.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
  FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  /// Inicializa plugin + pede permissão no iOS
  Future<void> initialize() async {
    if (_initialized) return;

    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    await _plugin.initialize(
      const InitializationSettings(iOS: iosInit),
    );

    // pede as permissões de fato
    await _plugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      sound: true,
      badge: true,
    );

    await TimezoneHelper.ensureInitialized();

    _initialized = true;
  }

  NotificationDetails get _details => const NotificationDetails(
    iOS: DarwinNotificationDetails(
      presentAlert: true,
      presentSound: true,
      presentBadge: true,
    ),
  );

  String _randomTip([List<String>? list]) {
    final L = (list != null && list.isNotEmpty)
        ? list
        : storyNotificationTips;
    final rnd = Random();
    return L[rnd.nextInt(L.length)];
  }

  /// Botão "Testar notificação agora"
  Future<void> showRandomTipNow() async {
    await initialize();

    await _plugin.show(
      999, // id qualquer
      'Lembrete de Story ✨',
      _randomTip(),
      _details,
    );
  }

  // -----------------------------
  //       AGENDAMENTO REAL
  // -----------------------------

  /// frequency:
  /// - 'diario'  -> 1x por dia
  /// - '2x_dia'  -> 2x por dia (hora + hora+6)
  /// - 'semanal' -> seg/qua/sex no mesmo horário
  Future<void> scheduleRandomStoryNotification({
    required int hour,
    required int minute,
    required List<String> tips,
    required String frequency,
  }) async {
    await initialize();
    await cancelStoryNotifications();

    if (frequency == 'diario') {
      await _scheduleDaily(hour, minute, tips);
    } else if (frequency == '2x_dia') {
      await _scheduleDaily(hour, minute, tips);
      await _scheduleDaily(hour + 6, minute, tips, id: 202);
    } else if (frequency == 'semanal') {
      await _scheduleWeekly(hour, minute, tips, DateTime.monday, id: 301);
      await _scheduleWeekly(hour, minute, tips, DateTime.wednesday, id: 302);
      await _scheduleWeekly(hour, minute, tips, DateTime.friday, id: 303);
    }
  }

  Future<void> _scheduleDaily(
      int hour,
      int minute,
      List<String> tips, {
        int id = 200,
      }) async {
    final scheduled = TimezoneHelper.nextInstanceOf(hour, minute);

    await _plugin.zonedSchedule(
      id,
      'Lembrete de Story ✨',
      _randomTip(tips),
      scheduled,
      _details,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.wallClockTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> _scheduleWeekly(
      int hour,
      int minute,
      List<String> tips,
      int weekday, {
        int id = 300,
      }) async {
    final now = tz.TZDateTime.now(tz.local);

    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    while (scheduled.weekday != weekday || scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    await _plugin.zonedSchedule(
      id,
      'Lembrete de Story ✨',
      _randomTip(tips),
      scheduled,
      _details,
      androidAllowWhileIdle: true,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.wallClockTime,
    );
  }

  Future<void> cancelStoryNotifications() async {
    await _plugin.cancelAll();
  }
}
