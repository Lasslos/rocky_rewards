import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:rocky_rewards/rocky_rewards.dart';
import 'package:rocky_rewards/widgets/reward_list_tile.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        leading: Theme.of(context).brightness == Brightness.light
            ? Image.asset('assets/icon_white.png', height: 41,)
            : Image.asset('assets/icon_red.png', height: 41,),
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
              AddReward(),
              LastRewards(),
            ],
          ),
        ),
      ),
  );
}

class CurrentPoints extends StatelessWidget {
  const CurrentPoints({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Card(
    child: Obx(() {
      var manager = RockyRewardsManager.instance;
      var allPoints = 0;
      var volunteerPoints = 0;
      var schoolPoints = 0;
      var communityPoints = 0;
      for (var reward in manager.rewardsList) {
        allPoints += reward.points;
        switch (reward.rewardType) {
          case RewardType.volunteer: {
            volunteerPoints += reward.points;
            break;
          }
          case RewardType.schoolActivity:{
            schoolPoints += reward.points;
            break;
          }
          case RewardType.community:{
            communityPoints += reward.points;
            break;
          }
        }
      }
      var initialized = RockyRewardsManager.instance.initialized.value;
      var theme = Theme.of(context);
      return ListTile(
        leading: const Icon(Icons.attach_money),
        title: Row(
          children: [
            Text(
              'Current Points: ',
              style: Theme.of(context).textTheme.headline6,
            ),
            initialized ? Text(
              '$allPoints',
              style: Theme.of(context).textTheme.headline6,
            ) : Expanded(
              child: Shimmer.fromColors(
                highlightColor: theme.disabledColor,
                baseColor: theme.hintColor,
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.hintColor,
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                  height: 14,
                ),
              ),
            ),
          ],
        ),
        subtitle: Column(
          children: [
            _buildSpecificPointsRow(context, 'Volunteer', volunteerPoints, initialized),
            _buildSpecificPointsRow(context, 'School', schoolPoints, initialized),
            _buildSpecificPointsRow(context, 'Community', communityPoints, initialized)
          ],
        ),
      );
    }),
  );

  Widget _buildSpecificPointsRow(BuildContext context, String name, int points, bool initialized) =>
      Row(
        
      );
}


class AddReward extends StatelessWidget {
  const AddReward({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Card(
      child: ListTile(
        leading: const Icon(Icons.add),
        title: Text(
          'Add Reward',
          style: Theme.of(context).textTheme.headline6,
        ),
        trailing: IconButton(
          onPressed: () {
            //TODO
          },
          icon: const Icon(Icons.arrow_forward),
        ),
      )
  );
}

class LastRewards extends StatelessWidget {
  const LastRewards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 164,
    child: Card(
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 5),
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
                  var manager = RockyRewardsManager.instance;
                  var list = manager.rewardsList;
                  var theme = Theme.of(context);
                  if (!manager.initialized.value) {
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 4,
                      //TODO: Round the edges of container
                      itemBuilder: (context, index) => Shimmer.fromColors(
                        highlightColor: theme.disabledColor,
                        baseColor: theme.hintColor,
                        child: Container(
                          margin: const EdgeInsets.all(5),
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: theme.hintColor,
                                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                                ),
                                height: 20,
                                width: 100,
                                margin: const EdgeInsets.only(bottom: 10),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: theme.hintColor,
                                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                                ),
                                height: 14,
                                width: 100,
                                margin: const EdgeInsets.only(bottom: 5),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: theme.hintColor,
                                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                                ),
                                height: 14,
                                width: 100,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: theme.hintColor,
                                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                                    ),
                                    height: 14,
                                    width: 50,
                                  ),
                                  const Icon(Icons.arrow_forward),
                                ],
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

                  var itemCount = RockyRewardsManager.instance.rewardsList.length;
                  if (itemCount > 4) {
                    itemCount = 4;
                  }
                  return ListView.builder(
                    itemCount: itemCount,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return RewardListTile(reward: list[index]);
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