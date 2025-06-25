// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WeeklyProgressAdapter extends TypeAdapter<WeeklyProgress> {
  @override
  final int typeId = 8;

  @override
  WeeklyProgress read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WeeklyProgress(
      dailyQuestsCompleted: fields[0] as int,
      mainQuestsCompleted: fields[1] as int,
      currentStreakDays: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, WeeklyProgress obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.dailyQuestsCompleted)
      ..writeByte(1)
      ..write(obj.mainQuestsCompleted)
      ..writeByte(2)
      ..write(obj.currentStreakDays);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeeklyProgressAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserProfileAdapter extends TypeAdapter<UserProfile> {
  @override
  final int typeId = 9;

  @override
  UserProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProfile(
      id: fields[0] as String?,
      username: fields[1] as String,
      currentXP: fields[2] as int,
      level: fields[3] as int,
      rank: fields[4] as String,
      totalQuestsCompleted: fields[5] as int,
      achievements: (fields[6] as List).cast<String>(),
      createdAt: fields[7] as DateTime?,
      lastLogin: fields[8] as DateTime?,
      weeklyProgress: fields[9] as WeeklyProgress?,
    );
  }

  @override
  void write(BinaryWriter writer, UserProfile obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.username)
      ..writeByte(2)
      ..write(obj.currentXP)
      ..writeByte(3)
      ..write(obj.level)
      ..writeByte(4)
      ..write(obj.rank)
      ..writeByte(5)
      ..write(obj.totalQuestsCompleted)
      ..writeByte(6)
      ..write(obj.achievements)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.lastLogin)
      ..writeByte(9)
      ..write(obj.weeklyProgress);
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
