part of 'search_bloc.dart';

@immutable
abstract class SearchEvent {}

class SearchProducts extends SearchEvent {
  final String query;
  SearchProducts({required this.query});
}

class GetAllProducts extends SearchEvent {}
