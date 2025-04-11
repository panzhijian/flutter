// lib/network_manager.dart
import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

import 'icx_logger.dart';

class NetworkManager extends ChangeNotifier {
  List<ConnectivityResult> connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  NetworkManager() {
    ICXLogger.d("NetworkManager");
    // 初始化监听
    _init();
  }

  // 初始化
  Future<void> _init() async {

    try {
      // // 主动获取当前网络状态
      // final initialStatus = await _connectivity.checkConnectivity();
      // await _updateConnectionStatus(initialStatus);
      //监听网络变化
      _connectivitySubscription =
          _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    } catch (e) {
      ICXLogger.d(e);
      ICXLogger.d('连接网络出现了异常');
    }
  }


  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    connectionStatus = result;

    ICXLogger.d(connectionStatus);
    notifyListeners();


    if (result == ConnectivityResult.mobile) {
      ICXLogger.d('成功连接移动网络');
    } else if (result == ConnectivityResult.wifi) {
      ICXLogger.d('成功连接WIFI');
    } else if (result == ConnectivityResult.ethernet) {
      ICXLogger.d('成功连接到以太网');
    } else if (result == ConnectivityResult.vpn) {
      ICXLogger.d('成功连接vpn网络');
    } else if (result == ConnectivityResult.bluetooth) {
      ICXLogger.d('成功连接蓝牙');
    } else if (result == ConnectivityResult.other) {
      ICXLogger.d('成功连接除以上以外的网络');
    } else if (result == ConnectivityResult.none) {
      ICXLogger.d('没有连接到任何网络');
    }
  }


}


