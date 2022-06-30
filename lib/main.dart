import 'dart:math';

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Name Generator",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          appBarTheme: AppBarTheme(
              backgroundColor: Colors.white, foregroundColor: Colors.black)),
      home: RandomWords(),
    );
  }
}

// stateFULL widget
class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);

  @override
  State<RandomWords> createState() => _RandomWordsState();
}

// STATE object  class
class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = <WordPair>{};
  final _biggerfont = const TextStyle(fontSize: 25);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Name Generator"),
        actions: [
          IconButton(
            onPressed: _pushSaved,
            icon: Icon(Icons.list),
            tooltip: "Saved Suggestion",
          ),
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider();
          final index = i ~/ 2;
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }
          final alreadySaved = _saved.contains(_suggestions[index]);
          return ListTile(
            title: Text(
              _suggestions[index].asSnakeCase,
              style: _biggerfont,
            ),
            trailing: Icon(
              alreadySaved ? Icons.favorite : Icons.favorite_border,
              // color: alreadySaved ? Colors.red : Colors.black,
              color: alreadySaved ? Colors.red : Colors.black,
              semanticLabel: alreadySaved ? "Remove from saved" : "Save",
            ),
            onTap: () {
              setState(
                () {
                  if (alreadySaved) {
                    _saved.remove(_suggestions[index]);
                  } else {
                    _saved.add(_suggestions[index]);
                  }
                },
              );
            },
          );
        },
      ),
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          final tiles = _saved.map(
            (pair) {
              return ListTile(
                title: Text(
                  pair.asSnakeCase,
                  style: _biggerfont,
                ),
              );
            },
          );
          final divided = tiles.isNotEmpty
              ? ListTile.divideTiles(
                  context: context,
                  tiles: tiles,
                ).toList()
              : <Widget>[];

          return Scaffold(
            appBar: AppBar(
              title: const Text('Saved Suggestions'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }
}
