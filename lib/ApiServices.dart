import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiApiService {
  final String _apiKey = 'AIzaSyDPs1xiaXvcsIfug38ll41JFn9ZA69s3Yg';
  final String _baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent';

  Future<String> sendPrompt(String prompt) async {
    final uri = Uri.parse('$_baseUrl?key=$_apiKey');
    final String template = '''
You are a travel assistant for a Flutter mobile app.

Given a travel plan, return a structured day-wise itinerary in the following format:

Each day starts with:
Day X: [Short title of the day like "Arrival in Bali & Settle in Ubud"],
followed by multiple bullet points that describe the day's schedule.

Each bullet point should be a natural-sounding sentence prefixed with a label like:
- Morning:
- Transfer:
- Accommodation:
- Afternoon:
- Evening:
- Activity:

Make sure:
- The trip is peaceful and relaxing.
- The suggestions are mid-range budget.
- You focus on low-popularity, hidden-gem type places.
- The structure should match the style of Flutter's Text and _buildItineraryItem() widget-based layout.

Example format:
Day 1: Arrival in Bali & Settle in Ubud  
- Morning: Arrive in Bali, Denpasar Airport.  
- Transfer: Private driver to Ubud (around 1.5 hours).  
- Accommodation: Check-in at a peaceful boutique hotel or villa in Ubud (e.g., Ubud Aura Retreat).  
- Afternoon: Explore Ubud's local area, walk around the tranquil rice terraces at Tegallalang.  
- Evening: Dinner at Locavore (known for farm-to-table cuisine) in peaceful environment.

Now generate a 7-day itinerary for this request:  
"7 days in Bali with 4 people, mid-range budget, low popularity places, peaceful trip"
''';


    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      "contents": [
        {
          "parts": [
            {"text": prompt + template}
          ]
        }
      ]
    });

    try {
      final response = await http.post(uri, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final generatedText = data['candidates'][0]['content']['parts'][0]['text'];
        return generatedText;
      } else {
        print('❌ Error: ${response.statusCode} - ${response.body}');
        return 'Error ${response.statusCode}: ${response.body}';
      }
    } catch (e) {
      print('❌ Exception: $e');
      return 'Exception: $e';
    }
  }
}
