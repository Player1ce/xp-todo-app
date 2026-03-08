
import 'package:flutter/material.dart';

class MyDemoHomePage extends StatefulWidget {
  const MyDemoHomePage({super.key});

  @override
  State<MyDemoHomePage> createState() => _MyDemoHomePageState();
}

class _MyDemoHomePageState extends State<MyDemoHomePage> {
  final int _counter = 0;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('You have pushed the button this many times:'),
          Text('$_counter', style: Theme.of(context).textTheme.headlineMedium),
        ],
      ),
    );
  }
}
