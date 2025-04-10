import 'package:dio/dio.dart';

import '../utils/icx_logger.dart';

/// 网络请求结果封装类
class HttpResult<T> {
  final bool success;
  final T? data;
  final String? error;

  HttpResult.success(this.data)
      : success = true, error = null;

  HttpResult.failure(this.error)
      : success = false, data = null;

  @override
  String toString() {
    return 'HttpResult{success: $success, data: $data, error: $error}';
  }
}

/// Dio单例封装类
class DioUtil {
  // 单例实例
  static final DioUtil _instance = DioUtil._internal();
  late final Dio _dio;

  // 工厂构造函数
  factory DioUtil() {
    return _instance;
  }

  // 内部构造函数
  DioUtil._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: 'https://www.wanandroid.com/', // 替换你的基础URL
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ));

    // 添加日志拦截器（可选）
    _dio.interceptors.add(LogInterceptor(
      request: true,
      requestBody: true,
      responseBody: true,
    ));
  }

  /// 获取Dio实例（按需暴露）
  Dio get dio => _dio;

  /// 封装GET请求
  Future<HttpResult<T>> get<T>(
      String path, {
        Map<String, dynamic>? queryParameters,
        Options? options,
      }) async {
    try {
      final response = await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return HttpResult.success(response.data);
    } on DioException catch (e) {
      // 处理Dio特有错误
      final errorMessage = e.response?.statusMessage ?? e.message ?? '网络请求失败';
      return HttpResult.failure(errorMessage);
    } catch (e) {
      // 处理其他异常
      return HttpResult.failure('未知错误: $e');
    }
  }
}

// 使用示例
void main() async {
  final dioUtil = DioUtil();

  // 发起GET请求
  final result = await dioUtil.get('/banner/json', queryParameters: {
    'userId': 123
  });
  if (result.success) {
    ICXLogger.d('请求成功: ${result.data}');
  } else {
    ICXLogger.d('请求失败: ${result.error}');
  }
}