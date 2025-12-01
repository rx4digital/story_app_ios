// lib/quiz_engajamento_page.dart
import 'package:flutter/material.dart';
import 'data/quiz_engajamento_questions.dart';

class QuizEngajamentoPage extends StatefulWidget {
  const QuizEngajamentoPage({super.key});

  @override
  State<QuizEngajamentoPage> createState() => _QuizEngajamentoPageState();
}

class _QuizEngajamentoPageState extends State<QuizEngajamentoPage> {
  late final List<QuizQuestion> _questions;
  int _current = 0;
  final Map<int, int> _answers = {}; // qIndex -> optionIndex

  // ---------- estilos ----------
  BoxDecoration get _darkGrad => const BoxDecoration(
    gradient: LinearGradient(
      colors: [Color(0xFF0F2330), Color(0xFF0D1C24)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
    borderRadius: BorderRadius.all(Radius.circular(18)),
  );

  BoxDecoration get _orangeGrad => const BoxDecoration(
    gradient: LinearGradient(
      colors: [Color(0xFFF5A623), Color(0xFFFF8C3B)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
    borderRadius: BorderRadius.all(Radius.circular(18)),
  );

  @override
  void initState() {
    super.initState();
    // copia a lista e embaralha para variar a ordem a cada abertura
    _questions = List<QuizQuestion>.from(quizEngajamentoQuestions)..shuffle();
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return const Scaffold(
        backgroundColor: Color(0xFF0D1116),
        body: Center(
          child: Text(
            'Sem perguntas cadastradas no momento 😅',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    final q = _questions[_current];

    return Scaffold(
      backgroundColor: const Color(0xFF0D1116),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1116),
        elevation: 0,
        foregroundColor: Colors.white,
        title: const Text(
          'Quiz do Engajamento',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          child: Column(
            children: [
              // progresso
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  minHeight: 8,
                  value: (_current + 1) / _questions.length,
                  backgroundColor: const Color(0xFF1A2630),
                  valueColor:
                  const AlwaysStoppedAnimation(Color(0xFFFF8C3B)),
                ),
              ),
              const SizedBox(height: 12),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Pergunta ${_current + 1} de ${_questions.length}',
                  style: const TextStyle(
                    color: Color(0xFF9CB3C9),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // enunciado
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: _darkGrad,
                child: Text(
                  q.text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    height: 1.3,
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // opções
              Expanded(
                child: ListView.separated(
                  itemCount: q.options.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, i) {
                    final selected = _answers[_current] == i;
                    return InkWell(
                      onTap: () => setState(() => _answers[_current] = i),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 16,
                        ),
                        decoration: _darkGrad.copyWith(
                          border: Border.all(
                            color: selected
                                ? const Color(0xFFFF8C3B)
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              selected
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_off,
                              color: selected
                                  ? const Color(0xFFFF8C3B)
                                  : const Color(0xFF6E869C),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                q.options[i],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // ações
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 56,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: Color(0xFFFF8C3B),
                            width: 2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          foregroundColor: Colors.white,
                        ),
                        onPressed: _current == 0
                            ? null
                            : () => setState(() => _current--),
                        child: const Text(
                          'Voltar',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ).copyWith(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.transparent,
                          ),
                        ),
                        onPressed: () {
                          if (_current < _questions.length - 1) {
                            setState(() => _current++);
                          } else {
                            _finish();
                          }
                        },
                        child: Ink(
                          decoration: _orangeGrad,
                          child: const Center(
                            child: Text(
                              'Próxima',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _finish() {
    int score = 0;
    for (int i = 0; i < _questions.length; i++) {
      final ans = _answers[i];
      if (ans != null && ans == _questions[i].correctIndex) {
        score++;
      }
    }
    showDialog(
      context: context,
      builder: (_) =>
          _ResultDialog(score: score, total: _questions.length),
    );
  }
}

class _ResultDialog extends StatelessWidget {
  final int score;
  final int total;
  const _ResultDialog({required this.score, required this.total});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF131A21),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Resultado',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Você acertou $score de $total.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFFCFD9E3),
                fontSize: 16,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 52,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE53935),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Fechar',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
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
