import 'dart:io';

import 'package:boundary_analysis/common_widgets/icx_app.dart';
import 'package:flutter/material.dart';
import 'package:fluwx/fluwx.dart';

void main() async{
  // kReleaseMode=true;
  // if (true) {
  //   AppLogger.configProd();
  //   AppLogger.enableLogging(false); // 生产环境关闭日志
  // }

  if (Platform.isAndroid||Platform.isIOS) {
    // 代码逻辑
    WidgetsFlutterBinding.ensureInitialized();
    await Fluwx().registerApi(
      appId: 'wx891598f540548c77',
      doOnAndroid: true,
      doOnIOS: true,
      universalLink: 'https://icarbonx.com/app/',
    );
  }

  runApp(const ICXApp());
}



