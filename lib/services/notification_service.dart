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

    // pede permissão no iOS
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

  // -----------------------------
  //        NOTIFICAÇÃO BASE
  // -----------------------------

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

  /// Teste imediato
  Future<void> showRandomTipNow() async {
    await initialize();

    await _plugin.show(
      999,
      'Lembrete de Story ✨',
      _randomTip(),
      _details,
    );
  }

  // -----------------------------
  //     AGENDAMENTO COMPLETO
  // -----------------------------

  Future<void> scheduleRandomStoryNotification({
    required int hour,
    required int minute,
    required List<String> tips,
    required String frequency, // diario, 2x_dia, 5x_dia, 10x_dia, semanal
  }) async {
    await initialize();
    await cancelStoryNotifications(); // sempre limpa antes

    switch (frequency) {
      case 'diario':
        await _scheduleTimesPerDay(1, hour, minute, tips);
        break;

      case '2x_dia':
        await _scheduleTimesPerDay(2, hour, minute, tips);
        break;

      case '5x_dia':
        await _scheduleTimesPerDay(5, hour, minute, tips);
        break;

      case '10x_dia':
        await _scheduleTimesPerDay(10, hour, minute, tips);
        break;

      case 'semanal':
        await _scheduleWeekly(hour, minute, tips);
        break;
    }
  }

  /// Agenda X notificações por dia divididas ao longo de 12 horas
  Future<void> _scheduleTimesPerDay(
      int times,
      int hour,
      int minute,
      List<String> tips,
      ) async {
    final now = tz.TZDateTime.now(tz.local);

    // Base de horário escolhido
    tz.TZDateTime base = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (base.isBefore(now)) {
      base = base.add(const Duration(days: 1));
    }

    const int windowHours = 12;

    final List<tz.TZDateTime> timesList = [];

    if (times == 1) {
      timesList.add(base);
    } else {
      final interval = windowHours / (times - 1);

      for (int i = 0; i < times; i++) {
        final t = base.add(Duration(hours: (interval * i).round()));
        timesList.add(t);
      }
    }

    int id = 500;

    for (final t in timesList) {
      await _plugin.zonedSchedule(
        id++,
        "Lembrete de Story ✨",
        _randomTip(tips),
        t,
        _details,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.wallClockTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }

  /// Seg/Qua/Sex no horário escolhido
  Future<void> _scheduleWeekly(
      int hour,
      int minute,
      List<String> tips,
      ) async {
    await _scheduleWeeklyDay(hour, minute, tips, DateTime.monday, 301);
    await _scheduleWeeklyDay(hour, minute, tips, DateTime.wednesday, 302);
    await _scheduleWeeklyDay(hour, minute, tips, DateTime.friday, 303);
  }

  Future<void> _scheduleWeeklyDay(
      int hour,
      int minute,
      List<String> tips,
      int weekday,
      int id,
      ) async {
    final now = tz.TZDateTime.now(tz.local);

    tz.TZDateTime scheduled = tz.TZDateTime(
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

  /// Cancela APENAS notificações deste recurso
  Future<void> cancelStoryNotifications() async {
    await _plugin.cancelAll();
  }
}
