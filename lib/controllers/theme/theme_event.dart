part of 'theme_bloc.dart';

@immutable
abstract class ThemeEvent {}

class ChangeTheme extends ThemeEvent {
  final bool value;
  ChangeTheme({this.value = false});
}
