import 'package:flutter/material.dart';

// void main() {
//   runApp(MaterialApp(title: '导航演示1', home: new FirstScreen()));
// }

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: '导航演示1',
        home: ProductList(
          products:
              List.generate(20, (i) => Product('商品 $i', '这是一个商品详情，编号为:$i')),
        ));
  }
}

class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(title: Text('导航页面')),
        body: Center(
            child: RaisedButton(
          child: Text('查看商品详情页面'),
          onPressed: () {
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => new SecondScreen()));
          },
        )));
  }
}

class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('技术胖商品详情页')),
        body: Center(
            child: RaisedButton(
                child: RaisedButton(
          child: Text('返回'),
          onPressed: () {
            Navigator.pop(context);
          },
        ))));
  }
}

class Product {
  final String title; //商品标题
  final String description; //商品描述
  Product(this.title, this.description);
}

class ProductList extends StatelessWidget {
  final List<Product> products;
  ProductList({Key key, @required this.products}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('商品列表')),
        body: ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            return ListTile(
                title: Text(products[index].title),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              new ProductDetail(product: products[index])));
                });
          },
        ));
  }
}

class ProductDetail extends StatelessWidget {
  final Product product;
  ProductDetail({Key key, @required this.product}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text('${product.title}'),
        ),
        body: Center(
          child: Text('${product.description}'),
        ));
  }
}
