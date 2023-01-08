import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:trade_app/screens/search.dart';
import 'package:trade_app/screens/home_page.dart';
import 'package:trade_app/screens/settings_page.dart';
import 'package:trade_app/screens/upload_page.dart';
import 'package:trade_app/screens/userbooklist.dart';
import 'package:trade_app/screens/chatrecord.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);
  static const String routeName = '/info';
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  // final String title;

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedindex = 0;
  final List<Widget> _children = [
    const HomePage(),
    const SearchPage(),
    UploadPage(),
    const UserList(),
    const ChatList(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _children.elementAt(_selectedindex),
        bottomNavigationBar: GNav(
            onTabChange: (value) => {
                  setState(() {
                    _selectedindex = value;
                    print("pages: " + value.toString());
                  })
                },
            gap: 0.5,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
            backgroundColor: Colors.black,
            color: Colors.white,
            activeColor: Colors.white,
            tabs: [
              GButton(
                icon: Icons.home_outlined,
                text: 'home',
                onPressed: () => {},
              ),
              GButton(
                icon: Icons.search,
                text: 'Search',
                onPressed: () => {},
              ),
              GButton(
                icon: Icons.bookmark_outline,
                text: 'books',
                // onPressed: () => _slidingPanel(),
                onPressed: () => {},
              ),
              GButton(
                icon: Icons.collections_bookmark_outlined,
                text: 'Inventory',
                onPressed: () => {},
              ),
              GButton(
                icon: Icons.chat_outlined,
                text: 'Chat',
                onPressed: () => {},
              ),
              GButton(
                icon: Icons.settings_outlined,
                text: 'setting',
                onPressed: () => {},
              ),
            ]));
  }

  void _slidingPanel() {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        builder: (context) {
          return Column(children: <Widget>[
            GridView.count(
              shrinkWrap: true,
              primary: true,
              crossAxisCount: 2,
              children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // Expanded(child: Container()),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.calendar_month,
                                color: Colors.redAccent,
                                size: 30.0,
                              )),
                          const Text('calendar',
                              style: TextStyle(color: Colors.redAccent))
                        ],
                      )
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // Expanded(child: Container()),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.upload,
                                color: Colors.amberAccent,
                                size: 30.0,
                              )),
                          const Text('add',
                              style: TextStyle(color: Colors.amberAccent))
                        ],
                      )
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // Expanded(child: Container()),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.handshake,
                                color: Colors.blueAccent,
                                size: 30.0,
                              )),
                          const Text('exchange',
                              style: TextStyle(color: Colors.blueAccent))
                        ],
                      )
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // Expanded(child: Container()),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.search,
                                color: Colors.purpleAccent,
                                size: 30.0,
                              )),
                          const Text('search',
                              style: TextStyle(color: Colors.purpleAccent))
                        ],
                      )
                    ]),
              ],
            ),
          ]);
        });
  }
}
