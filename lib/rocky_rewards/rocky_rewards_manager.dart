import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:rocky_rewards/rocky_rewards/rocky_rewards.dart';
import 'package:shared_preferences/shared_preferences.dart';

RxBool initialized = false.obs;
bool _isInitializing = false;
RxList<RockyReward> get rewardsList {
  if (!initialized.value && !_isInitializing) {
    _isInitializing = true;
    _load();
  }
  return _rewardsList;
}

final RxList<RockyReward> _rewardsList = <RockyReward>[].obs;
Future<void> _load() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  List<String> rewardsList = preferences.getStringList('rewards') ?? [];
  for (var reward in rewardsList) {
    _rewardsList.add(RockyReward.fromJSON(jsonDecode(reward)));
  }
  _rewardsList.listen(_maybeUpdateList);
  await Future.delayed(const Duration(seconds: 3));
  initialized.value = true;
}

List<RockyReward> _last = [];
void _maybeUpdateList(List<RockyReward> list) {
  if (!listEquals(_last, list)) {
    _last = list;
    _last.sort();
    _updateList();
  }
}

void _updateList() {
  _rewardsList.sort();
  _save();
}

Future<void> _save() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  List<String> rewardsListInJSON = [];
  for (var reward in rewardsList) {
    rewardsListInJSON.add(jsonEncode(await reward.toJSON()));
  }
  preferences.setStringList('rewards', rewardsListInJSON);
}
