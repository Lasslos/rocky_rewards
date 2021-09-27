import 'dart:io';
import 'dart:ui';

import 'package:date_utils/date_utils.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rocky_rewards/pdf_creator/coordinates.dart';
import 'package:rocky_rewards/utils/rocky_rewards.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;

const Rect firstNameField = Rect.fromLTWH(320, 30, 98, 14);
const Rect lastNameField = Rect.fromLTWH(473, 30, 109, 14);
const Rect schoolField = Rect.fromLTWH(621, 30, 44, 14);
const Rect monthField = Rect.fromLTWH(701, 30, 49, 14);

const RowCoordinates rowsSpan = RowCoordinates(169, 325);
const int numberOfRows = 17;
final List<RowCoordinates> rowList = _getRowCoordinates();
List<RowCoordinates> _getRowCoordinates() {
  List<RowCoordinates> result = [];
  for (var i = 0; i < 17; i++) {
    var y = rowsSpan.y + (rowsSpan.height / numberOfRows * i);
    var height = rowsSpan.height / numberOfRows;
    result.add(RowCoordinates(y, height));
  }
  return result;
}

const ColumnCoordinates dateColumn = ColumnCoordinates(19, 72);
const ColumnCoordinates rewardTypeColumn = ColumnCoordinates(92, 75);
const int numberOfRewardTypeColumns = 3;
const ColumnCoordinates groupNameColumn = ColumnCoordinates(169, 98);
const ColumnCoordinates description = ColumnCoordinates(268, 208);
const ColumnCoordinates attendanceTypeColumn = ColumnCoordinates(477, 44);
const int numberOfAttendanceTypeColumns = 2;
const hoursOfNumberOfGamesColumn = ColumnCoordinates(522, 36);
const pointsColumn = ColumnCoordinates(559, 25);
const signatureColumn = ColumnCoordinates(585, 92);
const phoneColumn = ColumnCoordinates(679, 93);

const Rect volunteerSumField = Rect.fromLTWH(92, 495, 24, 18);
const Rect schoolSumField = Rect.fromLTWH(117, 495, 25, 18);
const Rect communitySumField = Rect.fromLTWH(143, 495, 25, 18);

Future<ByteData> getTemplateBytes() async {
  return await rootBundle.load('assets/template_pdf.pdf');
}
Future<List<int>> createPDFBytes(DateTime month) async {
  if (!RockyRewardsManager.instance.initialized.value) {
    await RockyRewardsManager.instance.initialized.stream.first;
  }
  var list = RockyRewardsManager.instance.rewardsList.where((reward) =>
  reward.date.year == month.year && reward.date.month == month.month
  ).toList(growable: false);

  var templateBytes = await getTemplateBytes();
  var template = PdfDocument(
    inputBytes: templateBytes.buffer.asUint8List(),
  ).pages[0].createTemplate();
  var numberOfPages = (list.length / numberOfRows).ceil();
  var document = PdfDocument();

  for (int i = 0; i < numberOfPages; i++) {
    var page = document.pages.add();
    page.graphics.drawPdfTemplate(template, Offset.zero);
    fillPage(
      month,
      'Laslo',
      'Hauschild',
      'Selkirk Secondary School',
      i != (numberOfPages - 1)
          ? list.sublist(numberOfRows * i, numberOfRows * (i + 1))
          : list.sublist(numberOfRows * i),
      page,
    );
  }

  List<int> resultBytes = document.save();
  document.dispose();
  return resultBytes;
}
PdfPage fillPage(DateTime month, String firstName, String lastName,
    String school, List<RockyReward> rewards, PdfPage page) {
  var font = PdfStandardFont(PdfFontFamily.helvetica, 12);
  var graphics = page.graphics;
  graphics.drawString(firstName, font, bounds: firstNameField);
  graphics.drawString(lastName, font, bounds: lastNameField);
  graphics.drawString(school, font, bounds: schoolField);
  graphics.drawString(DateUtils.formatMonth(month), font, bounds: monthField);
  //TODO: Fill out columns
  //TODO: Fill out sums
  return page;
}
Future<void> writeAndOpenPDF(List<int> bytes, String fileName) async {
  //Only works on android!
  final path = (await getExternalStorageDirectory())!.path;
  final file = File('$path/$fileName');
  await file.writeAsBytes(bytes, flush: true);
  OpenFile.open(file.path);
}