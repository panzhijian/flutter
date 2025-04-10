import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class ICXLogger {
  // 单例实例
  static final ICXLogger _instance = ICXLogger._internal();
  factory ICXLogger() => _instance;
  ICXLogger._internal() {
    _initLogger();
  }

  late Logger _logger;
  bool _enableLog = kDebugMode; // 默认在调试模式启用日志

  // 初始化配置
  void _initLogger() {
    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 0, // 方法调用数（默认为2）
        errorMethodCount: 5, // 错误显示的方法数
        lineLength: 120,
        colors: true,
        // printEmojis: true,
        // printTime: true, // 显示时间
      ),
    );
  }

  // 全局日志开关
  static void enableLogging(bool enable) {
    ICXLogger()._enableLog = enable;
  }

  // 各等级日志方法
  static void v(dynamic message) {
    _log(Level.verbose, message);
  }

  static void d(dynamic message) {
    _log(Level.debug, message);
  }

  static void i(dynamic message) {
    _log(Level.info, message);
  }

  static void w(dynamic message) {
    _log(Level.warning, message);
  }

  static void e(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    ICXLogger()._logger.e(message, error: error, stackTrace: stackTrace);
  }

  // 统一处理日志输出
  static void _log(Level level, dynamic message) {
    if (ICXLogger()._enableLog) {
      ICXLogger()._logger.log(level, message);
    }
  }

  // 生产环境建议禁用颜色（可选配置）
  static void configProd() {
    ICXLogger()._logger = Logger(
      printer: PrettyPrinter(
        colors: false,
        printTime: false,
      ),
    );
  }
}