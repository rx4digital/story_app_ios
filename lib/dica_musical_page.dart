import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:audioplayers/audioplayers.dart';

// Dicas específicas do piano
import 'data/piano_tips.dart' as tips;

class DicaMusicalPage extends StatefulWidget {
  const DicaMusicalPage({Key? key}) : super(key: key);

  @override
  State<DicaMusicalPage> createState() => _DicaMusicalPageState();
}

class _DicaMusicalPageState extends State<DicaMusicalPage> {
  // ordem das teclas brancas
  final List<String> _whiteOrder =
  const ['C', 'D', 'E', 'F', 'G', 'A', 'B', 'Chigh'];

  // slots das teclas pretas
  final List<_BlackSlot> _blackSlots = const [
    _BlackSlot(afterWhiteIndex: 0, note: 'Csus'),
    _BlackSlot(afterWhiteIndex: 1, note: 'Dsus'),
    _BlackSlot(afterWhiteIndex: 3, note: 'Fsus'),
    _BlackSlot(afterWhiteIndex: 4, note: 'Gsus'),
    _BlackSlot(afterWhiteIndex: 5, note: 'Asus'),
  ];

  // player de áudio
  late final AudioPlayer _player;

  int _taps = 0;
  int _tipIndex = 0;

  String? _lastPlayed;
  bool _showConfetti = false;

  // Mapeia cada nota para o arquivo de áudio correspondente.
  // ⚠️ GARANTA que estes nomes batem com os arquivos em assets/audio/piano
  // Exemplo esperado:
  // assets/audio/piano/c.mp3, d.mp3, e.mp3, ...
  final Map<String, String> _noteToAsset = const {
    'C': 'audio/piano/c.mp3',
    'D': 'audio/piano/d.mp3',
    'E': 'audio/piano/e.mp3',
    'F': 'audio/piano/f.mp3',
    'G': 'audio/piano/g.mp3',
    'A': 'audio/piano/a.mp3',
    'B': 'audio/piano/b.mp3',
    'Chigh': 'audio/piano/chigh.mp3',
    // sustenidos
    'Csus': 'audio/piano/CSus.mp3',
    'Dsus': 'audio/piano/DSus.mp3',
    'Fsus': 'audio/piano/FSus.mp3',
    'Gsus': 'audio/piano/GSus.mp3',
    'A3sus': 'audio/piano/A3Sus.mp3',
  };

  List<String> get _tips =>
      (tips.pianoTips.isNotEmpty
          ? tips.pianoTips
          : const [
        '🎵 Mostre seu setup em 15s e pergunte: “Quer ver o resultado?”',
        '🎶 Faça um antes/depois com texto e CTA.',
        '✨ Abra uma caixinha “Qual tema você quer ver amanhã?”',
        '⭐ Mini-case: problema → ação → resultado.',
      ]);

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer()..setReleaseMode(ReleaseMode.stop);
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _playNote(String note) async {
    // feedback tátil
    HapticFeedback.selectionClick();

    setState(() => _lastPlayed = note);

    // toca o áudio, se existir mapeado
    final assetPath = _noteToAsset[note];
    if (assetPath != null) {
      try {
        // para não sobrepor centenas de sons
        await _player.stop();
        await _player.play(AssetSource(assetPath));
      } catch (_) {
        // se der erro de asset, só ignora o áudio
      }
    }

    _taps++;
    if (_taps >= 3) {
      _taps = 0;
      _showTipDialog();
    }
  }

  Future<void> _showTipDialog() async {
    setState(() => _showConfetti = true);
    await Future.delayed(const Duration(milliseconds: 450));
    if (!mounted) return;

    final tip = _tips[_tipIndex % _tips.length];
    _tipIndex++;

    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return Dialog(
          backgroundColor: const Color(0xFF101015),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 14),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.music_note,
                    size: 48, color: Colors.orange),
                const SizedBox(height: 6),
                const Text(
                  'Dica Musical',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  tip,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 14),
                FilledButton.icon(
                  onPressed: () => Navigator.of(ctx).pop(),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.check_circle_outline,
                      color: Colors.white),
                  label: const Text(
                    'Fechar',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Toque mais para novas ideias 🎵',
                  style: TextStyle(color: Colors.white54),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (!mounted) return;
    setState(() => _showConfetti = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0C12),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0C12),
        centerTitle: true,
        title: const Text('Dica Musical'),
      ),
      body: Stack(
        children: [
          const _GradientBackground(),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Piano do Engajamento',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      letterSpacing: .3,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const _HeaderCard(),
                const SizedBox(height: 10),
                Expanded(
                  child: LayoutBuilder(
                    builder: (ctx, cons) {
                      final w = cons.maxWidth;
                      final h = cons.maxHeight;
                      final whiteKeyW = (w - 16) / _whiteOrder.length;
                      final whiteKeyH = min(h * .75, 360.0);
                      final blackKeyH = whiteKeyH * .62;

                      return Center(
                        child: SizedBox(
                          width: w,
                          height: whiteKeyH,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Row(
                                crossAxisAlignment:
                                CrossAxisAlignment.stretch,
                                children: [
                                  for (final note in _whiteOrder)
                                    _GlossyWhiteKey(
                                      label:
                                      note == 'Chigh' ? 'C' : note,
                                      active: _lastPlayed == note,
                                      onTap: () => _playNote(note),
                                    ),
                                ],
                              ),
                              ..._buildBlackKeys(
                                whiteKeyW: whiteKeyW,
                                w: w,
                                h: blackKeyH,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding:
                  const EdgeInsets.fromLTRB(16, 10, 16, 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back,
                          color: Colors.white),
                      label: const Text(
                        'Voltar',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE53935),
                        padding: const EdgeInsets.symmetric(
                            vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_showConfetti) const _EmojiConfettiOverlay(),
        ],
      ),
    );
  }

  List<Widget> _buildBlackKeys({
    required double whiteKeyW,
    required double w,
    required double h,
  }) {
    final List<Widget> list = [];
    for (final slot in _blackSlots) {
      final note = slot.note;
      final left = (slot.afterWhiteIndex + 1) * whiteKeyW -
          (whiteKeyW * .62) / 2;
      list.add(
        Positioned(
          left: left,
          width: whiteKeyW * .62,
          height: h,
          child: _GlossyBlackKey(
            active: _lastPlayed == note,
            onTap: () => _playNote(note),
          ),
        ),
      );
    }
    return list;
  }
}

class _GradientBackground extends StatelessWidget {
  const _GradientBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0B0C12),
            Color(0xFF121525),
            Color(0xFF0B0C12),
          ],
        ),
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF11131D),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 18,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: const Row(
          children: [
            Icon(Icons.piano, color: Colors.orange),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Toque 3 notas para desbloquear uma dica 💡',
                style: TextStyle(color: Colors.white70),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlossyWhiteKey extends StatefulWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _GlossyWhiteKey({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  State<_GlossyWhiteKey> createState() => _GlossyWhiteKeyState();
}

class _GlossyWhiteKeyState extends State<_GlossyWhiteKey>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 90),
  );
  late final Animation<double> _scale =
  Tween<double>(begin: 1, end: .985).animate(_ctrl);

  @override
  void didUpdateWidget(covariant _GlossyWhiteKey oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.active && !oldWidget.active) {
      _ctrl.forward(from: 0).then((_) => _ctrl.reverse());
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child: GestureDetector(
          onTap: widget.onTap,
          child: ScaleTransition(
            scale: _scale,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(10),
                ),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFEDEEF3), Color(0xFFDADCE6)],
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
                border: Border.all(color: Colors.black, width: 1),
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    height: 18,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(12),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white.withOpacity(.55),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(
                        widget.label,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GlossyBlackKey extends StatefulWidget {
  final bool active;
  final VoidCallback onTap;
  const _GlossyBlackKey({required this.active, required this.onTap});

  @override
  State<_GlossyBlackKey> createState() => _GlossyBlackKeyState();
}

class _GlossyBlackKeyState extends State<_GlossyBlackKey>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 90),
  );
  late final Animation<double> _scale =
  Tween<double>(begin: 1, end: .985).animate(_ctrl);

  @override
  void didUpdateWidget(covariant _GlossyBlackKey oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.active && !oldWidget.active) {
      _ctrl.forward(from: 0).then((_) => _ctrl.reverse());
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF2B2B2B), Color(0xFF121212)],
            ),
            border: Border.all(color: Colors.black, width: 1),
            boxShadow: const [
              BoxShadow(
                color: Colors.black87,
                blurRadius: 10,
                offset: Offset(0, 7),
              ),
            ],
          ),
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: 12,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(10),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withOpacity(.15),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BlackSlot {
  final int afterWhiteIndex;
  final String note;
  const _BlackSlot({required this.afterWhiteIndex, required this.note});
}

// -------- Confete de emojis --------
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
    for (int i = 0; i < 24; i++) {
      _parts.add(
        _Particle(
          startX: rnd.nextDouble(),
          startY: rnd.nextDouble() * 0.2 + 0.6,
          emoji: (['🎵', '🎶', '✨', '⭐'])[rnd.nextInt(4)],
          delay: Duration(milliseconds: rnd.nextInt(300)),
          dur: Duration(milliseconds: 700 + rnd.nextInt(500)),
        ),
      );
    }
    _ctrs = _parts
        .map((p) => AnimationController(vsync: this, duration: p.dur))
        .toList();
    _anims = [
      for (final c in _ctrs)
        CurvedAnimation(parent: c, curve: Curves.easeOut)
    ];
    for (int i = 0; i < _ctrs.length; i++) {
      Future.delayed(_parts[i].delay, () => _ctrs[i].forward());
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
    return LayoutBuilder(
      builder: (ctx, cons) {
        return Stack(
          children: [
            for (int i = 0; i < _parts.length; i++)
              AnimatedBuilder(
                animation: _anims[i],
                builder: (_, __) {
                  final t = _anims[i].value;
                  final p = _parts[i];
                  final x =
                      p.startX * cons.maxWidth + sin(t * 10 + i) * 10;
                  final y =
                      p.startY * cons.maxHeight - t * 180;
                  return Positioned(
                    left: x,
                    top: y,
                    child: Opacity(
                      opacity: (1 - t).clamp(0.0, 1.0),
                      child: Transform.rotate(
                        angle: t * 3.14,
                        child: Text(
                          p.emoji,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  );
                },
              ),
          ],
        );
      },
    );
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
