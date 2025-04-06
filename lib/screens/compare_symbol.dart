import 'package:flutter/material.dart';
import 'dart:math';
import '../utils/game_utils.dart';
import '../utils/image_utils.dart';
import '../utils/app_theme.dart';
import '../utils/screen_utils.dart';
import '../widgets/common_widgets.dart';
import '../widgets/symbols_tutorial.dart';

class CompareSymbolScreen extends StatefulWidget {
  final GameDifficulty difficulty;

  const CompareSymbolScreen({super.key, required this.difficulty});

  @override
  State<CompareSymbolScreen> createState() => _CompareSymbolScreenState();
}

class _CompareSymbolScreenState extends State<CompareSymbolScreen> {
  // Game state variables
  int leftNumber = 0;
  int rightNumber = 0;
  int currentQuestion = 0;
  int correctAnswers = 0;
  String? selectedSymbol;
  bool? isAnswerCorrect;
  bool showResult = false;
  bool showTutorial = true;

  final int totalQuestions = 5;
  final double _dropTargetSize = 80;

  final Random random = Random();
  late int minNumber;
  late int maxNumber;
  late String currentImage;

  @override
  void initState() {
    super.initState();
    _setDifficultyParameters();
    ImageUtils.resetCounter();
    generateNewQuestion();
  }

  void _setDifficultyParameters() {
    switch (widget.difficulty) {
      case GameDifficulty.easy:
        minNumber = 1;
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

  void generateNewQuestion() {
    currentImage = ImageUtils.getNextDecorationImage();
    selectedSymbol = null;
    isAnswerCorrect = null;

    // Generate numbers within the difficulty range
    leftNumber = minNumber + random.nextInt(maxNumber - minNumber + 1);
    rightNumber = minNumber + random.nextInt(maxNumber - minNumber + 1);

    // Make sure numbers are different
    while (leftNumber == rightNumber) {
      rightNumber = minNumber + random.nextInt(maxNumber - minNumber + 1);
    }
  }

  // Process the user's answer
  void checkAnswer() {
    bool leftIsGreater = leftNumber > rightNumber;

    bool correctAnswer;
    if (selectedSymbol == ">") {
      correctAnswer = leftIsGreater;
    } else {
      correctAnswer = !leftIsGreater;
    }

    setState(() {
      isAnswerCorrect = correctAnswer;
      if (isAnswerCorrect!) {
        correctAnswers++;
      }

      // Delay before moving to next question
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

  void closeTutorial() => setState(() => showTutorial = false);
  void restartGame() {
    setState(() {
      currentQuestion = 0;
      correctAnswers = 0;
      showResult = false;
      generateNewQuestion();
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
        title: Text('Symbols Comparison - ${_getDifficultyName()}'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => setState(() => showTutorial = true),
            tooltip: 'Tutorial',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SafeArea(
          child: Stack(
            children: [
              showResult ? _buildResultScreen() : _buildGameScreen(),

              if (showTutorial)
                GameTutorial(
                  steps: SymbolTutorials.getComparisonSymbolTutorialSteps(),
                  onComplete: closeTutorial,
                  titleText: 'Comparison Symbols',
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameScreen() {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight:
              MediaQuery.of(context).size.height -
              AppBar().preferredSize.height -
              MediaQuery.of(context).padding.top,
        ),
        child: IntrinsicHeight(
          child: Padding(
            padding: EdgeInsets.all(
              ScreenUtils.getProportionateScreenWidth(16),
            ),
            child: Column(
              children: [
                // Progress indicator
                GameWidgets.buildProgressBar(
                  currentQuestion: currentQuestion,
                  totalQuestions: totalQuestions,
                  correctAnswers: correctAnswers,
                ),

                SizedBox(height: ScreenUtils.getProportionateScreenHeight(16)),

                GameWidgets.buildDecorationImage(currentImage, height: 120),

                SizedBox(height: ScreenUtils.getProportionateScreenHeight(16)),

                // Instruction text
                GameWidgets.buildInstructionContainer(
                  'Drag the correct symbol between the numbers',
                ),

                SizedBox(height: ScreenUtils.getProportionateScreenHeight(20)),

                // Number comparison area
                _buildComparisonArea(),

                SizedBox(height: ScreenUtils.getProportionateScreenHeight(30)),

                // Symbol selection area
                _buildSymbolSelectionArea(),

                const Spacer(),

                // Feedback area (shows correct/incorrect)
                if (isAnswerCorrect != null)
                  GameWidgets.buildFeedbackArea(isAnswerCorrect!),

                SizedBox(height: ScreenUtils.getProportionateScreenHeight(20)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildComparisonArea() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildNumberBox(leftNumber),

        // Drop target for symbol
        Container(
          width: _dropTargetSize,
          height: _dropTargetSize,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppTheme.primaryColor,
              width: 2,
              style: BorderStyle.solid,
            ),
          ),
          child: DragTarget<String>(
            builder: (context, candidateData, rejectedData) {
              // Show selected symbol if any
              if (selectedSymbol != null) {
                Color symbolColor =
                    isAnswerCorrect == null
                        ? AppTheme.primaryColor
                        : isAnswerCorrect!
                        ? Colors.green
                        : Colors.red;

                return Center(
                  child: Text(
                    selectedSymbol!,
                    style: TextStyle(
                      fontSize: ScreenUtils.adaptiveSize(5.0),
                      fontWeight: FontWeight.bold,
                      color: symbolColor,
                    ),
                  ),
                );
              }

              // Empty container
              return Center(
                child: Icon(
                  Icons.drag_indicator,
                  color: Colors.grey.withValues(alpha: 0.5),
                  size: ScreenUtils.adaptiveSize(2.5),
                ),
              );
            },
            onWillAcceptWithDetails: (data) => selectedSymbol == null,
            onAcceptWithDetails: (details) {
              setState(() {
                selectedSymbol = details.data;
                // Check answer after a slight delay to give visual feedback
                Future.delayed(const Duration(milliseconds: 300), checkAnswer);
              });
            },
          ),
        ),

        // Right number
        _buildNumberBox(rightNumber),
      ],
    );
  }

  Widget _buildNumberBox(int number) {
    double boxSize =
        widget.difficulty == GameDifficulty.hard
            ? ScreenUtils.getProportionateScreenWidth(90)
            : ScreenUtils.getProportionateScreenWidth(80);

    return Container(
      width: boxSize,
      height: boxSize,
      decoration: BoxDecoration(
        gradient: AppTheme.buttonGradient(AppTheme.accentColor),
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.standardShadow,
      ),
      child: Center(
        child: Text(
          number.toString(),
          style: TextStyle(
            fontSize: ScreenUtils.adaptiveSize(3.0),
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildSymbolSelectionArea() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Greater than symbol
        _buildDraggableSymbol(">"),

        // Less than symbol
        _buildDraggableSymbol("<"),
      ],
    );
  }

  Widget _buildDraggableSymbol(String symbol) {
    // Don't allow dragging if a symbol is already selected
    if (selectedSymbol != null) {
      return _buildSymbolContainer(symbol, isActive: false);
    }

    return Draggable<String>(
      data: symbol,
      feedback: Material(
        color: Colors.transparent,
        child: _buildSymbolContainer(symbol, size: 1.2),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: _buildSymbolContainer(symbol, isActive: false),
      ),
      child: _buildSymbolContainer(symbol),
    );
  }

  Widget _buildSymbolContainer(
    String symbol, {
    bool isActive = true,
    double size = 1.0,
  }) {
    return Container(
      width: _dropTargetSize * size,
      height: _dropTargetSize * size,
      decoration: BoxDecoration(
        color:
            isActive
                ? AppTheme.accentColor
                : Colors.grey.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16 * size),
        border: Border.all(color: Colors.white, width: 3 * size),
        boxShadow:
            isActive
                ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
                : null,
      ),
      child: Center(
        child: Text(
          symbol,
          style: TextStyle(
            fontSize: ScreenUtils.adaptiveSize(4.0) * size,
            fontWeight: FontWeight.bold,
            color: isActive ? Colors.white : Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildResultScreen() {
    return GameWidgets.buildResultScreen(
      context: context,
      correctAnswers: correctAnswers,
      totalQuestions: totalQuestions,
      gameTitle: 'Compare Symbols',
      customMessage:
          correctAnswers >= 4
              ? 'Great job! You\'re a symbols comparison expert!'
              : 'Keep practicing! You\'ll get better at comparing symbols!',
    );
  }
}