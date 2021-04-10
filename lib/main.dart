import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Journal Entries',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Journal'
          ''),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);


  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
 // _JournalEntryState createState() => _JournalEntryState();

}

class _MyHomePageState extends State<MyHomePage> {
  double _rank = 1;
  DateTime _displayDate = DateTime.now();
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

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
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(

        child:new Column(

          children:[


               new ElevatedButton(
               onPressed:() => _chooseDate(context),

               child:Text(
                "${_displayDate.toLocal()}".split(' ')[0],
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Roboto',
                    fontStyle: FontStyle.normal,
                    fontSize: 30.0,
                    color: Colors.black
                ),
              ),
            ),
        new TextFormField(
          //mainAxisAlignment: MainAxisAlignment.center,
          //children: <Widget>[
          keyboardType: TextInputType.multiline,
          minLines: 5,//Normal textInputField will be displayed
          maxLines: 5,
          controller: _controller,
            decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'What is something you are proud of?',
          //],
        ),
      ),
            new Container(
              child: new Text('Rank your accomplishment!',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Roboto',
                    fontStyle: FontStyle.normal,
                    fontSize: 30.0,
                    color: Colors.black
                ),
              ),
            ),
            new Slider(value: _rank,
                min: 1,
                max: 5,
                divisions: 5,
                label: _rank.round().toString(),
                onChanged: (double value){
                  setState(() {
                    _rank = value;
                  });
                }
                 ),
            new ElevatedButton(

              child:Text(
                "Save",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Roboto',
                    fontStyle: FontStyle.normal,
                    fontSize: 30.0,
                    color: Colors.black
                ),
              ),
            ),
      ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
