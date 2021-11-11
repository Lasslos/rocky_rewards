import 'package:date_utils/date_utils.dart' as date_utils;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:rocky_rewards/rocky_rewards/rocky_rewards.dart';
import 'package:rocky_rewards/rocky_rewards/rocky_rewards_manager.dart'
    as rocky_rewards_manager;
import 'package:toggle_switch/toggle_switch.dart';

class EditRewardView extends StatelessWidget {
  EditRewardView({required this.reward, Key? key}) : super(key: key) {
    controller = EditController(reward);
  }

  final RockyReward reward;
  late final EditController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rocky Rewards - Edit'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          _buildDateSelector(context),
          _buildRewardsTypeSelector(context),
          _buildGroupNameTextField(context),
          _buildDescriptionTextField(context),
          _buildAttendanceTypeSelector(context),
          _buildPointsPicker(context),
          _buildPhoneNumberTextField(context),
          _buildSubmitButton(context),
        ],
      ),
    );
  }

  Widget _buildDateSelector(BuildContext context) => Container(
        padding: const EdgeInsets.all(15),
        child: Center(
          child: ListTile(
            leading: const Icon(Icons.calendar_today),
            title: Obx(() => Text(
                  date_utils.DateUtils.formatFirstDay(controller.date.value),
                )),
            subtitle: const Text('Click to change'),
            trailing: IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: () async {
                controller.date.value = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate:
                          DateTime.now().subtract(const Duration(days: 365)),
                      lastDate: DateTime.now(),
                    ) ??
                    DateTime.now();
              },
            ),
          ),
        ),
      );

  Widget _buildRewardsTypeSelector(BuildContext context) {
    List<String> rewardTypeNameList = [];
    for (var rewardType in RewardType.values) {
      var name = rewardType
          .toString()
          .replaceFirst('${rewardType.runtimeType.toString()}.', '');
      name = name.replaceRange(0, 1, name[0].toUpperCase());
      rewardTypeNameList.add(name);
    }

    return Container(
      padding: const EdgeInsets.all(15),
      child: Center(
        child: ToggleSwitch(
          initialLabelIndex: controller.rewardType.value.index,
          minWidth: (MediaQuery.of(context).size.width - 50) / 3,
          animate: true,
          totalSwitches: RewardType.values.length,
          labels: rewardTypeNameList,
          onToggle: (index) {
            controller.rewardType.value = RewardType.values[index];
          },
        ),
      ),
    );
  }

  Widget _buildGroupNameTextField(BuildContext context) => Container(
        padding: const EdgeInsets.only(left: 20, bottom: 20, right: 20),
        child: Center(
          child: TextField(
            controller: controller.groupNameController,
            decoration: const InputDecoration(
                labelText: 'Name of Organization, Team or Club'),
          ),
        ),
      );

  Widget _buildDescriptionTextField(BuildContext context) => Container(
        padding: const EdgeInsets.only(left: 20, bottom: 20, right: 20),
        child: Center(
          child: TextField(
            controller: controller.descriptionController,
            decoration: const InputDecoration(labelText: 'Description'),
          ),
        ),
      );

  Widget _buildAttendanceTypeSelector(BuildContext context) {
    List<String> attendanceTypeNameList = [];
    for (var attendanceType in AttendanceType.values) {
      var name = attendanceType
          .toString()
          .replaceFirst('${attendanceType.runtimeType.toString()}.', '');
      name = name.replaceRange(0, 1, name[0].toUpperCase());
      attendanceTypeNameList.add(name);
    }

    return Container(
      padding: const EdgeInsets.all(5),
      child: Center(
        child: ToggleSwitch(
          initialLabelIndex: controller.attendanceType.value.index,
          minWidth: (MediaQuery.of(context).size.width - 50) / 2,
          animate: true,
          totalSwitches: AttendanceType.values.length,
          labels: attendanceTypeNameList,
          onToggle: (index) {
            controller.attendanceType.value = AttendanceType.values[index];
          },
        ),
      ),
    );
  }

  Widget _buildPointsPicker(BuildContext context) {
    var theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(5),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Text('Hour(s) or game(s):', style: theme.textTheme.subtitle1),
                Obx(
                  () => NumberPicker(
                    minValue: 0,
                    value: controller.hoursOrNumberOfGames.value,
                    maxValue: 127,
                    onChanged: (int value) {
                      controller.hoursOrNumberOfGames.value = value;
                    },
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Text('Points:', style: theme.textTheme.subtitle1),
                Obx(
                  () => NumberPicker(
                    minValue: 0,
                    value: controller.points.value,
                    maxValue: 127,
                    onChanged: (int value) {
                      controller.points.value = value;
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneNumberTextField(BuildContext context) => Container(
        padding: const EdgeInsets.only(left: 10, bottom: 10, right: 10),
        child: Center(
          child: TextField(
            controller: controller.phoneController,
            decoration: const InputDecoration(
                labelText: 'Phone number of responsible person'),
          ),
        ),
      );

  Widget _buildSubmitButton(BuildContext context) => TextButton(
        onPressed: () async {
          if (controller.groupNameController.text.isEmpty ||
              controller.descriptionController.text.isEmpty ||
              controller.phoneController.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: SizedBox(
                  height: 25,
                  child: Center(
                    child: Text(
                      'Please fill out every field.',
                    ),
                  ),
                ),
              ),
            );
            return;
          }
          var newReward = reward.copyWith(
              controller.date.value,
              controller.rewardType.value,
              controller.groupNameController.text,
              controller.descriptionController.text,
              controller.attendanceType.value,
              controller.hoursOrNumberOfGames.value,
              controller.points.value,
              controller.phoneController.text);
          rocky_rewards_manager.rewardsList.remove(reward);
          rocky_rewards_manager.rewardsList.add(newReward);
          Navigator.pop(context);
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          child: const Text('Submit'),
        ),
      );
}

class EditController extends GetxController {
  EditController(RockyReward reward) {
    date = reward.date.obs;
    rewardType = reward.rewardType.obs;
    groupNameController = TextEditingController(text: reward.groupName);
    descriptionController = TextEditingController(text: reward.description);
    attendanceType = reward.attendance.obs;
    hoursOrNumberOfGames = reward.hoursOrNumberOfGames.obs;
    points = reward.points.obs;
    phoneController = TextEditingController(text: reward.phone);
  }

  late final Rx<DateTime> date;
  late final Rx<RewardType> rewardType;
  late final TextEditingController groupNameController;
  late final TextEditingController descriptionController;
  late final Rx<AttendanceType> attendanceType;
  late final Rx<int> hoursOrNumberOfGames;
  late final Rx<int> points;
  late final TextEditingController phoneController;
}
