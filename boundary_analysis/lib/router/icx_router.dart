import 'package:boundary_analysis/chat_ai3.dart';
import 'package:boundary_analysis/pages/chat/chat_page.dart';
import 'package:boundary_analysis/pages/home/home_page.dart';
import 'package:boundary_analysis/pages/mine/mine_page.dart';
import 'package:boundary_analysis/utils/icx_logger.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../pages/tab_bar_page.dart';
import 'icx_router_path.dart';
import 'icx_not_found_page.dart';


// 封装路由管理类
class ICXRouter {

  // 路由列表
  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(
      path: ICXRouterPath.tab,
      builder: (context, state) => const TabBarPage(),
      ),
      GoRoute(
        path: ICXRouterPath.home,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: ICXRouterPath.mine,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          final params = state.extra as Map<String, dynamic>;
          ICXLogger.d(params);
          ICXLogger.d(id);
          return const MinePage();
        } ,
      ),
      GoRoute(
        path: ICXRouterPath.ai,
        builder: (context, state){
          // final String headimgurl = state.pathParameters['id']!;
          // ICXLogger.d("大厅"+headimgurl);
          final params = state.extra as Map<String, dynamic>;
          ICXLogger.d(params["headimgurl"]);
          return  MyHomePage3(headimgurl:params["headimgurl"],data_list: [],);
        },
      ),
      GoRoute(
        path: ICXRouterPath.chat,
        builder: (context, state){
          final params = state.extra as Map<String, dynamic>;
          return  ChatPage(headimgurl: params["headimgurl"],);
        },
      ),
    ],
    errorBuilder: (_, state) => const ICXNotFoundPage(),
    // redirect: 处理登录未登录逻辑
  );


  // // 路由守卫（重定向逻辑）
  // GoRouterRedirect _redirectLogic({required bool isLoggedIn}) {
  //   return (BuildContext context, GoRouterState state) {
  //     final isGoingToLogin = state.location == ICXRoutePath.login;
  //
  //     // 未登录且目标页面不是登录页 → 跳转登录
  //     if (!isLoggedIn && !isGoingToLogin) {
  //       return ICXRoutePath.login;
  //     }
  //
  //     // 已登录但目标为登录页 → 回首页
  //     if (isLoggedIn && isGoingToLogin) {
  //       return ICXRoutePath.home;
  //     }
  //
  //     // 其他情况允许正常导航
  //     return null;
  //   };
  // }

  // 静态跳转方法（无需手动获取 context）
  static void push<T>({
    required BuildContext context,
    required String path,
    Object? extra,
  }) {
    context.push(path, extra: extra);
  }

  static void go<T>({
    required BuildContext context,
    required String path,
    Object? extra,
  }) {
    context.go(path, extra: extra);
  }

  static void pop<T>(BuildContext context) {
    context.pop();
  }
}


