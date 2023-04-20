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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final help = Provider.of<UserProvider>(context, listen: false);
      String realusername = help.user.name;
      readJson(realusername);
    });
  }

  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> _buttons = [];

  String myselff = '';
  late List _items = [];
  // Fetch content from the json file
  Future<void> readJson(realusername) async {
    //load  the json here!!
    //fetch here

    http.Response resaa = await http.get(
        Uri.parse('http://$ipaddr/api/grabrec/$realusername'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });
    //print(resaa);

    final data = await json.decode(resaa.body);
    setState(() {
      _items = data;
      myselff = realusername;
    });
  }

  //I dont like this, its hard coding and I tried not to, but maybe will fix it later
  Future<void> loadBookData(searchString) async {
    List<dynamic> BookOfMonth = [];

    http.Response ress = await http.get(
        Uri.parse('http://$ipaddr/api/grabGPT/$searchString'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });
    final Booklist = await json.decode(ress.body);

    BookOfMonth = Booklist;
    for (var i = 0; i < BookOfMonth.length; i++) {
      var res = await http.post(
          //localhost
          //Uri.parse('http://172.20.10.3:3000/api/bookinfo'),
          Uri.parse('http://$ipaddr/api/bookinfo'),
          body: jsonEncode({"book_isbn": BookOfMonth[i]}),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });
      //print("res" + res.body);

      final data1 = await json.decode(res.body);

      String btitle = "Not found";
      String bauthors = "Not found";
      String binfoLink = "Not found";
      String blink = "Not found";
      if (data1["title"] != null) btitle = data1["title"].toString();
      if (data1["authors"] != null) bauthors = data1["authors"][0].toString();
      if (data1["infoLink"] != null) binfoLink = data1["infoLink"].toString();
      if (data1["imageLinks"] != null) {
        blink = data1["imageLinks"]["smallThumbnail"].toString();
        setState(() {
          _items[i]["googlelink"] = binfoLink;
          _items[i]["url"] = blink;
          _items[i]["booktitle"] = btitle;
          _items[i]["author"] = bauthors;
        });
      } else {
        setState(() {
          _items[i]["googlelink"] = "https://imgur.com/E72yFZP";
          _items[i]["url"] =
              "https://i.kym-cdn.com/entries/icons/original/000/027/528/519.png";
          _items[i]["booktitle"] = "Sorry I Lied";
          _items[i]["author"] = "GPT-3";
        });
      }
    }
  }

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
                                  : () async {
                                      loadBookData(entry.value['text']);
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
                                          Timer(Duration(seconds: 5), () {
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
                SizedBox(height: 5.0),
                Text(
                  "Click on the books to learn more! ",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Truth is hard and GPT lies! (sometimes)",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5.0),
                ImageSlideshow(
                  indicatorColor: Colors.white,
                  onPageChanged: (value) {
                    //debugPrint('Page changed: $value');
                  },
                  autoPlayInterval: 3000,
                  isLoop: true,
                  children: [
                    if (_items.isNotEmpty)
                      for (int i = 0; i < _items.length; i++)
                        Column(
                          children: [
                            TextButton.icon(
                              style: ButtonStyle(backgroundColor: null),
                              onPressed: () async {
                                if (await canLaunchUrl(
                                    Uri.parse(_items[i]["googlelink"]))) {
                                  launchUrl(Uri.parse(_items[i]["googlelink"]));
                                }
                              },
                              icon: Image.network(_items[i]["url"],
                                  width: 180, height: 200, fit: BoxFit.fill),
                              label: Text(
                                _items[i]["booktitle"] +
                                    '\n' +
                                    'By [ ' +
                                    _items[i]["author"] +
                                    ' ]',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        )
                    else
                      TextButton.icon(
                        style: ButtonStyle(backgroundColor: null),
                        onPressed: () async {
                          if (await canLaunchUrl(Uri.parse(
                              "http://books.google.com.hk/books?id=AEO7bwAACAAJ&dq=isbn:9781406317848&hl=&source=gbs_api"))) {
                            launchUrl(Uri.parse(
                                "http://books.google.com.hk/books?id=AEO7bwAACAAJ&dq=isbn:9781406317848&hl=&source=gbs_api"));
                          }
                        },
                        icon: Image.network(
                            "http://books.google.com/books/content?id=AEO7bwAACAAJ&printsec=frontcover&img=1&zoom=5&source=gbs_api"),
                        label: Text(
                          "Rosen's Sad Book" + '\n' + 'By ' + 'Michael Rosen',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
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
