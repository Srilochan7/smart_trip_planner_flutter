# Smart Trip Planner

Smart Trip Planner is a Flutter application that leverages Google Gemini AI to generate personalized travel itineraries based on user input. The app is designed to help users plan peaceful, mid-range budget trips for groups, providing day-by-day activities, locations, and summaries in a structured format.

---

## Features

- **AI-Powered Itinerary Generation:** Uses Gemini API to create custom travel plans.
- **Flexible Input:** Users can specify trip duration, destination, and preferences.
- **Structured Output:** Returns itineraries in valid JSON, including dates, activities, and locations.
- **Error Handling:** Validates AI responses and provides user-friendly error messages.
- **Scalable Architecture:** Clean separation of UI, business logic, and data layers.

---

## Architecture Overview

```
+-----------------------------+
|         Presentation        |
|  (UI: Screens, Widgets)     |
+-------------+---------------+
              |
              v
+-----------------------------+
|         Domain Layer        |
| (Business Logic, Providers) |
+-------------+---------------+
              |
              v
+-----------------------------+
|         Data Layer          |
|  - ApiServices.dart         |
|  - Models (Itinerary, etc.) |
+-------------+---------------+
              |
              v
+-----------------------------+
|      External Services      |
|  - Gemini API (Google AI)   |
|  - HTTP Client              |
+-----------------------------+
```

### Agent Chain Flow

1. **User Input:** User enters trip details in the app.
2. **Prompt Construction:** The app merges user input with a prompt template.
3. **API Call:** The prompt is sent to Gemini via `GeminiApiService`.
4. **AI Response:** Gemini returns a response containing a JSON itinerary.
5. **Parsing & Validation:** The app extracts and validates the JSON.
6. **Display:** The itinerary is shown in the UI or an error is displayed.

---

## File Structure

```
lib/
├── Features/
│   └── Services/
│       └── ApiServices.dart   # Handles Gemini API communication
├── Models/
│   └── itinerary.dart         # (Example) Data models for itineraries
├── main.dart                  # App entry point
```

---

## Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- A valid Google Gemini API key

### Installation

1. **Clone the repository:**
   ```sh
   git clone https://github.com/yourusername/smart_trip_planner.git
   cd smart_trip_planner
   ```

2. **Install dependencies:**
   ```sh
   flutter pub get
   ```

3. **Set your Gemini API key:**
   - Open `lib/Features/Services/ApiServices.dart`
   - Replace the placeholder in `_apiKey` with your actual API key:
     ```dart
     final String _apiKey = 'YOUR_API_KEY_HERE';
     ```

4. **Run the app:**
   ```sh
   flutter run
   ```

---

## Usage

1. Launch the app.
2. Enter your trip details (destination, duration, preferences).
3. Submit to generate a custom itinerary.
4. View your day-by-day travel plan.

---

## Example API Service

```dart
class GeminiApiService {
  final String _apiKey = 'YOUR_API_KEY_HERE';
  final String _baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';
  // ... prompt template and getItinerary() as in source ...
}
```

---

## Contributing

1. Fork the repository.
2. Create your feature branch (`git checkout -b feature/YourFeature`).
3. Commit your changes (`git commit -am 'Add some feature'`).
4. Push to the branch (`git push origin feature/YourFeature`).
5. Open a pull request.

---

## License

This project is licensed under the MIT License.

---

---

## Contact

For questions or support, open an issue or contact [srilochan7@example.com](mailto:srilochan7@gmail.com).
