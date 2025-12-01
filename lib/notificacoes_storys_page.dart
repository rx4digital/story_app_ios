// lib/notificacoes_storys_page.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'services/notification_service.dart';
import 'data/story_notification_tips.dart';

class NotificacoesStorysPage extends StatefulWidget {
  const NotificacoesStorysPage({super.key});

  @override
  State<NotificacoesStorysPage> createState() =>
      _NotificacoesStorysPageState();
}

class _NotificacoesStorysPageState extends State<NotificacoesStorysPage> {
  // chaves usadas no SharedPreferences
  static const _kEnabled = 'story_notif_enabled';
  static const _kHour = 'story_notif_hour';
  static const _kMinute = 'story_notif_minute';
  static const _kFreq = 'story_notif_freq';

  bool _enabled = false;
  TimeOfDay _time = const TimeOfDay(hour: 10, minute: 0);
  String _freq = 'diario'; // 'diario', '2x_dia', 'semanal'

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    final savedEnabled = prefs.getBool(_kEnabled);
    final savedHour = prefs.getInt(_kHour);
    final savedMinute = prefs.getInt(_kMinute);
    final savedFreq = prefs.getString(_kFreq);

    setState(() {
      _enabled = savedEnabled ?? false;
      if (savedHour != null && savedMinute != null) {
        _time = TimeOfDay(hour: savedHour, minute: savedMinute);
      }
      _freq = savedFreq ?? 'diario';
      _loading = false;
    });
  }

  Future<void> _savePrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kEnabled, _enabled);
    await prefs.setInt(_kHour, _time.hour);
    await prefs.setInt(_kMinute, _time.minute);
    await prefs.setString(_kFreq, _freq);
  }

  /// Aplica as mudanças: salva no SharedPreferences
  /// e dispara/cancela notificações.
  ///
  /// Por enquanto, quando ligar, manda uma notificação imediatamente
  /// (só pra testar). Depois você pode evoluir pra agendadas.
  Future<void> _applyNotificationChanges() async {
    // salva as preferências
    await _savePrefs();

    if (_enabled) {
      // aqui você poderia no futuro chamar um "schedule..."
      // por enquanto, enviamos uma notificação de teste:
      await NotificationService.instance.showRandomTipNow();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lembretes ativados. Notificação de teste enviada ✨'),
        ),
      );
    } else {
      // cancela todas as notificações locais
      await NotificationService.instance.cancelAll();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lembretes desativados.'),
        ),
      );
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (picked == null) return;
    setState(() => _time = picked);
    await _applyNotificationChanges();
  }

  void _onToggle(bool value) async {
    setState(() => _enabled = value);
    await _applyNotificationChanges();
  }

  void _onChangeFreq(String value) async {
    setState(() => _freq = value);
    await _applyNotificationChanges();
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF0D1116);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Lembretes de Storys',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: _loading
          ? const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Colors.orange),
        ),
      )
          : SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF151B23),
                borderRadius: BorderRadius.circular(18),
                border:
                Border.all(color: Colors.white.withOpacity(0.06)),
              ),
              child: const Text(
                'Ative os lembretes para receber ideias de storys, '
                    'ganchos e desafios ao longo do dia. Tudo focado em '
                    'te lembrar de aparecer e engajar.',
                style: TextStyle(
                  color: Color(0xFFCFD8E3),
                  fontSize: 15,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 18),

            // switch principal
            SwitchListTile.adaptive(
              value: _enabled,
              onChanged: _onToggle,
              activeColor: Colors.orange,
              title: const Text(
                'Receber lembretes',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(
                _enabled
                    ? 'As notificações estão ativas.'
                    : 'Nenhum lembrete será enviado.',
                style: const TextStyle(
                  color: Color(0xFF8FA0B3),
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(height: 16),

            Opacity(
              opacity: _enabled ? 1 : 0.4,
              child: IgnorePointer(
                ignoring: !_enabled,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Horário preferido',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: _pickTime,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF151B23),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.08),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${_time.hour.toString().padLeft(2, '0')}:${_time.minute.toString().padLeft(2, '0')}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Icon(Icons.access_time,
                                color: Colors.white70),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),

                    const Text(
                      'Frequência',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _ChipOption(
                          label: '1x por dia',
                          selected: _freq == 'diario',
                          onTap: () => _onChangeFreq('diario'),
                        ),
                        _ChipOption(
                          label: '2x por dia',
                          selected: _freq == '2x_dia',
                          onTap: () => _onChangeFreq('2x_dia'),
                        ),
                        _ChipOption(
                          label: 'Algumas vezes na semana',
                          selected: _freq == 'semanal',
                          onTap: () => _onChangeFreq('semanal'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'O que vou receber?',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '• Ideias rápidas de story\n'
                  '• Lembretes para mostrar bastidores\n'
                  '• Ganchos de abertura prontos\n'
                  '• Frases de CTA pra usar na hora',
              style: TextStyle(
                color: Color(0xFF9CB3C9),
                height: 1.4,
              ),
            ),

            const SizedBox(height: 24),

            // Botão extra para testar manualmente uma notificação
            ElevatedButton.icon(
              onPressed: () async {
                await NotificationService.instance.showRandomTipNow();
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:
                    Text('Notificação de teste enviada com sucesso ✅'),
                  ),
                );
              },
              icon: const Icon(Icons.notifications_active),
              label: const Text('Testar notificação agora'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- chipzinho de seleção de frequência ----
class _ChipOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ChipOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color:
          selected ? const Color(0xFFFFA43A) : const Color(0xFF151B23),
          border: Border.all(
            color: selected
                ? const Color(0xFFFFC27A)
                : Colors.white.withOpacity(0.15),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.black : Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
