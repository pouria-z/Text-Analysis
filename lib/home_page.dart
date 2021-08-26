import 'package:flutter/material.dart';
import 'package:sentiment_analysis/screens/key_phrases.dart';
import 'package:sentiment_analysis/screens/sentiment.dart';
import 'package:sentiment_analysis/screens/similarity.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    _controller = TabController(
      length: 3,
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: _controller,
        children: [
          Sentiment(),
          KeyPhrases(),
          Similarity(),
        ],
      ),
      bottomNavigationBar: Material(
        child: TabBar(
          controller: _controller,
          tabs: [
            Tab(
              text: "Sentiment",
            ),
            Tab(
              text: "Key Phrases",
            ),
            Tab(
              text: "Similarity",
            ),
          ],
        ),
      ),
    );
  }
}
