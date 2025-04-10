/*
1: 将网络请求直接放在page里面
2: 将网络请求放在vm里面,  使用static Fature方法 返回List<HomePageModel>
3: 使用状态管理 provider, 改为普通的Fature函数
4: 封装dio网络成单列
5: 添加拦截器, 对{"data":[],"errmsg":xx,"stateCode":0} 进行一成封装
6: 抽离到APi文件, 处理网络请求和返回数据解析
*/

import 'package:dio/dio.dart';
import 'interceptor/res_interceptor.dart';
import 'interceptor/print_log_interceptor.dart';
import 'http_method.dart';
class DioInstance {
  static DioInstance? _Instance;

  DioInstance._();

  static DioInstance instance() {
    return _Instance ??= DioInstance._();
  }

  Dio _dio = Dio();
  final _defaultTimeout = const Duration(seconds: 30);

  void initDio({
    required String baseUrl,
    String? method = HttpMethod.GET,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Duration? sendTimeout,
    ResponseType? responseType = ResponseType.json,
    String? contentType,
  }) async{
    _dio.options = BaseOptions(
        method: method,
        baseUrl: baseUrl,
        connectTimeout: connectTimeout ?? _defaultTimeout,
        receiveTimeout: receiveTimeout ?? _defaultTimeout,
        sendTimeout: sendTimeout ?? _defaultTimeout,
        responseType: responseType,
        contentType: contentType);
    _dio.interceptors.add(PrintLogInterceptor());
    _dio.interceptors.add(ResInterceptor());

  }

  Future<Response> get({
    required String path,
    Map<String, dynamic>? param,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    // try{
    //   return await _dio.get(path,
    //       queryParameters: param,
    //       options: options ??
    //           Options(
    //             method: HttpMethod.GET,
    //             receiveTimeout: _defaultTimeout,
    //             sendTimeout: _defaultTimeout,
    //           ),
    //       cancelToken: cancelToken);
    // }on DioException catch (e){
    //   throw Exception('网络请求失败1111: ${e.message}');
    //   return Response(requestOptions: RequestOptions());
    // }catch(e){
    //   throw Exception('网络请求失败2222: $e');
    //
    // }
    return await _dio.get(path,
        queryParameters: param,
        options: options ??
            Options(
              method: HttpMethod.GET,
              receiveTimeout: _defaultTimeout,
              sendTimeout: _defaultTimeout,
            ),
        cancelToken: cancelToken);
  }
}
