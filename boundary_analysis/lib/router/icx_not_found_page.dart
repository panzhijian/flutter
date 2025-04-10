// 示例错误页面
import 'package:flutter/material.dart';

class ICXNotFoundPage extends StatelessWidget {
  const ICXNotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('404')),
      body: const Center(child: Text('页面不存在')),
    );
  }
}