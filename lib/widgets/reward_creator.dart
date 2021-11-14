import 'package:date_utils/date_utils.dart' as date_utils;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:rocky_rewards/main.dart';
import 'package:rocky_rewards/rocky_rewards/rocky_rewards.dart';
import 'package:toggle_switch/toggle_switch.dart';

Future<RockyReward?> createRockyReward(BuildContext context) =>
    showDialog<RockyReward?>(
        context: context, builder: (context) => _RewardCreator());

Future<RockyReward> editRockyReward(
        BuildContext context, RockyReward reward) async =>
    await showDialog<RockyReward?>(
        context: context,
        builder: (context) => _RewardCreator(
              date: reward.date,
              rewardType: reward.rewardType,
              groupName: reward.groupName,
              description: reward.description,
              attendanceType: reward.attendance,
              hoursOrNumberOfGames: reward.hoursOrNumberOfGames,
              points: reward.points,
              phoneNumber: reward.phone,
            )) ??
    reward;

class _RewardCreator extends StatelessWidget {
  _RewardCreator({
    Key? key,
    DateTime? date,
    RewardType rewardType = RewardType.volunteer,
    String groupName = '',
    String description = '',
    AttendanceType attendanceType = AttendanceType.participant,
    int hoursOrNumberOfGames = 1,
    int points = 1,
    String phoneNumber = '',
  })  : date = (date ?? DateTime.now()).obs,
        rewardType = rewardType.obs,
        groupNameController = TextEditingController(text: groupName),
        descriptionController = TextEditingController(text: description),
        attendanceType = attendanceType.obs,
        hoursOrNumberOfGames = hoursOrNumberOfGames.obs,
        points = points.obs,
        phoneController = TextEditingController(text: phoneNumber),
        super(key: key);

  final Rx<DateTime> date;
  final Rx<RewardType> rewardType;
  final TextEditingController groupNameController;
  final TextEditingController descriptionController;
  final Rx<AttendanceType> attendanceType;
  final Rx<int> hoursOrNumberOfGames;
  final Rx<int> points;
  final TextEditingController phoneController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rocky Rewards'),
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

  Widget _buildDateSelector(BuildContext context) => Padding(
        padding: const EdgeInsets.all(15),
        child: Center(
          child: ListTile(
            leading: const Icon(Icons.calendar_today),
            title: Obx(
                () => Text(date_utils.DateUtils.formatFirstDay(date.value))),
            subtitle: const Text('Click to change'),
            trailing: IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: () async {
                date.value = await showDatePicker(
                      context: context,
                      initialDate: date.value,
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
          initialLabelIndex: rewardType.value.index,
          minWidth: (MediaQuery.of(context).size.width - 50) / 3,
          animate: true,
          totalSwitches: RewardType.values.length,
          labels: rewardTypeNameList,
          onToggle: (index) {
            rewardType.value = RewardType.values[index];
          },
        ),
      ),
    );
  }

  Widget _buildGroupNameTextField(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 20, bottom: 20, right: 20),
        child: Center(
          child: TextField(
            controller: groupNameController,
            decoration: const InputDecoration(
                labelText: 'Name of Organization, Team or Club'),
          ),
        ),
      );

  Widget _buildDescriptionTextField(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 20, bottom: 20, right: 20),
        child: Center(
          child: TextField(
            controller: descriptionController,
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
          initialLabelIndex: attendanceType.value.index,
          minWidth: (MediaQuery.of(context).size.width - 50) / 2,
          animate: true,
          totalSwitches: AttendanceType.values.length,
          labels: attendanceTypeNameList,
          onToggle: (index) {
            attendanceType.value = AttendanceType.values[index];
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
                    value: hoursOrNumberOfGames.value,
                    maxValue: 127,
                    onChanged: (int value) {
                      hoursOrNumberOfGames.value = value;
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
                    value: points.value,
                    maxValue: 127,
                    onChanged: (int value) {
                      points.value = value;
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

  Widget _buildPhoneNumberTextField(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 10, bottom: 10, right: 10),
        child: Center(
          child: TextField(
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.none,
            controller: phoneController,
            decoration: InputDecoration(
              labelText: 'Phone number of responsible person',
              suffixIcon: IconButton(
                onPressed: () async {
                  PhoneContact? contact;
                  try {
                    contact = await FlutterContactPicker.pickPhoneContact();
                  } on Exception {
                    contact = null;
                  }

                  phoneController.text = contact?.phoneNumber?.number ?? '';
                },
                icon: const Icon(Icons.person_search),
              ),
            ),
          ),
        ),
      );

  Widget _buildSubmitButton(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(primary: primary),
          onPressed: () async {
            if (groupNameController.text.isEmpty ||
                descriptionController.text.isEmpty ||
                phoneController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: primary,
                  elevation: 10,
                  behavior: SnackBarBehavior.floating,
                  width: MediaQuery.of(context).size.width - 50,
                  content: const Center(
                    heightFactor: 1,
                    child: Text(
                      'Please fill out every field.',
                    ),
                  ),
                ),
              );
              return;
            }
            Navigator.pop(
              context,
              RockyReward(
                date.value,
                rewardType.value,
                groupNameController.text,
                descriptionController.text,
                attendanceType.value,
                hoursOrNumberOfGames.value,
                points.value,
                phoneController.text,
              ),
            );
          },
          child: const Center(
            child: Text('Submit'),
          ),
        ),
      );
}
