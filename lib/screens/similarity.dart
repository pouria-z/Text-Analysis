import 'package:flutter/material.dart';
import 'package:sentiment_analysis/widgets.dart';
import 'package:sentiment_analysis/api_key.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Similarity extends StatefulWidget {
  const Similarity({Key? key}) : super(key: key);

  @override
  _SimilarityState createState() => _SimilarityState();
}

class _SimilarityState extends State<Similarity> {
  TextEditingController _controller2 = TextEditingController();
  TextEditingController _controller1 = TextEditingController();
  bool isLoading = false;
  bool showText = false;
  var input2;
  var input1;
  var string1;
  var string2;
  double similarity = 0.0;

  Future postData() async {
    setState(() {
      isLoading = true;
      showText = true;
    });
    var url = Uri.parse(
      'https://webit-text-analytics.p.rapidapi.com/similarity',
    );
    var response = await http.post(url, body: {
      'string1': '$string1',
      'string2': '$string2',
    }, headers: {
      'x-rapidapi-key': '$apiKey',
      'x-rapidapi-host': 'webit-text-analytics.p.rapidapi.com'
    });
    var json = jsonDecode(response.body)['data'];
    setState(() {
      similarity = json['similarity'];
    });

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Similarity Analyst"),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  input1 = value;
                  showText = false;
                  similarity = 0.0;
                });
              },
              controller: _controller1,
              decoration: decoration.copyWith(
                  hintText: 'Enter Sentence 1', labelText: 'Sentence 1'),
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.newline,
              maxLines: 50,
              minLines: 1,
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              onChanged: (value) {
                setState(() {
                  input2 = value;
                  showText = false;
                  similarity = 0.0;
                });
              },
              controller: _controller2,
              decoration: decoration.copyWith(
                  hintText: 'Enter Sentence 2', labelText: 'Sentence 2'),
              textInputAction: TextInputAction.next,
            ),
            TextButton(
              child: Text(
                "GO",
                style: TextStyle(
                    color: _controller2.text.trim().isEmpty ||
                            _controller1.text.isEmpty
                        ? Colors.grey[700]
                        : Colors.white),
              ),
              onPressed: () async {
                if (_controller2.text.trim().isEmpty ||
                    _controller1.text.isEmpty) {
                  return null;
                } else {
                  setState(() {
                    FocusScope.of(context).unfocus();
                    string1 = _controller1.text.trim();
                    string2 = _controller2.text.trim();
                  });
                  await postData().whenComplete(() {
                    _controller1.clear();
                    _controller2.clear();
                  });
                }
              },
            ),
            showText == false
                ? Container()
                : Text("Sentence 1: \n\t\t$string1\n",
                    style: TextStyle(fontSize: 18)),
            showText == false
                ? Container()
                : Text("Sentence 2: \n\t\t$string2\n",
                    style: TextStyle(fontSize: 18)),
            SizedBox(
              height: 20,
            ),
            showText == true && isLoading == true
                ? Center(
                    child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 1.2,
                  ))
                : similarity == 0.0
                    ? Container()
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          return ListTile(
                              title: RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                  text: "Similarity: ",
                                  style: TextStyle(
                                    fontSize: 20,
                                  )),
                              TextSpan(
                                  text:
                                      "${similarity.toStringAsFixed(4).toString()}",
                                  style: TextStyle(
                                      fontSize: 20,
                                      decoration: TextDecoration.underline))
                            ]),
                          ));
                        },
                      )
          ],
        ),
      ),
    );
  }
}
