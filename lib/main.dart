import 'package:flutter/material.dart';
import 'package:sentiment_analysis/home_page.dart';



void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Sentiment Analyst',
    theme: ThemeData.dark(),
    home: HomePage(),
  ));
}
