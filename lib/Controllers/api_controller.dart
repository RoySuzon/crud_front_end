import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiController {
  Future<bool> getSplashData() async {
    try {
      final res = await get(Uri.parse("https://crud-99vs.onrender.com/data"));
      final sp = await SharedPreferences.getInstance();
      if (jsonDecode(res.body)['status'] == true) {
        await sp.setString('baseUrl', jsonDecode(res.body)['baseUrl']);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<String> getBaseUrl() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString('baseUrl') ?? '';
  }

//GetUserAPi==========================
  Future<String> getUsers() async {
    String baseUrl = await getBaseUrl();

    String uri = "$baseUrl/api/user";
    log(uri);
    final res = await get(Uri.parse(uri));
    try {
      return res.body;
    } on Exception catch (e) {
      return e.toString();
    }
  }

//AddUserAPi==========================
  Future<String> addUser({
    required String title,
    String? author,
    String? body,
  }) async {
    String baseUrl = await getBaseUrl();

    String uri = "$baseUrl/api/post/";
    log(uri);
    final res = await post(Uri.parse(uri), body: {
      "title": title,
      "author": author ?? "N/A",
      "body": body ?? "N/A"
    });
    try {
      return res.body;
    } on Exception catch (e) {
      return e.toString();
    }
  }

//updateUserAPi==========================
  Future<String> updateUser(String id,{required String title,String ?author,String ?body }) async {
    String baseUrl = await getBaseUrl();

    String uri = "$baseUrl/api/update/${id}";
    log(uri);
    final res = await post(Uri.parse(uri), body: {"title": title,"author":author,"bodt":body});
    try {
      print(res.body);
      return res.body;
    } on Exception catch (e) {
      return e.toString();
    }
  }

//deleteateUserAPi==========================
  Future<String> deleteUser(String id) async {
    String baseUrl = await getBaseUrl();
    String uri = "$baseUrl/api/delete/$id";
    log(uri);
    final res = await get(Uri.parse(uri));
    try {
      print(res.body);
      return res.body;
    } on Exception catch (e) {
      return e.toString();
    }
  }
}

UsersModel usersModelFromJson(String str) =>
    UsersModel.fromJson(json.decode(str));

String usersModelToJson(UsersModel data) => json.encode(data.toJson());

class UsersModel {
  final bool? status;
  final List<User>? users;

  UsersModel({
    this.status,
    this.users,
  });

  factory UsersModel.fromJson(Map<String, dynamic> json) => UsersModel(
        status: json["status"],
        users: json["users"] == null
            ? []
            : List<User>.from(json["users"]!.map((x) => User.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "users": users == null
            ? []
            : List<dynamic>.from(users!.map((x) => x.toJson())),
      };
}

class User {
  final String? id;
  final String? title;
  final String? author;
  final String? body;
  final DateTime? date;
  final int? v;

  User({
    this.id,
    this.title,
    this.author,
    this.body,
    this.date,
    this.v,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"],
        title: json["title"],
        author: json["author"],
        body: json["body"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "author": author,
        "body": body,
        "date": date?.toIso8601String(),
        "__v": v,
      };
}
