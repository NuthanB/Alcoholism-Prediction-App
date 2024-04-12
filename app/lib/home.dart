import 'dart:convert';
import 'package:app/function.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'ResultsScreen.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String name = '';
  var data;
  String output = 'Report';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ECG Analysis'),
        backgroundColor: Color.fromARGB(255, 14, 125, 217),
      ),
      backgroundColor: Color.fromARGB(255, 199, 199, 5),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'animation/heart.json',
                height: 500,
                width: 500,
              ),
              TextField(
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Enter Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () async {
                  String url = 'http://172.27.116.181:5000/api?query=' + name;
                  data = await fetchdata(url);
                  var decoded = jsonDecode(data);
                  setState(() {
                    output = decoded['output'];
                  });

                  // Check if 'output' is a valid JSON
                  if (isJson(output)) {
                    // If it is a JSON string, decode it into a Map
                    Map<String, dynamic> resultMap = jsonDecode(output);

                    // Navigate to the ResultsScreen with the obtained result
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResultsScreen(result: resultMap),
                      ),
                    );
                  }
                },
                child: Text(
                  'Get Your Results',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to check if a string is a valid JSON
  bool isJson(String str) {
    try {
      jsonDecode(str);
      return true;
    } catch (_) {
      return false;
    }
  }
}
