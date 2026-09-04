import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resto/core/helpers/cache_helper.dart';
import 'package:resto/core/localization/manager/locale_state.dart';

class LocaleCubit extends Cubit<LocaleState> {
  LocaleCubit({required CacheHelper cacheHelper})
      : _cacheHelper = cacheHelper,
        super(const LocaleInitial());

  final CacheHelper _cacheHelper;

  static const String _localeKey = 'app_locale';
  Locale currentLocale = const Locale('en');

  bool get isArabic => currentLocale.languageCode == 'ar';

  void loadSavedLocale() {
    final savedCode = _cacheHelper.getDataString(key: _localeKey);
    if (savedCode != null && (savedCode == 'ar' || savedCode == 'en')) {
      currentLocale = Locale(savedCode);
    } else {
      currentLocale = const Locale('en');
    }
    emit(LocaleLoaded(currentLocale));
  }

  Future<void> setLocale(Locale locale) async {
    if (currentLocale == locale) return;
    try {
      currentLocale = locale;
      emit(LocaleLoaded(currentLocale));
      await _cacheHelper.saveData(
        key: _localeKey,
        value: locale.languageCode,
      );
    } catch (e) {
      emit(LocaleChangeFailed(currentLocale, e.toString()));
    }
  }

  Future<void> toggleLocale() async {
    final newLocale = currentLocale.languageCode == 'ar'
        ? const Locale('en')
        : const Locale('ar');
    await setLocale(newLocale);
  }
}
