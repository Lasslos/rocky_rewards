import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:rocky_rewards/utils/image_coder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RockyReward extends Comparable<RockyReward> {
  DateTime date;
  RewardType rewardType;
  String groupName;
  String description;
  AttendanceType attendance;
  int hoursOrNumberOfGames;
  int points;
  MyImage signature;
  String phone;

  RockyReward(
      this.date,
      this.rewardType,
      this.groupName,
      this.description,
      this.attendance,
      this.hoursOrNumberOfGames,
      this.points,
      this.signature,
      this.phone);

  static Future<RockyReward> fromJSON(Map<String, dynamic> json) async {
    var date = _getFromJSON<DateTime>(json, 'date', DateTime.now());
    var rewardType =
        RewardType.values[_getFromJSON<int>(json, 'rewardType', 0)];
    var groupName = _getFromJSON<String>(json, 'groupName', '');
    var description = _getFromJSON(json, 'description', '');
    var attendance =
        AttendanceType.values[_getFromJSON<int>(json, 'attendance', 0)];
    var hoursOrNumbersOfGames =
        _getFromJSON<int>(json, 'hoursOrNumbersOfGames', 0);
    var points = _getFromJSON<int>(json, 'points', 1);
    var signature =
        MyImage.fromString(_getFromJSON<String>(json, 'signature', ''));
    var phone = _getFromJSON<String>(json, 'phone', '012-345-6789');
    return RockyReward(date, rewardType, groupName, description, attendance,
        hoursOrNumbersOfGames, points, signature, phone);
  }

  static T _getFromJSON<T>(Map<String, dynamic> json, String path, T fallback) {
    Object? result = json[path];
    if (result == null || result is! T) {
      return fallback;
    }
    return result as T;
  }

  Future<Map<String, Object>> toJSON() async {
    Map<String, Object> result = {};
    result['date'] = date.toString();
    result['rewardType'] = rewardType.index;
    result['groupName'] = groupName;
    result['description'] = description;
    result['attendance'] = attendance.index;
    result['hoursOrNumberOfGames'] = hoursOrNumberOfGames;
    result['points'] = points;
    result['signature'] = signature.toString();
    result['phone'] = phone;

    return result;
  }

  @override
  int compareTo(RockyReward other) {
    return date.compareTo(other.date);
  }
}

enum RewardType { volunteer, school, community }
enum AttendanceType { participant, spectator }

class RockyRewardsManager {
  static RockyRewardsManager instance = RockyRewardsManager._private();
  var initialized = false.obs;

  RockyRewardsManager._private() {
    load();
  }

  final RxList<RockyReward> _rewardsList = <RockyReward>[].obs;
  RxList<RockyReward> get rewardsList => RxList.unmodifiable(_rewardsList);
  void addReward(RockyReward reward) {
    _rewardsList.add(reward);
    _rewardsList.sort();
    save();
  }
  void updateList() {
    _rewardsList.sort();
    save();
  }

  Future<void> load() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    List<String> rewardsList = preferences.getStringList('rewards') ?? [];
    for (var reward in rewardsList) {
      _rewardsList.add(await RockyReward.fromJSON(jsonDecode(reward)));
    }
    await Future.delayed(const Duration(seconds: 3));
    initialized.value = true;
  }

  Future<void> save() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    List<String> rewardsList = [];
    for (var reward in this.rewardsList) {
      rewardsList.add(jsonEncode(await reward.toJSON()));
    }
    preferences.setStringList('rewards', rewardsList);
  }
}
