import 'package:date_utils/date_utils.dart' as date_utils;
import 'package:flutter/material.dart';
import 'package:rocky_rewards/utils/rocky_rewards.dart';
import 'package:vrouter/vrouter.dart';

class RewardListTile extends StatelessWidget {
  final RockyReward reward;
  final Axis scrollDirection;

  const RewardListTile(
      {Key? key, required this.reward, this.scrollDirection = Axis.vertical})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (scrollDirection == Axis.vertical) {
      return _buildHorizontalTile(context);
    }
    return _buildVerticalTile(context);
  }

  Widget _buildHorizontalTile(BuildContext context) =>
      ListTile(
        leading: _buildTypeSpecifiedIcon(),
        title: Text(
          reward.groupName,
        ),
        subtitle: Text(
          '${reward.description} - ${dateTimeToString(reward.date)}',
        ),
        trailing: IconButton(
          onPressed: () {
            onPressed(context);
          },
          icon: const Icon(Icons.arrow_forward),
        ),
      );

  Widget _buildVerticalTile(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      child: Column(
        children: [
          Container(
            height: 20,
            margin: const EdgeInsets.only(bottom: 5, top: 5),
            child: Text(reward.groupName, style: const TextStyle(fontSize: 20)),
          ),
          Container(
            height: 14,
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
            height: 14,
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
  }

  void onPressed(BuildContext context) {
    context.vRouter.to(
        '/detailed_view/'
            '${RockyRewardsManager.instance.rewardsList.indexOf(reward)}');
  }
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
    return Icon(iconData, color: const Color(0xFFCC0A2D),);
  }

  String dateTimeToString(DateTime dateTime) =>
      date_utils.DateUtils.formatFirstDay(dateTime);

}