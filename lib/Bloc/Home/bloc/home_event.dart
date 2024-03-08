// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

class HomeInititalEvent extends HomeEvent {}

class AddUserEvent extends HomeEvent {
  final String title;
  final String? author;
  final String? body;
  AddUserEvent({
    required this.title,
    this.author,
    this.body,
  });
}

class RemoveUserEvent extends HomeEvent {
  final String id;
  RemoveUserEvent({
    required this.id,
  });
}
