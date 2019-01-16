import 'package:flutter/material.dart';
import './recipe/recipe.dart';
import './calorie/calorie.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          // appBar: AppBar(
          //   title: Text('列表'),
          //   centerTitle: true,
          //   actions: [],
          // ),
          body: TabBarView(
            children: <Widget>[
              new Recipe(title: '食谱'),
              new Calorie(title: '热量'),
              Text('ccc'),
            ],
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(color: Colors.black),
            // 设置 tabbar 的高度
            height: 50,
            child: TabBar(
              tabs: <Widget>[
                Tab(text: '食谱'),
                Tab(text: '热量'),
                Tab(text: '我的'),
              ],
            ),
          )),
    );
  }
}
