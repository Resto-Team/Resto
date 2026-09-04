import 'package:flutter/material.dart';

abstract class ThemeState {}

class ThemeInitial extends ThemeState {}

class ThemeChangeLoading extends ThemeState {}

class ThemeLoaded extends ThemeState {
  final ThemeMode themeMode;

  ThemeLoaded(this.themeMode);
}

class ThemeChangeFailed extends ThemeState {
  final String errorMessage;

  ThemeChangeFailed(this.errorMessage);
}