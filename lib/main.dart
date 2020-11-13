import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_movie/pages/search.dart';

void main() {

  runApp(MyApp());
}

class MyApp extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: SearchPage()
    ,);
  }
}