import 'package:flutter/material.dart';
import '../screens/compare_number.dart';
import '../screens/compare_symbol.dart';
import '../screens/compose_number.dart';
import '../screens/game_difficulty.dart';
import '../screens/order_number.dart';
import '../utils/app_theme.dart';
import '../utils/screen_utils.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtils.init(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: ScreenUtils.getProportionateScreenWidth(32),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(70),
                      child: Image.asset(
                        'assets/images/penguin_logo.png',
                        width: 140,
                        height: 140,
                        fit: BoxFit.cover,
                      ),
                    ),

                    SizedBox(
                      height: ScreenUtils.getProportionateScreenHeight(10),
                    ),

                    // App Title
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 12,
                      ),
                      decoration: AppTheme.iceContainerDecoration,
                      child: Text(
                        'Pingu\'s Math',
                        style: TextStyle(
                          fontSize: ScreenUtils.adaptiveSize(3.0),
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryTextColor,
                          letterSpacing: 1.0,
                          shadows: [
                            Shadow(
                              blurRadius: 3.0,
                              color: AppTheme.blueShadowColor,
                              offset: const Offset(1.0, 1.0),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(
                      height: ScreenUtils.getProportionateScreenHeight(20),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Let's learn math with ",
                          style: TextStyle(
                            fontSize: ScreenUtils.adaptiveSize(1.8),
                            fontStyle: FontStyle.italic,
                            color: AppTheme.secondaryTextColor,
                          ),
                        ),
                        Text(
                          "🐧",
                          style: TextStyle(
                            fontSize: ScreenUtils.adaptiveSize(2.2),
                          ),
                        ),
                        Text(
                          "friends!",
                          style: TextStyle(
                            fontSize: ScreenUtils.adaptiveSize(1.8),
                            fontStyle: FontStyle.italic,
                            color: AppTheme.secondaryTextColor,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: ScreenUtils.getProportionateScreenHeight(8),
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: AppTheme.snowColor,
                            thickness: 2,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Text(
                            "❄️",
                            style: TextStyle(
                              fontSize: ScreenUtils.adaptiveSize(2.0),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: AppTheme.snowColor,
                            thickness: 2,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: ScreenUtils.getProportionateScreenHeight(8),
                    ),

                    Container(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        "Choose a game!",
                        style: TextStyle(
                          fontSize: ScreenUtils.adaptiveSize(2.1),
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryTextColor,
                        ),
                      ),
                    ),

                    SizedBox(
                      height: ScreenUtils.getProportionateScreenHeight(8),
                    ),

                    // Game buttons
                    //1. Compare Numbers
                    _buildGameButton(
                      context,
                      'Compare Numbers',
                      null,
                      AppTheme.compareButtonColor,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => GameDifficultyScreen(
                                  title: 'Compare Numbers',
                                  description: 'comparing numbers',
                                  onDifficultySelected: (difficulty) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => CompareNumbersScreen(
                                              difficulty: difficulty,
                                            ),
                                      ),
                                    );
                                  },
                                  easyDescription:
                                      'Compare numbers from 0 to 9',
                                  mediumDescription:
                                      'Compare numbers from 10 to 99',
                                  hardDescription:
                                      'Compare numbers from 100 to 999',
                                ),
                          ),
                        );
                      },
                      customIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('🐧', style: TextStyle(fontSize: 16)),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 6),
                            child: Text(
                              '?',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const Text('🐧', style: TextStyle(fontSize: 24)),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: ScreenUtils.getProportionateScreenHeight(8),
                    ),

                    // 2. Compare Symbols
                    _buildGameButton(
                      context,
                      'Compare Symbols',
                      null,
                      AppTheme.symbolsButtonColor,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => GameDifficultyScreen(
                                  title: 'Compare Symbols',
                                  description: 'learning comparison symbols',
                                  onDifficultySelected: (difficulty) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => CompareSymbolScreen(
                                              difficulty: difficulty,
                                            ),
                                      ),
                                    );
                                  },
                                  easyDescription:
                                      'Compare > and < with numbers 0-9',
                                  mediumDescription:
                                      'Compare > and < with numbers 10-99',
                                  hardDescription:
                                      'Compare > and < with numbers 100-999',
                                ),
                          ),
                        );
                      },
                      customIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('🐧', style: TextStyle(fontSize: 24)),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 6),
                            child: Text(
                              '>',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const Text('🐧', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: ScreenUtils.getProportionateScreenHeight(8),
                    ),

                    // 3. Order Numbers
                    _buildGameButton(
                      context,
                      'Order Numbers',
                      null,
                      AppTheme.orderButtonColor,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => GameDifficultyScreen(
                                  title: 'Order Numbers',
                                  description: 'ordering numbers',
                                  onDifficultySelected: (difficulty) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => OrderNumbersScreen(
                                              difficulty: difficulty,
                                            ),
                                      ),
                                    );
                                  },
                                  easyDescription: 'Order 3 numbers from 0-9',
                                  mediumDescription:
                                      'Order 4 numbers from 10-99',
                                  hardDescription:
                                      'Order 5 numbers from 100-999',
                                ),
                          ),
                        );
                      },
                      customIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('🐧', style: TextStyle(fontSize: 14)),
                          const SizedBox(width: 4),
                          const Text('🐧', style: TextStyle(fontSize: 18)),
                          const SizedBox(width: 4),
                          const Text('🐧', style: TextStyle(fontSize: 22)),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: ScreenUtils.getProportionateScreenHeight(8),
                    ),

                    // 4. Composing Numbers
                    _buildGameButton(
                      context,
                      'Composing Numbers',
                      null,
                      AppTheme.composeButtonColor,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => GameDifficultyScreen(
                                  title: 'Composing Numbers',
                                  description: 'composing numbers',
                                  onDifficultySelected: (difficulty) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => ComposingNumbersScreen(
                                              difficulty: difficulty,
                                            ),
                                      ),
                                    );
                                  },
                                  easyDescription:
                                      'Find two numbers that add up to 3-9',
                                  mediumDescription:
                                      'Find two numbers that add up to 10-99',
                                  hardDescription:
                                      'Find two numbers that add up to 100-999',
                                ),
                          ),
                        );
                      },
                      customIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('🐧', style: TextStyle(fontSize: 22)),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 6),
                            child: Text(
                              '+',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const Text('🐧', style: TextStyle(fontSize: 22)),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: ScreenUtils.getProportionateScreenHeight(20),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGameButton(
    BuildContext context,
    String text,
    IconData? icon,
    Color color,
    VoidCallback onPressed, {
    Widget? customIcon,
    double verticalMargin = 6,
  }) {
    return Container(
      width: double.infinity,
      height: 60,
      margin: EdgeInsets.symmetric(vertical: verticalMargin),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.4),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              children: [
                SizedBox(
                  width: 80,
                  child:
                      customIcon ??
                      (icon != null
                          ? Icon(icon, size: 24, color: Colors.white)
                          : Container()),
                ),
                Expanded(
                  child: Text(
                    text,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  width: 24,
                  child: const Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
