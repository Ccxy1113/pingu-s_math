import 'package:flutter/material.dart';
import 'dart:math';
import '../utils/image_utils.dart';
import '../utils/app_theme.dart';
import '../utils/game_utils.dart';
import '../utils/screen_utils.dart';
import '../widgets/common_widgets.dart';

class CompareNumbersScreen extends StatefulWidget {
  final GameDifficulty difficulty;

  const CompareNumbersScreen({super.key, required this.difficulty});

  @override
  _CompareNumbersScreenState createState() => _CompareNumbersScreenState();
}

class _CompareNumbersScreenState extends State<CompareNumbersScreen> {
  // Game state variables
  int leftNumber = 0;
  int rightNumber = 0;
  int currentQuestion = 0;
  int correctAnswers = 0;
  bool askingForBigger = true;
  bool? isAnswerCorrect;
  bool showResult = false;
  final int totalQuestions = 10;
  late String currentImage;

  // Game parameters
  final Random random = Random();
  late int minNumber;
  late int maxNumber;

  @override
  void initState() {
    super.initState();
    _setDifficultyRanges();
    ImageUtils.resetCounter();
    generateNewQuestion();
  }

  // Set number ranges based on selected difficulty
  void _setDifficultyRanges() {
    switch (widget.difficulty) {
      case GameDifficulty.easy:
        minNumber = 0;
        maxNumber = 9;
        break;
      case GameDifficulty.medium:
        minNumber = 10;
        maxNumber = 99;
        break;
      case GameDifficulty.hard:
        minNumber = 100;
        maxNumber = 999;
        break;
    }
  }

  // Generate comparison question
  void generateNewQuestion() {
    // Generate two different numbers
    do {
      leftNumber = minNumber + random.nextInt(maxNumber - minNumber + 1);
      rightNumber = minNumber + random.nextInt(maxNumber - minNumber + 1);
    } while (leftNumber == rightNumber);

    currentImage = ImageUtils.getNextDecorationImage();
    askingForBigger = random.nextBool();
    isAnswerCorrect = null;
  }

  void checkAnswer(bool userSelectedLeft) {
    bool leftIsGreater = leftNumber > rightNumber;
    bool correctAnswer;

    if (askingForBigger) {
      correctAnswer =
          (userSelectedLeft && leftIsGreater) ||
          (!userSelectedLeft && !leftIsGreater);
    } else {
      correctAnswer =
          (userSelectedLeft && !leftIsGreater) ||
          (!userSelectedLeft && leftIsGreater);
    }

    setState(() {
      isAnswerCorrect = correctAnswer;
      if (correctAnswer) correctAnswers++;

      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          if (currentQuestion < totalQuestions - 1) {
            currentQuestion++;
            generateNewQuestion();
          } else {
            showResult = true;
          }
        });
      });
    });
  }

  String _getDifficultyName() {
    switch (widget.difficulty) {
      case GameDifficulty.easy:
        return 'Easy';
      case GameDifficulty.medium:
        return 'Medium';
      case GameDifficulty.hard:
        return 'Hard';
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtils.init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Compare Numbers - ${_getDifficultyName()}'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SafeArea(
          child: showResult ? _buildResultScreen() : _buildGameScreen(),
        ),
      ),
    );
  }

  Widget _buildGameScreen() {
    return Padding(
      padding: EdgeInsets.all(ScreenUtils.getProportionateScreenWidth(16)),
      child: Column(
        children: [
          // Progress bar
          GameWidgets.buildProgressBar(
            currentQuestion: currentQuestion,
            totalQuestions: totalQuestions,
            correctAnswers: correctAnswers,
          ),

          SizedBox(height: ScreenUtils.getProportionateScreenHeight(16)),

          // Decoration image
          GameWidgets.buildDecorationImage(currentImage, height: 150),

          SizedBox(height: ScreenUtils.getProportionateScreenHeight(16)),

          // Instruction container
          Container(
            padding: const EdgeInsets.all(16),
            decoration: AppTheme.iceContainerDecoration,
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                  fontSize: ScreenUtils.adaptiveSize(2.2),
                  color: AppTheme.primaryTextColor,
                ),
                children: [
                  const TextSpan(text: 'Which number is '),
                  TextSpan(
                    text: askingForBigger ? 'BIGGER' : 'SMALLER',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700,
                    ),
                  ),
                  const TextSpan(text: '?'),
                ],
              ),
            ),
          ),

          SizedBox(height: ScreenUtils.getProportionateScreenHeight(24)),

          // Number comparison area
          _buildComparisonArea(),

          const Spacer(),

          // Feedback area
          if (isAnswerCorrect != null)
            GameWidgets.buildFeedbackArea(isAnswerCorrect!),

          SizedBox(height: ScreenUtils.getProportionateScreenHeight(16)),
        ],
      ),
    );
  }

  Widget _buildComparisonArea() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Left number button
        _buildNumberButton(leftNumber, true),

        // Question mark
        SizedBox(
          width: ScreenUtils.getProportionateScreenWidth(50),
          child: Text(
            '?',
            style: TextStyle(
              fontSize: ScreenUtils.adaptiveSize(4.0),
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryTextColor,
            ),
            textAlign: TextAlign.center,
          ),
        ),

        // Right number button
        _buildNumberButton(rightNumber, false),
      ],
    );
  }

  Widget _buildNumberButton(int number, bool isLeft) {
    Color buttonColor = AppTheme.primaryColor;

    if (isAnswerCorrect != null) {
      bool leftIsGreater = leftNumber > rightNumber;
      bool correctButtonIsLeft =
          askingForBigger ? leftIsGreater : !leftIsGreater;

      // Correct answer is always green
      if (isLeft == correctButtonIsLeft) {
        buttonColor = Colors.green;
      }
      // Wrong answer is red if user selected it
      else if (isAnswerCorrect == false && isLeft != correctButtonIsLeft) {
        buttonColor = Colors.red;
      }
    }

    double size = widget.difficulty == GameDifficulty.hard ? 140 : 120;

    return GestureDetector(
      onTap: isAnswerCorrect == null ? () => checkAnswer(isLeft) : null,
      child: GameWidgets.buildNumberContainer(
        number,
        width: size,
        height: size,
        color: buttonColor,
      ),
    );
  }

  Widget _buildResultScreen() {
    String difficultyText = _getDifficultyName().toLowerCase();
    int threshold = (totalQuestions * 0.7).round();

    String successMessage =
        correctAnswers >= threshold
            ? 'Great job! You\'re a $difficultyText number comparing expert!'
            : 'Keep practicing $difficultyText numbers! You\'ll get better at comparing!';

    return GameWidgets.buildResultScreen(
      context: context,
      correctAnswers: correctAnswers,
      totalQuestions: totalQuestions,
      gameTitle: 'Compare Numbers',
      customMessage: successMessage,
    );
  }
}
