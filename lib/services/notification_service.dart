// lib/services/notification_service.dart
import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../data/story_notification_tips.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
  FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  /// Inicializa o plugin de notificações.
  /// No iOS, já pede a permissão na primeira vez que o app abre.
  Future<void> initialize() async {
    if (_initialized) return;

    const iosSettings = DarwinInitializationSettings(
      // Esses "true" aqui é que fazem o iOS mostrar o popup de permissão
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(iOS: iosSettings);

    await _plugin.initialize(initSettings);
    _initialized = true;
  }

  /// Notificação simples, imediata, com uma dica aleatória.
  Future<void> showRandomTipNow() async {
    // escolhe uma dica aleatória do arquivo de textos
    final tips = storyNotificationTips;
    final rnd = Random();
    final tip = (tips.isNotEmpty
        ? tips[rnd.nextInt(tips.length)]
        : 'Hora de aparecer nos Storys! 🎥✨')
        .trim();

    const details = NotificationDetails(
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await _plugin.show(
      1, // id qualquer
      'Lembrete de Story ✨',
      tip,
      details,
    );
  }

  /// (Opcional) cancelar todas – se quiser usar depois
  Future<void> cancelAll() => _plugin.cancelAll();
}
