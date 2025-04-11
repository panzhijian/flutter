import 'dart:convert';

import 'package:boundary_analysis/common_widgets/icx_consumer.dart';
import 'package:boundary_analysis/common_widgets/icx_change_notifier_provider.dart';
import 'package:boundary_analysis/router/icx_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fluwx/fluwx.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../router/icx_router_path.dart';
import '../../utils/icx_logger.dart';
import '../../utils/network_manager.dart';
import 'home_page_vm.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Fluwx _fluwx = Fluwx();
  final HomePageVM vm = HomePageVM();

  @override
  void initState() {
    super.initState();
    _addSubscriber();



  }

  void _addSubscriber() {
    // 点击微信认证页面的  允许 和拒绝 还有没有登录微信时候返回按钮 才会调用
    _fluwx.addSubscriber((resp) {
      if (resp is WeChatAuthResponse) {
        ICXLogger.d("微信登录认证监听回调");
        if (resp.isSuccessful) {
          switch (resp.errCode) {
            case 0:
              final code = resp.code; //根据code去调用接口拿去个人信息
              vm.fetchWeChatUserInfo(code);
              ICXLogger.d(code);
              break;
            default:
              break;
          }
        } else {
          ICXLogger.d("用户在认证页面点击拒绝按钮");
        }
      } else {
        ICXLogger.d("微信支付认证或其他认证");
      }
    });
  }

  void _weixinLogin() async {
    final isInstalled = await _fluwx.isWeChatInstalled;
    if (!isInstalled) {
      ICXLogger.d("微信未安装"); //隐藏微信登录按钮
      return;
    } else {
      ICXLogger.d("微信有安装");
      // // 创建微信登录请求
      final AuthType request = NormalAuth(
        scope: "snsapi_userinfo",
        state: "custom_state", // 可选参数（如不需要可删除）
      );
      // 弹出授权页面, 允许和拒绝
      final result = await Fluwx().authBy(which: request);
      if (!result) {
        ICXLogger.d("调起微信认证页面失败");
      } else {
        ICXLogger.d("调起微信认证页面成功");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    // ICXLogger.d("网络情况"+context.read<NetworkManager>().connectionStatus.toString());
    return ICXChangeNotifierProvider<HomePageVM>(
      create: () => vm,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("首页"),
          // backgroundColor: Colors.blueGrey,
        ),
        backgroundColor: Colors.white,
        body: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    // context.push("/mine/"+"456");
                    // context.push(ICXRouterPath.mine.replaceFirst(":id", "123"),extra: {'name': 'Alice', 'age': 30});

                    // context.push(ICXRouterPath.ai,extra: {'headimgurl':  vm.wechatUserInfo?.headimgurl??""});
                    context.push(ICXRouterPath.chat,extra: {'headimgurl':  vm.wechatUserInfo?.headimgurl??""});

                    // ICXRouter.push(
                    //   context: context,
                    //   path: ICXRouterPath.ai.replaceFirst(':headimgurl', vm.wechatUserInfo?.headimgurl??""),
                    //   extra: {'title': 'Demo'}, // 传递附加参数
                    // );
                  },
                  child: const Text("AI 问答")),
              ElevatedButton(
                  onPressed: () async {
                    _weixinLogin();
                  },
                  child: const Text("微信登录")),
              ICXConsumer<HomePageVM>(builder: (context, vm, child) {
                return vm.wechatUserInfo?.headimgurl != null
                    ? CachedNetworkImage(
                        imageUrl: vm.wechatUserInfo?.headimgurl ?? "",
                        placeholder: (BuildContext context, String url) {
                          return const Center(
                              child: CircularProgressIndicator());
                        },
                      )
                    : Icon(Icons.image_not_supported);
              }),
              // Image.asset('assets/images/Avatar.png',
              //   width: 72,
              //   height: 72,
              // ),
              // Image(image: AssetImage('assets/images/Avatar.png')),

    ],
          ),
        ),
      ),
    );
  }
}

// @override
// Widget build(BuildContext context) {
//   ICXLogger.d("1111111");
//   return ICXChangeNotifierProvider<HomePageVM>(
//       create: () => HomePageVM(),
//       child: ICXConsumer(builder: (context, vm) {
//         return Column(
//           children: [
//             ElevatedButton(onPressed: (){
//
//             }, child: Text("AI 问答")),
//             ElevatedButton(onPressed: (){
//
//             }, child: Text("微信登录")),
//           ],
//         );
//       }));
// }
