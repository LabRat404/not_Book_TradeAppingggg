import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:trade_app/widgets/reusable_widget.dart';
import 'package:provider/provider.dart';
import 'package:trade_app/provider/user_provider.dart';
import 'package:http/http.dart' as http;
import 'package:trade_app/screens/chatter.dart';
import 'package:cron/cron.dart';
import 'dart:async';
import 'package:trade_app/routes/ip.dart' as globals;

var ipaddr = globals.ip;

class TradeList extends StatefulWidget {
  const TradeList({Key? key}) : super(key: key);
  static const String routeName = '/bookinfo';
  @override
  State<TradeList> createState() => _TradeListState();
}

class _TradeListState extends State<TradeList> {
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
    //startTask();
  }

  startTask() {
    final help = Provider.of<UserProvider>(context, listen: false);
    String myuser = help.user.name;
    var cron = new Cron();
    cron.schedule(new Schedule.parse('*/1 * * * *'), () async {
      readJson(myuser);
    });
  }
  // void didChangeDependencies() {
  //   debugPrint(
  //       'Child widget: didChangeDependencies(), counter = $realusername');
  //   super.didChangeDependencies();
  // }

  List _items = [];
  List loadusernameimage = [];
  // Fetch content from the json file
  Future<String> readJson(realusername) async {
    //load  the json here!!
    //fetch here
    http.Response resaa = await http.get(
        Uri.parse('http://$ipaddr/api/graballchat/$realusername'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });
    //print(resaa);

    final data = await json.decode(resaa.body);

    List whoimage = [];

    for (int i = 0; i < data.length; i++) {
      String nameping = data[i]["notself"];
      if (nameping.toString() == realusername.toString()) {
        var who = data[i]["self"];
        http.Response imglink = await http.get(
            Uri.parse('http://$ipaddr/api/loaduserimage/$who'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            });

        whoimage.add(imglink.body.toString());
      } else {
        var who = data[i]["notself"];
        http.Response imglink = await http.get(
            Uri.parse('http://$ipaddr/api/loaduserimage/$who'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            });
        //print(imglink.body);

        whoimage.add(imglink.body.toString());
      }
    }
    //print(whoimage[0]);
    print("length : is :" + whoimage.length.toString());
    setState(() {
      _items = data;
      loadusernameimage = whoimage;
    });
    return ("tried");
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
  List<String> items = List<String>.generate(10, (i) => '$i');
  @override
  Widget build(BuildContext context) {
    var myselfname = context.watch<UserProvider>().user.name;
    return Scaffold(
      appBar: ReusableWidgets.LoginPageAppBar("Chat Record"),
      body: Padding(
          padding: const EdgeInsets.all(25),
          child: RefreshIndicator(
            onRefresh: () async {
              var test = await readJson(myselfname);
            },
            child: Column(
              children: [
                _items.isNotEmpty
                    ? Expanded(
                        child: ListView.builder(
                          itemCount: _items.length,
                          itemBuilder: (context, index) {
                            int long = _items[index]["chatter"].length;
                            String who = "";
                            if (_items[index]["notself"] == myselfname)
                              who = _items[index]["self"];
                            else
                              who = _items[index]["notself"];
                            return Column(children: <Widget>[
                              ListTile(
                                leading: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(loadusernameimage[index]),
                                ),
                                title: Text(
                                  who,
                                ),
                                subtitle: Text(
                                    _items[index]["chatter"][long - 1]["text"]),
                                trailing: PopupMenuButton(
                                  itemBuilder: (context) {
                                    return [
                                      // PopupMenuItem(
                                      //   value: 'edit',
                                      //   child: Text('Edit'),
                                      // ),
                                      PopupMenuItem(
                                        value: 'delete',
                                        child: Text('Delete'),
                                        onTap: () => {
                                          print("hiihhiih"),
                                        },
                                      )
                                    ];
                                  },
                                  onSelected: (String value) {
                                    print('You Click on po up menu item');
                                  },
                                ),
                                onTap: () async {
                                  final text = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Chatter(title: who),
                                    ),
                                  );
                                  print(text);
                                  readJson(myselfname);
                                },
                              ),
                              Divider(
                                  color: Colors.grey,
                                  endIndent: 24,
                                  indent: 24),
                            ]);
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
          )),
    );
  }
}
