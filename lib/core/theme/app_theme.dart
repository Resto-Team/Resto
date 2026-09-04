import 'package:flutter/material.dart';
import 'package:resto/core/theme/dark_theme.dart';
import 'package:resto/core/theme/light_theme.dart';

abstract class AppTheme {
  static ThemeData get light {
    return lightTheme;
  }

  static ThemeData get dark {
    return darkTheme;
  }
}
