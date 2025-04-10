
import 'package:boundary_analysis/pages/home/home_page.dart';
import 'package:boundary_analysis/pages/fourth_page.dart';
import 'package:boundary_analysis/pages/sencond_page.dart';
import 'package:boundary_analysis/pages/third_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';




class TabBarPage extends StatefulWidget {
  const TabBarPage({super.key});

  @override
  State<TabBarPage> createState() => _TabBarPageState();
}

class _TabBarPageState extends State<TabBarPage> {
  int _currentIndex=0;
  final List<Widget> tabBarItems=[];
  final List<String> tabLabels = ["首页", "test2", "test3", "我的"];
  final List<String> tabIcons = [
    "assets/images/icon_home_grey.png",
    "assets/images/icon_hot_key_grey.png",
    "assets/images/icon_knowledge_grey.png",
    "assets/images/icon_personal_grey.png"
  ];
  final List<String> tabActiveIcons = [
    "assets/images/icon_home_selected.png",
    "assets/images/icon_hot_key_selected.png",
    "assets/images/icon_knowledge_selected.png",
    "assets/images/icon_personal_selected.png"
  ];
  ///State生命周期，在组件渲染前回调
  @override
  void initState() {
    super.initState();
    initTabPage();
  }

  void initTabPage() {
    tabBarItems.add( HomePage());
    tabBarItems.add(const SecondPage());
    tabBarItems.add(const ThirdPage());
    tabBarItems.add(const FourthPage());
  }
  ///底部导航栏集合
  List<BottomNavigationBarItem> _barItemList() {
    List<BottomNavigationBarItem> items = [];
    for (var i = 0; i < tabBarItems.length; i++) {
      items.add(BottomNavigationBarItem(
          activeIcon: Image.asset(
            tabActiveIcons[i],
            width: 26.w,
            height: 26.h,
          ),
          icon: Image.asset(
            tabIcons[i],
            width: 26.w,
            height: 26.h,
          ),
          label: tabLabels[i]));
    }
    return items;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // body: IndexedStack(
      //   index: _index,
      //   children: tabBarItems,
      // ),
      body: tabBarItems[_currentIndex],//不会同时初始化4个page ,按需加载,但是每次都会执行page的build方法
      bottomNavigationBar: Theme(
          data: ThemeData(
            // brightness: Brightness.light,
            // splashColor: Colors.transparent,
            // highlightColor: Colors.transparent,
            // 去掉水波纹效果
            splashFactory: NoSplash.splashFactory,  // 替换这里
            // 去掉点击效果
            highlightColor: Colors.transparent,
          ),
        child: BottomNavigationBar (
          unselectedItemColor: Colors.black45,
          selectedItemColor: Colors.black, // 选中时
          selectedFontSize: 12.sp,
          unselectedFontSize: 12.sp,
          type:BottomNavigationBarType.fixed,
          items:_barItemList(),
          currentIndex: _currentIndex,
          onTap: (index) async{
            //重复事件不处理
            if (_currentIndex == index) {
              return;
            }
            // 触发反馈后执行操作
            await HapticFeedback.lightImpact();

            setState(() {
              _currentIndex=index;
            });
          },
        ),
      ) ,
    );
  }
}
