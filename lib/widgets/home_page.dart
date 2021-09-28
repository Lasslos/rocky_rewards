import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rocky_rewards/pdf_creator/pdf_creator.dart';
import 'package:shimmer/shimmer.dart';
import 'package:rocky_rewards/utils/rocky_rewards.dart';
import 'package:rocky_rewards/widgets/reward_list_tile.dart';
import 'package:vrouter/vrouter.dart';
import 'package:date_utils/date_utils.dart' as date_utils;
import 'package:month_picker_dialog/month_picker_dialog.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Theme.of(context).brightness == Brightness.light
            ? Image.asset('assets/icon_white.png', height: 41,)
            : Image.asset('assets/icon_red.png', height: 41,),
        title: const Text('Rocky Rewards - Overview'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CurrentPoints(),
              const LastRewards(),
              const AllRewards(),
              ExportMonth(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.vRouter.to('/add_reward');
        },
        child: const Icon(Icons.add),
      ),
  );
  }
}

class CurrentPoints extends StatelessWidget {
  const CurrentPoints({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      leading: const Icon(Icons.attach_money),
      title: _buildAllPointsRow(context),
      subtitle: Column(
        children: [
          _buildSpecificPointsRow(context, RewardType.volunteer),
          _buildSpecificPointsRow(context, RewardType.school),
          _buildSpecificPointsRow(context, RewardType.community)
        ],
      ),
    ),
  );

  Widget _buildAllPointsRow(BuildContext context) => Row(
    children: [
      Text(
        'Current Points: ',
        style: Theme.of(context).textTheme.headline6,
      ),
      Obx(() {
        var manager = RockyRewardsManager.instance;
        var allPoints = 0;
        for (var reward in manager.rewardsList) {
          allPoints += reward.points;
        }

        var theme = Theme.of(context);

        return manager.initialized.value ? Text(
          '$allPoints',
          style: theme.textTheme.headline6,
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
        );
      }),
    ],
  );
  Widget _buildSpecificPointsRow(BuildContext context, RewardType type) => Obx(() {
    var manager = RockyRewardsManager.instance;
    var initialized = manager.initialized.value;

    String displayName = type.toString()
        .replaceFirst(type.runtimeType.toString() + '.', '');
    displayName = displayName.replaceRange(0, 1, displayName[0].toUpperCase());

    int points = 0;
    for (var element in manager.rewardsList) {
      if (element.rewardType == type) {
        points += element.points;
      }
    }

    var theme = Theme.of(context);

    return Row(
      children: [
        Text('$displayName: ',),
        initialized ? Text(points.toString()) : Shimmer.fromColors(
          highlightColor: theme.disabledColor,
          baseColor: theme.hintColor,
          child: Container(
            decoration: BoxDecoration(
              color: theme.hintColor,
              borderRadius: const BorderRadius.all(Radius.circular(20)),
            ),
            height: 11,
            margin: const EdgeInsets.only(bottom: 2.5, top: 2.5),
          ),
        ),
      ],
    );
  });


  
}

class LastRewards extends StatelessWidget {
  const LastRewards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(
      minHeight: 176,
      maxHeight: 189,
    ),
    child: Card(
      child: Container(
        padding: const EdgeInsets.only(top: 15, left: 15, bottom: 5, right: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 2.5),
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
                  var list = manager.rewardsList.reversed.toList();
                  var theme = Theme.of(context);
                  if (!manager.initialized.value) {
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 4,
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
                                margin: const EdgeInsets.only(bottom: 5, top: 5),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: theme.hintColor,
                                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                                ),
                                height: 14,
                                width: 100,
                                margin: const EdgeInsets.only(bottom: 2.5, top: 2.5),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: theme.hintColor,
                                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                                ),
                                height: 14,
                                width: 100,
                              ),
                              TextButton(
                                child: Row(
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
                                onPressed: () {},
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
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return VerticalListTile(
                        reward: list[index],
                      );
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

class AllRewards extends StatelessWidget {
  const AllRewards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      leading: const Icon(
        Icons.clear_all
      ),
      title: const Text('All Rewards'),
      trailing: IconButton(
        icon: const Icon(Icons.arrow_forward),
        onPressed: () {
          context.vRouter.to('/all_items');
        },
      ),
    ),
  );
}

class ExportMonth extends StatelessWidget {
  ExportMonth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      leading: const Icon(
          Icons.import_export,
      ),
      title: const Text('Export Month'),
      trailing: IconButton(
        icon: const Icon(Icons.arrow_forward),
        onPressed: () async {
          var month = await showMonthPicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now().subtract(const Duration(days: 365)),
            lastDate: DateTime.now(),
          );
          if (month == null) {
            return;
          }
          writeAndOpenPDF(
            await createPDFBytes(month),
            '${date_utils.DateUtils.apiDayFormat(month).substring(0, 7)}_output.pdf'
                .replaceAll(' ', '_').toLowerCase(),
          );
        },
      ),
    ),
  );

}