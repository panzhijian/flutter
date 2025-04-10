import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ICXConsumer<T> extends StatelessWidget {
  final Widget Function(BuildContext context, T model, Widget? child) builder;

  const ICXConsumer({
    super.key,
    required this.builder,
    Widget? child,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<T>(
      builder: (context, model, child) => builder(context, model,child),
    );
  }
}