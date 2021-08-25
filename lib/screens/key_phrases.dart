import 'package:flutter/material.dart';
import 'package:sentiment_analysis/api_key.dart';
import 'package:sentiment_analysis/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class KeyPhrases extends StatefulWidget {
  const KeyPhrases({Key? key}) : super(key: key);

  @override
  _KeyPhrasesState createState() => _KeyPhrasesState();
}

class _KeyPhrasesState extends State<KeyPhrases> {
  late TextEditingController _controller = TextEditingController();
  bool isLoading = false;
  bool showText = false;
  var keyPhrase;
  List keyPhraseList = [];
  var input;

  Future postData() async {
    setState(() {
      isLoading = true;
      showText = true;
      keyPhraseList.clear();
    });
    var url = Uri.parse(
      'https://webit-text-analytics.p.rapidapi.com/key-phrases',
    );
    var response = await http.post(url, body: {
      'text': '${_controller.text.trim()}',
      'language': 'en',
    }, headers: {
      'x-rapidapi-key': '$apiKey',
      'x-rapidapi-host': 'webit-text-analytics.p.rapidapi.com'
    });
    var json = jsonDecode(response.body)['data']['key_phrases'];
    for (var i in json) {
      setState(() {
        keyPhrase = i;
        keyPhraseList.add(keyPhrase);
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Key Phrases Analyst"),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  input = value;
                  showText = false;
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
                  await postData().whenComplete(() => _controller.clear());
                }
              },
            ),
            isLoading == true
                ? Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 1.2,
                    ),
                  )
                : Container(),
            keyPhraseList.isEmpty
                ? Container()
                : Text("There are ${keyPhraseList.length} keyword[s]:",
                    style: TextStyle(fontSize: 18)),
            ListView.builder(
              shrinkWrap: true,
              itemCount: keyPhraseList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(keyPhraseList[index].toString(),
                      style: TextStyle(fontSize: 20)),
                  leading: Text((index + 1).toString(),
                      style: TextStyle(fontSize: 20)),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
