import 'dart:async';
import 'package:flutter/material.dart';
import 'package:notes_app/utils/db_helper.dart';
import 'package:notes_app/models/notes.dart';
import 'package:notes_app/screens/note_detail.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notes_app/screens/search_note.dart';
import 'package:notes_app/utils/widgets.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class NoteList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NoteListState();
  }
}

class NoteListState extends State<NoteList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> noteList;
  int count = 0;
  int axisCount = 2;

  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = List<Note>();
      updateListView();
    }

    Widget myAppBar() {
      return AppBar(
        title: Text('Entries', style: Theme.of(context).textTheme.headline),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.lightBlueAccent,
        leading: noteList.length == 0
            ? Container()
            : IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.black,
                ),
                onPressed: () async {
                  final Note result = await showSearch(
                      context: context, delegate: NotesSearch(notes: noteList));
                  if (result != null) {
                    navigateToDetail(result, 'Edit Note');
                  }
                },
              ),
        actions: <Widget>[
          noteList.length == 0
              ? Container()
              : IconButton(
                  icon: Icon(
                    axisCount == 2 ? Icons.list : Icons.grid_on,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    setState(() {
                      axisCount = axisCount == 2 ? 4 : 2;
                    });
                  },
                )
        ],
      );
    }

    return Scaffold(
      appBar: myAppBar(),
      body: noteList.length == 0
          ? Container(
              //color: Colors.white,

              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Click on the add button to add a new note!',
                      style: Theme.of(context).textTheme.body1),
                ),
              ),
            )
          : Container(
              //color: Colors.white,
        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin : Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.lightBlueAccent,
                Colors.white10,
              ],
            )
        ),
              child: getNotesList(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          var date = DateFormat.yMMMd().format(DateTime.now());
          navigateToDetail(Note('', date, 2, 0), 'Add Entry');
        },
        tooltip: 'What did you accomplish?',
        shape: CircleBorder(side: BorderSide(color: Colors.black.withOpacity(0.5), width: 2.0)),
        child: Icon(Icons.add, color: Colors.blueGrey.withOpacity(0.5)),
        elevation: 0,
        backgroundColor: Colors.lightBlueAccent.withOpacity(0.2),


      ),
    );
  }

  Widget getNotesList() {
    return StaggeredGridView.countBuilder(
      physics: BouncingScrollPhysics(),
      crossAxisCount: 4,
      itemCount: count,
      itemBuilder: (BuildContext context, int index) => GestureDetector(
        onTap: () {
          navigateToDetail(this.noteList[index], 'Edit Note');
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                color: colors[this.noteList[index].color],
                border: Border.all(width: 2, color: Colors.black),
                borderRadius: BorderRadius.circular(8.0)),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          this.noteList[index].title,
                          style: Theme.of(context).textTheme.body1,
                        ),
                      ),
                    ),
                    Text(
                      getPriorityText(this.noteList[index].priority),
                      style: TextStyle(
                          color:
                              getPriorityColor(this.noteList[index].priority)),
                    ),
                  ],
                ),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.start,
                //     children: <Widget>[
                //       Expanded(
                //         child: Text(
                //             this.noteList[index].description == null
                //                 ? ''
                //                 : this.noteList[index].description,
                //             style: Theme.of(context).textTheme.body2),
                //       )
                //     ],
                //   ),
                // ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(this.noteList[index].date,
                          style: Theme.of(context).textTheme.subtitle),
                    ])
              ],
            ),
          ),
        ),
      ),
      staggeredTileBuilder: (int index) => StaggeredTile.fit(axisCount),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
    );
  }

  // Returns the priority color
  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.yellow;
        break;
      case 3:
        return Colors.green;
        break;

      default:
        return Colors.yellow;
    }
  }

  // Returns the priority icon
  String getPriorityText(int priority) {
    switch (priority) {
      case 1:
        return '✨';
        break;
      case 2:
        return '💎';
        break;
      case 3:
        return '👑';
        break;

      default:
        return '✨';
    }
  }

  void navigateToDetail(Note note, String title) async {
    bool result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => NoteDetail(note, title)));

    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }
}
