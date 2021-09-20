import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rocky_rewards/rocky_rewards.dart';
import 'package:rocky_rewards/widgets/reward_summary_widget.dart';

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
      body: ListView(
        children: const [
          LastRewards(),
        ],
      ),
  );
}

class LastRewards extends StatelessWidget {
  const LastRewards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>  Obx(
      () {
        if (RockyRewardsManager.instance.initialized.value) {
          List<Widget> elements = [];
          for (var reward in RockyRewardsManager.instance.rewardsList) {
            elements.add(RewardSummaryVerticalWidget(reward: reward));
          }
          return ListView(
            scrollDirection: Axis.horizontal,
            children: elements,
          );
        }
        return const CircularProgressIndicator();
      }
    );
}
