import 'package:flutter/material.dart';
import 'package:trade_app/screens/tradeSelectList.dart';
import 'dart:convert';
import 'package:trade_app/screens/bookInfodetail_forsearch.dart';
import 'package:provider/provider.dart';
import 'package:trade_app/provider/user_provider.dart';
import 'package:http/http.dart' as http;
import 'package:trade_app/routes/ip.dart' as globals;
import 'package:tabbed_sliverlist/tabbed_sliverlist.dart';

var ipaddr = globals.ip;

class TradeShowList extends StatefulWidget {
  final String otherusername;
  TradeShowList({Key? key, required this.otherusername}) : super(key: key);
  @override
  _TradeShowListState createState() => _TradeShowListState();
}

class _TradeShowListState extends State<TradeShowList> {
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
  List _notmylist = [];
  List emptyList = [];
  Future<void> readJson(realusername, otherusername) async {
    List tmp1 = [];
    List tmp2 = [];
    List names = [];
    // http.Response dodo =
    //     await http.post(Uri.parse('http://$ipaddr/api/createtradebusket'),
    //         body: jsonEncode({
    //           "self": realusername,
    //           "notself": otherusername,
    //         }),
    //         headers: <String, String>{
    //       'Content-Type': 'application/json; charset=UTF-8',
    //     });
    //Import the tradebucket.json
    http.Response showInfo =
        await http.post(Uri.parse('http://$ipaddr/api/gettradebusket'),
            body: jsonEncode({
              "self": realusername,
              "notself": otherusername,
            }),
            headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });
    //var showInfo = await rootBundle.loadString('assets/tradebucket.json');

    final info = await json.decode(showInfo.body);

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
    for (int i = 0; i < info[0]['selflist'].length; i++) {
      names.add(info[0]['selflist'][i]);
    }
    for (int i = 0; i < info[0]['notselflist'].length; i++) {
      names.add(info[0]['notselflist'][i]);
    }
    //print(showInfo.body);
    if (showInfo.body != "Empty") {
      for (int i = 0; i < dataself.length; i++) {
        if (names.contains(dataself[i]['name'])) {
          tmp1.add(dataself[i]);
        }
      }
      for (int i = 0; i < datanotself.length; i++) {
        if (names.contains(datanotself[i]['name'])) {
          tmp2.add(datanotself[i]);
        }
      }
    }
    setState(() {
      _mylist = tmp1;
      _notmylist = tmp2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Offer with ${widget.otherusername}'),
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
            icon: const Icon(Icons.create_outlined, size: 25),
            color: Color.fromARGB(255, 255, 255, 255),
            tooltip: 'Upload Book Menu',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        TradeList(otherusername: widget.otherusername)),
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
                return ListTile(
                  leading: Image.network(_mylist[index]['url']),
                  title: Text(_mylist[index]['booktitle']),
                  subtitle: Text(
                    "Comments: " + _mylist[index]['comments'],
                    style: TextStyle(color: Colors.black.withOpacity(0.6)),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InfoDetailPageSearch(
                            hashname: _mylist[index]['name']),
                      ),
                    );
                  },
                );
              },
              tabListPadding: const EdgeInsets.symmetric(horizontal: 10),
            ),
            TabListBuilder(
              uniquePageKey: 'page2',
              length: _notmylist.length,
              builder: (context, index) {
                return ListTile(
                  leading: Image.network(_notmylist[index]['url']),
                  title: Text(_notmylist[index]['booktitle']),
                  subtitle: Text(
                    "Comments: " + _notmylist[index]['comments'],
                    style: TextStyle(color: Colors.black.withOpacity(0.6)),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InfoDetailPageSearch(
                            hashname: _notmylist[index]['name']),
                      ),
                    );
                  },
                );
              },
              tabListPadding: const EdgeInsets.symmetric(horizontal: 10),
            )
          ]),
    );
  }
}
