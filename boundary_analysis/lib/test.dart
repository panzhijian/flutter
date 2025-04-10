// import 'dart:convert';
//
// import 'package:fluwx/fluwx.dart';
// import 'package:get/get.dart';
// import 'package:music_flutter/constants/get_constants.dart';
// import 'package:music_flutter/http/request/request.dart';
// import 'package:music_flutter/model/model.dart';
// import 'package:music_flutter/modules/account/login/wechat_bind_phone_page.dart';
// import 'package:music_flutter/utils/toast.dart';
//
// import '../constants/constants.dart';
// import '../http/http.dart';
// import '../main.dart';
//
// class WechatUtil {
//   WechatUtil._();
//
//   static Function(WeChatPaymentResponse)? onPayResultListener;
//   static final _fluwx = Fluwx()
//     ..addSubscriber((resp) async {
//       if (resp is WeChatAuthResponse) {
//         if (resp.isSuccessful) {
//           switch (resp.errCode) {
//             case 0:
//               try {
//                 final code = resp.code;
//                 //todo 调用获取access_token 接口
//                 final appSecretResp = await HttpUtil.dio.get<String>(
//                     "${HttpUtil.baseUrl}api/app/web-site/app-secret");
//                 // 此方法可以让后端直接去调用
//                 final accessTokenResponse = await HttpUtil.dio.get(
//                     "https://api.weixin.qq.com/sns/oauth2/access_token",
//                     queryParameters: <String, dynamic>{
//                       "appid": wechatId,
//                       "secret": appSecretResp.data,
//                       "code": code,
//                       "grant_type": "authorization_code",
//                     });
//
//                 if (accessTokenResponse.data != null) {
//                   var json = jsonDecode(accessTokenResponse.data);
//                   final model = WechatAccessTokenModel.fromJson(json);
//                   // 调用自己服务端的微信登录接口完成信息获取，存储
//                   AccountRequest.wechatLogin(
//                       accessToken: model.access_token,
//                       openId: model.openid,
//                       onSucceedDeal: (m) {
//                         if (m.newUser) {
//                           Get.to(
//                                   () => WechatBindPhonePage(openId: model.openid));
//                         } else {
//                           storage.write(phoneNumber, m.phone.toString());
//                           storage.write(token, m.accessToken);
//                           Get.clearRouteTree();
//                           Get.offAll(() => const MainPage());
//                         }
//                       });
//                 }
//               } on Exception catch (_, e) {
//                 e.toString();
//               }
//               break;
//
//             default:
//               break;
//           }
//         }
//       }
//       if (resp is WeChatPaymentResponse) {
//         onPayResultListener?.call(resp);
//       }
//     });
//
// // 选择适当时机初始化
//   static void registerApi() async {
//     _fluwx.registerApi(
//       appId: wechatId,
//       //todo 添加IOS universalLink
//       universalLink: "https://xxxx.com/目录/",
//     );
//   }
// // 请求拉起登录
//   static void authBy() async {
//     final isInstall = await _fluwx.isWeChatInstalled;
//     if (isInstall) {
//       await _fluwx.authBy(
//         which: NormalAuth(
//           scope: 'snsapi_userinfo',
//           state: 'wechat_sdk_demo_test',
//         ),
//       );
//     } else {
//       toast("微信未安装");
//     }
//   }
// // 请求支付
//   static void pay(
//       PrePayIdModel m, {
//         Function(WeChatPaymentResponse)? onPayResult,
//       }) async {
//     onPayResultListener = onPayResult;
//     final isInstall = await _fluwx.isWeChatInstalled;
//     if (isInstall) {
//       await _fluwx.pay(
//         which: Payment(
//           appId: m.appId,
//           partnerId: m.partnerId,
//           prepayId: m.prepayId,
//           packageValue: m.packageValue,
//           nonceStr: m.nonceStr,
//           timestamp: int.tryParse(m.timeStamp) ?? -1,
//           sign: m.sign,
//         ),
//       );
//     } else {
//       toast("微信未安装");
//     }
//   }
//
//   static Future<bool> get wechatIsInstalled async =>
//       await _fluwx.isWeChatInstalled;
// }
