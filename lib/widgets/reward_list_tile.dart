import 'package:flutter/material.dart';
import 'package:rocky_rewards/utils/rocky_rewards.dart';

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
        title: Text(
          reward.groupName,
          style: Theme.of(context).textTheme.headline4,
        ),
        subtitle: Text(
          reward.description,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: IconButton(
          onPressed: onPressed,
          icon: const Icon(Icons.arrow_forward),
        ),
      );

  Widget _buildVerticalTile(BuildContext context) => Column(
    children: [
      Text(
        reward.groupName,
        style: Theme.of(context).textTheme.headline6,
      ),
      Text(
        reward.description,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Text('View more'),
          IconButton(
            onPressed: onPressed,
            icon: const Icon(Icons.arrow_forward),
          ),
        ]
      ),
    ],
  );

  void onPressed() {
    //TODO: Go to detailed view
  }
}