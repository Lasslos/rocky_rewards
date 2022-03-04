import 'package:date_utils/date_utils.dart' as date_utils;
import 'package:flutter/material.dart';
import 'package:rocky_rewards/main.dart';
import 'package:rocky_rewards/rocky_rewards/rocky_rewards.dart';
import 'package:rocky_rewards/rocky_rewards/rocky_rewards_list.dart';
import 'package:rocky_rewards/widgets/detailed_reward_view.dart';
import 'package:rocky_rewards/widgets/reward_creator.dart';

class HorizontalRewardListTile extends StatelessWidget {
  const HorizontalRewardListTile({required this.reward, Key? key})
      : super(key: key);

  final RockyReward reward;

  @override
  Widget build(BuildContext context) => ListTile(
        leading: _buildTypeSpecifiedIcon(),
        title: Text(
          reward.groupName,
        ),
        subtitle: Text(
          '${reward.description} - '
          '${date_utils.DateUtils.formatFirstDay(reward.date)}',
        ),
        onTap: () => _viewMore(context),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
                onPressed: () => edit(context),
                tooltip: 'Edit',
                icon: const Icon(Icons.edit)),
            IconButton(
              onPressed: () => _delete(context),
              tooltip: 'Delete',
              icon: const Icon(Icons.delete, color: primary),
            ),
          ],
        ),
      );

  void _delete(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Delete this reward?'),
              content: const Text('Do you really want to delete this reward? '
                  'It will not be possible to restore it.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    rewardsList.remove(reward);
                    Navigator.pop(context);
                  },
                  child: const Text('Ok', style: TextStyle(color: primary)),
                ),
              ],
            ));
  }

  Future<void> edit(BuildContext context) async {
    var editedReward = await editRockyReward(context, reward);
    rewardsList.remove(reward);
    rewardsList.add(editedReward);
  }

  void _viewMore(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailedRewardView(reward: reward),
      ),
    );
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
    return Icon(
      iconData,
      color: primary,
    );
  }
}

class VerticalListTile extends StatelessWidget {
  const VerticalListTile({required this.reward, Key? key}) : super(key: key);

  final RockyReward reward;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.all(5),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 5, top: 5),
              child: Text(
                reward.groupName,
                style: const TextStyle(fontSize: 20),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
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
                date_utils.DateUtils.formatFirstDay(reward.date),
                style: const TextStyle(
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.clip,
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailedRewardView(reward: reward),
                  ),
                );
              },
            ),
          ],
        ),
      );
}
