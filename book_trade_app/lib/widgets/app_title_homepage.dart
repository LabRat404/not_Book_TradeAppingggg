import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      child: Container(
        height: 150,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/book_title.jpg"), fit: BoxFit.cover)),
        child: Container(
          color: Colors.black38,
          child: Padding(
            padding: const EdgeInsets.all(22.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Material(
                  elevation: 18,
                  color: Colors.transparent,
                  child: Container(
                    child: Text(
                      'Welcome back\nAdmin124',
                      textAlign: TextAlign.start,
                      style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 0.9,
                              fontSize: 36)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
