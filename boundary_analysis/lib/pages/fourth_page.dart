import 'dart:async';

import 'package:boundary_analysis/utils/icx_logger.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../utils/network_manager.dart';

class FourthPage extends StatefulWidget {
  const FourthPage({super.key});

  @override
  State<FourthPage> createState() => _FourthPageState();
}

class _FourthPageState extends State<FourthPage> {
  @override
  Widget build(BuildContext context) {

    ICXLogger.d("444");
    return Scaffold(
      appBar: AppBar(
        title: Text("我的"),
        // backgroundColor: Colors.blueAccent,
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 示例：点击按钮时检查网络
          Fluttertoast.showToast(
              msg: "${context.read<NetworkManager>().connectionStatus.toString()}",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black45,
              textColor: Colors.white,
              fontSize: 16.0
          );

        },
        child: const Icon(Icons.refresh),
      ),

      body: Center(
        child: Text("4444"),
      ),
    );
  }
}
