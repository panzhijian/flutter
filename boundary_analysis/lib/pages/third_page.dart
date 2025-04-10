import 'package:flutter/material.dart';
import '../utils/icx_logger.dart';

class ThirdPage extends StatefulWidget {
  const ThirdPage({super.key});

  @override
  State<ThirdPage> createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {
  @override
  Widget build(BuildContext context) {
    ICXLogger.d("33333");
    return Scaffold(
      appBar: AppBar(
        title: Text("test3"),
        // backgroundColor: Colors.blueAccent,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Text("3333"),
      ),
    );
  }
}
