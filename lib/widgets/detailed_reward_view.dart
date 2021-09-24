import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/string_extensions.dart';
import 'package:rocky_rewards/utils/rocky_rewards.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:vrouter/vrouter.dart';
import 'package:date_utils/date_utils.dart' as date_utils;

class DetailedRewardView extends StatelessWidget {
  const DetailedRewardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int id = int.tryParse(context.vRouter.pathParameters['id'] ?? '0') ?? 0;
    RockyReward reward = RockyRewardsManager.instance.rewardsList[id];

    var theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rocky Rewards - Detailed View'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.all(15),
            child: Center(
              child: ListTile(
                leading: const Icon(Icons.calendar_today),
                title: Text(dateTimeToString(reward.date)),
              ),
            ),
          ),

          Container(
            margin: const EdgeInsets.all(15),
            child: Center(
              child: ToggleSwitch(
                minWidth: (MediaQuery.of(context).size.width - 50),
                totalSwitches: 1,
                labels: [
                  reward.rewardType.toString()
                      .replaceFirst('$RewardType.', '')
                      .capitalizeFirst!
                ],
              ),
            ),
          ),

          Container(
            margin: const EdgeInsets.only(left: 20, bottom: 20, right: 20),
            child: Center(
              child: TextField(
                controller: TextEditingController(text: reward.groupName),
                decoration: const InputDecoration(
                  labelText: "Name of Organization, Team or Club",
                ),
                enabled: false,
              ),
            ),
          ),

          Container(
            margin: const EdgeInsets.only(left: 20, bottom: 20, right: 20),
            child: Center(
              child: TextField(
                controller: TextEditingController(text: reward.description),
                decoration: const InputDecoration(
                  labelText: "Description",
                ),
                enabled: false,
              ),
            ),
          ),

          Container(
            margin: const EdgeInsets.all(5),
            child: Center(
              child: ToggleSwitch(
                minWidth: (MediaQuery
                    .of(context)
                    .size
                    .width - 50),
                animate: true,
                totalSwitches: 1,
                labels: [
                  reward.attendance.toString()
                      .replaceFirst('$AttendanceType.', '')
                      .capitalizeFirst!,
                ],
              ),
            ),
          ),

          if (reward.hoursOrNumberOfGames != null) Container(
            margin: const EdgeInsets.all(5),
            child: Center(
              child: ListTile(
                title: Text(
                  '${reward.hoursOrNumberOfGames} Hour(s) or game(s)'
                ),
              ),
            ),
          ),

          Container(
            margin: const EdgeInsets.only(top: 5, left: 20, right: 20, bottom: 20),
            child: Text('${reward.points} Point(s)', style: theme.textTheme.subtitle1),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            child: Text('Signature of responsible person', style: theme.textTheme.subtitle1),
          ),
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Colors.white,
            ),
            margin: const EdgeInsets.all(10),
            child: reward.signature.getWidget(),
          ),

          Container(
            margin: const EdgeInsets.only(left: 10, bottom: 10, right: 10),
            child: Center(
              child: TextField(
                controller: TextEditingController(text: reward.phone),
                decoration: const InputDecoration(
                  labelText: "Phone number of responsible person",
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String dateTimeToString(DateTime dateTime) =>
      date_utils.DateUtils.formatFirstDay(dateTime);
}
