import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trade_app/widgets/nav_bar.dart';
import '../../constants/error_handling.dart';
import 'package:trade_app/screens/login_page.dart';
import 'package:provider/provider.dart';
import 'package:trade_app/provider/user_provider.dart';

class AuthService {
  void signInUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      http.Response res =
          await http.post(Uri.parse('http://172.20.10.3:3000/api/signin'),
              //await http.post(Uri.parse('http://localhost:3000/api/signin'),
              body: jsonEncode({
                'email': email,
                'password': password,
              }),
              headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });
      debugPrint(res.body);
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          //store token in app memory
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('x-auth-token', jsonDecode(res.body)['token']);
          Provider.of<UserProvider>(context, listen: false).setUser(res.body);
          // ignore: use_build_context_synchronously
          Navigator.pushNamedAndRemoveUntil(
            context,
            NavBar.routeName,
            (route) => false,
          ); //return res.body['name']
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }

  void signUpUser({
    required BuildContext context,
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      http.Response res =
          //await http.post(Uri.parse('http://localhost:3000/api/signup'),
          await http.post(Uri.parse('http://172.20.10.3:3000/api/signup'),
              body: jsonEncode({
                'name': name,
                'email': email,
                'password': password,
                'address': "https://i.imgur.com/k2XHNOy.jpg",
              }),
              headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          //store token in app memory
          SharedPreferences prefs = await SharedPreferences.getInstance();
          //await prefs.setString('x-auth-token', jsonDecode(res.body)['token']);
          // ignore: use_build_context_synchronously
          Navigator.pushNamedAndRemoveUntil(
            context,
            LoginPage.routeName,
            (route) => false,
          );
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }

  void uploadIng(
      {required String name,
      required String url,
      required String comments,
      required String dbISBN,
      required String delhash,
      required String username,
      required String googlelink,
      required String author,
      required String booktitle}) async {
    try {
      http.Response res =
          //await http.post(Uri.parse('http://localhost:3000/api/signup'),
          await http.post(Uri.parse('http://172.20.10.3:3000/api/uploading'),
              body: jsonEncode({
                'name': name,
                'url': url,
                'dbISBN': dbISBN,
                'delhash': delhash,
                'comments': comments,
                'username': username,
                'booktitle': booktitle,
                'author': author,
                'googlelink': googlelink
              }),
              headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });
    } catch (e) {
      print(e.toString());
    }
  }
}
