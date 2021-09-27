import 'dart:io';
import 'dart:ui';

import 'package:date_utils/date_utils.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rocky_rewards/pdf_creator/coordinates.dart';
import 'package:rocky_rewards/utils/rocky_rewards.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;

const Rect _firstNameField = Rect.fromLTWH(320, 30, 98, 14);
const Rect _lastNameField = Rect.fromLTWH(473, 30, 109, 14);
const Rect _schoolField = Rect.fromLTWH(621, 30, 44, 14);
const Rect _monthField = Rect.fromLTWH(701, 30, 49, 14);

const RowCoordinates _rowsSpan = RowCoordinates(169, 325);
const int _numberOfRows = 17;
final List<RowCoordinates> _rowList = _getRowCoordinates();
List<RowCoordinates> _getRowCoordinates() {
  List<RowCoordinates> result = [];
  for (var i = 0; i < 17; i++) {
    var y = _rowsSpan.y + (_rowsSpan.height / _numberOfRows * i);
    var height = _rowsSpan.height / _numberOfRows;
    result.add(RowCoordinates(y, height));
  }
  return result;
}

const ColumnCoordinates _dateColumn = ColumnCoordinates(19, 72);
const ColumnCoordinates _rewardTypeColumn = ColumnCoordinates(92, 75);
const int _numberOfRewardTypeColumns = 3;
const ColumnCoordinates _groupNameColumn = ColumnCoordinates(169, 98);
const ColumnCoordinates _description = ColumnCoordinates(268, 208);
const ColumnCoordinates _attendanceTypeColumn = ColumnCoordinates(477, 44);
const int _numberOfAttendanceTypeColumns = 2;
const ColumnCoordinates _hoursOrNumberOfGamesColumn = ColumnCoordinates(522, 36);
const ColumnCoordinates _pointsColumn = ColumnCoordinates(559, 25);
const ColumnCoordinates _signatureColumn = ColumnCoordinates(585, 92);
const ColumnCoordinates _phoneColumn = ColumnCoordinates(679, 93);

const Rect _volunteerSumField = Rect.fromLTWH(92, 495, 24, 18);
const Rect _schoolSumField = Rect.fromLTWH(117, 495, 25, 18);
const Rect _communitySumField = Rect.fromLTWH(143, 495, 25, 18);

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
  var numberOfPages = (list.length / _numberOfRows).ceil();
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
          ? list.sublist(_numberOfRows * i, _numberOfRows * (i + 1))
          : list.sublist(_numberOfRows * i),
      page,
    );
  }

  List<int> resultBytes = document.save();
  document.dispose();
  return resultBytes;
}
void fillPage(DateTime month, String firstName, String lastName,
    String school, List<RockyReward> rewards, PdfPage page) {
  var font = PdfStandardFont(PdfFontFamily.helvetica, 12);
  var graphics = page.graphics;
  graphics.drawString(firstName, font, bounds: _firstNameField);
  graphics.drawString(lastName, font, bounds: _lastNameField);
  graphics.drawString(school, font, bounds: _schoolField);
  graphics.drawString(DateUtils.formatMonth(month), font, bounds: _monthField);

  for (int i = 0; i < rewards.length && i < 17; i++) {
    fillRowInPage(page, rewards[i], _rowList[i]);
  }

  //TODO: Fill out sums
}
void fillRowInPage(PdfPage page, RockyReward reward, RowCoordinates row) {
  var graphics = page.graphics;
  var font = PdfStandardFont(PdfFontFamily.helvetica, 12);

  //Date
  graphics.drawString(
    DateUtils.formatDay(reward.date),
    font,
    bounds: _dateColumn.getRect(row),
  );
  //RewardTypeColumn has multiple sub-columns, calculating which one it is
  var rewardTypeWidth = _rewardTypeColumn.width / _numberOfRewardTypeColumns;
  var rewardTypeX = _rewardTypeColumn.x +
      (rewardTypeWidth * reward.rewardType.index);
  graphics.drawString(
    '✔',
    font,
    bounds: ColumnCoordinates(rewardTypeX, rewardTypeWidth).getRect(row),
  );
  //GroupName
  graphics.drawString(
    reward.groupName,
    font,
    bounds: _groupNameColumn.getRect(row),
  );
  //Description
  graphics.drawString(
    reward.description,
    font,
    bounds: _description.getRect(row),
  );
  //Attendance has multiple sub-columns, calculating which one it is
  var attendanceTypeWidth = _attendanceTypeColumn.width / _numberOfAttendanceTypeColumns;
  var attendanceTypeX = _attendanceTypeColumn.x +
      (attendanceTypeWidth * reward.attendance.index);
  graphics.drawString(
    '✔',
    font,
    bounds: ColumnCoordinates(attendanceTypeX, attendanceTypeWidth).getRect(row),
  );
  //Hours or number of games
  graphics.drawString(
    reward.hoursOrNumberOfGames?.toString() ?? '',
    font,
    bounds: _hoursOrNumberOfGamesColumn.getRect(row),
  );
  //Points
  graphics.drawString(
    reward.points.toString(),
    font,
    bounds: _pointsColumn.getRect(row),
  );
  //Signature
  graphics.drawImage(
    PdfBitmap(reward.signature.bytes),
    _signatureColumn.getRect(row),
  );
  //Phone
  graphics.drawString(
    reward.phone,
    font,
    bounds: _phoneColumn.getRect(row)
  );
}

Future<void> writeAndOpenPDF(List<int> bytes, String fileName) async {
  //Only works on android!
  final path = (await getExternalStorageDirectory())!.path;
  final file = File('$path/$fileName');
  await file.writeAsBytes(bytes, flush: true);
  OpenFile.open(file.path);
}