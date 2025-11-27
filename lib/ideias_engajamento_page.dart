import 'package:flutter/material.dart';

class LaboratorioEngajamentoPage extends StatelessWidget {
  const LaboratorioEngajamentoPage({super.key});

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
              ),
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

            Row(
              children: [
                _pillOrange(
                  '💖 Story que Toca o Coração',
                      () => _comingSoon(context),
                ),
                const SizedBox(width: 14),
                _pillOrange(
                  '📊 Story que Mede Reação',
                      () => _comingSoon(context),
                ),
              ],
            ),
            const SizedBox(height: 14),

            _wideOrange(
              '🎭 Desafio: Mostre sem Mostrar',
                  () => _comingSoon(context),
            ),
            const SizedBox(height: 18),

            _darkButton(
              '🗨️ Story pra Gerar Conversa',
                  () => _comingSoon(context),
            ),
            const SizedBox(height: 12),

            _darkButton(
              '⚡ Comece o Story de forma Simples',
                  () => _comingSoon(context),
            ),
            const SizedBox(height: 12),

            _darkButton(
              '🚀 Story pra Bombar o Engajamento',
                  () => _comingSoon(context),
            ),
            const SizedBox(height: 12),

            _darkButton(
              '👀 Story que Segura a Atenção',
                  () => _comingSoon(context),
            ),
            const SizedBox(height: 24),

            _backButton(context),
          ],
        ),
      ),
    );
  }
}
