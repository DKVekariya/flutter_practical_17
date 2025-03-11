import 'package:flutter/material.dart';
import 'package:flutter_practical_17/ui/quiz/quize_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'home_screen.dart';

class ResultScreen extends ConsumerWidget {
  final int correctAnswers;
  final int totalQuestions;
  final String excellenceLevel;

  const ResultScreen({
    super.key,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.excellenceLevel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final score = (correctAnswers / totalQuestions) * 100;

    Color levelColor;
    IconData levelIcon;

    if (excellenceLevel == "Excellent") {
      levelColor = Colors.green;
      levelIcon = Icons.star;
    } else if (excellenceLevel == "Very Good") {
      levelColor = Colors.blue;
      levelIcon = Icons.thumb_up;
    } else if (excellenceLevel == "Good") {
      levelColor = Colors.orange;
      levelIcon = Icons.check_circle;
    } else {
      levelColor = Colors.red;
      levelIcon = Icons.error_outline;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Results'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                levelIcon,
                size: 80,
                color: levelColor,
              ),
              const SizedBox(height: 24),
              Text(
                excellenceLevel,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: levelColor,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Your Score: $correctAnswers out of $totalQuestions',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${score.toStringAsFixed(1)}%',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              _buildProgressBar(context, score),
              const SizedBox(height: 40),
              _buildFeedbackMessage(score),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      ref.read(quizViewModelProvider.notifier).restartQuiz();
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text(
                      'Try Again',
                      style: TextStyle(fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                            (route) => false,
                      );
                    },
                    icon: const Icon(Icons.home),
                    label: const Text(
                      'Home',
                      style: TextStyle(fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar(BuildContext context, double score) {
    return Container(
      height: 24,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Flexible(
            flex: score.toInt(),
            child: Container(
              decoration: BoxDecoration(
                color: _getColorForScore(score),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          Flexible(
            flex: (100 - score).toInt(),
            child: Container(),
          ),
        ],
      ),
    );
  }

  Color _getColorForScore(double score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.blue;
    if (score >= 40) return Colors.orange;
    return Colors.red;
  }

  Widget _buildFeedbackMessage(double score) {
    String message;
    if (score >= 80) {
      message = "Amazing work! You've mastered these math problems!";
    } else if (score >= 60) {
      message = "Good job! You're doing well with these math questions.";
    } else if (score >= 40) {
      message = "Not bad! With a bit more practice, you'll improve your math skills.";
    } else {
      message = "Keep practicing! Math skills improve with regular effort.";
    }

    return Text(
      message,
      style: const TextStyle(fontSize: 16),
      textAlign: TextAlign.center,
    );
  }
}