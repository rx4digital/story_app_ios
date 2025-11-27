import 'package:flutter/material.dart';

class CaptacaoClientesPage extends StatelessWidget {
  const CaptacaoClientesPage({super.key});

  void _comingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Em breve ✨')),
    );
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF0E0F11);
    const dark = Color(0xFF0F1B22);
    const goldA = Color(0xFFF4A21A);
    const goldB = Color(0xFFDB8B08);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        title: const Text('💰 Atraia Novos Clientes'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
        children: [
          const Text(
            '💰 Atraia Novos Clientes',
            style: TextStyle(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.w900,
              height: 1.05,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Storys para você vender.',
            style: TextStyle(
              color: Colors.amber.shade300,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: _tap(
                  context,
                  child: _goldButton('🎥 Grave Junto Comigo', goldA, goldB),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _tap(
                  context,
                  child: _goldButton('🌈 Story do Sonho', goldA, goldB),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          _tap(
            context,
            child: _goldWideButton(
              '💪 Vença o Medo em 15 segundos',
              goldA,
              goldB,
            ),
          ),
          const SizedBox(height: 16),

          _tap(
            context,
            child: _darkListButton('🔄 Recupere Clientes com Storys', dark),
          ),
          _tap(
            context,
            child:
            _darkListButton('💬 Story para Atrair Atenção do Cliente', dark),
          ),
          _tap(
            context,
            child: _darkListButton(
                '⏰ Oferta Rápida - Promoção Relâmpago', dark),
          ),
          _tap(
            context,
            child: _darkListButton('📅 Story para Lotar a Agenda', dark),
          ),
          _tap(
            context,
            child: _darkListButton(
                '🎁 Brinde para os 3 Primeiros', dark),
          ),

          const SizedBox(height: 28),
        ],
      ),
    );
  }

  Widget _tap(BuildContext ctx, {required Widget child}) => InkWell(
    borderRadius: BorderRadius.circular(14),
    onTap: () => _comingSoon(ctx),
    child: child,
  );

  Widget _goldButton(String label, Color a, Color b) => Container(
    height: 96,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(14),
      gradient: LinearGradient(colors: [a, b]),
    ),
    child: Text(
      label,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w900,
        fontSize: 24,
        height: 1.05,
      ),
    ),
  );

  Widget _goldWideButton(String label, Color a, Color b) => Container(
    height: 84,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(14),
      gradient: LinearGradient(colors: [a, b]),
    ),
    child: Text(
      label,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w900,
        fontSize: 22,
      ),
    ),
  );

  Widget _darkListButton(String label, Color bg) => Container(
    height: 64,
    alignment: Alignment.centerLeft,
    padding: const EdgeInsets.symmetric(horizontal: 20),
    margin: const EdgeInsets.only(bottom: 12),
    decoration: BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(14),
    ),
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
