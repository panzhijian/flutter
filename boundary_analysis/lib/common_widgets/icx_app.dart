
import 'package:boundary_analysis/router/icx_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../pages/tab_bar_page.dart';
import 'package:go_router/go_router.dart';


class ICXApp extends StatelessWidget {
  const ICXApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context , child) {
        return  GestureDetector(
          behavior: HitTestBehavior.opaque, // 确保点击事件穿透到空白区域
          onTap: () => FocusScope.of(context).unfocus(),
          child: MaterialApp.router(
            routerConfig: ICXRouter.router,
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
          ),
        );
      },
      // child: const TabBarPage(),
    );
  }
}

