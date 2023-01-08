import 'package:flutter/material.dart';
import 'package:trade_app/widgets/reusable_widget.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableWidgets.LoginPageAppBar('My Item List'),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset('assets/notification.png'),
          ),
          // new Text(
          //   'No notification so far',
          //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          // )
        ],
      ),
    );
  }
}
