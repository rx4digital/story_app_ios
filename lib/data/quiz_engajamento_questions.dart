// lib/data/quiz_engajamento_questions.dart

class QuizQuestion {
  final String text;
  final List<String> options;
  final int correctIndex;

  const QuizQuestion({
    required this.text,
    required this.options,
    required this.correctIndex,
  });
}

const List<QuizQuestion> quizEngajamentoQuestions = [
  QuizQuestion(
    text: 'Qual formato costuma performar melhor para ensinar algo?',
    options: [
      'Passo a passo visual (1-2-3) + exemplos',
      'Texto corrido sem exemplos',
      'Somente áudio',
      'Apenas um print sem contexto',
    ],
    correctIndex: 0,
  ),
  QuizQuestion(
    text: 'Em um story de venda, qual é o melhor primeiro bloco?',
    options: [
      'Preço e parcela',
      'Benefício direto/ganho',
      'Detalhes técnicos',
      'História da marca',
    ],
    correctIndex: 1,
  ),
  QuizQuestion(
    text: 'Para aumentar retenção, o que ajuda mais?',
    options: [
      'Textão com muitos parágrafos',
      'Música aleatória alta',
      'Gancho forte nos 3 primeiros segundos',
      'Muitos filtros diferentes',
    ],
    correctIndex: 2,
  ),
  QuizQuestion(
    text: 'O CTA mais claro geralmente é…',
    options: [
      'Verde claro com verbo no imperativo',
      'Texto escondido no canto',
      'Apenas um emoji 👀',
      'Link sem contexto',
    ],
    correctIndex: 0,
  ),
  QuizQuestion(
    text: 'Para gerar prova social rápida nos stories:',
    options: [
      'Print de feedbacks + números',
      'Explicar todo o produto',
      'Usar apenas fotos bonitas',
      'Nunca mostrar resultados',
    ],
    correctIndex: 0,
  ),
  QuizQuestion(
    text: 'Frequência ideal para teste A/B nos stories:',
    options: [
      '1-2 vezes por semana',
      '1 vez por ano',
      'Todo story precisa A/B',
      'Nunca testar',
    ],
    correctIndex: 0,
  ),
  QuizQuestion(
    text: 'Um bom “gancho” tem…',
    options: [
      'Conflito/curiosidade específicos',
      'Frases genéricas',
      'Só emojis',
      'Textão de 10 linhas',
    ],
    correctIndex: 0,
  ),
  QuizQuestion(
    text: 'Para ensinar em 3 passos, a ordem é:',
    options: [
      'Problema → Processo → Prova/Resultado',
      'Resultado → Problema → Processo',
      'Processo → Resultado → Qualquer coisa',
      'Qualquer ordem',
    ],
    correctIndex: 0,
  ),
];
