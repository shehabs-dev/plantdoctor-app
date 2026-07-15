part of 'settings_cubit.dart';

class SettingsState extends Equatable {
  final ThemeMode themeMode;
  final Locale locale;

  const SettingsState({
    this.themeMode = ThemeMode.dark,
    this.locale = const Locale('ar'),
  });

  SettingsState copyWith({ThemeMode? themeMode, Locale? locale}) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
    );
  }

  // ── HydratedBloc serialization ─────────────────────────────────────────

  Map<String, dynamic> toJson() => {
    'themeMode': themeMode.index,
    'locale': locale.languageCode,
  };

  factory SettingsState.fromJson(Map<String, dynamic> json) => SettingsState(
    themeMode: ThemeMode.values[json['themeMode'] as int? ?? 0],
    locale: Locale(json['locale'] as String? ?? 'en'),
  );

  @override
  List<Object?> get props => [themeMode, locale];
}
