import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'dart:async';
// import 'dart:io';
import 'package:dio/dio.dart';

class TabPage1 extends StatefulWidget {
  const TabPage1({Key key, this.data}) : super(key: key);
  final String data;
  _TabPage1State createState() => _TabPage1State();
}

//定义TAB页对象，这样做的好处就是，可以灵活定义每个tab页用到的对象，可结合Iterable对象使用，以后讲
class RecipeTab {
  String text;
  RecipeList recipeList;
  RecipeTab(this.text, this.recipeList);
}

class _TabPage1State extends State<TabPage1>
    with SingleTickerProviderStateMixin {
  final List<RecipeTab> myTabs = <RecipeTab>[
    new RecipeTab('text', new RecipeList(recipeType: 'hot')),
    new RecipeTab('text', new RecipeList(recipeType: 'new'))
  ];
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: myTabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
            backgroundColor: Colors.deepOrange,
            title: new TabBar(
              controller: _tabController,
              tabs: myTabs.map((item) {
                return new Tab(text: item.text ?? '错误');
              }).toList(),
              indicatorColor: Colors.white,
              isScrollable: true,
            )),
        body: new TabBarView(
          controller: _tabController,
          children: myTabs.map((item) {
            return item.recipeList;
          }).toList(),
        ));
  }
}

class RecipeList extends StatefulWidget {
  final String recipeType;
  RecipeList({Key key, this.recipeType}) : super(key: key);

  _RecipeListState createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  final String _url = 'https://www.jycais.cn';
  List data;
// https://www.jycais.cn/getMoreDiffStateRecipeList?classid=0&orderby=hot&page=1
  Future<Map> get(String recipeType) async {
    Dio dio = new Dio();
    Response response = await dio.get(
        '${_url}/getMoreDiffStateRecipeList?classid=0&orderby=${recipeType}&page=1');
    print(response.data);
    return response.data['data'];
  }

  Future<Null> loadData() async {
    await get(widget.recipeType); //注意await关键字
    if (!mounted) return; //异步处理，防止报错
    setState(() {}); //什么都不做，只为触发RefreshIndicator的子控件刷新
  }

  @override
  Widget build(BuildContext context) {
    return new RefreshIndicator(
      child: new FutureBuilder(
        future: get(widget.recipeType),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return new Center(
                  child: new Card(
                child: new Text('loading...'),
              ));
            default:
              if (snapshot.hasError) {
                return new Text('Error:${snapshot.error}');
              } else {
                return createListView(context, snapshot);
              }
          }
        },
      ),
      onRefresh: loadData,
    );
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    List values;
    values = jsonDecode(snapshot.data)['data'];
    return new ListView.builder(
        itemCount: values.length,
        itemBuilder: (context, i) {
          return _recipeRow(values[i]);
        });
  }

  Widget _recipeRow(info) {
    return new Card(
        child: new Row(
      children: <Widget>[
        new Expanded(child: new Image.network('src')),
        new Expanded(
          child: new Column(
            children: <Widget>[
              new Text(''),
              new Text(''),
            ],
          ),
        ),
      ],
    ));
  }
}
