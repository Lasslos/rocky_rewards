import 'package:flutter/material.dart';
import 'package:rocky_rewards/utils/rocky_rewards.dart';
import 'package:rocky_rewards/widgets/add_reward.dart';
import 'package:rocky_rewards/widgets/home.dart';
import 'package:vrouter/vrouter.dart';

void main() {
  runApp(const MyApp());
  RockyRewardsManager.instance;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => VRouter(
    themeMode: ThemeMode.system,
    theme: ThemeData(
      brightness: Brightness.light,
      primaryColor: const Color(0xFFCC0A2D),
      primarySwatch: Colors.red
    ),
    darkTheme: ThemeData(
      brightness: Brightness.dark,
      primaryColor: const Color(0xFFCC0A2D),
        primarySwatch: Colors.red

    ),
    routes: [
      VWidget(path: '/', widget: const HomePage()),
      VWidget(path: '/add_reward', widget: AddReward(key: UniqueKey()),),
    ],
  );
}
