import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:crud_front_end/Controllers/api_controller.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<HomeInititalEvent>((event, emit) async {
      emit(HomeLoadingState());
      final res = await ApiController().getUsers();
      UsersModel userList = usersModelFromJson(res.toString());
      emit(HomeSucessState(data: userList));
    });
    on<AddUserEvent>((event, emit) async {
      emit(HomeLoadingState());
      await ApiController()
          .addUser(title: event.title, author: event.author, body: event.body)
          .then((value) async {
        if (jsonDecode(value)['status'] == true) {
          print(value);
          add(HomeInititalEvent());
        } else {
          return;
        }
      });
    });
    on<RemoveUserEvent>((event, emit) async {
      emit(HomeLoadingState());
     await Future.delayed(Duration(seconds: 5));
      await ApiController().deleteUser(event.id).then((value) async {
        if (jsonDecode(value)['status'] == true) {
          print(value);
          add(HomeInititalEvent());
        } else {
          return;
        }
      });
    });
  }
}
