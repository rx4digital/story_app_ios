// lib/socorro_preciso_postar_page.dart
import 'dart:math';
import 'package:flutter/material.dart';

// cada arquivo exporta: const List<String> tips = [...]
import 'data/socorro_preciso_postar/tips_preciso_vender_agora.dart' as pv;
import 'data/socorro_preciso_postar/tips_oferta_ultimahora.dart' as orl;
import 'data/socorro_preciso_postar/tips_storys_que_segura_olhares.dart' as sp;
import 'data/socorro_preciso_postar/tips_apresentacao_60s.dart' as a60;
import 'data/socorro_preciso_postar/tips_porque_escolher_voce.dart' as ci;
import 'data/socorro_preciso_postar/tips_engajar_storys.dart' as es;
import 'data/socorro_preciso_postar/tips_vaga_servico_dia.dart' as vh;
import 'data/socorro_preciso_postar/tips_combo_imbativel.dart' as cd;

class MeSalvaPage extends StatelessWidget {
  const MeSalvaPage({super.key});

  // ---------- POPUP REUTILIZÁVEL ----------
  Future<void> _showTipsPopup(
      BuildContext context, {
        required String titulo,
        required List<String> itens,
      }) async {
    if (itens.isEmpty) return;

    // embaralha para não ficar sempre na mesma ordem
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
  // ---------------------------------------

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF0E0F11);
    const darkItem = Color(0xFF0F1B22);
    const goldA = Color(0xFFF4A21A);
    const goldB = Color(0xFFDB8B08);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        title: const Text('🚨 Socorro! Preciso Postar!'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 32),
        children: [
          const Text(
            '🚨 Socorro! Preciso Postar!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.w900,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Storys para interagir',
            style: TextStyle(
              color: Colors.amber.shade300,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 18),

          // Linha 2 dourados
          Row(
            children: [
              Expanded(
                child: _tap(
                  onTap: () => _showTipsPopup(
                    context,
                    titulo: '💸 Preciso Vender Agora!',
                    itens: pv.tips,
                  ),
                  child: _goldButton('💸 Preciso Vender Agora!', goldA, goldB),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _tap(
                  onTap: () => _showTipsPopup(
                    context,
                    titulo: '⚡ Oferta de Última Hora',
                    itens: orl.tips,
                  ),
                  child:
                  _goldButton('⚡ Oferta de Última Hora', goldA, goldB),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Dourado largo
          _tap(
            onTap: () => _showTipsPopup(
              context,
              titulo: '👁️ Story que Segura os Olhares',
              itens: sp.tips,
            ),
            child: _goldWide('👁️ Story que Segura os Olhares', goldA, goldB),
          ),
          const SizedBox(height: 14),

          // Itens escuros
          _tap(
            onTap: () => _showTipsPopup(
              context,
              titulo: '🗣️ Apresente-se em 1 story',
              itens: a60.tips,
            ),
            child: _darkItem('🗣️ Apresente-se em 1 story', darkItem),
          ),
          _tap(
            onTap: () => _showTipsPopup(
              context,
              titulo: '🤔 Por que Escolher Você?',
              itens: ci.tips,
            ),
            child: _darkItem('🤔 Por que Escolher Você?', darkItem),
          ),
          _tap(
            onTap: () => _showTipsPopup(
              context,
              titulo: '📈 Story pra Engajar Já!',
              itens: es.tips,
            ),
            child: _darkItem('📈 Story pra Engajar Já!', darkItem),
          ),
          _tap(
            onTap: () => _showTipsPopup(
              context,
              titulo: '🧑‍💼 Abriu Vaga ou Serviço para o Dia',
              itens: vh.tips,
            ),
            child: _darkItem('🧑‍💼 Abriu Vaga ou Serviço para o Dia', darkItem),
          ),
          _tap(
            onTap: () => _showTipsPopup(
              context,
              titulo: '🎯 Combo Imbatível',
              itens: cd.tips,
            ),
            child: _darkItem('🎯 Combo Imbatível', darkItem),
          ),
        ],
      ),
    );
  }

  // ---------- UI helpers (mesmo visual) ----------
  static Widget _goldButton(String label, Color a, Color b) {
    return Container(
      height: 112,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [a, b]),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.w900,
          height: 1.05,
        ),
      ),
    );
  }

  static Widget _goldWide(String label, Color a, Color b) {
    return Container(
      height: 92,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [a, b]),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 22,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  static Widget _darkItem(String label, Color bg) {
    return Container(
      height: 78,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 20),
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

  static Widget _tap({
    required VoidCallback onTap,
    required Widget child,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: IgnorePointer(
        ignoring: true,
        child: child,
      ),
    );
  }
}
