import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'settings_state.dart';

class SettingsCubit extends HydratedCubit<SettingsState> {
  SettingsCubit() : super(const SettingsState());

  void toggleTheme() {
    final isDark = state.themeMode == ThemeMode.dark;
    emit(state.copyWith(themeMode: isDark ? ThemeMode.light : ThemeMode.dark));
  }

  void toggleLocale() {
    final isEn = state.locale.languageCode == 'en';
    emit(state.copyWith(locale: Locale(isEn ? 'ar' : 'en')));
  }

  // ── HydratedBloc ───────────────────────────────────────────────────────

  @override
  SettingsState? fromJson(Map<String, dynamic> json) =>
      SettingsState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(SettingsState state) => state.toJson();
}
