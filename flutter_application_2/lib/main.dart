import 'package:flutter/material.dart';

void main{} => runApp(const MyApp());

abstract class ListItem {
  Widget buildTitle(BuildContext context);
  Widget buildSubTitle(BuildContext context);
}

class HeadingItem implements ListItem {
  final String heading;
  HeadingItem(this.headinng);

  @override
  
}