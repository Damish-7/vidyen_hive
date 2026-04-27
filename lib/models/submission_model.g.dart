// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submission_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SubmissionModelAdapter extends TypeAdapter<SubmissionModel> {
  @override
  final int typeId = 1;

  @override
  SubmissionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SubmissionModel(
      id: fields[0] as String,
      userId: fields[1] as String,
      userName: fields[2] as String,
      type: fields[3] as String,
      title: fields[4] as String,
      description: fields[5] as String,
      filePath: fields[6] as String?,
      status: fields[7] as String,
      adminRemark: fields[8] as String?,
      submittedAt: fields[9] as DateTime,
      coAuthors: fields[10] as String?,
      keywords: fields[11] as String?,
      category: fields[12] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SubmissionModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.userName)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.title)
      ..writeByte(5)
      ..write(obj.description)
      ..writeByte(6)
      ..write(obj.filePath)
      ..writeByte(7)
      ..write(obj.status)
      ..writeByte(8)
      ..write(obj.adminRemark)
      ..writeByte(9)
      ..write(obj.submittedAt)
      ..writeByte(10)
      ..write(obj.coAuthors)
      ..writeByte(11)
      ..write(obj.keywords)
      ..writeByte(12)
      ..write(obj.category);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubmissionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
