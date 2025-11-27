import 'dart:math';
import 'package:flutter/material.dart';

// DICAS
import 'data/tips/story_emocional_tips.dart' show storyEmocionalTips;
import 'data/tips/story_medir_conta_tips.dart' show storyMedirContaTips;
import 'data/tips/desafio_contar_sem_mostrar_tips.dart'
    show desafioContarSemMostrarTips;
import 'data/tips/storys_para_interagir_tips.dart'
    show storysParaInteragirTips;
import 'data/tips/storys_curtos_para_comecar_tips.dart'
    show storysCurtosParaComecarTips;
import 'data/tips/quero_engajar_pelos_storys_tips.dart'
    show queroEngajarPelosStorysTips;
import 'data/tips/stories_que_prendem_tips.dart'
    show storiesQuePrendemTips;

class LaboratorioEngajamentoPage extends StatelessWidget {
  const LaboratorioEngajamentoPage({super.key});

  // ====== paleta ======
  static const _bg = Color(0xFF0E1217);
  static const _orangeA = Color(0xFFFFA51E);
  static const _orangeB = Color(0xFFFF9900);
  static const _blueA = Color(0xFF0E2A33);
  static const _blueB = Color(0xFF103641);
  static const _red = Color(0xFFE23D2E);

  // ====== POPUP (uma dica por vez) ======
  Future<void> _showTipsPopup(
      BuildContext context, {
        required String title,
        required List<String> tips,
      }) async {
    if (tips.isEmpty) return;

    // embaralha as dicas pra não ficar sempre igual
    final random = Random();
    final shuffled = List<String>.from(tips)..shuffle(random);
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
                            title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(ctx),
                          icon: const Icon(
                            Icons.close_rounded,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

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
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: index == 0
                                ? null
                                : () => setState(() => index--),
                            child: const Text('Voltar'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFFFF9900),
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                              ),
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

  // ====== helpers de UI ======
  Widget _header(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 22),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 34,
          fontWeight: FontWeight.w900,
          height: 1.1,
        ),
      ),
    );
  }

  Widget _pillOrange(String text, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          height: 84,
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [_orangeA, _orangeB]),
            borderRadius: BorderRadius.circular(18),
            boxShadow: const [
              BoxShadow(
                color: Colors.black54,
                blurRadius: 12,
                offset: Offset(0, 6),
              )
            ],
          ),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }

  Widget _wideOrange(String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        height: 72,
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [_orangeA, _orangeB]),
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 12,
              offset: Offset(0, 6),
            )
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
      ),
    );
  }

  Widget _darkButton(String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        height: 70,
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
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _backButton(BuildContext context) => InkWell(
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
          )
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
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 18),
          children: [
            _header('💡 Ideias para trazer Engajamento'),

            // Laranjas lado a lado (pop-ups)
            Row(
              children: [
                _pillOrange(
                  '💖 Story Emocionante',
                      () => _showTipsPopup(
                    context,
                    title: '💖 Story Emocionante',
                    tips: storyEmocionalTips,
                  ),
                ),
                const SizedBox(width: 14),
                _pillOrange(
                  '📊 Story Termômetro',
                      () => _showTipsPopup(
                    context,
                    title: '📊 Story Termômetro',
                    tips: storyMedirContaTips,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Laranja largo
            _wideOrange(
              '🎭 Desafio: Mostre sem Mostrar',
                  () => _showTipsPopup(
                context,
                title: '🎭 Desafio: Mostre sem Mostrar',
                tips: desafioContarSemMostrarTips,
              ),
            ),
            const SizedBox(height: 18),

            // Azul-petróleo – todos com pop-up
            _darkButton(
              '🗨️ Story pra Gerar Conversa',
                  () => _showTipsPopup(
                context,
                title: '🗨️ Story pra Gerar Conversa',
                tips: storysParaInteragirTips,
              ),
            ),
            const SizedBox(height: 12),

            _darkButton(
              '⚡ Comece o Story de forma Simples',
                  () => _showTipsPopup(
                context,
                title: '⚡ Comece o Story de forma Simples',
                tips: storysCurtosParaComecarTips,
              ),
            ),
            const SizedBox(height: 12),

            _darkButton(
              '🚀 Story pra Bombar o Engajamento',
                  () => _showTipsPopup(
                context,
                title: '🚀 Story pra Bombar o Engajamento',
                tips: queroEngajarPelosStorysTips,
              ),
            ),
            const SizedBox(height: 12),

            _darkButton(
              '👀 Story que Segura a Atenção',
                  () => _showTipsPopup(
                context,
                title: '👀 Story que Segura a Atenção',
                tips: storiesQuePrendemTips,
              ),
            ),
            const SizedBox(height: 24),

            _backButton(context),
          ],
        ),
      ),
    );
  }
}
