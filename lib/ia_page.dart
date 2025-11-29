// lib/ia_page.dart
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'services/gemini_service.dart';

class InteligenciaArtificialPage extends StatefulWidget {
  const InteligenciaArtificialPage({Key? key}) : super(key: key);

  @override
  State<InteligenciaArtificialPage> createState() =>
      _InteligenciaArtificialPageState();
}

class _InteligenciaArtificialPageState
    extends State<InteligenciaArtificialPage> {
  final _service = GeminiService.instance;

  final _input = TextEditingController();
  final _scroll = ScrollController();
  final _msgs = <_Msg>[];

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    // mensagem inicial para não ficar vazio
    _msgs.add(
      _Msg(
        'Oi! Sou a IA do Story Feito. Pergunte algo como:\n'
            '• 3 ideias de story para vender hoje\n'
            '• Roteiro de 15s sobre meu produto\n'
            '• Chamada criativa com CTA',
        false,
      ),
    );
  }

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _autoScroll({int delayMs = 120}) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration(milliseconds: delayMs));
      if (!_scroll.hasClients) return;
      _scroll.animateTo(
        _scroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    });
  }

  Future<void> _send() async {
    final text = _input.text.trim();
    if (text.isEmpty || _loading) return;

    FocusScope.of(context).unfocus();

    setState(() {
      _msgs.add(_Msg(text, true));
      _input.clear();
      _loading = true;
    });
    _autoScroll();

    try {
      final reply = await _service
          .generateStoryReply(text)
          .timeout(const Duration(seconds: 30));
      if (!mounted) return;
      setState(() => _msgs.add(_Msg(reply, false)));
    } on TimeoutException {
      _snack('A IA demorou para responder. Tente novamente.');
    } catch (e, s) {
      if (kDebugMode) print('[IA] $e\n$s');
      _snack(
        'Falha ao falar com a IA. Verifique sua internet ou a chave de API.',
      );
    } finally {
      if (!mounted) return;
      setState(() => _loading = false);
      _autoScroll(delayMs: 250);
    }
  }

  void _snack(String m) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF0b1220);
    const mine = Color(0xFF1f2937);
    const bot = Color(0xFF0f172a);

    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: const Text('Crie Storys com a IA'),
        backgroundColor: bg,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            // LISTA DE MENSAGENS
            Expanded(
              child: Container(
                color: bg,
                child: ListView.builder(
                  controller: _scroll,
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  itemCount: _msgs.length,
                  itemBuilder: (_, i) {
                    final m = _msgs[i];
                    final align = m.mine
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start;
                    final color = m.mine ? mine : bot;
                    return Column(
                      crossAxisAlignment: align,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.06),
                            ),
                          ),
                          child: Text(
                            m.text,
                            style: const TextStyle(
                              color: Colors.white,
                              height: 1.55,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),

            // BARRA DE INPUT
            AnimatedPadding(
              duration: const Duration(milliseconds: 160),
              curve: Curves.easeOut,
              padding: EdgeInsets.fromLTRB(12, 0, 12, 12 + bottomInset),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _input,
                      minLines: 1,
                      maxLines: 3,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _send(),
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Digite sua pergunta para a IA…',
                        hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                        ),
                        filled: true,
                        fillColor: const Color(0xFF0f172a),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.white.withOpacity(0.08),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.white.withOpacity(0.08),
                          ),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          borderSide: BorderSide(
                            color: Colors.orange,
                            width: 1,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _loading ? null : _send,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _loading
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
                        : const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Msg {
  final String text;
  final bool mine;
  _Msg(this.text, this.mine);
}
