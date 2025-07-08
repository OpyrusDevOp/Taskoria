// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserProfileAdapter extends TypeAdapter<UserProfile> {
  @override
  final int typeId = 4;

  @override
  UserProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProfile(
      id: fields[0] as String,
      name: fields[1] as String,
      totalXP: fields[2] as int,
      currentLevel: fields[3] as int,
      currentRank: fields[4] as UserRank,
      createdAt: fields[5] as DateTime,
      totalQuestsCompleted: fields[6] as int,
      totalStreaksBroken: fields[7] as int,
    );
  }

  @override
  void write(BinaryWriter writer, UserProfile obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.totalXP)
      ..writeByte(3)
      ..write(obj.currentLevel)
      ..writeByte(4)
      ..write(obj.currentRank)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.totalQuestsCompleted)
      ..writeByte(7)
      ..write(obj.totalStreaksBroken);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
