import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import '../models/question.dart';

@injectable
class QuestionRepository {
  List<Question> getQuestions() {
    return [
      Question(
        text: "What is 12 × 8?",
        options: ["86", "96", "106", "116"],
        correctAnswerIndex: 1,
      ),
      Question(
        text: "Solve: 25 + 18 - 9",
        options: ["34", "36", "43", "52"],
        correctAnswerIndex: 0,
      ),
      Question(
        text: "If x = 7, what is 2x + 5?",
        options: ["14", "17", "19", "21"],
        correctAnswerIndex: 2,
      ),
      Question(
        text: "What is the square root of 144?",
        options: ["12", "14", "16", "18"],
        correctAnswerIndex: 0,
      ),
      Question(
        text: "Solve for x: 3x - 7 = 8",
        options: ["3", "5", "7", "9"],
        correctAnswerIndex: 1,
      ),
      Question(
        text: "What is 20% of 150?",
        options: ["15", "20", "30", "40"],
        correctAnswerIndex: 2,
      ),
      Question(
        text: "Simplify: (8 + 3) × 4 - 6",
        options: ["38", "42", "44", "48"],
        correctAnswerIndex: 0,
      ),
      Question(
        text: "If y = 9, what is y² + 3y?",
        options: ["81", "99", "108", "117"],
        correctAnswerIndex: 2,
      ),
      Question(
        text: "What is the value of 5² - 3²?",
        options: ["16", "17", "25", "34"],
        correctAnswerIndex: 0,
      ),
      Question(
        text: "Solve: 240 ÷ 8 × 3",
        options: ["60", "75", "90", "120"],
        correctAnswerIndex: 2,
      ),
    ];
  }
}
