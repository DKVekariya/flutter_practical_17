import 'package:flutter_practical_17/data/models/question.dart';
import 'package:flutter_practical_17/data/repositories/quiz_repository.dart';
import 'package:flutter_practical_17/ui/quiz/quize_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'widget_test.mocks.dart';

@GenerateMocks([QuestionRepository])

void main() {
  late MockQuestionRepository mockRepository;
  late QuizViewModel viewModel;

  setUp(() {
    mockRepository = MockQuestionRepository();
    when(mockRepository.getQuestions()).thenReturn([
      Question(
        text: "What is 2 + 2?",
        options: ["3", "4", "5", "6"],
        correctAnswerIndex: 1,
      ),
      Question(
        text: "What is 3 × 3?",
        options: ["6", "7", "8", "9"],
        correctAnswerIndex: 3,
      ),
    ]);
    viewModel = QuizViewModel(mockRepository);
  });

  group('QuizViewModel Tests', () {
    test('Initial state should be empty', () {
      expect(viewModel.state.questions, isEmpty);
      expect(viewModel.state.userAnswers, isEmpty);
      expect(viewModel.state.currentQuestionIndex, 0);
      expect(viewModel.state.isQuizFinished, false);
    });

    test('startQuiz should initialize questions and answers', () {
      viewModel.startQuiz();

      expect(viewModel.state.questions.length, 2);
      expect(viewModel.state.userAnswers.length, 2);
      expect(viewModel.state.userAnswers.every((element) => element == null), true);
      expect(viewModel.state.currentQuestionIndex, 0);
      expect(viewModel.state.isQuizFinished, false);
    });

    test('selectAnswer should update selectedAnswerIndex', () {
      viewModel.startQuiz();
      viewModel.selectAnswer(2);

      expect(viewModel.state.selectedAnswerIndex, 2);
    });

    test('submitAnswer should record user answer and move to next question', () {
      viewModel.startQuiz();
      viewModel.selectAnswer(1);
      viewModel.submitAnswer();

      expect(viewModel.state.userAnswers[0], 1);
      expect(viewModel.state.currentQuestionIndex, 1);
      expect(viewModel.state.selectedAnswerIndex, null);
    });

    test('submitAnswer on last question should finish quiz', () {
      viewModel.startQuiz();

      // Answer first question
      viewModel.selectAnswer(1);
      viewModel.submitAnswer();

      // Answer second (last) question
      viewModel.selectAnswer(3);
      viewModel.submitAnswer();

      expect(viewModel.state.userAnswers[0], 1);
      expect(viewModel.state.userAnswers[1], 3);
      expect(viewModel.state.isQuizFinished, true);
    });

    test('correctAnswersCount should return number of correct answers', () {
      viewModel.startQuiz();

      // Answer first question correctly
      viewModel.selectAnswer(1);
      viewModel.submitAnswer();

      // Answer second question incorrectly
      viewModel.selectAnswer(2); // Correct is 3
      viewModel.submitAnswer();

      expect(viewModel.state.correctAnswersCount, 1);
    });

    test('excellenceLevel should return appropriate level based on score', () {
      viewModel.startQuiz();

      // Answer both questions correctly
      viewModel.selectAnswer(1);
      viewModel.submitAnswer();
      viewModel.selectAnswer(3);
      viewModel.submitAnswer();

      // 2/2 should be "Excellent"
      expect(viewModel.state.excellenceLevel, "Excellent");
    });

    test('restartQuiz should reset the quiz state', () {
      viewModel.startQuiz();

      // Answer a question
      viewModel.selectAnswer(1);
      viewModel.submitAnswer();

      // Restart the quiz
      viewModel.restartQuiz();

      expect(viewModel.state.currentQuestionIndex, 0);
      expect(viewModel.state.userAnswers.every((element) => element == null), true);
      expect(viewModel.state.isQuizFinished, false);
      expect(viewModel.state.selectedAnswerIndex, null);
    });
  });
}