import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import '../utils/screen_utils.dart';
import '../utils/game_utils.dart';

class OrderTutorial {
  static void showInstructionsDialog(
    BuildContext context,
    GameDifficulty difficulty,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.info_outline, color: AppTheme.primaryColor),
              SizedBox(width: 10),
              Text(
                'How to Play',
                style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInstructionItem(
                  'Ascending Order (↑)',
                  'Numbers arranged from smallest to largest.',
                  'Example: 1, 3, 5, 7, 9',
                ),
                SizedBox(height: 12),
                _buildInstructionItem(
                  'Descending Order (↓)',
                  'Numbers arranged from largest to smallest.',
                  'Example: 9, 7, 5, 3, 1',
                ),
                SizedBox(height: 12),
                _buildDifficultyInfo(difficulty),
                SizedBox(height: 8),
                Text(
                  'Tap on available numbers to place them in order. \nTap on placed numbers to remove them.',
                  style: TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.primaryColor,
              ),
              child: Text(
                'Let\'s Go!',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }

  static Widget _buildInstructionItem(
    String title,
    String description,
    String example,
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
        SizedBox(height: 4),
        Text(
          description,
          style: TextStyle(fontSize: 14, color: AppTheme.secondaryTextColor),
        ),
        Container(
          margin: EdgeInsets.only(top: 4, bottom: 4),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppTheme.primaryColor.withValues(alpha: 0.3),
            ),
          ),
          child: Text(
            example,
            style: TextStyle(
              fontFamily: 'monospace',
              fontWeight: FontWeight.w500,
              color: AppTheme.primaryColor,
            ),
          ),
        ),
      ],
    );
  }

  // Display difficulty-specific information
  static Widget _buildDifficultyInfo(GameDifficulty difficulty) {
    String difficultyName = _getDifficultyName(difficulty);
    String range;
    String count;

    switch (difficulty) {
      case GameDifficulty.easy:
        range = "0-9";
        count = "3";
        break;
      case GameDifficulty.medium:
        range = "10-99";
        count = "4";
        break;
      case GameDifficulty.hard:
        range = "100-999";
        count = "5";
        break;
    }

    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$difficultyName Level',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: _getDifficultyColor(difficulty),
            ),
          ),
          SizedBox(height: 4),
          Text(
            '• You will arrange $count numbers per question',
            style: TextStyle(fontSize: 14),
          ),
          Text('• Numbers range from $range', style: TextStyle(fontSize: 14)),
          Text(
            '• Alternate between ascending and descending order',
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  static String _getDifficultyName(GameDifficulty difficulty) {
    switch (difficulty) {
      case GameDifficulty.easy:
        return 'Easy';
      case GameDifficulty.medium:
        return 'Medium';
      case GameDifficulty.hard:
        return 'Hard';
    }
  }

  static Color _getDifficultyColor(GameDifficulty difficulty) {
    switch (difficulty) {
      case GameDifficulty.easy:
        return Colors.green;
      case GameDifficulty.medium:
        return Colors.orange;
      case GameDifficulty.hard:
        return Colors.red;
    }
  }

  static Widget buildInstructionContainer(bool isAscending) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade400, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade100,
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
              Text(
                isAscending
                    ? 'Arrange the numbers in ASCENDING order'
                    : 'Arrange the numbers in DESCENDING order',
                style: TextStyle(
                  fontSize: ScreenUtils.adaptiveSize(1.8),
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}
