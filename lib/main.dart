import 'package:flutter/material.dart';
import 'package:notes_app/screens/note_list.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NoteKeeper',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(

        primarySwatch: Colors.lightBlue,
        primaryColor: Colors.black,


        textTheme: TextTheme(
          headline: GoogleFonts.lobster(
            fontWeight: FontWeight.bold,
            color: Colors.black54,
            fontSize: 36),
          //TextStyle(
             // fontFamily: GoogleFonts,

              //fontWeight: FontWeight.bold,
              //color: Colors.black,
             // fontSize: 24),
          body1: TextStyle(
              fontFamily: 'Sans',
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 20),
          body2: TextStyle(
              fontFamily: 'Sans',
              fontWeight: FontWeight.normal,
              color: Colors.black,
              fontSize: 18),
          subtitle: TextStyle(
              fontFamily: 'Sans',
              fontWeight: FontWeight.normal,
              color: Colors.black,
              fontSize: 14),
        ),
      ),
      home: NoteList(),
    );
  }
}
