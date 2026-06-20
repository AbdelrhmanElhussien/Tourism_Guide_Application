import 'package:google_generative_ai/google_generative_ai.dart';

class AIChatService {
  static const String _apiKey = 'AQ.Ab8RN6JMRARtkiVesPgBWE34TjIxD9yP6JGRAeBSlsfbIA8NWg';

  static const String _systemPrompt = '''
You are "Nefertiti AI", a friendly and expert Egypt tourism assistant inside the "Egypt Tourism Guide" mobile app.

Your role is to help tourists explore Egypt by:
- Recommending amazing places to visit (pyramids, temples, museums, beaches, etc.)
- Suggesting the best hotels and accommodation options
- Planning detailed itineraries
- Explaining Egyptian history and culture in an engaging way
- Recommending local food and restaurants
- Providing transportation advice (trains, flights, Uber, feluccas)
- Answering safety and travel tips
- Finding local certified guides

Rules:
- Always respond in the SAME language the user writes in (Arabic or English).
- Keep responses concise, friendly, and helpful — suitable for a mobile chat interface.
- Use relevant emojis to make responses feel warm and engaging 🇪🇬.
- Format lists using dashes or numbers for readability.
- Use **bold** for important names and places.
- Never go off-topic from Egypt tourism. If asked about unrelated topics, politely redirect.
- When recommending places, always mention the city they are in.
''';

  late final GenerativeModel _model;
  late ChatSession _chat;

  AIChatService() {
    _model = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: _apiKey,
      systemInstruction: Content.system(_systemPrompt),
      generationConfig: GenerationConfig(
        temperature: 0.7,
        maxOutputTokens: 1024,
      ),
    );
    _chat = _model.startChat();
  }

  Future<String> getResponse(String userMessage) async {
    try {
      final response = await _chat.sendMessage(
        Content.text(userMessage),
      );
      return response.text ?? 'Sorry, I could not generate a response. Please try again. 😕';
    } on GenerativeAIException catch (e) {
      if (e.message.contains('API_KEY')) {
        return 'API Key error. Please check the configuration. 🔑';
      }
      return 'An error occurred: ${e.message}. Please try again. 😕';
    } catch (e) {
      return 'Something went wrong. Please check your internet connection and try again. 🌐';
    }
  }

  /// Resets conversation history (used when user clears chat)
  void resetConversation() {
    _chat = _model.startChat();
  }
}
