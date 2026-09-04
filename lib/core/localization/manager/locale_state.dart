import 'package:flutter/material.dart';

@immutable
abstract class LocaleState {
  final Locale locale;
  const LocaleState(this.locale);
}

class LocaleInitial extends LocaleState {
  const LocaleInitial() : super(const Locale('en'));
}

class LocaleLoaded extends LocaleState {
  const LocaleLoaded(super.locale);
}

class LocaleChangeFailed extends LocaleState {
  final String error;
  const LocaleChangeFailed(super.locale, this.error);
}
