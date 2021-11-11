import 'package:date_utils/date_utils.dart' as date_utils;
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/string_extensions.dart';
import 'package:rocky_rewards/rocky_rewards/rocky_rewards.dart';
import 'package:toggle_switch/toggle_switch.dart';

class DetailedRewardView extends StatelessWidget {
  const DetailedRewardView({required this.reward, Key? key}) : super(key: key);
  final RockyReward reward;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rocky Rewards - Detailed View'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          ///Date of reward
          Container(
            margin: const EdgeInsets.all(15),
            child: Center(
              child: ListTile(
                leading: const Icon(Icons.calendar_today),
                title: Text(dateTimeToString(reward.date)),
              ),
            ),
          ),

          ///Reward Type
          Container(
            margin: const EdgeInsets.all(15),
            child: Center(
              child: ToggleSwitch(
                minWidth: MediaQuery.of(context).size.width - 50,
                totalSwitches: 1,
                labels: [
                  reward.rewardType
                      .toString()
                      .replaceFirst('$RewardType.', '')
                      .capitalizeFirst!
                ],
              ),
            ),
          ),

          ///Name of Organization, Team or Club
          Container(
            margin: const EdgeInsets.only(left: 20, bottom: 20, right: 20),
            child: Center(
              child: TextField(
                controller: TextEditingController(text: reward.groupName),
                decoration: const InputDecoration(
                  labelText: 'Name of Organization, Team or Club',
                ),
                enabled: false,
              ),
            ),
          ),

          ///Description
          Container(
            margin: const EdgeInsets.only(left: 20, bottom: 20, right: 20),
            child: Center(
              child: TextField(
                controller: TextEditingController(text: reward.description),
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
                enabled: false,
              ),
            ),
          ),

          ///Attendance
          Container(
            margin: const EdgeInsets.all(5),
            child: Center(
              child: ToggleSwitch(
                minWidth: MediaQuery.of(context).size.width - 50,
                animate: true,
                totalSwitches: 1,
                labels: [
                  reward.attendance
                      .toString()
                      .replaceFirst('$AttendanceType.', '')
                      .capitalizeFirst!,
                ],
              ),
            ),
          ),

          ///Hour(s) or games(s)
          Container(
            margin: const EdgeInsets.all(5),
            child: Center(
              child: ListTile(
                title:
                    Text('${reward.hoursOrNumberOfGames} Hour(s) or game(s)'),
              ),
            ),
          ),

          ///Points
          Container(
            margin:
                const EdgeInsets.only(top: 5, left: 20, right: 20, bottom: 20),
            child: Text('${reward.points} Point(s)',
                style: theme.textTheme.subtitle1),
          ),

          ///Phone number
          Container(
            margin: const EdgeInsets.only(left: 10, bottom: 10, right: 10),
            child: Center(
              child: TextField(
                controller: TextEditingController(text: reward.phone),
                decoration: const InputDecoration(
                  labelText: 'Phone number of responsible person',
                ),
                enabled: false,
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
