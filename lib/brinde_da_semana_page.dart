import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'
    show Clipboard, ClipboardData, rootBundle, HapticFeedback;

class BrindeDaSemanaPage extends StatefulWidget {
  const BrindeDaSemanaPage({Key? key}) : super(key: key);

  @override
  State<BrindeDaSemanaPage> createState() => _BrindeDaSemanaPageState();
}

class _BrindeDaSemanaPageState extends State<BrindeDaSemanaPage>
    with SingleTickerProviderStateMixin {
  // ---- CONFIG ----
  static const String _assetPath = 'assets/brinde_semana.json';

  // ---- ESTADO ----
  late final DateTime _monday; // segunda-feira da semana atual
  late final int _seedWeek;    // seed determinístico da semana
  List<String> _brindes = [];
  String? _brindeDaSemana;

  bool _loading = true;
  bool _liberado = false;
  bool _showConfetti = false;

  // Mini-game: barra com cursor animado
  late final AnimationController _ctrl;
  late final Animation<double> _cursor; // 0..1 (vai e volta)
  late final double _zonaIni;           // 0..1 (janela de acerto)
  late final double _zonaFim;           // 0..1

  late final List<_Confetti> _confetti;

  @override
  void initState() {
    super.initState();

    // Segunda-feira da semana atual (ISO-like: 1=Mon..7=Sun)
    final now = DateTime.now();
    _monday = now.subtract(Duration(days: (now.weekday - 1)));
    _seedWeek = _monday.year * 10000 + _monday.month * 100 + _monday.day;

    // Janela de acerto determinística pela semana
    final rnd = Random(_seedWeek * 37);
    final largura = 0.18 + rnd.nextDouble() * 0.12; // 18% a 30% da barra
    final start = rnd.nextDouble() * (1 - largura);
    _zonaIni = start;
    _zonaFim = start + largura;

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _cursor = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);

    _confetti = _geraConfetti(_seedWeek);

    _carregarBrindes();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  // Lê os brindes do assets; aceita ["..."] ou {"brindes":[...]}
  Future<void> _carregarBrindes() async {
    try {
      final raw = await rootBundle.loadString(_assetPath);
      final parsed = jsonDecode(raw);
      if (parsed is List) {
        _brindes = parsed.map<String>((e) => e.toString()).toList();
      } else if (parsed is Map && parsed['brindes'] is List) {
        _brindes =
            (parsed['brindes'] as List).map<String>((e) => e.toString()).toList();
      }
    } catch (_) {
      // Fallback seguro
      _brindes = [
        'Sorteio relâmpago no Domingo: comente “EU QUERO” para participar.',
        'Entrega de bônus: modelo de arte editável para Stories.',
        'Cupom surpresa: 10% para os 10 primeiros que mandarem DM.',
        'Roleta da sorte no sábado: prêmios para quem interagir nos Stories.',
        'Pack de ícones exclusivos para personalizar destaques.',
        'Template de Reels da semana (capas + roteiro).',
        'Checklist de conteúdo pronto para baixar.',
        'Acesso a uma aula gravada curta (15 min) com 3 hacks.',
        'Mentoria relâmpago de 10 minutos para 3 seguidores.'
      ];
    }

    if (_brindes.isEmpty) {
      _brindes = ['Presente surpresa: um template premium liberado no sábado!'];
    }

    // Escolha determinística pela semana
    final idx = _seedWeek % _brindes.length;
    _brindeDaSemana = _brindes[idx];

    setState(() => _loading = false);
  }

  void _tentarParar() {
    if (_loading || _liberado) return;

    final pos = _cursor.value; // 0..1
    if (pos >= _zonaIni && pos <= _zonaFim) {
      _ganhou();
    } else {
      HapticFeedback.lightImpact();
      _toast('Errou por pouco 😅 Tente cravar no verde!');
    }
  }

  void _ganhou() async {
    HapticFeedback.mediumImpact();
    setState(() {
      _liberado = true;
      _showConfetti = true;
    });
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _showConfetti = false);
    _mostrarBrindeDialog();
  }

  Future<void> _mostrarBrindeDialog() async {
    if (_brindeDaSemana == null) return;
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return Dialog(
          backgroundColor: const Color(0xFF1E1E1E),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 14),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.card_giftcard, size: 48, color: Colors.orange),
                const SizedBox(height: 8),
                const Text(
                  'Brinde da Semana',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  _brindeDaSemana!,
                  style: const TextStyle(color: Colors.white70, fontSize: 16, height: 1.35),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: _brindeDaSemana!));
                          Navigator.of(ctx).pop();
                          _toast('Brinde copiado 👌');
                        },
                        icon: const Icon(Icons.copy, color: Colors.orange),
                        label: const Text('Copiar', style: TextStyle(color: Colors.orange)),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.orange),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => Navigator.of(ctx).pop(),
                        icon: const Icon(Icons.check_circle_outline, color: Colors.white),
                        label: const Text('Concluir', style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text('Novo brinde na próxima semana 😉',
                    style: TextStyle(color: Colors.white54)),
              ],
            ),
          ),
        );
      },
    );
  }

  String _faixaSemanaLabel() {
    final domingo = _monday.add(const Duration(days: 6));
    String fmt(DateTime d) =>
        '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}';
    return '${fmt(_monday)}–${fmt(domingo)}';
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text('Brinde da Semana'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _HeaderDark(
                  titulo: 'Brinde • ${_faixaSemanaLabel()}',
                  subtitulo: _liberado
                      ? 'Parabéns! Brinde liberado 🎉'
                      : 'Pare o cursor na área VERDE para desbloquear.',
                  podeVer: _liberado,
                  onVer: () {
                    if (_liberado) {
                      _mostrarBrindeDialog();
                    } else {
                      _toast('Acerte no verde primeiro ✨');
                    }
                  },
                ),
              ),
              const SizedBox(height: 24),

              // MINI-GAME: barra de timing (MAIOR para preencher a tela)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _TimingGame(
                        cursor: _cursor,
                        zonaIni: _zonaIni,
                        zonaFim: _zonaFim,
                        onParar: _tentarParar,
                        ativo: !_liberado,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _liberado
                            ? 'Brinde liberado! Copie e use como quiser nesta semana.'
                            : 'Dica: toque quando o cursor estiver dentro do VERDE.',
                        style: const TextStyle(color: Colors.white70),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (_showConfetti)
            Positioned.fill(
              child: IgnorePointer(
                ignoring: true,
                child: _ConfettiOverlay(confetti: _confetti),
              ),
            ),
        ],
      ),
    );
  }

  List<_Confetti> _geraConfetti(int seed) {
    final rnd = Random(seed + 999);
    const emojis = ['✨', '🎉', '🎊', '⭐', '🎁'];
    return List.generate(26, (i) {
      final dx = rnd.nextDouble();
      final dy = rnd.nextDouble();
      final e = emojis[rnd.nextInt(emojis.length)];
      final delay = Duration(milliseconds: rnd.nextInt(400));
      final dur = Duration(milliseconds: 600 + rnd.nextInt(600));
      return _Confetti(dx, dy, e, delay, dur);
    });
  }
}

// ---------- HEADER (dark) ----------
class _HeaderDark extends StatelessWidget {
  final String titulo;
  final String subtitulo;
  final bool podeVer;
  final VoidCallback onVer;

  const _HeaderDark({
    required this.titulo,
    required this.subtitulo,
    required this.podeVer,
    required this.onVer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF121212),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white10),
        boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 18, offset: Offset(0, 6))],
      ),
      child: Row(
        children: [
          Container(
            width: 54, height: 54, alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFF1F1F1F),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white10),
            ),
            child: const Icon(Icons.card_giftcard, size: 28, color: Colors.orange),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titulo, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
                const SizedBox(height: 4),
                Text(subtitulo, style: const TextStyle(color: Colors.white60, fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: onVer,
            style: ElevatedButton.styleFrom(
              backgroundColor: podeVer ? Colors.orange : Colors.white10,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text('Ver brinde',
                style: TextStyle(color: podeVer ? Colors.white : Colors.white38, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

// ---------- MINI-GAME (versão MAIOR para preencher a tela) ----------
class _TimingGame extends StatelessWidget {
  final Animation<double> cursor; // 0..1
  final double zonaIni;           // 0..1
  final double zonaFim;           // 0..1
  final VoidCallback onParar;
  final bool ativo;

  const _TimingGame({
    required this.cursor,
    required this.zonaIni,
    required this.zonaFim,
    required this.onParar,
    required this.ativo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Barra maior e mais alta
        SizedBox(
          height: 160,
          child: LayoutBuilder(
            builder: (ctx, cons) {
              final w = cons.maxWidth;
              final h = 44.0; // altura da barra

              return AnimatedBuilder(
                animation: cursor,
                builder: (_, __) {
                  final x = cursor.value * (w - h); // posição do cursor
                  final zonaX = zonaIni * w;
                  final zonaW = (zonaFim - zonaIni) * w;

                  return Stack(
                    children: [
                      // trilho
                      Container(
                        height: h,
                        decoration: BoxDecoration(
                          color: const Color(0xFF121212),
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(color: Colors.white10),
                          boxShadow: const [
                            BoxShadow(color: Colors.black87, blurRadius: 16, offset: Offset(0, 6)),
                          ],
                        ),
                      ),
                      // zona verde (sucesso)
                      Positioned(
                        left: zonaX, top: 3, bottom: 3,
                        child: Container(
                          width: zonaW,
                          decoration: BoxDecoration(
                            color: const Color(0xFF13C27A).withOpacity(0.3),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: const Color(0xFF13C27A)),
                          ),
                        ),
                      ),
                      // cursor
                      Positioned(
                        left: x, top: 0,
                        child: Container(
                          width: h, height: h,
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.circle,
                            boxShadow: const [
                              BoxShadow(color: Colors.black, blurRadius: 14, offset: Offset(0, 6)),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: const Icon(Icons.play_arrow, color: Colors.white, size: 20),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
        const SizedBox(height: 24),
        // Botão mais largo e alto
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: ativo ? onParar : null,
            icon: const Icon(Icons.sports_score, color: Colors.white),
            label: const Text('Parar no Verde', style: TextStyle(color: Colors.white, fontSize: 18)),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 18),
              backgroundColor: ativo ? Colors.orange : Colors.white10,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ),
      ],
    );
  }
}

// -------- Confetti simples (emojis animados) --------
class _Confetti {
  final double dx; // 0..1
  final double dy; // 0..1
  final String emoji;
  final Duration delay;
  final Duration dur;
  _Confetti(this.dx, this.dy, this.emoji, this.delay, this.dur);
}

class _ConfettiOverlay extends StatefulWidget {
  final List<_Confetti> confetti;
  const _ConfettiOverlay({required this.confetti});

  @override
  State<_ConfettiOverlay> createState() => _ConfettiOverlayState();
}

class _ConfettiOverlayState extends State<_ConfettiOverlay> with TickerProviderStateMixin {
  late final List<AnimationController> _ctrs;
  late final List<Animation<double>> _anims;

  @override
  void initState() {
    super.initState();
    _ctrs = widget.confetti
        .map((c) => AnimationController(vsync: this, duration: c.dur)..forward(from: 0))
        .toList();
    _anims = [
      for (int i = 0; i < widget.confetti.length; i++)
        CurvedAnimation(parent: _ctrs[i], curve: Curves.easeOut)
    ];
    // Pequeno atraso individual
    for (int i = 0; i < widget.confetti.length; i++) {
      Future.delayed(widget.confetti[i].delay, () {
        if (mounted) _ctrs[i].forward(from: 0);
      });
    }
  }

  @override
  void dispose() {
    for (final c in _ctrs) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constraints) {
      return Stack(
        children: [
          for (int i = 0; i < widget.confetti.length; i++)
            AnimatedBuilder(
              animation: _anims[i],
              builder: (_, __) {
                final c = widget.confetti[i];
                final t = _anims[i].value;
                final x = c.dx * constraints.maxWidth + sin(t * 8 + i) * 12;
                final y = c.dy * constraints.maxHeight - t * 140; // sobe
                return Positioned(
                  left: x,
                  top: y,
                  child: Opacity(
                    opacity: (1 - t).clamp(0.0, 1.0),
                    child: Transform.rotate(
                      angle: t * 3.14,
                      child: const Text('🎁', style: TextStyle(fontSize: 18)),
                    ),
                  ),
                );
              },
            ),
        ],
      );
    });
  }
}
