
import 'package:flutter/material.dart';
import 'package:flutter_practical_17/ui/quiz/quize_view_model.dart';
import 'package:flutter_practical_17/ui/quiz/result_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'answer_option_widget.dart';
import 'home_screen.dart';

class QuizScreen extends ConsumerStatefulWidget {
  const QuizScreen({super.key});

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(quizViewModelProvider.notifier).startQuiz();
    });
  }

  @override
  Widget build(BuildContext context) {
    final quizState = ref.watch(quizViewModelProvider);

    if (quizState.questions.isEmpty) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (quizState.isQuizFinished) {
      return ResultScreen(
        correctAnswers: quizState.correctAnswersCount,
        totalQuestions: quizState.questions.length,
        excellenceLevel: quizState.excellenceLevel,
      );
    }

    final currentQuestion = quizState.questions[quizState.currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('MathQuest'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            LinearProgressIndicator(
              value: (quizState.currentQuestionIndex + 1) /
                  quizState.questions.length,
              backgroundColor: Colors.grey.shade300,
              color: Colors.blue,
              minHeight: 10,
              borderRadius: BorderRadius.circular(5),
            ),
            const SizedBox(height: 8),
            Text(
              'Question ${quizState.currentQuestionIndex + 1}/${quizState.questions.length}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Text(
                currentQuestion.text,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: ListView.builder(
                itemCount: currentQuestion.options.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: AnswerOption(
                      text: currentQuestion.options[index],
                      isSelected: quizState.selectedAnswerIndex == index,
                      onTap: () {
                        ref
                            .read(quizViewModelProvider.notifier)
                            .selectAnswer(index);
                      },
                    ),
                  );
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                            (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                      ),
                    ),
                    child: const Text(
                      'Quit',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(width: 16), // Optional spacing between buttons
                Expanded(
                  child: ElevatedButton(
                    onPressed: quizState.selectedAnswerIndex != null
                        ? () {
                      ref.read(quizViewModelProvider.notifier).submitAnswer();
                    }
                        : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                      ),
                    ),
                    child: const Text(
                      'Submit Answer',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}