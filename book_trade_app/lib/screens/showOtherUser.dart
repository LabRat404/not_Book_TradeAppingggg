import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:trade_app/provider/user_provider.dart';
import 'package:trade_app/widgets/reusable_widget.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:trade_app/screens/chatter.dart';
import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';

class ISBN_info {
  final String title;
  final String publishedDate;

  ISBN_info({required this.title, required this.publishedDate});

  factory ISBN_info.fromJson(Map<String, dynamic> json) {
    final title = json['subtitle'] as String;
    final publishedDate = json['publishedDate'] as String;
    return ISBN_info(title: title, publishedDate: publishedDate);
  }
}

class ShowotherUser extends StatefulWidget {
  final String otherusername;
  const ShowotherUser({required this.otherusername, Key? key})
      : super(key: key);
  static const String routeName = '/showotheruser';
  @override
  State<ShowotherUser> createState() => _ShowotherUserState();
}

class _ShowotherUserState extends State<ShowotherUser> {
  @override
  //String realusername = 'doria';

  void initState() {
    //print("Hi  Im loading");
    super.initState();
    //var realusername = context.watch<UserProvider>().user.name;
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   realusername = Provider.of<String>(context, listen: false);
    // });
    String realusername = widget.otherusername;
    readJson(realusername);
    readJson2(realusername);
  }

  // void didChangeDependencies() {
  //   debugPrint(
  //       'Child widget: didChangeDependencies(), counter = $realusername');
  //   super.didChangeDependencies();
  // }

  List _items = [];
  // Fetch content from the json file
  Future<void> readJson(realusername) async {
    //load  the json here!!
    //fetch here
    http.Response resaa = await http.get(
        Uri.parse('http://172.20.10.3:3000/api/grabuserlist/$realusername'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });
    //print(resaa);
    final data = await json.decode(resaa.body);
    setState(() {
      _items = data;
    });
  }

  String links = "";
  // Fetch content from the json file
  Future<void> readJson2(realusername) async {
    //load  the json here!!
    //fetch here
    print("username is:" + realusername);
    http.Response resaa = await http.get(
        Uri.parse('http://172.20.10.3:3000/api/grabuserdata/$realusername'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });

    print(resaa);
    final data = await json.decode(resaa.body);
    setState(() {
      links = data["address"];
    });
  }

  // getdata(dbisbn) async {
  //   var res = await http.post(
  //       //localhost
  //       //Uri.parse('http://172.20.10.3:3000/api/bookinfo'),
  //       Uri.parse('http://172.20.10.3:3000/api/bookinfo'),
  //       body: jsonEncode({"book_isbn": 0984782869}),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json; charset=UTF-8',
  //       });
  //   var resBody = json.decode(res.toString());
  //   debugPrint(resBody['title']); // can print title
  //   print(resBody['title']);
  //   return "asdasdsad";
  // }

  @override
  Widget build(BuildContext context) {
    var self = context.watch<UserProvider>().user.name;
    var username = widget.otherusername;
    var flag = 0;

    return Scaffold(
      appBar: ReusableWidgets.LoginPageAppBar(username),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            if (_items.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    return Card(
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: [
                          if (links.isEmpty && index == 0)
                            SimpleUserCard(
                              userName: username,
                              userProfilePic: AssetImage("assets/empty.png"),
                            )
                          else if (index == 0)
                            SimpleUserCard(
                              userName: username,
                              userProfilePic: NetworkImage(links),
                            ),
                          if (index == 0)
                            ButtonBar(children: [
                              ElevatedButton.icon(
                                icon: Icon(Icons.recycling),
                                label: Text("Chat with user " + username),
                                onPressed: () async {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Trade Request Sent!')),
                                  );
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          Chatter(title: username),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  shadowColor: Colors.orange,
                                ),
                              ),
                            ]),
                          ListTile(
                            title: Text(
                                "Book title: " + _items[index]["booktitle"]),
                            subtitle: Text(
                              "Book author: " +
                                  _items[index]["author"] +
                                  '\n' +
                                  "ISBN code: " +
                                  _items[index]["dbISBN"],
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.6)),
                            ),
                          ),

                          ButtonBar(
                            alignment: MainAxisAlignment.start,
                          ),
                          //Image.network(_items[index]["smallThumbnail"]),
                          Image.network(_items[index]["url"]),

                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: Text(
                              _items[index]["comments"],
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.6)),
                            ),
                          ),
                          ButtonBar(
                            children: [
                              if (username != self)
                                ElevatedButton.icon(
                                  icon: Icon(Icons.recycling),
                                  label: Text("Trade with user " + username),
                                  onPressed: () async {
                                    print("Trade!Book hash is " +
                                        _items[index]["name"]);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Trade Request Sent!')),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    shadowColor: Colors.orange,
                                  ),
                                ),
                              ElevatedButton.icon(
                                icon: Icon(Icons.link),
                                label: Text("Show more on Google Play Book"),
                                onPressed: () async {
                                  if (await canLaunchUrl(
                                      Uri.parse(_items[index]["googlelink"]))) {
                                    launchUrl(
                                        Uri.parse(_items[index]["googlelink"]));
                                  }
                                  //print(_items[index]["googlelink"]);
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ),
              )
            else
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (links.isEmpty)
                    SimpleUserCard(
                      userName: username,
                      userProfilePic: AssetImage("assets/empty.png"),
                    )
                  else
                    SimpleUserCard(
                      userName: username,
                      userProfilePic: NetworkImage(links),
                    ),
                  new Text(
                    'Bring doria back so its not empty here!(User have no item yet!)',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Center(
                    child: Image.asset('assets/empty.png'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
