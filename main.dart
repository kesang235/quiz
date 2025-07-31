import 'package:flutter/material.dart';
import 'dart:math';
import 'questionbank.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomePage(),
    );
  }
}

// Homepage with Start button
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Loading()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.lightGreen,
            foregroundColor: Colors.black,
            textStyle: const TextStyle(fontSize: 20),
          ),
          child: const Text('START QUIZ'),
        ),
      ),
    );
  }
}

// Countdown Screen
class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const QuizPage()),
      );
    });
    return const Scaffold(
      body: Center(
        child: Text(
          'STARTING QUIZ',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

// Quiz Page
class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final List<UserResponse> userResponses = [];
  late List<Bank> quizQuestions;
  int currentIndex = 0;
  int score = 0;
  late DateTime startTime;

  @override
  void initState() {
    super.initState();
    quizQuestions = List.from(fullQuestionBank)..shuffle();
    quizQuestions = quizQuestions.take(10).toList();
    startTime = DateTime.now();
  }

  void handleAnswer(int selectedOption) {
    final question = quizQuestions[currentIndex];
    final isCorrect = selectedOption == question.answer;
    final timeTaken = DateTime.now().difference(startTime).inSeconds;

    userResponses.add(UserResponse(
      question: question.question,
      category: question.category,
      isCorrect: isCorrect,
      timeTaken: timeTaken,
    ));

    if (isCorrect) score++;

    if (currentIndex < quizQuestions.length - 1) {
      setState(() {
        currentIndex++;
        startTime = DateTime.now(); // Reset for next question
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ResultPage(score: score, responses: userResponses),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = quizQuestions[currentIndex];

    return Scaffold(
      appBar: AppBar(title: Text("Question ${currentIndex + 1}")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              question.question,
              style:
              const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ...List.generate(question.options.length, (i) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ElevatedButton(
                  onPressed: () => handleAnswer(i),
                  child: Text(question.options[i]),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

// Result Page
class ResultPage extends StatelessWidget {
  final int score;
  final List<UserResponse> responses;
  const ResultPage({super.key, required this.score, required this.responses});

  @override
  Widget build(BuildContext context) {
    for (var response in responses) {
      print(response.toJson());
    }
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Quiz Completed!\nScore: $score / ${responses.length}',
              style: const TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: const Text("Retry Quiz"),
            )
          ],
        ),
      ),
    );
  }
}
