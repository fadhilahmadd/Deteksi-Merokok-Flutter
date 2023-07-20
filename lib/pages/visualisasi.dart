import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ChartWidget extends StatefulWidget {
  @override
  _ChartWidgetState createState() => _ChartWidgetState();
}

class _ChartWidgetState extends State<ChartWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      backgroundColor: Color.fromARGB(255, 42, 21, 46),
        title: Text('Visualisasi', style: TextStyle(color: Colors.white),),
      ),
      body: WebView(
        initialUrl:
            'http://192.168.193.223:8502', // Ganti dengan URL server Flask Anda
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}