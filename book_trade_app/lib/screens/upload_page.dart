import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter/material.dart';
import 'package:trade_app/widgets/reusable_widget.dart';
import 'package:trade_app/screens/bookInfodetail.dart';
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

class UploadPage extends StatefulWidget {
  const UploadPage({Key? key, this.title}) : super(key: key);
  final String? title;
  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final ImagePicker _picker = ImagePicker();
  var maxWidthController = TextEditingController();
  var maxHeightController = TextEditingController();
  var qualityController = TextEditingController();

  var ISBNController = TextEditingController();
  var commentsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //ISBNController = new TextEditingController(text: '9780547928227');
    // commentsController = new TextEditingController(
    //     text: 'I really liked her but she dosnt know.');
    maxHeightController = new TextEditingController(text: '375');
    maxWidthController = new TextEditingController(text: '375');
    qualityController = new TextEditingController(text: '100');
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

  uploading(realusername) async {
    if (_imageFileList != null) {
      var request = http.MultipartRequest(
          "POST", Uri.parse("https://api.imgur.com/3/image"));
      request.fields['title'] = "dummyImage";
      request.headers['Authorization'] = "Client-ID " + "4556ad76cb684d8";

      var res = await http.post(
          //localhost
          //Uri.parse('http://172.20.10.3:3000/api/bookinfo'),
          Uri.parse('http://172.20.10.3:3000/api/bookinfo'),
          body: jsonEncode({"book_isbn": ISBNController.text}),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });

      print("Im res:: " + res.body);
      var resBody = await json.decode(res.body);
      debugPrint("ISBN code is: " + ISBNController.text);
      debugPrint("book title is:" + resBody['title']); // can print title

      if (resBody["error"] != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('ISBN code not found, please enter a correct code!')),
        );
      } else {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Uploading Book...')),
        );
      }

      String tempPath = "";
      String appDocPath = "";
      Directory appDocDir = await getApplicationDocumentsDirectory();
      appDocPath = appDocDir.path;
      print(appDocPath);
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
      print(result);
      String name2 = result['data']['id'];
      String url2 = result['data']['link'];
      String delhash = result['data']['deletehash'];
      String dbISBN = ISBNController.text;
      String dbcomments = commentsController.text;
      String googlelink = resBody['infoLink'];
      String booktitle = resBody['title'];
      String author = resBody['authors'][0];
      print("this is googlelink ->" + googlelink);
      print("this is booktitle ->" + booktitle);
      print("this is author ->" + author);
      // if (result != null) {
      AuthService().uploadIng(
        name: name2,
        url: url2,
        delhash: delhash,
        dbISBN: dbISBN,
        comments: dbcomments,
        username: realusername,
        googlelink: googlelink,
        booktitle: booktitle,
        author: author,
      );
      // }
      print("this is uname ->" + realusername);
      print("this is name ->" + name2);
      print("this is url ->" + url2);
      print("this is isbn ->" + dbISBN);
      //output img num and such and the luv to ah bee
    }
    // your code
  }

  @override
  void dispose() {
    maxWidthController.dispose();
    maxHeightController.dispose();
    qualityController.dispose();
    ISBNController.dispose();
    commentsController.dispose();
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

  // Future<void> retrieveLostData() async {
  //   final LostDataResponse response = await _picker.retrieveLostData();
  //   if (response.isEmpty) {
  //     return;
  //   }
  //   if (response.file != null) {
  //     isVideo = false;
  //     setState(() {
  //       if (response.files == null) {
  //         _setImageFileListFromFile(response.file);
  //       } else {
  //         _imageFileList = response.files;
  //       }
  //     });
  //   } else {
  //     _retrieveDataError = response.exception!.code;
  //   }
  // }

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
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Add optional parameters'),
            content: Column(
              children: <Widget>[
                TextField(
                  controller: maxWidthController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                      hintText: 'Enter maxWidth (please enter 300)'),
                ),
                TextField(
                  controller: maxHeightController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                      hintText: 'Enter maxHeight (please enter 300)'),
                ),
                TextField(
                  controller: qualityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      hintText: 'Enter quality (please enter 60)'),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                  child: const Text('PICK'),
                  onPressed: () {
                    final double? width = maxWidthController.text.isNotEmpty
                        ? double.parse(maxWidthController.text)
                        : null;
                    final double? height = maxHeightController.text.isNotEmpty
                        ? double.parse(maxHeightController.text)
                        : null;
                    final int? quality = qualityController.text.isNotEmpty
                        ? int.parse(qualityController.text)
                        : null;
                    onPick(
                        double.parse(maxWidthController.text),
                        double.parse(maxHeightController.text),
                        int.parse(qualityController.text));
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var realusername = context.watch<UserProvider>().user.name;

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

    // final UploadImageButton = ElevatedButton(

    //   style: ElevatedButton.styleFrom(
    //     foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
    //     backgroundColor: const Color.fromARGB(100, 217, 217, 217),
    //     minimumSize: const Size(350, 350),
    //     shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.circular(10.0),
    //     ),
    //   ),
    //   onPressed: () {
    //     //let user to choose photo from album
    //     // isVideo = false;
    //     // _onImageButtonPressed(ImageSource.gallery, context: context);
    //   },
    //   child: const Text('Upload image here'),
    // );
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

    return MaterialApp(
        home: Scaffold(
      backgroundColor: const Color.fromARGB(255, 157, 85, 169),
      appBar: ReusableWidgets.UploadItem('Upload your book!'),
      body: Center(
        child: _handlePreview(),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: FloatingActionButton(
                onPressed: () {
                  _cameraResults(context);
                },
                heroTag: 'image2',
                tooltip: 'ISBN Scanner',
                child: Image.asset(
                  "assets/icons8-barcode-64.png",
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
            child: FloatingActionButton(
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
              heroTag: 'image2',
              tooltip: 'Scanned Book Detail',
              child: const Icon(Icons.library_books_outlined),
            ),
          ),
          Semantics(
            label: 'image_picker_example_from_gallery',
            child: FloatingActionButton(
              onPressed: () {
                isVideo = false;
                _onImageButtonPressed(ImageSource.gallery, context: context);
              },
              heroTag: 'image0',
              tooltip: 'Pick Image from gallery',
              child: const Icon(Icons.photo),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: FloatingActionButton(
              onPressed: () {
                isVideo = false;
                _onImageButtonPressed(ImageSource.camera, context: context);
              },
              heroTag: 'image2',
              tooltip: 'Take a Photo',
              child: const Icon(Icons.camera_alt),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: FloatingActionButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        scrollable: true,
                        title: Text('Login'),
                        content: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Form(
                            child: Column(
                              children: <Widget>[
                                TextFormField(
                                  controller: ISBNController,
                                  decoration: InputDecoration(
                                    labelText: 'ISBN',
                                    icon: Icon(Icons.camera),
                                  ),
                                ),
                                TextFormField(
                                  controller: commentsController,
                                  decoration: InputDecoration(
                                    labelText: 'comments',
                                    icon: Icon(Icons.message),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        actions: [
                          ElevatedButton(
                              child: Text("Submit"),
                              onPressed: () async {
                                await uploading(realusername);
                                ScaffoldMessenger.of(context)
                                    .removeCurrentSnackBar();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Item uploaded! ')),
                                );
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  NavBar.routeName,
                                  (route) => false,
                                );
                              })
                        ],
                      );
                    });
                //Upload the book user enter with ISBN and its thumbnail
              },
              heroTag: 'image2',
              tooltip: 'Upload your book!',
              child: const Icon(Icons.upload),
            ),
          ),
        ],
      ),
    ));
  }
}

typedef OnPickImageCallback = void Function(
    double? maxWidth, double? maxHeight, int? quality);
