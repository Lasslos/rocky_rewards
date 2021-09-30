import 'package:date_utils/date_utils.dart' as date_utils;
import 'package:flutter/material.dart';
import 'package:rocky_rewards/main.dart';
import 'package:rocky_rewards/utils/rocky_rewards.dart';
import 'package:rocky_rewards/widgets/detailed_reward_view.dart';

import 'edit_view.dart';

class HorizontalRewardListTile extends StatelessWidget {
  final RockyReward reward;

  const HorizontalRewardListTile({Key? key, required this.reward})
      : super(key: key);

  @override
  Widget build(BuildContext context) => ListTile(
        leading: _buildTypeSpecifiedIcon(),
        title: Text(
          reward.groupName,
        ),
        subtitle: Text(
          '${reward.description} - ${dateTimeToString(reward.date)}',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditRewardView(
                              reward: reward,
                            )),
                  );
                },
                icon: const Icon(Icons.edit)),
            IconButton(
              onPressed: () {
                onPressed(context);
              },
              icon: const Icon(Icons.arrow_forward),
            ),
          ],
        ),
      );

  void onPressed(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailedRewardView(reward: reward),
        ));
  }

  String dateTimeToString(DateTime dateTime) =>
      date_utils.DateUtils.formatFirstDay(dateTime);

  Icon _buildTypeSpecifiedIcon() {
    late IconData iconData;
    switch (reward.rewardType) {
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

class VerticalListTile extends StatelessWidget {
  final RockyReward reward;

  const VerticalListTile({Key? key, required this.reward}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.all(5),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 5, top: 5),
              child:
                  Text(reward.groupName, style: const TextStyle(fontSize: 20)),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 2.5, top: 2.5),
              child: Text(
                reward.description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            SizedBox(
              child: Text(
                dateTimeToString(reward.date),
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            TextButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  SizedBox(
                    height: 14,
                    child: Text(
                      'View more',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Icon(Icons.arrow_forward),
                ],
              ),
              onPressed: () {
                onPressed(context);
              },
            ),
          ],
        ),
      );

  void onPressed(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailedRewardView(reward: reward),
        ));
  }

  String dateTimeToString(DateTime dateTime) =>
      date_utils.DateUtils.formatFirstDay(dateTime);
}
