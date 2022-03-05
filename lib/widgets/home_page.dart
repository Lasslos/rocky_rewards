import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:rocky_rewards/backup/export_backup.dart';
import 'package:rocky_rewards/pdf_creator/pdf_creator.dart';
import 'package:rocky_rewards/rocky_rewards/rocky_rewards.dart';
import 'package:rocky_rewards/rocky_rewards/rocky_rewards_list.dart';
import 'package:rocky_rewards/widgets/reward_creator.dart';
import 'package:rocky_rewards/widgets/settings_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rocky_rewards/widgets/reward_list_tile.dart';
import 'package:date_utils/date_utils.dart' as date_utils;

import '../main.dart';
import 'all_items_list_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
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
                BackupData(),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            var reward = await createRockyReward(context);
            if (reward != null) {
              rewardsList.add(reward);
            }
          },
          child: const Icon(Icons.add),
        ),
      );
}

class CurrentPoints extends StatelessWidget {
  const CurrentPoints({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var iconTableRowWidgets = <Widget>[];
    var valueTableRowWidgets = <Widget>[];
    for (var element in RewardType.values) {
      iconTableRowWidgets.add(
        SizedBox(
          height: 46,
          child: Center(
            child: _buildTypeSpecifiedIcon(element),
          ),
        ),
      );
    }
    iconTableRowWidgets.add(const Center(
        child: Text('Σ', style: TextStyle(color: primary, fontSize: 24))));
    for (var type in RewardType.values) {
      valueTableRowWidgets.add(SizedBox(
        height: 28,
        child: Center(
          child: Obx(() {
            return Text(
              rewardsList.rx.value
                  .fold<int>(
                    0,
                    (previousValue, element) => element.rewardType == type
                        ? previousValue + element.points
                        : previousValue,
                  )
                  .toString(),
            );
          }),
        ),
      ));
    }
    valueTableRowWidgets.add(
      Obx(() {
        int points = rewardsList.rx.value.fold(
            0, (previousValue, element) => previousValue + element.points);
        return Center(child: Text(points.toString()));
      }),
    );
    return SizedBox(
      height: 92,
      child: Card(
        child: Table(
          children: [
            TableRow(children: iconTableRowWidgets),
            TableRow(children: valueTableRowWidgets),
          ],
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        ),
      ),
    );
  }

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
          maxHeight: 188,
        ),
        child: Card(
          child: Container(
            padding:
                const EdgeInsets.only(top: 15, left: 15, bottom: 10, right: 15),
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
                      var list = rewardsList.rx.value.copy.reversed.toList();
                      if (list.isEmpty) {
                        return const Text('Nothing here. Do something!');
                      }

                      var itemCount = rewardsList.rx.value.length;
                      if (itemCount > 4) {
                        itemCount = 4;
                      }
                      var children = <Widget>[];
                      for (int i = 0; i < itemCount; i++) {
                        children.add(SizedBox(
                          width: 117,
                          child: VerticalListTile(reward: list[i]),
                        ));
                      }
                      return ListView(
                        scrollDirection: Axis.horizontal,
                        children: children,
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

              var month = await showMonthYearPicker(
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

class BackupData extends StatelessWidget {
  const BackupData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Card(
        child: ListTile(
          leading: const Icon(
            Icons.backup,
          ),
          title: const Text('BackUp Data'),
          trailing: IconButton(
            icon: const Icon(
              Icons.arrow_forward,
            ),
            onPressed: () async => backup(),
          ),
        ),
      );
}
