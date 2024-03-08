import 'dart:developer';

import 'package:crud_front_end/Bloc/Home/bloc/home_bloc.dart';
import 'package:crud_front_end/Controllers/api_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Homscreeen extends StatefulWidget {
  const Homscreeen({super.key});

  @override
  State<Homscreeen> createState() => _HomscreeenState();
}

class _HomscreeenState extends State<Homscreeen> {
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _bodyController = TextEditingController();
  final bloc = HomeBloc();

  void controllerClear() {
    _titleController.clear();
    _authorController.clear();
    _bodyController.clear();
  }

  Future<void> getBaseUrl() async {
    final sp = await SharedPreferences.getInstance();

    // await sp.clear();

    if (sp.getString('baseUrl') == null) {
      log('api hit');
      await ApiController.getSplashData();
      bloc.add(HomeInititalEvent());
    } else {
      log('api not hit');
      bloc.add(HomeInititalEvent());
    }
  }

  @override
  void initState() {
    getBaseUrl();
    // ApiController().getSplashData();

    super.initState();
  }

  String length = '0';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder(
          bloc: bloc,
          builder: (context, state) {
            if (state is HomeSucessState) {
              length = state.data.users!.length.toString();
              return Text(state.data.users!.length.toString());
            } else {
              return Text(length);
            }
          },
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              actionsPadding: const EdgeInsets.all(30),
              actions: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: 'ENTER NAME'),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _authorController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'ENTER Author Name'),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _bodyController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: 'ENTER Details'),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ActionChip(
                      label: const Text('NO'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    ActionChip(
                      label: const Text('YES'),
                      onPressed: () {
                        if (_titleController.text.trim().isNotEmpty) {
                          bloc.add(AddUserEvent(
                              title: _titleController.text,
                              author: _authorController.text.trim() == ''
                                  ? null
                                  : _authorController.text.trim(),
                              body: _bodyController.text.trim() == ''
                                  ? null
                                  : _bodyController.text.trim()));
                          controllerClear();
                        }

                        Navigator.pop(context);
                      },
                    )
                  ],
                )
              ],
            ),
          );
        },
        child: Icon(Icons.add),
      ),
      body: BlocBuilder(
        bloc: bloc,
        builder: (context, state) {
          if (state is HomeSucessState) {
            return state.data.users!.isEmpty
                ? Center(
                    child: Text('There is no Data!'),
                  )
                : ListView.builder(
                    // reverse: true,
                    itemCount: state.data.users!.length,

                    itemBuilder: (context, index) {
                      final data = state.data.users!.reversed.toList()[index];
                      return Card(
                        child: ListTile(
                          leading: IconButton(
                              onPressed: () {
                                _authorController.text = data.author.toString();
                                _titleController.text = data.title.toString();
                                _bodyController.text = data.body.toString();
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    actionsPadding: EdgeInsets.all(30),
                                    actions: [
                                      TextField(
                                        controller: _titleController,
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            hintText: 'ENTER NAME'),
                                      ),
                                      const SizedBox(height: 20),
                                      TextField(
                                        controller: _authorController,
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            hintText: 'ENTER Author Name'),
                                      ),
                                      const SizedBox(height: 20),
                                      TextField(
                                        controller: _bodyController,
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            hintText: 'ENTER Details'),
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          ActionChip(
                                            label: const Text('NO'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                          ActionChip(
                                            label: const Text('YES'),
                                            onPressed: () {
                                              if (_titleController.text
                                                  .trim()
                                                  .isNotEmpty) {
                                                bloc.add(UpdateUserEvent(
                                                    title:
                                                        _titleController.text,
                                                    author:
                                                        _authorController.text,
                                                    body: _bodyController.text,
                                                    id: data.id.toString()));
                                                controllerClear();
                                              }
                                              Navigator.pop(context);
                                            },
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              },
                              icon: Icon(Icons.edit)),
                          subtitle: Text(data.author.toString()),
                          trailing: IconButton(
                              onPressed: () {
                                bloc.add(
                                    RemoveUserEvent(id: data.id.toString()));
                              },
                              icon: const Icon(Icons.delete)),
                          title: Text(data.title.toString()),
                        ),
                      );
                    },
                  );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
