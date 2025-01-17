import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiFetching {
  static Future<List<Map<String, dynamic>>> fetchQuestions() async {
    final response = await http.get(Uri.parse('https://api.jsonserve.com/Uw5CrX'));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      // Ensure we are dealing with a map and contain 'questions' key
      if (jsonData is Map && jsonData.containsKey('questions')) {
        final questions = jsonData['questions'] as List<dynamic>;

        return questions.map((q) {
          return {
            'question': q['description'] ?? 'No question provided',  // Ensure question field is a string
            'options': (q['options'] as List<dynamic>?)?.map((option) {
              return {
                'id': option['id'] ?? -1,  // Default id
                'description': option['description'] ?? 'No description',  // Default option description
                'is_correct': option['is_correct'] ?? false,  // Default correctness flag
              };
            }).toList() ?? [],
            'answer': q['answer'] ?? '',  // Default to empty string if answer is null
            'correct': q['correct'] ?? 0,  // Assuming 'correct' is the index of correct answer
          };
        }).toList();
      } else {
        throw Exception('Unexpected API response format');
      }
    } else {
      throw Exception('Failed to fetch data from the API');
    }
  }
}
