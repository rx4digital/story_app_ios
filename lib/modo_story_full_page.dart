// lib/modo_story_full_page.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:story_app/roleta_storys_page.dart';

// DICAS – cada arquivo exporta uma lista com nome específico
import 'data/tips/story_full/desafio_relampago_tips.dart' as d33;
import 'data/tips/story_full/roteiro_surpresa_tips.dart' as rad;
import 'data/tips/story_full/story_sem_desculpa_tips.dart' as ssd;

class ModoStoryFullPage extends StatelessWidget {
  const ModoStoryFullPage({super.key});

  static const _bg = Color(0xFF0E1217);
  static const _orangeA = Color(0xFFFFA51E);
  static const _orangeB = Color(0xFFFF9900);
  static const _blueA = Color(0xFF0E2A33);
  static const _blueB = Color(0xFF103641);
  static const _red = Color(0xFFE23D2E);

  void _comingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Em breve ✨')),
    );
  }

  // ---------- POPUP REUTILIZÁVEL DE DICAS ----------
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
                    // Cabeçalho
                    Row(
                      children: [
                        const Icon(
                          Icons.lightbulb,
                          color: Colors.amber,
                          size: 22,
                        ),
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
                          icon: const Icon(
                            Icons.close_rounded,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Texto da dica
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

                    // Navegação
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: Colors.white.withOpacity(.2),
                              ),
                              foregroundColor: Colors.white,
                              padding:
                              const EdgeInsets.symmetric(vertical: 12),
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
                              padding:
                              const EdgeInsets.symmetric(vertical: 12),
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
  // --------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 18),
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 18, bottom: 4),
              child: Text(
                '🚀 Modo Turbo de Storys',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  height: 1.15,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Text(
                'Nunca mais procrastine para gravar seus storys.',
                style: TextStyle(
                  color: Color(0xFFFFD98A),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            // duas pílulas laranja (ainda "em breve")
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () => _comingSoon(context), // este ainda é em breve
                    child: _pillOrange(text: '🎮 Modo Jogo'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RoletaStorysPage(),
                        ),
                      );
                    },
                    child: _pillOrange(text: '🎡 Roleta de Ideias'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // lembretes (em breve)
            InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () => _comingSoon(context),
              child: _wideOrange(text: '🔔 Lembretes de Fazer Storys'),
            ),
            const SizedBox(height: 20),

            // Quiz (em breve)
            InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () => _comingSoon(context),
              child: _darkButton(text: '❓ Quiz do Engajamento'),
            ),
            const SizedBox(height: 12),

            // ⚡ Desafio Relâmpago – POP-UP
            InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () => _showTipsPopup(
                context,
                titulo: '⚡ Desafio Relâmpago',
                itens: d33.desafio3x3Tips,
              ),
              child: _darkButton(text: '⚡ Desafio Relâmpago'),
            ),
            const SizedBox(height: 12),

            // 🧨 Roteiro Surpresa – POP-UP
            InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () => _showTipsPopup(
                context,
                titulo: '🧨 Roteiro Surpresa',
                itens: rad.roteiroAutodestruiTips,
              ),
              child: _darkButton(text: '🧨 Roteiro Surpresa'),
            ),
            const SizedBox(height: 12),

            // 🚀 Sem Desculpas! Posta Logo! – POP-UP
            InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () => _showTipsPopup(
                context,
                titulo: '🚀 Sem Desculpas! Posta Logo!',
                itens: ssd.storySemDesculpaTips,
              ),
              child: _darkButton(text: '🚀 Sem Desculpas! Posta Logo!'),
            ),
            const SizedBox(height: 26),

            // voltar
            InkWell(
              onTap: () => Navigator.pop(context),
              borderRadius: BorderRadius.circular(18),
              child: Container(
                height: 66,
                decoration: BoxDecoration(
                  color: _red,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black45,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: const Text(
                  'Voltar à página inicial',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
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

  // ==== componentes visuais ====
  static Widget _pillOrange({required String text}) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [_orangeA, _orangeB]),
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  static Widget _wideOrange({required String text}) {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [_orangeA, _orangeB]),
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 22,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  static Widget _darkButton({required String text}) {
    return Container(
      height: 74,
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [_blueA, _blueB]),
        borderRadius: BorderRadius.circular(18),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
