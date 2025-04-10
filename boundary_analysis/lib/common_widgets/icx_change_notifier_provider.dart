import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

typedef TransitionBuilder = Widget Function(BuildContext context, Widget? child);


class ICXChangeNotifierProvider<T extends ChangeNotifier> extends StatelessWidget {
  final Widget? child;
  final T Function() create;
  final TransitionBuilder? builder;


  const ICXChangeNotifierProvider({
    super.key,
    required this.create,
    this.child,
    this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>(
      create: (_) => create(),
      child: child,
      builder: builder,
    );
  }
}