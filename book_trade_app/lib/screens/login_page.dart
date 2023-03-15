import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:trade_app/screens/register_page.dart';
import 'package:trade_app/widgets/reusable_widget.dart';
import 'package:trade_app/services/auth/connector.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  static const String routeName = '/login';
  const LoginPage({super.key});
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isChecked = false;
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _loadUserEmailPassword();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
        hintText: 'Email',
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
                "assets/overlay.png") //add your image url if its from network if not change it to image.asset
            ));

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
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final heading = Text.rich(
      TextSpan(
        text: 'Login',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
        // default text style
      ),
    );

    final register_button = TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RegisterPage()),
        );
      },
      child: const Text("Don't have an account? Sign up!"),
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
        //set remember me
        if (_isChecked)
          _handleRemeberme(true);
        else
          _handleRemeberme(false);
        // Validate returns true if the form is valid, or false otherwise.
        // print(emailController.text);
        // print(passwordController.text);
        if (_formKey.currentState!.validate()) {
          // If the form is valid, display a snackbar. In the real world,
          // you'd often call a server or save the information in a database.
          AuthService().signInUser(
              context: context,
              email: emailController.text,
              password: passwordController.text);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Logging in...')),
          );
        }
      },
      child: const Text('Login'),
    );

    final rememberDoria = CheckboxListTile(
        controlAffinity: ListTileControlAffinity.leading,
        title: Text("Remember Me",
            style: TextStyle(color: Color(0xff646464), fontFamily: 'Rubic')),
        activeColor: Color(0xff00C8E8),
        value: _isChecked,
        onChanged: (bool? value) {
          setState(() {
            _isChecked = value!;
          });
        });

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
            SizedBox(height: 75.0),
            //logo,
            bg,
            //slide,
            SizedBox(height: 75.0),
            email,
            SizedBox(height: 8.0),
            password,
            rememberDoria,
            loginButton,
            SizedBox(height: 5.0),
            register_button
          ],
        ),
      ),
    );
  }

  void _loadUserEmailPassword() async {
    bool load = false;
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      load = _prefs.getBool("remember_me")!;
    } catch (e) {
      debugPrint(e as String?);
    }

    if (load) {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      var _email = _prefs.getString("email") ?? "";
      var _password = _prefs.getString("password") ?? "";
      var _remeberMe = _prefs.getBool("remember_me") ?? false;
      if (_remeberMe) {
        setState(() {
          _isChecked = true;
        });
        emailController.text = _email ?? "";
        passwordController.text = _password ?? "";
      }
    }
  }

  _handleRemeberme(bool value) {
    if (value) {
      SharedPreferences.getInstance().then(
        (prefs) {
          prefs.setBool("remember_me", value);
          prefs.setString('email', emailController.text);
          prefs.setString('password', passwordController.text);
        },
      );
    } else {
      SharedPreferences.getInstance().then(
        (prefs) {
          prefs.setBool("remember_me", value);
          prefs.setString('email', '');
          prefs.setString('password', '');
        },
      );
    }
  }
}
