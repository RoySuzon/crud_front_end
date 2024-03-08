// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

class HomeSucessState extends HomeState {
  final UsersModel data;
  HomeSucessState({
    required this.data,
  });
}

class HomeLoadingState extends HomeState {}
