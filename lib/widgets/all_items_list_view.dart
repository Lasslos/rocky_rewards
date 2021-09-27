import 'package:date_utils/date_utils.dart' as date_utils;
import 'package:flutter/material.dart';
import 'package:rocky_rewards/utils/rocky_rewards.dart';
import 'package:rocky_rewards/widgets/reward_list_tile.dart';

class AllItemsListView extends StatelessWidget {
  const AllItemsListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var manager = RockyRewardsManager.instance;

    List<Widget> items = [];
    DateTime? lastMonth;
    for (var reward in manager.rewardsList.reversed) {
      var month = DateTime(reward.date.year, reward.date.month);
      if (month != lastMonth) {
        lastMonth = month;
        items.add(_buildDateSeparator(context, month));
      }
      items.add(HorizontalRewardListTile(reward: reward,));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rocky Rewards - All'),
      ),
      body: ListView(
        children: items,
      )
    );
  }

  Widget _buildDateSeparator(BuildContext context, DateTime date) => Container(
    padding: const EdgeInsets.all(15),
    child: Row(
      children: [
        Expanded(
          child: Container(
            color: Theme.of(context).cardColor,
            height: 1,
          ),
        ),
        Text(
          '   ${date_utils.DateUtils.formatMonth(date)}   ',
          style: Theme.of(context).textTheme.headline6,
        ),
        Expanded(
          child: Container(
            color: Theme.of(context).cardColor,
            height: 1,
          ),
        ),
      ],
    ),
  );
}
