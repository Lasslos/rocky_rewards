import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:signature/signature.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../utils/rocky_rewards.dart';

class AddReward extends StatelessWidget {
  AddReward({Key? key}) : super(key: key);

  final AddRewardController controller = AddRewardController();

  @override
  Widget build(BuildContext context) {
    List<String> rewardTypeNameList = [];
    for (var rewardType in RewardType.values) {
      var name = rewardType.toString()
          .replaceFirst('${rewardType.runtimeType.toString()}.', '');
      name = name.replaceRange(0, 1, name[0].toUpperCase());
      rewardTypeNameList.add(name);
    }
    List<String> attendanceTypeNameList = [];
    for (var attendanceType in AttendanceType.values) {
      var name = attendanceType.toString()
          .replaceFirst('${attendanceType.runtimeType.toString()}.', '');
      name = name.replaceRange(0, 1, name[0].toUpperCase());
      attendanceTypeNameList.add(name);
    }

    var theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: theme.brightness == Brightness.light
            ? Image.asset('assets/icon_white.png', height: 41,)
            : Image.asset('assets/icon_red.png', height: 41,),
        title: const Text('Rocky Rewards - Add'),
        centerTitle: true,
      ),
      body: ListView(
        children: [

          Container(
            padding: const EdgeInsets.all(15),
            child: Center(
              child: ToggleSwitch(
                minWidth: (MediaQuery
                    .of(context)
                    .size
                    .width - 50) / 3,
                animate: true,
                totalSwitches: RewardType.values.length,
                labels: rewardTypeNameList,
                onToggle: (index) {
                  controller.rewardType.value = RewardType.values[index];
                },

              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.only(left: 10, bottom: 10, right: 10),
            child: Center(
              child: TextField(
                controller: controller.groupNameController,
                decoration: const InputDecoration(
                    labelText: "Name of Organization, Team or Club"
                ),
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.only(left: 10, bottom: 10, right: 10),
            child: Center(
              child: TextField(
                controller: controller.descriptionController,
                decoration: const InputDecoration(
                    labelText: "Description"
                ),
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.all(5),
            child: Center(
              child: ToggleSwitch(
                minWidth: (MediaQuery
                    .of(context)
                    .size
                    .width - 50) / 2,
                animate: true,
                totalSwitches: AttendanceType.values.length,
                labels: attendanceTypeNameList,
                onToggle: (index) {
                  controller.attendanceType.value = AttendanceType.values[index];
                },
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.all(5),
            child: Center(
              child: ListTile(
                title: Text(
                  '${controller.hoursOrNumberOfGames} hour(s) or game(s)'
                      .trim().capitalizeFirst??"",
                ),
                subtitle: const Text(
                  "Leave empty if it doesn't apply",
                ),
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.all(5),
            child: Obx(
              () => NumberPicker(
                axis: Axis.horizontal,
                minValue: 0,
                value: controller.hoursOrNumberOfGames.value ?? 1,
                maxValue: 2147483647,
                onChanged: (int value) {
                  controller.hoursOrNumberOfGames.value = value;
                  },
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            child: Text('Points:', style: theme.textTheme.subtitle1),
          ),
          Container(
            padding: const EdgeInsets.all(5),
            child: Obx(
              () => NumberPicker(
                minValue: 0,
                value: controller.points.value,
                maxValue: 2147483647,
                axis: Axis.horizontal,
                onChanged: (int value) {
                  controller.points.value = value;
                  },
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            child: Text('Signature of responsible person', style: theme.textTheme.subtitle1),
          ),
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Colors.grey,
            ),
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            child: Signature(
              controller: controller.signatureController,
              height: 100,
            ),
          ),

          Container(
            padding: const EdgeInsets.only(left: 10, bottom: 10, right: 10),
            child: const Center(
              child: TextField(
                decoration: InputDecoration(
                    labelText: "Phone number of responsible person"
                ),
              ),
            ),
          ),

          TextButton(
            onPressed: () async {
              //TextController.isBlank will never return null.
              if (controller.groupNameController.isBlank! ||
                  controller.descriptionController.isBlank! ||
                  (controller.phoneController.isBlank!) ||
                  controller.signatureController.isEmpty
              ) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Center(
                      child: Text('Please fill out every field.'),
                    ),
                  ),
                );
                return;
              }
              RockyRewardsManager.instance.addReward(
                RockyReward(
                  DateTime.now(),
                    controller.rewardType.value,
                    controller.groupNameController.text,
                    controller.descriptionController.text,
                    controller.attendanceType.value,
                    controller.hoursOrNumberOfGames.value,
                    controller.points.value,
                    (await controller.signatureController.toImage())!,
                    controller.phoneController.text,
                )
              );
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}

class AddRewardController extends GetxController {
  Rx<RewardType> rewardType = RewardType.values.first.obs;
  TextEditingController groupNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  Rx<AttendanceType> attendanceType = AttendanceType.values.first.obs;
  Rx<int?> hoursOrNumberOfGames = Rx<int?>(null);
  Rx<int> points = Rx<int>(1);
  SignatureController signatureController = SignatureController(
    exportBackgroundColor: Colors.white,
  );
  TextEditingController phoneController = TextEditingController();
}