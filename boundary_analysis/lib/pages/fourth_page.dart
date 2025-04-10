import 'package:boundary_analysis/utils/icx_logger.dart';
import 'package:flutter/material.dart';

class FourthPage extends StatefulWidget {
  const FourthPage({super.key});

  @override
  State<FourthPage> createState() => _FourthPageState();
}

class _FourthPageState extends State<FourthPage> {
  @override
  Widget build(BuildContext context) {
    ICXLogger.d("44444");

    return Scaffold(
      appBar: AppBar(
        title: Text("我的"),
        // backgroundColor: Colors.red,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Text("44444"),
      ),
    );
  }
}
