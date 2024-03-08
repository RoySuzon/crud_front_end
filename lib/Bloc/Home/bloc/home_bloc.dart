import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:crud_front_end/Controllers/api_controller.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
   late  UsersModel userList;
    on<HomeInititalEvent>((event, emit) async {
      emit(HomeLoadingState());
      final res = await ApiController().getUsers();
      userList = usersModelFromJson(res.toString());
      emit(HomeSucessState(data: userList));
    });
    on<AddUserEvent>((event, emit) async {
      emit(HomeLoadingState());
      await ApiController()
          .addUser(title: event.title, author: event.author, body: event.body)
          .then((value) async {
        if (jsonDecode(value)['status'] == true) {
          add(HomeInititalEvent());
          getToast('Successfully Added');
        } else {
          getToast('Faild to Add');
          emit(HomeSucessState(data: userList));
        }
      });
    });
    on<RemoveUserEvent>((event, emit) async {
      emit(HomeLoadingState());
      //  await Future.delayed(Duration(seconds: 5));
      await ApiController().deleteUser(event.id).then((value) async {
        if (jsonDecode(value)['status'] == true) {
          getToast('Successfully Remove');
          add(HomeInititalEvent());
        } else {
          getToast('Faild to delete');
          emit(HomeSucessState(data: userList));
        }
      });
    });
    on<UpdateUserEvent>((event, emit) async {
      emit(HomeLoadingState());
      //  await Future.delayed(Duration(seconds: 5));
      await ApiController().updateUser(event.id, title: event.title,author: event.author,body: event.body).then((value) async {
        if (jsonDecode(value)['status'] == true) {
          getToast('Successfully Update');
          add(HomeInititalEvent());
        } else {
          getToast('Faild to Update');
          emit(HomeSucessState(data: userList));
        }
      });
    });
  }
}

getToast(msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}
