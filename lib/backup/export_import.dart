import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rocky_rewards/rocky_rewards/rocky_rewards.dart';
import 'package:rocky_rewards/rocky_rewards/rocky_rewards_list.dart';
import 'package:share_plus/share_plus.dart';

Future<void> export() async {
  var path = (await getApplicationDocumentsDirectory()).path;
  var file = File('$path/backup.json');

  var json = <Map<String, Object>>[];
  for (var reward in rewardsList) {
    json.add(reward.toJSON());
  }

  file.writeAsString(jsonEncode(json));

  await Share.shareFiles(
    [file.path],
    subject: 'Rocky Rewards Backup',
  );
}
Future<void> import(BuildContext context) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    dialogTitle: 'Import Data',
  );

  if (result != null && result.files.single.path != null) {
    try {
      File file = File(result.files.single.path!);
      var json = await file.readAsString();
      List<dynamic> jsonDecoded = jsonDecode(json);
      for (var rewardEncoded in jsonDecoded) {
        rewardsList.add(RockyReward.fromJSON(rewardEncoded));
      }
    } on FileSystemException {
      showSnackBar(context, 'Something went wrong');
      return;
    } on FormatException {
      showSnackBar(context, 'Something went wrong');
      return;
    }
    showSnackBar(context, 'Import Complete');
  } else {
    showSnackBar(context, 'Cancelled');
  }
}

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Dismiss',
          onPressed: () {
            ScaffoldMessenger.of(context).removeCurrentSnackBar(
                reason: SnackBarClosedReason.dismiss
            );
          },
        ),
      )
  );
}
