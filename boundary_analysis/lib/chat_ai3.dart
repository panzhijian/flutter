

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
// import '../chat_ai_data.dart';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter/rendering.dart';





class MyHomePage3 extends StatefulWidget {
  const MyHomePage3({super.key, required this.headimgurl, required this.data_list});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.


  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String headimgurl;
  final List data_list;

  @override
  State<MyHomePage3> createState() => _MyHomePage3State();
}

class _MyHomePage3State extends State<MyHomePage3> {
  TextEditingController? _editController;
  final ScrollController _scrollController = ScrollController();
  bool _autoScrollEnabled = true;
  bool _showScrollToBottomButton=false;
  late double _width;
  final FocusNode myFocusNode = FocusNode(); // 创建FocusNode对象
  bool _shouldStop = false;

  @override
  void dispose() {
    _scrollController.dispose(); // 释放滚动控制器
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _editController = TextEditingController();
    _scrollController.addListener(_scrollListener);

  }

  void _scrollListener() {
    debugPrint("scroller当前位置${_scrollController.position.pixels}");
    debugPrint("scroller最大位置${_scrollController.position.maxScrollExtent}");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_autoScrollEnabled && _scrollController.hasClients) {

      }
    });


    if (_scrollController.position.userScrollDirection != ScrollDirection.idle) {
      
      debugPrint("333333333333333333");
      _autoScrollEnabled = false;
    }



    // 判断是否显示滚动到底部按钮
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent-100){
      setState(() => _showScrollToBottomButton = false);
    }else{
      setState(() => _showScrollToBottomButton = true);
    }


    // if (!isAtBottom && !_showScrollToBottomButton) {
    //   setState(() => _showScrollToBottomButton = true);
    // } else if (isAtBottom && _showScrollToBottomButton) {
    //   setState(() => _showScrollToBottomButton = false);
    // }
    //
    // if (_scrollController.position.pixels >=
    //     _scrollController.position.maxScrollExtent) {
    //   //滚动到底部
    //   debugPrint("滚动到底部咯");
    // }else if(_scrollController.position.pixels <=
    //     _scrollController.position.minScrollExtent){
    //   //滚动到顶部
    //   debugPrint("滚动到顶部咯");
    //
    // }else{
    //   debugPrint("我在中间");
    // }



  }
  String _accumulatedText="";
  var is_ture=false;
  List data_list=[];
  var falg=false; //ai回复消息等待提示框


  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;


    debugPrint("aaaaaaaaaaa");
    //一: 布局 cloumn>expend(listview.build)+container
    //           1:expend(listview.build) 抽离方法
    //           2:container 抽离方法
    //二: 聊天逻辑
    //       1: 点击发送按钮>刷新listview.build >调用deepseek-v3接口
    //       2: 成功: 获取数据流>一直刷新listview       后期替换为[provider]形式
    //       3: 失败:返回toast
    // 目前存在问题
    //         1. 当内容很长, 滑动到列表最顶端,点击发送消息, 会闪一下,
    //            解决不了的话就换方案,点击输入框,让listview 滚动到最底部



    /// 解析流式响应数据
    /// [stream] 响应体流对象
    Stream<String> _parseStream(ResponseBody stream) async* {
      var buffer = StringBuffer(); // 用于累积不完整数据
      // Stream
      // 逐块处理字节流
      await for (final bytes in stream.stream) {
        // 将字节解码为字符串并存入缓冲区
        buffer.write(utf8.decode(bytes));

        debugPrint(buffer.toString());

        // 按换行符分割数据
        final lines = buffer.toString().split('\n');
        // debugPrint(lines);

        // 清空缓冲区后处理未完成行
        buffer.clear();
        if (lines.isNotEmpty && !lines.last.endsWith('\n')) {
          // 保留最后未完成的行继续累积
          buffer.write(lines.removeLast());
        }

        // 处理完整的数据行
        for (final line in lines.where((l) =>
        l.startsWith('data: ') &&  // 过滤有效数据行
            l.trim() != '[DONE]')) {   // 忽略结束标记
          try {
            // 解析JSON数据
            final jsonData = jsonDecode(line.substring(6)); // 去掉"data: "前缀
            // 安全获取内容字段
            final content = jsonData['choices'][0]?['delta']?['content'] ?? '';
            if (content.isNotEmpty) {
              yield content; // 产生内容块
            }
          } catch (_) {
            // 忽略单行解析错误，保持流持续处理
          }
        }
      }
    }


    //  添加数据
    _addDat(Map dic){
      data_list.add(dic);
    }
    // 在_scrollToBottom方法中添加智能判断
    void _scrollToBottom() {

      return
      WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_autoScrollEnabled && _scrollController.hasClients) {
            // debugPrint("_scrollToBottom当前位置${_scrollController.position.pixels}");
            // debugPrint("_scrollToBottom最大位置${_scrollController.position.maxScrollExtent}");
            final position = _scrollController.position; //只有内容超过视口时才滚动
            if (position.maxScrollExtent > position.minScrollExtent) {
              _scrollController.jumpTo(
                _scrollController.position.maxScrollExtent,
                // duration: Duration(milliseconds: 300),
                // curve: Curves.easeOut,
              );
            }
          }
      });

    }

    // 1: 先滚动到最底部,  2:然后发送消息, 又滚动到最底部

    Future<void> _fetchData() async {

      _shouldStop = false;

      String str=_editController!.text;
      bool isEmptyOrWhitespace = str.isEmpty || str.trim().isEmpty;
      if (isEmptyOrWhitespace){
        return ;
      }

      debugPrint("进行网络请求咯");
      _editController?.clear();
      FocusScope.of(context).requestFocus(FocusNode());
      _accumulatedText="";

      debugPrint("其他1111111111111");


      debugPrint("其他3333333333333");
      setState(() {
        debugPrint("其他444444444444");

        falg=true;
        _addDat({"is_mine":1,"msg":str,"circle":false,"isGenerating":false});
        _addDat({"is_mine":0,"msg":_accumulatedText,"circle":true,"isGenerating":true});
      });




      debugPrint("其他555555555");

      // 启用自动滚动并立即滚动到底部
      _autoScrollEnabled = true;
      _scrollToBottom();


      debugPrint("其他66666666");

      final dio = Dio();
      const apiKey = '14e65d92-b40d-4361-976c-d2be7bb48609'; // 替换为真实API密钥

      try{
        var response = await dio.post(
          'https://ark.cn-beijing.volces.com/api/v3/chat/completions',
          data: {
            "model": "deepseek-v3-241226", // 指定模型版本
            "stream": true,                // 启用流式传输
            'messages': [
              {'role': 'user', 'content': str} // 对话消息
            ]},
          options: Options(
            headers: {'Authorization': 'Bearer $apiKey'}, // 认证头
            responseType: ResponseType.stream, // 指定接收流式响应
          ),
        );

        await for (final chunk in _parseStream(response.data)) {
          data_list.last["circle"]=false;
          debugPrint("其他7777777777");
          if(_shouldStop){
            debugPrint("生成停止");

            break;
          }
          setState(() {
            debugPrint("其他88888888");

            _accumulatedText += chunk;
            falg=false;
            Map map=data_list.last;
            map["msg"]=_accumulatedText;
          });
          debugPrint("其他9999999999");

          _scrollToBottom();  // 强制滚动
          debugPrint("其他101010101010");

          // debugPrint(chunk); // 调试输出
          // stdout.write(chunk); // 实时输出内容
        }

        // falg=false;
        debugPrint(_accumulatedText);
        data_list.last["circle"]=false;//不需要更新界面 上面已经刷新了
        setState(() {
          data_list.last["isGenerating"]=false;  //需要最后更新一次
        });

      }
      catch (e) {
        debugPrint('Error错误: $e'); // 错误处理
      }
    }
    // 输入框封装
    Widget _textFiledV(){
      return TextField(
        focusNode: myFocusNode,
        minLines: 1, // 最小行数
        maxLines: 3,  // 最大行数
        cursorColor: Colors.blueAccent, // 设置光标颜色
        controller: _editController,
        onChanged:(value){
          debugPrint(value);

        },
        decoration: InputDecoration(
          labelText: "给我发消息...",
          floatingLabelBehavior: FloatingLabelBehavior.never,
          prefixIcon: GestureDetector(
            child: SizedBox(
              width: 20,
              height: 20,
              child: Opacity(
                opacity: 0.5, // 半透明
                child: Image.asset('assets/images/Add icon@1x.png'),

              )

            ),
            onTap: _fetchData,
          ), // 在右侧添加一
          suffixIcon: GestureDetector(
            child: SizedBox(
              width: 24,
              height: 24,
              child: Image.asset('assets/images/send@2x.png'),
            ),
            onTap: _fetchData,
          ), // 在右侧添加一个人物图标
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder( // 圆角无边框
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none, // 完全去掉边框线
          ),
        ),
      );
    }



    // 重新发送消息
    Future<void> _fetchData2(int index) async {
      // _fetchData2(data_list[index-1]["msg"]);

      debugPrint("重新发送消息内容${data_list[index-1]["msg"]},${index}");
      _shouldStop = false;
      // data_list.removeAt(index);
      String str=data_list[index-1]["msg"];
      bool isEmptyOrWhitespace = str.isEmpty || str.trim().isEmpty;
      if (isEmptyOrWhitespace){
        return ;
      }
      debugPrint("进行网络请求咯");
      _editController?.clear();
      FocusScope.of(context).requestFocus(FocusNode());
      _accumulatedText="";

      debugPrint("其他1111111111111");


      debugPrint("其他3333333333333");
      setState(() {
        debugPrint("其他444444444444");


        // falg=true;
        // _addDat({"is_mine":1,"msg":str});
        // _addDat({"is_mine":0,"msg":_accumulatedText});
        data_list[index]={"is_mine":0,"msg":_accumulatedText,"circle":true,"isGenerating":true};

      });



      debugPrint("其他555555555");

      // 启用自动滚动并立即滚动到底部
      _autoScrollEnabled = true;
      _scrollToBottom();


      debugPrint("其他66666666");

      final dio = Dio();
      const apiKey = '14e65d92-b40d-4361-976c-d2be7bb48609'; // 替换为真实API密钥

      try{
        var response = await dio.post(
          'https://ark.cn-beijing.volces.com/api/v3/chat/completions',
          data: {
            "model": "deepseek-v3-241226", // 指定模型版本
            "stream": true,                // 启用流式传输
            'messages': [
              {'role': 'user', 'content': str} // 对话消息
            ]},
          options: Options(
            headers: {'Authorization': 'Bearer $apiKey'}, // 认证头
            responseType: ResponseType.stream, // 指定接收流式响应
          ),
        );

        await for (final chunk in _parseStream(response.data)) {
          data_list[index]["circle"]=false;

          debugPrint("其他7777777777");
          if(_shouldStop){
            debugPrint("生成停止");

            break;
          }
          setState(() {
            debugPrint("其他88888888");

            _accumulatedText += chunk;
            falg=false;
            Map map=data_list[index];
            map["msg"]=_accumulatedText;
          });
          debugPrint("其他9999999999");

          _scrollToBottom();  // 强制滚动
          debugPrint("其他101010101010");

          // debugPrint(chunk); // 调试输出
          // stdout.write(chunk); // 实时输出内容
        }

        // falg=false;
        debugPrint(_accumulatedText);
        // data_list[index]={"is_mine":0,"msg":_accumulatedText,"circle":};
        data_list[index]["circle"]=false;
        setState(() {
          data_list.last["isGenerating"]=false;  //需要最后更新一次
        });

      }
      catch (e) {
        debugPrint('Error错误: $e'); // 错误处理
      }
    }



      // 底部模块封装
    Widget _bottomV(){
      return Container(
          decoration: BoxDecoration(
            // color: Colors.orange, // 背景颜色
            border: Border.all(
              color: Color.fromRGBO(232, 236, 239, 1), // 边框颜色
              width: 2.0, // 边框宽度
            ),
            borderRadius: BorderRadius.circular(10.0), // 圆角
            // boxShadow: [
            //   BoxShadow(
            //     // color: Color.fromRGBO(100, 100, 100,0.2), // 阴影颜色
            //     spreadRadius: 2, // 阴影扩散范围
            //     blurRadius: 7, // 阴影模糊程度
            //     // offset: Offset(0, 3), // 阴影偏移
            //   )
            // ],
          ),
          margin: EdgeInsets.only(left: 16,bottom: 32,right:16 ,top: 15),
          padding: EdgeInsets.only(left: 5,bottom: 2,right:10 ,top: 0),
          child: _textFiledV(),
      );
    }

    Widget getA(){
      return Align(
        alignment: Alignment.centerLeft, // 靠左对齐
        child: Container( // 使用Container来设置大小和样式
          padding:EdgeInsets.all(15) ,
          width: 50, // 设置宽度
          height: 50, // 设置高度
          // color: Colors.blue, // 设置背景颜色
          child: const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color.fromRGBO(200, 200, 200, 1)),

          ), // 子组件内容
        ),
      );

    }


    Widget _left_right_widget(BuildContext context, int index){
      // WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

      if(data_list[index]["is_mine"]==1){
       //  Stack> coulum+image
       //  Column>container+row

        Widget a=Stack(
          children: [
            Column(
              children: [
                Container(
                  width: _width-32,
                  margin: EdgeInsets.only(top: 30 ),
                  padding: EdgeInsets.only(left:20 ,right: 20,top: 20,bottom: 64),
                  decoration: BoxDecoration(
                    color: Colors.white, // 使用ARGB色值设置背景颜色
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(
                      color: Color.fromARGB(255, 243, 245, 247), // 设置边框颜色
                      width: 3.0, // 设置边框宽度
                    ),
                  ),
                  child: Text(
                    data_list[index]["msg"],
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                Container(
                  color: Colors.white,
                  margin:EdgeInsets.only(left:16 ,right: 16,top: 6,bottom: 0) ,
                  height:24 ,
                  child: Row(
                    children: [
                      Text(
                        "just now",
                        style: TextStyle(
                          fontSize: 12.0, // 字体大小
                          color: Color.fromRGBO(108, 114, 117, 0.5), // 字体颜色
                        ),
                      ),
                      SizedBox(width: 8,),

                      ElevatedButton(
                          onPressed: (){
                            FocusScope.of(context).requestFocus(myFocusNode); // 点击按钮时请求焦点，键盘弹起
                            _editController?.text=data_list[index]["msg"];

                          },
                          child: Text(
                              "Edit",
                              style: TextStyle(
                                fontSize: 12.0, // 字体大小
                                color: Color.fromRGBO(35, 38, 39, 1), // 字体颜色
                              ),
                          ),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(38, 24),
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5.0), // 调整水平和垂直间距
                            backgroundColor: Color.fromRGBO(232, 236, 239, 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0), // 设置圆角大小
                            ),

                          ),

                      ),
                      // SizedBox(height: 60,)
                    ],
                  ),
                ),
                // SizedBox(height: 30,)
                // SizedBox(height: 30,),
              ],
            ),
            Positioned(
              bottom: 0,
              right:30,
              child: Container(
                  height: 64,
                  width:64,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0), // 设置圆角大小
                    child: widget.headimgurl.isEmpty?Image.asset('assets/images/user@2x.png'):                  CachedNetworkImage(
                      imageUrl: widget.headimgurl,
                      placeholder: (BuildContext context, String url) {
                        return const Center(
                            child: CircularProgressIndicator()
                        );
                      },
                    ),
                  ),
              )
              ,
            ),
          ],
        );
        return a;
      }else{
        Widget a=Stack(
          children: [
            Column(
              children: [
                Container(
                  width: _width-20,
                  margin: EdgeInsets.only(top: 30 ),
                  padding: EdgeInsets.only(left:20 ,right: 20,top: 20,bottom: 64),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 243, 245, 247), // 使用ARGB色值设置背景颜色
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: MarkdownBody(
                    data: data_list[index]["msg"],
                    selectable: true,
                    styleSheet: MarkdownStyleSheet(
                      // 全局文本样式（默认样式）
                      p: TextStyle(
                        fontSize: 18.0, // 设置基础字体大小
                        // color: Colors.orange,
                      ),
                      // 设置多行代码块（代码块）的背景颜色
                      codeblockDecoration: BoxDecoration(
                        color: Color.fromARGB(255, 232, 232, 232), // 背景色
                        borderRadius: BorderRadius.circular(10.0), // 圆角
                      ),

                      // 列表样式
                      // listIndent: 24.0,  // 列表缩进
                    ),
                  ),
                ),
                Container(
                  color: Colors.white,
                  margin:EdgeInsets.only(left:16 ,right: 16,top: 6,bottom: 0) ,
                  height:24 ,
                  child: data_list.length-1==index?Row(
                    mainAxisAlignment: MainAxisAlignment.end, // 让子元素从右边开始排列
                    children: [
                      ElevatedButton.icon(
                        onPressed: (){
                          if (data_list.last["isGenerating"]) {
                            setState(() {
                              // 正在生成
                              _shouldStop = true;
                              data_list.last["isGenerating"]=false;
                              debugPrint('已请求停止生成');
                            });

                          }else{
                            // 停止生成, 手动停止,以及默认初始状态停止,
                            // 重新发网络请求

                            _fetchData2(index);

                          }

                        },
                        label: Text(
                          data_list.last["isGenerating"]?"Pause generating":"generating",
                          style: TextStyle(
                            fontSize: 12.0, // 字体大小
                            color: Color.fromRGBO(35, 38, 39, 1), // 字体颜色
                          ),
                        ),
                        icon: data_list.last["isGenerating"]?SizedBox(height: 16,child: Image.asset("assets/images/stop@2x.png"),):SizedBox(height: 16,child: null,),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(38, 24),
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0.0), // 调整水平和垂直间距
                          backgroundColor: Color.fromRGBO(232, 236, 239, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0), // 设置圆角大小
                          ),
                        ),

                      ),
                      // SizedBox(height: 60,)
                    ],
                  ):null,

                ),
              ],
            ),
            Positioned(
              bottom: 0,
              left:30,
              child: SizedBox(height: 64,width:64, child: Image.asset('assets/images/Avatar@2x.png'))
              ,
            ),
          ],
        );
        return  AnimatedSwitcher(
          duration: Duration(microseconds: 300),
          child: data_list[index]["circle"]==true
              ? getA()
              :a);
      }
    }



    // 列表封装
    Widget _listviewV(){
      return Expanded(
          child: ListView.builder(
              controller: _scrollController, // 绑定控制器
              itemCount: data_list.length,
              // cacheExtent: 10000,
              physics: AlwaysScrollableScrollPhysics(), // 强制启用滚动
              // padding: EdgeInsets.only(bottom: 20), // 底部留白
              itemBuilder: (BuildContext context, int index) {
                debugPrint("bbbbbbbb");
                return _left_right_widget(context, index);
              }
          )
      );
    }


    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Chat"),
        backgroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked, // 悬浮按钮位置
      floatingActionButton: _showScrollToBottomButton
          ?Container(
            width: 40,
            height: 40,
            // color: Colors.red,
            margin: EdgeInsets.only(bottom: 110),
            child: FloatingActionButton(
              backgroundColor:Color.fromRGBO(245, 245, 245, 1),
              onPressed: () {
                // debugPrint("当前位置${_scrollController.position.pixels}");
                // debugPrint("最大位置${_scrollController.position.maxScrollExtent}");
                // 处理点击事件
                debugPrint("点击事件");
                _autoScrollEnabled=true;
                _scrollToBottom();
              },
              tooltip: '底部', // 悬浮按钮的提示信息
              child: SizedBox(
                width: 20,
                height: 20,
                child: Image.asset("assets/images/向下箭头.png"),
              ), // 悬浮按钮的图标
            ),
          )
          :null,
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _listviewV(),
          _bottomV()
        ],
      ),
    );
  }
}




