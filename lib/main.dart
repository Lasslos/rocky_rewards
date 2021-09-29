import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rocky_rewards/utils/rocky_rewards.dart';
import 'package:rocky_rewards/widgets/home_page.dart';

const Color primary = Color(0xFFCC0A2D);

void main() {
  runApp(const MyApp());
  RockyRewardsManager.instance;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
    themeMode: ThemeMode.system,
    theme: ThemeData(
      brightness: Brightness.light,
      primaryColor: primary,
      primarySwatch: Colors.red,
    ),
    darkTheme: ThemeData(
      brightness: Brightness.dark,
      primaryColor: primary,
      primarySwatch: Colors.red,
    ),
    home: const HomePage(),
  );
}
