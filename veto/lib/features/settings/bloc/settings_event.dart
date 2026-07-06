import 'package:equatable/equatable.dart';

sealed class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

class ToggleThemeEvent extends SettingsEvent {
  const ToggleThemeEvent();
}
