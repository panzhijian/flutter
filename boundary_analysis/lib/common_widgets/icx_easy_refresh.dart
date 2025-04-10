import 'package:flutter/material.dart';
import 'package:easy_refresh/easy_refresh.dart';

// 定义刷新和加载回调类型
typedef OnRefreshCallback = Future<void> Function();
typedef OnLoadMoreCallback = Future<void> Function();

/// 自定义易用刷新组件，封装了EasyRefresh的基本功能
/// [child] 需要包裹的可滚动内容组件
/// [enableLoadMore] 是否启用上拉加载功能
/// [onRefresh] 下拉刷新回调函数
/// [onLoad] 上拉加载回调函数
/// [header] 自定义顶部刷新指示器
/// [footer] 自定义底部加载指示器
class ICXEasyRefresh extends StatefulWidget {
  final Widget child;
  final bool enableLoadMore;
  final OnRefreshCallback? onRefresh;
  final OnLoadMoreCallback? onLoad;
  final Header? header;
  final Footer? footer;
  final EasyRefreshController? controller; // 刷新控制器

  const ICXEasyRefresh({
    super.key,
    required this.child,
    required this.controller,
    this.enableLoadMore = true,
    this.onRefresh,
    this.onLoad,
    this.header,
    this.footer,
  });

  @override
  State<ICXEasyRefresh> createState() => _ICXEasyRefreshState();
}

class _ICXEasyRefreshState extends State<ICXEasyRefresh> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// 处理下拉刷新逻辑
  // Future<void> _handleRefresh() async {
  //   print("下拉下拉");
  //   if (_isLoading) return; // 防止重复请求
  //   _isLoading = true;
  //   try {
  //     await widget.onRefresh?.call(); // 执行外部传入的刷新逻辑
  //     _controller.finishRefresh(); // 通知刷新完成
  //     _controller.resetFooter(); // 重置底部加载状态
  //   } finally {
  //     _isLoading = false;
  //   }
  // }

  /// 处理上拉加载逻辑
  // Future<void> _handleLoad() async {
  //   print("上拉上拉");
  //
  //   if (_isLoading || _noMoreData) return; // 防止重复请求或无更多数据时加载
  //   _isLoading = true;
  //   try {
  //     await widget.onLoad?.call(); // 执行外部传入的加载逻辑
  //     _controller.finishLoad(IndicatorResult.success); // 通知加载成功
  //   } finally {
  //     _isLoading = false;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return EasyRefresh(
      controller: widget.controller,
      header: widget.header ?? const ClassicHeader(), // 使用默认头部指示器
      footer: widget.footer ?? const ClassicFooter(), // 使用默认底部指示器
      onRefresh: widget.onRefresh , // 绑定刷新回调
      onLoad: widget.onLoad , // 条件绑定加载回调
      child: widget.child,
    );
  }
}













/// 刷新功能示例页面
class RefreshDemo extends StatefulWidget {
  const RefreshDemo({super.key});

  @override
  State<RefreshDemo> createState() => _RefreshDemoState();
}

class _RefreshDemoState extends State<RefreshDemo> {
  late EasyRefreshController _controller;
  final List<String> _items = []; // 数据列表
  int _page = 1; // 分页计数器

  /// 加载数据方法
  /// [isRefresh] 是否为刷新操作（重置分页）
  Future<void> _loadData({bool isRefresh = false}) async {
    // 模拟2秒网络延迟
    await Future.delayed(const Duration(seconds: 2));

    if (isRefresh) {
      // 刷新时清空数据并重置分页
      _items.clear();
      _page = 1;
    }

    // 生成模拟数据（每页20条）
    final newItems = List.generate(20, (index) => 'Item ${_page * 20 + index}');
    _items.addAll(newItems);
    _page++; // 分页递增

    setState(() {});
  }
  @override
  void initState() {
    super.initState();
    _controller = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Refresh Demo')),
      body: ICXEasyRefresh(
        controller: _controller,
        // 绑定刷新回调
        onRefresh: () async{
          await _loadData(isRefresh: true);
          _controller.finishRefresh();
          // easyRefreshC.resetFooter();
        },
        // 绑定加载更多回调
        onLoad: () async{
          await _loadData(isRefresh: true);
          _controller.finishLoad();
        },        // 列表内容
        child: ListView.builder(
          itemCount: _items.length,
          itemBuilder: (context, index) {
            return ListTile(title: Text(_items[index]));
          },
        ),
      ),
    );
  }
}

/// 主要实现细节说明：
/// 1. 状态管理：使用_isLoading防止重复请求，_noMoreData标记数据加载完成状态
/// 2. 控制器使用：通过EasyRefreshController精确控制刷新/加载的完成状态
/// 3. 异常处理：使用try-finally确保加载状态重置
/// 4. 灵活配置：支持自定义头部/底部指示器，可开关加载功能
/// 5. 分页逻辑：示例中通过_page计数器实现简单分页，实际使用时需要结合接口返回的分页信息
/// 
/// 注意事项：
/// - 实际业务中需要在加载回调中处理网络异常情况
/// - 当数据加载完成后，应设置_noMoreData = true并调用_controller.finishLoad(IndicatorResult.noMore)
/// - 列表内容需要支持滚动（如ListView/GridView/CustomScrollView等）