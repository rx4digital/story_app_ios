// lib/services/timezone_helper.dart
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Helper simples para inicializar fuso e gerar datas futuras
class TimezoneHelper {
  static bool _initialized = false;

  static Future<void> ensureInitialized() async {
    if (_initialized) return;

    tz.initializeTimeZones();

    // Como seu público é BR, vamos fixar America/Sao_Paulo.
    // Se quiser outro fuso depois é só trocar essa string.
    final location = tz.getLocation('America/Sao_Paulo');
    tz.setLocalLocation(location);

    _initialized = true;
  }

  /// Próxima ocorrência desse horário (amanhã se o horário de hoje já passou)
  static tz.TZDateTime nextInstanceOf(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }
}
