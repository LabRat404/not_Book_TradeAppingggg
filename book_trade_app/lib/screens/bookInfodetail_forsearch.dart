import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:trade_app/provider/user_provider.dart';
import 'package:trade_app/widgets/reusable_widget.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:trade_app/screens/showOtherUser.dart';
import 'package:trade_app/screens/chatter.dart';
import 'package:provider/provider.dart';

class InfoDetailPageSearch extends StatefulWidget {
  final String hashname;
  InfoDetailPageSearch({required this.hashname, Key? key}) : super(key: key);
  static const String routeName = '/bookinfodetailsearch';
  @override
  State<InfoDetailPageSearch> createState() => _InfoDetailPageSearchState();
}

class _InfoDetailPageSearchState extends State<InfoDetailPageSearch> {
  void initState() {
    super.initState();
    readJson();
  }

  List<String> info = [];
  // Fetch content from the json file
  Future<void> readJson() async {
    String hashname = widget.hashname;
    http.Response resa = await http.get(
        //localhost
        //Uri.parse('http://172.20.10.3:3000/api/bookinfo'),
        Uri.parse('http://172.20.10.3:3000/api/grabdbbook/$hashname'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });

    //load  the json here!!
    //print(res);

    //print("resbody2 -->" + data[0]);
    // print("resbody3 -->" + data['title']);
    //print("resbody4 -->" + data[0]['title']);

    final data2 = await json.decode(resa.body);
    String btitle = "Not found";
    String blink = "Not found";
    String bauthors = "Not found";
    String binfoLink = "Not found";
    String bcomments = "Not found";
    String postby = "Not found";
    String bdbISBN = "Not found";
    if (data2[0]["booktitle"] != null)
      btitle = data2[0]["booktitle"].toString();
    if (data2[0]["author"] != null) bauthors = data2[0]["author"].toString();
    if (data2[0]["googlelink"] != null)
      binfoLink = data2[0]["googlelink"].toString();
    if (data2[0]["username"] != null) postby = data2[0]["username"].toString();
    if (data2[0]["comments"] != null)
      bcomments = data2[0]["comments"].toString();
    if (data2[0]["url"] != null) blink = data2[0]["url"].toString();
    bcomments = data2[0]["comments"].toString();
    if (data2[0]["dbISBN"] != null) bdbISBN = data2[0]["dbISBN"].toString();
    setState(() {
      info.addAll([
        btitle,
        bauthors,
        binfoLink,
        postby,
        bcomments,
        blink,
        bdbISBN,
        widget.hashname
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    var self = context.watch<UserProvider>().user.name;
    return Scaffold(
      appBar: ReusableWidgets.LoginPageAppBar('Book Detailed Info'),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            if (info.isNotEmpty)
              Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    (info[5] == "Not found")
                        ? Image.asset('assets/empty.png')
                        : Image.network(info[5]),
                    ListTile(
                      title: Text(info[0]),
                      subtitle: Text(
                        "By " +
                            info[1] +
                            '\n' +
                            "Posted by User: " +
                            info[3] +
                            '\n' +
                            "ISBN code: " +
                            info[6] +
                            '\n' +
                            "Comments by user: " +
                            '\n' +
                            info[4],
                        style: TextStyle(color: Colors.black.withOpacity(0.6)),
                      ),
                    ),

                    //Image.network(_items[index]["smallThumbnail"]),

                    Center(
                        child: ButtonBar(
                      mainAxisSize: MainAxisSize.min,
                      //alignment: Alignment.center,
                      children: [
                        if (info[3] != self)
                          ElevatedButton.icon(
                            icon: Icon(Icons.recycling),
                            label: Text("Chat with user " + info[3]),
                            onPressed: () async {
                              // print("Trade!Book hash is " + info[7]);
                              // ScaffoldMessenger.of(context).showSnackBar(
                              //   const SnackBar(
                              //       content: Text('Trade Request Sent!')),
                              // );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Chatter(title: info[3]),
                                ),
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
                            if (await canLaunchUrl(Uri.parse(info[2]))) {
                              launchUrl(Uri.parse(info[2]));
                            }
                          },
                        ),
                        ElevatedButton.icon(
                          icon: Icon(Icons.add),
                          label: Text("See profile " + info[3]),
                          onPressed: () async {
                            // print("Trade!Book hash is " + info[7]);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ShowotherUser(otherusername: info[3]),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shadowColor: Colors.orange,
                          ),
                        ),
                      ],
                    ))
                  ],
                ),
              )
            else
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  new Text(
                    'Bring doria back so its not empty here!' +
                        'no books for code: ${widget.hashname}',
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
