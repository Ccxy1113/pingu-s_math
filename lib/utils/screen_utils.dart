import 'package:flutter/material.dart';

class ScreenUtils {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double defaultSize;
  static late Orientation orientation;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;
  }

  static double getProportionateScreenHeight(double inputHeight) {
    double screenHeight = ScreenUtils.screenHeight;
    return (inputHeight / 812.0) * screenHeight;
  }

  static double getProportionateScreenWidth(double inputWidth) {
    double screenWidth = ScreenUtils.screenWidth;
    return (inputWidth / 375.0) * screenWidth;
  }

  static double adaptiveSize(double size) {
    final height = getProportionateScreenHeight(size * 10);
    final width = getProportionateScreenWidth(size * 10);

    return height < width ? height : width;
  }
}
