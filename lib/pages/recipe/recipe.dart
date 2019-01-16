import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import './detail.dart';

Dio dio = new Dio();

class Recipe extends StatefulWidget {
  Recipe({Key key, this.title}) : super(key: key);
  final title;
  _RecipeState createState() => _RecipeState();
}

class RecipeTab {
  String text;
  RecipeList recipeList;
  RecipeTab(this.text, this.recipeList);
}

class _RecipeState extends State<Recipe> with SingleTickerProviderStateMixin {
  TabController _tabController;
  final List<RecipeTab> myTabs = [
    new RecipeTab('最新推荐', new RecipeList(orderby: 'hot', classid: 0)),
    new RecipeTab('最新发布', new RecipeList(orderby: 'new', classid: 0)),
    new RecipeTab('热菜', new RecipeList(orderby: 'tag', classid: 102)),
    new RecipeTab('凉菜', new RecipeList(orderby: 'tag', classid: 202)),
    new RecipeTab('汤羹', new RecipeList(orderby: 'tag', classid: 57)),
    new RecipeTab('主食', new RecipeList(orderby: 'tag', classid: 59)),
    new RecipeTab('小吃', new RecipeList(orderby: 'tag', classid: 62)),
    new RecipeTab('西餐', new RecipeList(orderby: 'tag', classid: 160)),
    new RecipeTab('烘焙', new RecipeList(orderby: 'tag', classid: 60)),
    new RecipeTab('自制食材', new RecipeList(orderby: 'tag', classid: 69)),
  ];
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
        title: Text(widget.title ?? '列表'),
        centerTitle: true,
      ),
      body: Scaffold(
        appBar: AppBar(
          title: TabBar(
            controller: _tabController,
            tabs: myTabs.map((item) {
              return new Tab(text: item.text);
            }).toList(),
            isScrollable:
                true, //水平滚动的开关，开启后Tab标签可自适应宽度并可横向拉动，关闭后每个Tab自动压缩为总长符合屏幕宽度的等宽，默认关闭
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: myTabs.map((item) {
            return item.recipeList;
          }).toList(),
        ),
      ),
    );
  }
}

class RecipeList extends StatefulWidget {
  RecipeList({Key key, this.orderby, this.classid}) : super(key: key);
  final String orderby;
  final classid;
  _RecipeListState createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList>
    with AutomaticKeepAliveClientMixin {
  bool get wantKeepAlive => true;
  int page = 1;
  var recipeList = [];
  ScrollController _scrollCtrl;
  TabController _tabController;
  getRecipeList() async {
    if (!mounted) return; //异步处理，防止报错
    print('get ${page}');
    var res = await dio.get(
        'https://www.jycais.cn/getMoreDiffStateRecipeList?classid=${widget.classid}&orderby=${widget.orderby}&page=${page}');
    // print(res.data);
    setState(() {
      recipeList.addAll(res.data['data']);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRecipeList();
    _scrollCtrl = new ScrollController();
    _scrollCtrl.addListener(() {
      if (_scrollCtrl.position.pixels == _scrollCtrl.position.maxScrollExtent) {
        setState(() {
          page++;
        });
        // 获取新页面的数据
        getRecipeList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _recipeList();
  }

  Widget _recipeList() {
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
