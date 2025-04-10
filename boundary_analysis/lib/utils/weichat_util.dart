//
//
//
// import 'package:fluwx/fluwx.dart';
//
// import 'icx_logger.dart';
//
//
// typedef isInstalled=void Function(bool isInstalled);
// // typedef isInstalled=void Function(bool isInstalled);
//
// class WechatUtil{
//
//
//
//
//
//
//
//
//   //
//   // void _addSubscriber(){
//   //   // 点击微信认证页面的  允许 和拒绝 还有没有登录微信时候返回按钮 才会调用
//   //   _fluwx.addSubscriber((resp) {
//   //     if (resp is WeChatAuthResponse) {
//   //       ICXLogger.d("微信登录认证监听回调");
//   //       if (resp.isSuccessful) {
//   //         switch (resp.errCode) {
//   //           case 0:
//   //             final code = resp.code; //根据code去调用接口拿去个人信息
//   //             ICXLogger.d(code);
//   //             break;
//   //           default:
//   //             break;
//   //         }
//   //       }else{
//   //         ICXLogger.d("用户在认证页面点击拒绝按钮");
//   //       }
//   //     }else{
//   //       ICXLogger.d("微信支付认证或其他认证");
//   //     }
//   //   });
//   //
//   // }
//
//   // WechatUtil._();
//   final _fluwx = Fluwx();
//
//   Future<bool> isInstalled() async{
//     final isInstalled = await _fluwx.isWeChatInstalled;
//     if (!isInstalled) {
//       ICXLogger.d("微信未安装");//隐藏微信登录按钮
//       return false;
//     } else {
//       ICXLogger.d("微信有安装");
//       return true;
//     }
//   }
//
//   static void auth() async{
//       // // 创建微信登录请求
//       final AuthType request = NormalAuth(
//         scope: "snsapi_userinfo",
//         state: "custom_state",
//       );
//       // 弹出授权页面, 允许和拒绝
//       final result = await Fluwx().authBy(which: request);
//       if (!result) {
//         ICXLogger.d("调起微信认证页面失败");
//       } else {
//         ICXLogger.d("调起微信认证页面成功");
//       }
//   }
//
//
// }