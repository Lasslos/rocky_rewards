import 'dart:async';

T _getFromJSON<T>(Map<String, dynamic> json, String path, T fallback) {
  Object? result = json[path];
  if (result == null || result is! T) {
    return fallback;
  }
  return result as T;
}

class RockyReward extends Comparable<RockyReward> {
  RockyReward(this.date, this.rewardType, this.groupName, this.description,
      this.attendance, this.hoursOrNumberOfGames, this.points, this.phone);

  factory RockyReward.fromJSON(Map<String, dynamic> json) {
    var date = DateTime.tryParse(
            _getFromJSON<String>(json, 'date', DateTime.now().toString())) ??
        DateTime.now();
    var rewardType =
        RewardType.values[_getFromJSON<int>(json, 'rewardType', 0)];
    var groupName = _getFromJSON<String>(json, 'groupName', '');
    var description = _getFromJSON(json, 'description', '');
    var attendance =
        AttendanceType.values[_getFromJSON<int>(json, 'attendance', 0)];
    var hoursOrNumbersOfGames = _getFromJSON<int>(json, 'hours', 0);
    var points = _getFromJSON<int>(json, 'points', 1);
    var phone = _getFromJSON<String>(json, 'phone', '012-345-6789');
    return RockyReward(date, rewardType, groupName, description, attendance,
        hoursOrNumbersOfGames, points, phone);
  }

  final DateTime date;
  final RewardType rewardType;
  final String groupName;
  final String description;
  final AttendanceType attendance;
  final int hoursOrNumberOfGames;
  final int points;
  final String phone;

  Future<Map<String, Object>> toJSON() async {
    Map<String, Object> result = {};
    result['date'] = date.toString();
    result['rewardType'] = rewardType.index;
    result['groupName'] = groupName;
    result['description'] = description;
    result['attendance'] = attendance.index;
    result['hours'] = hoursOrNumberOfGames;
    result['points'] = points;
    result['phone'] = phone;

    return result;
  }

  @override
  int compareTo(RockyReward other) {
    return date.compareTo(other.date);
  }

  @override
  bool operator ==(Object other) {
    if (other is! RockyReward) {
      return false;
    }
    return date == other.date &&
        rewardType == other.rewardType &&
        groupName == other.groupName &&
        description == other.description &&
        attendance == other.attendance &&
        hoursOrNumberOfGames == other.hoursOrNumberOfGames &&
        points == other.points &&
        phone == other.phone;
  }

  RockyReward copyWith(
          DateTime? date,
          RewardType? rewardType,
          String? groupName,
          String? description,
          AttendanceType? attendance,
          int? hoursOrNumberOfGames,
          int? points,
          String? phone) =>
      RockyReward(
        date ?? this.date,
        rewardType ?? this.rewardType,
        groupName ?? this.groupName,
        description ?? this.description,
        attendance ?? this.attendance,
        hoursOrNumberOfGames ?? this.hoursOrNumberOfGames,
        points ?? this.points,
        phone ?? this.phone,
      );

  @override
  int get hashCode => Object.hashAll([
        date,
        rewardType,
        groupName,
        description,
        attendance,
        hoursOrNumberOfGames,
        points,
        phone
      ]);
}

enum RewardType { volunteer, school, community }
enum AttendanceType { participant, spectator }
