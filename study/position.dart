import 'package:flutter/material.dart';

void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     var stack = new Stack(
//       alignment: const FractionalOffset(0, 0.9),
//       children: <Widget>[
//         new CircleAvatar(
//           backgroundImage: new NetworkImage(
//               'http://jspang.com/static//myimg/blogtouxiang.jpg'),
//           radius: 100.0,
//         ),
//         new Container(
//           decoration: new BoxDecoration(
//             color: Colors.lightBlue,
//           ),
//           padding: EdgeInsets.all(5.0),
//           child: new Text('JSPang 技术胖'),
//         )
//       ],
//     );
//     return MaterialApp(
//       title: 'ListView widget',
//       home: Scaffold(
//         appBar: new AppBar(
//           title: new Text('垂直方向布局'),
//         ),
//         body: Center(child: stack),
//       ),
//     );
//   }
// }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var stack = new Stack(
      children: <Widget>[
        new CircleAvatar(
          backgroundImage: new NetworkImage(
              'http://jspang.com/static//myimg/blogtouxiang.jpg'),
          radius: 100.0,
        ),
        new Positioned(
          top: 10.0,
          left: 10.0,
          child: new Text('JSPang.com'),
        ),
        new Positioned(
          bottom: 5,
          right: 0.0,
          child: new Text('技术胖'),
        )
      ],
    );
    return MaterialApp(
      title: 'ListView widget',
      home: Scaffold(
        appBar: new AppBar(
          title: new Text('层叠布局'),
        ),
        body: Center(child: stack),
      ),
    );
  }
}
