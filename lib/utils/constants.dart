import 'package:flutter/material.dart';

class AppConstants {
  // Text Styles
  static const headerStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );
  
  static const subheaderStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );

  // Spacing
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;

  // Animation Durations
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);

  // Points
  static const int minTaskPoints = 10;
  static const int maxTaskPoints = 100;
  static const int defaultTaskPoints = 50;
} 