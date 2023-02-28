import 'package:flutter/material.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:audioplayers/audioplayers.dart';
import "package:cached_network_image/cached_network_image.dart";
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trade_app/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'dart:math' as math;
import 'package:intl/intl.dart';
import 'package:cron/cron.dart';
import 'dart:async';
import 'package:trade_app/routes/ip.dart' as globals;
import 'package:trade_app/screens/showOtherUser.dart';
import 'package:flutter/material.dart';
import 'package:trade_app/widgets/reusable_widget.dart';
import 'package:trade_app/screens/bookInfodetail.dart';
import 'package:trade_app/screens/tradeshowlist.dart';
import '/../widgets/camera.dart';
import 'package:trade_app/provider/user_provider.dart';

import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:trade_app/widgets/nav_bar.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:trade_app/services/auth/connector.dart';
import 'package:trade_app/routes/ip.dart' as globals;

import 'package:trade_app/screens/bookInfodetail.dart';
import '/../widgets/camera.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';

var ipaddr = globals.ip;

class Chatter extends StatefulWidget {
  final String title;
  Chatter({Key? key, required this.title}) : super(key: key);

  @override
  _ChatterState createState() => _ChatterState();
}

class _ChatterState extends State<Chatter> {
  Timer mytimer = Timer.periodic(Duration(), (timer) {});
  final ImagePicker _picker = ImagePicker();
  var maxWidthController = TextEditingController();
  var maxHeightController = TextEditingController();
  var qualityController = TextEditingController();

  var MsgController = TextEditingController();
  var ISBNController = TextEditingController();
  var commentsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    run("run");
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final help = Provider.of<UserProvider>(context, listen: false);
      String myuser = help.user.name;
      readJson(myuser);
    });

    //Timer but need to think of disposing it

    maxHeightController = new TextEditingController(text: '375');
    maxWidthController = new TextEditingController(text: '375');
    qualityController = new TextEditingController(text: '100');
    //startTask();
    //if use autp cron  job, rmb  to dispose  or else will have a green leak
  }

  Future<Directory?>? _tempDirectory;

  void _requestTempDirectory() {
    setState(() {
      _tempDirectory = getTemporaryDirectory();
    });
  }

  List<XFile>? _imageFileList;
  void _setImageFileListFromFile(XFile? value) {
    _imageFileList = value == null ? null : <XFile>[value];
  }

  dynamic _pickImageError;
  bool isVideo = false;
  String? _retrieveDataError;

  Future<void> _onImageButtonPressed(ImageSource source,
      {BuildContext? context, bool isMultiImage = false}) async {
    if (isMultiImage) {
      await _displayPickImageDialog(context!,
          (double? maxWidth, double? maxHeight, int? quality) async {
        try {
          final List<XFile> pickedFileList = await _picker.pickMultiImage(
            maxWidth: maxWidth,
            maxHeight: maxHeight,
            imageQuality: quality,
          );
          setState(() {
            _imageFileList = pickedFileList;
          });
        } catch (e) {
          setState(() {
            _pickImageError = e;
          });
        }
      });
    } else {
      await _displayPickImageDialog(context!,
          (double? maxWidth, double? maxHeight, int? quality) async {
        try {
          final XFile? pickedFile = await _picker.pickImage(
            source: source,
            maxWidth: maxWidth,
            maxHeight: maxHeight,
            imageQuality: quality,
          );
          setState(() {
            _setImageFileListFromFile(pickedFile);
          });
          String link = await uploading();
        } catch (e) {
          setState(() {
            _pickImageError = e;
          });
        }
      });
    }
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  uploading() async {
    final help = Provider.of<UserProvider>(context, listen: false);
    String myuser = help.user.name;

    if (_imageFileList != null) {
      var request = http.MultipartRequest(
          "POST", Uri.parse("https://api.imgur.com/3/image"));
      request.fields['title'] = "dummyImage";
      request.headers['Authorization'] = "Client-ID " + "4556ad76cb684d8";

      String tempPath = "";
      String appDocPath = "";
      Directory appDocDir = await getApplicationDocumentsDirectory();
      appDocPath = appDocDir.path;

      //get item num api
      final File newImage =
          await File(_imageFileList![0].path).copy('$appDocPath/tmp.png');
      var picture = http.MultipartFile.fromBytes('image',
          (await rootBundle.load('$appDocPath/tmp.png')).buffer.asUint8List(),
          filename: 'test1.png');
      request.files.add(picture);
      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var tmp2 = String.fromCharCodes(responseData);
      Map<String, dynamic> result = json.decode(tmp2);

      Random random = new Random();
      final now = new DateTime.now();
      print("heres the link");
      print(result['data']['link']);

      var res = await http.post(
          //localhost
          //Uri.parse('http://172.20.10.3:3000/api/bookinfo'),
          Uri.parse('http://$ipaddr/api/bookinfo'),
          body: jsonEncode({"book_isbn": ISBNController.text}),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });

      var returnstring =
          await http.post(Uri.parse('http://$ipaddr/api/PhotoChat'),
              body: jsonEncode({
                "self": myuser,
                "notself": widget.title,
                "images": result['data']['link'],
                "randomhash": random.nextInt(100000) + 10,
                "dates": new DateFormat('yyyy-MM-dd')
                    .format(new DateTime.now())
                    .toString(),
              }),
              headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });

      if (returnstring.body == "done") {
        sendmsg(myuser, "loadimgloading", random.nextInt(100000) + 10);
      }

      return returnstring.body;
      // String name2 = result['data']['id'];
      // String url2 = result['data']['link'];
      // String delhash = result['data']['deletehash'];
      // String dbISBN = ISBNController.text;
      // String dbcomments = commentsController.text;
      // String googlelink = resBody['infoLink'];
      // String booktitle = resBody['title'];
      // String author = resBody['authors'][0];
      // print("this is googlelink ->" + googlelink);
      // print("this is booktitle ->" + booktitle);
      // print("this is author ->" + author);
      // // if (result != null) {
      // AuthService().uploadIng(
      //   name: name2,
      //   url: url2,
      //   delhash: delhash,
      //   dbISBN: dbISBN,
      //   comments: dbcomments,
      //   username: realusername,
      //   googlelink: googlelink,
      //   booktitle: booktitle,
      //   author: author,
      // );
      // // }
      // print("this is uname ->" + realusername);
      // print("this is name ->" + name2);
      // print("this is url ->" + url2);
      // print("this is isbn ->" + dbISBN);
      //output img num and such and the luv to ah bee
    }
    // your code
  }

  selectedimage(BuildContext context, OnPickImageCallback onPick) {
    final double? width = maxWidthController.text.isNotEmpty
        ? double.parse(maxWidthController.text)
        : null;
    final double? height = maxHeightController.text.isNotEmpty
        ? double.parse(maxHeightController.text)
        : null;
    final int? quality = qualityController.text.isNotEmpty
        ? int.parse(qualityController.text)
        : null;
    return onPick(
        double.parse(maxWidthController.text),
        double.parse(maxHeightController.text),
        int.parse(qualityController.text));
  }

  run(String value) {
    mytimer = Timer.periodic(Duration(seconds: 40), (timer) {
      final help = Provider.of<UserProvider>(context, listen: false);
      String myuser = help.user.name;
      readJson(myuser);
    });
    if (value == "norun") mytimer.cancel();
  }

  @override
  void dispose() {
    maxWidthController.dispose();
    maxHeightController.dispose();
    qualityController.dispose();
    ISBNController.dispose();
    commentsController.dispose();

    mytimer.cancel();
    super.dispose();
  }

  Widget _previewImages() {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_imageFileList != null) {
      return Semantics(
        label: 'image_picker_example_picked_images',
        child: ListView.builder(
          key: UniqueKey(),
          itemBuilder: (BuildContext context, int index) {
            // Why network for web?
            // See https://pub.dev/packages/image_picker#getting-ready-for-the-web-platform
            return Semantics(
              label: 'image_picker_example_picked_image',
              child: kIsWeb
                  ? Image.network(_imageFileList![index].path)
                  : Image.file(File(_imageFileList![0].path)),
            );
          },
          itemCount: _imageFileList!.length,
        ),
      );
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return const Text(
        'Preview your Image here! ',
        textAlign: TextAlign.center,
      );
    }
  }

  Widget _handlePreview() {
    return _previewImages();
  }

  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  Future<void> _displayPickImageDialog(
      BuildContext context, OnPickImageCallback onPick) async {
    return selectedimage(context, onPick);
  }

  var data2;
  String linkicon = "";
  List _items = [];

  // Fetch content from the json file
  Future<String> readJson(myuser) async {
    //load  the json here!!
    //fetch here
    String notself = widget.title;
    // final String response = await rootBundle.loadString('assets/chatter.json');
    // final data = await json.decode(response);

    http.Response data =
        await http.post(Uri.parse('http://$ipaddr/api/grabchat'),
            body: jsonEncode({
              "self": myuser,
              "notself": widget.title,
            }),
            headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });

    http.Response iconlink = await http.get(
        Uri.parse('http://$ipaddr/api/loaduserimage/$notself'),
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
      linkicon = iconlink.body;
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
        Uri.parse('http://$ipaddr/api/createnloadChat'),
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
    Future<void> _cameraResults(BuildContext context) async {
      final isbn = await Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Camera()));
      if (!mounted) return;
      ISBNController.text = isbn;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Book Scanned with ISBN: $isbn")),
      );
    }

    final CancelButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.redAccent,
        minimumSize: const Size(350, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      onPressed: () {
        isVideo = false;
        _onImageButtonPressed(ImageSource.gallery, context: context);
      },
      child: const Text('Upload image of the item'),
    );

    final Display = FutureBuilder<void>(
      //future: retrieveLostData(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return const Text(
              'You have not yet picked an image.  2',
              textAlign: TextAlign.center,
            );
          case ConnectionState.done:
            return _handlePreview();
          default:
            if (snapshot.hasError) {
              return Text(
                'Pick image/video error: ${snapshot.error}}',
                textAlign: TextAlign.center,
              );
            } else {
              return const Text(
                'You have not yet picked an image. 3',
                textAlign: TextAlign.center,
              );
            }
        }
      },
    );

    final ViewDetailsButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.pinkAccent,
        minimumSize: const Size(350, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => InfoDetailPage(
                    isbncode: ISBNController.text,
                  )),
        );
        //this button should be disabled at first, if there is data fetched from ISBN, then it is enabled
      },
      child: const Text('View details'),
    );

    Random random = new Random();
    var self = context.watch<UserProvider>().user.name;
    final now = new DateTime.now();

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
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
          actions: [
            Material(
              shape: CircleBorder(),
              clipBehavior: Clip.hardEdge,
              color: Colors.transparent,
              child: Ink.image(
                image: NetworkImage(linkicon),
                fit: BoxFit.cover,
                width: 40.0,
                height: 40.0,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ShowotherUser(otherusername: widget.title),
                      ),
                    );
                  },
                ),
              ),
            ),
            Material(
              color: Colors.transparent,
            )
          ],
        ),
        body: data2 != null
            ? Stack(
                children: [
                  SingleChildScrollView(
                    reverse: true,
                    child: Column(
                      children: <Widget>[
                        BubbleNormalImage(
                          id: 'id001',
                          image: _image("https://i.imgur.com/vGgUHFg.jpg"),
                          color: Color((math.Random().nextDouble() * 0xFFFFFF)
                                  .toInt())
                              .withOpacity(1.0),
                          tail: true,
                          delivered: true,
                          isSender: data2["chatter"][1]["user"].toString() !=
                                  widget.title
                              ? false
                              : true,
                        ),
                        Center(
                            child: ButtonBar(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                              ElevatedButton.icon(
                                icon: Icon(Icons.recycling),
                                label: Text("View Trade Bucket"),
                                onPressed: () async {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "Still developing (ノಠ益ಠ) ノ彡 ┻━┻")),
                                  );
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TradeShowList(
                                            otherusername: widget.title)),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  shadowColor: Colors.orange,
                                ),
                              ),
                            ])),
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
                          else if (data2["chatter"][i]["images"] != null)
                            BubbleNormalImage(
                              id: data2["chatter"][i]["images"],
                              image: Container(
                                constraints: BoxConstraints(
                                  minHeight: 20.0,
                                  minWidth: 20.0,
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: data2["chatter"][i]["images"],
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) =>
                                          CircularProgressIndicator(
                                              value: downloadProgress.progress),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                              color: Color(
                                      (math.Random().nextDouble() * 0xFFFFFF)
                                          .toInt())
                                  .withOpacity(1.0),
                              tail: true,
                              delivered: true,
                              isSender:
                                  data2["chatter"][i]["user"].toString() !=
                                          widget.title
                                      ? true
                                      : false,
                            )
                          else if (data2["chatter"][i]["text"].toString() !=
                              "loadimgloading")
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
                      print('tets'),
                      sendmsg(self, msg, random.nextInt(100000) + 10),
                    },
                    actions: [
                      InkWell(
                        child: Icon(
                          Icons.add,
                          color: Colors.black,
                          size: 30,
                        ),
                        onTap: () {
                          isVideo = false;
                          _onImageButtonPressed(ImageSource.gallery,
                              context: context);
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8, right: 8),
                        child: InkWell(
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.green,
                            size: 30,
                          ),
                          onTap: () {
                            isVideo = false;
                            _onImageButtonPressed(ImageSource.camera,
                                context: context);
                          },
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

  Widget _image(String imglink) {
    return Container(
      constraints: BoxConstraints(
        minHeight: 20.0,
        minWidth: 20.0,
      ),
      child: CachedNetworkImage(
        imageUrl: imglink,
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

typedef OnPickImageCallback = void Function(
    double? maxWidth, double? maxHeight, int? quality);
