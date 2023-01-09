import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:trade_app/widgets/reusable_widget.dart';
import 'package:trade_app/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:trade_app/widgets/reusable_widget.dart';
import 'package:provider/provider.dart';
import 'package:trade_app/provider/user_provider.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:trade_app/widgets/nav_bar.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  static const String routeName = '/home';
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final help = Provider.of<UserProvider>(context, listen: false);
      String realusername = help.user.name;
      readJson(realusername);
    });
    //loadBookData();
  }

  List _items = [];
  // Fetch content from the json file
  Future<void> readJson(realusername) async {
    //load  the json here!!
    //fetch here
    print(realusername);
    http.Response resaa = await http.get(
        Uri.parse('http://172.20.10.3:3000/api/grabrec/$realusername'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });
    //print(resaa);
    print("end");
    print(resaa.body);
    final data = await json.decode(resaa.body);
    setState(() {
      _items = data;
    });
  }

  //I dont like this, its hard coding and I tried not to, but maybe will fix it later
  Future<void> loadBookData() async {
    List<String> BookOfMonth = [
      "9781603095020",
      "9781503519770",
      "9781447220039",
      "9780593189641"
    ];
    List<String> Recommendation = ["9780984782857", "9781406317848"];
    List<dynamic> BookOfMonthList;
    List<dynamic> RecommendationList;

    for (var i = 0; i < BookOfMonth.length; i++) {
      var res = await http.post(
          //localhost
          //Uri.parse('http://172.20.10.3:3000/api/bookinfo'),
          Uri.parse('http://172.20.10.3:3000/api/bookinfo'),
          body: jsonEncode({"book_isbn": BookOfMonth[i]}),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });
      //print("res" + res.body);
      final data1 = json.decode(res.body);
      String btitle = "Not found";
      String bauthors = "Not found";
      String binfoLink = "Not found";
      String blink = "Not found";
      if (data1["title"] != null) btitle = data1["title"].toString();
      if (data1["authors"] != null) bauthors = data1["authors"].toString();
      if (data1["infoLink"] != null) binfoLink = data1["infoLink"].toString();
      if (data1["imageLinks"] != null)
        blink = data1["imageLinks"]["smallThumbnail"].toString();
      setState(() {});
    }
    for (var i = 0; i < Recommendation.length; i++) {
      var res2 = await http.post(
          //localhost
          //Uri.parse('http://172.20.10.3:3000/api/bookinfo'),
          Uri.parse('http://172.20.10.3:3000/api/bookinfo'),
          body: jsonEncode({"book_isbn": Recommendation[i]}),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });
      //print("res" + res2.body);
      final data2 = json.decode(res2.body);
      String btitle = "Not found";
      String bauthors = "Not found";
      String binfoLink = "Not found";
      String blink = "Not found";
      if (data2["title"] != null) btitle = data2["title"].toString();
      if (data2["authors"] != null) bauthors = data2["authors"].toString();
      if (data2["infoLink"] != null) binfoLink = data2["infoLink"].toString();
      if (data2["imageLinks"] != null)
        blink = data2["imageLinks"]["smallThumbnail"].toString();

      setState(() {});
    }
  }

  // final slide = ImageSlideshow(
  //   indicatorColor: Colors.white,
  //   onPageChanged: (value) {},
  //   autoPlayInterval: 3000,
  //   isLoop: true,
  //   children: [
  //     Image.network(
  //         "http://books.google.com/books/content?id=-VfNSAAACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api"),
  //     Image.network(
  //         "http://books.google.com/books/content?id=fltxyAEACAAJ&printsec=frontcover&img=1&zoom=5&source=gbs_api"),
  //     Image.network(
  //         "http://books.google.com/books/content?id=T929zgEACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api"),
  //   ],
  // );
  //I dont like this, its hard coding and I tried not to, but maybe will fix it later
  final loopBOM = ImageSlideshow(
    indicatorColor: Colors.white,
    onPageChanged: (value) {},
    autoPlayInterval: 3000,
    isLoop: true,
    children: [
      //for(int i=0, i<x; i++)
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
  );
  //I dont like this, its hard coding and I tried not to, but maybe will fix it later
  final loopRec = ImageSlideshow(
    indicatorColor: Colors.white,
    onPageChanged: (value) {
      //debugPrint('Page changed: $value');
    },
    autoPlayInterval: 3000,
    isLoop: true,
    children: [
      Column(
        children: [
          TextButton.icon(
            style: ButtonStyle(backgroundColor: null),
            onPressed: () async {
              if (await canLaunchUrl(Uri.parse(
                  "http://books.google.com.hk/books?id=jD8iswEACAAJ&dq=isbn:9780984782857&hl=&source=gbs_api"))) {
                launchUrl(Uri.parse(
                    "http://books.google.com.hk/books?id=jD8iswEACAAJ&dq=isbn:9780984782857&hl=&source=gbs_api"));
              }
            },
            icon: Image.network(
                "http://books.google.com/books/content?id=jD8iswEACAAJ&printsec=frontcover&img=1&zoom=5&source=gbs_api"),
            label: Text(
              'Cracking the Coding Interview' +
                  '\n' +
                  'By ' +
                  'Gayle Laakmann McDowell',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Center(
              child: ButtonBar(mainAxisSize: MainAxisSize.min, children: [
            ElevatedButton.icon(
              icon: Icon(Icons.recycling),
              label: Text("Chat with user "),
              onPressed: () async {
                // print("Trade!Book hash is " + info[7]);
                // ScaffoldMessenger.of(context).showSnackBar(
                //   const SnackBar(
                //       content: Text('Trade Request Sent!')),
                // );
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => Chatter(title: info[3]),
                //   ),
                // );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shadowColor: Colors.orange,
              ),
            ),
          ]))
        ],
      ),
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
  );
  final bm = Text.rich(
    TextSpan(
      text: 'Books of the month! ',

      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
      // default text style
    ),
    textAlign: TextAlign.left,
  );
  final heading = Text.rich(
    TextSpan(
      text: 'Trade Recommendations! ',
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
      // default text style
    ),
  );

  final category_text = Text.rich(
    TextSpan(
      text: 'Recommended Categories',
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
      // default text style
    ),
  );

  @override
  Widget build(BuildContext context) {
    //loadBookData();
    var username = context.watch<UserProvider>().user.name;
    return Scaffold(
      appBar: ReusableWidgets.LoginPageAppBar('Welcome Back! $username'),
      body: Column(
        children: <Widget>[
          SizedBox(height: 30.0),
          bm,

          loopBOM,

          heading,
          loopRec,

          //category_text,
        ],
      ),
    );
  }
}
