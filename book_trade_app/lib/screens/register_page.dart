import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:trade_app/widgets/reusable_widget.dart';
import 'package:trade_app/services/auth/connector.dart';

class RegisterPage extends StatefulWidget {
  static String tag = 'register-page';
  const RegisterPage({super.key});
  @override
  _RegisterPageState createState() => new _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();
  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final slide = ImageSlideshow(
      indicatorColor: Colors.blue,
      onPageChanged: (value) {
        debugPrint('Page changed: $value');
      },
      autoPlayInterval: 3000,
      isLoop: true,
      children: [
        Image.network(
            "http://books.google.com/books/content?id=-VfNSAAACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api"),
        Image.network(
            "http://books.google.com/books/content?id=fltxyAEACAAJ&printsec=frontcover&img=1&zoom=5&source=gbs_api"),
        Image.network(
            "http://books.google.com/books/content?id=T929zgEACAAJ&printsec=frontcover&img=1&zoom=5&source=gbs_api"),
      ],
    );
    // final logo = Hero(
    //   tag: 'hero',
    //   child: CircleAvatar(
    //     backgroundColor: Colors.transparent,
    //     radius: 48.0,
    //     child: Image.network(
    //         'http://books.google.com/books/content?id=-VfNSAAACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api'),
    //   ),
    // );
    final name = TextFormField(
      controller: nameController,
      enableSuggestions: false,
      autocorrect: false,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your username';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: 'Username',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

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
        hintText: 'Registration Email',
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
          return 'Password';
        }
        if (value != _confirmPass.text) return 'Not Match';
        return null;
      },
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final password2 = TextFormField(
      controller: _confirmPass,
      obscureText: true,
      enableSuggestions: false,
      autocorrect: false,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Verify Password';
        }
        if (value != passwordController.text) return 'Not Match';
        return null;
      },
      decoration: InputDecoration(
        hintText: 'Verify Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final bg = SizedBox(
        width: 300,
        height: 200,
        child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Image.asset(
                "assets/books.png") //add your image url if its from network if not change it to image.asset
            ));

    final heading = Text.rich(
      TextSpan(
        text: 'Register Account',
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
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          AuthService().signUpUser(
            context: context,
            email: emailController.text,
            password: passwordController.text,
            name: nameController.text,
          );

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Registered successfully, please login')),
          );
        }
      },
      child: const Text('Register'),
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
      appBar: ReusableWidgets.LoginPageAppBar('Welcome to Trade Book'),
      body: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            SizedBox(height: 60.0),
            heading,
            SizedBox(height: 25.0),
            bg,
            //logo,
            //slide,
            SizedBox(height: 48.0),
            name,
            SizedBox(height: 8.0),
            email,
            SizedBox(height: 8.0),
            password,
            SizedBox(height: 8.0),
            password2,
            SizedBox(height: 24.0),
            loginButton,
          ],
        ),
      ),
    );
  }
}
