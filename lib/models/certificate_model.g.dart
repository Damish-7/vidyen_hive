// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'certificate_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CertificateModelAdapter extends TypeAdapter<CertificateModel> {
  @override
  final int typeId = 2;

  @override
  CertificateModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CertificateModel(
      id: fields[0] as String,
      userId: fields[1] as String,
      userName: fields[2] as String,
      title: fields[3] as String,
      type: fields[4] as String,
      issuedAt: fields[5] as DateTime,
      issuedBy: fields[6] as String,
      filePath: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CertificateModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.userName)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(5)
      ..write(obj.issuedAt)
      ..writeByte(6)
      ..write(obj.issuedBy)
      ..writeByte(7)
      ..write(obj.filePath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CertificateModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
