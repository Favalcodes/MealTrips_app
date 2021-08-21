import 'package:flutter/material.dart';

class SizeConfig {
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double defaultSize;
  static Orientation orientation;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;
  }
}

// Get the proportionate height as per screen size
double getProportionateScreenHeight(double inputHeight) {
  double heightDivisor;
  double screenHeight = SizeConfig.screenHeight;
  if(screenHeight <= 812) {
    heightDivisor = 812;
  } else if (screenHeight > 812) {
    heightDivisor = 840;
  }
  // 812 is the layout height that designer use
  return (inputHeight / heightDivisor ) * screenHeight;
}

double getProportionateScreenWidth (double inputWidth) {
  double widthDivisor;
  double screenWidth = SizeConfig.screenWidth;
  if(screenWidth <= 350){
    widthDivisor = 360;
  } else if (screenWidth >= 351) {
    widthDivisor = 380;
  } else {
    widthDivisor = 420;
  }
  return (inputWidth / widthDivisor) * screenWidth;
}