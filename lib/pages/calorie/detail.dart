import 'package:flutter/material.dart';

class CalorieDetail extends StatefulWidget {
  CalorieDetail({Key key, this.calorieId}) : super(key: key);
  final calorieId;
  _CalorieDetailState createState() => _CalorieDetailState();
}

class _CalorieDetailState extends State<CalorieDetail> {
  @override
  Widget build(BuildContext context) {
    return Text(widget.calorieId);
  }
}
