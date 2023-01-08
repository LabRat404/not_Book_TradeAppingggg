import 'package:flutter/material.dart';
import 'package:trade_app/widgets/reusable_widget.dart';

class InformationPage extends StatefulWidget {
  static String tag = 'information';
  const InformationPage({super.key});
  @override
  _InformationPageState createState() => new _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  final heading = Text.rich(
    TextSpan(
      text: 'By Doria and Tang',
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      // default text style
    ),
  );
  final intro = Card(
    child: Padding(
      padding: EdgeInsets.all(16.0),
      child: Text(
          "Passing reading material such as UGFN/H books from senior to junior years is always a tradition in CUHK, but due to COVID-19, it's harder now to meet new friends. Most of them after finishing the course will just simply throw the textbooks away as they have no one to pass them on to. It will become a waste of paper and money since those books are quite thick and consumed lots of paper to print instead. To address the waste and encourage students in CUHK to meet each other, we decided to develop an application, which lets people trade stuff that they won't need for something useful while promising them social interactions, letting them have a chance to meet some new friends."),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableWidgets.LoginPageAppBar("About Us"),
      body: Column(
        children: <Widget>[
          SizedBox(height: 70.0),
          heading,
          SizedBox(height: 20.0),
          intro,
        ],
      ),
    );
  }
}
