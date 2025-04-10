import 'package:flutter/material.dart';

import '../utils/icx_logger.dart';

class SecondPage extends StatefulWidget {
  const SecondPage({super.key});

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  @override
  Widget build(BuildContext context) {
    ICXLogger.d("2222");
    return Scaffold(
      appBar: AppBar(
        title: Text("test1"),
        // backgroundColor: Colors.green,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Text("222"),
      ),
    );
  }
}
