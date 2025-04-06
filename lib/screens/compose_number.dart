import 'package:flutter/material.dart';
import 'dart:math';
import '../utils/app_theme.dart';
import '../utils/screen_utils.dart';
import '../widgets/common_widgets.dart';
import '../utils/image_utils.dart';
import '../widgets/compose_tutorial.dart';
import '../utils/game_utils.dart';

class ComposingNumbersScreen extends StatefulWidget {
  final GameDifficulty difficulty;

  const ComposingNumbersScreen({super.key, required this.difficulty});

  @override
  State<ComposingNumbersScreen> createState() => _ComposingNumbersScreenState();
}

class _ComposingNumbersScreenState extends State<ComposingNumbersScreen> {
  // Game constants
  final int totalQuestions = 5;
  final int numberOfOptions = 5;
  late int minTargetNumber;
  late int maxTargetNumber;

  // Game state
  int currentQuestion = 0;
  int correctAnswers = 0;
  bool showResult = false;
  bool? isAnswerCorrect;
  String currentImage = '';
  int targetNumber = 0;
  List<int> availableNumbers = [];
  List<int> selectedNumbers = [];
  int currentSum = 0;
  bool showTutorial = true;

  // Random generator
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    _setDifficultyParameters();
    generateNewQuestion();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (showTutorial) {
        ComposeTutorial.showTutorialDialog(context, () {
          setState(() => showTutorial = false);
        });
      }
    });
  }

  // Set difficulty
  void _setDifficultyParameters() {
    switch (widget.difficulty) {
      case GameDifficulty.easy:
        minTargetNumber = 3;
        maxTargetNumber = 9;
        break;
      case GameDifficulty.medium:
        minTargetNumber = 10;
        maxTargetNumber = 99;
        break;
      case GameDifficulty.hard:
        minTargetNumber = 100;
        maxTargetNumber = 999;
        break;
    }
  }

  // Generate a new question with a target number and options
  void generateNewQuestion() {
    currentImage = ImageUtils.getNextDecorationImage();

    // Reset selection state
    selectedNumbers = [];
    currentSum = 0;
    isAnswerCorrect = null;

    // Generate target number based on difficulty
    targetNumber = _generateTargetNumber();

    // Generate available numbers
    generateAvailableNumbers();
  }

  // Generate an appropriate target number based on difficulty
  int _generateTargetNumber() {
    // Easy level
    if (widget.difficulty == GameDifficulty.easy) {
      return minTargetNumber +
          random.nextInt(maxTargetNumber - minTargetNumber + 1);
    }
    // Medium level
    if (widget.difficulty == GameDifficulty.medium) {
      return random.nextBool()
          ? (1 + random.nextInt(9)) * 10
          : minTargetNumber +
              random.nextInt(maxTargetNumber - minTargetNumber + 1);
    }
    // Hard level
    int type = random.nextInt(3);
    if (type == 0) {
      return (1 + random.nextInt(9)) * 100;
    } else if (type == 1) {
      return (10 + random.nextInt(99)) * 10;
    } else {
      return minTargetNumber +
          random.nextInt(maxTargetNumber - minTargetNumber + 1);
    }
  }

  // Generate numbers that compose the target
  void generateAvailableNumbers() {
    Set<int> numbers = {};

    // Generate a valid pair that adds up to the target
    int firstNumber;
    int secondNumber;

    // Easy
    if (widget.difficulty == GameDifficulty.easy) {
      firstNumber = 1 + random.nextInt(targetNumber - 1);
    }
    // Medium
    else if (widget.difficulty == GameDifficulty.medium) {
      if (targetNumber >= 20 && random.nextBool()) {
        firstNumber = (1 + random.nextInt(targetNumber ~/ 10)) * 10;
        firstNumber = firstNumber >= targetNumber ? 10 : firstNumber;
      } else {
        firstNumber = 1 + random.nextInt(targetNumber - 1);
      }
    } else {
      // Hard
      if (targetNumber >= 200 && random.nextBool()) {
        if (random.nextBool() && targetNumber >= 200) {
          firstNumber = (1 + random.nextInt(targetNumber ~/ 100)) * 100;
          firstNumber = firstNumber >= targetNumber ? 100 : firstNumber;
        } else {
          firstNumber = (1 + random.nextInt(targetNumber ~/ 10)) * 10;
          firstNumber =
              firstNumber >= targetNumber
                  ? random.nextInt(9) * 10 + 10
                  : firstNumber;
        }
      } else {
        int minFirstNumber = max(1, targetNumber ~/ 20);
        int maxFirstNumber = targetNumber - minFirstNumber;
        firstNumber =
            minFirstNumber + random.nextInt(maxFirstNumber - minFirstNumber);
      }
    }

    secondNumber = targetNumber - firstNumber;
    numbers.add(firstNumber);
    numbers.add(secondNumber);

    while (numbers.length < numberOfOptions) {
      int randomNum;
      if (widget.difficulty == GameDifficulty.easy) {
        randomNum = 1 + random.nextInt(maxTargetNumber + 5);
      } else if (widget.difficulty == GameDifficulty.medium) {
        randomNum =
            random.nextBool()
                ? 1 +
                    random.nextInt(9) // single digit
                : 10 + random.nextInt(maxTargetNumber); // double digit
      } else {
        randomNum =
            random.nextBool()
                ? 10 +
                    random.nextInt(90) // double digit
                : 100 + random.nextInt(maxTargetNumber - 100); // triple digit
      }

      bool createsPair = false;
      for (int num in numbers) {
        if (num + randomNum == targetNumber) {
          createsPair = true;
          break;
        }
      }

      if (!createsPair && !numbers.contains(randomNum)) {
        numbers.add(randomNum);
      }
    }

    // Convert to list and shuffle
    availableNumbers = numbers.toList()..shuffle();
  }

  // Handle when a number is selected
  void selectNumber(int number) {
    if (isAnswerCorrect != null || selectedNumbers.length >= 2) return;

    setState(() {
      selectedNumbers.add(number);
      availableNumbers.remove(number);
      currentSum += number;

      // Check if we've selected exactly 2 numbers
      if (selectedNumbers.length == 2) {
        isAnswerCorrect = currentSum == targetNumber;
        if (isAnswerCorrect!) correctAnswers++;

        // Move to next question after delay
        _showFeedbackAndContinue();
      }
    });
  }

  // Handle when a selected number is removed
  void removeSelectedNumber(int index) {
    if (isAnswerCorrect != null) return;

    setState(() {
      int number = selectedNumbers[index];
      selectedNumbers.removeAt(index);
      availableNumbers.add(number);
      currentSum -= number;
    });
  }

  // Show feedback and move to next question after delay
  void _showFeedbackAndContinue() {
    Duration feedbackDuration =
        widget.difficulty == GameDifficulty.hard
            ? const Duration(seconds: 3)
            : const Duration(seconds: 2);

    Future.delayed(feedbackDuration, () {
      if (mounted) {
        setState(() {
          if (currentQuestion < totalQuestions - 1) {
            currentQuestion++;
            generateNewQuestion();
          } else {
            showResult = true;
          }
        });
      }
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
        title: Text('Composing Numbers - ${_getDifficultyName()}'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              ComposeTutorial.showTutorialDialog(
                context,
                () => setState(() => showTutorial = false),
              );
            },
            tooltip: 'Tutorial',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SafeArea(
          child: Stack(
            children: [showResult ? _buildResultScreen() : _buildGameScreen()],
          ),
        ),
      ),
    );
  }

  Widget _buildGameScreen() {
    final screenHeight = MediaQuery.of(context).size.height;
    final appBarHeight = AppBar().preferredSize.height;
    final topPadding = MediaQuery.of(context).padding.top;
    final availableHeight = screenHeight - appBarHeight - topPadding;

    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: availableHeight),
        child: IntrinsicHeight(
          child: Padding(
            padding: EdgeInsets.all(
              ScreenUtils.getProportionateScreenWidth(12),
            ),
            child: Column(
              children: [
                // Progress indicator
                GameWidgets.buildProgressBar(
                  currentQuestion: currentQuestion,
                  totalQuestions: totalQuestions,
                  correctAnswers: correctAnswers,
                ),

                SizedBox(height: ScreenUtils.getProportionateScreenHeight(8)),

                // Decoration image
                GameWidgets.buildDecorationImage(currentImage, height: 120),

                SizedBox(height: ScreenUtils.getProportionateScreenHeight(8)),

                // Target number display
                _buildTargetNumberDisplay(),

                SizedBox(height: ScreenUtils.getProportionateScreenHeight(8)),

                // Selected numbers display
                _buildSelectedNumbersArea(),

                SizedBox(height: ScreenUtils.getProportionateScreenHeight(8)),

                // Available numbers to choose from
                _buildAvailableNumbersGrid(),

                const Expanded(flex: 1, child: SizedBox()),

                // Feedback area
                if (isAnswerCorrect != null)
                  GameWidgets.buildFeedbackArea(isAnswerCorrect!),

                SizedBox(height: ScreenUtils.getProportionateScreenHeight(12)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTargetNumberDisplay() {
    // Adjust font size based on difficulty
    double fontSize =
        widget.difficulty == GameDifficulty.hard
            ? ScreenUtils.adaptiveSize(2.8)
            : ScreenUtils.adaptiveSize(3.2);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: ScreenUtils.getProportionateScreenHeight(10),
        horizontal: ScreenUtils.getProportionateScreenWidth(12),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.standardShadow,
        border: Border.all(color: AppTheme.primaryColor, width: 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Find TWO numbers that make:',
            style: TextStyle(
              fontSize: ScreenUtils.adaptiveSize(1.6),
              color: AppTheme.secondaryTextColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: ScreenUtils.getProportionateScreenHeight(4)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: ScreenUtils.getProportionateScreenHeight(8),
                  horizontal: ScreenUtils.getProportionateScreenWidth(20),
                ),
                decoration: BoxDecoration(
                  gradient: AppTheme.buttonGradient(AppTheme.primaryColor),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: AppTheme.standardShadow,
                ),
                child: Text(
                  targetNumber.toString(),
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedNumbersArea() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ScreenUtils.getProportionateScreenWidth(12)),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.accentColor, width: 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with current sum
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Your combination: ',
                style: TextStyle(
                  fontSize: ScreenUtils.adaptiveSize(1.6),
                  fontWeight: FontWeight.w500,
                  color: AppTheme.primaryTextColor,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  color: _getSumColor(),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$currentSum',
                  style: TextStyle(
                    fontSize: ScreenUtils.adaptiveSize(1.6),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: ScreenUtils.getProportionateScreenHeight(12)),

          // Selected numbers
          if (selectedNumbers.isEmpty)
            Text(
              'Select TWO numbers below that add up to $targetNumber',
              style: TextStyle(
                fontSize: ScreenUtils.adaptiveSize(1.5),
                fontStyle: FontStyle.italic,
                color: Colors.grey.shade600,
              ),
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (selectedNumbers.isNotEmpty)
                  GestureDetector(
                    onTap: () => removeSelectedNumber(0),
                    child: _buildNumberTile(
                      selectedNumbers[0],
                      isSelected: true,
                    ),
                  ),

                if (selectedNumbers.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      '+',
                      style: TextStyle(
                        fontSize: ScreenUtils.adaptiveSize(2.5),
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryTextColor,
                      ),
                    ),
                  ),

                if (selectedNumbers.length >= 2)
                  GestureDetector(
                    onTap: () => removeSelectedNumber(1),
                    child: _buildNumberTile(
                      selectedNumbers[1],
                      isSelected: true,
                    ),
                  ),

                if (selectedNumbers.length == 2)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      '=',
                      style: TextStyle(
                        fontSize: ScreenUtils.adaptiveSize(2.5),
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryTextColor,
                      ),
                    ),
                  ),

                if (selectedNumbers.length == 2)
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: ScreenUtils.getProportionateScreenHeight(8),
                      horizontal: ScreenUtils.getProportionateScreenWidth(16),
                    ),
                    decoration: BoxDecoration(
                      color: _getSumColor(),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: AppTheme.standardShadow,
                    ),
                    child: Text(
                      '$currentSum',
                      style: TextStyle(
                        fontSize: ScreenUtils.adaptiveSize(2.2),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),

          // Show explanation if answer is incorrect
          if (isAnswerCorrect == false)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                'Try again! The correct answer is not $currentSum',
                style: TextStyle(
                  fontSize: ScreenUtils.adaptiveSize(1.5),
                  fontStyle: FontStyle.italic,
                  color: Colors.red[700],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAvailableNumbersGrid() {
    double tileSize = widget.difficulty == GameDifficulty.hard ? 65 : 55;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ScreenUtils.getProportionateScreenWidth(12)),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.primaryColor.withValues(alpha: 0.7),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Text(
            'Available Numbers',
            style: TextStyle(
              fontSize: ScreenUtils.adaptiveSize(1.6),
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryTextColor,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children:
                availableNumbers
                    .map(
                      (number) => GestureDetector(
                        onTap:
                            isAnswerCorrect == null &&
                                    selectedNumbers.length < 2
                                ? () => selectNumber(number)
                                : null,
                        child: _buildNumberTile(
                          number,
                          width: tileSize,
                          height: tileSize,
                        ),
                      ),
                    )
                    .toList(),
          ),

          // Reset selection button
          if (selectedNumbers.isNotEmpty &&
              selectedNumbers.length < 2 &&
              isAnswerCorrect == null)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: TextButton.icon(
                onPressed: () {
                  setState(() {
                    availableNumbers.addAll(selectedNumbers);
                    selectedNumbers = [];
                    currentSum = 0;
                  });
                },
                icon: Icon(Icons.refresh, color: AppTheme.primaryColor),
                label: Text(
                  'Reset Selection',
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: AppTheme.primaryColor),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNumberTile(
    int number, {
    bool isSelected = false,
    double? width,
    double? height,
  }) {
    double fontSize =
        number > 99
            ? ScreenUtils.adaptiveSize(1.8)
            : ScreenUtils.adaptiveSize(2.0);

    return Container(
      width: width ?? ScreenUtils.getProportionateScreenWidth(55),
      height: height ?? ScreenUtils.getProportionateScreenHeight(55),
      decoration: BoxDecoration(
        gradient: AppTheme.buttonGradient(
          isSelected ? AppTheme.accentColor : AppTheme.primaryColor,
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: AppTheme.standardShadow,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Stack(
        children: [
          Center(
            child: Text(
              number.toString(),
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          if (isSelected && isAnswerCorrect == null)
            Positioned(
              top: 2,
              right: 2,
              child: Icon(
                Icons.close,
                color: Colors.white.withValues(alpha: 0.7),
                size: 14,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildResultScreen() {
    String message;
    int threshold = (totalQuestions * 0.7).round();

    if (correctAnswers == totalQuestions) {
      message = 'Perfect! You found all the number combinations!';
    } else if (correctAnswers >= threshold) {
      message =
          'Good job! You understand how numbers can be made up of smaller numbers!';
    } else {
      message = 'Keep practicing to see how different numbers can be combined!';
    }

    return GameWidgets.buildResultScreen(
      context: context,
      correctAnswers: correctAnswers,
      totalQuestions: totalQuestions,
      gameTitle: 'Composing Numbers',
      customMessage: message,
    );
  }

  Color _getSumColor() {
    if (currentSum == targetNumber) {
      return Colors.green;
    } else if (currentSum > targetNumber) {
      return Colors.red;
    } else if (currentSum > 0) {
      return AppTheme.accentColor;
    } else {
      return Colors.grey;
    }
  }
}
