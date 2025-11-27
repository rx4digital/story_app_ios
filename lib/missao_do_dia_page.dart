import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'
    show Clipboard, ClipboardData, rootBundle, HapticFeedback;

class MissaoDoDiaPage extends StatefulWidget {
  const MissaoDoDiaPage({Key? key}) : super(key: key);

  @override
  State<MissaoDoDiaPage> createState() => _MissaoDoDiaPageState();
}

class _MissaoDoDiaPageState extends State<MissaoDoDiaPage>
    with TickerProviderStateMixin {
  // ---- Dicas ----
  static const String _assetPath = 'assets/dicas_missao.json';
  late final int _seedToday;
  List<String> _dicas = [];
  String? _dicaDeHoje;
  bool _carregando = true;

  // ---- Céu / estrelas ----
  static const int _starCount = 28;
  late final List<Offset> _stars; // 0..1 (proporcional)
  final List<int> _selecionadas = []; // índices das 3 estrelas escolhidas
  bool _liberado = false;
  bool _showConfetti = false;

  // animação de “pulso” ao tocar estrela
  late final AnimationController _pulseCtrl;
  late final Animation<double> _pulse;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    _seedToday = now.year * 10000 + now.month * 100 + now.day;

    // gera estrelas fixas pro dia (posições proporcionais 0..1)
    _stars = _gerarEstrelas(_seedToday);

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _pulse = CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeOut);

    _carregarDicas();
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  List<Offset> _gerarEstrelas(int seed) {
    final rnd = Random(seed * 73);
    final list = <Offset>[];
    for (int i = 0; i < _starCount; i++) {
      // evita bordas (margem de 6%)
      final dx = 0.06 + rnd.nextDouble() * 0.88;
      final dy = 0.08 + rnd.nextDouble() * 0.8;
      list.add(Offset(dx, dy));
    }
    return list;
  }

  Future<void> _carregarDicas() async {
    try {
      final raw = await rootBundle.loadString(_assetPath);
      final parsed = jsonDecode(raw);
      if (parsed is List) {
        _dicas = parsed.map<String>((e) => e.toString()).toList();
      } else if (parsed is Map && parsed['dicas'] is List) {
        _dicas =
            (parsed['dicas'] as List).map<String>((e) => e.toString()).toList();
      }
    } catch (_) {
      _dicas = [
        'Mostre seu planejamento em 3 passos nos Stories.',
        'Bastidores rápidos + caixinha: “Quer ver mais do meu dia?”',
        'Antes x Depois (mesmo em texto) + CTA “Quer também?”',
        'Desafio do dia: peça respostas na caixinha.',
        'Mostre uma ferramenta que você usa em 15s.',
        'Mini-case: problema → ação → resultado.',
        'Reposte um feedback e agradeça marcando o cliente.',
        'Mito ou verdade? Faça uma votação.',
        '3 erros comuns e como evitar.',
      ];
    }
    if (_dicas.isEmpty) {
      _dicas = [
        'Poste seu objetivo do dia e marque a hora que vai cumprir.'
      ];
    }
    _dicaDeHoje = _dicas[_seedToday % _dicas.length];
    setState(() => _carregando = false);
  }

  void _onTapSky(Offset localPos, Size skySize) {
    if (_liberado || _carregando) return;

    final idx = _estrelaMaisProxima(localPos, skySize);
    if (idx == null) return;

    if (!_selecionadas.contains(idx)) {
      _selecionadas.add(idx);
      HapticFeedback.selectionClick();
      _pulseCtrl.forward(from: 0);

      if (_selecionadas.length == 3) {
        _ganhou();
      } else {
        setState(() {});
      }
    }
  }

  int? _estrelaMaisProxima(Offset pos, Size sky) {
    int? best;
    double bestDist = double.infinity;

    for (int i = 0; i < _stars.length; i++) {
      final s = _toPx(_stars[i], sky);
      final d = (s - pos).distance;
      if (d < bestDist) {
        bestDist = d;
        best = i;
      }
    }

    final tol = sky.width * 0.06;
    if (bestDist <= tol) return best;
    return null;
  }

  Offset _toPx(Offset p, Size sky) =>
      Offset(p.dx * sky.width, p.dy * sky.height);

  Future<void> _ganhou() async {
    HapticFeedback.mediumImpact();
    setState(() {
      _liberado = true;
      _showConfetti = true;
    });
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _showConfetti = false);
    _mostrarDicaDialog();
  }

  Future<void> _mostrarDicaDialog() async {
    if (_dicaDeHoje == null) return;
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => Dialog(
        backgroundColor: const Color(0xFF161824),
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.auto_awesome,
                  size: 50, color: Colors.orange),
              const SizedBox(height: 8),
              const Text(
                'Missão de Hoje',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                _dicaDeHoje!,
                style: const TextStyle(
                    color: Colors.white70, fontSize: 16, height: 1.35),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Clipboard.setData(
                            ClipboardData(text: _dicaDeHoje!));
                        Navigator.of(ctx).pop();
                        _toast('Dica copiada 👌');
                      },
                      icon: const Icon(Icons.copy, color: Colors.orange),
                      label: const Text('Copiar',
                          style: TextStyle(color: Colors.orange)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.orange),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.of(ctx).pop(),
                      icon: const Icon(Icons.check_circle_outline,
                          color: Colors.white),
                      label: const Text('Concluir',
                          style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text('Nova dica só amanhã 😉',
                  style: TextStyle(color: Colors.white54)),
            ],
          ),
        ),
      ),
    );
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  String _dataCurta() {
    final d = DateTime.now();
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0B12),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0B12),
        centerTitle: true,
        title: const Text('Missão de Hoje'),
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : Stack(
        children: [
          const _StarryBackground(),
          Column(
            children: [
              const SizedBox(height: 12),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16),
                child: _HeaderDark(
                  titulo: 'Missão • ${_dataCurta()}',
                  subtitulo: _liberado
                      ? 'Constelação completa! Missão desbloqueada ✨'
                      : 'Toque 3 estrelas para formar a constelação.',
                  podeVer: _liberado,
                  onVerDica: () {
                    if (_liberado) {
                      _mostrarDicaDialog();
                    } else {
                      _toast('Conecte 3 estrelas primeiro ⭐');
                    }
                  },
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 6),
                  child: LayoutBuilder(
                    builder: (ctx, cons) {
                      final skySize =
                      Size(cons.maxWidth, cons.maxHeight);
                      return GestureDetector(
                        onTapDown: (d) =>
                            _onTapSky(d.localPosition, skySize),
                        child: CustomPaint(
                          painter: _SkyPainter(
                            stars: _stars,
                            selected: _selecionadas,
                            pulse: _pulse.value,
                            glowColor: Colors.orange,
                          ),
                          child: const SizedBox.expand(),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
          if (_showConfetti) const _EmojiConfettiOverlay(),
        ],
      ),
    );
  }
}

// ---------- Header ----------
class _HeaderDark extends StatelessWidget {
  final String titulo;
  final String subtitulo;
  final bool podeVer;
  final VoidCallback onVerDica;

  const _HeaderDark({
    required this.titulo,
    required this.subtitulo,
    required this.podeVer,
    required this.onVerDica,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF12131C),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white10),
        boxShadow: const [
          BoxShadow(
              color: Colors.black54,
              blurRadius: 18,
              offset: Offset(0, 6))
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFF1B1C29),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white10),
            ),
            child: const Icon(Icons.auto_awesome,
                size: 28, color: Colors.orange),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titulo,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16)),
                const SizedBox(height: 4),
                Text(subtitulo,
                    style: const TextStyle(
                        color: Colors.white60, fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: onVerDica,
            style: ElevatedButton.styleFrom(
              backgroundColor:
              podeVer ? Colors.orange : Colors.white10,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
              'Ver dica',
              style: TextStyle(
                color: podeVer ? Colors.white : Colors.white38,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------- Pintura do céu / estrelas ----------
class _SkyPainter extends CustomPainter {
  final List<Offset> stars;
  final List<int> selected;
  final double pulse;
  final Color glowColor;

  _SkyPainter({
    required this.stars,
    required this.selected,
    required this.pulse,
    required this.glowColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final bgGlow = Paint()
      ..color = const Color(0xFF0C0D17)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);

    canvas.drawCircle(
        Offset(size.width * .25, size.height * .3), 120, bgGlow);
    canvas.drawCircle(
        Offset(size.width * .7, size.height * .65), 150, bgGlow);

    final starPaint = Paint()..color = Colors.white70;
    final glowPaint = Paint()
      ..color = Colors.white.withOpacity(.35)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

    for (int i = 0; i < stars.length; i++) {
      final p = Offset(stars[i].dx * size.width,
          stars[i].dy * size.height);

      canvas.drawCircle(p, 2.4, glowPaint);
      canvas.drawCircle(p, 1.3, starPaint);

      if (selected.contains(i)) {
        final scale = 1 + pulse * .8;
        final pulseR = 10.0 * scale;
        final selGlow = Paint()
          ..color = glowColor.withOpacity(.45)
          ..maskFilter =
          const MaskFilter.blur(BlurStyle.normal, 14);
        final core = Paint()..color = Colors.white;

        canvas.drawCircle(p, pulseR, selGlow);
        canvas.drawCircle(p, 3.0, core);
      }
    }

    if (selected.length >= 2) {
      final linePaint = Paint()
        ..color = glowColor.withOpacity(.8)
        ..strokeWidth = 2.2
        ..style = PaintingStyle.stroke;

      for (int i = 0; i < selected.length - 1; i++) {
        final a = Offset(stars[selected[i]].dx * size.width,
            stars[selected[i]].dy * size.height);
        final b = Offset(stars[selected[i + 1]].dx * size.width,
            stars[selected[i + 1]].dy * size.height);
        canvas.drawLine(a, b, linePaint);

        final halo = Paint()
          ..color = glowColor.withOpacity(.18)
          ..strokeWidth = 6
          ..maskFilter =
          const MaskFilter.blur(BlurStyle.normal, 8)
          ..style = PaintingStyle.stroke;
        canvas.drawLine(a, b, halo);
      }

      if (selected.length >= 3) {
        final a = Offset(stars[selected[0]].dx * size.width,
            stars[selected[0]].dy * size.height);
        final c = Offset(stars[selected[2]].dx * size.width,
            stars[selected[2]].dy * size.height);
        final linePaint2 = Paint()
          ..color = glowColor.withOpacity(.8)
          ..strokeWidth = 2.2
          ..style = PaintingStyle.stroke;
        final halo2 = Paint()
          ..color = glowColor.withOpacity(.18)
          ..strokeWidth = 6
          ..maskFilter =
          const MaskFilter.blur(BlurStyle.normal, 8)
          ..style = PaintingStyle.stroke;
        canvas.drawLine(c, a, linePaint2);
        canvas.drawLine(c, a, halo2);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _SkyPainter old) {
    return old.selected != selected ||
        old.pulse != pulse ||
        old.stars != stars;
  }
}

// ---------- BG estrelado sutil ----------
class _StarryBackground extends StatelessWidget {
  const _StarryBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0A0B12),
            Color(0xFF121528),
            Color(0xFF0A0B12),
          ],
        ),
      ),
    );
  }
}

// ---------- Confete com emojis ----------
class _EmojiConfettiOverlay extends StatefulWidget {
  const _EmojiConfettiOverlay();

  @override
  State<_EmojiConfettiOverlay> createState() =>
      _EmojiConfettiOverlayState();
}

class _EmojiConfettiOverlayState extends State<_EmojiConfettiOverlay>
    with TickerProviderStateMixin {
  late final List<AnimationController> _ctrs;
  late final List<Animation<double>> _anims;
  final List<_Particle> _parts = [];

  @override
  void initState() {
    super.initState();
    final rnd = Random();
    for (int i = 0; i < 26; i++) {
      _parts.add(_Particle(
        startX: rnd.nextDouble(),
        startY: rnd.nextDouble() * 0.25 + 0.6,
        emoji: (['✨', '🎉', '🎊', '⭐'])[rnd.nextInt(4)],
        delay: Duration(milliseconds: rnd.nextInt(300)),
        dur: Duration(milliseconds: 650 + rnd.nextInt(550)),
      ));
    }
    _ctrs = _parts
        .map((p) =>
        AnimationController(vsync: this, duration: p.dur))
        .toList();
    _anims = [
      for (final c in _ctrs)
        CurvedAnimation(parent: c, curve: Curves.easeOut)
    ];
    for (int i = 0; i < _ctrs.length; i++) {
      Future.delayed(
          _parts[i].delay, () => _ctrs[i].forward());
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
    return LayoutBuilder(builder: (ctx, cons) {
      return Stack(
        children: [
          for (int i = 0; i < _parts.length; i++)
            AnimatedBuilder(
              animation: _anims[i],
              builder: (_, __) {
                final t = _anims[i].value;
                final p = _parts[i];
                final x = p.startX * cons.maxWidth +
                    sin(t * 8 + i) * 12;
                final y = p.startY * cons.maxHeight -
                    t * 160;
                return Positioned(
                  left: x,
                  top: y,
                  child: Opacity(
                    opacity: (1 - t).clamp(0.0, 1.0),
                    child: Transform.rotate(
                      angle: t * 3.14,
                      child: Text(p.emoji,
                          style:
                          const TextStyle(fontSize: 18)),
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

class _Particle {
  final double startX, startY;
  final String emoji;
  final Duration delay, dur;
  _Particle({
    required this.startX,
    required this.startY,
    required this.emoji,
    required this.delay,
    required this.dur,
  });
}
