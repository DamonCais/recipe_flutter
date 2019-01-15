import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import './detail.dart';

Dio dio = new Dio();

class Recipe extends StatefulWidget {
  Recipe({Key key}) : super(key: key);
  _RecipeState createState() => _RecipeState();
}

class _RecipeState extends State<Recipe> {
  int page = 1;
  var orderby = 'hot';
  var recipeList = [];
  var total = 0;
  ScrollController _scrollCtrl;

  getRecipeList() async {
    var res = await dio.get(
        'https://www.jycais.cn/getMoreDiffStateRecipeList?classid=0&orderby=hot&page=${page}');
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
