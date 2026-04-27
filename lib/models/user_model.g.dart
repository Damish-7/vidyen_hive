// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 0;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      id: fields[0] as String,
      name: fields[1] as String,
      email: fields[2] as String,
      passwordHash: fields[3] as String,
      regCode: fields[4] as String,
      delegateType: fields[5] as String,
      designation: fields[6] as String,
      institution: fields[7] as String,
      city: fields[8] as String,
      country: fields[9] as String,
      phone: fields[10] as String,
      status: fields[11] as String,
      isAdmin: fields[12] as bool,
      createdAt: fields[13] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.passwordHash)
      ..writeByte(4)
      ..write(obj.regCode)
      ..writeByte(5)
      ..write(obj.delegateType)
      ..writeByte(6)
      ..write(obj.designation)
      ..writeByte(7)
      ..write(obj.institution)
      ..writeByte(8)
      ..write(obj.city)
      ..writeByte(9)
      ..write(obj.country)
      ..writeByte(10)
      ..write(obj.phone)
      ..writeByte(11)
      ..write(obj.status)
      ..writeByte(12)
      ..write(obj.isAdmin)
      ..writeByte(13)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
