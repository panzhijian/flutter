
import 'dart:developer';
import 'package:dio/dio.dart';
import '../base_model.dart';

class ResInterceptor extends Interceptor{


  // 统一处理成功和失败,不是交给每个请求接口, 如果那样的话, 直接返回最原始的json就好了
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // log("${response.statusCode}");
    // log("${response.data}");
    if (response.statusCode == 200) {
      var res=BaseModel.fromJson(response.data);
      if (res.errorCode==0){
        handler.next(Response(requestOptions: response.requestOptions,data: res.data));
      }else{
        handler.reject(DioException(requestOptions: response.requestOptions));
      }
    }else{
      handler.reject(DioException(requestOptions: response.requestOptions));
    }
    // super.onResponse(response, handler);
  }



}