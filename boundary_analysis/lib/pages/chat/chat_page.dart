import 'package:boundary_analysis/pages/chat/ai_widget.dart';
import 'package:boundary_analysis/pages/chat/user_text_widget.dart';
import 'package:boundary_analysis/utils/icx_logger.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common_widgets/icx_change_notifier_provider.dart';
import '../../common_widgets/icx_consumer.dart';
import 'chat_page_vm.dart';

class ChatPage extends StatefulWidget {
  final String headimgurl;
  const ChatPage({super.key, required this.headimgurl});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _editController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  static final FocusNode myFocusNode = FocusNode(); // 创建FocusNode对象
  final vm = ChatPageVM();
  bool isGenerating = true; //默认第一个就是在生成
  bool _showScrollToBottomButton=false;


  @override
  void dispose() {
    _scrollController.dispose();
    _editController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    // debugPrint("scroller当前位置${_scrollController.position.pixels}");
    // debugPrint("scroller最大位置${_scrollController.position.maxScrollExtent}");
    // debugPrint("scroller最小位置${_scrollController.position.minScrollExtent}");
    // 判断是否显示滚动到底部按钮

    if (_scrollController.position.pixels <= _scrollController.position.minScrollExtent+100){
      setState(() => _showScrollToBottomButton = false);
    }else{
      setState(() => _showScrollToBottomButton = true);
    }
  }

  // 在_scrollToBottom方法中添加智能判断
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        final position = _scrollController.position; //只有内容超过视口时才滚动
        if (position.maxScrollExtent > position.minScrollExtent) {
          _scrollController.jumpTo(
            _scrollController.position.minScrollExtent,
            // duration: Duration(milliseconds: 300),
            // curve: Curves.easeOut,
          );
        }
      }
    });
  }

  // 底部模块封装
  Widget _bottomV() {
    return Container(
      decoration: BoxDecoration(
        // color: Colors.orange, // 背景颜色
        border: Border.all(
          color: const Color.fromRGBO(232, 236, 239, 1), // 边框颜色
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
      margin: const EdgeInsets.only(left: 16, bottom: 32, right: 16, top: 15),
      padding: const EdgeInsets.only(left: 5, bottom: 2, right: 10, top: 0),
      child: _textFiledV(),
    );
  }

  Widget _textFiledV() {
    return TextField(
      focusNode: myFocusNode,
      minLines: 1,
      // 最小行数
      maxLines: 3,
      // 最大行数
      cursorColor: Colors.blueAccent,
      // 设置光标颜色
      controller: _editController,
      onChanged: (value) {
        // debugPrint(value);
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
                child: Image.asset('assets/images/Add icon.png'),
              )),
        ),
        // 在右侧添加一
        suffixIcon: GestureDetector(
          child: SizedBox(
            width: 24,
            height: 24,
            child: Image.asset('assets/images/send.png'),
          ),
          onTap: () {
            if (_editController.text.trim().isEmpty) {
              ICXLogger.d("空内容");
              return;
            } else {
              _scrollToBottom();
              vm.sendMessage(_editController.text);
            }
          },
        ),
        // 在右侧添加一个人物图标
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          // 圆角无边框
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none, // 完全去掉边框线
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ICXChangeNotifierProvider<ChatPageVM>(
        create: () => vm,
        builder: (BuildContext context, Widget? child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Chat"),
              backgroundColor: Colors.white,
            ),
            backgroundColor: Colors.white,
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked, // 悬浮按钮位置
            floatingActionButton: _showScrollToBottomButton
                ?Container(
              width: 40,
              height: 40,
              // color: Colors.red,
              margin: const EdgeInsets.only(bottom: 110),
              child: FloatingActionButton(
                backgroundColor:const Color.fromRGBO(245, 245, 245, 1),
                onPressed: () {
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
            body: SafeArea(
              child: Column(
                children: [
                  // 可扩展的滚动区域
                  Expanded(
                      child: Align(
                    alignment: Alignment.topCenter,
                    child:ICXConsumer<ChatPageVM>(builder: (context, vm, child) {
                      return ListView.builder(
                        controller: _scrollController,
                        shrinkWrap: true,
                        reverse: true,
                        itemCount: vm.message_element_list.length,
                        // itemExtent: 50,
                        itemBuilder: (BuildContext context, int index) {
                          if (vm.message_element_list[index].role == "user" &&
                              vm.message_element_list[index].type == "text") {
                            return UserTextWidget(
                              vm.message_element_list[index],
                              editCallback: () {
                                FocusScope.of(context).requestFocus(
                                    myFocusNode); // 点击按钮时请求焦点，键盘弹起
                                _editController.text = vm.message_element_list[index].content?.text ??"";
                              },
                              headimgurl: widget.headimgurl,
                            );
                            return Align(
                              alignment: Alignment.centerRight,
                              child: Text(vm.message_element_list[index].content
                                      ?.text ??
                                  ""),
                            );
                          } else {
                            // return Align(
                            //     alignment:Alignment.centerLeft,
                            //   child: Text(vm.message_element_list[index].content?.text ??""),
                            // );

                            return AiWidget(
                              vm.message_element_list[index],
                              isfirstMessageEle: (index == 0) ? true : false,
                              onPressed: () {
                                isGenerating = !isGenerating;
                                final provider = Provider.of<ChatPageVM>(context,listen: false);
                                provider.updateIsGenerating(isGenerating);
                              },
                            );
                          }
                        },
                      );
                    }),
                  )),

                  _bottomV(),
                ],
              ),
            ),
          );
        });
  }
}



// class BottomTextField extends StatelessWidget {
//   final TextEditingController _editController = TextEditingController();
//   const BottomTextField({super.key});
//
//
//   // 底部模块封装
//   Widget _bottomV() {
//     return Container(
//       decoration: BoxDecoration(
//         // color: Colors.orange, // 背景颜色
//         border: Border.all(
//           color: const Color.fromRGBO(232, 236, 239, 1), // 边框颜色
//           width: 2.0, // 边框宽度
//         ),
//         borderRadius: BorderRadius.circular(10.0), // 圆角
//         // boxShadow: [
//         //   BoxShadow(
//         //     // color: Color.fromRGBO(100, 100, 100,0.2), // 阴影颜色
//         //     spreadRadius: 2, // 阴影扩散范围
//         //     blurRadius: 7, // 阴影模糊程度
//         //     // offset: Offset(0, 3), // 阴影偏移
//         //   )
//         // ],
//       ),
//       margin: const EdgeInsets.only(left: 16, bottom: 32, right: 16, top: 15),
//       padding: const EdgeInsets.only(left: 5, bottom: 2, right: 10, top: 0),
//       child: _textFiledV(),
//     );
//   }
//
//   Widget _textFiledV() {
//     return TextField(
//       focusNode: myFocusNode,
//       minLines: 1,
//       // 最小行数
//       maxLines: 3,
//       // 最大行数
//       cursorColor: Colors.blueAccent,
//       // 设置光标颜色
//       controller: _editController,
//       onChanged: (value) {
//         // debugPrint(value);
//       },
//       decoration: InputDecoration(
//         labelText: "给我发消息...",
//         floatingLabelBehavior: FloatingLabelBehavior.never,
//         prefixIcon: GestureDetector(
//           child: SizedBox(
//               width: 20,
//               height: 20,
//               child: Opacity(
//                 opacity: 0.5, // 半透明
//                 child: Image.asset('assets/images/Add icon.png'),
//               )),
//         ),
//         // 在右侧添加一
//         suffixIcon: GestureDetector(
//           child: SizedBox(
//             width: 24,
//             height: 24,
//             child: Image.asset('assets/images/send.png'),
//           ),
//           onTap: () {
//             if (_editController.text.trim().isEmpty) {
//               ICXLogger.d("空内容");
//               return;
//             } else {
//               _scrollToBottom();
//               vm.sendMessage(_editController.text);
//             }
//           },
//         ),
//         // 在右侧添加一个人物图标
//         filled: true,
//         fillColor: Colors.white,
//         border: OutlineInputBorder(
//           // 圆角无边框
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide.none, // 完全去掉边框线
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }

