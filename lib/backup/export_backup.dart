import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:rocky_rewards/rocky_rewards/rocky_rewards_list.dart';
import 'package:share_plus/share_plus.dart';

Future<void> backup() async {
  var path = (await getApplicationDocumentsDirectory()).path;
  var file = File('$path/backup.txt');
  file.writeAsString(
      jsonEncode(rewardsList.copy.map((e) => jsonEncode(e.toJSON())).toList()));

  await Share.shareFiles(
    [file.path],
    subject: 'Rocky Rewards Backup',
  );
}
