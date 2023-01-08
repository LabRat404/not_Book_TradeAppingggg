import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:trade_app/screens/information_page.dart';
import 'package:trade_app/screens/login_page.dart';
import 'package:trade_app/screens/change_page.dart';
import 'package:trade_app/screens/avatarchange.dart';
import 'package:trade_app/widgets/reusable_widget.dart';
import 'package:trade_app/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:trade_app/screens/bookInfodetail_forsearch.dart';
import 'package:provider/provider.dart';
import 'package:trade_app/provider/user_provider.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:trade_app/widgets/reusable_widget.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:trade_app/screens/showOtherUser.dart';
import 'package:trade_app/screens/chatter.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  //String realusername = 'doria';

  void initState() {
    print("Hi  Im loading settings");
    super.initState();
    //var realusername = context.watch<UserProvider>().user.name;
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   realusername = Provider.of<String>(context, listen: false);
    // });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final help = Provider.of<UserProvider>(context, listen: false);
      String realusername = help.user.name;
      readJson(realusername);
      //print("lol she did it" + help.user.address);
    });
  }

  // void didChangeDependencies() {
  //   debugPrint(
  //       'Child widget: didChangeDependencies(), counter = $realusername');
  //   super.didChangeDependencies();
  // }

  String links = "";
  // Fetch content from the json file
  Future<void> readJson(realusername) async {
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

  @override
  Widget build(BuildContext context) {
    var username = context.watch<UserProvider>().user.name;
    return MaterialApp(
      home: Scaffold(
        appBar: ReusableWidgets.LoginPageAppBar('Settings'),
        backgroundColor: Colors.white.withOpacity(.94),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: [
              // user card
              links.isEmpty
                  ? SimpleUserCard(
                      userName: username,
                      userProfilePic: AssetImage("assets/empty.png"),
                    )
                  : SimpleUserCard(
                      userName: username,
                      userProfilePic: NetworkImage(links),
                    ),

              SettingsGroup(
                items: [
                  SettingsItem(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AvatarChange()));
                    },
                    icons: CupertinoIcons.pencil_outline,
                    iconStyle: IconStyle(),
                    title: 'Appearance',
                    subtitle: "Change your avatar!",
                  ),
                  SettingsItem(
                    onTap: () {},
                    icons: Icons.fingerprint,
                    iconStyle: IconStyle(
                      iconsColor: Colors.white,
                      withBackground: true,
                      backgroundColor: Colors.red,
                    ),
                    title: 'Privacy',
                    subtitle: "Choose what to share!",
                  ),
                  SettingsItem(
                    onTap: () {},
                    icons: Icons.dark_mode_rounded,
                    iconStyle: IconStyle(
                      iconsColor: Colors.white,
                      withBackground: true,
                      backgroundColor: Colors.red,
                    ),
                    title: 'Dark mode',
                    subtitle: "Automatic",
                    trailing: Switch.adaptive(
                      value: false,
                      onChanged: (value) {},
                    ),
                  ),
                ],
              ),
              SettingsGroup(
                items: [
                  SettingsItem(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const InformationPage()),
                      );
                    },
                    icons: Icons.info_rounded,
                    iconStyle: IconStyle(
                      backgroundColor: Colors.purple,
                    ),
                    title: 'About',
                    subtitle: "Learn more Trade Books",
                  ),
                ],
              ),
              // You can add a settings title
              SettingsGroup(
                settingsGroupTitle: "Account",
                items: [
                  SettingsItem(
                    onTap: () {
                      Navigator.of(context).pushAndRemoveUntil(
                          new MaterialPageRoute(
                              builder: (context) => new LoginPage()),
                          (route) => false);
                    },
                    icons: Icons.exit_to_app_rounded,
                    title: "Sign Out",
                  ),
                  SettingsItem(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ChangePage()),
                      );
                    },
                    icons: CupertinoIcons.repeat,
                    title: "Change email/password",
                  ),
                  SettingsItem(
                    onTap: () {},
                    icons: CupertinoIcons.delete_solid,
                    title: "Delete account",
                    titleStyle: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
