import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'sobre_rayanne_page.dart';

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

  void _toast(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  Future<void> _abrirUrl(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      _toast(context, 'Não foi possível abrir o link.');
    }
  }

  void _showIdiomaRegiaoSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: _card,
      isScrollControlled: false,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Row(
                children: [
                  Icon(Icons.public_rounded, color: Colors.white),
                  SizedBox(width: 10),
                  Text(
                    'Idioma e região',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Novas opções em breve. Padrão atual: Português (BR)',
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3A4B59),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'Fechar',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
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
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
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
          _tile(
            context,
            icon: Icons.subscriptions_rounded,
            label: 'Planos e assinaturas',
            onTap: () => _comingSoon(context),
          ),
          const SizedBox(height: 18),

          _sectionTitle('Preferências'),
          _tile(
            context,
            icon: Icons.public_rounded,
            label: 'Idioma e região',
            onTap: () => _showIdiomaRegiaoSheet(context),
          ),
          _tile(
            context,
            icon: Icons.notifications_active_rounded,
            label: 'Notificações',
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
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SobreRayannePage(
                    image: const AssetImage('assets/rayanne.jpg'),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 18),

          _sectionTitle('Ajuda'),
          _tile(
            context,
            icon: Icons.lightbulb_rounded,
            label: 'Sugestões para o app',
            onTap: () => _abrirUrl(
              context,
              'https://www.rx4digital.com.br/storyfeito',
            ),
          ),
          _tile(
            context,
            icon: Icons.help_outline_rounded,
            label: 'Central de ajuda',
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
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: Colors.white,
        ),
        onTap: onTap,
      ),
    );
  }
}
