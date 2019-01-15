import 'package:flutter/material.dart';

class RecipeDetail extends StatefulWidget {
  RecipeDetail({Key key, this.recipeId}) : super(key: key);
  final recipeId;
  _RecipeDetailState createState() => _RecipeDetailState();
}

class _RecipeDetailState extends State<RecipeDetail> {
  @override
  Widget build(BuildContext context) {
    return Text(widget.recipeId);
  }
}

