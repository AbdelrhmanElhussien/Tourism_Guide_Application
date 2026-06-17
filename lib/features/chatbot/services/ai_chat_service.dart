import 'dart:async';
import 'dart:math';

class AIChatService {
  // Pre-defined rich responses for Egypt travel
  final Map<String, String> _quickActionResponses = {
    'Recommend Places': 'Here are some top recommended places in Egypt! 🇪🇬\n\n'
        '1. **Giza Pyramids & Sphinx** (Cairo): The ultimate ancient wonder of the world.\n'
        '2. **Karnak & Luxor Temples** (Luxor): The largest open-air museum and religious site in history.\n'
        '3. **Valley of the Kings** (Luxor): Royal tombs carved deep into the desert hills.\n'
        '4. **Abu Simbel Temples** (Aswan): Magnificent temples built by King Ramesses II.\n'
        '5. **Khan El-Khalili** (Cairo): Vibrant historic bazaar filled with spices, perfume, and local souvenirs.',

    'Find Hotels': 'I can help you find the best places to stay in Egypt! 🏨\n\n'
        '- **Cairo**: Marriott Mena House (Pyramids view) or The Nile Ritz-Carlton (Nile view).\n'
        '- **Luxor**: Sofitel Winter Palace (Historic, elegant, and hosted royalty).\n'
        '- **Aswan**: Sofitel Legend Old Cataract (Iconic heritage hotel overlooking the Nile).\n'
        '- **Red Sea (Hurghada/Sharm)**: Rixos Premium or Steigenberger resorts for luxury beach relaxation.\n\n'
        'Would you like to search for budget, mid-range, or luxury accommodations in a specific city?',

    'Find Guides': 'Egypt is rich in history, and a certified Egyptologist guide will make your trip unforgettable! 🤠\n\n'
        'I can recommend top-rated local guides in Cairo, Luxor, and Aswan who speak English, Arabic, Spanish, French, German, or Chinese.\n\n'
        'They will explain the hieroglyphs, handle ticketing, and guide you away from tourist crowds. Would you like me to find a guide for a specific city?',

    'Transportation Options': 'Here are the best ways to get around Egypt! 🚆🚕✈️\n\n'
        '- **Between Cities**: Domestic flights (EgyptAir) are fast. The Sleeper Train from Cairo to Luxor/Aswan is a classic experience. For budget travel, Go Bus offers reliable AC coaches.\n'
        '- **Within Cities**: Uber is highly recommended in Cairo and Alexandria—it is safe, tracked, and cheap. The Cairo Metro is excellent to avoid traffic.\n'
        '- **Nile Crossings**: Feluccas (traditional sailboats) or motorboats are perfect and scenic in Luxor and Aswan.',

    'Plan My Trip': 'Let\'s design a perfect Egyptian adventure! 🗓️ Here is a classic 7-day itinerary:\n\n'
        '- **Days 1-2**: Cairo (Pyramids of Giza, Egyptian Museum, NMEC, and Khan El-Khalili).\n'
        '- **Days 3-5**: Luxor (Fly or take train to Luxor. Visit Valley of the Kings, Karnak, and Luxor Temples. Highly recommend a sunrise hot air balloon!)\n'
        '- **Days 6-7**: Aswan (Visit Philae Temple, High Dam, and a day trip to Abu Simbel before returning to Cairo).\n\n'
        'Would you like to customize this to include a Nile Cruise or Red Sea beach relaxation?',

    'Nearby Attractions': 'Based on popular destinations, here are must-see nearby attractions! 📍\n\n'
        '- **Near Cairo Pyramids**: The Grand Egyptian Museum (GEM) and the Sphinx.\n'
        '- **Near Cairo Downtown**: Coptic Cairo, Islamic Cairo, and Al-Azhar Park (great sunset view).\n'
        '- **Near Luxor West Bank**: Hatshepsut Temple, Colossi of Memnon, and Medinet Habu.\n'
        '- **Near Aswan**: Elephantine Island and the Nubian Village.\n\n'
        'Which city are you currently exploring or planning to visit?'
  };

  final List<String> _generalResponses = [
    'That is a great question! Egypt is full of wonders. Is there a specific city (Cairo, Luxor, Aswan, Sharm El-Sheikh) you want to ask about?',
    'Fascinating choice! Egypt is rich in culture. Don\'t forget to try traditional foods like Koshary, Falafel, and Molokhia during your stay! 🍲',
    'I\'d love to help you with that! Safety tip: Egypt is very welcoming to tourists, but it is always good practice to use registered transport (like Uber) and hire licensed guides.',
    'Egypt has great weather! The best time to visit historical sites is from October to April when the weather is cooler. Summer is perfect for Red Sea diving! ☀️🏖️',
    'Interesting! Are you interested in ancient history, modern local experiences, or beautiful beach resorts?'
  ];

  Future<String> getResponse(String userMessage) {
    // Artificial delay to simulate thinking/typing
    final completer = Completer<String>();
    
    Timer(const Duration(milliseconds: 1500), () {
      // Check if message matches quick actions
      String normalized = userMessage.trim();
      
      // Exact or case-insensitive match for quick actions
      for (var entry in _quickActionResponses.entries) {
        if (entry.key.toLowerCase() == normalized.toLowerCase()) {
          completer.complete(entry.value);
          return;
        }
      }

      // Keyword matching
      final msg = normalized.toLowerCase();
      if (msg.contains('pyramid') || msg.contains('giza') || msg.contains('sphinx')) {
        completer.complete('The Giza Pyramids and Sphinx are open daily from 8 AM to 5 PM. I recommend visiting early in the morning to beat the heat and crowds. Don\'t miss the Sound & Light show in the evening! 🌅');
      } else if (msg.contains('hotel') || msg.contains('stay') || msg.contains('room')) {
        completer.complete(_quickActionResponses['Find Hotels']!);
      } else if (msg.contains('guide') || msg.contains('tourist') || msg.contains('egyptologist')) {
        completer.complete(_quickActionResponses['Find Guides']!);
      } else if (msg.contains('transport') || msg.contains('train') || msg.contains('bus') || msg.contains('uber') || msg.contains('taxi')) {
        completer.complete(_quickActionResponses['Transportation Options']!);
      } else if (msg.contains('itinerary') || msg.contains('plan') || msg.contains('trip')) {
        completer.complete(_quickActionResponses['Plan My Trip']!);
      } else if (msg.contains('food') || msg.contains('eat') || msg.contains('restaurant') || msg.contains('koshary')) {
        completer.complete('You must try Egyptian cuisine! 🍲\n'
            '- **Koshary**: Egypt\'s national dish (pasta, rice, lentils, chickpeas, onions, and spicy tomato sauce).\n'
            '- **Ta\'ameya**: Egyptian falafel made with fava beans (fluffy and delicious).\n'
            '- **Ful Medames**: Slow-cooked fava beans, a breakfast staple.\n'
            '- **Molokhia**: A green leafy soup served with rice and chicken.\n\n'
            'Let me know if you want recommendations for top-rated restaurants!');
      } else if (msg.contains('safety') || msg.contains('safe')) {
        completer.complete('Egypt is generally very safe for tourists. Major tourist sites, hotels, and airports have strong security measures. Just use common sense, avoid unlicensed street vendors, and use official ride-hailing apps like Uber.');
      } else {
        // Return a random response from general responses
        final random = Random();
        completer.complete(_generalResponses[random.nextInt(_generalResponses.length)]);
      }
    });

    return completer.future;
  }
}
