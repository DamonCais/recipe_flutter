import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import './detail.dart';

Dio dio = new Dio();

class Recipe extends StatefulWidget {
  Recipe({Key key}) : super(key: key);
  _RecipeState createState() => _RecipeState();
}

class _RecipeState extends State<Recipe> with SingleTickerProviderStateMixin {
  TabController _tabController;
  final List<String> myTabs = ['hot', 'new'];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = new TabController(vsync: this, length: myTabs.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TabBar(
          controller: _tabController,
          tabs: [
            new Tab(text: 'hot'),
            new Tab(text: 'new'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          new RecipeList(type: 'hot'),
          new RecipeList(type: 'new'),
        ],
      ),
    );
  }
}

class RecipeList extends StatefulWidget {
  RecipeList({Key key, this.type}) : super(key: key);
  final String type;
  _RecipeListState createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList>
    with AutomaticKeepAliveClientMixin {
  bool get wantKeepAlive => true;
  int page = 1;
  var recipeList = [];
  ScrollController _scrollCtrl;
  TabController _tabController;
  getRecipeList(orderby) async {
    if (!mounted) return; //异步处理，防止报错
    print('get ${page}');
    var res = await dio.get(
        'https://www.jycais.cn/getMoreDiffStateRecipeList?classid=0&orderby=${orderby}&page=${page}');
    // print(res.data);
    setState(() {
      recipeList.addAll(res.data['data']);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRecipeList(widget.type);
    _scrollCtrl = new ScrollController();
    _scrollCtrl.addListener(() {
      if (_scrollCtrl.position.pixels == _scrollCtrl.position.maxScrollExtent) {
        setState(() {
          page++;
        });
        // 获取新页面的数据
        getRecipeList(widget.type);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _recipeList(widget.type);
  }

  Widget _recipeList(type) {
    return ListView.builder(
      controller: _scrollCtrl,
      itemCount: recipeList.length,
      itemBuilder: (BuildContext ctx, int i) {
        var recipe = recipeList[i];
        return GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext ctx) {
              return new RecipeDetail(recipeId: recipe['id']);
            }));
          },
          child: _recipeRow(recipe),
        );
      },
    );
  }

  Widget _recipeRow(recipe) {
    return Container(
      decoration:
          BoxDecoration(border: Border(top: BorderSide(color: Colors.black))),
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
            child: Image.network(
              recipe['cover'],
              height: 80,
              width: 80,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
                height: 100,
                padding: EdgeInsets.only(left: 20),
                child: Column(
                  children: <Widget>[
                    Text(recipe['title']),
                    Text(
                      "原料:${recipe['mainingredient']}",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                )),
          )
        ],
      ),
    );
  }
}
