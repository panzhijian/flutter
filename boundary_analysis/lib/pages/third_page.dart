import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/icx_logger.dart';
import '../utils/network_manager.dart';

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
      // body: Center(
      //   child: Text("3333"),
      // ),
      body:          Consumer<NetworkManager>(
        builder: (context, network, _) {
          return Center(
            child: Text(network.connectionStatus.toString()),
          );
        })
    );
  }
}
