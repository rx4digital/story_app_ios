import 'package:flutter/material.dart';

class MeSalvaPage extends StatelessWidget {
  const MeSalvaPage({super.key});

  void _comingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Em breve ✨')),
    );
  }

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

          Row(
            children: [
              Expanded(
                child: _tap(
                  onTap: () => _comingSoon(context),
                  child: _goldButton('💸 Preciso Vender Agora!', goldA, goldB),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _tap(
                  onTap: () => _comingSoon(context),
                  child: _goldButton('⚡ Oferta de Última Hora', goldA, goldB),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          _tap(
            onTap: () => _comingSoon(context),
            child: _goldWide('👁️ Story que Segura os Olhares', goldA, goldB),
          ),
          const SizedBox(height: 14),

          _tap(
            onTap: () => _comingSoon(context),
            child: _darkItem('🗣️ Apresente-se em 1 story', darkItem),
          ),
          _tap(
            onTap: () => _comingSoon(context),
            child: _darkItem('🤔 Por que Escolher Você?', darkItem),
          ),
          _tap(
            onTap: () => _comingSoon(context),
            child: _darkItem('📈 Story pra Engajar Já!', darkItem),
          ),
          _tap(
            onTap: () => _comingSoon(context),
            child: _darkItem('🧑‍💼 Abriu Vaga ou Serviço para o Dia', darkItem),
          ),
          _tap(
            onTap: () => _comingSoon(context),
            child: _darkItem('🎯 Combo Imbatível', darkItem),
          ),
        ],
      ),
    );
  }

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
      child: child,
    );
  }
}
