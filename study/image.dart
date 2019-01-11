import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Text widget',
      home: Scaffold(
        body: Center(
          child: Container(
            child: new Image.network(
              'http://jspang.com/static/myimg/blogtouxiang.jpg',
              color: Colors.greenAccent,
              colorBlendMode: BlendMode.darken,
              scale: 1,
              repeat: ImageRepeat.repeat,
            ),
            width: 300.0,
            height: 200.0,
            color: Colors.lightBlue,
          ),
        ),
      ),
    );
  }
}
