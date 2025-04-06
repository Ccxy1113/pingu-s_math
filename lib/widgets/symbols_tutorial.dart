import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class TutorialStep {
  final String title;
  final Widget content;

  TutorialStep({required this.title, required this.content});
}

class GameTutorial extends StatefulWidget {
  final List<TutorialStep> steps;
  final VoidCallback onComplete;
  final String? titleText;

  const GameTutorial({
    super.key,
    required this.steps,
    required this.onComplete,
    this.titleText,
  });

  @override
  State<GameTutorial> createState() => _GameTutorialState();
}

class _GameTutorialState extends State<GameTutorial> {
  int currentStep = 0;

  void nextStep() {
    setState(() {
      if (currentStep < widget.steps.length - 1) {
        currentStep++;
      } else {
        // Last step, complete tutorial
        widget.onComplete();
      }
    });
  }

  void previousStep() {
    setState(() {
      if (currentStep > 0) {
        currentStep--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.7),
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Card(
          margin: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                Text(
                  widget.titleText ?? 'How to Play',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),

                const SizedBox(height: 8),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    widget.steps.length,
                    (index) => Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            index == currentStep
                                ? AppTheme.primaryColor
                                : Colors.grey.withValues(alpha: 0.3),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Current step title
                Text(
                  widget.steps[currentStep].title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.secondaryTextColor,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 12),

                // Current step content
                widget.steps[currentStep].content,

                const SizedBox(height: 20),

                // Navigation buttons row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back button
                    if (currentStep > 0)
                      ElevatedButton.icon(
                        onPressed: previousStep,
                        label: const Text("Back"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          foregroundColor: Colors.black87,
                          minimumSize: const Size(100, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      )
                    else
                      // Skip button
                      TextButton(
                        onPressed: widget.onComplete,
                        style: TextButton.styleFrom(
                          minimumSize: const Size(100, 48),
                        ),
                        child: Text(
                          'Skip',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 16,
                          ),
                        ),
                      ),

                    // Next/Start button
                    ElevatedButton.icon(
                      onPressed: nextStep,
                      label: Text(
                        currentStep < widget.steps.length - 1
                            ? 'Next'
                            : 'Let\'s Go!',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                          255,
                          18,
                          127,
                          235,
                        ),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(120, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SymbolTutorials {
  static Widget buildSymbolExplanation({
    required String symbol,
    required String exampleLeft,
    required String exampleRight,
    required String explanation,
    required Color symbolColor,
  }) {
    return Column(
      children: [
        // Symbol example - simplified
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildBox(exampleLeft, AppTheme.primaryColor),

            _buildBox(
              symbol,
              symbolColor,
              margin: const EdgeInsets.symmetric(horizontal: 10),
            ),

            _buildBox(exampleRight, AppTheme.primaryColor),
          ],
        ),

        const SizedBox(height: 16),

        Text(
          explanation,
          style: const TextStyle(fontSize: 16, color: Colors.black87),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  static Widget _buildBox(String text, Color color, {EdgeInsets? margin}) {
    return Container(
      width: 50,
      height: 50,
      margin: margin,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color, width: 2),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }

  static List<TutorialStep> getComparisonSymbolTutorialSteps() {
    return [
      // Greater than
      TutorialStep(
        title: 'Greater Than Symbol (>)',
        content: buildSymbolExplanation(
          symbol: '>',
          exampleLeft: '8',
          exampleRight: '3',
          explanation:
              '8 > 3 means "8 is GREATER THAN 3"\nThe symbol points to the smaller number',
          symbolColor: Colors.blue,
        ),
      ),

      // Less than
      TutorialStep(
        title: 'Less Than Symbol (<)',
        content: buildSymbolExplanation(
          symbol: '<',
          exampleLeft: '4',
          exampleRight: '9',
          explanation:
              '4 < 9 means "4 is LESS THAN 9"\nThe symbol points to the smaller number',
          symbolColor: Colors.green,
        ),
      ),

      // How to play
      TutorialStep(
        title: 'How to Play',
        content: Column(
          children: [
            const Text(
              'Drag the correct symbol (< or >) between the two numbers.',
              style: TextStyle(fontSize: 16, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildBox('42', Colors.orange),
                Container(
                  width: 40,
                  height: 40,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey),
                  ),
                ),
                _buildBox('17', Colors.orange),
              ],
            ),
          ],
        ),
      ),
    ];
  }
}
