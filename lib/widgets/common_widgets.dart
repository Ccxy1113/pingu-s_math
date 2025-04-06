import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class GameWidgets {
  /// Progress bar showing current question and score
  static Widget buildProgressBar({
    required int currentQuestion,
    required int totalQuestions,
    required int correctAnswers,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Question ${currentQuestion + 1} of $totalQuestions',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryTextColor,
              ),
            ),
            Text(
              'Score: $correctAnswers',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryTextColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: (currentQuestion + 1) / totalQuestions,
            minHeight: 12,
            backgroundColor: Colors.white,
            valueColor: const AlwaysStoppedAnimation<Color>(
              AppTheme.primaryColor,
            ),
          ),
        ),
      ],
    );
  }

  /// Image widgets
  static Widget buildDecorationImage(
    String imagePath, {
    double height = 120,
    IconData fallbackIcon = Icons.image,
  }) {
    return SizedBox(
      height: height,
      child: Image.asset(
        imagePath,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Icon(
            fallbackIcon,
            size: height * 0.7,
            color: AppTheme.primaryColor,
          );
        },
      ),
    );
  }

  /// Correct/Wrong answer feedback area
  static Widget buildFeedbackArea(bool isCorrect) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color:
            isCorrect
                ? Colors.green.withValues(alpha: 0.8)
                : Colors.red.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          isCorrect
              ? const Icon(Icons.check_circle, color: Colors.white)
              : const Icon(Icons.cancel, color: Colors.white),
          const SizedBox(width: 10),
          Text(
            isCorrect ? 'Correct! Well done!' : 'Oops! Try again next time!',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  /// Instruction
  static Widget buildInstructionContainer(String message) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.iceContainerDecoration,
      child: Text(
        message,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppTheme.primaryTextColor,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  /// Number Container for Compare Numbers
  static Widget buildNumberContainer(
    dynamic content, {
    double width = 120,
    double height = 120,
    Color? color,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color ?? AppTheme.primaryColor,
            (color ?? AppTheme.primaryColor).withValues(alpha: 0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.8),
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: FittedBox(
          fit: BoxFit.contain,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              content.toString(),
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the result screen
  static Widget buildResultScreen({
    required BuildContext context,
    required int correctAnswers,
    required int totalQuestions,
    required String gameTitle,
    String? customMessage,
  }) {
    int passingScore = (totalQuestions * 0.7).ceil();
    bool isPassing = correctAnswers >= passingScore;

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              isPassing
                  ? 'assets/images/goodResult.png'
                  : 'assets/images/badResult.png',
              height: screenWidth * 0.5,
              width: screenWidth * 0.5,
              gaplessPlayback: true,
            ),

            SizedBox(height: screenHeight * 0.02),

            // Result container
            Container(
              width: screenWidth * 0.85,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: AppTheme.blueShadow,
                border: Border.all(color: AppTheme.primaryColor, width: 3),
              ),
              child: Column(
                children: [
                  Text(
                    gameTitle,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Game Complete!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryTextColor,
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.02),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Your Score: ',
                        style: TextStyle(
                          fontSize: 18,
                          color: AppTheme.secondaryTextColor,
                        ),
                      ),
                      Text(
                        '$correctAnswers / $totalQuestions',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isPassing ? Colors.green : Colors.orange,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: screenHeight * 0.015),

                  Text(
                    customMessage ??
                        (isPassing
                            ? 'Great job! You\'re a math expert!'
                            : 'Keep practicing! You\'ll get better soon!'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: AppTheme.secondaryTextColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            SizedBox(height: screenHeight * 0.04),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  context,
                  'Play Again',
                  Icons.replay,
                  AppTheme.accentColor,
                  () {
                    // Go back to difficulty screen
                    Navigator.pop(context);
                  },
                ),
                _buildActionButton(
                  context,
                  'Home',
                  Icons.home,
                  AppTheme.primaryDarkColor,
                  () {
                    // Navigate to home screen
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  static Widget _buildActionButton(
    BuildContext context,
    String text,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonWidth = screenWidth * 0.35;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: buttonWidth,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          gradient: AppTheme.buttonGradient(color),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.8),
            width: 2,
          ),
          boxShadow: AppTheme.standardShadow,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
