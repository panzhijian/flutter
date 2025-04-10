// content支持多种类型, 适合对话有图片的场景
import 'dart:convert';
import 'package:boundary_analysis/pages/chat/message_type.dart';
import 'package:boundary_analysis/pages/chat/role_type.dart';
import 'package:boundary_analysis/utils/icx_logger.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'chat_http_para_util.dart';
import 'message.dart';

// void main() => runApp(MyApp());
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//
//     return MaterialApp(
//       home: Scaffold(
//         body: Test(),
//       )
//     );
//   }
// }
//
// class Test extends StatefulWidget {
//   const Test({super.key});
//
//   @override
//   State<Test> createState() => _TestState();
// }
//
// class _TestState extends State<Test> {
//
//   void _getData(){
//     final vm = ChatPageVM();
//     // 按照要求调用接口 接口参数而已, 不需要model, 下面是图片和文字一起的参数
//     // final pic_info=[
//     //   {
//     //     "type":"text",
//     //     "text":"图片主要讲了什么?"
//     //   },
//     //   {
//     //     "type": "image_url",
//     //     "image_url": {
//     //       "url": "https://ark-project.tos-cn-beijing.volces.com/doc_image/ark_demo_img_1.png"
//     //     }
//     //   },
//     //   {
//     //     "type": "image_url",
//     //     "image_url": {
//     //       "url": "https://ark-project.tos-cn-beijing.volces.com/doc_image/ark_demo_img_2.png"
//     //     }
//     //   }
//     // ];
//
//     // ICXLogger.d(vm._messages);
//     ChatHttpParaMessage para=ChatHttpParaMessage.addHttpMessagePara(role: "user", content: "帮我写100字");
//     para._httpParaMessage;
//
//
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: ElevatedButton(onPressed: (){
//         _getData();
//       }, child: Text("点击")),
//     );
//   }
// }






//添加了注释版本
/// 聊天流式交互处理类
class ChatStream {
  // 使用Dio作为HTTP客户端
  bool isGenerating=true; //默认第一个就是在生成

  static const apiKey = '14e65d92-b40d-4361-976c-d2be7bb48609'; // 替换为真实API密钥

  final Dio _dio = Dio();

  // Function(bool isGenerating)? callback;



  /// 发送消息并获取流式响应
  /// [messages] 消息历史记录，格式示例：
  /// [
  ///   {'role': 'user', 'content': '你好'},
  ///   {'role': 'assistant', 'content': '你好！有什么可以帮助你的？'}
  /// ]
  /// {"choices":[{"finish_reason":"stop","index":0,"logprobs":null,"message":{"content":"十字花科（Brassicaceae）是一类重要的植物科，包含了许多常见的蔬菜、油料作物和观赏植物。以下是一些常见的十字花科植物：\n\n### 蔬菜类：\n1. **甘蓝**（Brassica oleracea）\n   - **卷心菜**（Cabbage）\n   - **花椰菜**（Cauliflower）\n   - **西兰花**（Broccoli）\n   - **羽衣甘蓝**（Kale）\n   - **球茎甘蓝**（Kohlrabi）\n\n2. **大白菜**（Brassica rapa subsp. pekinensis）\n\n3. **小白菜**（Brassica rapa subsp. chinensis）\n\n4. **芥菜**（Brassica juncea）\n   - **雪里蕻**（Mustard greens）\n   - **芥菜籽**（Mustard seeds）\n\n5. **萝卜**（Raphanus sativus）\n   - **白萝卜**（Daikon radish）\n   - **樱桃萝卜**（Cherry radish）\n\n6. **芜菁**（Brassica rapa subsp. rapa）\n\n7. **油菜**（Brassica napus）\n   - **油菜籽**（Canola, used for oil）\n\n### 油料作物：\n1. **油菜**（Brassica napus）\n2. **芥菜**（Brassica juncea）\n3. **亚麻荠**（Camelina sativa）\n\n### 观赏植物：\n1. **紫罗兰**（Viola spp.）\n2. **香雪球**（Lobularia maritima）\n3. **羽衣甘蓝**（Ornamental kale）\n\n### 野生植物：\n1. **荠菜**（Capsella bursa-pastoris）\n2. **独行菜**（Lepidium spp.）\n3. **葶苈**（Draba spp.）\n\n这些植物在农业、园艺和生态系统中都扮演着重要角色，具有广泛的用途和经济价值。","role":"assistant"}}],"created":1741916189,"id":"02174191617138438eab44a4b1ff29b46112b3edbb97f64368ac6","model":"deepseek-v3-241226","service_tier":"default","object":"chat.completion","usage":{"completion_tokens":430,"prompt_tokens":9,"total_tokens":439,"prompt_tokens_details":{"cached_tokens":0},"completion_tokens_details":{"reasoning_tokens":0}}}
  Stream<String> send(List<Map<String, dynamic>> messages) async* {
    // API接口地址
    const url = 'https://ark.cn-beijing.volces.com/api/v3/chat/completions';

    try {
      // 发送POST请求
      final response = await _dio.post(
        url,
        // 请求体数据
        data: {
          "model": "deepseek-v3-241226", // 使用的AI模型
          "stream": true,               // 启用流式传输
          "messages": messages          // 对话历史
        },
        // 请求配置
        options: Options(
          headers: {
            // 认证头，Bearer后面加空格是标准格式
            'Authorization': 'Bearer $apiKey'
          },
          // 指定接收流式响应
          responseType: ResponseType.stream,
        ),
      );

      // 创建字符串缓冲区，用于处理不完整的数据块
      var buffer = StringBuffer();

      // 逐块处理接收到的字节流
      await for (final chunk in response.data.stream) {
        if(!isGenerating){
          break;
        }
        // debugPrint(utf8.decode(chunk));
        // 将字节数据解码为字符串并追加到缓冲区
        buffer.write(utf8.decode(chunk));

        // 按换行符分割数据（SSE协议以\n分隔事件）
        final lines = buffer.toString().split('\n');

        // 清空缓冲区后处理未完成行
        buffer.clear();

        if (lines.last.isNotEmpty) {
          // 如果最后一行不完整，保留到下次处理
          buffer.write(lines.removeLast());
        }

        // 处理每个完整的事件行
        for (final line in lines) {
          // 过滤有效数据行：以"data: "开头且不是结束标记
          if (line.startsWith('data: ') && line.trim() != '[DONE]') {
            try {
              // 解析JSON数据（去掉前缀"data: "后的部分）
              final json = jsonDecode(line.substring(6));

              // 安全获取内容字段路径：choices[0].delta.content
              // 使用?? 运算符提供默认值，避免空异常
              final content = json['choices'][0]['delta']['content'] ?? '';

              // 输出有效内容
              if (content.isNotEmpty) {
                yield content; // 生成流数据
              }
            } catch (_) {
              // 忽略单行解析错误，保持流持续
            }
          }
        }
      }
    } catch (e) {
      // 统一异常处理，将错误转换为可读信息
      throw Exception('请求失败: ${e.toString()}');
    }
  }
}






class ChatPageVM extends ChangeNotifier {

  List<MessageElement> message_element_list=[]; //界面消息列表
  ChatHttpParaUtil para=ChatHttpParaUtil();
  ChatStream chat=ChatStream();


  // 用户发送消息
  Future sendMessage(String content) async{

    chat.isGenerating=true;//打开流式返回开关,确保能够正常返回数据

    //0: 判断消息数据格式是否ok, ok的花组装2个消息model
    final MessageElement user=MessageElement.fromJson({"type":"text","role":"user","content":{"text":content}});
    final MessageElement ai=MessageElement.fromJson({"type":"text","role":"assistant","content":{"text":""},"isGenerating":true});
    message_element_list.insert(0,user);
    message_element_list.insert(0,ai);
    if(hasListeners){
      notifyListeners();
    }

    //1: 处理用户发送的内容, 拼httppara, 以及消息界面的消息格式
    para.addHttpPara(role: "user", content: content);
    ICXLogger.d(para.httpPara);


    //2: 调用大模型文本对话的api
    final stream =chat.send(para.httpPara);


    //3: 解析流式返回响应+SSE数据格式
    String assistant_content="";
    stream.listen((data) {
      assistant_content+=data;
      message_element_list.first.content?.text=assistant_content;
      if(hasListeners) notifyListeners();

      // ICXLogger.d('Received data: $data'); // 输出: Received data: 1, Received data: 2, Received data: 3
    }, onDone: () {
      ICXLogger.d('流式返回结束成功'); // 1:手动点击停止,也会调用  2:流式返回成功后结束也会调用
      para.addHttpPara(role: "assistant", content: assistant_content);
      message_element_list.first.isGenerating=false;
      if(hasListeners) notifyListeners();

    }, onError: (error) {
      throw Exception('流式返回失败: ${error}');

    });



    //4: 在合适地方发出notifyListeners
    // con.addMessage("assistant", assistant_content);


    // final MessageElement ele=MessageElement.fromJson({"type":"text","role":"user","content":{"text":"帮我写500字"}});


   // Future getHomeList() async {
   //   Response res = await DioInstance.instance().get(path: "banner/json");
   //   List dd = res.data;
   //   for (int i = 0; i < dd.length; i++) {
   //     HomeListModel2 model = HomeListModel2.fromJson(dd[i]);
   //     data_list.add(model);
   //   }
   //   notifyListeners();
   // }

   // message_element_list.add(ele);
   // notifyListeners();
   //  ICXLogger.d("结束");
  }

  // 是否在生成,true 和false
  void updateIsGenerating(bool isGenerating) {
    // 为ture 代码正在生成, false停止生成了
    if(isGenerating){
      // 发起重新生成网络请求接口

    }else{

    }
    //1 暂停流式返回
    chat.isGenerating=isGenerating;
  }



  //ai回复消息
  replyMessage(){

    notifyListeners();
  }



}


