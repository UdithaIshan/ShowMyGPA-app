import 'package:flutter/material.dart';

void main() => runApp(GPAAnalyzer());

class GPAAnalyzer extends StatefulWidget {
  @override
  _GPAAnalyzerState createState() => _GPAAnalyzerState();
}

class _GPAAnalyzerState extends State<GPAAnalyzer> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
    );
  }
}
