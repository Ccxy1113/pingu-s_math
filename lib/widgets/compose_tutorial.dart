import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class ComposeTutorial {
  static void showTutorialDialog(
    BuildContext context,
    VoidCallback onComplete,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              SizedBox(width: 10),
              Text(
                'Composing Numbers',
                style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSection(
                  'What is Number Composition?',
                  'Numbers can be made by adding smaller numbers together.',
                  _buildExample(2, 3, 5),
                ),
                SizedBox(height: 16),
                _buildSection(
                  'How to Play',
                  'Find TWO numbers that add up to the target number.',
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Target: 8',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      _buildExample(3, 5, 8, highlight: true),
                      SizedBox(height: 8),
                      Text(
                        'Tap on numbers to select them!',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onComplete();
              },
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.primaryColor,
              ),
              child: Text(
                'Got it!',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }

  static Widget _buildSection(
    String title,
    String description,
    Widget example,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppTheme.primaryTextColor,
          ),
        ),
        SizedBox(height: 6),
        Text(
          description,
          style: TextStyle(fontSize: 14, color: AppTheme.secondaryTextColor),
        ),
        SizedBox(height: 12),
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.primaryColor.withValues(alpha: 0.3),
            ),
          ),
          child: Center(child: example),
        ),
      ],
    );
  }

  static Widget _buildExample(
    int a,
    int b,
    int result, {
    bool highlight = false,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildNumberBubble(a, highlight: highlight),
        Text(' + ', style: TextStyle(fontSize: 20)),
        _buildNumberBubble(b, highlight: highlight),
        Text(' = ', style: TextStyle(fontSize: 20)),
        _buildNumberBubble(result, isResult: true),
      ],
    );
  }

  static Widget _buildNumberBubble(
    int number, {
    bool isResult = false,
    bool highlight = false,
  }) {
    Color bubbleColor;
    if (highlight) {
      bubbleColor = Colors.green[600]!;
    } else if (isResult) {
      bubbleColor = AppTheme.accentColor;
    } else {
      bubbleColor = AppTheme.primaryColor;
    }

    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bubbleColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        number.toString(),
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
