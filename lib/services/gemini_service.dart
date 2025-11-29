// lib/services/gemini_service.dart
import 'package:google_generative_ai/google_generative_ai.dart';

/// Serviço para conversar SOMENTE sobre Storys.
/// Mantém o histórico da conversa enquanto a tela estiver aberta.
class GeminiService {
  // ========= CHAVE DA API =========
  // Se você não passar nada via --dart-define, usa esse fallback.
  // Troque por uma chave sua se quiser.
  static const String _API_KEY_FALLBACK =
      'AIzaSyBxRHaT3_ysMjIoSzOk2myEo-zARXAcaow';

  static const String _API_KEY = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: _API_KEY_FALLBACK,
  );
  // =================================

  /// Prompt fixo com o estilo e regras do assistente.
  static const String _SYSTEM_PROMPT = '''
Você é um assistente simpático e criativo que ajuda o usuário a criar STORYS
para redes sociais. Sua linguagem deve ser leve, empática e inspiradora — como
um amigo especialista em marketing que orienta com entusiasmo e clareza.

💬 Tonalidade: simpática, próxima e motivadora.
💡 Função: ajudar com ideias, ganchos, roteiros, CTAs, formatos e boas práticas.

Regras principais:
- Responda somente sobre Storys e criação de conteúdo.
- Se o usuário pedir algo fora disso, redirecione com educação.
- Respostas curtas ou médias, práticas e aplicáveis.
- Pule duas linhas entre cada dica.
- Pule uma linha entre subitens de uma dica.
- Use títulos como "Dica 1", "Dica 2", etc.
- Sempre termine perguntando se o usuário quer mais ideias ou variações.

Exemplo de estilo:
Dica 1: Mostre o antes e depois

Story 1/3: "Olha essa transformação 😱"
Story 2/3: "Só aplicando o produto e... magia!"
Story 3/3: "Resultado incrível, né?"

Se o usuário pedir “mais dicas”, continue o mesmo tema e mantenha o histórico.
''';

  /// Singleton
  static final GeminiService instance = GeminiService._internal();

  late final GenerativeModel _model;
  ChatSession? _chat;

  GeminiService._internal() {
    _model = GenerativeModel(
      // modelo válido da lib
      model: 'gemini-2.0-flash',
      apiKey: _API_KEY,
      systemInstruction: Content.system(_SYSTEM_PROMPT),
    );

    _chat = _model.startChat(history: [
      Content.model([
        TextPart(
          'Oi! 😄 Que bom te ver por aqui. Me conta: sobre qual tema de story você quer ideias hoje?',
        ),
      ]),
    ]);
  }

  /// Envia a mensagem do usuário mantendo o histórico vivo.
  Future<String> generateStoryReply(String userMessage) async {
    if (_API_KEY.isEmpty) {
      return 'Nenhuma chave de API da IA foi configurada. '
          'Peça suporte para configurar a GEMINI_API_KEY. 😅';
    }

    final userTurn = '''
Usuário: $userMessage

Responda de forma empática e criativa.
Organize com espaçamento entre as dicas e subdicas para melhor leitura.
''';

    try {
      _chat ??= _model.startChat(history: []);

      final response = await _chat!.sendMessage(
        Content.text(userTurn),
      );

      final text = response.text?.trim();
      if (text == null || text.isEmpty) {
        return 'Hmm... não consegui gerar uma ideia agora. Quer tentar reformular o pedido? 😊';
      }

      // Limpa quebras de linha exageradas.
      final formatted = text.replaceAll(RegExp(r'(\n){3,}'), '\n\n');

      return formatted;
    } catch (e) {
      return 'Ops! Parece que houve um probleminha na conversa com a IA. '
          'Verifique sua conexão ou tente novamente em alguns minutos 💬';
    }
  }

  /// Reinicia o histórico.
  void reset() {
    _chat = _model.startChat(history: [
      Content.model([
        TextPart(
          'Tudo certo! 💪 Vamos começar de novo. '
              'Qual tema de story você quer trabalhar agora?',
        ),
      ]),
    ]);
  }
}
