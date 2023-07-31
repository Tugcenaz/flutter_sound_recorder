class RecordModel {
  String recordName;

  int recordDate;

  Duration recordDuration;

  RecordModel(
      {required this.recordDuration,
      required this.recordDate,
      required this.recordName});

  Map<String, dynamic> toMap() {
    return {
      'recordName': recordName,
      'recordDate': recordDate,
      'recordDuration': recordDuration,
    };
  }

  RecordModel.fromMap(Map<String, dynamic> map)
      : recordName = map['recordName'],
        recordDate = map['recordDate'],
        recordDuration = map['recordDuration'];
}
