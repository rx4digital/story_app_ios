import 'package:flutter/material.dart';

class ConfiguracoesPage extends StatelessWidget {
  const ConfiguracoesPage({super.key});

  static const _bg = Color(0xFF0E1217);
  static const _card = Color(0xFF121A21);
  static const _muted = Color(0xFF9FB2BB);
  static const _stroke = Color(0xFF1E2A33);

  void _comingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Em breve ✨')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Configurações do App',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
        children: [
          _sectionTitle('Sobre a conta'),
          _tile(
            context,
            icon: Icons.person_rounded,
            label: 'Conta e perfil',
            onTap: () => _comingSoon(context),
          ),
          const SizedBox(height: 18),

          _sectionTitle('Preferências'),
          _tile(
            context,
            icon: Icons.public_rounded,
            label: 'Idioma e região',
            onTap: () => _comingSoon(context),
          ),
          _tile(
            context,
            icon: Icons.privacy_tip_rounded,
            label: 'Permissões do app',
            onTap: () => _comingSoon(context),
          ),
          const SizedBox(height: 18),

          _sectionTitle('Sistema'),
          _tile(
            context,
            icon: Icons.system_update_rounded,
            label: 'Verificar atualizações',
            onTap: () => _comingSoon(context),
          ),
          _tile(
            context,
            icon: Icons.info_rounded,
            label: 'Sobre o app',
            onTap: () => _comingSoon(context),
          ),
          const SizedBox(height: 18),

          _sectionTitle('Ajuda'),
          _tile(
            context,
            icon: Icons.lightbulb_rounded,
            label: 'Sugestões para o app',
            onTap: () => _comingSoon(context),
          ),
          _tile(
            context,
            icon: Icons.share_rounded,
            label: 'Compartilhar app',
            onTap: () => _comingSoon(context),
          ),
          const SizedBox(height: 18),

          _tileDanger(
            context,
            icon: Icons.logout_rounded,
            label: 'Sair da conta',
            onTap: () => _comingSoon(context),
          ),
        ],
      ),
    );
  }

  // ---- UI helpers ----

  Widget _sectionTitle(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Text(
      text,
      style: const TextStyle(
        color: _muted,
        fontWeight: FontWeight.w800,
        letterSpacing: .2,
      ),
    ),
  );

  Widget _tile(
      BuildContext context, {
        required IconData icon,
        required String label,
        required VoidCallback onTap,
      }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _stroke),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        trailing:
        const Icon(Icons.chevron_right_rounded, color: Colors.white),
        onTap: onTap,
      ),
    );
  }

  Widget _tileDanger(
      BuildContext context, {
        required IconData icon,
        required String label,
        required VoidCallback onTap,
      }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF201216),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFF4A2027)),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.red.shade300),
        title: Text(
          label,
          style: TextStyle(
            color: Colors.red.shade200,
            fontWeight: FontWeight.w800,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
