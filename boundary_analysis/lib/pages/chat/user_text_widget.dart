import 'package:flutter/material.dart';
import 'message.dart';
import 'package:cached_network_image/cached_network_image.dart';


class UserTextWidget extends StatefulWidget {
  final MessageElement messageEle;
  final VoidCallback? editCallback;
  final String? headimgurl;

  const UserTextWidget(this.messageEle, {super.key,this.editCallback,this.headimgurl});

  @override
  State<UserTextWidget> createState() => _UserTextWidgetState();
}

class _UserTextWidgetState extends State<UserTextWidget> {
  late double _width;

  @override
  Widget build(BuildContext context) {
    _width= MediaQuery.of(context).size.width;

    final Widget a=Stack(
      children: [
        Column(
          children: [
            Container(
              width: _width-32,
              margin: const EdgeInsets.only(top: 30 ),
              padding: const EdgeInsets.only(left:20 ,right: 20,top: 20,bottom: 64),
              decoration: BoxDecoration(
                color: Colors.white, // 使用ARGB色值设置背景颜色
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(
                  color: const Color.fromARGB(255, 243, 245, 247), // 设置边框颜色
                  width: 3.0, // 设置边框宽度
                ),
              ),
              child: Text(
                widget.messageEle.content?.text??"",
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            Container(
              color: Colors.white,
              margin:const EdgeInsets.only(left:16 ,right: 16,top: 6,bottom: 0) ,
              height:24 ,
              child: Row(
                children: [
                  const Text(
                    "just now",
                    style: TextStyle(
                      fontSize: 12.0, // 字体大小
                      color: Color.fromRGBO(108, 114, 117, 0.5), // 字体颜色
                    ),
                  ),
                  const SizedBox(width: 8,),
                  ElevatedButton(
                    onPressed:widget.editCallback,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(38, 24),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5.0), // 调整水平和垂直间距
                      backgroundColor: const Color.fromRGBO(232, 236, 239, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0), // 设置圆角大小
                      ),

                    ),
                    child:const Text(
                      "Edit",
                      style: TextStyle(
                        fontSize: 12.0, // 字体大小
                        color: Color.fromRGBO(35, 38, 39, 1), // 字体颜色
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
          child: SizedBox(
            height: 64,
            width:64,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0), // 设置圆角大小
              child: (widget.headimgurl?.isEmpty??true)?Image.asset('assets/images/user.png'): CachedNetworkImage(
                imageUrl: widget.headimgurl??"",
                // placeholder: (BuildContext context, String url) {
                //   return const Center(
                //       child: CircularProgressIndicator()
                //   );
                // },
              ),
            ),
          )
          ,
        ),
      ],
    );
    return a;
  }
}
