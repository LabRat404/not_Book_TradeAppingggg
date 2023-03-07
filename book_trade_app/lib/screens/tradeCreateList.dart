import 'package:flutter/material.dart';
import 'package:trade_app/screens/chatter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trade_app/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:trade_app/routes/ip.dart' as globals;
import 'package:trade_app/widgets/nav_bar.dart';
import 'package:trade_app/screens/bookInfodetail_forsearch.dart';
import 'package:tabbed_sliverlist/tabbed_sliverlist.dart';

var ipaddr = globals.ip;

class TradeCreateList extends StatefulWidget {
  final String otherusername;
  TradeCreateList({Key? key, required this.otherusername}) : super(key: key);
  @override
  _TradeCreateListState createState() => _TradeCreateListState();
}

List _items_full = [];

class _TradeCreateListState extends State<TradeCreateList> {
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
  bool reverse = false;
  String me = '';
  String her = '';
  Future<void> readJson(realusername, otherusername) async {
    List tmp1 = [];
    List tmp2 = [];
    List names = [];
    bool flag = false;

    //import self book list
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
      flag = true;
      dataself = await json.decode(notself.body);
      datanotself = await json.decode(self.body);
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
      reverse = flag;
      me = realusername;
      her = otherusername;
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
      child: const Text("Confirm"),
      onPressed: () async {
        String tmp = '';
        List _newmylist = [];
        List _newnotmylist = [];
        for (int i = 0; i < _mylist.length; i++) {
          if (_myboollist[i]) {
            _newmylist.add(_mylist[i]["name"]);
          }
        }
        for (int i = 0; i < _notmylist.length; i++) {
          if (_notmyboollist[i]) {
            _newnotmylist.add(_notmylist[i]["name"]);
          }
        }
        Random random = new Random();
        final now = new DateTime.now();
        if (reverse) {
          http.Response res =
              await http.post(Uri.parse('http://$ipaddr/api/createtradebusket'),
                  body: jsonEncode({
                    "self": her,
                    "notself": me,
                    "randomhash": random.nextInt(100000) + 10,
                    "lastdate": new DateFormat('yyyy-MM-dd')
                        .format(new DateTime.now())
                        .toString(),
                    "status": "inprogress",
                    "editing": "no",
                    "selflist": _newnotmylist,
                    "notselflist": _newmylist
                    //rmb rever the list to generate
                  }),
                  headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              });
          if (res.body == "done") {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Trade request Send!")),
            );
            sendmsg(
                me, her, 'Trade Offer Created', random.nextInt(100000) + 10);

            Navigator.pushNamedAndRemoveUntil(
              context,
              NavBar.routeName,
              (route) => false,
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Trade request not Send!")),
            );
            Navigator.pushNamedAndRemoveUntil(
              context,
              NavBar.routeName,
              (route) => false,
            );
          }
        } else {
          http.Response res =
              await http.post(Uri.parse('http://$ipaddr/api/createtradebusket'),
                  body: jsonEncode({
                    "self": me,
                    "notself": her,

                    "randomhash": random.nextInt(100000) + 10,
                    "lastdate": new DateFormat('yyyy-MM-dd')
                        .format(new DateTime.now())
                        .toString(),
                    "status": "inprogress",
                    "editing": "no",
                    "selflist": _newmylist,
                    "notselflist": _newnotmylist
                    //rmb rever the list to generate
                  }),
                  headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              });
          if (res.body == "done") {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Trade request Send!")),
            );

            sendmsg(
                me, her, 'Trade Offer Created', random.nextInt(100000) + 10);

            Navigator.pushNamedAndRemoveUntil(
              context,
              NavBar.routeName,
              (route) => false,
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Trade request not Send!")),
            );
            Navigator.pushNamedAndRemoveUntil(
              context,
              NavBar.routeName,
              (route) => false,
            );
          }
        }
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Confirm new trade offer? "),
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
        title: Text('New Offer with ${widget.otherusername}'),
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

void sendmsg(self, her, msg, random) async {
  // print(msg),
  var resul = await http.post(
      //localhost
      //Uri.parse('http://172.20.10.3:3000/api/bookinfo'),
      Uri.parse('http://$ipaddr/api/createnloadChat'),
      body: jsonEncode({
        "self": self,
        "notself": her,
        "msg": msg,
        "randomhash": random,
        "dates":
            new DateFormat('yyyy-MM-dd').format(new DateTime.now()).toString(),
      }),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      });
}
