import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

/// A number tracked at a point in time.
@JsonSerializable()
class EntryModel {
  int value;  
  @JsonKey(fromJson: _timestampToDateTime, toJson: _dateTimeToTimestamp)
  DateTime time;
  @JsonKey(includeFromJson: false)
  String? id;

  EntryModel(this.value, this.time);

  factory EntryModel.fromJson(Map<String, dynamic> json) => _$EntryFromJson(json);

  Map<String, dynamic> toJson() => _$EntryToJson(this);

  static DateTime _timestampToDateTime(Timestamp timestamp) {
    return DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);
  }

  static Timestamp _dateTimeToTimestamp(DateTime dateTime) {
    return Timestamp.fromMillisecondsSinceEpoch(dateTime.millisecondsSinceEpoch);
  }

  @override
  operator ==(Object other) => other is EntryModel && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return '<Entry id=$id>';
  }
}

EntryModel _$EntryFromJson(Map<String, dynamic> json) {
  return EntryModel(
    json['value'] as int,
    EntryModel._timestampToDateTime(json['time'] as Timestamp),
  );
}

Map<String, dynamic> _$EntryToJson(EntryModel instance) => <String, dynamic>{
      'value': instance.value,
      'time': EntryModel._dateTimeToTimestamp(instance.time),
    };
