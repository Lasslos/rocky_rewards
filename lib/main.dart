import 'package:flutter/material.dart';
import 'package:rocky_rewards/rocky_rewards.dart';
import 'package:rocky_rewards/widgets/home.dart';
import 'package:vrouter/vrouter.dart';

void main() {
  runApp(const MyApp());
  RockyRewardsManager.instance;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => VRouter(
    themeMode: ThemeMode.system,
    theme: ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.red,
    ),
    darkTheme: ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.red
    ),
    routes: [
      VWidget(path: '/', widget: const HomePage())
    ],
  );
}
