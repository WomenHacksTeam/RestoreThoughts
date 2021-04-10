import 'package:flutter/material.dart';
import 'DatabaseHelper.dart';
import 'Entry.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Journal',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Listify'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController textController = new TextEditingController();

  List<Entry> entryList = [];

  @override
  void initState() {
    super.initState();

    DatabaseHelper.instance.queryAllRows().then((value) {
      setState(() {
        value.forEach((element) {
          entryList.add(Entry(
              id: element['id'],
              date: element['date'],
              text: element['text'],
              score: element['score']));
        });
      });
    }).catchError((error) {
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        alignment: Alignment.topLeft,
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(hintText: "Enter an entry"),
                    controller: textController,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _addToDb,
                )
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                child: entryList.isEmpty
                    ? Container()
                    : ListView.builder(itemBuilder: (ctx, index) {
                        if (index == entryList.length) return null;
                        return ListTile(
                          title: Text(entryList[index].text),
                          subtitle: Text(entryList[index].date.toString()),
                          leading: Text(entryList[index].id.toString()),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _deleteEntry(entryList[index].id),
                          ),
                        );
                      }),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _deleteEntry(int id) async {
    await DatabaseHelper.instance.delete(id);
    setState(() {
      entryList.removeWhere((element) => element.id == id);
    });
  }

  void _addToDb() async {
    String textInput = textController.text;
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day);
    int score = 3;
    var id = await DatabaseHelper.instance
        .insert(Entry(text: textInput, date: date, score: score));
    setState(() {
      entryList.insert(
          0, Entry(id: id, text: textInput, date: date, score: score));
    });
  }
}
