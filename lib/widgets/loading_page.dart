import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingBuilder extends StatelessWidget {
  final Future<Widget> Function(BuildContext context) builder;
  final Duration minimumLoadingTime;

  const LoadingBuilder({
    Key? key,
    required this.builder,
    this.minimumLoadingTime = const Duration(seconds: 1)}) : super(key: key);

  Future<Widget> _buildChild(BuildContext context) async {
    var futureWidget = builder(context);
    await Future.delayed(minimumLoadingTime);
    Widget widget;
    try {
      widget = await futureWidget;
    } catch (e) {
      widget = const Scaffold(
        body: Center(
          child: Text('Something in #LoadingPage.builder went wrong.'),
        ),
      );
    }
    return widget;
  }

  @override
  Widget build(BuildContext context) {
    _buildChild(context);
    return FutureBuilder<Widget>(
      future: _buildChild(context),
      initialData: const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ), 
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(
              child: Text('Something in #LoadingPage._buildChild went wrong.'),
            ),
          );
        }
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return snapshot.data;
      },
    );
  }
}