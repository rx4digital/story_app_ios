import 'dart:math';
import 'package:flutter/material.dart';
import 'ia_page.dart';


// listas de dicas
import 'data/home_tips/tips_dicas_pos_servico.dart'
    show tipsDicasPosServico;
import 'data/home_tips/tips_ideias_storys.dart'
    show tipsIdeiasStorys;

// telas
import 'missao_do_dia_page.dart';
import 'brinde_da_semana_page.dart';
import 'configuracoes_page.dart';
import 'ideias_engajamento_page.dart';
import 'socorro_preciso_postar_page.dart';
import 'atraia_novos_clientes_page.dart';
import 'modo_story_full_page.dart';

class HomePage extends StatelessWidget {
  /// Apenas pra exibir no header. Pode trocar depois.
  final String userName;
  final bool isPro;

  const HomePage({
    super.key,
    this.userName = 'Criador(a)',
    this.isPro = false,
  });

  // Snack de "em breve"
  void _comingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Em breve ✨'),
      ),
    );
  }

  // Navegação genérica
  void _open(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  // ---------- POPUP COM DICAS ALEATÓRIAS ----------
  Future<void> _openTipsPopup(
      BuildContext context, {
        required String titulo,
        required List<String> itens,
      }) async {
    // embaralhar as dicas a cada abertura
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
  // ---------------------------------------------

  @override
  Widget build(BuildContext context) {
    // 🎨 Paleta
    const bg = Color(0xFF0F1318);
    const cardDark = Color(0xFF141A21);
    const listDark = Color(0xFF10161C);
    const orangeA = Color(0xFFFFA51E);
    const orangeB = Color(0xFFFF9900);
    const red = Color(0xFFE23D2E);

    // Badge PRO / FREE
    Widget versionBadge() => Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isPro ? Colors.green.shade600 : Colors.blueGrey.shade600,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        isPro ? 'PRO' : 'FREE',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    // Botão laranja grande (lado a lado)
    Widget bigOrange(String title, IconData icon, VoidCallback onTap) {
      return Expanded(
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            height: 90,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [orangeA, orangeB],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black38,
                  blurRadius: 16,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: Colors.black87, size: 28),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      shadows: [
                        Shadow(
                          color: Colors.black54,
                          blurRadius: 6,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Botão laranja largo
    Widget wideOrange(String title, VoidCallback onTap) {
      return InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          height: 78,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [orangeA, orangeB],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black38,
                blurRadius: 16,
                offset: Offset(0, 6),
              ),
            ],
          ),
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      );
    }

    // Botão de lista escuro
    Widget darkListButton(
        String title, {
          String? subtitle,
          IconData icon = Icons.chevron_right,
          VoidCallback? onTap,
        }) {
      return InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          height: 64,
          margin: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: listDark,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 13,
                        ),
                      ),
                  ],
                ),
              ),
              Icon(
                icon,
                color: Colors.white.withOpacity(0.8),
                size: 18,
              ),
            ],
          ),
        ),
      );
    }

    // Botão vermelho de configurações
    Widget redButton(String title, VoidCallback onTap) {
      return InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          height: 64,
          margin: const EdgeInsets.only(top: 18),
          decoration: BoxDecoration(
            color: red,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black45,
                blurRadius: 12,
                offset: Offset(0, 5),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Cabeçalho
            Container(
              decoration: BoxDecoration(
                color: cardDark,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 12,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('👋', style: TextStyle(fontSize: 22)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Olá $userName!',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      versionBadge(),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'O que deseja fazer?',
                    style: TextStyle(
                      color: Colors.amber.shade300,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // dois botões laranja
            Row(
              children: [
                bigOrange(
                  'Missão do Dia',
                  Icons.event_available_rounded,
                      () => _open(context, const MissaoDoDiaPage()),
                ),
                const SizedBox(width: 12),
                bigOrange(
                  'Brinde da Semana',
                  Icons.card_giftcard_rounded,
                      () => _open(context, const BrindeDaSemanaPage()),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Laboratório (laranja largo) -> tela de engajamento
            wideOrange(
              '💡 Ideias para trazer Engajamento',
                  () => _open(
                context,
                const LaboratorioEngajamentoPage(),
              ),
            ),

            const SizedBox(height: 18),

            // lista escura
            darkListButton(
              '🚨 Socorro! Preciso Postar!',
              onTap: () => _open(
                context,
                const MeSalvaPage(),
              ),
            ),
            darkListButton(
              '💰 Atraia Novos Clientes',
              onTap: () => _open(
                context,
                const CaptacaoClientesPage(),
              ),
            ),
            darkListButton(
              '🤝 Stories Pós-Atendimento',
              onTap: () => _openTipsPopup(
                context,
                titulo: '🤝 Stories Pós-Atendimento',
                itens: tipsDicasPosServico,
              ),
            ),
            darkListButton(
              '💡 Ideia Rápida de Story',
              onTap: () => _openTipsPopup(
                context,
                titulo: '💡 Ideia Rápida de Story',
                itens: tipsIdeiasStorys,
              ),
            ),
            darkListButton(
              '🚀 Modo Turbo de Storys',
              onTap: () => _open(
                context,
                const ModoStoryFullPage(),
              ),
            ),
            darkListButton(
              '🤖 Crie com a IA (inteligência artificial)',
              onTap: () => _open(context, const InteligenciaArtificialPage()),
            ),

            // Configurações (vermelho)
            redButton(
              'Configurações do App',
                  () => _open(context, const ConfiguracoesPage()),
            ),
          ],
        ),
      ),
    );
  }
}
