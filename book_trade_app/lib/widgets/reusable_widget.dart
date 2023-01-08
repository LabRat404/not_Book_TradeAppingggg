import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class ReusableWidgets {
  static accountPageAppBar(String title) {
    return AppBar(
      toolbarHeight: 70,
      backgroundColor: Colors.green,
      title: Text(title),
    );
  }

  static otherUserProfile(String title) {
    var namee = title;
    return AppBar(
      title: Text(
        "$namee's Profile",
        style: GoogleFonts.montserrat(
            textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 0.9,
                fontSize: 25)),
        textAlign: TextAlign.left,
      ),
      flexibleSpace: Image(
        image: AssetImage('assets/book_title.jpg'),
        fit: BoxFit.cover,
      ),
      backgroundColor: Colors.transparent,
    );
  }

  static UploadItem(String title) {
    return AppBar(
      title: Text('Upload your book!'),
      backgroundColor: Colors.green,
      actions: [
        IconButton(
          icon: const Icon(Icons.info_outline),
          tooltip: 'Upload Book Menu',
          onPressed: () async {
            // handle the press

            if (await canLaunchUrl(Uri.parse("https://imgur.com/a/PwLrDxY"))) {
              launchUrl(Uri.parse("https://imgur.com/a/PwLrDxY"));
            }
          },
        ),
      ],
    );
  }

  static changeAvatar(String title) {
    return AppBar(
      title: Text('Chane your Avatar!'),
      flexibleSpace: Image(
        image: AssetImage('assets/book_title.jpg'),
        fit: BoxFit.cover,
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.info_outline),
          tooltip: 'Change Avatar Menu',
          onPressed: () async {
            // handle the press
            if (await canLaunchUrl(Uri.parse("https://imgur.com/a/Sr7FBbi"))) {
              launchUrl(Uri.parse("https://imgur.com/a/Sr7FBbi"));
            }
          },
        ),
      ],
    );
  }

  static LoginPageAppBar(String title) {
    return AppBar(
      title: Text(
        title,
        style: GoogleFonts.montserrat(
            textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 0.9,
                fontSize: 25)),
        textAlign: TextAlign.left,
      ),
      flexibleSpace: Image(
        image: AssetImage('assets/book_title.jpg'),
        fit: BoxFit.cover,
      ),
      backgroundColor: Colors.transparent,
    );
  }
}
