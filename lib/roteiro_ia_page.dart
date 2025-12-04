// lib/roteiro_ia_page.dart
import 'package:flutter/material.dart';

import 'services/gemini_service.dart';
import 'gravar_comigo_page.dart';

class RoteiroIaPage extends StatefulWidget {
  const RoteiroIaPage({Key? key}) : super(key: key);

  @override
  State<RoteiroIaPage> createState() => _RoteiroIaPageState();
}

class _RoteiroIaPageState extends State<RoteiroIaPage> {
  final _promptCtrl = TextEditingController();
  final _roteiroCtrl = TextEditingController();
  final _ia = GeminiService.instance;

  bool _loadingIa = false;

  @override
  void dispose() {
    _promptCtrl.dispose();
    _roteiroCtrl.dispose();
    super.dispose();
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  Future<void> _gerarComIa() async {
    final prompt = _promptCtrl.text.trim();
    if (prompt.isEmpty) {
      _snack('Escreva rapidamente sobre o que é o story 😊');
      return;
    }

    setState(() => _loadingIa = true);

    try {
      final pergunta = '''
Crie um roteiro de story em VÍDEO, em formato de teleprompter, 
para eu falar olhando para a câmera, sobre:

"$prompt"

Regras:
- Frases curtas, respiráveis, boas para ler em voz alta.
- Que caibam bem em 15s a 45s de fala.
- Sem "Dica 1, Dica 2..." — apenas texto corrido dividido em linhas.
- Use quebras de linha para cada frase ou bloco curto.
- Não use markdown, só texto simples.
''';

      final resposta = await _ia.generateStoryReply(pergunta);
      setState(() {
        _roteiroCtrl.text = resposta.trim();
      });
    } catch (e) {
      _snack('Não consegui gerar o roteiro agora. Tente de novo em alguns segundos.');
    } finally {
      if (mounted) setState(() => _loadingIa = false);
    }
  }

  void _abrirGravacao() {
    final texto = _roteiroCtrl.text.trim();
    if (texto.isEmpty) {
      _snack('Crie ou cole um roteiro antes de gravar 😉');
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => GravarComigoPage(roteiro: texto),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF0B0C12);
    const card = Color(0xFF121824);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        foregroundColor: Colors.white,
        title: const Text(
          'Roteiro com IA',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.08)),
              ),
              child: const Text(
                '1️⃣ Conte rapidamente sobre o story que você quer gravar.\n'
                    '2️⃣ Deixe a IA sugerir o roteiro.\n'
                    '3️⃣ Ajuste do seu jeito e depois clique em "Gravar junto comigo".',
                style: TextStyle(
                  color: Color(0xFFCFD9E3),
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              'Sobre o que é esse story?',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 6),

            TextField(
              controller: _promptCtrl,
              maxLines: 3,
              minLines: 2,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Ex.: story vendendo pacote de sobrancelha para novas clientes...',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                filled: true,
                fillColor: card,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Colors.orange, width: 1),
                ),
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              height: 46,
              child: ElevatedButton.icon(
                onPressed: _loadingIa ? null : _gerarComIa,
                icon: _loadingIa
                    ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.black,
                    ),
                  ),
                )
                    : const Icon(Icons.auto_awesome),
                label: Text(
                  _loadingIa ? 'Gerando roteiro...' : 'Gerar roteiro com IA',
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFA51E),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              'Roteiro para o teleprompter',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 6),

            Container(
              decoration: BoxDecoration(
                color: card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.08)),
              ),
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              child: TextField(
                controller: _roteiroCtrl,
                maxLines: 12,
                minLines: 6,
                style: const TextStyle(
                  color: Colors.white,
                  height: 1.4,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'O roteiro gerado pela IA aparece aqui. '
                      'Você pode editar à vontade antes de gravar.',
                  hintStyle: TextStyle(
                    color: Color(0xFF8FA0B3),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _abrirGravacao,
                icon: const Icon(Icons.videocam_rounded),
                label: const Text(
                  'Gravar junto comigo',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF34D399),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            SizedBox(
              height: 46,
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFE53935)),
                  foregroundColor: const Color(0xFFE53935),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Voltar',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
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
