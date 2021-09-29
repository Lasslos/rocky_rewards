import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:date_utils/date_utils.dart' as date_utils;
import 'package:flutter/cupertino.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rocky_rewards/pdf_creator/coordinates.dart';
import 'package:rocky_rewards/utils/rocky_rewards.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;

const Rect _firstNameField = Rect.fromLTWH(310, 20, 98, 14);
const Rect _lastNameField = Rect.fromLTWH(463, 20, 109, 14);
const Rect _schoolField = Rect.fromLTWH(611, 20, 44, 14);
const Rect _monthField = Rect.fromLTWH(691, 20, 49, 14);

const RowCoordinates _rowsSpan = RowCoordinates(159, 325);
const int _numberOfRows = 17;
final List<RowCoordinates> _rowList = _getRowCoordinates();
List<RowCoordinates> _getRowCoordinates() {
  List<RowCoordinates> result = [];
  for (var i = 0; i < 17; i++) {
    var y = _rowsSpan.y + (_rowsSpan.height / _numberOfRows * i);
    var height = _rowsSpan.height / _numberOfRows;
    result.add(RowCoordinates(y, height - 4));
  }
  return result;
}

const ColumnCoordinates _dateColumn = ColumnCoordinates(9, 72);
const ColumnCoordinates _rewardTypeColumn = ColumnCoordinates(82, 75);
const int _numberOfRewardTypeColumns = 3;
const ColumnCoordinates _groupNameColumn = ColumnCoordinates(159, 98);
const ColumnCoordinates _description = ColumnCoordinates(258, 208);
const ColumnCoordinates _attendanceTypeColumn = ColumnCoordinates(467, 44);
const int _numberOfAttendanceTypeColumns = 2;
const ColumnCoordinates _hoursOrNumberOfGamesColumn =
    ColumnCoordinates(512, 36);
const ColumnCoordinates _pointsColumn = ColumnCoordinates(549, 25);
const ColumnCoordinates _signatureColumn = ColumnCoordinates(575, 90);
const ColumnCoordinates _phoneColumn = ColumnCoordinates(669, 93);

const Rect _volunteerSumField = Rect.fromLTWH(82, 485, 24, 18);
const Rect _schoolSumField = Rect.fromLTWH(107, 485, 25, 18);
const Rect _communitySumField = Rect.fromLTWH(133, 485, 25, 18);

Future<ByteData> _getTemplateBytes() async {
  return await rootBundle.load('assets/template_pdf.pdf');
}

Future<List<int>> createPDFBytes(DateTime month) async {
  if (!RockyRewardsManager.instance.initialized.value) {
    await RockyRewardsManager.instance.initialized.stream.first;
  }
  var list = RockyRewardsManager.instance.rewardsList
      .where((reward) =>
          reward.date.year == month.year && reward.date.month == month.month)
      .toList(growable: false);

  var templateBytes = await _getTemplateBytes();
  var template = PdfDocument(
    inputBytes: templateBytes.buffer.asUint8List(),
  ).pages[0].createTemplate();
  var numberOfPages = (list.length / _numberOfRows).ceil();
  var document = PdfDocument();
  document.pageSettings.size = PdfPageSize.letter;
  document.pageSettings.orientation = PdfPageOrientation.landscape;
  document.pageSettings.setMargins(10);

  for (int i = 0; i < numberOfPages; i++) {
    var page = document.pages.add();
    page.graphics.drawPdfTemplate(template, Offset.zero);
    _fillPage(
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
  if (numberOfPages == 0) {
    var page = document.pages.add();
    page.graphics.drawPdfTemplate(template, Offset.zero);
  }

  List<int> resultBytes = document.save();
  document.dispose();
  return resultBytes;
}

void _fillPage(DateTime month, String firstName, String lastName, String school,
    List<RockyReward> rewards, PdfPage page) {
  var font = PdfStandardFont(PdfFontFamily.helvetica, 12);
  var format = PdfStringFormat(
      alignment: PdfTextAlignment.center,
      lineAlignment: PdfVerticalAlignment.middle);
  var graphics = page.graphics;

  graphics.drawString(firstName, font, bounds: _firstNameField, format: format);
  graphics.drawString(lastName, font, bounds: _lastNameField, format: format);
  graphics.drawString(school, font, bounds: _schoolField, format: format);
  graphics.drawString(date_utils.DateUtils.formatMonth(month), font,
      bounds: _monthField, format: format);

  for (int i = 0; i < rewards.length && i < 17; i++) {
    _fillRowInPage(page, rewards[i], _rowList[i]);
  }
  Map<RewardType, int> points = {};
  for (var rewardType in RewardType.values) {
    points[rewardType] = 0;
  }
  points[RewardType.school] = 1;
  points[RewardType.volunteer] = 3;
  for (var reward in rewards) {
    var rewardType = reward.rewardType;
    points[rewardType] = points[rewardType]! + reward.points;
  }

  graphics.drawString(
    points[RewardType.volunteer]!.toString(),
    font,
    bounds: _volunteerSumField,
    format: format,
  );
  graphics.drawString(
    points[RewardType.school]!.toString(),
    font,
    bounds: _schoolSumField,
    format: format,
  );
  graphics.drawString(
    points[RewardType.community]!.toString(),
    font,
    bounds: _communitySumField,
    format: format,

  );
}

void _fillRowInPage(PdfPage page, RockyReward reward, RowCoordinates row) {
  var graphics = page.graphics;
  var font = PdfStandardFont(PdfFontFamily.timesRoman, 12);
  var format = PdfStringFormat(
      alignment: PdfTextAlignment.center,
      lineAlignment: PdfVerticalAlignment.middle);

  //Date
  graphics.drawString(
    date_utils.DateUtils.formatFirstDay(reward.date),
    font,
    bounds: _dateColumn.getRect(row),
    format: format,
  );
  //RewardTypeColumn has multiple sub-columns, calculating which one it is
  var rewardTypeWidth = _rewardTypeColumn.width / _numberOfRewardTypeColumns;
  var rewardTypeX =
      _rewardTypeColumn.x + (rewardTypeWidth * reward.rewardType.index);
  graphics.drawString(
    'X',
    font,
    bounds: ColumnCoordinates(rewardTypeX, rewardTypeWidth).getRect(row),
    format: format,
  );
  //GroupName
  graphics.drawString(
    reward.groupName,
    font,
    bounds: _groupNameColumn.getRect(row),
    format: format,
  );
  //Description
  graphics.drawString(
    reward.description,
    font,
    bounds: _description.getRect(row),
    format: format,
  );
  //Attendance has multiple sub-columns, calculating which one it is
  var attendanceTypeWidth =
      _attendanceTypeColumn.width / _numberOfAttendanceTypeColumns;
  var attendanceTypeX =
      _attendanceTypeColumn.x + (attendanceTypeWidth * reward.attendance.index);
  graphics.drawString(
    'X',
    font,
    bounds:
        ColumnCoordinates(attendanceTypeX, attendanceTypeWidth).getRect(row),
    format: format,
  );
  //Hours or number of games
  graphics.drawString(
    reward.hoursOrNumberOfGames.toString(),
    font,
    bounds: _hoursOrNumberOfGamesColumn.getRect(row),
    format: format,
  );
  //Points
  graphics.drawString(
    reward.points.toString(),
    font,
    bounds: _pointsColumn.getRect(row),
    format: format,
  );
  //Signature
  var signature = PdfBitmap(reward.signature.bytes);
  graphics.drawImage(
    signature,
    _getEqualRatioRect(
      _signatureColumn.getRect(row),
      signature.height / signature.width,
    ),
  );
  //Phone
  graphics.drawString(
    reward.phone,
    font,
    bounds: _phoneColumn.getRect(row),
    format: format,
  );
}

/// Given a max rect, width and height ratio, it finds a rect
/// aligned to the center of the given rect,
/// that has the same width/height ratio.
Rect _getEqualRatioRect(Rect constrain, double ratio) {
  var rectRatio = constrain.height / constrain.width;
  double left;
  double top;
  double width;
  double height;
  if (ratio < rectRatio) {
    width = constrain.width;
    height = width * ratio;
    left = 0;
    top = (constrain.height - height) / 2;
  } else {
    height = constrain.height;
    width = pow(ratio, -1) * height;
    left = (constrain.width - width) / 2;
    top = 0;
  }
  return Rect.fromLTWH(
    constrain.left + left,
    constrain.top + top,
    width,
    height,
  );
}

Future<void> writeAndOpenPDF(List<int> bytes, String fileName) async {
  //Only works on android!
  final path = (await getExternalStorageDirectory())!.path;
  final file = File('$path/$fileName');
  await file.writeAsBytes(bytes, flush: true);
  OpenFile.open(file.path);
}
