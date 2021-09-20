import 'package:flutter/material.dart';
import 'package:rocky_rewards/rocky_rewards.dart';

class RewardSummaryHorizontalWidget extends StatelessWidget {
  final RockyReward reward;
  const RewardSummaryHorizontalWidget({Key? key, required this.reward}) : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Column(
        children: [
          Text(
            reward.groupName,
            style: Theme.of(context).textTheme.headline4,
          ),
          Text(
            reward.description,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
      IconButton(
          onPressed: () {

          },
          icon: const Icon(Icons.arrow_forward),
      ),
    ],
  );
}

class RewardSummaryVerticalWidget extends StatelessWidget {
  final RockyReward reward;
  const RewardSummaryVerticalWidget({Key? key, required this.reward}) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(
        reward.groupName,
        style: Theme.of(context).textTheme.headline4,
      ),
      Text(
        reward.description,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      TextButton(
        onPressed: () {

        },
        child: Row(
          children: const [
            Text('View More'),
            Icon(Icons.arrow_forward)
          ],
        ),
      )
    ],
  );
}
