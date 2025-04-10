import 'package:flutter/material.dart';

class MinePage extends StatefulWidget {
  const MinePage({super.key});

  @override
  State<MinePage> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("我的页面"),),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               Text("我的页面"),
            ],
          ),
        ),
      ),
    );
  }
}
