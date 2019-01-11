import 'package:flutter/material.dart';

import './TopTabPages/TopTabPage_1.dart';
import './TopTabPages/TopTabPage_2.dart';
import './TopTabPages/TopTabPage_3.dart';
class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}


//用于使用到了一点点的动画效果，因此加入了SingleTickerProviderStateMixin
class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{

// 定义底部导航
final List<Tab> _bottomTabs = <Tab>[
  new Tab(text:'Home',icon:new Icon(Icons.home)),
  new Tab(text:'Book',icon:new Icon(Icons.book)),
  new Tab(text:'Me',icon:new Icon(Icons.info)),
];
  //定义底部导航Tab
  TabController _bottomNavigation;
  @override
  void initState(){
    super.initState();
    _bottomNavigation  = new TabController(
      vsync: this,
      length: _bottomNavigation.length
    );
  }

  //当整个页面dispose时，记得把控制器也dispose掉，释放内存
  @override
  void dispose() {
    _bottomNavigation.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.deepOrange,
        title:new Text('title'),
      ),
      body: new TabBarView(
        controller: _bottomNavigation,
        children: <Widget>[
          new TabPage1(),
          new TabPage2(),
          new TabPage3(),
        ],
      ),
      bottomNavigationBar: new Material(
        color:Colors.deepOrange,
        child: new TabBar(
          controller: _bottomNavigation,
          tabs:_bottomTabs,
          indicatorColor: Colors.white,
        
        ),
      ),
    );
  }
}