import 'package:flutter/material.dart';
import 'package:flutter_practical_17/ui/quiz/quize_view_model.dart';
import 'package:flutter_practical_17/ui/quiz/result_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/question.dart';

class QuizScreen extends ConsumerStatefulWidget {
  const QuizScreen({super.key});

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(quizViewModelProvider.notifier).startQuiz();
    });

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final quizState = ref.watch(quizViewModelProvider);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

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
            _buildProgressBar(quizState),
            const SizedBox(height: 8),
            Text(
              'Question ${quizState.currentQuestionIndex + 1}/${quizState.questions.length}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 40),
            FadeTransition(
              opacity: _controller,
              child: _buildQuestionCard(currentQuestion, isDarkMode),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: _buildAnswerOptions(currentQuestion, quizState, isDarkMode),
            ),
            _buildActionButtons(context, quizState),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(QuizState quizState) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 10,
      width: MediaQuery.of(context).size.width * ((quizState.currentQuestionIndex + 1) / quizState.questions.length),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  Widget _buildQuestionCard(Question question, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isDarkMode ? [] : [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Text(
        question.text,
        style: Theme.of(context).textTheme.titleLarge,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildAnswerOptions(Question question, QuizState quizState, bool isDarkMode) {
    return ListView.builder(
      itemCount: question.options.length,
      itemBuilder: (context, index) {
        final isSelected = quizState.selectedAnswerIndex == index;
        final isCorrect = index == question.correctAnswerIndex;
        final isAnswered = quizState.selectedAnswerIndex != null;

        Color backgroundColor = isDarkMode ? Colors.grey[800]! : Colors.white;
        Color textColor = isDarkMode ? Colors.white : Colors.black;

        if (isAnswered) {
          if (isCorrect) {
            backgroundColor = Colors.green.shade100;
            textColor = Colors.green.shade900;
          } else if (isSelected) {
            backgroundColor = Colors.red.shade100;
            textColor = Colors.red.shade900;
          }
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: GestureDetector(
            onTap: isAnswered
                ? null
                : () => ref.read(quizViewModelProvider.notifier).selectAnswer(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? Colors.blue : (isDarkMode ? Colors.grey : Colors.grey.shade300),
                  width: 2,
                ),
              ),
              child: Text(
                question.options[index],
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: textColor),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButtons(BuildContext context, QuizState quizState) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
            child: const Text('Quit'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: quizState.selectedAnswerIndex != null
                ? () => ref.read(quizViewModelProvider.notifier).submitAnswer()
                : null,
            child: const Text('Submit'),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
