


import 'dart:convert';

import 'package:boundary_analysis/utils/base_mode.dart';
import 'package:dio/dio.dart';

import '../../model/wechat_authorization_info.dart';
import '../../model/wechat_user_info.dart';
import '../../utils/icx_logger.dart';

class HomePageVM extends BaseModel{
  WechatUserInfo? wechatUserInfo;

  final dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  ));


  // 核心方法：通过 code 获取用户信息
  void fetchWeChatUserInfo(String? code) async {
    const appId = 'wx891598f540548c77';  // 替换实际值
    const appSecret = 'ebdc14a406dd4d605321c092fff69fd4';  // ⚠️ 危险！客户端不应存储 Secret

    try {
      // 1. 获取 access_token
      final tokenResponse = await dio.get(
        'https://api.weixin.qq.com/sns/oauth2/access_token',
        queryParameters: {
          'appid': appId,
          'secret': appSecret,
          'code': code,
          'grant_type': 'authorization_code',
        },
      );
      WechatAuthorizationInfo wechatAuthorizationInfo=WechatAuthorizationInfo.fromJson(jsonDecode(tokenResponse.data));

      // 2. 获取用户信息
      final userInfoResponse = await dio.get(
        'https://api.weixin.qq.com/sns/userinfo',
        queryParameters: {
          'access_token': wechatAuthorizationInfo.accessToken,
          'openid': wechatAuthorizationInfo.openid,
          'lang': 'zh_CN',
        },
      );
      wechatUserInfo=WechatUserInfo.fromJson(jsonDecode(userInfoResponse.data));
      ICXLogger.d(userInfoResponse.data);
      notifyListeners();


    } on DioException catch (e) {  // 处理 Dio 网络错误
      if (e.response != null) {
        throw Exception('微信接口响应错误: ${e.response?.statusCode}');
      } else {
        throw Exception('网络请求失败: ${e.message}');
      }
    } catch (e) {  // 处理其他错误
      throw Exception('获取用户信息失败: $e');
    }
  }

  // 验证微信业务错误
  void _validateWeChatResponse(Map<String, dynamic> data) {
    if (data.containsKey('errcode') && data['errcode'] != 0) {
      throw Exception('微信业务错误: ${data['errmsg']} (${data['errcode']})');
    }
  }


}