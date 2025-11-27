import 'package:flutter/material.dart';

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
                      () => _comingSoon(context),
                ),
                const SizedBox(width: 12),
                bigOrange(
                  'Brinde da Semana',
                  Icons.card_giftcard_rounded,
                      () => _comingSoon(context),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Laboratório (laranja largo)
            wideOrange(
              '💡 Ideias para trazer Engajamento',
                  () => _comingSoon(context),
            ),

            const SizedBox(height: 18),

            // lista escura
            darkListButton(
              '🚨 Socorro! Preciso Postar!',
              onTap: () => _comingSoon(context),
            ),
            darkListButton(
              '💰 Atraia Novos Clientes',
              onTap: () => _comingSoon(context),
            ),
            darkListButton(
              '🤝 Stories Pós-Atendimento',
              onTap: () => _comingSoon(context),
            ),
            darkListButton(
              '💡 Ideia Rápida de Story',
              onTap: () => _comingSoon(context),
            ),
            darkListButton(
              '🚀 Modo Turbo de Storys',
              onTap: () => _comingSoon(context),
            ),
            darkListButton(
              '🤖 Crie com a IA (inteligência artificial)',
              onTap: () => _comingSoon(context),
            ),

            // Configurações (vermelho)
            redButton(
              'Configurações do App',
                  () => _comingSoon(context),
            ),
          ],
        ),
      ),
    );
  }
}
