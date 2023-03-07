import 'package:flutter/material.dart';
import 'package:trade_app/widgets/reusable_widget.dart';
import 'package:http/http.dart' as http;
import 'package:trade_app/routes/ip.dart' as globals;
import 'package:trade_app/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

var ipaddr = globals.ip;

class ChangePage extends StatefulWidget {
  static String tag = 'change-page';

  const ChangePage({super.key});
  @override
  _ChangePageState createState() => new _ChangePageState();
}

class _ChangePageState extends State<ChangePage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

//in progress (not sure how ah bee encrypts it...)
  change() async {
    final help = Provider.of<UserProvider>(context, listen: false);
    String myuser = help.user.name;
    var res = await http.post(
        //localhost
        //Uri.parse('http://172.20.10.3:3000/api/bookinfo'),
        Uri.parse('http://$ipaddr/api/bookinfo'),
        body: jsonEncode({
          "username": myuser,
          "email": emailController.text,
          "password": passwordController.text
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });
  }

  @override
  Widget build(BuildContext context) {
    // final logo = Hero(
    //   tag: 'hero',
    //   child: CircleAvatar(
    //     backgroundColor: Colors.transparent,
    //     radius: 48.0,
    //     child: Image.network(
    //         'http://books.google.com/books/content?id=-VfNSAAACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api'),
    //   ),
    // );

    final email = TextFormField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: 'new email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final password = TextFormField(
      controller: passwordController,
      obscureText: true,
      enableSuggestions: false,
      autocorrect: false,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter the password';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: 'new password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final heading = Text.rich(
      TextSpan(
        text: 'Reset email and password',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
        // default text style
      ),
    );

    final loginButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
        shadowColor: Colors.lightBlueAccent.shade100,
        minimumSize: const Size(350, 50),
        elevation: 5.9,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      onPressed: () async {
        change();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Still developing (ノಠ益ಠ) ノ彡 ┻━┻")),
        );
      },
      child: const Text('Reset'),
    );

    // final forgotLabel = FlatButton(
    //   child: Text(
    //     'Forgot password?',
    //     style: TextStyle(color: Colors.black54),
    //   ),
    //   onPressed: () {},
    // );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: ReusableWidgets.LoginPageAppBar('Settings'),
      body: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            SizedBox(height: 60.0),
            heading,
            //logo,
            //slide,
            SizedBox(height: 48.0),
            email,
            SizedBox(height: 8.0),
            password,
            SizedBox(height: 24.0),
            loginButton,
          ],
        ),
      ),
    );
  }
}
