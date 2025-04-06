import 'package:flutter/material.dart';
import 'dart:math';
import '../utils/app_theme.dart';
import '../utils/screen_utils.dart';
import '../widgets/common_widgets.dart';
import '../utils/image_utils.dart';
import '../utils/game_utils.dart';
import '../widgets/order_tutorial.dart';

class OrderNumbersScreen extends StatefulWidget {
  final GameDifficulty difficulty;

  const OrderNumbersScreen({super.key, required this.difficulty});

  @override
  State<OrderNumbersScreen> createState() => _OrderNumbersScreenState();
}

class _OrderNumbersScreenState extends State<OrderNumbersScreen> {
  final int totalQuestions = 5;
  late int maxNumber; // Maximum number to use
  late int minNumber; // Minimum number to use
  late int numbersPerQuestion; // Numbers to order per question

  int currentQuestion = 0;
  int correctAnswers = 0;
  bool isAscending = true;
  bool showResult = false;
  bool? isAnswerCorrect;
  String currentImage = '';
  bool _showedInstructions = false;

  // Number lists
  late List<int> targetNumbers; // Numbers in correct order
  late List<int> shuffledNumbers; // Numbers for player to arrange
  late List<int> playerArrangement; // Player's current arrangement

  @override
  void initState() {
    super.initState();
    _setDifficultyParameters();

    ImageUtils.resetCounter();
    generateNewQuestion();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_showedInstructions) {
        OrderTutorial.showInstructionsDialog(context, widget.difficulty);
        _showedInstructions = true;
      }
    });
  }

  void _setDifficultyParameters() {
    switch (widget.difficulty) {
      case GameDifficulty.easy:
        minNumber = 0;
        maxNumber = 9;
        numbersPerQuestion = 3; // Fewer numbers for easy level
        break;
      case GameDifficulty.medium:
        minNumber = 10;
        maxNumber = 99;
        numbersPerQuestion = 4; // More numbers for medium level
        break;
      case GameDifficulty.hard:
        minNumber = 100;
        maxNumber = 999;
        numbersPerQuestion = 5; // Most numbers for hard level
        break;
    }
  }

  // Generate a new ordering question
  void generateNewQuestion() {
    // Alternate between ascending and descending
    if (currentQuestion % 2 == 0) {
      isAscending = true;
    } else {
      isAscending = false;
    }

    currentImage = ImageUtils.getNextDecorationImage();

    final random = Random();
    Set<int> numberSet = {};

    while (numberSet.length < numbersPerQuestion) {
      int newNumber = minNumber + random.nextInt(maxNumber - minNumber + 1);
      numberSet.add(newNumber);
    }

    // Convert to list and sort
    targetNumbers = numberSet.toList();
    targetNumbers.sort();

    // If descending, reverse the order
    if (!isAscending) {
      targetNumbers = targetNumbers.reversed.toList();
    }

    // Create shuffled copy for the player to arrange
    shuffledNumbers = List.from(targetNumbers);
    shuffledNumbers.shuffle();
    playerArrangement = [];

    // Reset result display
    showResult = false;
    isAnswerCorrect = null;
  }

  // Check if the player's arrangement is correct
  void checkAnswer() {
    if (playerArrangement.length == targetNumbers.length) {
      bool correct = true;
      for (int i = 0; i < targetNumbers.length; i++) {
        if (playerArrangement[i] != targetNumbers[i]) {
          correct = false;
          break;
        }
      }

      setState(() {
        isAnswerCorrect = correct;
        showResult = true;

        if (correct) {
          correctAnswers++;
        }
      });
    }
  }

  void nextQuestion() {
    setState(() {
      if (currentQuestion < totalQuestions - 1) {
        currentQuestion++;
        generateNewQuestion();
      } else {
        currentQuestion = totalQuestions;
      }
    });
  }

  void addNumberToArrangement(int number) {
    if (playerArrangement.length < targetNumbers.length &&
        !playerArrangement.contains(number)) {
      setState(() {
        playerArrangement.add(number);
        shuffledNumbers.remove(number);
      });
    }
  }

  void removeNumberFromArrangement(int index) {
    if (index < playerArrangement.length) {
      setState(() {
        int number = playerArrangement[index];
        playerArrangement.removeAt(index);
        shuffledNumbers.add(number);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtils.init(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Order the Numbers - ${_getDifficultyName()}',
          style: TextStyle(
            fontSize: ScreenUtils.adaptiveSize(2.2),
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline),
            color: Colors.white,
            onPressed:
                () => OrderTutorial.showInstructionsDialog(
                  context,
                  widget.difficulty,
                ),
            tooltip: 'Instructions',
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: Column(
          children: [
            Expanded(
              child: SafeArea(
                bottom: false,
                child: SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child:
                      currentQuestion < totalQuestions
                          ? _buildGameContent()
                          : _buildResultScreen(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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

  Widget _buildGameContent() {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(
          left: ScreenUtils.getProportionateScreenWidth(16),
          right: ScreenUtils.getProportionateScreenWidth(16),
          top: ScreenUtils.getProportionateScreenHeight(16),
        ),
        child: Column(
          children: [
            // Progress bar
            GameWidgets.buildProgressBar(
              currentQuestion: currentQuestion,
              totalQuestions: totalQuestions,
              correctAnswers: correctAnswers,
            ),

            SizedBox(height: ScreenUtils.getProportionateScreenHeight(10)),

            SizedBox(
              height: ScreenUtils.getProportionateScreenHeight(120),
              child: Image.asset(currentImage, fit: BoxFit.contain),
            ),

            SizedBox(height: ScreenUtils.getProportionateScreenHeight(10)),

            // Instructions - Using the OrderTutorial class
            OrderTutorial.buildInstructionContainer(isAscending),

            SizedBox(height: ScreenUtils.getProportionateScreenHeight(16)),

            // Player's arrangement area
            _buildArrangementArea(),

            // Show Correct Answer when the player gets it wrong
            if (showResult == true && isAnswerCorrect == false)
              _buildCorrectAnswerDisplay(),

            SizedBox(height: ScreenUtils.getProportionateScreenHeight(12)),

            // Available numbers to choose from (only show when not showing result)
            if (!showResult) _buildNumberSelection(),

            SizedBox(height: ScreenUtils.getProportionateScreenHeight(12)),

            // Check answer button (only show when not showing result)
            if (!showResult) _buildCheckButton(),

            // Feedback area (shows after checking answer)
            if (showResult)
              Column(
                children: [
                  GameWidgets.buildFeedbackArea(isAnswerCorrect!),
                  SizedBox(
                    height: ScreenUtils.getProportionateScreenHeight(12),
                  ),
                  _buildNextButton(),
                ],
              ),

            // Add extra space at the bottom to ensure everything is visible
            SizedBox(height: ScreenUtils.getProportionateScreenHeight(50)),
          ],
        ),
      ),
    );
  }

  // Display the arrangement area where player places numbers in order
  Widget _buildArrangementArea() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.primaryColor.withValues(alpha: 0.7),
          width: 2,
        ),
        boxShadow: AppTheme.blueShadow,
      ),
      child: Column(
        children: [
          Text(
            'Your Arrangement',
            style: TextStyle(
              fontSize: ScreenUtils.adaptiveSize(1.8),
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryTextColor,
            ),
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              targetNumbers.length,
              (index) => _buildArrangementSlot(index),
            ),
          ),
        ],
      ),
    );
  }

  //Display the correct answer when player gets it wrong
  Widget _buildCorrectAnswerDisplay() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 16),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.shade600, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withValues(alpha: 0.3),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.info_outline,
                color: Colors.green.shade700,
                size: ScreenUtils.adaptiveSize(2.0),
              ),
              SizedBox(width: 8),
              Text(
                'Correct Order:',
                style: TextStyle(
                  fontSize: ScreenUtils.adaptiveSize(1.8),
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              targetNumbers.length,
              (index) => _buildCorrectAnswerTile(targetNumbers[index]),
            ),
          ),
          SizedBox(height: 10),
          Text(
            isAscending
                ? 'The numbers are arranged from smallest to largest.'
                : 'The numbers are arranged from largest to smallest.',
            style: TextStyle(
              fontSize: ScreenUtils.adaptiveSize(1.5),
              fontStyle: FontStyle.italic,
              color: Colors.grey[700],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Individual tile in the correct answer display
  Widget _buildCorrectAnswerTile(int number) {
    return Container(
      width: ScreenUtils.getProportionateScreenWidth(45),
      height: ScreenUtils.getProportionateScreenHeight(45),
      margin: EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade400, Colors.green.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withValues(alpha: 0.3),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          number.toString(),
          style: TextStyle(
            fontSize: ScreenUtils.adaptiveSize(2.2),
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // Individual slot in the arrangement area
  Widget _buildArrangementSlot(int index) {
    // Check if this slot has a number
    bool hasNumber = index < playerArrangement.length;

    Color slotColor = AppTheme.accentColor;
    if (showResult && hasNumber) {
      // Correct numbers in green and incorrect in red
      if (isAnswerCorrect == true) {
        slotColor = Colors.green;
      } else {
        bool numberCorrect = playerArrangement[index] == targetNumbers[index];
        slotColor = numberCorrect ? Colors.green : Colors.red;
      }
    }

    return GestureDetector(
      onTap:
          (!showResult && hasNumber)
              ? () => removeNumberFromArrangement(index)
              : null,
      child: Container(
        width: ScreenUtils.getProportionateScreenWidth(45),
        height: ScreenUtils.getProportionateScreenHeight(45),
        margin: EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          gradient:
              hasNumber
                  ? AppTheme.buttonGradient(slotColor)
                  : LinearGradient(
                    colors: [Colors.grey[300]!, Colors.grey[400]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: hasNumber ? Colors.white : Colors.grey[400]!,
            width: 2,
          ),
          boxShadow: hasNumber ? AppTheme.standardShadow : null,
        ),
        child: Center(
          child:
              hasNumber
                  ? Text(
                    playerArrangement[index].toString(),
                    style: TextStyle(
                      fontSize: ScreenUtils.adaptiveSize(2.2),
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )
                  : Icon(
                    Icons.add,
                    color: Colors.grey[600],
                    size: ScreenUtils.adaptiveSize(1.8),
                  ),
        ),
      ),
    );
  }

  // Display available numbers to choose
  Widget _buildNumberSelection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.accentColor.withValues(alpha: 0.7),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Text(
            'Available Numbers',
            style: TextStyle(
              fontSize: ScreenUtils.adaptiveSize(1.8),
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryTextColor,
            ),
          ),
          SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children:
                shuffledNumbers
                    .map((number) => _buildNumberTile(number))
                    .toList(),
          ),
        ],
      ),
    );
  }

  // Individual number tile in the selection area
  Widget _buildNumberTile(int number) {
    double tileSize =
        widget.difficulty == GameDifficulty.hard
            ? ScreenUtils.getProportionateScreenWidth(55)
            : ScreenUtils.getProportionateScreenWidth(45);

    double fontSize =
        widget.difficulty == GameDifficulty.hard
            ? ScreenUtils.adaptiveSize(2.0)
            : ScreenUtils.adaptiveSize(2.2);

    return GestureDetector(
      onTap: () => addNumberToArrangement(number),
      child: Container(
        width: tileSize,
        height: tileSize,
        decoration: BoxDecoration(
          gradient: AppTheme.buttonGradient(AppTheme.primaryColor),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: AppTheme.standardShadow,
        ),
        child: Center(
          child: Text(
            number.toString(),
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  // Button to check the answer
  Widget _buildCheckButton() {
    bool isComplete = playerArrangement.length == targetNumbers.length;

    return SizedBox(
      width: double.infinity,
      height: ScreenUtils.getProportionateScreenHeight(50),
      child: ElevatedButton(
        onPressed: isComplete && !showResult ? checkAnswer : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 3,
          disabledBackgroundColor: Colors.grey,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, size: ScreenUtils.adaptiveSize(2.2)),
            SizedBox(width: 8),
            Text(
              'Check Answer',
              style: TextStyle(
                fontSize: ScreenUtils.adaptiveSize(2.2),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Button to move to the next question
  Widget _buildNextButton() {
    return SizedBox(
      width: double.infinity,
      height: ScreenUtils.getProportionateScreenHeight(50),
      child: ElevatedButton(
        onPressed: nextQuestion,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.accentColor,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 3,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.arrow_forward, size: ScreenUtils.adaptiveSize(2.2)),
            SizedBox(width: 8),
            Text(
              'Next Question',
              style: TextStyle(
                fontSize: ScreenUtils.adaptiveSize(2.2),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultScreen() {
    String difficultyText = _getDifficultyName().toLowerCase();
    String successMessage =
        correctAnswers >= 3
            ? 'Great job! You\'re a number ordering expert at the $difficultyText level!'
            : 'Keep practicing $difficultyText level ordering! You\'ll get better!';

    return GameWidgets.buildResultScreen(
      context: context,
      correctAnswers: correctAnswers,
      totalQuestions: totalQuestions,
      gameTitle: 'Order Numbers',
      customMessage: successMessage,
    );
  }
}
