import 'package:hive_flutter/adapters.dart';

part 'job_model.g.dart';

@HiveType(typeId: 0)
enum Status {
  @HiveField(0)
  applied,

  @HiveField(1)
  interviewing,

  @HiveField(2)
  rejected,

  @HiveField(3)
  offered,
}

@HiveType(typeId: 1)
class Job extends HiveObject {
  @HiveField(0)
  String company;

  @HiveField(1)
  String role;

  @HiveField(2)
  String location;

  @HiveField(3)
  DateTime appliedDate;

  @HiveField(4)
  String portal;

  @HiveField(5)
  Status status;

  @HiveField(6)
  String? jobUrl;

  @HiveField(7)
  List<String> jobDescriptionImages;

  @HiveField(8)
  String? notes;

  Job({
    required this.company,
    required this.role,
    required this.location,
    required this.appliedDate,
    required this.portal,
    required this.status,
    this.jobDescriptionImages = const [],
    this.jobUrl,
    this.notes,
  });
}
