// 1. 定义 Model 类
import 'dart:convert';

import 'package:boundary_analysis/utils/icx_logger.dart';

class HomeListModel {
  final String title;
  final String desc;

  // final int age;
  final String url;

  HomeListModel({required this.title, required this.desc, required this.url});

  // 2. 手动实现 fromJson
  factory HomeListModel.fromJson(Map<String, dynamic> json) {
    return HomeListModel(
      title: json['title'] as String,
      desc: json['desc'] as String,
      url: json['url'] as String,
    );
  }

  // 3. 手动实现 toJson
  Map<String, dynamic> toJson() => {
    'title': title,
    'desc': desc,
    'url': url,
  };
}

void main(){
  // 使用示例
  final json = '{"title": "John", "desc": "25", "url": "2023-01-01"}';
  final user = HomeListModel.fromJson(jsonDecode(json));
  ICXLogger.d(user.title);
  ICXLogger.d("${user.desc}=====${user.title}====${user.url}");
}
