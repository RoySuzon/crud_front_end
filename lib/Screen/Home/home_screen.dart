import 'package:crud_front_end/Bloc/Home/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  @override
  void initState() {
    bloc.add(HomeInititalEvent());
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              actionsPadding: EdgeInsets.all(30),
              actions: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: 'ENTER NAME'),
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
                              author: _authorController.text,
                              body: _bodyController.text));
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
            return ListView.builder(
              // reverse: true,
              itemCount: state.data.users!.length,
              itemBuilder: (context, index) {
                final data = state.data.users!.reversed.toList()[index];
                return ListTile(
                  trailing: IconButton(
                      onPressed: () {
                        bloc.add(RemoveUserEvent(id: data.id.toString()));
                      },
                      icon: Icon(Icons.delete)),
                  title: Text(data.title.toString()),
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
