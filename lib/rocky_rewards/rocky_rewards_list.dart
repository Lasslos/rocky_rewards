import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:rocky_rewards/rocky_rewards/rocky_rewards.dart';
import 'package:shared_preferences/shared_preferences.dart';

final RockyRewardsList rewardsList = RockyRewardsList();

class RockyRewardsList extends Iterable<RockyReward> with ChangeNotifier {
  RockyRewardsList() {
    _initRx();
    _load();
  }

  final List<RockyReward> _field = [];
  RockyReward operator [](int index) => _field[index];
  void add(RockyReward reward) {
    _field.insert(_binarySearch(_field, reward), reward);
    notifyListeners();
  }

  void remove(RockyReward reward) {
    _field.remove(reward);
    notifyListeners();
  }

  @override
  Iterator<RockyReward> get iterator => _field.iterator;
  List<RockyReward> get copy {
    var result = <RockyReward>[];
    result.addAll(_field);
    return result;
  }

  int _binarySearch(List<RockyReward> sortedList, RockyReward searching) {
    int minimum = 0;
    int maximum = sortedList.length;

    while (minimum < maximum) {
      int middle = minimum + ((maximum - minimum) >> 1);
      RockyReward middleElement = sortedList[middle];
      int comparison = middleElement.compareTo(searching);
      if (comparison == 0) {
        return middle;
      }
      if (comparison < 0) {
        minimum = middle + 1;
      } else {
        maximum = middle;
      }
    }
    return minimum;
  }

  late Rx<RockyRewardsList> rx;
  void _initRx() {
    rx = Rx(this);
    addListener(rx.refresh);
  }

  Future<void> _load() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    List<String> rewardsList = preferences.getStringList('rewards') ?? [];
    for (var reward in rewardsList) {
      add(RockyReward.fromJSON(jsonDecode(reward)));
    }
    addListener(_save);
    FlutterNativeSplash.remove();
  }

  Future<void> _save() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    List<String> rewardsListInJSON = [];
    for (var reward in this) {
      rewardsListInJSON.add(jsonEncode(reward.toJSON()));
    }
    preferences.setStringList('rewards', rewardsListInJSON);
  }
}
