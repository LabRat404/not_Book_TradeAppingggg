import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:trade_app/screens/bookInfodetail_forsearch.dart';
import 'package:provider/provider.dart';
import 'package:trade_app/provider/user_provider.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:trade_app/screens/chatter.dart';

class SearchPage extends StatefulWidget {
  static const String routeName = '/Search';
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

List _items_full = [];

class _SearchPageState extends State<SearchPage> {
  @override
  //String realusername = 'doria';

  void initState() {
    //print("Hi  Im loading");
    super.initState();
    //var realusername = context.watch<UserProvider>().user.name;
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   realusername = Provider.of<String>(context, listen: false);
    // });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final help = Provider.of<UserProvider>(context, listen: false);
      String realusername = help.user.name;
      readJson(realusername);
    });
  }

  List _items = [];
  Future<void> readJson(realusername) async {
    //load  the json here!!
    //fetch here
    http.Response resaa = await http.get(
        Uri.parse('http://172.20.10.3:3000/api/graballuserbook'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });
    //print(resaa);
    final data = await json.decode(resaa.body);
    setState(() {
      _items = data;
      _items_full = _items;
    });
  }

  @override
  Widget build(BuildContext context) {
    var self = context.watch<UserProvider>().user.name;
    return Scaffold(
      appBar: AppBar(
        title: Text('Search for a book!',
            style: GoogleFonts.montserrat(
                textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 0.9,
                    fontSize: 25))),
        flexibleSpace: Image(
          image: AssetImage('assets/book_title.jpg'),
          fit: BoxFit.cover,
        ),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: CustomSearchDelegate(),
              );
            },
            icon: const Icon(Icons.search, size: 35),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            _items.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        return Card(
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(_items[index]["booktitle"]),
                                subtitle: Text(
                                  "Posted by user: " +
                                      _items[index]["username"] +
                                      '\n' +
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
                                  if (_items[index]["username"] != self)
                                    ElevatedButton.icon(
                                      icon: Icon(Icons.recycling),
                                      label: Text("Chat with user " +
                                          _items[index]["username"]),
                                      onPressed: () async {
                                        print("Trade!Book hash is " +
                                            _items[index]["name"]);
                                        // ScaffoldMessenger.of(context)
                                        //     .showSnackBar(
                                        //   const SnackBar(
                                        //       content:
                                        //           Text('Trade Request Sent!')),
                                        // );
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Chatter(
                                                title: _items[index]
                                                    ["username"]),
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
                                    label:
                                        Text("Show more on Google Play Book"),
                                    onPressed: () async {
                                      if (await canLaunchUrl(Uri.parse(
                                          _items[index]["googlelink"]))) {
                                        launchUrl(Uri.parse(
                                            _items[index]["googlelink"]));
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
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      new Text(
                        'Bring doria back so its not empty here!',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
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

class CustomSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> seacrhTerms = [
      'Atomic Habits',
      'Cracking the Coding Interview, Fourth Edition Book 2',
      'The Last Wish',
    ];
    List<String> matchQuery = [];
    for (var fruit in seacrhTerms) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> seacrhTerms = [];
    List<String> matchQueryLinkTerms = [];
    List<String> matchQueryNameTerms = [];
    List<String> matchQueryHashNameTerms = [];
    //_items_full.isNotEmpty ? {print("hi")} : {print("bye")};
    _items_full.forEach((element) {
      seacrhTerms.add(element["booktitle"]);
      matchQueryLinkTerms.add(element["url"]);
      matchQueryNameTerms.add(element["username"]);
      matchQueryHashNameTerms.add(element["name"]);
    });
    List<String> matchQuery = [];
    List<String> matchQueryLink = [];
    List<String> matchQueryName = [];
    List<String> matchQueryHashName = [];
    int i = 0;
    for (var item in seacrhTerms) {
      if (item.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(item);
        matchQueryLink.add(matchQueryLinkTerms[i]);
        matchQueryName.add(matchQueryNameTerms[i]);
        matchQueryHashName.add(matchQueryHashNameTerms[i]);
      }
      i++;
    }

    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        var link = matchQueryLink[index];
        var usernames = matchQueryName[index];
        var hashname = matchQueryHashName[index];
        return ListTile(
          leading: Image.network(link),
          title: Text(result),
          subtitle: Text(
            "Posted by user: " + usernames,
            style: TextStyle(color: Colors.black.withOpacity(0.6)),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InfoDetailPageSearch(hashname: hashname),
              ),
            );
          },
        );
      },
    );
  }
}
