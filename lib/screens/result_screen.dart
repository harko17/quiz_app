import 'package:flutter/material.dart';
import 'package:quiz_app/screens/quiz_screen.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  final int total;
  final List<dynamic> questions;
  final Map<int, int?> selectedAnswers;

  const ResultScreen({
    Key? key,
    required this.score,
    required this.total,
    required this.questions,
    required this.selectedAnswers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Quiz Results'),
        backgroundColor: Colors.teal,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade300, Colors.blue.shade500],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Your Score: $score/$total',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  score == total
                      ? 'Perfect Score! 🎉'
                      : score > total / 2
                      ? 'Good job! 👍'
                      : 'Better luck next time! 🤔',
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.white70,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 40),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: questions.length,
                    itemBuilder: (context, index) {
                      final question = questions[index];
                      final selectedOptionIndex = selectedAnswers[index];
                      final correctOptionIndex = question['correct'];

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Q${index + 1}: ${question['question']}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Your answer: ${selectedOptionIndex != null ? question['options'][selectedOptionIndex]['description'] : 'Not Selected'}',
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(
                                'Correct answer: ${question['options'][correctOptionIndex]['description']}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const QuizScreen()),
                          (route) => false, // Removes all previous routes
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  child: const Text('Restart Quiz'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
