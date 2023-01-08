import 'package:flutter/material.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:audioplayers/audioplayers.dart';
import "package:cached_network_image/cached_network_image.dart";
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:trade_app/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:cron/cron.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import "dart:async";

class Chatter extends StatefulWidget {
  final String title;
  Chatter({Key? key, required this.title}) : super(key: key);

  @override
  _ChatterState createState() => _ChatterState();
}

class _ChatterState extends State<Chatter> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final help = Provider.of<UserProvider>(context, listen: false);
      String myuser = help.user.name;
      readJson(myuser);
    });
    startTask();
  }

  var data2;

  List _items = [];

  // Fetch content from the json file
  Future<String> readJson(myuser) async {
    //load  the json here!!
    //fetch here

    // final String response = await rootBundle.loadString('assets/chatter.json');
    // final data = await json.decode(response);

    http.Response data =
        await http.post(Uri.parse('http://172.20.10.3:3000/api/grabchat'),
            body: jsonEncode({
              "self": myuser,
              "notself": widget.title,
            }),
            headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });

    // print(resaa);
    print("Im reading and doinng...");
    //final data = await json.decode(response);
    final abc = await json.decode(data.body);
    setState(() {
      // _items = data["items"];
      // _items = data;
      //data2 = data;
      data2 = abc[0];
    });

    // print(data);
    // print("compare\n");
    // print(data2);
    // data2["chats"].forEach((value) {
    //   value["chatter"].forEach((userchat) {
    //     if (userchat["user"] == "tanjaii") {
    //       print(userchat["text"].toString());
    //     }
    //   });
    // });
    return ("tried");
  }

  AudioPlayer audioPlayer = new AudioPlayer();
  Duration duration = new Duration();
  Duration position = new Duration();
  bool isPlaying = false;
  bool isLoading = false;
  bool isPause = false;
  startTask() {
    final help = Provider.of<UserProvider>(context, listen: false);
    String myuser = help.user.name;
    var cron = new Cron();
    cron.schedule(new Schedule.parse('*/1 * * * *'), () async {
      readJson(myuser);
    });
  }

  void sendmsg(self, msg, random) async {
    // print(msg),
    var resul = await http.post(
        //localhost
        //Uri.parse('http://172.20.10.3:3000/api/bookinfo'),
        Uri.parse('http://172.20.10.3:3000/api/createnloadChat'),
        body: jsonEncode({
          "self": self,
          "notself": widget.title,
          "msg": msg,
          "randomhash": random,
          "dates": new DateFormat('yyyy-MM-dd')
              .format(new DateTime.now())
              .toString(),
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });
    print(resul.body);
    String test = await readJson(self);
    print(test);
    print(data2);
    readJson(self);
  }

  // printchat() {
  //   return
  // }
  int j = 0;
  var resa;
  var formatter = new DateFormat('yyyy-MM-dd');
  printchat(int i, int j) {}

  @override
  Widget build(BuildContext context) {
    Random random = new Random();
    var self = context.watch<UserProvider>().user.name;
    final now = new DateTime.now();

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          leading: GestureDetector(
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onTap: () {
              Navigator.pop(context, "something");
            },
          ),
        ),
        body: data2 != null
            ? Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        BubbleNormalImage(
                          id: 'id001',
                          image: _image(),
                          color: Colors.purpleAccent,
                          tail: true,
                          delivered: true,
                          isSender: data2["chatter"][1]["user"].toString() !=
                                  widget.title
                              ? false
                              : true,
                        ),
                        //printchat(),data2["chats"].forEach((value) {
                        //   value["chatter"].forEach((userchat) {
                        //     if (userchat["user"] == "tanjaii") {
                        //       print(userchat["text"].toString());
                        //     }
                        //   });
                        // });

                        for (int i = 0; i < data2["chatter"].length; i++)
                          if (data2["chatter"][i]["dates"] != null)
                            DateChip(
                                date: DateTime.parse(
                                    data2["chatter"][i]["dates"]))
                          else
                            BubbleSpecialOne(
                              text: data2["chatter"][i]["text"].toString(),
                              isSender:
                                  data2["chatter"][i]["user"].toString() !=
                                          widget.title
                                      ? true
                                      : false,
                              color: data2["chatter"][i]["user"].toString() !=
                                      widget.title
                                  ? Colors.blue
                                  : Colors.black,
                              textStyle: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),

                        SizedBox(
                          height: 100,
                        )
                      ],
                    ),
                  ),
                  MessageBar(
                    onSend: (msg) => {
                      sendmsg(self, msg, random.nextInt(100000) + 10),
                    },
                    actions: [
                      InkWell(
                        child: Icon(
                          Icons.add,
                          color: Colors.black,
                          size: 30,
                        ),
                        onTap: () {},
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8, right: 8),
                        child: InkWell(
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.green,
                            size: 30,
                          ),
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                ],
              )
            : Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        //printchat(),data2["chats"].forEach((value) {
                        //   value["chatter"].forEach((userchat) {
                        //     if (userchat["user"] == "tanjaii") {
                        //       print(userchat["text"].toString());
                        //     }
                        //   });
                        // });

                        SizedBox(
                          height: 100,
                        )
                      ],
                    ),
                  ),
                  MessageBar(
                    onSend: (msg) => {
                      sendmsg(self, msg, random.nextInt(100000) + 10),
                    },
                    actions: [
                      InkWell(
                        child: Icon(
                          Icons.add,
                          color: Colors.black,
                          size: 30,
                        ),
                        onTap: () {},
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8, right: 8),
                        child: InkWell(
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.green,
                            size: 30,
                          ),
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                ],
              )

        // This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  Widget _image() {
    return Container(
      constraints: BoxConstraints(
        minHeight: 20.0,
        minWidth: 20.0,
      ),
      child: CachedNetworkImage(
        imageUrl: 'https://i.ibb.co/JCyT1kT/Asset-1.png',
        progressIndicatorBuilder: (context, url, downloadProgress) =>
            CircularProgressIndicator(value: downloadProgress.progress),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }

  void _changeSeek(double value) {
    setState(() {
      audioPlayer.seek(new Duration(seconds: value.toInt()));
    });
  }

  void _playAudio() async {
    final url =
        'https://file-examples-com.github.io/uploads/2017/11/file_example_MP3_700KB.mp3';
    if (isPause) {
      await audioPlayer.resume();
      setState(() {
        isPlaying = true;
        isPause = false;
      });
    } else if (isPlaying) {
      await audioPlayer.pause();
      setState(() {
        isPlaying = false;
        isPause = true;
      });
    } else {
      setState(() {
        isLoading = true;
      });
    }

    audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() {
        duration = d;
        isLoading = false;
      });
    });
  }
}
