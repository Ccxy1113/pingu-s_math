import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import '../utils/screen_utils.dart';
import '../utils/game_utils.dart';

class GameDifficultyScreen extends StatelessWidget {
  final String title;
  final String description;
  final Function(GameDifficulty) onDifficultySelected;
  final String? customInstructionText;
  final String? customFooterText;

  final String easyDescription;
  final String mediumDescription;
  final String hardDescription;

  const GameDifficultyScreen({
    super.key,
    required this.title,
    required this.description,
    required this.onDifficultySelected,
    this.customInstructionText,
    this.customFooterText,
    this.easyDescription = 'Numbers from 0 to 9',
    this.mediumDescription = 'Numbers from 10 to 99',
    this.hardDescription = 'Numbers from 100 to 999',
  });

  @override
  Widget build(BuildContext context) {
    ScreenUtils.init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Difficulty'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(
              ScreenUtils.getProportionateScreenWidth(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: ScreenUtils.getProportionateScreenHeight(20),
                  ),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: ScreenUtils.adaptiveSize(3.0),
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryTextColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: AppTheme.iceContainerDecoration,
                  child: Text(
                    customInstructionText ??
                        'Choose a difficulty level to start $description!',
                    style: TextStyle(
                      fontSize: ScreenUtils.adaptiveSize(1.8),
                      color: AppTheme.primaryTextColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                SizedBox(height: ScreenUtils.getProportionateScreenHeight(30)),

                _buildDifficultyCard(
                  context,
                  title: 'Easy',
                  description: easyDescription,
                  icon: Icons.sentiment_satisfied_rounded,
                  color: Colors.green,
                  difficulty: GameDifficulty.easy,
                ),

                SizedBox(height: ScreenUtils.getProportionateScreenHeight(16)),

                _buildDifficultyCard(
                  context,
                  title: 'Medium',
                  description: mediumDescription,
                  icon: Icons.sentiment_neutral_rounded,
                  color: Colors.orange,
                  difficulty: GameDifficulty.medium,
                ),

                SizedBox(height: ScreenUtils.getProportionateScreenHeight(16)),

                _buildDifficultyCard(
                  context,
                  title: 'Hard',
                  description: hardDescription,
                  icon: Icons.sentiment_very_dissatisfied_rounded,
                  color: Colors.red,
                  difficulty: GameDifficulty.hard,
                ),

                Spacer(),

                Text(
                  customFooterText ?? 'Select the level that\'s right for you!',
                  style: TextStyle(
                    fontSize: ScreenUtils.adaptiveSize(1.6),
                    fontStyle: FontStyle.italic,
                    color: AppTheme.secondaryTextColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDifficultyCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required GameDifficulty difficulty,
  }) {
    return GestureDetector(
      onTap: () => onDifficultySelected(difficulty),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
          border: Border.all(color: color.withValues(alpha: 0.6), width: 2),
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 36),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: ScreenUtils.adaptiveSize(2.2),
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: ScreenUtils.adaptiveSize(1.6),
                      color: AppTheme.secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: color, size: 20),
          ],
        ),
      ),
    );
  }
}
