import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ListView',
      theme: ThemeData(
        primarySwatch: Colors.green,

        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'My App', storage: CounterStorage()),
    );
  }
}

class CounterStorage{
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

  Future<int> readCounter() async {
    try{
      final file = await _localFile;

      String contents = await file.readAsString();

      return int.parse(contents);
    }catch(e){
      return 0;
    }
  }

  Future<File> writeCounter(int counter) async {
    final file = await _localFile;

    return file.writeAsString('$counter');
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  final CounterStorage storage;

  MyHomePage({Key key, this.title, @required this.storage}) : super(key: key);



  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    widget.storage.readCounter().then((int value) {

      setState(() {
        _counter = value;
      });

    });
  }

  Future<File> _incrementCounter() {
    setState(() {

      _counter++;
    });
    
    return widget.storage.writeCounter(_counter);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: new ListView.builder(
        itemCount: _counter,
          itemBuilder: (context, index){
          return ListTile(
            leading: const Icon(FontAwesomeIcons.book),
            title: Text('Name of item'),
            onTap: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SecondPage())
              );
            },
          );
          }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Second Screen'),
      ),
      body: Center(
        child: RaisedButton.icon(
          onPressed: ()  {
            Navigator.pop(context);
          },
          label: Text('Go back!'),
          icon: Icon(FontAwesomeIcons.stepBackward),
        ),
      ),
    );
  }
}
