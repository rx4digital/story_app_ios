// lib/captacao_clientes_page.dart
import 'dart:math';
import 'package:flutter/material.dart';

// Dicas (cada arquivo exporta uma lista específica)
import 'data/atraiaclientes/venca_medo_tips.dart' as medo;
import 'data/atraiaclientes/recupere_clientes_tips.dart' as rec;
import 'data/atraiaclientes/atrair_atencao_tips.dart' as atencao;
import 'data/atraiaclientes/oferta_relampago_tips.dart' as oferta;
import 'data/atraiaclientes/lotar_agenda_tips.dart' as agenda;
import 'data/atraiaclientes/brinde_primeiros_tips.dart' as brinde;

// tela do Story do Sonho
import 'mapa_dos_sonhos_page.dart';

// 👉 tela de roteiro IA (caminho correto)
import 'roteiro_ia_page.dart';

class CaptacaoClientesPage extends StatelessWidget {
  const CaptacaoClientesPage({super.key});

  // cores
  static const _bg = Color(0xFF0E0F11);
  static const _dark = Color(0xFF0F1B22);
  static const _goldA = Color(0xFFF4A21A);
  static const _goldB = Color(0xFFDB8B08);

  // snackbar
  void _comingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Em breve ✨')),
    );
  }

  // POP-UP de dicas reutilizável
  Future<void> _showTipsPopup(
      BuildContext context, {
        required String titulo,
        required List<String> itens,
      }) async {
    if (itens.isEmpty) return;

    final random = Random();
    final shuffled = List<String>.from(itens)..shuffle(random);
    int index = 0;

    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setState) {
            return Dialog(
              backgroundColor: const Color(0xFF141A21),
              insetPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.lightbulb,
                            color: Colors.amber, size: 22),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            titulo,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        IconButton(
                          splashRadius: 20,
                          onPressed: () => Navigator.pop(ctx),
                          icon: const Icon(Icons.close_rounded,
                              color: Colors.white70),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        shuffled[index],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          height: 1.35,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: Colors.white.withOpacity(.2),
                              ),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed:
                            index == 0 ? null : () => setState(() => index--),
                            child: const Text('Voltar'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFFFF9900),
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              if (index < shuffled.length - 1) {
                                setState(() => index++);
                              } else {
                                Navigator.pop(ctx);
                              }
                            },
                            child: Text(
                              index < shuffled.length - 1
                                  ? 'Próxima'
                                  : 'Fechar',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ---------- UI ----------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        title: const Text('💰 Atraia Novos Clientes'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
        children: [
          const Text(
            '💰 Atraia Novos Clientes',
            style: TextStyle(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.w900,
              height: 1.05,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Storys para você vender.',
            style: TextStyle(
              color: Colors.amber.shade300,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 18),

          /// ==========================
          /// 🔥 BOTÕES PRINCIPAIS
          /// ==========================
          Row(
            children: [
              Expanded(
                child: _tap(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        // 👉 abre a tela de roteiro IA
                        builder: (_) => const RoteiroIaPage(),
                      ),
                    );
                  },
                  child: _goldButton('🎥 Grave Junto Comigo', _goldA, _goldB),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _tap(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const StoryDoSonhoPage(),
                      ),
                    );
                  },
                  child: _goldButton('🌈 Story do Sonho', _goldA, _goldB),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// ==========================
          /// POP-UPS
          /// ==========================
          _tap(
            onTap: () => _showTipsPopup(
              context,
              titulo: '💪 Vença o Medo em 15 segundos',
              itens: medo.vencaMedoTips,
            ),
            child:
            _goldWideButton('💪 Vença o Medo em 15 segundos', _goldA, _goldB),
          ),

          const SizedBox(height: 16),

          _tap(
            onTap: () => _showTipsPopup(
              context,
              titulo: '🔄 Recupere Clientes com Storys',
              itens: rec.recupereClientesTips,
            ),
            child: _darkListButton('🔄 Recupere Clientes com Storys', _dark),
          ),

          _tap(
            onTap: () => _showTipsPopup(
              context,
              titulo: '💬 Story para Atrair Atenção do Cliente',
              itens: atencao.atrairAtencaoTips,
            ),
            child: _darkListButton(
                '💬 Story para Atrair Atenção do Cliente', _dark),
          ),

          _tap(
            onTap: () => _showTipsPopup(
              context,
              titulo: '⏰ Oferta Rápida - Promoção Relâmpago',
              itens: oferta.ofertaRelampagoTips,
            ),
            child: _darkListButton(
                '⏰ Oferta Rápida - Promoção Relâmpago', _dark),
          ),

          _tap(
            onTap: () => _showTipsPopup(
              context,
              titulo: '📅 Story para Lotar a Agenda',
              itens: agenda.lotarAgendaTips,
            ),
            child: _darkListButton('📅 Story para Lotar a Agenda', _dark),
          ),

          _tap(
            onTap: () => _showTipsPopup(
              context,
              titulo: '🎁 Brinde para os 3 Primeiros',
              itens: brinde.brindePrimeirosTips,
            ),
            child: _darkListButton('🎁 Brinde para os 3 Primeiros', _dark),
          ),

          const SizedBox(height: 28),
        ],
      ),
    );
  }

  // Helpers UI
  Widget _tap({
    required VoidCallback onTap,
    required Widget child,
  }) =>
      InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: child,
      );

  Widget _goldButton(String label, Color a, Color b) => Container(
    height: 96,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(14),
      gradient: LinearGradient(colors: [a, b]),
    ),
    child: Text(
      label,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w900,
        fontSize: 24,
        height: 1.05,
      ),
    ),
  );

  Widget _goldWideButton(String label, Color a, Color b) => Container(
    height: 84,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(14),
      gradient: LinearGradient(colors: [a, b]),
    ),
    child: Text(
      label,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w900,
        fontSize: 22,
      ),
    ),
  );

  Widget _darkListButton(String label, Color bg) => Container(
    height: 64,
    alignment: Alignment.centerLeft,
    padding: const EdgeInsets.symmetric(horizontal: 20),
    margin: const EdgeInsets.only(bottom: 12),
    decoration: BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(14),
    ),
    child: Text(
      label,
      style: const TextStyle(
        color: Color(0xFFE0E6EA),
        fontWeight: FontWeight.w800,
        fontSize: 20,
      ),
    ),
  );
}
