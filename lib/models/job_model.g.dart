// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class JobAdapter extends TypeAdapter<Job> {
  @override
  final int typeId = 1;

  @override
  Job read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Job(
      company: fields[0] as String,
      role: fields[1] as String,
      location: fields[2] as String,
      appliedDate: fields[3] as DateTime,
      portal: fields[4] as String,
      status: fields[5] as Status,
      jobDescriptionImages: (fields[7] as List).cast<String>(),
      jobUrl: fields[6] as String?,
      notes: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Job obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.company)
      ..writeByte(1)
      ..write(obj.role)
      ..writeByte(2)
      ..write(obj.location)
      ..writeByte(3)
      ..write(obj.appliedDate)
      ..writeByte(4)
      ..write(obj.portal)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.jobUrl)
      ..writeByte(7)
      ..write(obj.jobDescriptionImages)
      ..writeByte(8)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JobAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class StatusAdapter extends TypeAdapter<Status> {
  @override
  final int typeId = 0;

  @override
  Status read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Status.applied;
      case 1:
        return Status.interviewing;
      case 2:
        return Status.rejected;
      case 3:
        return Status.offered;
      default:
        return Status.applied;
    }
  }

  @override
  void write(BinaryWriter writer, Status obj) {
    switch (obj) {
      case Status.applied:
        writer.writeByte(0);
        break;
      case Status.interviewing:
        writer.writeByte(1);
        break;
      case Status.rejected:
        writer.writeByte(2);
        break;
      case Status.offered:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
