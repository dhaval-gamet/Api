import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyMLApp());
}

class MyMLApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ML Prediction App',
      theme: ThemeData(primarySwatch: Colors.green),
      home: PredictionPage(),
    );
  }
}

class PredictionPage extends StatefulWidget {
  @override
  _PredictionPageState createState() => _PredictionPageState();
}

class _PredictionPageState extends State<PredictionPage> {
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();
  String _result = "";

  Future<void> _getPrediction() async {
    final url = Uri.parse("https://ml-larnig-model.onrender.com/predict");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "color": _colorController.text,
        "size": int.tryParse(_sizeController.text) ?? 0,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _result = "Prediction: ${data['prediction']}";
      });
    } else {
      setState(() {
        _result = "Error: ${response.body}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ML Prediction App")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _colorController,
              decoration: InputDecoration(labelText: 'Color (e.g., हरा)'),
            ),
            TextField(
              controller: _sizeController,
              decoration: InputDecoration(labelText: 'Size (number)'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getPrediction,
              child: Text("Get Prediction"),
            ),
            SizedBox(height: 20),
            Text(
              _result,
              style: TextStyle(fontSize: 18, color: Colors.blue),
            )
          ],
        ),
      ),
    );
  }
}
