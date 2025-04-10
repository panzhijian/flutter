import 'dart:convert';

class ChatHttpParaUtil{

  final List<Map<String, dynamic>> httpPara = []; // 改为dynamic类型
  static const int _maxRounds = 10;
  static const int _maxTokens = 3000;


  addHttpPara({required String role, required dynamic content}){
    httpPara.add({
      'role': role,
      'content': content,
    });
    _autoTrim();
  }


  void _autoTrim() {
    while (httpPara.length > _maxRounds || _calculateTotalLength() > _maxTokens) {
      httpPara.removeAt(0);
    }
  }

  int _calculateTotalLength() {
    return httpPara.fold(0, (sum, msg) {
      final content = msg['content'];
      return sum + _computeContentLength(content);
    });
  }

  // 新增内容长度计算方法
  int _computeContentLength(dynamic content) {
    if (content is String) {
      return content.length;
    } else if (content is List) {
      // 处理列表中的Map元素
      return content.fold(0, (sum, item) {
        if (item is Map<String, dynamic>) {
          return sum + jsonEncode(item).length; // 将Map转换为JSON字符串计算长度
        }
        return sum;
      });
    }
    return 0; // 其他类型不计入长度或根据需求调整
  }


}
