  import 'dart:convert';
  import 'package:http/http.dart' as http;

  class GeminiApiService {
    final String _apiKey = 'AIzaSyDPs1xiaXvcsIfug38ll41JFn9ZA69s3Yg'; 

    final String _baseUrl =
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';

    final String _promptTemplate = '''
  You are a travel planning assistant. Carefully read and understand the user's prompt for trip duration (e.g., "1 day", "weekend", "3 nights", etc.). Only generate the number of days requested, even if the destination offers more options.

Create a peaceful, mid-range budget itinerary for 4 people. Return only valid JSON in this format:

{
  "title": "Trip Title",
  "startDate": "YYYY-MM-DD",
  "endDate": "YYYY-MM-DD",
  "days": [
    {
      "date": "YYYY-MM-DD",
      "summary": "Short summary",
      "items": [
        {
          "time": "HH:MM",
          "activity": "Activity description",
          "location": "latitude,longitude"
        }
      ]
    }
  ]
}

Strict rules:
- Match the duration exactly as mentioned by the user (e.g., "X day trip" means generate only X day).
- If the prompt is vague or duration is missing, assume 4 days by default.
- Format JSON properly with accurate ISO date and time format.


  Input:
  ''';

   Future<String> getItinerary(String userInput) async {
  if (_apiKey == 'YOUR_API_KEY_HERE') {
    throw Exception('API key not set');
  }

  final uri = Uri.parse('$_baseUrl?key=$_apiKey');
  final body = jsonEncode({
    "contents": [
      {
        "parts": [{"text": '$_promptTemplate "$userInput"'}]
      }
    ],
  });

  final response = await http.post(uri,
      headers: {'Content-Type': 'application/json'}, body: body);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final rawText = data['candidates'][0]['content']['parts'][0]['text'];

    
    final match = RegExp(r'{[\s\S]*}').firstMatch(rawText);
    if (match != null) {
      return match.group(0)!; 
    } else {
      throw FormatException("Could not extract valid JSON from Gemini response.");
    }
  } else {
    throw Exception('Error ${response.statusCode}: ${response.body}');
  }
}

  }
