import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/utils/db_helper.dart';
import 'package:notes_app/models/notes.dart';
import 'package:notes_app/utils/widgets.dart';

class NoteDetail extends StatefulWidget {
  final String appBarTitle;
  final Note note;

  NoteDetail(this.note, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return NoteDetailState(this.note, this.appBarTitle);
  }
}

class NoteDetailState extends State<NoteDetail> {
  DatabaseHelper helper = DatabaseHelper();

  double _priority = 2;
  List labels = ['Good ✨', 'Great 💎', 'Amazing 👑'];
  DateTime _displayDate = DateTime.now();
  TextEditingController _controller;

  String appBarTitle;
  Note note;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  int color;
  bool isEdited = false;

  NoteDetailState(this.note, this.appBarTitle);

  _chooseDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _displayDate, // Refer step 1
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    setState(() {
      if (picked != null) {
        _displayDate = picked;
        note.date = DateFormat.yMMMd().format(picked);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    titleController.text = note.title;
    descriptionController.text = note.description;
    color = note.color;
    return WillPopScope(
        onWillPop: () {
          isEdited ? showDiscardDialog(context) : moveToLastScreen();
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: Text(
              appBarTitle,
              style: Theme.of(context).textTheme.headline,
            ),
            backgroundColor: colors[color],
            leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                onPressed: () {
                  isEdited ? showDiscardDialog(context) : moveToLastScreen();
                }),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.save,
                  color: Colors.black,
                ),
                onPressed: () {
                  titleController.text.length == 0
                      ? showEmptyTitleDialog(context)
                      : _save();
                },
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.black),
                onPressed: () {
                  showDeleteDialog(context);
                },
              )
            ],
          ),
          body: Container(
            color: colors[color],
            child: Column(
              children: <Widget>[
                ElevatedButton(
                  onPressed: () => _chooseDate(context),
                  child: Text(
                    note.date,
                    // "${_displayDate.toLocal()}".split(' ')[0],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontStyle: FontStyle.normal,
                        fontSize: 30.0,
                        color: Colors.white),
                  ),
                ),
                Container(
                  child: new Text(
                    '\nRank your accomplishment!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        // fontFamily: 'Roboto',
                        // fontStyle: FontStyle.normal,
                        // fontSize: 10.0,
                        color: Colors.black),
                  ),
                ),
                Slider(
                    value: note.priority.toDouble(),
                    min: 1,
                    max: 3,
                    divisions: 2,
                    label: labels[_priority.round() - 1],
                    onChanged: (double value) {
                      setState(() {
                        _priority = value;
                        updatePriority(_priority.round());
                      });
                    }),
                // PriorityPicker(
                //   selectedIndex: 3 - note.priority,
                //   onTap: (index) {
                //     isEdited = true;
                //     note.priority = 3 - index;
                //   },
                // ),
                // ColorPicker(
                //   selectedIndex: note.color,
                //   onTap: (index) {
                //     setState(() {
                //       color = index;
                //     });
                //     isEdited = true;
                //     note.color = index;
                //   },
                // ),
                // Padding(
                //   padding: EdgeInsets.all(16.0),
                //   child: TextField(
                //     controller: titleController,
                //     maxLength: 255,
                //     style: Theme.of(context).textTheme.body1,
                //     onChanged: (value) {
                //       updateTitle();
                //     },
                //     decoration: InputDecoration.collapsed(
                //       hintText: 'Title',
                //     ),
                //   ),
                // ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      maxLength: 255,
                      controller: titleController,
                      style: Theme.of(context).textTheme.body2,
                      onChanged: (value) {
                        updateTitle();
                      },
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 0.7),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 0.7),
                        ),
                        hintText: "What did you accomplish?",
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void showDiscardDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text(
            "Discard Changes?",
            style: Theme.of(context).textTheme.body1,
          ),
          content: Text("Are you sure you want to discard changes?",
              style: Theme.of(context).textTheme.body2),
          actions: <Widget>[
            FlatButton(
              child: Text("No",
                  style: Theme.of(context)
                      .textTheme
                      .body1
                      .copyWith(color: Colors.purple)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("Yes",
                  style: Theme.of(context)
                      .textTheme
                      .body1
                      .copyWith(color: Colors.purple)),
              onPressed: () {
                Navigator.of(context).pop();
                moveToLastScreen();
              },
            ),
          ],
        );
      },
    );
  }

  void showEmptyTitleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text(
            "Incomplete Accomplishment!",
            style: Theme.of(context).textTheme.body1,
          ),
          content: Text("Write a few words about what you've accomplished.",
              style: Theme.of(context).textTheme.body2),
          actions: <Widget>[
            FlatButton(
              child: Text("Okay",
                  style: Theme.of(context)
                      .textTheme
                      .body1
                      .copyWith(color: Colors.purple)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text(
            "Delete Entry?",
            style: Theme.of(context).textTheme.body1,
          ),
          content: Text("Are you sure you want to delete this entry?",
              style: Theme.of(context).textTheme.body2),
          actions: <Widget>[
            FlatButton(
              child: Text("No",
                  style: Theme.of(context)
                      .textTheme
                      .body1
                      .copyWith(color: Colors.purple)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("Yes",
                  style: Theme.of(context)
                      .textTheme
                      .body1
                      .copyWith(color: Colors.purple)),
              onPressed: () {
                Navigator.of(context).pop();
                _delete();
              },
            ),
          ],
        );
      },
    );
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  void updateTitle() {
    isEdited = true;
    note.title = titleController.text;
  }

  void updatePriority(value) {
    isEdited = true;
    note.priority = value;
  }

  // void updateDescription() {
  //   isEdited = true;
  //   note.description = descriptionController.text;
  // }

  void updateDate() {
    isEdited = true;
    note.date = DateFormat.yMMMd().format(_displayDate);
  }

  // Save data to database
  void _save() async {
    moveToLastScreen();

    // note.date = DateFormat.yMMMd().format(DateTime.now());
    //note.date = DateFormat.yMMMd().format(_displayDate);

    if (note.id != null) {
      await helper.updateNote(note);
    } else {
      await helper.insertNote(note);
    }
  }

  void _delete() async {
    await helper.deleteNote(note.id);
    moveToLastScreen();
  }
}
