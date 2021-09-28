import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rocky_rewards/utils/rocky_rewards.dart';
import 'package:rocky_rewards/widgets/add_reward_page.dart';
import 'package:rocky_rewards/widgets/all_items_list_view.dart';
import 'package:rocky_rewards/widgets/detailed_reward_view.dart';
import 'package:rocky_rewards/widgets/home_page.dart';
import 'package:rocky_rewards/widgets/loading_page.dart';
import 'package:vrouter/vrouter.dart';

const Color primary = Color(0xFFCC0A2D);

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
          primaryColor: primary,
          primarySwatch: Colors.red,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: primary,
          primarySwatch: Colors.red,
        ),
        routes: [
          VWidget(
            path: '/',
            widget: const HomePage(),
            stackedRoutes: [
              VWidget.builder(
                path: 'add_reward',
                builder: (BuildContext context, VRouterData data) =>
                    LoadingBuilder(
                  builder: (BuildContext context) => SynchronousFuture(
                    AddReward(key: GlobalKey()),
                  ),
                ),
              ),
              VWidget(path: 'all_items', widget: const AllItemsListView()),
              VWidget(
                  path: 'detailed_view/:id',
                  widget: const DetailedRewardView()),
            ],
          ),
        ],
      );
}
