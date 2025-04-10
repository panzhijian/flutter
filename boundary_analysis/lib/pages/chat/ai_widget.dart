import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'message.dart';


class AiWidget extends StatefulWidget {
  final MessageElement messageEle;
  final VoidCallback? onPressed;
  final bool isfirstMessageEle; //如果是第一个元素, 先显示菊花,在正常显示

  const AiWidget(this.messageEle, {super.key,this.onPressed,required this.isfirstMessageEle});

  @override
  State<AiWidget> createState() => _AiWidgetState();
}

class _AiWidgetState extends State<AiWidget> {
  late double _width;

  Widget getA() {
    return Align(
      alignment: Alignment.centerLeft, // 靠左对齐
      child: Container( // 使用Container来设置大小和样式
        padding: const EdgeInsets.all(15),
        width: 50, // 设置宽度
        height: 50, // 设置高度
        // color: Colors.blue, // 设置背景颜色
        child: const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
              Color.fromRGBO(200, 200, 200, 1)),
        ), // 子组件内容
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _width= MediaQuery.of(context).size.width;
    final Widget a=Stack(
      children: [
        Column(
          children: [
            Container(
              width: _width-20,
              margin: const EdgeInsets.only(top: 30 ),
              padding: const EdgeInsets.only(left:20 ,right: 20,top: 20,bottom: 64),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 243, 245, 247), // 使用ARGB色值设置背景颜色
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: MarkdownBody(
                data: widget.messageEle.content?.text??"",
                // selectable: true,
                styleSheet: MarkdownStyleSheet(
                  // 全局文本样式（默认样式）
                  p: const TextStyle(
                    fontSize: 18.0, // 设置基础字体大小
                    // color: Colors.orange,
                  ),
                  // 设置多行代码块（代码块）的背景颜色
                  codeblockDecoration: BoxDecoration(
                    color: const Color.fromARGB(255, 232, 232, 232), // 背景色
                    borderRadius: BorderRadius.circular(10.0), // 圆角
                  ),

                  // 列表样式
                  // listIndent: 24.0,  // 列表缩进
                ),
              ),
            ),
            Container(
              color: Colors.white,
              margin:const EdgeInsets.only(left:16 ,right: 16,top: 6,bottom: 0) ,
              height:24 ,
              child: widget.isfirstMessageEle?Row(
                mainAxisAlignment: MainAxisAlignment.end, // 让子元素从右边开始排列
                children: [
                  ElevatedButton.icon(
                    onPressed: widget.onPressed,
                    label: Text(
                      (widget.messageEle.isGenerating??false)?"Pause generating":"generating",
                      style: const TextStyle(
                        fontSize: 12.0, // 字体大小
                        color: Color.fromRGBO(35, 38, 39, 1), // 字体颜色
                      ),
                    ),
                    icon: (widget.messageEle.isGenerating??false)?SizedBox(height: 16,child: Image.asset('assets/images/stop.png'),):const SizedBox(height: 16,child: null,),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(38, 24),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0.0), // 调整水平和垂直间距
                      backgroundColor: const Color.fromRGBO(232, 236, 239, 1),
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
          child: SizedBox(height: 64,width:64, child:  Image.asset('assets/images/Avatar.png')),
        ),
      ],
    );
    return  AnimatedSwitcher(
        duration: const Duration(microseconds: 300),
        child: (widget.messageEle.content?.text?.isEmpty ?? false)
            ? getA()
            :a
        );
  }
}
