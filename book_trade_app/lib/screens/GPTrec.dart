import 'package:flutter/material.dart';
import 'package:trade_app/widgets/reusable_widget.dart';
import 'dart:async';
import 'package:trade_app/routes/ip.dart' as globals;
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:trade_app/widgets/reusable_widget.dart';
import 'package:trade_app/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'package:trade_app/screens/chatter.dart';
import 'package:trade_app/screens/tradeCreateList.dart';
import 'package:trade_app/routes/ip.dart' as globals;

var ipaddr = globals.ip;

class GPTRECPage extends StatefulWidget {
  @override
  _GPTRECPageState createState() => _GPTRECPageState();
}

class _GPTRECPageState extends State<GPTRECPage> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> _buttons = [];

  void _addButton() {
    String text = _controller.text.trim();
    if (_buttons.length < 3 &&
        text.isNotEmpty &&
        !_buttons.any((button) => button['text'] == text)) {
      setState(() {
        _buttons.add({
          'text': text,
          'cooldown': false,
        });
        _controller.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("You can add a maximum of 3 buttons."),
          duration: Duration(seconds: 2),
          action: SnackBarAction(
            label: "OK",
            onPressed: () {},
          ),
        ),
      );
    }
  }

  void _deleteButton(String text) {
    setState(() {
      _buttons.removeWhere((button) => button['text'] == text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableWidgets.LoginPageAppBar('Read with GPT'),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Add a search keyword for me!",
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _addButton,
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: _buttons
                      .asMap()
                      .entries
                      .map(
                        (entry) => Row(
                          children: [
                            ElevatedButton(
                              onPressed: entry.value['cooldown']
                                  ? null
                                  : () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              "Searching for keyword ${entry.value['text']}, one moment~"),
                                          duration: Duration(seconds: 2),
                                          action: SnackBarAction(
                                            label: "OK",
                                            onPressed: () {},
                                          ),
                                        ),
                                      );
                                      setState(() {
                                        for (var i = 0;
                                            i < _buttons.length;
                                            i++) {
                                          _buttons[i]['cooldown'] = true;
                                        }
                                      });

                                      for (var i = 0;
                                          i < _buttons.length;
                                          i++) {
                                        setState(() {
                                          _buttons[i]['cooldown'] = true;
                                          Timer(Duration(seconds: 3), () {
                                            setState(() {
                                              _buttons[i]['cooldown'] = false;
                                            });
                                          });
                                        });
                                      }
                                    },
                              child: entry.value['cooldown']
                                  ? SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(entry.value['text']),
                            ),
                            IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: entry.value['cooldown']
                                  ? null
                                  : () => _deleteButton(entry.value['text']),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ),
                SizedBox(height: 20.0),
                Text(
                  "Click on the book to learn more! ",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20.0),
                ImageSlideshow(
                  indicatorColor: Colors.white,
                  onPageChanged: (value) {},
                  autoPlayInterval: 3000,
                  isLoop: true,
                  children: [
                    TextButton.icon(
                      style: ButtonStyle(backgroundColor: null),
                      onPressed: () async {
                        if (await canLaunchUrl(Uri.parse(
                            "http://books.google.com.hk/books?id=ClWQEAAAQBAJ&dq=isbn:9781603095020&hl=&source=gbs_api"))) {
                          launchUrl(Uri.parse(
                              "http://books.google.com.hk/books?id=ClWQEAAAQBAJ&dq=isbn:9781603095020&hl=&source=gbs_api"));
                        }
                      },
                      icon: Image.network(
                          "http://books.google.com/books/content?id=ClWQEAAAQBAJ&printsec=frontcover&img=1&zoom=5&source=gbs_api"),
                      label: Text(
                        'Animal Stories' + '\n' + 'By ' + 'Peter Hoey',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextButton.icon(
                      style: ButtonStyle(backgroundColor: null),
                      onPressed: () async {
                        if (await canLaunchUrl(Uri.parse(
                            "https://play.google.com/store/books/details?id=APbMBQAAQBAJ&source=gbs_api"))) {
                          launchUrl(Uri.parse(
                              "https://play.google.com/store/books/details?id=APbMBQAAQBAJ&source=gbs_api"));
                        }
                      },
                      icon: Image.network(
                          "http://books.google.com/books/content?id=APbMBQAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api"),
                      label: Text(
                        'La-La Land' + '\n' + 'By ' + 'Jean Thompson',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextButton.icon(
                      style: ButtonStyle(backgroundColor: null),
                      onPressed: () async {
                        if (await canLaunchUrl(Uri.parse(
                            "http://books.google.com.hk/books?id=f1CuuQAACAAJ&dq=isbn:9781447220039&hl=&source=gbs_api"))) {
                          launchUrl(Uri.parse(
                              "http://books.google.com.hk/books?id=f1CuuQAACAAJ&dq=isbn:9781447220039&hl=&source=gbs_api"));
                        }
                      },
                      icon: Image.network(
                          "http://books.google.com/books/content?id=f1CuuQAACAAJ&printsec=frontcover&img=1&zoom=5&source=gbs_api"),
                      label: Text(
                        'Jaws' + '\n' + 'By ' + 'Peter Benchley',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: SizedBox(),
                ),
              ],
            ),
          ),
          //here
        ],
      ),
    );
  }
}
