import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ListView widget',
      home: Scaffold(
          appBar: new AppBar(
            title: new Text('垂直方向布局'),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('I am JSPang'),
              Text('my website is jspang.com'),
              Text('I love coding')
            ],
          )),
    );
  }
}

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'ListView widget',
//       home: Scaffold(
//           appBar: new AppBar(
//             title: new Text('垂直方向布局'),
//           ),
//           body: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Center(child: Text('I am JSPang')),
//               Expanded(child: Center(child: Text('my website is jspang.com'))),
//               Center(child: Text('I love coding'))
//             ],
//           )),
//     );
//   }
// }
