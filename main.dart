import 'package:flutter/material.dart';
import 'dart:core';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

final Uri _apiurl1 = Uri.parse(
    'https://newsapi.org/v2/everything?q=tesla&from=2023-07-02&sortBy=publishedAt&apiKey=9a79de5801fa4c4795d425521cdc1c2f');

final Uri _apiurl2 = Uri.parse(
    "https://newsapi.org/v2/everything?q=apple&from=2023-08-01&to=2023-08-01&sortBy=popularity&apiKey=9a79de5801fa4c4795d425521cdc1c2f");

List<dynamic>? _provider1;
List<dynamic>? _provider2;
List<dynamic> _provider = [];

String _headlines = "Tesla News";

var now = new DateTime.now();
var formatter = new DateFormat('yyyy-MM-dd');
String currentDate = formatter.format(now);
void main() async {
  _provider1 = await fetchData(_apiurl1);
  _provider2 = await fetchData(_apiurl2);
  if (_provider1 != null) {
    _provider = _provider1!;
  }

  runApp(MaterialApp(
    home: Home(),
    debugShowCheckedModeBanner: false,
  ));
}

class Home extends StatefulWidget {
  const Home({Key? key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            "images12/background.jpg",
            fit: BoxFit.cover,
          ),
          Scaffold(
            drawer: Drawer(
              child: ListView(
                children: <Widget>[
                  DrawerHeader(
                    child: Text(
                      "CHOOSE A NEWS PROVIDER!",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Times New Roman',
                          fontSize: 18.0),
                    ),
                    decoration: BoxDecoration(color: Colors.blue),
                  ),
                  ListTile(
                    title: Text(
                      "Tesla News",
                      style: TextStyle(
                        fontFamily: 'Times New Roman',
                        fontSize: 18.0,
                      ),
                    ),
                    subtitle: Text(
                      "News articles mentioning Tesla",
                      style: TextStyle(
                        fontFamily: 'Times New Roman',
                        fontSize: 16.0,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    onTap: () {
                      if (_provider1 != null) {
                        setState(() {
                          _provider = _provider1!;
                          _headlines = "Tesla News";
                        });
                      }
                    },
                  ),
                  ListTile(
                      title: Text(
                        "Apple News",
                        style: TextStyle(
                          fontFamily: 'Times New Roman',
                          fontSize: 18.0,
                        ),
                      ),
                      subtitle: Text(
                        "News articles mentioning Apple",
                        style: TextStyle(
                          fontFamily: 'Times New Roman',
                          fontSize: 16.0,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      onTap: () {
                        if (_provider2 != null) {
                          setState(() {
                            _provider = _provider2!;
                            _headlines = "Apple News";
                          });
                        }
                      }),
                ],
              ),
            ),
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                "${_headlines.toUpperCase()}",
                style: TextStyle(
                    fontFamily: 'Times New Roman',
                    fontSize: 25,
                    color: Colors.white),
              ),
              elevation: 3.0,
              backgroundColor: Colors.grey.withOpacity(0.3),
            ),
            backgroundColor: Colors.transparent,
            body: Center(
              child: ListView.builder(
                padding: const EdgeInsets.all(12.0),
                itemCount: _provider.length,
                itemBuilder: (BuildContext context, int position) {
                  return Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          title: CachedNetworkImage(
                            imageUrl: "${_provider[position]['urlToImage']}",
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                          subtitle: Text(
                            "${_provider[position]['title']}",
                            style: TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Times New Roman',
                              color: Colors.black,
                            ),
                          ),
                          onTap: () => _showNewsSnippet(
                              context, _provider[position]['description']),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<List<dynamic>?> fetchData(Uri apiUrl) async {
  http.Response response = await http.get(apiUrl);
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return data['articles'] as List<dynamic>;
  } else {
    // Handle error case
    print('Request failed with status: ${response.statusCode}');
    return null;
  }
}

void _showNewsSnippet(BuildContext context, String snippet) {
  var alert = AlertDialog(
    title: Text(
      "Headlines",
      style: TextStyle(
        fontSize: 16.0,
        fontFamily: 'Times New Roman',
        fontWeight: FontWeight.w500,
      ),
    ),
    content: Text(snippet),
    actions: [
      ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            "Dismiss",
            style: TextStyle(
                fontSize: 16.0,
                fontFamily: 'Times New Roman',
                fontStyle: FontStyle.italic),
          ))
    ],
  );
  showDialog(context: context, builder: (context) => alert);
}
