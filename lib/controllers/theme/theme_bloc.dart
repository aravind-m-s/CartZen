import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeInitial()) {
    on<ChangeTheme>((event, emit) async {
      emit(ThemeState(darkTheme: event.value));
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('darkTheme', event.value);
    });
  }
}
