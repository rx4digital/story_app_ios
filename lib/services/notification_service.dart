// lib/services/notification_service.dart
import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Serviço central para agendar / cancelar notificações de story.
class NotificationService {
  NotificationService._internal();
  static final NotificationService instance = NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
  FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  /// Inicializa plugin + timezones (chamado uma vez no app).
  Future<void> initialize() async {
    if (_initialized) return;

    // timezone local
    tz.initializeTimeZones();

    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      iOS: iosSettings,
      // Android não será usado (app iOS-only), então não precisamos configurar.
    );

    await _plugin.initialize(initSettings);
    _initialized = true;
  }

  /// Pede permissão de notificação pro usuário (iOS).
  Future<bool> requestPermissions() async {
    final iosImpl =
    _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();

    final result = await iosImpl?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );

    return result ?? false;
  }

  /// Agenda notificações recorrentes com base nas preferências.
  ///
  /// [frequency]:
  ///   - 'diario'   -> 1x por dia no horário definido
  ///   - '2x_dia'   -> 2x por dia (segunda notificação ~6h depois)
  ///   - 'semanal'  -> 1x por semana naquele horário
  Future<void> scheduleRandomStoryNotification({
    required int hour,
    required int minute,
    required List<String> tips,
    required String frequency,
  }) async {
    if (!_initialized) await initialize();
    await requestPermissions();

    // limpa qualquer agendamento anterior
    await cancelStoryNotifications();

    if (tips.isEmpty) return;

    final rnd = Random();
    final now = tz.TZDateTime.now(tz.local);

    // primeiro disparo no próximo horário escolhido
    var first = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (first.isBefore(now)) {
      first = first.add(const Duration(days: 1));
    }

    final details = const NotificationDetails(
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    // IDs fixos para conseguirmos cancelar depois
    const id1 = 1001;
    const id2 = 1002;

    if (frequency == '2x_dia') {
      // primeira do dia
      await _plugin.zonedSchedule(
        id1,
        'Hora do Story ✨',
        tips[rnd.nextInt(tips.length)],
        first,
        details,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );

      // segunda, ~6 horas depois
      final second = first.add(const Duration(hours: 6));
      await _plugin.zonedSchedule(
        id2,
        'Bora aparecer de novo? 📲',
        tips[rnd.nextInt(tips.length)],
        second,
        details,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } else if (frequency == 'semanal') {
      await _plugin.zonedSchedule(
        id1,
        'Dia de Story 💡',
        tips[rnd.nextInt(tips.length)],
        first,
        details,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );
    } else {
      // diário (padrão)
      await _plugin.zonedSchedule(
        id1,
        'Lembrete de Story 🎥',
        tips[rnd.nextInt(tips.length)],
        first,
        details,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }

  /// Cancela todas as notificações do modo Story.
  Future<void> cancelStoryNotifications() async {
    if (!_initialized) await initialize();
    await _plugin.cancel(1001);
    await _plugin.cancel(1002);
  }
}
