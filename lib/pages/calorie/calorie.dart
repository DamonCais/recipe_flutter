import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import './detail.dart';

Dio dio = new Dio();

class Calorie extends StatefulWidget {
  Calorie({Key key, this.title}) : super(key: key);
  final title;
  _CalorieState createState() => _CalorieState();
}

class CalorieTab {
  String text;
  CalorieList calorieList;
  CalorieTab(this.text, this.calorieList);
}

class _CalorieState extends State<Calorie> with SingleTickerProviderStateMixin {
  TabController _tabController;
  final List<CalorieTab> myTabs = [
    new CalorieTab('谷薯芋、杂豆、主食', new CalorieList(list: 1)),
    new CalorieTab('蛋类、肉类及制品', new CalorieList(list: 2)),
    new CalorieTab('奶类及制品', new CalorieList(list: 3)),
    new CalorieTab('蔬果和菌藻', new CalorieList(list: 4)),
    new CalorieTab('坚果、大豆及制品', new CalorieList(list: 5)),
    new CalorieTab('饮料', new CalorieList(list: 6)),
    new CalorieTab('食用油、油脂及制品', new CalorieList(list: 7)),
    new CalorieTab('调味品', new CalorieList(list: 8)),
    new CalorieTab('零食、点心、冷饮', new CalorieList(list: 9)),
    new CalorieTab('其它', new CalorieList(list: 10)),
    new CalorieTab('菜肴', new CalorieList(list: 132)),
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
            return item.calorieList;
          }).toList(),
        ),
      ),
    );
  }
}

class CalorieList extends StatefulWidget {
  CalorieList({Key key, this.list}) : super(key: key);
  final list;
  _CalorieListState createState() => _CalorieListState();
}

class _CalorieListState extends State<CalorieList>
    with AutomaticKeepAliveClientMixin {
  bool get wantKeepAlive => true;
  int page = 1;
  var calorieList = [];
  ScrollController _scrollCtrl;
  TabController _tabController;
  getCalorieList() async {
    if (!mounted) return; //异步处理，防止报错
    print('get ${page}');
    var res = await dio.get(
        'https://www.jycais.cn/getCalorie?list=${widget.list}&page=${page}');
    // print(res.data);
    setState(() {
      calorieList.addAll(res.data);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCalorieList();
    _scrollCtrl = new ScrollController();
    _scrollCtrl.addListener(() {
      if (_scrollCtrl.position.pixels == _scrollCtrl.position.maxScrollExtent) {
        setState(() {
          page++;
        });
        // 获取新页面的数据
        getCalorieList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _calorieList();
  }

  Widget _calorieList() {
    return ListView.builder(
      controller: _scrollCtrl,
      itemCount: calorieList.length,
      itemBuilder: (BuildContext ctx, int i) {
        var calorie = calorieList[i];
        return GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext ctx) {
              return new CalorieDetail(calorieId: calorie['id']);
            }));
          },
          child: _calorieRow(calorie),
        );
      },
    );
  }

  Widget _calorieRow(calorie) {
    return Container(
      decoration:
          BoxDecoration(border: Border(top: BorderSide(color: Colors.black))),
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
            child: Image.network(
              calorie['img'],
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
                    Text(calorie['title']),
                    Text(
                      ":${calorie['calorie']}",
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
