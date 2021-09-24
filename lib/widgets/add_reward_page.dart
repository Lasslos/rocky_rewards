import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:rocky_rewards/utils/image_coder.dart';
import 'package:signature/signature.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:vrouter/vrouter.dart';
import 'package:date_utils/date_utils.dart' as date_utils;

import '../utils/rocky_rewards.dart';

class AddReward extends StatelessWidget {
  AddReward({Key? key}) : super(key: key);

  final AddRewardController controller = AddRewardController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rocky Rewards - Add'),
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
          _buildSignatureHeader(context),
          _buildSignatureField(context),
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
        title: Obx(() =>
            Text(dateTimeToString(controller.date.value))
        ),
        subtitle: const Text('Click to change'),
        trailing: IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: () async {
            controller.date.value = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now().subtract(const Duration(days: 365)),
              lastDate: DateTime.now(),
            ) ?? DateTime.now();
          },
        ),
      ),
    ),
  );

  Widget _buildRewardsTypeSelector(BuildContext context) {
    List<String> rewardTypeNameList = [];
    for (var rewardType in RewardType.values) {
      var name = rewardType.toString()
          .replaceFirst('${rewardType.runtimeType.toString()}.', '');
      name = name.replaceRange(0, 1, name[0].toUpperCase());
      rewardTypeNameList.add(name);
    }

    return Container(
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
    );
  }

  Widget _buildGroupNameTextField(BuildContext context) => Container(
    padding: const EdgeInsets.only(left: 20, bottom: 20, right: 20),
    child: Center(
      child: TextField(
        controller: controller.groupNameController,
        decoration: const InputDecoration(
            labelText: "Name of Organization, Team or Club"
        ),
      ),
    ),
  );

  Widget _buildDescriptionTextField(BuildContext context) => Container(
    padding: const EdgeInsets.only(left: 20, bottom: 20, right: 20),
    child: Center(
      child: TextField(
        controller: controller.descriptionController,
        decoration: const InputDecoration(
            labelText: "Description"
        ),
      ),
    ),
  );

  Widget _buildAttendanceTypeSelector(BuildContext context) {
    List<String> attendanceTypeNameList = [];
    for (var attendanceType in AttendanceType.values) {
      var name = attendanceType.toString()
          .replaceFirst('${attendanceType.runtimeType.toString()}.', '');
      name = name.replaceRange(0, 1, name[0].toUpperCase());
      attendanceTypeNameList.add(name);
    }


    return Container(
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
                Obx(() =>
                    NumberPicker(
                      minValue: 0,
                      value: controller.hoursOrNumberOfGames.value ?? 1,
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
                Obx(() =>
                    NumberPicker(
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

  Widget _buildSignatureHeader(BuildContext context) {
    var theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: Text(
          'Signature of responsible person', style: theme.textTheme.subtitle1),
    );
  }

  Widget _buildSignatureField(BuildContext context) => Container(
    decoration: const BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      color: Colors.grey,
    ),
    margin: const EdgeInsets.all(10),
    padding: const EdgeInsets.all(10),
    child: Signature(
      controller: controller.signatureController,
      height: 250,
    ),
  );

  Widget _buildPhoneNumberTextField(BuildContext context) => Container(
    padding: const EdgeInsets.only(left: 10, bottom: 10, right: 10),
    child: Center(
      child: TextField(
        controller: controller.phoneController,
        decoration: const InputDecoration(
            labelText: "Phone number of responsible person"
        ),
      ),
    ),
  );

  Widget _buildSubmitButton(BuildContext context) => TextButton(
    onPressed: () async {
      if (controller.groupNameController.text.isEmpty ||
          controller.descriptionController.text.isEmpty ||
          controller.phoneController.text.isEmpty||
          controller.signatureController.isEmpty
      ) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: SizedBox(
              height: 25,
              child: Center(
                child: Text(
                  'Please fill out every field.',
                  style: TextStyle(
                      color: Color(0xFFCC0A2D),
                      fontSize: 16
                  ),
                ),
              ),
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
          MyImage((await controller.signatureController.toPngBytes())!),
          controller.phoneController.text,
        ),
      );
      context.vRouter.to('/');
    },
    child: Container(
      padding: const EdgeInsets.all(10),
      child: const Text('Submit'),
    ),
  );

  String dateTimeToString(DateTime dateTime) =>
      date_utils.DateUtils.formatFirstDay(dateTime);
}

class AddRewardController extends GetxController {
  Rx<DateTime> date = DateTime.now().obs;
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