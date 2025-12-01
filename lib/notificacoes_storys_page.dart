import 'dart:math';
import 'package:flutter/material.dart';

// Dicas de lembretes
import 'data/story_notification_tips.dart'
as notif_tips; // notif_tips.storyNotificationsTips

class NotificacoesStorysPage extends StatefulWidget {
  const NotificacoesStorysPage({super.key});

  @override
  State<NotificacoesStorysPage> createState() =>
      _NotificacoesStorysPageState();
}

class _NotificacoesStorysPageState extends State<NotificacoesStorysPage> {
  // Estados básicos
  bool _enabled = true;
  String _intensidade = 'moderado'; // 'leve' | 'moderado' | 'intenso'
  bool _soEmDiasUteis = true;
  bool _lembretesDeManha = true;
  bool _lembretesATarde = false;
  bool _lembretesAnoite = false;

  late String _previewTip;

  @override
  void initState() {
    super.initState();
    _previewTip = _pickRandomTip();
  }

  String _pickRandomTip() {
    final list = notif_tips.storyNotificationTips;
    if (list.isEmpty) {
      return 'Você vai receber lembretes com ideias de story, ganchos e mini-desafios para gravar mais. ✨';
    }
    final rnd = Random();
    return list[rnd.nextInt(list.length)];
  }

  void _refreshPreview() {
    setState(() {
      _previewTip = _pickRandomTip();
    });
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF0E1217);
    const card = Color(0xFF151A23);
    const accent = Color(0xFFFFA51E);
    const red = Color(0xFFE23D2E);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        foregroundColor: Colors.white,
        title: const Text(
          '🔔 Lembretes de Storys',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          children: [
            const Text(
              'Deixe o Story Feito te lembrar de aparecer com frequência, com ideias prontas para gravar.',
              style: TextStyle(
                color: Color(0xFFCFD7E3),
                fontSize: 14,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),

            // Cartão principal (status)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: card,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: Colors.white.withOpacity(0.06),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    height: 42,
                    width: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E2531),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.notifications_active_rounded,
                      color: accent,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _enabled
                          ? 'Lembretes ligados — você receberá notificações com ideias de story.'
                          : 'Lembretes desligados — você não receberá notificações.',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        height: 1.35,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Switch.adaptive(
                    value: _enabled,
                    activeColor: accent,
                    onChanged: (v) {
                      setState(() => _enabled = v);
                      // aqui depois você pode salvar em SharedPreferences
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            // Intensidade
            const Text(
              'Frequência dos lembretes',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _ChipOption(
                  label: 'Leve (3x/semana)',
                  selected: _intensidade == 'leve',
                  onTap: _enabled
                      ? () => setState(() => _intensidade = 'leve')
                      : null,
                ),
                _ChipOption(
                  label: 'Moderado (1x/dia)',
                  selected: _intensidade == 'moderado',
                  onTap: _enabled
                      ? () => setState(() => _intensidade = 'moderado')
                      : null,
                ),
                _ChipOption(
                  label: 'Intenso (2–3x/dia)',
                  selected: _intensidade == 'intenso',
                  onTap: _enabled
                      ? () => setState(() => _intensidade = 'intenso')
                      : null,
                ),
              ],
            ),

            const SizedBox(height: 18),

            const Text(
              'Horários preferidos',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),

            _SwitchConfigTile(
              title: 'Somente em dias úteis',
              subtitle: 'De segunda a sexta',
              value: _soEmDiasUteis,
              enabled: _enabled,
              onChanged: (v) {
                setState(() => _soEmDiasUteis = v);
              },
            ),
            _SwitchConfigTile(
              title: 'Manhã (8h – 11h)',
              value: _lembretesDeManha,
              enabled: _enabled,
              onChanged: (v) {
                setState(() => _lembretesDeManha = v);
              },
            ),
            _SwitchConfigTile(
              title: 'Tarde (13h – 17h)',
              value: _lembretesATarde,
              enabled: _enabled,
              onChanged: (v) {
                setState(() => _lembretesATarde = v);
              },
            ),
            _SwitchConfigTile(
              title: 'Noite (18h – 21h)',
              value: _lembretesAnoite,
              enabled: _enabled,
              onChanged: (v) {
                setState(() => _lembretesAnoite = v);
              },
            ),

            const SizedBox(height: 22),

            // Preview de notificação
            Row(
              children: [
                const Text(
                  'Exemplo de lembrete',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: _refreshPreview,
                  child: const Text(
                    'Trocar exemplo',
                    style: TextStyle(color: accent),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF161B26),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.notifications_rounded,
                    color: accent,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _previewTip,
                      style: const TextStyle(
                        color: Color(0xFFE4ECF5),
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Botão voltar
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'Voltar à página inicial',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Chip customizado para seleção de intensidade
class _ChipOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  const _ChipOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = selected
        ? const LinearGradient(
      colors: [Color(0xFFF5A623), Color(0xFFFF8C3B)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    )
        : const LinearGradient(
      colors: [Color(0xFF151A23), Color(0xFF151A23)],
    );

    final textColor = selected ? Colors.black : const Color(0xFFE4ECF5);

    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          gradient: bg,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected
                ? Colors.transparent
                : Colors.white.withOpacity(0.08),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

/// Tile de configuração com switch
class _SwitchConfigTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool value;
  final bool enabled;
  final ValueChanged<bool> onChanged;

  const _SwitchConfigTile({
    required this.title,
    this.subtitle,
    required this.value,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    const card = Color(0xFF151A23);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.05),
        ),
      ),
      child: ListTile(
        enabled: enabled,
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: subtitle == null
            ? null
            : Text(
          subtitle!,
          style: const TextStyle(
            color: Color(0xFF9CB3C9),
            fontSize: 13,
          ),
        ),
        trailing: Switch.adaptive(
          value: value,
          activeColor: const Color(0xFFFFA51E),
          onChanged: enabled ? onChanged : null,
        ),
      ),
    );
  }
}
