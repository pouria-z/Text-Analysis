import 'package:flutter/material.dart';
import 'package:sentiment_analysis/api_key.dart';
import 'package:sentiment_analysis/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Sentiment extends StatefulWidget {
  const Sentiment({Key? key}) : super(key: key);

  @override
  _SentimentState createState() => _SentimentState();
}

class _SentimentState extends State<Sentiment> {
  TextEditingController _controller = TextEditingController();
  var inputText;
  double pos = 0.0;
  double neg = 0.0;
  bool isLoading = false;
  bool isEnable = false;
  var input;

  Future postData() async {
    setState(() {
      isLoading = true;
      inputText = null;
      pos = 0.0;
      neg = 0.0;
    });
    var url = Uri.parse(
      'https://webit-text-analytics.p.rapidapi.com/sentiment',
    );
    var response = await http.post(url, body: {
      'text': '${_controller.text.trim()}',
      'language': 'en',
    }, headers: {
      'x-rapidapi-key': '$apiKey',
      'x-rapidapi-host': 'webit-text-analytics.p.rapidapi.com'
    });
    var json = jsonDecode(response.body);
    setState(() {
      inputText = json['data']['input_text'];
      pos = json['data']['sentiment']['positive'];
      neg = json['data']['sentiment']['negative'];
    });
    print("your text: $inputText, positive: $pos and negative: $neg");
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sentiment Analyst"),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  input = value;
                });
              },
              controller: _controller,
              decoration: decoration,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.newline,
              maxLines: 50,
              minLines: 1,
            ),
            TextButton(
              child: Text(
                "GO",
                style: TextStyle(
                    color: _controller.text.trim().isEmpty
                        ? Colors.grey[700]
                        : Colors.white),
              ),
              onPressed: () async {
                if (_controller.text.trim().isEmpty) {
                  return null;
                } else {
                  FocusScope.of(context).unfocus();
                  await postData().whenComplete(() => _controller.clear());
                }
              },
            ),
            inputText == null && isLoading == false
                ? Container()
                : inputText == null && isLoading == true
                    ? Center(
                        child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 1.2,
                      ))
                    : Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: pos > neg
                                ? Colors.green[700]
                                : Colors.red[700]),
                        child: Center(
                            child: Text(
                          inputText,
                          style: TextStyle(color: Colors.white, fontSize: 22),
                        )),
                      ),
            SizedBox(
              height: 20,
            ),
            pos == 0.0
                ? Container()
                : TextBox(
                    value: pos,
                    otherValue: neg,
                    color: Colors.green,
                    title: 'Positive'),
            pos == 0.0
                ? Container()
                : TextBox(
                    value: neg,
                    otherValue: pos,
                    color: Colors.red,
                    title: 'Negative',
                  ),
          ],
        ),
      ),
    );
  }
}

class TextBox extends StatelessWidget {
  const TextBox({
    Key? key,
    required this.value,
    required this.otherValue,
    required this.color,
    required this.title,
  }) : super(key: key);

  final double value;
  final double otherValue;
  final Color color;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      "$title: ${value.toStringAsFixed(6)}",
      style: TextStyle(
          color: value > otherValue ? color : Colors.white, fontSize: 18),
    );
  }
}
