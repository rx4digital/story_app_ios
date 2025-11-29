import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

// lista externa com as dicas – precisa ter `const List<String> roletaTips`
import 'data/tips/roleta_tips.dart';

class RoletaStorysPage extends StatefulWidget {
  const RoletaStorysPage({Key? key}) : super(key: key);

  @override
  State<RoletaStorysPage> createState() => _RoletaStorysPageState();
}

class _RoletaStorysPageState extends State<RoletaStorysPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  Animation<double>? _anim;

  late final AudioPlayer _player;

  final _rnd = Random();

  double _baseRotation = 0;
  double _deltaRotation = 0;
  bool _spinning = false;
  bool _dialogOpen = false;

  final List<String> _items = const [
    'Segmento 1',
    'Segmento 2',
    'Segmento 3',
    'Segmento 4',
    'Segmento 5',
    'Segmento 6',
    'Segmento 7',
    'Segmento 8',
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _player = AudioPlayer()..setReleaseMode(ReleaseMode.stop);
  }

  @override
  void dispose() {
    _controller.dispose();
    _player.dispose();
    super.dispose();
  }

  double get _currentAngle => _baseRotation + _deltaRotation;

  // ---------- POPUP GENÉRICO ----------
  Future<void> _showTipPopup(
      BuildContext context, {
        required String title,
        required List<String> itens,
      }) async {
    if (itens.isEmpty) return;
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
                            title,
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
                        itens[index],
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
                                  color: Colors.white.withOpacity(.2)),
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
                              if (index < itens.length - 1) {
                                setState(() => index++);
                              } else {
                                Navigator.pop(ctx);
                              }
                            },
                            child: Text(
                              index < itens.length - 1
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
  // -----------------------------------

  Future<void> _spin() async {
    if (_spinning || _dialogOpen) return;
    setState(() => _spinning = true);

    final seg = 2 * pi / _items.length;
    final chosenIndex = _rnd.nextInt(_items.length);
    final targetAngle = (chosenIndex * seg) + (seg / 2);

    final extraTurns = 4 + _rnd.nextInt(3); // 4..6 voltas
    final endDelta = (extraTurns * 2 * pi) +
        _normalize(targetAngle - (_currentAngle % (2 * pi)));

    _anim?.removeListener(_tick);

    _anim = Tween<double>(begin: 0, end: endDelta).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    )
      ..addListener(_tick)
      ..addStatusListener(_onSpinCompleted);

    // som da roleta
    await _player.stop();
    _player.play(AssetSource('sounds/roulette_spin.mp3'));

    _controller.forward(from: 0);
  }

  void _tick() {
    setState(() => _deltaRotation = _anim?.value ?? 0);
  }

  Future<void> _onSpinCompleted(AnimationStatus status) async {
    if (status == AnimationStatus.completed) {
      await _player.stop();

      _baseRotation = (_baseRotation + (_anim?.value ?? 0)) % (2 * pi);
      _deltaRotation = 0;

      if (!mounted) return;

      if (_dialogOpen) {
        setState(() => _spinning = false);
        return;
      }

      final tip = roletaTips.isNotEmpty
          ? roletaTips[_rnd.nextInt(roletaTips.length)]
          : 'Sem dicas disponíveis';

      setState(() {
        _dialogOpen = true;
        _spinning = false;
      });

      await _showTipPopup(
        context,
        title: 'Dica de Story',
        itens: [tip],
      ).whenComplete(() {
        if (mounted) {
          setState(() => _dialogOpen = false);
        }
      });
    }
  }

  double _normalize(double angle) {
    double a = angle % (2 * pi);
    if (a < 0) a += 2 * pi;
    return a;
  }

  @override
  Widget build(BuildContext context) {
    final wheelSize = MediaQuery.of(context).size.width * 0.82;

    return Scaffold(
      backgroundColor: const Color(0xFF0E1217),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E1217),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Roleta dos Storys',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Gire a roleta para receber uma ideia de Story criativa e rápida de executar.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF9FB2BB),
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // ROLETA
            Stack(
              alignment: Alignment.topCenter,
              children: [
                CustomPaint(
                  size: Size(wheelSize, 24),
                  painter: _PointerPainter(),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Transform.rotate(
                    angle: _currentAngle,
                    child: CustomPaint(
                      size: Size(wheelSize, wheelSize),
                      painter: _WheelPainter(
                        segments: _items.length,
                        colors: const [
                          Color(0xFFFFC06A),
                          Color(0xFFFF9F3F),
                        ],
                        borderColor: const Color(0xFF8A5A30),
                        centerColor: const Color(0xFF0E1A20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // BOTÃO GIRAR
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: (_spinning || _dialogOpen) ? null : _spin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFA43A),
                    disabledBackgroundColor: const Color(0xFFFFA43A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    _spinning
                        ? 'Girando…'
                        : (_dialogOpen ? 'Feche a dica' : 'Girar'),
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            // BOTÃO VOLTAR
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE74C3C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Voltar à página inicial',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                      color: Colors.white,
                    ),
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

// ==== painters ====

class _WheelPainter extends CustomPainter {
  _WheelPainter({
    required this.segments,
    required this.colors,
    required this.borderColor,
    required this.centerColor,
  });

  final int segments;
  final List<Color> colors;
  final Color borderColor;
  final Color centerColor;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2;
    final center = Offset(radius, radius);

    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..color = borderColor.withOpacity(0.8);
    canvas.drawCircle(center, radius - 5, borderPaint);

    if (segments <= 0) return;

    final segAngle = 2 * pi / segments;
    for (int i = 0; i < segments; i++) {
      final paint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: i.isEven ? colors : colors.reversed.toList(),
        ).createShader(
          Rect.fromCircle(center: center, radius: radius - 8),
        );
      final path = Path()
        ..moveTo(center.dx, center.dy)
        ..arcTo(
          Rect.fromCircle(center: center, radius: radius - 8),
          -pi / 2 + i * segAngle,
          segAngle,
          false,
        )
        ..close();
      canvas.drawPath(path, paint);
    }

    final hubPaint = Paint()..color = centerColor;
    canvas.drawCircle(center, radius * 0.18, hubPaint);
  }

  @override
  bool shouldRepaint(covariant _WheelPainter oldDelegate) => false;
}

class _PointerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final c = Offset(w / 2, 0);

    final path = Path()
      ..moveTo(c.dx, 0)
      ..lineTo(c.dx - 12, h)
      ..lineTo(c.dx + 12, h)
      ..close();

    final paint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFFFE29A), Color(0xFFFFA43A)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(c.dx - 12, 0, 24, h))
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, paint);

    final stroke = Paint()
      ..color = const Color(0xFF8A5A30)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawPath(path, stroke);
  }

  @override
  bool shouldRepaint(covariant _PointerPainter oldDelegate) => false;
}
