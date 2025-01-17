import 'dart:async';
import 'package:flutter/material.dart';
import 'package:quiz_app/screens/result_screen.dart';
import 'package:quiz_app/services/api_fetching.dart';
import 'package:quiz_app/modules/option_button.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<dynamic> questions = [];
  int currentQuestionIndex = 0;
  Map<int, int?> selectedAnswers = {}; // Store the selected option index for each question
  bool isLoading = true;
  late Timer _timer;
  int _remainingTime = 60; // Timer duration in seconds

  @override
  void initState() {
    super.initState();
    fetchQuestions();
    _startTimer();
  }

  Future<void> fetchQuestions() async {
    questions = await ApiFetching.fetchQuestions();
    setState(() {
      isLoading = false;
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _timer.cancel();
          submitQuiz(); // Auto-submit when time runs out
        }
      });
    });
  }

  void submitQuiz() {
    int score = 0;

    // Iterate through each question and calculate the score
    for (int i = 0; i < questions.length; i++) {
      final selectedIndex = selectedAnswers[i]; // Get the selected answer index for the question
      final correctOptionIndex = questions[i]['correct']; // Correct answer index

      // Check if the question was answered and if the selected answer is correct
      if (selectedIndex != null && selectedIndex == correctOptionIndex) {
        score++;
      }
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(
          score: score,
          total: questions.length,
          questions: questions,
          selectedAnswers: selectedAnswers,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the screen is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Quiz'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: submitQuiz, // Trigger the submitQuiz function
          ),
        ],
        backgroundColor: Colors.teal[600],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
        ),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Question ${currentQuestionIndex + 1}/${questions.length}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            // Question Box with better style
            Container(
              padding: const EdgeInsets.all(20.0),
              margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                questions[currentQuestionIndex]['question'],
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            // Display options in a grid layout
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 2,
                ),
                itemCount: questions[currentQuestionIndex]['options'].length,
                itemBuilder: (context, index) {
                  bool isSelected = selectedAnswers[currentQuestionIndex] == index;

                  return OptionButton(
                    text: '${String.fromCharCode(65 + index)}. ${questions[currentQuestionIndex]['options'][index]['description']}',
                    isSelected: isSelected,
                    onSelected: () {
                      setState(() {
                        selectedAnswers[currentQuestionIndex] = index;
                      });
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Time Left: $_remainingTime seconds', // Timer display
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ),
            // Navigation buttons (Next and Previous)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: currentQuestionIndex > 0
                        ? () {
                      setState(() {
                        currentQuestionIndex--;
                      });
                    }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal[200],
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    child: const Text('Previous'),
                  ),
                  ElevatedButton(
                    onPressed: currentQuestionIndex < questions.length - 1
                        ? () {
                      setState(() {
                        currentQuestionIndex++;
                      });
                    }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal[200],
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    child: const Text('Next'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: LinearProgressIndicator(
                value: (currentQuestionIndex + 1) / questions.length,
                backgroundColor: Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation(Colors.teal),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
