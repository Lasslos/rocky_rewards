import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rocky_rewards/pdf_creator/pdf_creator.dart';
import 'package:rocky_rewards/rocky_rewards/rocky_rewards.dart';
import 'package:rocky_rewards/widgets/reward_creator.dart';
import 'package:rocky_rewards/widgets/settings_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:rocky_rewards/widgets/reward_list_tile.dart';
import 'package:rocky_rewards/rocky_rewards/rocky_rewards_manager.dart'
    as rocky_rewards_manager;
import 'package:date_utils/date_utils.dart' as date_utils;
import 'package:month_picker_dialog/month_picker_dialog.dart';

import '../main.dart';
import 'all_items_list_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Image.asset(
            Theme.of(context).brightness == Brightness.light
                ? 'assets/icon_white.png'
                : 'assets/icon_red.png',
            height: 41,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsPage(),
                  ));
            },
            icon: const Icon(
              Icons.settings,
            ),
          ),
        ],
        title: const Text('Rocky Rewards'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              CurrentPoints(),
              LastRewards(),
              AllRewards(),
              ExportMonth(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var reward = await createRockyReward(context);
          if (reward != null) {
            rocky_rewards_manager.rewardsList.add(reward);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class CurrentPoints extends StatelessWidget {
  const CurrentPoints({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Obx(() {
        var initialized = rocky_rewards_manager.initialized.value;
        var theme = Theme.of(context);

        return SizedBox(
          height: 92,
          child: Card(
            child: initialized
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildSpecificPointsColumn(context, RewardType.volunteer),
                      _buildSpecificPointsColumn(context, RewardType.school),
                      _buildSpecificPointsColumn(context, RewardType.community),
                      _buildAllPointsColumn(context),
                    ],
                  )
                : Shimmer.fromColors(
                    period: const Duration(milliseconds: 1400),
                    highlightColor: theme.scaffoldBackgroundColor,
                    baseColor: theme.hintColor,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 25),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: 20,
                            decoration: BoxDecoration(
                              color: theme.hintColor,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                            ),
                          ),
                          Container(
                            height: 20,
                            decoration: BoxDecoration(
                              color: theme.hintColor,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        );
      });

  Widget _buildAllPointsColumn(BuildContext context) => Obx(() {
        var icon =
            const Text('Σ', style: TextStyle(color: primary, fontSize: 24));

        int points = rocky_rewards_manager.rewardsList.fold(
            0, (previousValue, element) => previousValue + element.points);

        return Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(5),
                child: icon,
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: Text(points.toString()),
              ),
            ],
          ),
        );
      });
  Widget _buildSpecificPointsColumn(BuildContext context, RewardType type) =>
      Obx(() {
        var icon = _buildTypeSpecifiedIcon(type);

        int points = rocky_rewards_manager.rewardsList.fold(
          0,
          (previousValue, element) => element.rewardType == type
              ? previousValue + element.points
              : previousValue,
        );

        return Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(5),
                child: icon,
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: Text(points.toString()),
              ),
            ],
          ),
        );
      });

  Icon _buildTypeSpecifiedIcon(RewardType rewardType) {
    late IconData iconData;
    switch (rewardType) {
      case RewardType.volunteer:
        iconData = Icons.volunteer_activism;
        break;
      case RewardType.school:
        iconData = Icons.school;
        break;
      case RewardType.community:
        iconData = Icons.group;
        break;
    }
    return Icon(
      iconData,
      color: primary,
    );
  }
}

class LastRewards extends StatelessWidget {
  const LastRewards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        constraints: const BoxConstraints(
          minHeight: 176,
          maxHeight: 189,
        ),
        child: Card(
          child: Container(
            padding:
                const EdgeInsets.only(top: 15, left: 15, bottom: 5, right: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 2.5),
                  child: Row(
                    children: [
                      const Icon(Icons.access_time),
                      Container(
                        margin: const EdgeInsets.only(left: 35),
                        child: Text(
                          'Last Rewards',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Obx(() {
                      var list =
                          rocky_rewards_manager.rewardsList.reversed.toList();
                      var theme = Theme.of(context);
                      if (!rocky_rewards_manager.initialized.value) {
                        return Shimmer.fromColors(
                          period: const Duration(milliseconds: 1400),
                          highlightColor: theme.scaffoldBackgroundColor,
                          baseColor: theme.hintColor,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 4,
                            itemBuilder: (context, index) => Container(
                              margin: const EdgeInsets.all(5),
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: theme.hintColor,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20)),
                                    ),
                                    height: 20,
                                    width: 100,
                                    margin: const EdgeInsets.only(
                                        bottom: 5, top: 5),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: theme.hintColor,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20)),
                                    ),
                                    height: 14,
                                    width: 100,
                                    margin: const EdgeInsets.only(
                                        bottom: 2.5, top: 2.5),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: theme.hintColor,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20)),
                                    ),
                                    height: 14,
                                    width: 100,
                                  ),
                                  TextButton(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: theme.hintColor,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(20)),
                                          ),
                                          height: 14,
                                          width: 50,
                                        ),
                                        const Icon(Icons.arrow_forward),
                                      ],
                                    ),
                                    onPressed: () {},
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                      if (list.isEmpty) {
                        return const Text('Nothing here. Do something!');
                      }

                      var itemCount = rocky_rewards_manager.rewardsList.length;
                      if (itemCount > 4) {
                        itemCount = 4;
                      }
                      return ListView.builder(
                        itemCount: itemCount,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return VerticalListTile(
                            reward: list[index],
                          );
                        },
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

class AllRewards extends StatelessWidget {
  const AllRewards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Card(
        child: ListTile(
          leading: const Icon(Icons.clear_all),
          title: const Text('All Rewards'),
          trailing: IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AllRewardsListView(),
                  ));
            },
          ),
        ),
      );
}

class ExportMonth extends StatelessWidget {
  const ExportMonth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Card(
        child: ListTile(
          leading: const Icon(
            Icons.import_export,
          ),
          title: const Text('Export Month'),
          trailing: IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () async {
              var prefs = await SharedPreferences.getInstance();
              if (!(prefs.containsKey('firstName') &&
                      prefs.containsKey('lastName') &&
                      prefs.containsKey('school')) ||
                  prefs.getString('firstName')!.isEmpty ||
                  prefs.getString('lastName')!.isEmpty ||
                  prefs.getString('school')!.isEmpty) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingsPage(),
                    ));
                return;
              }

              var month = await showMonthPicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now().subtract(const Duration(days: 365)),
                lastDate: DateTime.now(),
              );
              if (month == null) {
                return;
              }
              var firstName = prefs.getString('firstName')!;
              var lastName = prefs.getString('lastName')!;
              var school = prefs.getString('school')!;
              writeAndOpenPDF(
                context,
                await createPDFBytes(month, firstName, lastName, school),
                '${date_utils.DateUtils.apiDayFormat(month).substring(0, 7)}'
                        '_output.pdf'
                    .replaceAll(' ', '_')
                    .toLowerCase(),
              );
            },
          ),
        ),
      );
}
