import 'package:flutter/material.dart';
import 'package:trade_app/screens/data.dart';
import 'package:trade_app/screens/chatter.dart';
import 'package:trade_app/screens/tradeSelectList.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:trade_app/screens/bookInfodetail_forsearch.dart';
import 'package:provider/provider.dart';
import 'package:trade_app/provider/user_provider.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:trade_app/screens/chatter.dart';
import 'package:trade_app/routes/ip.dart' as globals;
import 'package:tabbed_sliverlist/tabbed_sliverlist.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:audioplayers/audioplayers.dart';
import "package:cached_network_image/cached_network_image.dart";
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:trade_app/widgets/reusable_widget.dart';
import 'package:provider/provider.dart';
import 'package:trade_app/provider/user_provider.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:trade_app/widgets/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:trade_app/screens/information_page.dart';
import 'package:trade_app/screens/login_page.dart';
import 'package:trade_app/screens/avatarchange.dart';
import 'package:trade_app/widgets/reusable_widget.dart';
import 'package:trade_app/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:trade_app/services/auth/connector.dart';
import 'package:trade_app/provider/user_provider.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trade_app/widgets/nav_bar.dart';
import '../../constants/error_handling.dart';
import 'package:trade_app/screens/login_page.dart';
import 'package:provider/provider.dart';
import 'package:trade_app/provider/user_provider.dart';

var ipaddr = globals.ip;

class TradeList extends StatefulWidget {
  final String otherusername;
  TradeList({Key? key, required this.otherusername}) : super(key: key);
  @override
  _TradeListState createState() => _TradeListState();
}

List _items_full = [];

class _TradeListState extends State<TradeList> {
  @override
  void initState() {
    //print("Hi Im loading");
    super.initState();
    //var realusername = context.watch<UserProvider>().user.name;
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   realusername = Provider.of<String>(context, listen: false);
    // });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final help = Provider.of<UserProvider>(context, listen: false);
      String realusername = help.user.name;
      readJson(realusername, widget.otherusername);
    });
  }

  List _mylist = [];
  List _myboollist = [];
  List _notmylist = [];
  List _notmyboollist = [];
  List emptyList = [];
  Future<void> readJson(realusername, otherusername) async {
    List tmp1 = [];
    List tmp2 = [];
    List names = [];
    //Import the tradebucket.json

    var showInfo = await rootBundle.loadString('assets/tradebucket.json');
    final info = await json.decode(showInfo);
    //imprt self book list
    http.Response self = await http.get(
        Uri.parse('http://$ipaddr/api/grabuserlist/$realusername'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });

    //import notself book list
    http.Response notself = await http.get(
        Uri.parse('http://$ipaddr/api/grabuserlist/$otherusername'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });
    List dataself = [];
    List datanotself = [];
    final data1 = await json.decode(self.body);
    if (realusername == data1[0]["username"]) {
      dataself = await json.decode(self.body);
      datanotself = await json.decode(notself.body);
    } else {
      dataself = await json.decode(notself.body);
      datanotself = await json.decode(self.body);
    }
    for (int i = 0; i < info['selflist'].length; i++) {
      names.add(info['selflist'][i]['name']);
    }
    for (int i = 0; i < info['notselflist'].length; i++) {
      names.add(info['notselflist'][i]['name']);
    }

    for (int i = 0; i < dataself.length; i++) {
      if (names.contains(dataself[i]['name'])) {
        tmp1.add(true);
      } else {
        tmp1.add(false);
      }
    }
    for (int i = 0; i < datanotself.length; i++) {
      if (names.contains(datanotself[i]['name'])) {
        tmp2.add(true);
      } else {
        tmp2.add(false);
      }
    }
    setState(() {
      _mylist = dataself;
      _notmylist = datanotself;
      _myboollist = tmp1;
      _notmyboollist = tmp2;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Confirm"),
      onPressed: () {
        print('confirmed');
        print(_myboollist);
        print(_notmyboollist);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Confirm new trade offer? "),
      content: Text(
          "Please confirm the new trade offer with ${widget.otherusername}"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog

    bool _value = false;
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Offer with ${widget.otherusername}'),
        leading: GestureDetector(
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onTap: () {
            Navigator.pop(context, "something");
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.checklist_rtl_outlined, size: 25),
            color: Color.fromARGB(255, 255, 255, 255),
            tooltip: 'Confirm Check List',
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return alert;
                },
              );
            },
          ),
        ],
      ),
      body: TabbedList(
          tabLength: 2,
          sliverTabBar: const SliverTabBar(
              expandedHeight: 54,
              tabBar: TabBar(
                tabs: [
                  Tab(
                    text: 'Your Offer',
                  ),
                  Tab(
                    text: 'Their Offer',
                  )
                ],
              )),
          tabLists: [
            TabListBuilder(
              uniquePageKey: 'page1',
              length: _mylist.length,
              builder: (BuildContext context, index) {
                return Card(
                    child: GestureDetector(
                        onDoubleTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => InfoDetailPageSearch(
                                  hashname: _mylist[index]['name']),
                            ),
                          );
                          //Add code for showing AlertDialog here
                        },
                        child: CheckboxListTile(
                            secondary: Image.network(_mylist[index]['url']),
                            title: Text(_mylist[index]['booktitle']),
                            subtitle: Text(
                              "Comments: " + _mylist[index]['comments'],
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.6)),
                            ),
                            value: _myboollist[index],
                            onChanged: (bool? value) {
                              setState(() {
                                _myboollist[index] = value;
                              });
                            })));
              },
              tabListPadding: const EdgeInsets.symmetric(horizontal: 10),
            ),
            TabListBuilder(
              uniquePageKey: 'page2',
              length: _notmylist.length,
              builder: (context, index) {
                return Card(
                    child: GestureDetector(
                        onDoubleTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => InfoDetailPageSearch(
                                  hashname: _notmylist[index]['name']),
                            ),
                          );
                          //Add code for showing AlertDialog here
                        },
                        child: CheckboxListTile(
                          secondary: Image.network(_notmylist[index]['url']),
                          title: Text(_notmylist[index]['booktitle']),
                          subtitle: Text(
                            "Comments: " + _notmylist[index]['comments'],
                            style:
                                TextStyle(color: Colors.black.withOpacity(0.6)),
                          ),
                          value: _notmyboollist[index],
                          onChanged: (bool? value) {
                            setState(() {
                              _notmyboollist[index] = value;
                            });
                          },
                        )));
              },
              tabListPadding: const EdgeInsets.symmetric(horizontal: 10),
            )
          ]),
    );
  }
}
