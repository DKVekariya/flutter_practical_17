import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import '../../data/models/question.dart';
import '../../data/repositories/quiz_repository.dart';

final getIt = GetIt.instance;

final quizViewModelProvider = StateNotifierProvider<QuizViewModel, QuizState>(
      (ref) => QuizViewModel(getIt<QuestionRepository>()),
);

class QuizState {
  final List<Question> questions;
  final int currentQuestionIndex;
  final List<int?> userAnswers;
  final bool isQuizFinished;
  final int? selectedAnswerIndex;

  QuizState({
    required this.questions,
    this.currentQuestionIndex = 0,
    required this.userAnswers,
    this.isQuizFinished = false,
    this.selectedAnswerIndex,
  });

  QuizState copyWith({
    List<Question>? questions,
    int? currentQuestionIndex,
    List<int?>? userAnswers,
    bool? isQuizFinished,
    int? selectedAnswerIndex,
  }) {
    return QuizState(
      questions: questions ?? this.questions,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      userAnswers: userAnswers ?? this.userAnswers,
      isQuizFinished: isQuizFinished ?? this.isQuizFinished,
      selectedAnswerIndex: selectedAnswerIndex,
    );
  }

  int get correctAnswersCount {
    int count = 0;
    for (int i = 0; i < questions.length; i++) {
      if (userAnswers[i] == questions[i].correctAnswerIndex) {
        count++;
      }
    }
    return count;
  }

  String get excellenceLevel {
    final score = correctAnswersCount;
    if (score <= 3) return "Needs Improvement";
    if (score <= 6) return "Good";
    if (score <= 8) return "Very Good";
    return "Excellent";
  }
}

@injectable
class QuizViewModel extends StateNotifier<QuizState> {
  final QuestionRepository _questionRepository;

  QuizViewModel(this._questionRepository)
      : super(QuizState(
    questions: [],
    userAnswers: [],
  ));

  void startQuiz() {
    final questions = _questionRepository.getQuestions();
    state = QuizState(
      questions: questions,
      userAnswers: List.filled(questions.length, null),
    );
  }

  void selectAnswer(int answerIndex) {
    state = state.copyWith(selectedAnswerIndex: answerIndex);
  }

  void submitAnswer() {
    if (state.selectedAnswerIndex == null) return;

    final updatedAnswers = List<int?>.from(state.userAnswers);
    updatedAnswers[state.currentQuestionIndex] = state.selectedAnswerIndex;

    if (state.currentQuestionIndex == state.questions.length - 1) {
      state = state.copyWith(
        userAnswers: updatedAnswers,
        isQuizFinished: true,
      );
    } else {
      state = state.copyWith(
        userAnswers: updatedAnswers,
        currentQuestionIndex: state.currentQuestionIndex + 1,
        selectedAnswerIndex: null,
      );
    }
  }

  void restartQuiz() {
    startQuiz();
  }
}