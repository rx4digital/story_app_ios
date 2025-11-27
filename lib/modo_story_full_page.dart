import 'package:flutter/material.dart';

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

            Row(
              children: [
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () => _comingSoon(context),
                    child: _pillOrange(text: '🎮 Modo Jogo'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () => _comingSoon(context),
                    child: _pillOrange(text: '🎡 Roleta de Ideias'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () => _comingSoon(context),
              child: _wideOrange(text: '🔔 Lembretes de Fazer Storys'),
            ),
            const SizedBox(height: 20),

            InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () => _comingSoon(context),
              child: _darkButton(text: '❓ Quiz do Engajamento'),
            ),
            const SizedBox(height: 12),

            InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () => _comingSoon(context),
              child: _darkButton(text: '⚡ Desafio Relâmpago'),
            ),
            const SizedBox(height: 12),

            InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () => _comingSoon(context),
              child: _darkButton(text: '🧨 Roteiro Surpresa'),
            ),
            const SizedBox(height: 12),

            InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () => _comingSoon(context),
              child: _darkButton(text: '🚀 Sem Desculpas! Posta Logo!'),
            ),
            const SizedBox(height: 26),

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
